---
title: "BoatDex"
created: 2026-07-05
updated: 2026-07-05
type: project
status: draft
tags: [type/project, status/draft, domain/mobile-app, domain/software-product, project/boatdex]
project: boatdex
priority: p2
---

# BoatDex

*A life-list for boat spotters: point your phone at a vessel, identify it from public AIS data, log the sighting, and build a rarity-scored collection you compare with friends.*

## Goal

Ship a small, focused mobile app where the atomic unit of value is a
**sighting** — a user personally observes a vessel, identifies it, and logs
it into a private, rarity-weighted collection with an opt-in social layer.
Success is engagement and delight in a focused hobby community, not scale.

## Context and motivation

The idea started watching yachts pass off Marbella and asking "what is that
boat?" Existing ship-tracking apps are radars built for sailors and shipping
professionals; none treats **spotting as a collectible hobby** the way
birdwatching and plane-spotting apps do. The public AIS signal is a
commodity — the opportunity is the *experience* on top of it: a personal
catalogue, a rarity system that rewards rare finds over volume, and a social
layer of mutual friends comparing collections. This is a non-research,
personal build to practise agentic programming, learn new stacks (FastAPI +
Expo), and test whether a real hobby community forms.

## Stack

*(Proposed in the spec; each choice becomes an ADR in `decisions/`.)*

- **Code repo:** `<to-create>` (Python monorepo `boatdex/` + `client/` Expo app)
- **Backend:** FastAPI · SQLAlchemy 2.0 · PostgreSQL (+PostGIS) · Alembic
- **Auth:** fastapi-users (Argon2id + JWT access/refresh)
- **Async / realtime:** arq (Redis) · WebSocket/SSE · Expo Push / FCM / APNs
- **Client:** Expo / React Native (cross-platform)
- **AIS feed:** aisstream.io (free WS) → Datalastic/VesselAPI if outgrown
- **Tooling:** ruff · mypy --strict · pytest + hypothesis · pre-commit · import-linter
- See [[03-tech-stack/_MOC|Tech-stack MOC]] for the full rationale.

## Status

- **Phase:** vault scaffolding → product Q&A (open decisions unresolved)
- **Last session:** *(none yet — this README is the scaffold)*
- **Blockers:** the nine open product decisions in
  [[01-product/_MOC|Product MOC]] must be resolved before M0 scaffolding.

## Roadmap

Milestone-driven (spec §8). Full board in [[11-roadmap/_MOC|Roadmap MOC]].

| Milestone | Goal                                   | Status      |
|-----------|----------------------------------------|-------------|
| M0        | Repo, tooling, CI, doc skeleton        | not started |
| M1        | Pure domain core (rarity, FSM)         | not started |
| M2–M3     | Persistence + auth                     | not started |
| M4–M5     | Sightings/catalogue + social graph     | not started |
| M6–M7     | Notifications fan-out + realtime        | not started |
| M8        | Expo mobile client (end-to-end)        | not started |
| M9        | Camera identify (AIS) — deferred       | not started |

## Key references

The domain-core math rests on four sources (full cites in
[[05-domain-core/_MOC|Domain-core MOC]]):

- Shannon (1948), *A Mathematical Theory of Communication* — surprisal/rarity.
- Robertson (2004), *Understanding IDF*, J. Doc. 60(5) — rarity = IDF.
- Jaccard (1912), *Distribution of the flora in the alpine zone* — collection similarity.
- Silberstein et al. (2010), *Feeding Frenzy*, SIGMOD — fan-out-on-write justification.

## Open questions

The nine product decisions (brief §"Decisions to contrast") are the agenda
for the upcoming Q&A. They live in [[01-product/_MOC|Product MOC]]. In short:
social model · manual-vs-camera launch · rarity definition · sighting proof ·
public boat pages · platform first · monetization · seed region · MVP boundary.

## Related

- [[_MOC|BoatDex Project MOC]]
- [[../_MOC|01_Projects MOC]]
- [[/99_Index|Vault Index]]

#type/project #status/draft #domain/mobile-app #project/boatdex
