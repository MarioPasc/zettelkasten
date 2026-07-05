---
title: "MOC — BoatDex · Product"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/product]
---

# MOC — BoatDex · Product

*The "why" and "what" of BoatDex, in non-technical terms — the layer every
engineering decision must serve. Project context: BoatDex is a life-list for
boat spotters where a rarity-scored personal collection, built one sighting
at a time, is shared with mutual friends (see [[../_README|project README]]).
This folder is the source of product truth; when a technical note needs a
"why", it links back here.*

## Scope

Vision and positioning, target users, the core experience loop, the
non-negotiable product principles, how success is measured, the open product
decisions, monetization, and go-to-market. No implementation detail.

## Planned notes

- [[vision-and-positioning|Vision & positioning]] — life-list vs. radar; the gap left by ship-trackers; the experience-not-data thesis
- [[target-users|Target users]] — primary enthusiast spotter; secondary holidaymakers and local hobby communities; honest note on audience size
- [[core-experience-loop|Core experience loop]] — spot → identify → log → grow; catalogue, rarity, collection score
- [[product-principles|Product principles]] — the five hard lines: sighting-as-value, no owner ID, public info only, no people-tracking, privacy-by-default
- [[success-metrics|Success metrics]] — engagement/delight over scale; repeat logging, friend reactions, perceived rarity fairness, "group firsts"
- [[open-decisions|Open decisions]] — the nine to-contrast questions (the Q&A agenda)
- [[monetization|Monetization]] — free vs. freemium vs. one-time; covering running costs vs. goodwill
- [[go-to-market|Go-to-market]] — seed region (Costa del Sol candidate), how an early community forms

## Decisions (Q&A status — 2026-07-05)

From the brief's "Decisions to contrast". **Resolved** in the first Q&A round:

1. ✅ **How social?** → **private-friends-only** (mutual consent; catalogue readable iff own or accepted edge). Drives the [[../05-domain-core/friendship-fsm|FSM]] and the authz rule.
3. ✅ **How is rarity measured?** → **regional**, over a hierarchical named-region tree, with a per-vessel hotspot map; global is the zoomed-out view. Denominator is **AIS presence** (via the [[../05-domain-core/regional-presence-port|presence port]], bootstrapped from sightings). See [[../05-domain-core/rarity-surprisal|rarity]].
6. ✅ **Which platform first?** → **cross-platform** (Expo), already fixed by the stack.

Also settled downstream: the collectible unit is a distinct **`(vessel, region)`** pair; sighting location is **required, coarsened to the region cell**.

**Still open** (next Q&A rounds):

2. **Manual-first or camera-first at launch?** — camera is deferred to M9, so manual-first is implied; confirm.
4. **Do sightings need proof?** trust · photo-required · photo-optional-but-rewarded.
5. **Public "boat page" community layer?** purely-personal · shared wiki-style pages. (Private-only social leans toward purely-personal.)
7. **How does it sustain itself?** free · freemium · one-time.
8. **Which region to seed first?** Costa del Sol vs. alternatives (interacts with region-tree coverage).
9. **Smallest first version worth shipping?** the MVP boundary.

## Sources

- `BoatDex_Product_Brief.md` — §In one line, §The gap, §Who it's for, §Core experience, §Product principles, §What success looks like, §Decisions to contrast.
- `BoatDex_SPECIFICATION.md` §1 (product definition), §"Explicit non-goals".

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/product
