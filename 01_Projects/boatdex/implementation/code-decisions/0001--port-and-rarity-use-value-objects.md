---
title: "0001 — Port and rarity use value objects"
created: 2026-07-06
updated: 2026-07-06
type: decision
status: done
tags: [type/decision, project/boatdex, status/done]
---

# 0001 — Port and rarity use value objects

*`RegionalPresence` and `rarity()` are typed over `MMSI` / `RegionId` value objects, not raw `int` aliases — enforcing the coding-standards rule that no raw identifier crosses a module boundary.*

## Context

The `regional-presence-port` spec note uses illustrative type aliases `RegionId = str` and `MMSI = int` in its method signatures. The coding-standards note (§2) states: "no raw identifiers cross a layer boundary — always wrap in the value object." These two notes are in tension.

The `rarity()` function similarly could have been typed to accept raw `int` counts, but takes `MMSI` and `RegionId` when querying the `RegionalPresence` port.

## Decision

All `RegionalPresence` method signatures and the `rarity()` function call sites use the `MMSI` and `RegionId` value objects from `domain/value_objects.py`. The spec aliases (`RegionId = str`, `MMSI = int`) are treated as illustrative pseudocode, not binding types.

## Consequences

- **Positive**: No raw integer or string identifiers pass between domain modules; type errors caught statically by mypy --strict.
- **Positive**: Test doubles (`DictPresence`) indexed by value objects — equality and hashing via structural `__eq__`/`__hash__` on frozen dataclasses, not raw integer keys.
- **Neutral**: The spec note's illustrative aliases need a clarification annotation (finding to raise, not a code change).
- **Negative**: Callers must construct `MMSI` / `RegionId` before querying the port; minor extra verbosity at call sites.

#type/decision #project/boatdex #status/done

## Related

- [[../../10-quality-and-ops/coding-standards|spec: coding standards §2]]
- [[../../05-domain-core/regional-presence-port|spec: regional presence port]]
