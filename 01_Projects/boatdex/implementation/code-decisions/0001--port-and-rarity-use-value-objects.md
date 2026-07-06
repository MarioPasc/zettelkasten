---
title: "0001 — Port and rarity use value objects"
created: 2026-07-06
updated: 2026-07-06
type: decision
status: done
tags: [type/decision, project/boatdex, status/done]
---

# 0001 — Port and rarity use value objects

*`RegionalPresence` and `rarity()` are typed over `vessel_id: UUID` / `RegionId` value objects, not raw `int` aliases or `MMSI` — enforcing the coding-standards rule that no raw identifier crosses a module boundary.*

## Context

The `regional-presence-port` spec note uses illustrative type aliases `RegionId = str` and `MMSI = int` in its method signatures. The coding-standards note (§2) states: "no raw identifiers cross a layer boundary — always wrap in the value object." These two notes are in tension.

The `rarity()` function similarly could have been typed to accept raw `int` counts, but takes typed keys when querying the `RegionalPresence` port.

## Decision

All `RegionalPresence` method signatures and the `rarity()` function call sites use `vessel_id: UUID` (the entity's surrogate key) and the `RegionId` value object from `domain/value_objects.py`. The spec aliases (`RegionId = str`, `MMSI = int`) are treated as illustrative pseudocode, not binding types. MMSI and IMO live exclusively on the `Vessel` entity and are never passed through the presence port.

## Consequences

- **Positive**: No raw integer or string identifiers pass between domain modules; type errors caught statically by mypy --strict.
- **Positive**: Test doubles (`DictPresence`) indexed by `(UUID, RegionId)` pairs — equality and hashing via structural `__eq__`/`__hash__`, not raw integer keys.
- **Positive**: The AIS adapter performs its own MMSI → vessel_id resolution before calling the port, keeping the domain layer agnostic to AIS-specific identifiers.
- **Negative**: Callers must resolve to `vessel_id` before querying the port; the AIS adapter bears this responsibility.

## Updated (spec reconciliation)

The original draft of this decision stated the port was typed over `MMSI` and `RegionId`. After reconciling with the corrected `05-domain-core/regional-presence-port.md` spec (PR #3 — `fix/conform-port-vessel-id-and-minimal-event`), the vessel key is `vessel_id: UUID`, not `MMSI`. MMSI/IMO are identifiers that live on the `Vessel` entity only; the presence port and rarity function never receive them. This supersedes the earlier MMSI-value-object choice and is the authoritative record.

#type/decision #project/boatdex #status/done

## Related

- [[../../10-quality-and-ops/coding-standards|spec: coding standards §2]]
- [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
