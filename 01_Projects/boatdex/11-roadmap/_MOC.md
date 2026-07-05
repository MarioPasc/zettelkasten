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

- [[milestones|Milestones M0–M9 + MA]] — M0 scaffolding · M1 domain core (**R1/R2 rarity, geodesy/identify, FSM** — all pure) · M2 persistence (+ `region` tree) · M3 auth · M4 sightings (**manual capture**; point-in-polygon → region_id; `SightingBackedPresence`→R2) · M8 mobile client (manual loop) · **M9 camera identify — primary fast-follow** (live-AIS bounding-box adapter + device sensors + AR viewfinder) · M5 social graph · M6 notifications · M7 realtime · **MA AIS region-statistics** (→ `AISPresence`→R1, swaps behind the presence port). Two independent AIS integrations: **live bounding-box** (camera, M9) and **historical stats** (rarity R1, MA)

> [!note] Reordered priority (2026-07-05)
> **MVP = M0–M4 + minimal M8** (manual capture → collectible → R1 rarity on a
> phone). **Fast-follow = M9 camera + heatmap + R2.** Social (M5), notifications
> (M6), realtime (M7) are secondary and come after. Camera is no longer "off the
> critical path" — it is the flagship, gated only on the client and live-AIS.
- [[documentation-protocol|Documentation protocol]] — the `docs/` layout (architecture, adr/ MADR, specs/, progress/PROGRESS.md, api/, CHANGELOG); the per-feature spec template; the milestone close-out checklist (flip PROGRESS, append CHANGELOG, write ADRs, regenerate OpenAPI, check docstring coverage)

## Open questions (Q&A agenda)

- MVP boundary (open decision Q9): working assumption is **M0–M4 + minimal M8** (manual capture loop on a phone), camera as the immediate fast-follow — confirm the exact cut.
- Ordering M8 (client) before M5–M7: shipping a usable manual app early means the mobile client precedes social/notifications/realtime. Confirm this front-loads the client vs. a backend-complete-first path.
- Solo build cadence — realistic target dates given this is a side project.
- Where does this roadmap's `docs/` live relative to the vault: mirrored, or the code repo is source-of-truth and the vault holds the design notes?

## Sources

- `BoatDex_SPECIFICATION.md` §8 (milestone plan), §9 (documentation-generation protocol).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/product
