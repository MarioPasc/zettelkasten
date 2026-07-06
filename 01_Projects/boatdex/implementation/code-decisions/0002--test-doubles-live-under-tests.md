---
title: "0002 — Test doubles live under tests/"
created: 2026-07-06
updated: 2026-07-06
type: decision
status: done
tags: [type/decision, project/boatdex, status/done]
---

# 0002 — Test doubles live under tests/

*`FixedClock`, `FakeClock`, and `DictPresence` are placed in `tests/doubles.py`, not in `domain/`; `pythonpath = ["tests"]` in pytest config makes them importable from any test module.*

## Context

The domain defines two ports (`Clock` and `RegionalPresence`) as `typing.Protocol`. Tests need concrete implementations of these protocols. There are two placement options:

1. Place implementations in `domain/` (e.g., `domain/testing.py`) — available to any layer but pollutes the production package with test-only code.
2. Place implementations in `tests/doubles.py` — test-only, but requires `tests/` to be on `sys.path`.

The coding-standards note (§6) explicitly requires test doubles to live in `tests/` and not in the production package.

## Decision

`FixedClock`, `FakeClock` (with `.advance(timedelta)`), and `DictPresence` reside in `tests/doubles.py`. `pyproject.toml` pytest section sets `pythonpath = ["tests"]`, so `from doubles import FixedClock` works from any test module without an absolute import path.

## Consequences

- **Positive**: Production `domain/` package contains only types, protocols, and logic — no test scaffolding.
- **Positive**: Doubles are importable from any test without relative-path gymnastics.
- **Positive**: Import-linter `layers` contract passes without modification (`tests/` is outside `src/boatdex/`).
- **Neutral**: Test doubles are not type-checked against the protocols by mypy unless `tests/` is added to mypy's `files`; added to `mypy.ini` under `[mypy-doubles]` to preserve strict checking.

#type/decision #project/boatdex #status/done

## Related

- [[../../10-quality-and-ops/coding-standards|spec: coding standards §6]]
- [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
