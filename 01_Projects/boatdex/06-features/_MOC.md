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

- [[sightings-and-catalogue|Sightings & catalogue]] — **manual capture is the MVP path** (search/pick a vessel → save with region); create/list a sighting; dedup on `(MMSI, region_id)`; location coarsened to the region cell; the personal catalogue with counts, first/last seen, **R1 rarity + R2 badge**; future-dated spot → validation error
- [[accounts-and-profiles|Accounts & profiles]] — per-user account; private-by-default collection; display name; account lifecycle
- [[friends-and-graph|Friends & graph]] — send/accept/decline requests, unfriend, block; mutual (both agree); canonical-edge uniqueness
- [[collection-comparison|Collection comparison]] — mine ∩ theirs, only-mine, only-theirs; "how alike?" (Jaccard) readout; rare shared finds highlighted
- [[notifications|Notifications]] — fan-out on write; novelty flags `friend_spot`, `owner_novel` (new to spotter), `group_novel` (first in the friend group)
- [[realtime-feed|Realtime feed]] — in-app live friend-spot feed over WS/SSE; push when backgrounded; < 1 s delivery target
- [[camera-identify|Camera identify (primary fast-follow)]] — the flagship capture path: device GPS + compass + camera **AR viewfinder**; live AIS bounding-box query; pointed-at vessel resolved by **bearing match** ([[../05-domain-core/geodesy-identify|geodesy/identify]]); **distance = haversine(user, AIS position)**, direction from bearing/COG; public identity fields only; manual capture is the fallback when identify fails

## Open questions (Q&A agenda)

*Resolved:* comparison is **friends-only** (private social model); camera is a
**primary fast-follow**, not deferred, with manual as the day-one fallback.

- Proof-of-sighting (open decision Q4) directly shapes the sightings feature: trust / photo-required / photo-optional-but-rewarded.
- Manual identify: search by name/MMSI, pick from a nearby list, or free-text with later reconciliation?
- Camera identify: bearing-match tolerance and what to do when several vessels share a bearing (list to disambiguate?); behaviour when AIS returns nothing (fall back to manual).
- R2 (community-frequency) display: a numeric badge, a percentile, or a "seen by N users" count?
- Notifications: which events are push-worthy vs. in-app-only? Quiet hours / batching?

## Sources

- `BoatDex_Product_Brief.md` §Core experience, §The social layer, §Camera identify.
- `BoatDex_SPECIFICATION.md` §6 (notification fan-out + novelty flags), §7 (API), §8 (milestones M4–M9).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/product
