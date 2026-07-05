---
title: "Collection score"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/information-retrieval, project/boatdex]
aliases: ["collection score", "the number friends compete on"]
sources: []
---

# Collection score

*A user's score is the numerically-stable sum of regional rarities over the
distinct (vessel, region) entries in their catalogue — the single number
friends compete on, rewarding rare finds over raw volume.*

The catalogue's atomic unit is a **distinct `(MMSI, region_id)` pair** (the
resolved catch-unit decision): spotting the same vessel in a new sea is a new
collectible entry with its own [[rarity-surprisal|regional rarity]]. The score
sums those.

## Definition

```
score(u) = fsum( R_{r}(v) for (v, r) in catalogue(u) )
```

- `catalogue(u)` is the **set** of distinct `(MMSI, region_id)` entries the
  user has logged ≥ 1 sighting for.
- `R_r(v)` is [[rarity-surprisal|regional rarity]] at the entry's region.
- `fsum` is `math.fsum` — exact partial sums, so a large catalogue of small
  bit-values does not accumulate float drift (matters for tie-breaking on a
  leaderboard).

## Invariants

1. **Non-negativity.** Each `R_r(v) ≥ 0 ⇒ score(u) ≥ 0`.
2. **Set additivity.** Adding a new distinct entry with rarity `ρ` increases
   the score by exactly `ρ`.
3. **Idempotence in the set.** Re-spotting an existing `(v, r)` does not change
   `catalogue(u)` ⇒ score unchanged. (Repeat sightings update `last_seen` and
   `sighting_count`, never the score.)
4. **Order invariance.** Score depends only on the set, not insertion order.
5. **Empty catalogue.** `score(∅) = 0.0`.

## Acceptance tests

**Property (hypothesis):**

- `test_score_nonnegative` — random catalogues ⇒ `score ≥ 0`.
- `test_score_additivity` — `score(C ∪ {e}) == score(C) + R(e)` for `e ∉ C`,
  within `rtol=1e-12`.
- `test_score_idempotent` — re-adding an existing entry leaves the score equal.
- `test_score_order_invariant` — shuffling entry order leaves the score equal
  (exact, since `fsum`).

**Example (pytest):**

- `test_score_empty` — `score([]) == 0.0`.
- `test_score_golden` — a 3-entry catalogue with rarities
  `[4.8957, 6.2446, 2.0]` ⇒ `13.1403` (`rtol=1e-9`).

## Non-goals

- No diminishing-returns transform (rejected: pure sum was the chosen shape).
- No repeat-sighting weighting (repeat sightings are deliberately score-neutral).
- Does not rank users — that is a read query over stored/last-computed scores.

#type/concept #status/active #domain/information-retrieval #project/boatdex

## Related

- [[rarity-surprisal|Rarity as regional surprisal]] — the per-entry term
- [[catalogue-similarity|Catalogue similarity]] — the comparison metric
- [[../06-features/_MOC|Features]] — the catalogue and comparison features
- [[_MOC|Domain-core MOC]]
