---
title: "Code note — events"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — events

*`SightingCreated` domain event with `as_payload()` producing a fully JSON-friendly dict; no external serialisation library required.*

## Goal

Emit a structured domain event when a sighting is created so that downstream consumers (notifications, AIS stats, leaderboard updates) can react without coupling to the `Sighting` entity directly.

## Key implementation facts

- **`SightingCreated`** (`@dataclass(frozen=True)`):
  - `sighting_id: UUID`
  - `user_id: UUID`
  - `vessel_id: UUID`
  - `region_id: RegionId`
  - `spotted_at: datetime` (UTC-aware)
  - `verified: bool`
  - `verification: str | None`
  - `r1_bits: frozenset[str]`
- **`as_payload(self) -> dict[str, object]`**: returns a JSON-friendly dict:
  - UUIDs serialised as `str(uuid)`.
  - `region_id` serialised as `int(region_id.value)`.
  - `spotted_at` serialised as `spotted_at.isoformat()` (ISO-8601 UTC string).
  - `r1_bits` serialised as `sorted(list(self.r1_bits))` (deterministic ordering).
  - `verified` and `verification` pass through unchanged.
- No dependency on `json`, `pydantic`, or any serialisation library — the method returns a plain `dict` that callers pass to `json.dumps` themselves.
- `SightingCreated` is constructed from a `Sighting` entity; a factory function `from_sighting(s: Sighting) -> SightingCreated` is provided.

## Tests / coverage

`tests/domain/test_events.py`: construction, `as_payload` field-by-field assertions (UUID as str, datetime as ISO string, sorted r1_bits), round-trip via `json.dumps(as_payload())`. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../06-features/sightings-and-catalogue|spec: sightings & catalogue]]
