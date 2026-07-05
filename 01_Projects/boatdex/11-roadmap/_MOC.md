---
title: "MOC — BoatDex · Roadmap"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/product]
---

# MOC — BoatDex · Roadmap

*The delivery plan and the discipline around it. Project context: BoatDex is
spec-driven — each milestone ships a spec, code, tests meeting a coverage
gate, doc updates, and any new ADR, and is "done" only when acceptance
criteria pass in CI (see [[../_README|README]]).*

## Scope

The milestone sequence with acceptance criteria and dependency order, and the
continuous documentation-generation protocol that runs at each milestone
close-out. The scope of *what* each milestone builds lives in the relevant
area MOC; this folder tracks *order* and *done-ness*.

## Planned notes

- [[milestones|Milestones M0–M9 + MA]] — M0 scaffolding · M1 domain core (regional rarity + FSM, pure) · M2 persistence (+ `region` tree) · M3 auth · M4 sightings (point-in-polygon → region_id; `SightingBackedPresence` bootstrap adapter) · M5 social graph · M6 notifications · M7 realtime · M8 mobile client · M9 camera identify · **MA AIS region-statistics module** (ingestion → `AISPresence` adapter, swaps in behind the presence port); strict M0→M6 order, M7/M8 depend on M6, M9 and MA independent and off the critical path; per-milestone acceptance criteria
- [[documentation-protocol|Documentation protocol]] — the `docs/` layout (architecture, adr/ MADR, specs/, progress/PROGRESS.md, api/, CHANGELOG); the per-feature spec template; the milestone close-out checklist (flip PROGRESS, append CHANGELOG, write ADRs, regenerate OpenAPI, check docstring coverage)

## Open questions (Q&A agenda)

- MVP boundary (open decision Q9): which milestones are in v1? Likely M0–M5 + one social feature.
- Is M9 (camera) in the v1 roadmap at all, or explicitly post-launch (open decision Q2)?
- Solo build cadence — realistic target dates given this is a side project.
- Where does this roadmap's `docs/` live relative to the vault: mirrored, or the code repo is source-of-truth and the vault holds the design notes?

## Sources

- `BoatDex_SPECIFICATION.md` §8 (milestone plan), §9 (documentation-generation protocol).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/product
