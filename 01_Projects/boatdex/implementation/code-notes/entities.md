---
title: "Code note — entities"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — entities

*Five domain entity / value-cluster types: Region, Vessel, Sighting, CatalogueEntry, and the mutable Friendship with its FriendshipStatus enum.*

## Goal

Represent the durable domain objects — the nouns of the model — as plain Python dataclasses and enums with identity semantics, no persistence concerns.

## Key implementation facts

- **Region** (`@dataclass(frozen=True)`): `id: RegionId`, `name: str`, `description: str | None`. Equality by `id`.
- **Vessel** (`@dataclass(frozen=True)`): `id: UUID`, `mmsi: MMSI | None`, `imo: IMO | None`, `name: str | None`, `ship_type: ShipType | None`. Invariant: at least one of `mmsi` or `name` must be non-None (raises builtin `ValueError` in `__post_init__`).
- **Sighting** (`@dataclass(frozen=True)`): `id: UUID`, `user_id: UUID`, `vessel_id: UUID`, `region_id: RegionId`, `spotted_at: datetime` (UTC-aware), `verified: bool`, `verification: str | None`, `r1_bits: frozenset[str]`. **No coordinates stored** — coordinates are used only transiently in the identify flow, not persisted on the sighting.
- **CatalogueEntry** (`@dataclass(frozen=True)`): `vessel: Vessel`, `sightings: tuple[Sighting, ...]`, `rarity: float`. Represents the materialized read model for a single collector's catalogue entry.
- **FriendshipStatus** (`StrEnum`): `PENDING`, `ACCEPTED`, `DECLINED`, `BLOCKED`. `StrEnum` chosen for JSON-serialisation compatibility.
- **Friendship** (`@dataclass`): `id: UUID`, `requester_id: UUID`, `addressee_id: UUID`, `status: FriendshipStatus`, `created_at: datetime`, `updated_at: datetime`. Mutable (status transitions via FSM in `social.py`).

## Tests / coverage

`tests/domain/test_entities.py`: construction, `__eq__` / `__hash__` on frozen types, `Vessel` invariant (no mmsi+name → ValueError), `FriendshipStatus` string values. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../04-data-model/domain-entities|spec: domain entities]]
