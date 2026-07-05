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
**Ready to write now** (decisions locked, see [[../05-domain-core/_MOC|Domain-core MOC]]):
`0001--regional-rarity-model` (surprisal + hierarchical shrinkage over a
presence port), `0002--ais-presence-not-user-sightings` (ground-truth
denominator; bootstrap then swap), `0003--catch-unit-vessel-region-pair`,
`0004--social-private-friends-only`, `0005--location-coarsened-to-region`.
**Still pending** the usual stack ADRs (`tech-stack`, `fanout-on-write`) and the
unresolved product decisions (proof-of-sighting, monetization, seed region,
MVP boundary).*

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
