---
title: "Code note — geodesy"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — geodesy

*Haversine distance, initial bearing, angular difference, and `identify_target` (nearest target within angular tolerance); sphere model with R_EARTH_M = 6371008.8 m.*

## Goal

Support the camera-identify flow: given a device position and compass heading, return the closest vessel candidate whose bearing from the device falls within a tolerance cone.

## Key implementation facts

- **`R_EARTH_M = 6371008.8`** — mean Earth radius in metres (IAU 2012 nominal).
- **`haversine_distance(a: Coordinate, b: Coordinate) -> Distance`**: standard haversine formula; returns `Distance(metres=...)`.
- **`initial_bearing(origin: Coordinate, target: Coordinate) -> float`**: returns bearing in [0, 360) degrees, measured clockwise from geographic north. Uses `atan2` on the sin/cos cross terms.
- **`angular_diff(a: float, b: float) -> float`**: minimal angular difference between two bearings; returns a value in [0, 180] degrees.
- **`identify_target(device: Coordinate, heading: float, candidates: Iterable[tuple[T, Coordinate]], tolerance_deg: float) -> T | None`**:
  - Filters candidates to those within `tolerance_deg` of `heading`.
  - Ties broken by distance (nearest wins).
  - Returns `None` if no candidate is within tolerance.
  - Generic over `T` (vessel ID type).
- **Spec numeric finding**: the spec claims "reciprocal bearing ≈ 180° for any a≠b (atol 1e-6)". This is exact only on a shared meridian or the equator; in the general case the two initial bearings differ from 180° by ≈ Δlon · sin(lat) (meridian convergence on a sphere). Tests pin exact meridian/equator cases; Hypothesis tests verify the property holds for small separations (camera-identify regime). See [[../code-decisions/0004--golden-and-property-tolerances|decision 0004]] and build-session findings.

## Tests / coverage

`tests/domain/test_geodesy.py`: known-distance golden values (equatorial, meridional), bearing quadrant cases, `angular_diff` wrap-around, `identify_target` (no candidates, single, tie-break by distance, tolerance boundary). Hypothesis: symmetry of distance, bearing reciprocal over small separations. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/geodesy-identify|spec: geodesy & identify]]
