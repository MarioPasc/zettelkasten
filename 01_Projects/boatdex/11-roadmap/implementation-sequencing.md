---
title: "Implementation sequencing — reuse-driven build order"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["build order", "implementation order", "reuse spine"]
sources: []
---

# Implementation sequencing — reuse-driven build order

*The order to build BoatDex so each block reuses the code paths of the ones
before it: a pure core first, then one capture funnel that every later
feature (camera, social, notifications) plugs into.*

The [[../01-product/building-blocks|building blocks]] note says *what matters
first* (primary vs secondary); this note says *in what order to write the
code* so nothing is built twice.

## The two reuse seams (why this order works)

1. **The [[../05-domain-core/regional-presence-port|`RegionalPresence` port]].**
   Rarity is one pure function over counts. Swap the count provider and
   **R1 upgrades from a sighting-backed stand-in to AIS ground truth with zero
   domain rework**. So we can ship rarity on day one and make it "real" later
   without touching the maths or its tests.
2. **The single `SightingService.create()` funnel.** Manual and camera capture
   are two *front-ends onto one path*: `resolve region → validate → compute R1
   → persist → emit SightingCreated`. Because
   [[../05-domain-core/geodesy-identify|geodesy/identify]] lives in the pure
   core, the camera fast-follow is *almost free* — it reuses the funnel and adds
   only a live-AIS adapter and the AR UI.

## Functional decomposition → build phases

Each phase reuses the previous. "Establishes" = the code path later phases
call.

| Phase | Milestone | Builds | Reuses | Establishes (reused by) |
|---|---|---|---|---|
| P0 | M0 | Repo, hexagonal package, tooling, CI | — | the layout + CI gate everything imports |
| P1 | M1 | **Pure domain core**: entities, exceptions, presence **port**, rarity (R1/R2), score, Jaccard, geodesy/identify, friendship FSM | P0 | the logic every feature calls; `DictPresence` stub for tests |
| P2 | M2 | SQLAlchemy models (incl. **region tree**), Alembic, repositories, **`SightingBackedPresence`** adapter | P1 (port) | DB + the adapter that powers R2 **and stands in for R1** |
| P3 | M3 | Auth (fastapi-users, JWT) | P0, P2 | identity every endpoint needs |
| P4 | M4 | **`SightingService.create()`** (lat/lon→region_id→validate→R1→persist→emit); `GET /me/catalogue` (R1 score + R2 badge) | P1+P2+P3 | the **one capture funnel** + region-resolution path |
| P5 | M8 (slice) | **Minimal Expo client**: register/login, manual search-and-log, view catalogue + score | P3, P4 | **→ MVP ships** (manual capture → collectible → R1) |
| P6 | M9 | **Camera identify** (fast-follow): GPS+compass+camera AR; live-AIS bbox adapter; `identify_target`+haversine → confirm → same `create()` | P1 geodesy + P4 funnel + P3 | adds only live-AIS adapter + camera UI |
| P7 | — | Per-vessel **heatmap** + R2 badge surfacing | P2 adapters, sighting data | — |
| P8 | MA | **AIS region-statistics**: real `AISPresence` adapter (subscribe+backfill→aggregate) | the port (P1) | swaps R1 provider → **R1 becomes ground truth, zero domain change** |
| P9 | M5 | **Social**: friend FSM + comparison (Jaccard) + authz rule | P1 FSM/Jaccard + P4 + P3 | the accepted-friend graph |
| P10 | M6/M7 | **Notifications** fan-out + **realtime**: `SightingCreated`→friends→arq→push+WS | P4 event + P9 graph | — |

MVP boundary sits after **P5**. Camera (P6) and heatmap/R2 (P7) are the
fast-follow; social (P9) and notifications (P10) are secondary, last.

## Next specification files (the immediate queue)

The domain core (P1) is spec-complete with acceptance tests. The keystone
gap is the **data model** (it gates P2 and P4). Fill in this order:

1. **`04-data-model/relational-schema.md`** — *keystone*. DDL for `app_user`,
   `vessel`, `region` (tree), `sighting` (region_id, no stored lat/lon),
   `friendship`, `notification`, `push_token` (+ `presence_stat`?). ← **this Q&A round**.
2. **`04-data-model/domain-entities.md`** + **`catalogue-derivation.md`** — mirror the schema; `(user, vessel, region)` catalogue.
3. **`06-features/sightings-and-catalogue.md`** — the MVP core-loop feature (manual capture + catalogue), spec-driven template.
4. **`07-api/api-surface.md`** — the MVP subset: auth + `POST /sightings` + `GET /me/catalogue`.
5. **`08-client-ux/navigation-and-screens.md`** + **`key-flows.md`** — the minimal manual MVP client.

Deferred until their phase: `camera-identify` detail (P6), the AIS
region-statistics module (P8), social/notifications specs (P9/P10).

## Open decisions gating the keystone (this Q&A round)

Region model & geo resolution · proof-of-sighting · vessel primary key
(MMSI vs surrogate) · presence-count storage. Resolved answers land directly
in `relational-schema.md` and graduate to ADRs under [[../decisions/_MOC|decisions/]].

## Related

- [[../01-product/building-blocks|System building blocks]] — the primary/secondary priority this order realises
- [[../05-domain-core/regional-presence-port|Regional presence port]] — reuse seam #1
- [[../05-domain-core/geodesy-identify|Geodesy & identify]] — why the camera fast-follow is cheap
- [[../02-architecture/_MOC|Architecture]] — the layers these phases fill
- [[_MOC|Roadmap MOC]]

#type/concept #status/active #domain/backend #project/boatdex
