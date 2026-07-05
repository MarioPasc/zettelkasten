---
title: "MOC — BoatDex · Features"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/product]
---

# MOC — BoatDex · Features

*The functional specification, feature by feature. Project context: the core
loop is spot → identify → log → grow, wrapped in a social layer of mutual
friends (see [[../_README|README]]). Each note here follows the spec-driven
template (goal · user stories · domain invariants · interfaces · data changes
· acceptance criteria · out-of-scope) so it can be implemented against
directly.*

## Scope

One note per user-facing capability. Features cite the mechanics in
[[../05-domain-core/_MOC|Domain core]] and the endpoints in
[[../07-api/_MOC|API]]; they do not restate them.

## Planned notes

- [[sightings-and-catalogue|Sightings & catalogue]] — create/list a sighting; dedup; `vessel.global_count` update; the personal catalogue with counts, first/last seen, rarity; future-dated spot → validation error
- [[accounts-and-profiles|Accounts & profiles]] — per-user account; private-by-default collection; display name; account lifecycle
- [[friends-and-graph|Friends & graph]] — send/accept/decline requests, unfriend, block; mutual (both agree); canonical-edge uniqueness
- [[collection-comparison|Collection comparison]] — mine ∩ theirs, only-mine, only-theirs; "how alike?" (Jaccard) readout; rare shared finds highlighted
- [[notifications|Notifications]] — fan-out on write; novelty flags `friend_spot`, `owner_novel` (new to spotter), `group_novel` (first in the friend group)
- [[realtime-feed|Realtime feed]] — in-app live friend-spot feed over WS/SSE; push when backgrounded; < 1 s delivery target
- [[camera-identify|Camera identify (deferred)]] — point-at-vessel AIS resolution; bounding-box subscription; heading-tolerance overlay; public identity fields only; M9, off the critical path

## Open questions (Q&A agenda)

- Proof-of-sighting (open decision Q4) directly shapes the sightings feature: trust / photo-required / photo-optional-but-rewarded.
- Comparison: friends-only, or extend to public profiles (open decision Q1)?
- Notifications: which events are push-worthy vs. in-app-only? Quiet hours / batching?
- Camera identify: is it in scope for v1 at all, or strictly post-launch (open decision Q2)?
- Manual identify: search by name/MMSI, pick from a nearby list, or free-text with later reconciliation?

## Sources

- `BoatDex_Product_Brief.md` §Core experience, §The social layer, §Camera identify.
- `BoatDex_SPECIFICATION.md` §6 (notification fan-out + novelty flags), §7 (API), §8 (milestones M4–M9).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/product
