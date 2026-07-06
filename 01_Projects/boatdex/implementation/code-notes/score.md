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

- **`collection_score(rarities: Iterable[float]) -> float`**: accepts an iterable of R1 rarity values (in bits) and returns `math.fsum(rarities)`.
- The function has no knowledge of `CatalogueEntry`. Callers supply the rarity values — typically by reading `CatalogueEntry.rarity_bits` (stored on the entity in `entities.py`) for each distinct `(vessel, region)` catalogue entry. Mapping entries to floats is an application-layer concern.
- **`math.fsum`** gives an exactly-rounded partial-sum total (compensated sum), making the result order-invariant and free of float drift across large catalogues — relevant for leaderboard tie-breaking.
- Returns `0.0` for an empty iterable.
- No caching or memoisation at the domain level; caching is an infrastructure concern.

## Tests / coverage

`tests/domain/test_score.py`: empty iterable (`0.0`), single entry, multi-entry, Hypothesis property (score equals sum of individual rarities regardless of order), golden value with known rarity inputs. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/collection-score|spec: collection score]]
