---
title: "MOC — BoatDex · Code decisions"
type: moc
created: 2026-07-06
updated: 2026-07-06
tags: [type/moc, project/boatdex]
---

# MOC — BoatDex · Code decisions

*Implementation ADRs — **code-level** decisions taken while building (a library
choice inside a module, a refactor, a workaround, a test strategy). Numbered
`NNNN--slug.md`, MADR-style. **Distinct from** the design/architecture ADRs in
[[../../decisions/_MOC|the spec `decisions/` folder]]: those decide *what to
build*; these decide *how the code does it*. If a choice contradicts or changes
the spec, it does not belong here — raise it against the spec instead.*

## Children

<!-- Auto-managed by the impl-doc skill. One line per ADR:
     - [[NNNN--slug|NNNN — Title]] — one-line outcome -->

- [[0001--port-and-rarity-use-value-objects|0001 — Port and rarity use value objects]] — `RegionalPresence` and `rarity()` typed over `MMSI`/`RegionId` value objects, not raw `int` aliases
- [[0002--test-doubles-live-under-tests|0002 — Test doubles live under tests/]] — `FixedClock`, `FakeClock`, `DictPresence` in `tests/doubles.py`; `pythonpath=["tests"]` in pytest config
- [[0003--value-object-exception-split|0003 — Value-object exception split]] — MMSI/IMO/Coordinate raise `ValidationError` family; ShipType/RegionId/Distance raise builtin `ValueError`
- [[0004--golden-and-property-tolerances|0004 — Golden and property tolerances]] — tests pin exact −log₂(p̃) and meridian/equator bearings; spec numeric discrepancies framed as findings to raise

## Parent

- [[../_MOC|Implementation MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
