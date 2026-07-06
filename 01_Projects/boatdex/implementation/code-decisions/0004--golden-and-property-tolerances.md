---
title: "0004 — Golden and property tolerances for numeric spec findings"
created: 2026-07-06
updated: 2026-07-06
type: decision
status: done
tags: [type/decision, project/boatdex, status/done]
---

# 0004 — Golden and property tolerances for numeric spec findings

*Tests pin the mathematically exact values (exact −log₂(p̃) for rarity; exact meridian/equator bearings for geodesy) rather than the spec's printed approximations. The spec inaccuracies are framed as findings to raise, not as authoritative corrections.*

## Context

Two spec notes contain numeric values that do not match the exact mathematical results:

1. **`rarity-surprisal.md` bits column**: the p̃ column is correct (0.0335884, 0.0131803) but the printed bits (4.8957, 6.2446) are rounded incorrectly — exact −log₂(p̃) is ≈4.89586 and ≈6.24547.
2. **`geodesy-identify.md` reciprocal-bearing claim**: "reciprocal bearing ≈ 180° for any a≠b (atol 1e-6)" is exact only on a shared meridian or the equator. In the general case, the two initial bearings differ by ≈ Δlon · sin(lat) (meridian convergence), which is negligible only for small Δlon or near-equatorial latitudes.

Two test-strategy options existed:
- Pin the spec's printed values (treating them as intentional rounding).
- Pin the mathematically exact values and record the discrepancy.

## Decision

Tests pin the mathematically exact values:

- **Rarity golden table**: `pytest.approx(-math.log2(p_tilde), rel=1e-6)` against the computed exact p̃, not the spec's rounded bits.
- **Geodesy reciprocal bearing**: exact equality for meridian and equatorial cases; Hypothesis `small_separation` strategy (Δlat, Δlon < 0.1°) verifying the property holds within the camera-identify regime (where meridian convergence is negligible).

The discrepancies are flagged as spec findings in the build-session log and in the code-notes for `rarity` and `geodesy`. They must be raised against the spec notes — the code does not treat them as authoritative corrections.

## Consequences

- **Positive**: Tests reflect mathematical truth; they will not break if a future spec correction aligns the numbers.
- **Positive**: The property-based approach for geodesy is more informative than a blanket tolerance on an overstated claim.
- **Neutral**: The spec notes need a targeted annotation or corrigendum (external action, not a code change).
- **Negative**: Golden test values do not literally match the spec table; requires the comment `# exact -log2(p̃), spec table rounds to 4.8957` to be self-documenting.

#type/decision #project/boatdex #status/done

## Related

- [[../../05-domain-core/rarity-surprisal|spec: rarity]]
- [[../../05-domain-core/geodesy-identify|spec: geodesy & identify]]
