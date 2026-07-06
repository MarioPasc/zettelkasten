---
title: "Code note — value objects"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — value objects

*Six frozen dataclasses enforcing domain identity rules: MMSI, IMO, ShipType, Coordinate, RegionId, Distance. Two exception-raise patterns depending on whether the spec defines a named error subclass for the type.*

## Goal

Provide immutable, self-validating domain primitives so that no raw `int` / `float` / `str` identifier crosses a module boundary.

## Key implementation facts

- All value objects are `@dataclass(frozen=True)` — equality and hashing via structural equality.
- **MMSI** (`value: int`, 9 digits):
  - Leading-digit classification: `kind` property returns `MmsiKind` enum (`VESSEL`, `GROUP`, `SAR_AIRCRAFT`, `COASTAL_STATION`, `INDIVIDUAL`, `OTHER`).
  - Only `VESSEL` MMSIs are considered loggable (sightable).
  - `mid` property (first 3 digits) returns Maritime Identification Digit.
  - Constructor raises `InvalidMmsiError` for values outside [100000000, 999999999].
- **IMO** (`value: int`):
  - Validates the A.600(15) check digit (weighted sum mod 10 = last digit).
  - Constructor raises `InvalidImoError` on check-digit failure.
- **ShipType** (`code: int`):
  - Validates against ITU-R M.1371 category ranges; raises builtin `ValueError` (no named spec subclass for this type — see [[../code-decisions/0003--value-object-exception-split|decision 0003]]).
  - `category` property returns a `ShipCategory` enum label.
- **Coordinate** (`lat: float`, `lon: float`):
  - WGS84 bounds: lat ∈ [−90, 90], lon ∈ [−180, 180].
  - `math.isnan` check on both components; NaN raises `InvalidCoordinateError`.
  - Out-of-bounds raises `InvalidCoordinateError`.
- **RegionId** (`value: int`):
  - Must be strictly positive (MRGID ≥ 1); raises builtin `ValueError`.
- **Distance** (`metres: float`):
  - Must be ≥ 0.0; raises builtin `ValueError`. Supports `__add__`, `__sub__`, `__lt__` for comparison convenience.

## Exception-raise split

MMSI / IMO / Coordinate raise the `ValidationError` family (named subclasses).
ShipType / RegionId / Distance raise builtin `ValueError` — mirroring the exception spec which defines named subclasses only for the first three. See [[../code-decisions/0003--value-object-exception-split|decision 0003]].

## Tests / coverage

`tests/domain/test_value_objects.py`: property tests (Hypothesis) over valid ranges, parametrised edge cases (boundary values, NaN, leading-zero MMSI, IMO check-digit vectors), kind classification table. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/value-objects|spec: value objects]]
- [[../../05-domain-core/domain-exceptions|spec: domain exceptions]]
