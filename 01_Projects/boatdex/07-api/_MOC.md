---
title: "MOC — BoatDex · API"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/api-design]
---

# MOC — BoatDex · API

*The HTTP/WS interface contract between the Expo client and the backend.
Project context: the api layer is thin — it authenticates, validates, and
delegates to application services; the authorization rule (you may read a
catalogue iff it is yours or an accepted-friend edge exists) is enforced in
the application layer, not the router (see [[../02-architecture/_MOC|Architecture]]).*

## Scope

The endpoint surface, request/response shapes, and the authorization rule.
FastAPI auto-generates OpenAPI, so this folder tracks the *design intent*;
the generated reference lives in the code repo's `docs/api/`.

## Planned notes

- [[api-surface|API surface]] — auth (`/auth/register`, `/auth/jwt/login`, `/auth/jwt/refresh`), sightings (`POST /sightings`, `GET /sightings`), catalogue (`GET /me/catalogue`, `GET /me/catalogue/compare?friend_id=`), friends (`/friends/requests` + accept/decline, `DELETE /friends/{id}`, `GET /friends`), notifications (`GET /notifications`, `POST /notifications/{id}/read`), devices (`POST /devices/push-token`), realtime (`WS /realtime`); plus the authorization rule

## Open questions (Q&A agenda)

- Pagination scheme (cursor vs. offset) for `/sightings` and `/notifications`.
- Versioning: prefix `/v1` from the start, or defer?
- Rate limiting on sighting creation to deter fake-logging (ties to proof decision Q4).
- Public-profile endpoints — needed only if the social model (Q1) goes public/hybrid.

## Sources

- `BoatDex_SPECIFICATION.md` §7 (API surface + authorization rule).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/api-design
