---
title: "MOC — BoatDex · Data model"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/data-modeling]
---

# MOC — BoatDex · Data model

*How BoatDex represents its data, at two levels: the relational schema that
persists to Postgres, and the pure domain entities the core logic operates
on. Project context: the atomic record is a **sighting** (user saw vessel V
at time T); a user's catalogue is derived, not stored (see
[[../_README|README]]).*

## Scope

The DDL sketch (tables, keys, indexes, constraints), the frozen domain
dataclasses that mirror it without ORM ties, and the derived catalogue view.
The *behaviour* over this data lives in
[[../05-domain-core/_MOC|Domain core]]; how it is queried lives in
[[../07-api/_MOC|API]].

## Resolved model (2026-07-05 Q&A)

Rarity is **regional**, so the schema gains a hierarchical **`region`** tree;
every `sighting` carries a **required `region_id`** (resolved at write time by
point-in-polygon, precise lat/lon dropped — coarsen-to-cell). The catalogue's
atomic unit is a distinct **`(user, mmsi, region)`** entry, not distinct MMSI.
Presence *counts* move behind the [[../05-domain-core/regional-presence-port|presence port]],
so the schema stores raw `sighting` rows; regional/global counts are computed
(or cached) by the presence adapter, not hand-denormalised on `vessel`.

## Planned notes

- [[relational-schema|Relational schema]] ✅ *written* — `app_user`, `vessel` (**surrogate UUID PK; MMSI unique-nullable**; `source` manual/ais), `region` (`region_id` TEXT PK, `parent_id` self-FK, `level`, **PostGIS `geom`** for point-in-polygon), `sighting` (**`region_id` NOT NULL**, **no stored lat/lon**, optional `photo_url` + `verified`/`verification`/`observer_distance_m`), `friendship` (canonical edge, `CHECK user_low < user_high`), `notification`, `push_token`; presence counts **computed on demand**
- [[domain-entities|Domain entities]] ✅ *written* — frozen `@dataclass` `Vessel`, `Region`, `Sighting`, `CatalogueEntry` (keyed `(vessel_id, region_id)`), `Friendship`; `FriendshipStatus` enum; no I/O, no ORM
- [[catalogue-derivation|Catalogue derivation]] ✅ *written* — `catalogue_entry` view: distinct **`(user, vessel_id, region_id)`** with `sighting_count`, `first_seen`, `last_seen`; regional rarity joined at read time via the presence port

## Decisions (resolved 2026-07-06 Q&A → see [[relational-schema|Relational schema]])

- ✅ **Vessel key** → surrogate `vessel_id` UUID; MMSI unique-nullable. Catalogue keys `(vessel_id, region_id)`.
- ✅ **Presence counts** → computed on demand from `sighting`; no `presence_stat` table at MVP (port-hidden cache later).
- ✅ **Region geo** → polygons stored in **PostGIS** (now a required extension); `lat/lon → region_id` by point-in-polygon at write time; precise coords not stored.
- ✅ **Proof** → photo-optional + opportunistic proximity check; `photo_url` nullable + `verified`/`verification`/`observer_distance_m` on `sighting`.

## Open questions (remaining)

- Photo storage: single `photo_url` column vs a `sighting_photo` table for multiples (deferred until it bites).
- Vessel-position source for the proximity check at manual MVP (no live AIS yet) → resolve in [[../06-features/sightings-and-catalogue|sightings feature]].
- `region.level` semantics / max depth — fixed by the chosen maritime dataset (IHO / EEZ nesting).
- GDPR erasure: hard `ON DELETE CASCADE` vs soft-delete for `app_user`.

## Sources

- `BoatDex_SPECIFICATION.md` §4.1 (relational schema DDL), §4.2 (domain entities).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/data-modeling
