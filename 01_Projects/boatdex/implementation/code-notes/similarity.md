---
title: "Code note — similarity"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — similarity

*Jaccard similarity over (vessel, region) frozensets; J(∅, ∅) = 1 by convention; PEP 695 generic; weighted variant deferred.*

## Goal

Quantify catalogue overlap between two collectors so that a friend-recommendation or "similar collectors" feature can rank candidates without loading full catalogues.

## Key implementation facts

- **`jaccard[T](a: frozenset[T], b: frozenset[T]) -> float`** — PEP 695 generic (Python 3.12+ `type` syntax).
- Convention **J(∅, ∅) = 1**: two collectors with empty catalogues are considered identical (maximum similarity). This matches the spec's stated convention and avoids a 0/0 case.
- Operates over `frozenset[tuple[MMSI, RegionId]]` for the catalogue use case, but is generic over any hashable `T`.
- Weighted variant (where sighting frequency modulates intersection weight) is deferred per spec — not implemented in M1.
- Returns a `float` in [0.0, 1.0].

## Tests / coverage

`tests/domain/test_similarity.py`: identity (J(A,A)=1), empty-empty (J(∅,∅)=1), disjoint (J(A,B)=0), partial overlap golden values, Hypothesis symmetry property (J(a,b) == J(b,a)). 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/catalogue-similarity|spec: similarity]]
