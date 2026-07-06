---
title: "Code note — presence port"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — presence port

*`RegionalPresence` is a `typing.Protocol` (7 methods) that abstracts regional vessel-observation counts, keying regions on `RegionId` and vessels on `vessel_id: UUID` — MMSI never appears in the port.*

## Goal

Decouple the domain's statistical computations (rarity, presence) from any concrete persistence mechanism; allow a `DictPresence` test double in unit tests and a `SightingBackedPresence` SQLAlchemy implementation in M2.

## Key implementation facts

- `RegionalPresence` is a `typing.Protocol` (PEP 544); structural subtyping only — no `runtime_checkable` decorator.
- Vessels are keyed by surrogate `vessel_id: UUID`; regions by the `RegionId` value object. MMSI never appears in the port — the AIS adapter maps its MMSI-keyed data to `vessel_id` internally before calling any port method.
- Seven methods:
  - `region_total(region: RegionId) -> int` — total observations in the region (N_r).
  - `region_vocabulary(region: RegionId) -> int` — distinct vessels observed in the region (V_r).
  - `vessel_count(vessel_id: UUID, region: RegionId) -> int` — observations of one vessel in one region (n_{v,r}).
  - `parent(region: RegionId) -> RegionId | None` — backoff parent; `None` only at the global root.
  - `global_total() -> int` — total observations at the global root (N_global).
  - `global_vocabulary() -> int` — distinct vessels at the global root (V_global).
  - `vessel_global_count(vessel_id: UUID) -> int` — observations of one vessel across all regions (n_{v,global}).
- Contract invariants (exercised by the parametrised presence contract test):
  1. All counts are `>= 0`.
  2. `vessel_count(v, r) <= region_total(r)`.
  3. `region_total(r) > 0` implies `region_vocabulary(r) >= 1`.
  4. `parent(r) is None` iff `r` is the global root; the parent chain is finite and acyclic.
  5. Roll-up: `region_total(parent(r)) >= region_total(r)` and `vessel_global_count(v) >= vessel_count(v, r)`.

## Tests / coverage

`tests/domain/test_presence.py`: structural check via `DictPresence`, invariant assertions, edge cases (vessel not seen, empty region). 100% branch coverage on the protocol module (the protocol itself has no branches; coverage exercised via the double).

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
