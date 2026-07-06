---
title: "Value objects"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/data-modeling, project/boatdex]
aliases: ["value objects", "MMSI value object", "IMO", "primitive obsession"]
sources: []
---

# Value objects

*Validating value objects replace raw `int`/`str`/`float` in the domain so
that maritime identity rules (MMSI ranges, the IMO check digit, coordinate
bounds) are enforced once, at construction, and impossible to violate
downstream.*

Decision (2026-07-06 Q&A): **use validating value objects**, not primitives.
Each is a `frozen` dataclass validating in `__post_init__`; an invalid
*external* input raises a domain `ValidationError` (see
[[domain-exceptions|domain exceptions]]), mapped to HTTP 422 in the api layer.
Pattern reference: Evans, *DDD* (value objects); Percival & Gregory,
*Architecture Patterns with Python* (cosmicpython.com).

## The objects

### `MMSI` — Maritime Mobile Service Identity (ITU-R M.585)

9 digits. The **leading digits classify the identity**; a naive `len==9 &
isdigit` check wrongly accepts aids-to-navigation and SART beacons as vessels.

| Leading pattern | `MmsiKind` | Loggable vessel? |
|---|---|---|
| `2`–`7` + MID | `VESSEL` | ✅ yes |
| `0MIDxxxxx` | `GROUP_SHIP` | no |
| `00MIDxxxx` | `COAST_STATION` | no |
| `111MIDaxx` | `SAR_AIRCRAFT` | no |
| `99MIDaxxx` | `ATON` (aid to navigation) | no |
| `98MIDxxxx` | `CRAFT_ASSOCIATED` | no |
| `970/972/974…` | `SART`/`MOB`/`EPIRB` | no |

`MMSI` exposes `kind: MmsiKind` and `mid: int` (first 3 digits → country via a
static [Maritime Identification Digits](https://en.wikipedia.org/wiki/Maritime_identification_digits)
table → flag). **Only `kind == VESSEL` may be the subject of a sighting**;
anything else raises `InvalidMmsiError`. MMSI is *not* the vessel PK (it is
reassigned when a vessel is re-flagged) — see [[../04-data-model/relational-schema|schema]].

### `IMO` — IMO ship identification number (IMO Res. A.600(15))

7 digits: six sequential + one check digit.
`check = (7·d1 + 6·d2 + 5·d3 + 4·d4 + 3·d5 + 2·d6) mod 10 == d7`.
Construction validates the check digit → `InvalidImoError`. **Nullable at the
vessel level**: pleasure craft, small fishing boats and warships have no IMO.

### `ShipType` — AIS ship-and-cargo type (ITU-R M.1371)

Code 0–99; the first digit is the category (30 fishing, 36 sailing,
37 pleasure craft, 40–49 HSC, 50–59 special, 60–69 passenger, 70–79 cargo,
80–89 tanker). Store the **raw code + a derived category label**; treat as a
**soft signal only** (operators mis-set it; 0 = "not available"). Never use
ship type as a hard rarity discriminator.

### `Coordinate` — WGS84 position (EPSG:4326)

`lat ∈ [-90, 90]`, `lon ∈ [-180, 180]`; out of range → `InvalidCoordinateError`.
A transient *input* only — resolved to a `RegionId` and then discarded
([[region-model|region model]]); never persisted on a sighting.

### `RegionId` — Marine Regions gazetteer id (MRGID)

An opaque, stable identifier of a node in the named-region tree
([[region-model|region model]]); in practice the **MRGID** integer from
[Marine Regions](https://www.marineregions.org) (CC-BY 4.0). The
[[regional-presence-port|presence port]] and the region tree key on it.

### `Distance` — metres

Non-negative `float`, unit-tagged (metres) to prevent unit confusion in
[[geodesy-identify|geodesy]] (haversine/geodesic outputs, the proximity check).

## Validation-error policy

- **External/boundary input** (a user-typed MMSI, a client coordinate) that
  breaks a rule → a domain `ValidationError` subclass (`InvalidMmsiError`,
  `InvalidImoError`, `InvalidCoordinateError`), mapped to **HTTP 422** in the
  api layer. These are part of the ubiquitous language.
- **Internal precondition** breaches (a negative count reaching `rarity`) are
  *bugs* → builtin `ValueError`, never a domain exception. See
  [[domain-exceptions|domain exceptions]] for the full rule.

Value objects are pure (no I/O); the MID→country and ship-type tables are
static embedded data.

## Sources

- ITU-R M.585 (MMSI) · IMO Res. A.600(15) (IMO check digit) · ITU-R M.1371
  (AIS ship types) · Marine Regions MRGID (CC-BY 4.0). Full citations in
  [[region-model|region model]] and the tech-stack AIS note.

## Related

- [[_MOC|Domain-core MOC]]
- [[domain-exceptions|Domain exceptions]] — the `ValidationError` family raised here
- [[../04-data-model/domain-entities|Domain entities]] — entities now hold these types
- [[region-model|Region model]] — `RegionId`/MRGID and the named-region tree
- [[../10-quality-and-ops/coding-standards|Coding standards]] — the value-object convention

#type/concept #status/active #domain/data-modeling #project/boatdex
