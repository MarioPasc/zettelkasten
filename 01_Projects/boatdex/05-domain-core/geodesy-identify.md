---
title: "Geodesy & identify"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["haversine", "bearing", "pointed-at identify", "range and bearing"]
sources:
  - "Sinnott, R. W. (1984). Virtues of the Haversine. Sky and Telescope 68(2):159."
---

# Geodesy & identify

*The pure functions the capture block needs: great-circle distance and initial
bearing between two lat/lon points, and the rule that picks which nearby vessel
the phone is pointed at by matching device heading to each vessel's bearing.*

The [capture & identify block](../01-product/building-blocks.md) derives
distance and direction from positions rather than phone depth sensors. That
derivation is pure geometry, so it lives in the domain core with the rarity
maths — no AIS I/O here (the bounding-box query is an infrastructure adapter;
these functions consume its already-fetched `candidates`).

## Types

```python
@dataclass(frozen=True)
class LatLon:
    lat: float   # degrees, [-90, 90]
    lon: float   # degrees, [-180, 180]

@dataclass(frozen=True)
class VesselFix:
    mmsi: int
    pos: LatLon
    cog: float | None = None   # course over ground, degrees (from AIS)
```

`R_EARTH = 6_371_008.8` m (IUGG mean radius).

## Functions

```python
def haversine_distance(a: LatLon, b: LatLon) -> float:      # metres
def initial_bearing(a: LatLon, b: LatLon) -> float:         # degrees, [0, 360)
def angular_diff(deg1: float, deg2: float) -> float:        # smallest, [0, 180]
def identify_target(
    observer: LatLon, heading_deg: float,
    candidates: Sequence[VesselFix], tolerance_deg: float,
) -> VesselFix | None:
```

- `haversine_distance` — Sinnott (1984) haversine, numerically stable at small
  separations (where the spherical law of cosines degrades).
- `initial_bearing` — forward azimuth from `a` to `b`.
- `identify_target` — among `candidates`, keep those whose bearing from
  `observer` is within `tolerance_deg` of `heading_deg` (via `angular_diff`,
  which wraps 360→0); return the one with the **smallest angular difference**,
  tie-broken by **nearest distance**; `None` if none qualify.

## Invariants

1. `haversine_distance(a, a) == 0`; symmetric; `≥ 0`.
2. `angular_diff(initial_bearing(a, b), initial_bearing(b, a)) ≈ 180°`
   (reciprocal bearing), for `a ≠ b`.
3. `angular_diff` wraps: `angular_diff(359, 1) == 2`; range `[0, 180]`; symmetric.
4. `identify_target` returns `None` iff no candidate is within `tolerance_deg`.
5. Purity — no clock, no I/O, deterministic.

## Worked example (golden values for tests)

At the equator, `α = 1e-9`-free clean geometry:

| Call | Expected |
|------|----------|
| `haversine_distance((0,0), (0,1))` | `111194.9` m (`rtol=1e-4`) |
| `haversine_distance((0,0), (1,0))` | `111194.9` m (`rtol=1e-4`) |
| `initial_bearing((0,0), (0,1))` | `90.0°` (due east) |
| `initial_bearing((0,0), (1,0))` | `0.0°` (due north) |

Identify: observer `(0,0)`, heading `88°`, tolerance `10°`, candidates at
bearings `{90° (east), 0° (north), 270° (west)}` ⇒ returns the east vessel
(`|88−90|=2 ≤ 10`, the closest match).

## Acceptance tests

**Property (hypothesis):**

- `test_distance_zero_symmetric_nonneg` — random points ⇒ `d(a,a)=0`, `d(a,b)=d(b,a)`, `d≥0`.
- `test_reciprocal_bearing` — `a≠b` ⇒ `angular_diff(bearing(a,b), bearing(b,a)) ≈ 180` (`atol=1e-6`).
- `test_angular_diff_wraps` — `∀ x,y: 0 ≤ angular_diff(x,y) ≤ 180` and `angular_diff(359,1)==2`.
- `test_identify_none_outside_tolerance` — all candidates > tolerance away ⇒ `None`.

**Example (pytest):**

- `test_geodesy_golden` — the four table rows.
- `test_identify_picks_nearest_bearing` — the identify scenario above ⇒ east vessel.
- `test_identify_tiebreak_nearest` — two candidates at equal bearing ⇒ the closer one.

## Non-goals

- No AIS querying, no camera/AR rendering — those are adapters/client.
- No sensor-fusion or Kalman filtering; a single instantaneous fix is assumed.
- Not region resolution (`lat/lon → region_id` is point-in-polygon, an app service).

#type/concept #status/active #domain/backend #project/boatdex

## Related

- [[../01-product/building-blocks|System building blocks]] — the capture & identify block
- [[../06-features/_MOC|Features]] — `camera-identify` consumes these functions
- [[rarity-surprisal|Rarity as regional surprisal]] — the other pure-maths core
- [[_MOC|Domain-core MOC]]
