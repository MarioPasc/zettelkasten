---
title: "Implementation progress board"
type: moc
created: 2026-07-06
updated: 2026-07-06
branch: feature/m0-m1-domain-core
tags: [type/moc, project/boatdex, status/active]
---

# Implementation progress board

*The single source of truth for **where the build is**. The first note the
coding agent reads when resuming work. Updated at the end of every build
session via the `impl-doc` skill. Mirrors the spec's milestone plan
([[../11-roadmap/implementation-sequencing|implementation sequencing]]) but
tracks **code reality**, not design intent.*

## Milestone status

| Milestone | Scope | Status | Coverage | Notes |
|-----------|-------|--------|----------|-------|
| M0 | Repo, uv, hexagonal skeleton, tooling, CI | ✅ done | — | [[build-sessions/2026-07-06T1448--m0-m1-domain-core\|session log]] |
| M1 | Pure domain core (value objects, rarity, FSM, geodesy, presence port) | ✅ done | 100% branch (353 stmts / 66 branches, 142 tests) | branch `feature/m0-m1-domain-core`; [[build-sessions/2026-07-06T1448--m0-m1-domain-core\|session log]] |
| M2 | Persistence (SQLAlchemy, Alembic, `SightingBackedPresence`, `region_cell`) | ⬜ not started | — | |
| M3 | Auth (fastapi-users, JWT) | ⬜ not started | — | |
| M4 | Sightings + catalogue + rarity wiring | ⬜ not started | — | |
| M5+ | Social · notifications · realtime · camera · AIS stats | ⬜ not started | — | see roadmap |

Legend: ⬜ not started · 🟡 in progress · ✅ done (acceptance criteria pass in CI).

## How to update this board

At each build-session close-out (`impl-doc` skill): flip the milestone state,
record the measured domain branch-coverage %, and link the
[[build-sessions/_MOC|session log]] and any [[code-decisions/_MOC|code
decision]] taken.

## Related

- [[_MOC|Implementation MOC]]
- [[../11-roadmap/implementation-sequencing|Spec: implementation sequencing]]
- [[../11-roadmap/_MOC|Spec: roadmap]]

#type/moc #project/boatdex #status/active
