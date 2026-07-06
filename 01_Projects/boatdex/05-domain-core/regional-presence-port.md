---
title: "Regional presence port"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["RegionalPresence protocol", "presence provider"]
sources: []
---

# Regional presence port

*The domain-facing interface that supplies the per-region observation counts
rarity needs, so the core stays agnostic to whether those counts come from
user sightings (launch) or aggregated AIS data (later).*

Rarity ([[rarity-surprisal|Rarity as regional surprisal]]) is a pure function
of counts. Those counts have two possible sources over the project's life —
user sightings at launch, and a real AIS presence-statistics module later
(see [[../02-architecture/_MOC|Architecture]]). To keep `domain/` free of any
data source, the counts enter through a `Protocol` **port**; infrastructure
supplies an **adapter**. This is the hexagonal seam that lets the denominator
change with zero domain rework.

## The port (domain interface)

```python
from uuid import UUID
from ..value_objects import RegionId   # value object over the Marine Regions MRGID

# Vessels are keyed by the surrogate vessel_id (UUID) — NOT MMSI — matching the catalogue
# unit (vessel_id, region) and the MMSI-nullable decision. `RegionId` is the value object
# from value_objects (coding-standards §2: no raw int/str crosses the boundary). The AIS
# adapter maps its MMSI-keyed data to vessel_id internally, so the domain never sees MMSI
# in the presence path. (Optionally: `VesselId = NewType("VesselId", UUID)` for type safety.)

class RegionalPresence(Protocol):
    def region_total(self, region: RegionId) -> int: ...              # N_r  : all observations in region r
    def region_vocabulary(self, region: RegionId) -> int: ...         # V_r  : distinct vessels observed in r
    def vessel_count(self, vessel_id: UUID, region: RegionId) -> int: ...  # n_{v,r}
    def parent(self, region: RegionId) -> RegionId | None: ...        # backoff step; None only at the global root
    def global_total(self) -> int: ...                                # N at the global root
    def global_vocabulary(self) -> int: ...                           # V at the global root
    def vessel_global_count(self, vessel_id: UUID) -> int: ...        # n_{v,global}
```

The port is read-only and side-effect-free. `parent` walks the hierarchical
region tree the shrinkage in [[rarity-surprisal|rarity]] climbs; the global
root is reached in a finite number of steps.

## Adapters (infrastructure — not domain)

Two adapters run **permanently**, feeding the two rarities in
[[rarity-surprisal|rarity]] through the identical function:

- **`AISPresence` → R1 (encounter difficulty).** Counts derive from the AIS
  region-statistics module (position reports / vessel-days of v in r). The adapter
  **maps MMSI → vessel_id** via the vessel registry; a vessel with no MMSI has zero
  AIS presence (rarity backs off). Ground truth, independent of app adoption. Ships
  with milestone MA; until then, R1 uses the sighting-backed adapter as a stand-in.
- **`SightingBackedPresence` → R2 (community frequency).** Counts derive from the
  `sighting` table keyed by the surrogate `vessel_id`: `n_{v,r}` = sightings of
  `vessel_id` in region r across all users, `N_r` = sightings in r, `V_r` = distinct
  `vessel_id` in r. Available day one, no new service. Endogenous (a vessel looks
  common because users log it) — exactly the community-frequency signal R2 wants.

Both satisfy this one port, so rarity/score code and their tests never change
when either count source does.

## Contract (every adapter must satisfy)

The region tree is a **partition** (child regions tile their parent, no
overlap) — **guaranteed by construction** via the [[region-model|H3 region
model]] (each grid cell maps to exactly one region), not merely assumed. Then
for all `v`, `r`:

1. All returned counts are `≥ 0`.
2. `vessel_count(v, r) ≤ region_total(r)`.
3. `region_total(r) > 0 ⇒ region_vocabulary(r) ≥ 1`, and `V_r ≥ #{v : n_{v,r} > 0}`.
4. `parent(r) is None` iff `r` is the global root; from any region the parent
   chain reaches the root in finite steps (no cycles).
5. Partition roll-up: `region_total(parent) ≥ region_total(r)` and
   `vessel_global_count(v) ≥ vessel_count(v, r)`.

## Acceptance tests

**Contract test (parametrised over adapters).** A single
`test_presence_contract(provider)` asserts invariants 1–5 on a fixed fixture
graph; both `SightingBackedPresence` (against a seeded disposable Postgres) and
an in-memory stub run it. Any adapter added later must pass unchanged.

**Stub for domain tests.** A `DictPresence(counts, tree)` in-memory
implementation is the test double all [[rarity-surprisal|rarity]] property
tests build on — it lets a test set `n_{v,r}`, `N_r`, `V_r` independently and
assert the maths without a database.

## Non-goals

- No caching, no persistence, no AIS wire format here — those live in the
  adapters, behind the port.
- The port does not define the region tree itself; that is a data artefact
  (Marine Regions / IHO / EEZ) loaded by infrastructure.

#type/concept #status/active #domain/backend #project/boatdex

## Related

- [[rarity-surprisal|Rarity as regional surprisal]] — the sole consumer of this port
- [[../04-data-model/_MOC|Data model]] — the `sighting` / region tables the launch adapter reads
- [[../02-architecture/_MOC|Architecture]] — the AIS region-statistics module behind `AISPresence`
- [[_MOC|Domain-core MOC]]
