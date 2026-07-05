---
title: "MOC — BoatDex · Domain core"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/information-retrieval]
---

# MOC — BoatDex · Domain core

*The load-bearing, framework-free logic — the part worth getting provably
right. Project context: rarity is what makes the collection game meaningful,
and the friendship state machine is what keeps the social graph consistent
(see [[../_README|README]]). Everything here is pure Python with 100% branch
coverage and hypothesis property tests as the acceptance gate.*

## Scope

The rarity model and its information-theoretic justification, the collection
score, catalogue-similarity metrics, the friendship finite state machine, and
the domain exception hierarchy. The relational side lives in
[[../04-data-model/_MOC|Data model]]; how these are invoked lives in
[[../06-features/_MOC|Features]].

## Planned notes

- [[rarity-surprisal|Rarity as surprisal]] — `R(v) = -log2 p̂(v)`, `p̂(v) = (n_v + α)/(N + αV)` (Lidstone smoothing, α=1 ⇒ Laplace); Shannon self-information = IDF; monotonic non-increasing in `n_v`
- [[collection-score|Collection score]] — `fsum` of per-vessel rarities; rewards rare finds over raw volume; the single number friends compete on
- [[catalogue-similarity|Catalogue similarity]] — Jaccard over MMSI sets; rarity-weighted Jaccard so shared rare vessels count more; bounds `0 ≤ J ≤ 1`
- [[friendship-fsm|Friendship FSM]] — `canonical_pair(a,b)` (order-invariant undirected edge); explicit transition table pending→{accepted,declined,blocked}, accepted→{blocked}, declined→{pending}, blocked→∅; illegal moves single raise site
- [[domain-exceptions|Domain exceptions]] — `BoatDexError` base + one subclass per invariant (self-friendship, duplicate/absent edge, invalid transition, unknown vessel, sighting validation)

## Property tests that must pass (acceptance)

- `surprisal` monotonically non-increasing in `sighting_count`.
- `jaccard(a, a) == 1` for non-empty `a`; `0 ≤ jaccard(a, b) ≤ 1`.
- `canonical_pair` is order-invariant.
- FSM: only table-listed transitions succeed; all others raise.

## Open questions (Q&A agenda)

- Global vs. regional rarity (open decision Q3) changes what `N`, `V`, `n_v` count over — resolve before fixing the formula.
- Should `α` (smoothing) be tunable per deployment, or fixed at 1.0?
- Collection score: pure sum, or a diminishing-returns transform to discourage grinding common vessels?
- Comparison readout ("how alike are our collections?") — plain Jaccard, weighted, or both surfaced?

## Sources (citations)

- `BoatDex_SPECIFICATION.md` §5 (exceptions, FSM, rarity).
- Shannon, C. E. (1948). *A Mathematical Theory of Communication.* Bell Syst. Tech. J. 27(3):379–423. DOI:10.1002/j.1538-7305.1948.tb01338.x
- Robertson, S. (2004). *Understanding inverse document frequency.* J. Doc. 60(5):503–520. DOI:10.1108/00220410410560582
- Jaccard, P. (1912). *The distribution of the flora in the alpine zone.* New Phytol. 11(2):37–50. DOI:10.1111/j.1469-8137.1912.tb05611.x

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/information-retrieval
