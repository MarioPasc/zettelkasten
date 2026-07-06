---
title: "Coding standards"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["coding conventions", "code style", "patterns"]
sources: []
---

# Coding standards

*The how-to-build contract for M0/M1: the patterns, naming, and purity rules
that keep the domain core testable in isolation and the layer boundaries
honest. These are enforced in CI, not left to discipline.*

Grounds the abstract architecture in concrete rules. References: Percival &
Gregory, *Architecture Patterns with Python* (cosmicpython.com); Evans, *DDD*;
Cockburn, *Hexagonal Architecture*; Martin, *Clean Architecture*. Inherits the
Python conventions in the user's global `CLAUDE.md` (typing, NumPy docstrings,
dataclasses, per-module exceptions).

## 1 · Layering & the dependency rule

Four layers: `domain → application → infrastructure → api`. **`domain/`
imports nothing outward** (no framework, no ORM, no I/O). Enforced by an
**import-linter** contract:

- a *layers* contract (`domain` < `application` < `infrastructure`/`api`);
- an *independence* contract (sibling infrastructure adapters don't import each
  other).

CI fails on any violation. This is the invariant that keeps the rarity math honest.

## 2 · Value objects over primitives

Wrap identifiers and quantities (`MMSI`, `IMO`, `ShipType`, `Coordinate`,
`RegionId`, `Distance`) in validating frozen dataclasses — see
[[../05-domain-core/value-objects|value objects]]. No raw `int` MMSI or
`float` lat/lon crosses a function boundary.

## 3 · Exceptions

Split **domain/business-rule** exceptions (a `BoatDexError` hierarchy, one per
invariant, `<Context><Violation>Error`, structured attributes) from
**programming/precondition** errors (builtin `ValueError`/`TypeError` = a bug).
The domain→HTTP status mapping lives **only in the api layer**. Full rule:
[[../05-domain-core/domain-exceptions|domain exceptions]].

## 4 · Purity & determinism (the domain must be a pure function of its inputs)

- **No `datetime.now()` in `domain/`.** Inject a `Clock` port (a `now()`
  provider); "sighting not in the future" is checked against the injected
  clock, so tests pass a frozen clock.
- **No `uuid4()` in `domain/`.** IDs are generated in *infrastructure* and
  passed in; domain entities receive their id.
- **No `random`** anywhere in the domain.
- **Config is passed, not read.** Tunables (`alpha`, `tau`, base H3 resolution)
  arrive as a `RarityConfig` / `RegionConfig` parameter — never a module global
  or `os.environ` read inside the domain.

## 5 · Config & reproducibility

`RarityConfig(alpha=1.0, tau=50.0, version=...)` and a `RegionConfig`
(base resolution + dataset version). Any **persisted derived value** (a stored
score, a leaderboard snapshot) carries a `rarity_model_version` so a retune or
an R1 provider swap (sighting-backed → AIS at MA) stays reproducible and
old scores remain interpretable.

## 6 · Naming & module layout

- Packages/modules: lowercase, `domain/rarity.py`, `domain/social.py`,
  `domain/value_objects.py`, `domain/presence.py`, `domain/geodesy.py`.
- Tests mirror source: `tests/domain/test_rarity.py`; integration under
  `tests/integration/`. Hypothesis strategies named `st_<thing>`. Test doubles
  (`DictPresence`, `FakeClock`) co-located under `tests/`.
- Exceptions: `<Context><Violation>Error` (e.g. `InvalidFriendshipTransitionError`).

## 7 · Docstrings & numerics

- **NumPy-style** docstrings (`Parameters`/`Returns`/`Raises`), no usage
  examples. Document **algorithmic complexity** (e.g. rarity backoff is
  `O(tree depth)`) and **numerical caveats** (use `math.fsum` for score sums;
  note `log2` ULP non-determinism across platforms).
- **Units are explicit**: distances in **metres**, rarity in **bits**,
  timestamps **UTC-aware**.

## 8 · Typing & tooling

Python 3.10+ (`X | None`, `list[int]`), `mypy --strict`. `ruff` (lint+format),
`pytest` + `pytest-cov` (100% branch coverage on `domain/`), `hypothesis` for
domain properties, `pre-commit`, `import-linter`. See
[[../03-tech-stack/_MOC|tech stack]].

## Related

- [[_MOC|Quality & ops MOC]]
- [[../02-architecture/_MOC|Architecture]] — the layers these rules enforce
- [[../05-domain-core/value-objects|Value objects]] · [[../05-domain-core/domain-exceptions|Domain exceptions]]
- [[../05-domain-core/rarity-surprisal|Rarity]] — `RarityConfig` + versioning

#type/concept #status/active #domain/backend #project/boatdex
