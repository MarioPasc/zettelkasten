---
title: "Code note — clock"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — clock

*A `Clock` Protocol exposing a single `now() -> datetime` method; enables deterministic testing by injecting a fixed clock rather than calling `datetime.now()` directly in domain logic.*

## Goal

Enforce domain purity: domain modules must never call `datetime.now()` or any wall-clock function directly, because that makes tests non-deterministic.

## Key implementation facts

- `Clock` is a `typing.Protocol` with one method: `now(self) -> datetime`.
- The returned `datetime` must be UTC-aware (enforced by type annotation; checked in tests via `.tzinfo`).
- The domain never imports `datetime.now` or any real-time source — all callers inject a `Clock` instance.
- Test doubles (`FixedClock`, `FakeClock`) live in `tests/doubles.py`, not in `domain/` (see [[../code-decisions/0002--test-doubles-live-under-tests|decision 0002]]). `FakeClock` supports `.advance(timedelta)` for FSM timestamp progression tests.

## Tests / coverage

`tests/domain/test_clock.py`: structural `isinstance` check via `runtime_checkable`; `FixedClock` and `FakeClock` smoke tests. 100% branch coverage (protocol itself has no branching).

#type/concept #project/boatdex #status/done

## Related

- [[../../10-quality-and-ops/coding-standards|spec: coding standards §4 (Clock injection)]]
