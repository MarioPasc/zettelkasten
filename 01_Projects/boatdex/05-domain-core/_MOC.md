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

One rarity function `R_r(v) = −log₂ p̃_r(v)`, evaluated over an abstract
**presence port** by two providers ⇒ **two rarities**: **R1** (AIS presence,
regional, *feeds the score*) and **R2** (user sightings, global+regional, a
*shown badge*). The collectible unit is a distinct **`(vessel, region)`** pair;
the score is a pure sum of **R1**; similarity is **plain** Jaccard; the social
model is **private-friends-only** so the FSM stands as sketched. Sparse regions
use **hierarchical shrinkage** up a named-region tree. The capture block's
distance/direction is derived by pure geometry
([[geodesy-identify|geodesy & identify]]), not phone depth sensors. Full
decision table in [[../_README|README]].

## Notes (written)

- [[value-objects|Value objects]] — validating `MMSI` (kind-classified), `IMO` (check-digit), `ShipType` (ITU-R M.1371), `Coordinate`, `RegionId` (MRGID), `Distance`; invalid input → the `ValidationError` family
- [[regional-presence-port|Regional presence port]] — the `RegionalPresence` Protocol; `AISPresence`→R1 and `SightingBackedPresence`→R2 adapters (both permanent); the contract every adapter satisfies
- [[region-model|Region model — named regions over an H3 grid]] — collectible/rarity unit = named region (MRGID); H3 is internal plumbing (O(1) resolve, **partition by construction**, no runtime PostGIS)
- [[rarity-surprisal|Rarity as regional surprisal]] — `R_r(v) = −log₂ p̃_r(v)`; Lidstone base `p̂_r`; Jelinek–Mercer shrinkage `p̃_r = λ_r p̂_r + (1−λ_r) p̃_{parent}`, `λ_r = N_r/(N_r+τ)`; **`RarityConfig(α=1, τ=50, version)`**; **R1/R2 from one function**; golden values
- [[collection-score|Collection score]] — `fsum` of **R1** over distinct `(vessel, region)` entries; set-additive, idempotent on re-sighting
- [[catalogue-similarity|Catalogue similarity]] — plain Jaccard over `(vessel, region)` sets; `J(∅,∅)=1` convention; `0 ≤ J ≤ 1`
- [[geodesy-identify|Geodesy & identify]] — haversine distance, initial bearing, angular diff, `identify_target` (bearing-match the pointed-at vessel); pure, no AIS I/O; golden equator values
- [[friendship-fsm|Friendship FSM]] — `canonical_pair`; table pending→{accepted,declined,blocked}, accepted→{blocked}, declined→{pending}, blocked terminal; single illegal-move raise site
- [[domain-exceptions|Domain exceptions]] — `BoatDexError` base + one subclass per invariant (self-friendship, duplicate/absent edge, invalid transition, unknown vessel, unknown region, sighting validation)

## Property tests that must pass (acceptance gate)

- `R_r(v)` non-negative and non-increasing in `n_{v,r}`; backs off to the parent as `N_r → 0`; reduces to IDF `log₂(N/n)` in the single-level, α→0 limit — and holds for **both** R1 and R2 (same function, different provider).
- Presence adapters satisfy the port contract (counts ≥ 0; `n_{v,r} ≤ N_r`; parent chain reaches the root).
- `score` set-additive, idempotent on re-sighting, order-invariant (`fsum`); sums R1 only.
- `jaccard(a, a) == 1` for non-empty `a`; `0 ≤ jaccard(a, b) ≤ 1`; `J(∅,∅)=1`.
- Geodesy: `d(a,a)=0`, symmetric, `≥0`; reciprocal bearing ≈ 180°; `angular_diff` wraps to `[0,180]`; `identify_target` returns `None` iff no candidate within tolerance.
- `canonical_pair` order-invariant; self-pair raises.
- FSM: exactly table-listed transitions succeed; all others raise `InvalidTransitionError`.

## Resolved (2026-07-06 Q&A → to become ADRs at M1 close-out)

- ✅ **Value objects** over primitives ([[value-objects]]); ✅ **exception split** — domain hierarchy for business rules vs builtin `ValueError` for precondition bugs ([[domain-exceptions]]); ✅ region unit = **named region (MRGID)** over an **H3** grid substrate ([[region-model]]); ✅ **`RarityConfig`** (α, τ injectable) + a `version` stamp on persisted scores. Contract in [[../10-quality-and-ops/coding-standards|coding standards]].

## Open questions (remaining, smaller)

- Add an **unblock** transition (`blocked → pending`), or keep `blocked` terminal in v1?
- H3 **base resolution** (res 4; res 5 for micro-EEZs) and how many named-region levels the backoff climbs — a versioned `RegionConfig` / data-artefact decision ([[region-model]]).

## Sources (citations)

- `BoatDex_SPECIFICATION.md` §5 (exceptions, FSM, rarity).
- Shannon, C. E. (1948). *A Mathematical Theory of Communication.* Bell Syst. Tech. J. 27(3):379–423. DOI:10.1002/j.1538-7305.1948.tb01338.x
- Robertson, S. (2004). *Understanding inverse document frequency.* J. Doc. 60(5):503–520. DOI:10.1108/00220410410560582
- Jaccard, P. (1912). *The distribution of the flora in the alpine zone.* New Phytol. 11(2):37–50. DOI:10.1111/j.1469-8137.1912.tb05611.x

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/information-retrieval
