---
title: "MOC — BoatDex · Code notes"
type: moc
created: 2026-07-06
updated: 2026-07-06
tags: [type/moc, project/boatdex]
---

# MOC — BoatDex · Code notes

*Durable per-module / per-subsystem documentation of the **actual code**: how a
module works, its public surface, deviations from the spec and why, and
gotchas. One note per module (`<module>.md`, e.g. `rarity.md`, `region-resolver.md`).
Each **links back** to the spec note it realises (e.g. `rarity.md` →
[[../../05-domain-core/rarity-surprisal|spec: rarity]]).*

## Children

<!-- Auto-managed by the impl-doc skill. One line per module note:
     - [[<module>|<Module>]] — one-line summary + spec backlink -->

- [[scaffold-m0|M0 scaffold]] — uv, hexagonal layout, import-linter contracts, CI gate, pre-commit → [[../../03-tech-stack/tooling-and-ci|spec: tooling & CI]]
- [[exceptions|Exceptions]] — `BoatDexError` root, `ValidationError` family, business-rule errors → [[../../05-domain-core/domain-exceptions|spec: domain exceptions]]
- [[value-objects|Value objects]] — MMSI, IMO, ShipType, Coordinate, RegionId, Distance → [[../../05-domain-core/value-objects|spec: value objects]]
- [[entities|Entities]] — Region, Vessel, Sighting, CatalogueEntry, Friendship → [[../../04-data-model/domain-entities|spec: domain entities]]
- [[clock|Clock]] — `Clock` Protocol; domain never calls `datetime.now()` → [[../../10-quality-and-ops/coding-standards|spec: coding standards §4]]
- [[presence|Presence port]] — `RegionalPresence` Protocol (7 methods, value-object typed) → [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
- [[rarity|Rarity]] — Lidstone + Jelinek-Mercer surprisal; `rarity()` = −log₂(p̃) → [[../../05-domain-core/rarity-surprisal|spec: rarity]]
- [[similarity|Similarity]] — Jaccard over (vessel, region) sets; J(∅,∅)=1 → [[../../05-domain-core/catalogue-similarity|spec: similarity]]
- [[score|Score]] — `collection_score()` via `math.fsum`; order-invariant exact sum → [[../../05-domain-core/collection-score|spec: collection score]]
- [[geodesy|Geodesy]] — haversine, initial_bearing, angular_diff, identify_target → [[../../05-domain-core/geodesy-identify|spec: geodesy & identify]]
- [[social|Social]] — `canonical_pair`, friendship FSM, single raise site → [[../../05-domain-core/friendship-fsm|spec: friendship FSM]]
- [[events|Events]] — `SightingCreated` + `as_payload()` JSON-friendly dict → [[../../06-features/sightings-and-catalogue|spec: sightings & catalogue]]

## Parent

- [[../_MOC|Implementation MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
