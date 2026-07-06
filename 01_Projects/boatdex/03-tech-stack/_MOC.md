---
title: "MOC — BoatDex · Tech stack"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/backend]
---

# MOC — BoatDex · Tech stack

*The technology choices and their rationale. Project context: BoatDex is a
non-research build (see [[../_README|README]]) partly chosen to learn a
modern Python-async + Expo stack. Each choice here should graduate into a
MADR-format ADR under [[../decisions/_MOC|decisions/]]; this folder holds the
rationale and the alternatives considered.*

## Scope

Backend framework and persistence, authentication, async/realtime/push,
mobile client, the AIS data source, and the enforced tooling. One note per
coherent group of choices, each ending in a proposed ADR.

## Planned notes

- [[backend-framework|Backend framework]] — FastAPI (async, Pydantic, OpenAPI) · SQLAlchemy 2.0 typed `Mapped[...]` · PostgreSQL · Alembic migrations · **h3-py** (Apache-2.0; runtime `lat/lon → region`) · **PostGIS + shapely offline-only** (region rasterisation, see [[../05-domain-core/region-model|region model]])
- [[auth-and-security|Auth & security]] — fastapi-users, Argon2id password hashing, JWT access/refresh; "auth is the wrong place to be original"
- [[async-realtime-push|Async, realtime & push]] — arq (Redis) task queue (Celery fallback) · WebSocket/SSE live feed · Expo Push / FCM / APNs
- [[client-stack|Client stack]] — Expo / React Native; cross-platform; **camera capture is a primary fast-follow** so the client needs device **GPS** (`expo-location`), **compass/orientation** (`expo-sensors` magnetometer), and a **camera + 2D AR overlay** (label vessels by screen-projected bearing). No depth-AR / LiDAR — distance is AIS-derived
- [[data-sources-ais|AIS data source]] — **two uses of the same feed**: (1) **live bounding-box** query for camera identify (low-latency, small area); (2) **historical presence stats** for R1 rarity + heatmap. aisstream.io free bounding-box WS → Datalastic / VesselAPI if outgrown; coverage limits (non-AIS boats) matter more for live identify
- [[tooling-and-ci|Tooling & CI]] ✅ *written* — **uv** (Python 3.12) · ruff · mypy --strict · pytest + pytest-cov (100% branch on domain) · hypothesis · pre-commit · import-linter · **GitHub Actions** CI; private monorepo layout

## Open questions (Q&A agenda)

- Hosting target (self-host VPS, Fly.io, Render, a cloud provider) and its cost envelope.
- Managed Postgres vs. self-managed; is PostGIS available on the chosen host?
- AIS licensing: is aisstream.io's free tier's usage acceptable for a shipped app? Terms review needed.
- Object storage for sighting photos (S3-compatible?) — deferred until proof-of-sighting decision (Q4).

## Sources

- `BoatDex_SPECIFICATION.md` §3 (technology stack table + enforced tooling).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/backend
