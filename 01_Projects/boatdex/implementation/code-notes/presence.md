---
title: "Code note — presence port"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — presence port

*`RegionalPresence` is a `typing.Protocol` (7 methods) that abstracts regional sighting counts so that the domain's rarity and catalogue logic can be tested without a database.*

## Goal

Decouple the domain's statistical computations (rarity, presence) from any concrete persistence mechanism; allow a `DictPresence` test double in unit tests and a `SightingBackedPresence` SQLAlchemy implementation in M2.

## Key implementation facts

- `RegionalPresence` is a `typing.Protocol` (PEP 544); runtime-checkable for assertion in tests.
- Seven methods:
  - `vessel_count_in_region(mmsi: MMSI, region: RegionId) -> int` — local sightings of one vessel in one region.
  - `total_count_in_region(region: RegionId) -> int` — total sightings in region (N_r).
  - `global_vessel_count(mmsi: MMSI) -> int` — vessel appearances across all regions.
  - `global_total_count() -> int` — all sightings globally (N_global).
  - `regions_for_vessel(mmsi: MMSI) -> frozenset[RegionId]` — which regions a vessel has been seen in.
  - `vessels_in_region(region: RegionId) -> frozenset[MMSI]` — which vessels are known in a region.
  - `catalogue_entry_count(mmsi: MMSI) -> int` — how many collectors have logged this vessel.
- All method signatures use `MMSI` and `RegionId` value objects — no raw `int` identifiers cross the boundary (see [[../code-decisions/0001--port-and-rarity-use-value-objects|decision 0001]]).
- Contract invariants encoded as assertions in `DictPresence` (test double):
  1. `vessel_count_in_region ≤ total_count_in_region`.
  2. `global_vessel_count ≥ vessel_count_in_region` for any region.
  3. `total_count_in_region ≤ global_total_count`.
  4. `regions_for_vessel` and `vessels_in_region` are consistent (bidirectional index).
  5. Counts are non-negative integers.

## Tests / coverage

`tests/domain/test_presence.py`: `DictPresence` structural check, invariant assertions, edge cases (vessel not seen, empty region). 100% branch coverage on the protocol module (protocol itself has no branches; coverage exercised via double).

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
