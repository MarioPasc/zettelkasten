---
title: "Code note — rarity"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — rarity

*Lidstone-smoothed local probability with Jelinek-Mercer shrinkage to a global-root base case; `rarity() = −log₂(p̃)` in bits; fully monotone and non-negative.*

## Goal

Compute a surprisal score (bits) for observing a vessel in a region, using a two-level smoothing scheme that handles unseen vessels (N_r = 0) and low-count regions without division by zero.

## Key implementation facts

- **Config**: `RarityConfig(alpha: float = 1.0, tau: float = 50.0, version: str = "1.0")` — frozen dataclass.
  - `alpha`: Lidstone smoothing pseudocount.
  - `tau`: Jelinek-Mercer mixing weight (higher = more trust in global).
  - Invalid values (alpha ≤ 0, tau ≤ 0, negative counts) raise builtin `ValueError`.
- **Formula**:

  ```
  p̃_local  = (n_rv + alpha) / (N_r + V * alpha)     # Lidstone, V = vocab size
  p̃_global = (n_v + alpha)  / (N_G + V * alpha)     # global base
  p̃        = (N_r / (N_r + tau)) * p̃_local
             + (tau / (N_r + tau)) * p̃_global        # Jelinek-Mercer
  rarity   = -log2(p̃)
  ```

- **N_r = 0 short-circuit**: when the region has no sightings, the Jelinek-Mercer weight on the local term is 0; reduces to pure global backoff, avoiding the 0/0 undefined form.
- **`math.log2`** used (not `math.log`); result guaranteed non-negative because p̃ ≤ 1.
- **Spec numeric finding**: the spec's golden table bits column (4.8957, 6.2446) are slightly off from exact −log₂(p̃) (≈4.89586, ≈6.24547). Tests pin the mathematically exact values (see [[../code-decisions/0004--golden-and-property-tolerances|decision 0004]] and build-session findings).

## Tests / coverage

`tests/domain/test_rarity.py`: Hypothesis property tests (non-negativity, monotone non-increase with count, backoff invariant when N_r=0, IDF limit), golden-table parametrisation against exact −log₂(p̃) values, edge cases (alpha boundary, tau boundary). 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/rarity-surprisal|spec: rarity]]
