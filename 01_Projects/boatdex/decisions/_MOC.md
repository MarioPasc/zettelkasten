---
title: "MOC — BoatDex · Decisions"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex]
---

# MOC — BoatDex · Decisions

*Architecture Decision Records for BoatDex, in MADR format (Context ·
Decision · Status · Consequences · Alternatives). One ADR per non-obvious
choice — the stack, fan-out-on-write, the rarity model, the auth provider,
and each product decision once resolved in the Q&A. Numbered `NNNN--slug.md`.
Project context in [[../_README|README]].*

## Children

<!-- Auto-managed by moc-update. One line per ADR:
     - [[NNNN--slug|NNNN — Title]] — one-line outcome -->

*No ADRs written yet, but the 2026-07-05 Q&A resolved enough to record several.
**Ready to write now** (decisions locked, see [[../05-domain-core/_MOC|Domain-core MOC]]
and [[../01-product/building-blocks|building blocks]]):
`0001--regional-rarity-model` (surprisal + hierarchical shrinkage over a
presence port), `0002--two-rarities-r1-scores-r2-badge` (one function, two
providers: AIS→R1 feeds the score, sightings→R2 is a shown badge),
`0003--catch-unit-vessel-region-pair`, `0004--social-private-friends-only`,
`0005--location-coarsened-to-region`,
`0006--camera-fast-follow-manual-first-mvp` (manual capture is the MVP, camera
is the primary fast-follow, not deferred),
`0007--distance-ais-derived` (distance/direction from GPS + compass + haversine,
no phone depth sensors).
**Still pending** the usual stack ADRs (`tech-stack`, `fanout-on-write`) and the
unresolved product decisions (proof-of-sighting, monetization, seed region,
MVP cut).*

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
