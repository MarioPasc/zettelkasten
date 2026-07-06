---
title: "Tooling & CI (M0)"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["M0 toolchain", "CI", "repo setup"]
sources: []
---

# Tooling & CI (M0)

*The M0 scaffolding contract: a private monorepo managed with `uv`, Python
3.12, and a CI gate (ruff · mypy --strict · pytest+cov · import-linter) that
must be green on an otherwise-empty package before any milestone proceeds.*

Decisions here (2026-07-06 Q&A) close M0. They implement the rules in
[[../10-quality-and-ops/coding-standards|coding standards]].

## Repository & layout

- **Private GitHub monorepo** `boatdex/` (visibility private for now; **license
  deferred to release** — all deps are Apache/MIT-compatible, Marine Regions is
  CC-BY 4.0, so any later choice stays open).
- **Backend** at `src/boatdex/` (hexagonal: `domain/`, `application/`,
  `infrastructure/`, `api/`, `telemetry/`), per spec §10.
- **Client** at `client/` (Expo / React Native), scaffolded at M8.
- **Docs** at `docs/` (architecture · adr/ · specs/ · progress/PROGRESS.md ·
  api/), per spec §9.

## Environment & packaging

- **Python 3.12**.
- **`uv`** (Astral) for the venv, the lockfile (`uv.lock`), and task running —
  chosen for speed and single-tool simplicity; pairs with `ruff` (same vendor).
  Project metadata in `pyproject.toml`.

## Quality tools (enforced, not optional)

| Tool | Role |
|------|------|
| **ruff** | lint + format (replaces black/isort/flake8) |
| **mypy --strict** | full static typing on `src/boatdex/` |
| **pytest** + **pytest-cov** | tests; **100% branch coverage on `domain/`** is the gate |
| **hypothesis** | property tests for the pure domain (rarity, FSM, geodesy, presence contract) |
| **pre-commit** | runs ruff + mypy on staged files |
| **import-linter** | *layers* contract (`domain < application < infrastructure/api`) + *independence* contract (sibling adapters don't cross-import) |

## CI — GitHub Actions

One workflow on push / PR, Python 3.12, jobs run in parallel; **all green is the
merge gate**:

1. **lint** — `ruff check` + `ruff format --check`.
2. **type** — `mypy --strict`.
3. **test** — `pytest --cov` with the domain branch-coverage threshold.
4. **boundaries** — `lint-imports` (import-linter contracts).

## Dependencies by stage

- **M0/M1 (pure core):** stdlib only in `domain/`; dev tools above. No external
  data or service.
- **Runtime later:** FastAPI, SQLAlchemy, PostgreSQL, Alembic, fastapi-users,
  arq/Redis, **h3-py** (region resolution).
- **Offline data-prep:** PostGIS, shapely, H3 polyfill (build the `region_cell`
  lookup from Marine Regions).
- **Later milestones:** `pyais` (AIS decode), aisstream.io (feed), Expo Push/FCM/APNs.

## Related

- [[_MOC|Tech-stack MOC]]
- [[../10-quality-and-ops/coding-standards|Coding standards]] — the rules CI enforces
- [[../05-domain-core/region-model|Region model]] — the offline region build
- [[../11-roadmap/implementation-sequencing|Implementation sequencing]] — M0 = P0
- [[../09-legal-privacy/_MOC|Legal & privacy]] — dataset attribution obligations

#type/concept #status/active #domain/backend #project/boatdex
