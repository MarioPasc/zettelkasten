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

The rarity model and its information-theoretic justification, the presence
port that feeds it, the collection score, catalogue-similarity, the friendship
finite state machine, and the domain exception hierarchy. The relational side
lives in [[../04-data-model/_MOC|Data model]]; how these are invoked lives in
[[../06-features/_MOC|Features]].

## Resolved model (2026-07-05 Q&A)

Rarity is **regional**, over counts from an abstract **presence port** (user
sightings at launch, AIS presence later); the collectible unit is a distinct
**`(vessel, region)`** pair; the score is a pure sum of regional rarities;
similarity is **plain** Jaccard; the social model is **private-friends-only**
so the FSM stands exactly as sketched. Sparse regions are handled by
**hierarchical shrinkage** up a named-region tree to the global root. Full
decision table in [[../_README|README]].

## Notes (written)

- [[regional-presence-port|Regional presence port]] — the `RegionalPresence` Protocol; `SightingBackedPresence` (launch) → `AISPresence` (later) adapters; the contract every adapter satisfies
- [[rarity-surprisal|Rarity as regional surprisal]] — `R_r(v) = −log₂ p̃_r(v)`; Lidstone base `p̂_r`; Jelinek–Mercer shrinkage `p̃_r = λ_r p̂_r + (1−λ_r) p̃_{parent}`, `λ_r = N_r/(N_r+τ)`; α=1, τ=50; golden test values
- [[collection-score|Collection score]] — `fsum` of `R_r(v)` over distinct `(MMSI, region)` entries; set-additive, idempotent on re-sighting
- [[catalogue-similarity|Catalogue similarity]] — plain Jaccard over `(MMSI, region)` sets; `J(∅,∅)=1` convention; `0 ≤ J ≤ 1`
- [[friendship-fsm|Friendship FSM]] — `canonical_pair`; table pending→{accepted,declined,blocked}, accepted→{blocked}, declined→{pending}, blocked terminal; single illegal-move raise site
- [[domain-exceptions|Domain exceptions]] — `BoatDexError` base + one subclass per invariant (self-friendship, duplicate/absent edge, invalid transition, unknown vessel, unknown region, sighting validation)

## Property tests that must pass (acceptance gate)

- `R_r(v)` non-negative and non-increasing in `n_{v,r}`; backs off to the parent as `N_r → 0`; reduces to IDF `log₂(N/n)` in the single-level, α→0 limit.
- Presence adapters satisfy the port contract (counts ≥ 0; `n_{v,r} ≤ N_r`; parent chain reaches the root).
- `score` set-additive, idempotent on re-sighting, order-invariant (`fsum`).
- `jaccard(a, a) == 1` for non-empty `a`; `0 ≤ jaccard(a, b) ≤ 1`; `J(∅,∅)=1`.
- `canonical_pair` order-invariant; self-pair raises.
- FSM: exactly table-listed transitions succeed; all others raise `InvalidTransitionError`.

## Open questions (remaining, smaller)

- Promote `α` (=1.0) and `τ` (=50) from module constants to per-deployment config once AIS data volume is known?
- Add an **unblock** transition (`blocked → pending`), or keep `blocked` terminal in v1?
- Region-tree depth/source: which Marine Regions / IHO / EEZ dataset, and how many nesting levels the backoff climbs — a data-artefact decision for the [[../02-architecture/_MOC|AIS region-statistics module]].

## Sources (citations)

- `BoatDex_SPECIFICATION.md` §5 (exceptions, FSM, rarity).
- Shannon, C. E. (1948). *A Mathematical Theory of Communication.* Bell Syst. Tech. J. 27(3):379–423. DOI:10.1002/j.1538-7305.1948.tb01338.x
- Robertson, S. (2004). *Understanding inverse document frequency.* J. Doc. 60(5):503–520. DOI:10.1108/00220410410560582
- Jaccard, P. (1912). *The distribution of the flora in the alpine zone.* New Phytol. 11(2):37–50. DOI:10.1111/j.1469-8137.1912.tb05611.x

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/information-retrieval
