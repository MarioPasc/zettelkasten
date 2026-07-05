---
title: "MOC — BoatDex · Client & UX"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/mobile-app]
---

# MOC — BoatDex · Client & UX

*The mobile app experience. Project context: the client is Expo / React
Native, cross-platform, and its job is to make the spot → log loop feel fast
and the collection feel alive (see [[../_README|README]]). The camera is an
enhancement to the capture step, not the product — manual identify-and-log
must be complete on its own.*

## Scope

Screen inventory and navigation, the key user flows, and the UX principles
that keep logging low-friction. Consumes the endpoints in
[[../07-api/_MOC|API]]; realises the features in
[[../06-features/_MOC|Features]].

## Planned notes

- [[navigation-and-screens|Navigation & screens]] — the primary tabs (Collection · Social · Capture/Log · Notifications · Profile); screen map
- [[key-flows|Key user flows]] — onboarding + first sighting; log-a-sighting (search → confirm → save with optional photo/note/place); add-a-friend; receive-and-react-to a friend spot; view-collection-comparison

## Open questions (Q&A agenda)

- Onboarding: how fast can a new user log their first boat (time-to-first-value)?
- Offline-first? Spotters are often at the coast with poor signal — queue-and-sync?
- How is the collection visualised — grid of vessels, list, map of sightings, "score climbing" moment?
- Visual identity / branding / name confirmation ("BoatDex") — placeholder until product Q&A.
- Accessibility and one-handed use on a moving ferry.

## Sources

- `BoatDex_Product_Brief.md` §Core experience, §Camera identify (later).
- `BoatDex_SPECIFICATION.md` §3 (client stack), §8 milestone M8.

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/mobile-app
