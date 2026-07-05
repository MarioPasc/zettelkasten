---
title: "MOC — BoatDex"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex]
---

# MOC — BoatDex

*Map of Content for BoatDex — a life-list boat-spotting app with a rarity
score and a social layer. This folder holds the full app specification,
organised general → specific: product intent first, then architecture,
technology, data, domain logic, features, interfaces, client, governance,
quality, and the delivery roadmap. Start at [[_README|the project README]]
for context; each area below has its own `_MOC.md` guide.*

## How to read this vault

Areas are numbered to enforce a **general → specific** reading order. The
odd-numbered "why/what" areas (product, features, client, legal) are
readable without engineering background; the technical areas (architecture,
tech-stack, data-model, domain-core, api) deepen from there. Every area's
`_MOC.md` lists its *planned* atomic notes and the **open questions** to be
resolved — those open questions are the agenda for the product Q&A.

## Children — specification areas

- [[01-product/_MOC|01 · Product]] — vision, users, principles, success metrics, the nine open decisions, monetization, go-to-market
- [[02-architecture/_MOC|02 · Architecture]] — hexagonal ports-and-adapters, system context, the core spot data-flow
- [[03-tech-stack/_MOC|03 · Tech stack]] — FastAPI/SQLAlchemy/Postgres, auth, async/realtime, Expo client, AIS source, tooling
- [[04-data-model/_MOC|04 · Data model]] — relational schema, pure domain entities, the derived catalogue view
- [[05-domain-core/_MOC|05 · Domain core]] — rarity (surprisal), collection score, catalogue similarity, friendship FSM, exceptions
- [[06-features/_MOC|06 · Features]] — sightings, accounts, friends, comparison, notifications, realtime, camera-identify
- [[07-api/_MOC|07 · API]] — the endpoint surface and the authorization rule
- [[08-client-ux/_MOC|08 · Client & UX]] — Expo app screens, navigation, key user flows
- [[09-legal-privacy/_MOC|09 · Legal & privacy]] — GDPR compliance, the product guardrails (hard lines)
- [[10-quality-and-ops/_MOC|10 · Quality & ops]] — testing strategy, observability, deployment
- [[11-roadmap/_MOC|11 · Roadmap]] — milestone plan M0–M9, documentation-generation protocol

## Operational folders

- [[decisions/_MOC|Decisions (ADRs)]] — one MADR-format record per non-obvious choice
- [[coding-sessions/_MOC|Coding sessions]] — timestamped logs of build sessions

## Parent

- [[../_MOC|01_Projects MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
