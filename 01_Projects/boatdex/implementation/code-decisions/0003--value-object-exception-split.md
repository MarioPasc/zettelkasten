---
title: "0003 — Value-object exception split"
created: 2026-07-06
updated: 2026-07-06
type: decision
status: done
tags: [type/decision, project/boatdex, status/done]
---

# 0003 — Value-object exception split

*MMSI, IMO, and Coordinate raise named `ValidationError` subclasses; ShipType, RegionId, and Distance raise builtin `ValueError` — mirroring the exception spec which defines subclasses only for the first three.*

## Context

The domain-exceptions spec defines `InvalidMmsiError`, `InvalidImoError`, and `InvalidCoordinateError` as named subclasses of `ValidationError`. It does not define named subclasses for `ShipType`, `RegionId`, or `Distance`. Two consistent approaches exist:

1. Raise `ValidationError` (base) for the latter three — consistent family but spec does not enumerate them.
2. Raise builtin `ValueError` for the latter three — mirrors the spec boundary exactly; API error handlers catch `ValidationError` for the three with named subclasses and let `ValueError` propagate as a programming error.

## Decision

Raise named `ValidationError` subclasses only for the value objects for which the spec explicitly defines them (MMSI, IMO, Coordinate). Raise builtin `ValueError` for ShipType, RegionId, and Distance — these represent programmer misuse of the constructor rather than a user-supplied invalid identifier.

## Consequences

- **Positive**: The exception hierarchy matches the spec exactly; no undocumented extension.
- **Positive**: API error handlers can pattern-match on `ValidationError` exclusively for the three spec-defined cases without catching unintended `ValueError`s from other sources.
- **Negative**: Two raise conventions in one module require a comment explaining the split; covered in [[../code-notes/value-objects|value-objects code note]] and [[../code-notes/exceptions|exceptions code note]].

#type/decision #project/boatdex #status/done

## Related

- [[../../10-quality-and-ops/coding-standards|spec: coding standards §3]]
- [[../../05-domain-core/domain-exceptions|spec: domain exceptions]]
- [[../../05-domain-core/value-objects|spec: value objects]]
