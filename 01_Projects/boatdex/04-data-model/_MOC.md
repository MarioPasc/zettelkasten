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

- [[relational-schema|Relational schema]] — tables `app_user`, `vessel` (MMSI PK; public AIS identity fields only), `region` (`region_id` PK, `name`, `parent_id` self-FK, `level`; the backoff tree), `sighting` (event, **`region_id` NOT NULL** FK, **no stored lat/lon**), `friendship` (canonical undirected edge, `CHECK user_low < user_high`), `notification` (materialised fan-out), `push_token`; indexes and cascade rules
- [[domain-entities|Domain entities]] — frozen `@dataclass` `Vessel`, `Region`, `Sighting`, `CatalogueEntry` (keyed `(mmsi, region_id)`), `Friendship`; `FriendshipStatus` enum; no I/O, no ORM
- [[catalogue-derivation|Catalogue derivation]] — `catalogue_entry` view: distinct **`(user, mmsi, region_id)`** with `sighting_count`, `first_seen`, `last_seen`; regional rarity joined at read time via the presence port

## Open questions (remaining)

- Is MMSI a safe primary key for `vessel` given MMSI reassignment/reuse in the wild? Do we need a surrogate id? (Interacts with `(mmsi, region)` catalogue key.)
- Cache regional presence counts in a `presence_stat(mmsi, region_id, n)` table for read performance, or compute on demand from `sighting` / AIS each time?
- Photo storage: URL column only, or a dedicated `sighting_photo` table for multiples?
- Region tree: store the polygon geometry (for point-in-polygon) in Postgres/PostGIS, or resolve `lat/lon → region_id` in an application service and store only the id?

## Sources

- `BoatDex_SPECIFICATION.md` §4.1 (relational schema DDL), §4.2 (domain entities).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/data-modeling
