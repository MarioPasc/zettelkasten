---
title: "MOC — BoatDex · Architecture"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/backend]
---

# MOC — BoatDex · Architecture

*The high-level technical shape of BoatDex. Project context: a mobile
boat-spotting collection app (see [[../_README|README]]) whose load-bearing
logic — rarity math and the friendship state machine — must stay pure and
testable. This folder explains how the system is partitioned so that core
stays framework-free.*

## Scope

The chosen architectural style (hexagonal / ports-and-adapters), the system
component map, the import-boundary invariant, and the end-to-end path a
single spot travels. Technology *choices* live in
[[../03-tech-stack/_MOC|Tech stack]]; the *math* lives in
[[../05-domain-core/_MOC|Domain core]].

## Planned notes

- [[hexagonal-architecture|Hexagonal architecture]] — four layers (domain → application → infrastructure → api); why a pure I/O-free core; the `import-linter` contract that `domain/` imports nothing outward
- [[system-context|System context]] — the component map: client, api routers, application services, domain core, infrastructure adapters (DB, auth, queue, push, AIS)
- [[core-data-flow|Core data flow]] — the central spot path: `client → sightings router → SightingService.create() → domain validates + computes rarity → repository persists → emits SightingCreated → queue → NotificationService fans out → push + WS broadcast`

## Open questions (Q&A agenda)

- Is a monolith the right first shape, or split api/worker from day one?
- Is PostGIS worth the operational cost at MVP, or defer geo to a later milestone?
- Event bus: in-process domain events + arq, or an external broker later?

## Sources

- `BoatDex_SPECIFICATION.md` §2 (architecture + mermaid diagram), §10 (repository layout, import boundary).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/backend
