---
title: "MOC — BoatDex · Quality & ops"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/backend]
---

# MOC — BoatDex · Quality & ops

*The non-functional layer — how BoatDex is tested, observed, and run.
Project context: the spec sets hard gates (100% branch coverage on the pure
domain, mypy --strict, an import-linter boundary) that make the core math
honest and the layers clean (see [[../02-architecture/_MOC|Architecture]]).
This folder turns those into a strategy.*

## Scope

Testing strategy across the layers, observability, and deployment/operations.
Complements the tooling choices in [[../03-tech-stack/_MOC|Tech stack]] (which
picks the tools) by defining how they are used.

## Planned notes

- [[coding-standards|Coding standards]] ✅ *written* — layering + import-linter contracts, value objects, the exception split, domain purity (Clock injection, no `uuid4`/`now` in domain), config + versioning, naming/docstrings/numerics
- [[testing-strategy|Testing strategy]] — fast pure-domain unit + hypothesis property tests; application-layer tests with mocked infra; integration tests against disposable Postgres + the API; push adapter contract-tested against Expo/FCM; coverage gates per layer
- [[observability|Observability]] — structlog structured/JSON logging; no plaintext secrets in logs; key metrics (spot rate, fan-out latency, push delivery, WS connection health); what to alert on
- [[deployment|Deployment & ops]] — environments, CI (ruff/mypy/pytest/import-linter green as merge gate), migration workflow (Alembic up/down), backups, and the hosting target (to be decided)

## Open questions (Q&A agenda)

- Hosting + CI/CD provider (ties to [[../03-tech-stack/_MOC|tech-stack]] hosting question).
- Budget ceiling for running costs — bounds host, managed-DB, and AIS-tier choices.
- Load expectations: given the honestly-small audience, what scale do we design for (and explicitly *not* over-engineer for)?
- Error tracking (Sentry-style) — in scope for v1?
- Mobile release pipeline: Expo EAS build/submit, app-store review overhead.

## Sources

- `BoatDex_SPECIFICATION.md` §3 (enforced tooling), §8 (per-milestone acceptance criteria), §9 (documentation protocol).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/backend
