---
title: "Code note — score"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — score

*`collection_score()` sums R1 rarity bits over a collector's catalogue using `math.fsum` for order-invariant, numerically exact floating-point accumulation.*

## Goal

Produce a single scalar ranking a collector's catalogue by the total surprisal of their sightings; feeds leaderboards and personal-progress displays.

## Key implementation facts

- **`collection_score(entries: Iterable[CatalogueEntry]) -> float`**: iterates over `CatalogueEntry.rarity` values and accumulates with `math.fsum`.
- **`math.fsum`** chosen for exact floating-point summation (compensated sum) — the result is independent of iteration order. A simple `sum()` would produce order-dependent rounding errors for large catalogues.
- Returns `0.0` for an empty iterable.
- No caching or memoisation at the domain level; caching is an infrastructure concern.

## Tests / coverage

`tests/domain/test_score.py`: empty catalogue (0.0), single entry, multi-entry, Hypothesis property (score equals sum of individual rarities regardless of order), golden value with known rarity inputs. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/collection-score|spec: collection score]]
