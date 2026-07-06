---
title: "Code note — exceptions"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — exceptions

*A two-tier exception hierarchy rooted at `BoatDexError`; `ValidationError` sub-family for value-object construction failures; business-rule errors for domain invariant violations.*

## Goal

Provide a single import point for all domain errors so that application and API layers can catch by category (`ValidationError`, `BoatDexError`) without importing individual modules.

## Key implementation facts

- **Root**: `BoatDexError(Exception)` — all domain exceptions inherit from this.
- **Validation family** (`ValidationError(BoatDexError)`):
  - `InvalidMmsiError(ValidationError)` — carries `mmsi: object` (typed `object` to avoid circular import with `value_objects`).
  - `InvalidImoError(ValidationError)` — carries `imo: object`.
  - `InvalidCoordinateError(ValidationError)` — carries `lat: float`, `lon: float`.
- **Business-rule errors** (direct children of `BoatDexError`):
  - `SelfFriendshipError` — user attempted to friend themselves.
  - `DuplicateEdgeError` — friendship edge already exists.
  - `AbsentEdgeError` — friendship edge does not exist (used by `unblock`/delete).
  - `InvalidTransitionError` — FSM transition not allowed from current state.
  - `UnknownVesselError` — vessel MMSI not found.
  - `UnknownRegionError` — region MRGID not found.
  - `SightingValidationError` — composite sighting constraint violated.
- **Structured attributes**: each subclass stores the offending value as a named attribute on the exception instance, enabling programmatic inspection by API error handlers.
- **`id`-like attrs typed `object`**: the `mmsi` / `imo` attrs on validation errors are typed `object` (not `MMSI` / `IMO`) to avoid a module-level cycle between `exceptions.py` and `value_objects.py`, since value objects raise these exceptions during construction.

## Tests / coverage

`tests/domain/test_exceptions.py`: instantiation of each subclass, attribute access, `isinstance` hierarchy checks. 100% branch coverage within the module.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/domain-exceptions|spec: domain exceptions]]
