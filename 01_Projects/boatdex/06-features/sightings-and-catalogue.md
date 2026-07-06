---
title: "Feature — Sightings & catalogue (MVP core loop)"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/product, project/boatdex]
aliases: ["sightings feature", "manual capture", "catalogue feature"]
sources: []
---

# Feature — Sightings & catalogue (MVP core loop)

*The manual spot → identify → log → grow loop: search or introduce a vessel,
log a sighting coarsened to its region, and watch a rarity-scored catalogue of
`(vessel, region)` entries fill up. This is the MVP (phase P4–P5); no camera,
no social.*

Spec-driven note (spec §9 template). Implements building block 1 (manual
path) + block 2, wired to block 3's R1. See
[[../01-product/building-blocks|building blocks]].

## Goal

A signed-in user can log a vessel they have seen and see it appear in a
personal, rarity-scored catalogue — with no camera and no live-AIS.

## User stories

- As a spotter, I want to **search** for a vessel by name or MMSI so I can log a
  boat someone has already introduced.
- As a spotter, when the boat isn't in the registry, I want to **introduce it**
  (name required; MMSI/type/flag optional) so I can still log it.
- As a spotter, I want my **location turned into a region automatically** so I
  don't have to name where I am, and my precise position isn't stored.
- As a spotter, I want to **attach an optional photo and note** so a sighting is
  richer and softly verified.
- As a collector, I want a **catalogue of distinct `(vessel, region)` entries**
  with counts, first/last-seen, each entry's **R1 rarity** and **R2 badge**, and
  a **collection score**, so I can watch progress and see what was rare.

## Domain invariants (enforced in domain / application, not the router)

- `spotted_at` must not be in the future → `SightingValidationError`.
- A sighting's `region_id` must resolve to an existing `region`; a vessel must
  exist (found) or be created atomically with the sighting.
- A vessel must be identifiable: `mmsi is not None or name is not None`
  (mirrors the DDL CHECK).
- The catalogue unit is distinct `(user, vessel_id, region_id)`; re-sighting
  increments the count and never changes the collection score (set-additive
  [[../05-domain-core/collection-score|score]]).
- **Verification (MVP):** a photo sets `verification='photo'`, `verified=true`;
  otherwise `verified=false`. Proximity verification is **out of scope until
  P6** (needs live-AIS vessel positions).
- Precise `lat/lon` are inputs only: used for point-in-polygon (region) and,
  from P6, the proximity check — then discarded.

## Interfaces (MVP subset)

```
GET  /vessels?q=<name|mmsi>        search the registry
POST /vessels                      introduce a vessel {name, mmsi?, imo?, ship_type?, flag?}
POST /sightings                    {vessel_id | new_vessel, lat, lon, spotted_at, photo_url?, note?}
GET  /sightings?user_id=...        list a user's sightings (self; friends later)
GET  /me/catalogue                 entries + r1_bits + r2_bits + collection_score
```

`SightingService.create()` is the **one funnel** every capture path reuses
(manual now, camera at P6):
`resolve region (PostGIS ST_Covers) → validate invariants → set verification
from photo → compute R1 via presence port → persist sighting (no lat/lon) →
emit SightingCreated`.

Region resolution fallback: if no GPS fix is supplied, the client offers a
manual region pick from the tree (no silent default).

## Data changes

None beyond [[../04-data-model/relational-schema|the schema]] — `vessel`
(`source='manual'`, `created_by`), `sighting` (verification triplet), `region`.
No `presence_stat` (counts on demand). Catalogue is the derived
[[../04-data-model/catalogue-derivation|`catalogue_entry`]] view.

## Acceptance criteria (testable, one per line)

- Creating a sighting with a valid GPS fix resolves the deepest containing
  region via point-in-polygon and stores its `region_id` with no `lat/lon`.
- A future `spotted_at` is rejected with `SightingValidationError`.
- `POST /vessels` with neither `name` nor `mmsi` is rejected.
- Searching an existing vessel by name or MMSI returns it; a second identical
  MMSI introduction is prevented by the partial unique index.
- Logging a sighting with a photo yields `verified=true, verification='photo'`;
  without a photo, `verified=false`.
- `GET /me/catalogue` returns one entry per distinct `(vessel, region)` with
  correct `sighting_count`, `first_seen`, `last_seen`, `r1_bits`, and
  `collection_score = Σ r1_bits`.
- Re-logging the same `(vessel, region)` increments `sighting_count` and leaves
  `collection_score` unchanged.

## Out of scope (later phases)

- **Camera identify + proximity verification** → P6 (M9).
- **Per-vessel heatmap + full R2 surfacing** → P7.
- **Friends / catalogue comparison** → P9 (M5); `/sightings` reads restricted to
  self at MVP.
- **Notifications / realtime** → P10 (M6/M7).
- Multiple photos per sighting; AIS auto-registry of vessels (MA).

## Related

- [[_MOC|Features MOC]]
- [[../01-product/building-blocks|System building blocks]] — realises blocks 1 (manual) + 2, R1 of 3
- [[../04-data-model/relational-schema|Relational schema]] · [[../04-data-model/catalogue-derivation|Catalogue derivation]]
- [[../05-domain-core/regional-presence-port|Presence port]] · [[../05-domain-core/collection-score|Collection score]]
- [[../11-roadmap/implementation-sequencing|Implementation sequencing]] — P4–P5
- [[../07-api/_MOC|API]] — the endpoint contract

#type/concept #status/active #domain/product #project/boatdex
