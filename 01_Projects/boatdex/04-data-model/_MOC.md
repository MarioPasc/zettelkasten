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

## Planned notes

- [[relational-schema|Relational schema]] — tables `app_user`, `vessel` (MMSI PK, denormalised `global_count`), `sighting` (event, optional PostGIS point), `friendship` (canonical undirected edge, `CHECK user_low < user_high`), `notification` (materialised fan-out), `push_token`; indexes and cascade rules
- [[domain-entities|Domain entities]] — frozen `@dataclass` `Vessel`, `Sighting`, `CatalogueEntry`, `Friendship`; `FriendshipStatus` enum; no I/O, no ORM
- [[catalogue-derivation|Catalogue derivation]] — `catalogue_entry` view: distinct MMSI per user with `sighting_count`, `first_seen`, `last_seen`; rarity joined at read time

## Open questions (Q&A agenda)

- Is MMSI a safe primary key for `vessel` given MMSI reassignment/reuse in the wild? Do we need a surrogate id?
- Store `rarity_bits` denormalised or always recompute from `global_count`?
- Photo storage: URL column only, or a dedicated `sighting_photo` table for multiples?
- Regional-rarity (open decision Q3) may add a `region`/geo-bucket dimension — schema impact to hold until Q3 resolves.

## Sources

- `BoatDex_SPECIFICATION.md` §4.1 (relational schema DDL), §4.2 (domain entities).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/data-modeling
