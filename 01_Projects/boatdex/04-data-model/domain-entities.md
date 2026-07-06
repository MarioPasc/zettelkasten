---
title: "Domain entities"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/data-modeling, project/boatdex]
aliases: ["dataclasses", "domain model"]
sources: []
---

# Domain entities

*The frozen, I/O-free dataclasses the domain core operates on — a pure mirror
of the [[relational-schema|relational schema]] with no ORM, no framework, and
no persistence concern. Keys use the surrogate `vessel_id` and the opaque
`region_id`.*

These live in `domain/entities.py`, importable by nothing outward (the
`import-linter` boundary). The presence counts and rarity that decorate them
come from [[../05-domain-core/_MOC|domain core]], never from these classes.

## Entities

```python
"""domain/entities.py — pure domain entities. No I/O, no ORM."""
from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from uuid import UUID

from .value_objects import IMO, MMSI, RegionId, ShipType  # validating value objects
# RegionId is the Marine Regions MRGID (see 05-domain-core/region-model).


@dataclass(frozen=True, slots=True)
class Region:
    """A node in the hierarchical named-region tree (geometry lives in infra)."""

    region_id: RegionId
    name: str
    parent_id: RegionId | None   # None only at the global root
    level: int                   # 0 = root, grows downward


@dataclass(frozen=True, slots=True)
class Vessel:
    """A vessel by public identity only. Surrogate id; MMSI may be unknown."""

    vessel_id: UUID
    mmsi: MMSI | None             # validated + kind-classified; None if unknown
    imo: IMO | None               # validated check digit; None for small craft
    name: str | None
    ship_type: ShipType | None    # ITU-R M.1371 code + category; a soft signal
    flag: str | None
    # Invariant (mirrors the DDL CHECK): mmsi is not None or name is not None.


@dataclass(frozen=True, slots=True)
class Sighting:
    """An observation event: user U saw vessel V in region R at time T."""

    id: UUID
    user_id: UUID
    vessel_id: UUID
    region_id: RegionId          # resolved at write time; precise lat/lon dropped
    spotted_at: datetime
    photo_url: str | None = None
    note: str | None = None
    verified: bool = False
    verification: str | None = None       # None | 'photo' | 'proximity' | 'proximity_photo'
    observer_distance_m: float | None = None


@dataclass(frozen=True, slots=True)
class CatalogueEntry:
    """A user's aggregate record for one (vessel, region) pair — the collectible unit."""

    vessel_id: UUID
    region_id: RegionId
    sighting_count: int
    first_seen: datetime
    last_seen: datetime
    rarity_bits: float           # R1(v, r); see domain/rarity.py


class FriendshipStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    DECLINED = "declined"
    BLOCKED = "blocked"


@dataclass(slots=True)
class Friendship:
    """Canonical undirected edge with a lifecycle (see domain/social.py)."""

    user_low: UUID
    user_high: UUID
    requested_by: UUID
    status: FriendshipStatus
    updated_at: datetime
```

## Notes on the mirror

- **`Vessel.vessel_id` is the identity**, not MMSI — a boat introduced manually
  with no MMSI is still a first-class vessel (`mmsi=None`). Rarity and the
  catalogue key on `(vessel_id, region_id)`.
- **`Sighting` has no coordinates.** `region_id` is the only spatial field; the
  verification triplet records *how* (not *where*) a sighting was checked.
- **`CatalogueEntry.rarity_bits`** is R1 (encounter difficulty, AIS-backed). R2
  (community frequency) is fetched separately for display, not stored on the
  entry (see [[catalogue-derivation|Catalogue derivation]]).
- The dataclasses are `frozen` (value objects); `Friendship` is mutable only in
  its `status`/`updated_at`, driven by the [[../05-domain-core/friendship-fsm|FSM]].

## Related

- [[_MOC|Data-model MOC]]
- [[../05-domain-core/value-objects|Value objects]] — the validated field types (`MMSI`, `IMO`, `ShipType`, `RegionId`)
- [[relational-schema|Relational schema]] — the tables these mirror
- [[catalogue-derivation|Catalogue derivation]] — how `CatalogueEntry` is built
- [[../05-domain-core/rarity-surprisal|Rarity as regional surprisal]] — `rarity_bits`
- [[../05-domain-core/friendship-fsm|Friendship FSM]] — `Friendship` lifecycle

#type/concept #status/active #domain/data-modeling #project/boatdex
