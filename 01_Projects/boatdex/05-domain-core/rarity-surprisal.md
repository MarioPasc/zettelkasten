---
title: "Rarity as regional surprisal"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/information-retrieval, project/boatdex]
aliases: ["regional rarity", "R(v)", "surprisal"]
sources:
  - "Shannon, C. E. (1948). A Mathematical Theory of Communication. Bell Syst. Tech. J. 27(3):379–423. DOI:10.1002/j.1538-7305.1948.tb01338.x"
  - "Robertson, S. (2004). Understanding inverse document frequency. J. Doc. 60(5):503–520. DOI:10.1108/00220410410560582"
  - "Zhai, C. & Lafferty, J. (2004). A study of smoothing methods for language models applied to information retrieval. ACM TOIS 22(2):179–214. DOI:10.1145/984321.984322"
---

# Rarity as regional surprisal

*A vessel's rarity is its Shannon self-information under a
hierarchically-smoothed presence distribution: `R_r(v) = −log₂ p̃_r(v)` bits,
where `p̃_r` shrinks the region's own estimate toward its parent so
near-empty regions do not blow up. One function, two live count sources ⇒ two
surfaced rarities.*

Rarity is the number that makes the collection a game
([[../01-product/building-blocks|building blocks]] · block 3). The formula
below is defined once and evaluated over counts supplied by the
[[regional-presence-port|regional presence port]]; running it over **two**
providers yields the product's two rarities.

## Two rarities from one function

| | **R1 — encounter difficulty** | **R2 — community frequency** |
|---|---|---|
| Question | "how hard to see this vessel *here*?" | "how many times have users seen it?" |
| Provider | `AISPresence` (ground-truth AIS) | `SightingBackedPresence` (user sightings) |
| Scope | **regional** (with backoff to global) | **global**, with a regional breakdown |
| Role | **feeds the collection score** ([[collection-score]]) | shown **badge**, not summed |
| Endogenous? | no (real-world) | yes (grows with app usage) |

Both call the identical `rarity(provider, mmsi, region)` below — only the
injected provider differs. `R1` before the AIS module ships uses the
sighting-backed provider as a temporary stand-in; `R2` uses it permanently.

## Definition

For vessel `v` in region `r`, rarity is the surprisal (Shannon 1948) of its
smoothed presence probability:

```
R_r(v) = −log₂ p̃_r(v)          [bits]
```

With no smoothing and a single-level tree this is exactly IDF
(`log₂(N/n_v)`, Robertson 2004) — rarity *is* inverse presence frequency.

## Smoothed estimate (hierarchical shrinkage)

A region's own Lidstone estimate (α = add-α smoothing):

```
p̂_r(v) = (n_{v,r} + α) / (N_r + α·V_r)
```

is unstable when `N_r` is small — the sparse-bucket problem. Shrink it toward
the parent region's smoothed estimate, recursively up the tree to the global
root (Jelinek–Mercer interpolation; Zhai & Lafferty 2004):

```
p̃_r(v)      = λ_r · p̂_r(v) + (1 − λ_r) · p̃_{parent(r)}(v)
p̃_global(v) = (n_{v,global} + α) / (N_global + α·V_global)     # base case
λ_r         = N_r / (N_r + τ)                                  # confidence in region r's own data
```

`λ_r → 0` as `N_r → 0` (empty region ⇒ trust the parent entirely); `λ_r → 1`
as `N_r → ∞` (rich region ⇒ trust local). `τ` is a shrinkage pseudo-count: at
`N_r = τ` the local estimate and the parent estimate carry equal weight.

## Parameters (fixed for v1)

| Symbol | Meaning | v1 value | Rationale |
|--------|---------|----------|-----------|
| `α` | Lidstone smoothing | `1.0` (Laplace) | Standard uninformative prior; keeps `p̂ ∈ (0,1)`. |
| `τ` | shrinkage pseudo-count | `50` | Region needs ~50 observations to half-trust its own rate; tune once AIS data volume is known. |

Both are module constants for v1, not per-request tunable. Promoting them to
config is deferred (see open questions in [[_MOC|Domain-core MOC]]).

## Invariants

1. **Non-negativity.** `p̃_r(v) ∈ (0, 1] ⇒ R_r(v) ≥ 0`.
2. **Monotonicity.** Holding all other port outputs fixed, increasing
   `n_{v,r}` (with `N_r` increased consistently) does not increase `R_r(v)`.
   *(Proof sketch: `d`-step of `(n+α)/(N+αV)` under `n,N → n+1,N+1` has sign
   `(N−n)+α(V−1) ≥ 0`, so `p̂_r` is non-decreasing; `p̃_r` is non-decreasing in
   `p̂_r` since `λ_r ≥ 0`; `−log₂` is decreasing.)*
3. **Backoff limit.** As `N_r → 0`, `λ_r → 0` and `R_r(v) → R_{parent(r)}(v)`.
4. **IDF correspondence.** Single-level tree, `α → 0⁺`, `V` finite ⇒
   `R_r(v) → log₂(N_r / n_{v,r})`.
5. **Purity.** Same port state ⇒ same value; no I/O, no globals, no clock.

## Worked example (golden values for tests)

Two-level tree, region `r` (e.g. Alborán Sea) with parent = global.
`α = 1`, `τ = 50`. Global: `N=1000, V=200, n_v=4`. Region: `N_r=20, V_r=8`.

| Case | `n_{v,r}` | `p̃_r(v)` | `R_r(v)` (bits) |
|------|-----------|----------|-----------------|
| seen twice locally | 2 | `0.0335884` | `4.8957` |
| unseen locally | 0 | `0.0131803` | `6.2446` |

Derivation of row 1: `p̃_global = 5/1200 = 0.00416667`; `p̂_r = 3/28 = 0.107143`;
`λ_r = 20/70 = 0.285714`; `p̃_r = 0.285714·0.107143 + 0.714286·0.00416667 =
0.0335884`; `R = −log₂ 0.0335884 = 4.8957`. Tests pin these at `rtol=1e-6`.

## Acceptance tests

**Property (hypothesis), over `DictPresence` stubs from
[[regional-presence-port|the port]]:**

- `test_rarity_nonnegative` — random count graphs ⇒ `R_r(v) ≥ 0`.
- `test_rarity_monotone_in_count` — build two stubs identical except
  `n_{v,r}` larger (and `N_r` larger by the same delta) ⇒ `R₂ ≤ R₁`.
- `test_backoff_to_parent` — stub with `N_r = 0` ⇒
  `R_r(v) == R_parent(v)` within `rtol=1e-9`.
- `test_idf_limit` — single-level tree, `α = 1e-9` ⇒
  `R_r(v) ≈ log₂(N_r / n_{v,r})` within `atol=1e-3`.

**Example (pytest):**

- `test_rarity_golden` — the two table rows above, `rtol=1e-6`.

## Non-goals

- Not the collection score (that sums rarities: [[collection-score]]).
- Not the count source (that is the [[regional-presence-port|port]]).
- Not the region tree construction (a data artefact, loaded by infra).

#type/concept #status/active #domain/information-retrieval #project/boatdex

## Related

- [[regional-presence-port|Regional presence port]] — supplies `n_{v,r}, N_r, V_r`, the parent chain
- [[collection-score|Collection score]] — `Σ R_r(v)` over catalogue entries
- [[catalogue-similarity|Catalogue similarity]] — the other read-time metric
- [[../04-data-model/_MOC|Data model]] — the region tree and catalogue entry
- [[_MOC|Domain-core MOC]]
