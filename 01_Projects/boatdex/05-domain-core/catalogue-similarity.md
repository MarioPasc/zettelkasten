---
title: "Catalogue similarity"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/information-retrieval, project/boatdex]
aliases: ["Jaccard similarity", "how alike are our collections"]
sources:
  - "Jaccard, P. (1912). The distribution of the flora in the alpine zone. New Phytol. 11(2):37–50. DOI:10.1111/j.1469-8137.1912.tb05611.x"
---

# Catalogue similarity

*How alike two collections are: the plain Jaccard index over their sets of
distinct (vessel, region) entries — one bounded 0..1 number backing the
"how alike are our collections?" comparison readout.*

The comparison feature ([[../06-features/_MOC|Features]]) shows mine ∩ theirs,
only-mine, only-theirs, and a single similarity number. That number is the
**plain** Jaccard index (the resolved similarity decision — no rarity
weighting) over catalogue entries as defined in [[collection-score]].

## Definition

For users `A`, `B` with catalogue sets `S_A`, `S_B` of `(MMSI, region_id)`
pairs:

```
J(A, B) = |S_A ∩ S_B| / |S_A ∪ S_B|
```

The comparison payload is the triple of sets plus `J`:
`(S_A ∩ S_B, S_A \ S_B, S_B \ S_A, J)`.

## Invariants

1. **Bounds.** `0 ≤ J(A, B) ≤ 1`.
2. **Reflexivity.** `J(A, A) = 1` for non-empty `A`.
3. **Symmetry.** `J(A, B) = J(B, A)`.
4. **Disjointness.** `J(A, B) = 0` iff `S_A ∩ S_B = ∅`.
5. **Empty convention.** `J(∅, ∅) = 1` by definition (two empty collections are
   identical); `J(A, ∅) = 0` for non-empty `A`. This resolves the `0/0` case
   explicitly so the function is total.

## Acceptance tests

**Property (hypothesis):**

- `test_jaccard_bounds` — random pair sets ⇒ `0 ≤ J ≤ 1`.
- `test_jaccard_reflexive` — non-empty `A` ⇒ `J(A, A) == 1.0`.
- `test_jaccard_symmetric` — `J(A, B) == J(B, A)`.
- `test_jaccard_disjoint` — disjoint sets ⇒ `J == 0.0`.

**Example (pytest):**

- `test_jaccard_empty` — `J(∅, ∅) == 1.0` and `J({(1,'a')}, ∅) == 0.0`.
- `test_jaccard_golden` — `S_A={(1,'x'),(2,'x'),(3,'y')}`,
  `S_B={(2,'x'),(3,'y'),(4,'z')}` ⇒ `|∩|=2, |∪|=4, J=0.5`.

## Non-goals

- No rarity-weighted variant in v1 (explicitly deferred; a shared rare vessel
  counts the same as a shared common one for now).
- Does not decide authorization — comparison is only offered between
  accepted-friend edges ([[friendship-fsm]], [[../07-api/_MOC|API]] authz rule).

#type/concept #status/active #domain/information-retrieval #project/boatdex

## Related

- [[collection-score|Collection score]] — same `(MMSI, region)` set, summed instead of intersected
- [[rarity-surprisal|Rarity as regional surprisal]] — highlights *which* shared finds are rare
- [[friendship-fsm|Friendship FSM]] — comparison requires an accepted edge
- [[_MOC|Domain-core MOC]]
