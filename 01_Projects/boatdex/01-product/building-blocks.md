---
title: "System building blocks"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/product, project/boatdex]
aliases: ["building blocks", "primary vs secondary blocks"]
sources: []
---

# System building blocks

*BoatDex decomposed into three primary building blocks — capture/identify,
collectible, and rarity/heatmap — plus secondary blocks (friends, client,
notifications). The primary blocks are the product; the rest support them.*

This note is the product-truth statement of *what the app is made of* and *what
matters first*, complementing the horizontal spec areas (architecture,
data-model, …) with a vertical, priority-ordered view. Terminology: a
**vessel** is one boat (the collectible unit's subject); "how many vessels I've
seen" is the collection.

## Primary blocks

### 1 · Capture & identify

Point the phone at a vessel, grant location, and it is saved **as seen**. The
vessel's details come from a free real-time AIS service; distance and direction
are **derived, not sensed**:

- Device supplies **GPS position** and **compass heading**.
- A **bounding-box AIS query** returns nearby vessels with live positions.
- The pointed-at vessel is the one whose **bearing from the observer matches the
  device heading** within a tolerance ([[../05-domain-core/geodesy-identify|geodesy/identify]]).
- **Distance** = great-circle distance between observer GPS and the vessel's AIS
  position; the camera is an **AR viewfinder**, not a rangefinder.
- The sighting is stored **coarsened to its region cell** (precise lat/lon
  dropped).

**Two capture paths.** *Manual* (search/pick a vessel, save with region) is the
MVP path and works with no camera. *Camera* point-and-see is the **primary
fast-follow** — the flagship, not a deferred extra. See
[[../06-features/_MOC|Features]] (`sightings-and-catalogue`, `camera-identify`).

### 2 · Collectible

Every sighting persists to the user's catalogue — a record of the distinct
**`(vessel, region)`** entries they have seen, with counts and first/last-seen.
This is the "life-list." See [[../04-data-model/_MOC|Data model]]
(`catalogue-derivation`) and [[../06-features/_MOC|Features]].

### 3 · Rarity & heatmap

Historical AIS data, updated over time, yields per-vessel statistics that drive:

- A **hotspot heatmap** for a single vessel — where it has been seen.
- **Two rarities**, both surfaced per vessel:
  - **R1 — encounter difficulty** ("how hard was it to see this vessel *here*"):
    AIS-presence regional [[../05-domain-core/rarity-surprisal|surprisal]].
    **This is what the collection score sums.**
  - **R2 — community frequency** ("how many times users have seen it"): the same
    surprisal over *user sightings*, global with a regional breakdown. A shown
    badge, **not** summed into the score.

## Secondary blocks

Real, but they serve the primary loop and come later:

- **Friends & comparison** — private mutual friends, catalogue comparison
  ([[../05-domain-core/friendship-fsm|FSM]], `06/collection-comparison`).
- **Client & frontend** — the Expo app and its UX ([[../08-client-ux/_MOC|Client & UX]]).
- **Notifications & realtime** — friend-spot fan-out and the live feed.

## Priority ordering (build implication)

```
MVP        : capture(manual) → collectible → R1 rarity  (+ minimal client)
fast-follow: capture(camera) + heatmap + R2 rarity
later      : friends/comparison → notifications → realtime
```

This ordering is reflected in [[../11-roadmap/_MOC|the roadmap]]: manual capture
ships first; camera moves up from "deferred M9" to primary fast-follow.

#type/concept #status/active #domain/product #project/boatdex

## Related

- [[core-experience-loop|Core experience loop]] — the spot→identify→log→grow loop these blocks realise
- [[../05-domain-core/rarity-surprisal|Rarity as regional surprisal]] — R1 and R2
- [[../05-domain-core/geodesy-identify|Geodesy & identify]] — distance, bearing, pointed-at match
- [[../02-architecture/_MOC|Architecture]] — live-AIS-identify vs historical-AIS-stats
- [[_MOC|Product MOC]]
