---
title: "Domain exceptions"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["BoatDexError", "domain exception hierarchy"]
sources: []
---

# Domain exceptions

*One base exception and one subclass per domain invariant, so every rule
violation raises a specific, catchable type the application layer can map to an
HTTP status without string-matching messages.*

The domain core signals every invariant breach by raising, never by returning
error codes or `None`. All exceptions descend from a single base so
infrastructure can `except BoatDexError` at the boundary.

## Hierarchy

```python
class BoatDexError(Exception):
    """Base for every domain-core invariant violation."""

class SelfFriendshipError(BoatDexError): ...      # canonical_pair(a, a)
class DuplicateEdgeError(BoatDexError): ...        # edge already exists for the pair
class AbsentEdgeError(BoatDexError): ...           # action on a non-existent edge
class InvalidTransitionError(BoatDexError): ...    # (state, action) not in the FSM table
class UnknownVesselError(BoatDexError): ...        # MMSI not resolvable
class UnknownRegionError(BoatDexError): ...        # region_id not in the region tree
class SightingValidationError(BoatDexError): ...   # future-dated / missing-region / malformed sighting
```

## Which invariant raises which

| Exception | Raised by | Trigger |
|-----------|-----------|---------|
| `SelfFriendshipError` | [[friendship-fsm]] `canonical_pair` | `a == b` |
| `DuplicateEdgeError` | friend service | request when a live edge exists |
| `AbsentEdgeError` | friend service | accept/decline/unfriend a missing edge |
| `InvalidTransitionError` | [[friendship-fsm]] `_apply` | illegal `(state, action)` |
| `UnknownVesselError` | sighting validation | MMSI not in `vessel` |
| `UnknownRegionError` | sighting validation | coarsened point maps to no region |
| `SightingValidationError` | sighting validation | `observed_at` in the future; region required but absent |

## Invariants

1. **Single root.** Every domain exception `isinstance(_, BoatDexError)`.
2. **No bare raises.** The domain core never raises `Exception`, `ValueError`,
   or `RuntimeError` directly for a domain rule — only these subclasses.
3. **Specificity.** Each invariant has its own subclass (no shared "generic
   error" for two distinct rules).

## Acceptance tests

**Example (pytest), one per invariant:**

- `test_self_friendship_raises` — `canonical_pair(7, 7)` ⇒ `SelfFriendshipError`.
- `test_invalid_transition_raises` — `accept` from `accepted` ⇒ `InvalidTransitionError`.
- `test_future_sighting_raises` — `observed_at > now` ⇒ `SightingValidationError`.
- `test_unknown_region_raises` — point outside the region tree ⇒ `UnknownRegionError`.

**Property:**

- `test_all_domain_errors_subclass_base` — reflection over the module: every
  public exception is a `BoatDexError` subclass (guards against a stray
  `ValueError` regressing in).

## Non-goals

- No HTTP status mapping here — that is an api-layer concern (a single
  `except BoatDexError` handler maps to 4xx).
- No error message i18n / user-facing copy — messages are developer-facing.

#type/concept #status/active #domain/backend #project/boatdex

## Related

- [[friendship-fsm|Friendship FSM]] — raises `SelfFriendshipError`, `InvalidTransitionError`
- [[rarity-surprisal|Rarity as regional surprisal]] — `UnknownRegionError`, `UnknownVesselError` upstream
- [[../06-features/_MOC|Features]] — the sighting-validation rules that raise `SightingValidationError`
- [[_MOC|Domain-core MOC]]
