---
title: "Code note — events"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — events

*`SightingCreated` is a 5-field frozen dataclass carrying minimal facts only; derived data (`r1_bits`, `verified`, `verification`) is deliberately absent and re-fetched by consumers.*

## Goal

Emit a structured domain event when a sighting is created so that downstream consumers (notifications, leaderboard updates) can react without coupling to the `Sighting` entity directly.

## Key implementation facts

- **`SightingCreated`** (`@dataclass(frozen=True, slots=True)`): exactly five fields —
  - `sighting_id: UUID`
  - `user_id: UUID`
  - `vessel_id: UUID`
  - `region_id: RegionId`
  - `spotted_at: datetime`
- There are **no additional fields**. `r1_bits`, `verified`, and `verification` are absent by design: derived or mutable data is re-fetched by consumers, so the event stays stable across schema migrations.
- **`as_payload(self) -> dict[str, object]`**: returns a JSON-friendly dict over all five fields:
  - `sighting_id`, `user_id`, `vessel_id` → `str(uuid)`.
  - `region_id` → `self.region_id.value` (the underlying `int`).
  - `spotted_at` → `self.spotted_at.isoformat()` (ISO-8601 UTC string).
- There is **no `from_sighting`** factory. Callers construct `SightingCreated` directly with keyword arguments.
- No dependency on `json`, `pydantic`, or any serialisation library — the method returns a plain `dict`.

## Tests / coverage

`tests/domain/test_events.py`: construction, `as_payload` field-by-field assertions (UUIDs as str, `region_id` as int, `spotted_at` as ISO string), round-trip via `json.dumps(as_payload())`. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../06-features/sightings-and-catalogue|spec: sightings & catalogue]]
