---
title: "Code note — M0 repo scaffold"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — M0 repo scaffold

*The M0 scaffold establishes the uv-managed Python 3.12 project with a hexagonal package layout, import-linter boundary contracts, pre-commit hooks, and a four-job CI gate.*

## Goal

Provide a reproducible, CI-gated skeleton so that all subsequent M1+ modules can be added incrementally without touching toolchain configuration.

## Key implementation facts

- **Package manager**: `uv` with `[dependency-groups]` for dev dependencies (`ruff`, `mypy`, `pytest`, `pytest-cov`, `hypothesis`, `pylint-import-linter`, `pre-commit`). No legacy `requirements.txt`.
- **Python version**: `.python-version` = `3.12`; `pyproject.toml` `requires-python = ">=3.12"`.
- **Hexagonal layout** under `src/boatdex/`: five sub-packages — `domain/`, `application/`, `infrastructure/`, `api/`, `telemetry/`. Each has `__init__.py` + `py.typed` (PEP 561 marker). No cross-layer imports at scaffold time.
- **Import-linter contracts** (`setup.cfg` / `.importlinter`):
  - `layers` contract: `domain` must not import from `application`, `infrastructure`, `api`, or `telemetry`.
  - `independence` contract: `domain` sub-modules must not import each other (enforced for the pure-value sub-modules).
  Both contracts pass throughout M1 (verified in CI `boundaries` job).
- **Pre-commit hooks**: `ruff --fix`, `black`, `isort`, `mypy --strict` on staged files.
- **CI jobs** (GitHub Actions):
  1. `lint` — `ruff check src/ tests/`
  2. `type` — `mypy --strict src/`
  3. `test` — `pytest --cov=boatdex --cov-branch --cov-fail-under=100 tests/domain/`
  4. `boundaries` — `lint-imports`
- **Docs**: `docs/adr/0001-hexagonal-layout.md` (why hexagonal over layered); `CHANGELOG.md` stub.

## Tests / coverage

Scaffold itself has no domain logic to test. The CI `boundaries` job validates structural constraints. After M1, `test` job reports 353 stmts / 66 branches / 0 missed in `src/boatdex/domain/`.

#type/concept #project/boatdex #status/done

## Related

- [[../../03-tech-stack/tooling-and-ci|spec: tooling & CI]]
- [[../../10-quality-and-ops/coding-standards|spec: coding standards]]
