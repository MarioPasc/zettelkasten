---
title: "Relational schema"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/data-modeling, project/boatdex]
aliases: ["DDL", "database schema"]
sources: []
---

# Relational schema

*The PostgreSQL schema for BoatDex: users, a hierarchical region tree with
polygons, manually-introduced vessels (surrogate key), region-coarsened
sightings with optional photo + proximity verification, the canonical
friendship edge, and materialised notifications. Presence counts are computed
on demand, not stored.*

The behaviour over this data lives in [[../05-domain-core/_MOC|Domain core]];
the entities that mirror these tables are in [[domain-entities|Domain
entities]]; the derived catalogue is in [[catalogue-derivation|Catalogue
derivation]].

## Resolved decisions (2026-07-06 Q&A → future ADRs)

1. **Region model = open maritime dataset (hierarchical polygons).** Named
   seas / EEZ zones (Marine Regions / IHO) nested to a global root.
   `lat/lon → region_id` by **point-in-polygon at write time** ⇒ **PostGIS is
   now a required dependency** (previously "optional"). Precise coordinates are
   a **transient input**, not stored (privacy: coarsen-to-region).
2. **Proof = photo-optional + opportunistic proximity check.** A sighting
   counts with no photo. At write time, if the vessel's position is known, the
   server computes the observer→vessel great-circle distance
   ([[../05-domain-core/geodesy-identify|geodesy]]) and may mark the sighting
   `verified`. The photo is an identification aid and optional verification.
   ⇒ `photo_url` nullable; a small verification triplet on `sighting`.
3. **Vessel key = surrogate UUID, MMSI unique.** `vessel_id UUID` PK; `mmsi`
   unique but **nullable** — which the surrogate key makes safe and which
   manual entry needs (a boat may be introduced with no MMSI). Catalogue keys
   on `vessel_id`, not MMSI.
4. **Presence counts = computed on demand.** No `presence_stat` table in the
   MVP; the [[../05-domain-core/regional-presence-port|`SightingBackedPresence`]]
   adapter aggregates from `sighting`. A cache table is a later, port-hidden
   optimisation.

Also settled: **vessels are introduced manually for now** (`vessel.source`);
the AIS auto-registry arrives with the region-statistics module (MA).

## DDL sketch

```sql
CREATE EXTENSION IF NOT EXISTS postgis;   -- region polygons + point-in-polygon
CREATE EXTENSION IF NOT EXISTS citext;    -- case-insensitive email

-- Users (profile view; fastapi-users owns auth columns).
CREATE TABLE app_user (
    id            UUID PRIMARY KEY,
    email         CITEXT UNIQUE NOT NULL,
    display_name  TEXT NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    is_active     BOOLEAN NOT NULL DEFAULT true
);

-- Hierarchical named-region tree (loaded from the maritime dataset).
-- region_id is an opaque string (RegionId in the presence port), e.g. 'iho:28'.
CREATE TABLE region (
    region_id   TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    parent_id   TEXT REFERENCES region(region_id),      -- NULL only at global root
    level       INT  NOT NULL,                           -- 0 = root, grows downward
    geom        GEOGRAPHY(MULTIPOLYGON, 4326) NOT NULL,  -- for ST_Covers point-in-polygon
    source_ref  TEXT                                     -- dataset provenance
);
CREATE INDEX ix_region_geom   ON region USING GIST (geom);
CREATE INDEX ix_region_parent ON region (parent_id);

-- Vessels — surrogate PK; MMSI unique-but-nullable; manually introduced for now.
CREATE TABLE vessel (
    vessel_id   UUID PRIMARY KEY,
    mmsi        BIGINT,                                  -- 9-digit; NULL if unknown
    imo         BIGINT,                                  -- 7-digit, nullable
    name        TEXT,
    ship_type   TEXT,
    flag        TEXT,
    length_m    NUMERIC,
    beam_m      NUMERIC,
    source      TEXT NOT NULL DEFAULT 'manual',          -- manual | ais
    created_by  UUID REFERENCES app_user(id),            -- who introduced it (manual)
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (mmsi IS NOT NULL OR name IS NOT NULL)          -- must be identifiable
);
CREATE UNIQUE INDEX uq_vessel_mmsi ON vessel (mmsi) WHERE mmsi IS NOT NULL;

-- Sightings — the atomic event. Coarsened to region; precise lat/lon NOT stored.
CREATE TABLE sighting (
    id                 UUID PRIMARY KEY,
    user_id            UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    vessel_id          UUID NOT NULL REFERENCES vessel(vessel_id),
    region_id          TEXT NOT NULL REFERENCES region(region_id),  -- resolved at write
    spotted_at         TIMESTAMPTZ NOT NULL,
    photo_url          TEXT,                                        -- optional
    note               TEXT,
    verified           BOOLEAN NOT NULL DEFAULT false,
    verification       TEXT,                    -- NULL | 'proximity' | 'photo' | 'proximity_photo'
    observer_distance_m NUMERIC,                -- scalar from the proximity check (not a location)
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_sighting_user_time    ON sighting (user_id, spotted_at DESC);
CREATE INDEX ix_sighting_vessel_region ON sighting (vessel_id, region_id);  -- presence aggregation

-- Canonical undirected friendship edge: user_low < user_high (one row per pair).
CREATE TABLE friendship (
    user_low     UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    user_high    UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    requested_by UUID NOT NULL REFERENCES app_user(id),
    status       TEXT NOT NULL,                 -- pending|accepted|declined|blocked
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_low, user_high),
    CHECK (user_low < user_high)
);

-- Materialised notifications (fan-out on write; secondary milestone).
CREATE TABLE notification (
    id           UUID PRIMARY KEY,
    recipient_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    kind         TEXT NOT NULL,                 -- friend_spot|owner_novel|group_novel|request
    payload      JSONB NOT NULL,
    is_read      BOOLEAN NOT NULL DEFAULT false,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_notification_recipient ON notification (recipient_id, created_at DESC);

-- Push device registrations.
CREATE TABLE push_token (
    user_id   UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    token     TEXT NOT NULL,
    platform  TEXT NOT NULL,                    -- ios|android|expo
    PRIMARY KEY (user_id, token)
);
```

## Derived catalogue (view)

The catalogue is not stored; it is `sighting` grouped by the collectible unit
**`(user, vessel, region)`** (full treatment in [[catalogue-derivation|Catalogue
derivation]]):

```sql
CREATE VIEW catalogue_entry AS
SELECT user_id, vessel_id, region_id,
       COUNT(*)        AS sighting_count,
       MIN(spotted_at) AS first_seen,
       MAX(spotted_at) AS last_seen
FROM   sighting
GROUP  BY user_id, vessel_id, region_id;
```

Rarity (R1/R2) is joined at read time from the presence port, keyed
`(vessel_id, region_id)` — never denormalised onto a table.

## Write-time data flow for a manual sighting

`client sends {vessel_id | new-vessel fields, lat, lon, spotted_at, photo?}`
→ **resolve region**: `ST_Covers(region.geom, point(lon,lat))`, pick the
deepest matching node → `region_id` → **optional proximity check**: if a vessel
position is available, haversine(observer, vessel) → set `verified`,
`verification`, `observer_distance_m` → **persist** `sighting` (no lat/lon) →
emit `SightingCreated`. Precise coordinates never touch disk.

## Deferred tables (later milestones, not MVP)

```sql
-- Presence cache (only if on-demand aggregation gets slow; port-hidden).
-- CREATE TABLE presence_stat (vessel_id UUID, region_id TEXT, n BIGINT,
--                             PRIMARY KEY (vessel_id, region_id));
-- Multiple photos per sighting (if single photo_url proves limiting).
-- CREATE TABLE sighting_photo (id UUID PK, sighting_id UUID FK, url TEXT, ...);
```

## Open sub-questions (smaller, non-blocking)

- Where does the **vessel position** for the proximity check come from at
  manual MVP (no live AIS yet)? Options: skip proximity until the live-AIS
  adapter lands (P6) so MVP verification is photo-only; or a one-off lookup.
  → feeds [[../06-features/sightings-and-catalogue|the sightings feature spec]].
- `region.level` semantics and max depth — fixed by the chosen dataset's
  nesting (IHO → EEZ → sub-zone?). A data-artefact decision for MA.
- Retain `observer_distance_m` (a scalar) given the privacy stance, or drop it
  and keep only the `verified` boolean?
- Soft-delete vs hard `ON DELETE CASCADE` for GDPR erasure of `app_user`.

## Sources

- `BoatDex_SPECIFICATION.md` §4.1 (original DDL), evolved by the 2026-07-05 and
  2026-07-06 Q&A rounds (regional rarity, `(vessel, region)` unit, surrogate key).

## Related

- [[_MOC|Data-model MOC]]
- [[domain-entities|Domain entities]] — the dataclasses mirroring these tables
- [[catalogue-derivation|Catalogue derivation]] — the `(user, vessel, region)` view
- [[../05-domain-core/regional-presence-port|Regional presence port]] — reads `sighting` for counts
- [[../05-domain-core/geodesy-identify|Geodesy & identify]] — the proximity check
- [[../02-architecture/_MOC|Architecture]] — where point-in-polygon runs (PostGIS)

#type/concept #status/active #domain/data-modeling #project/boatdex
