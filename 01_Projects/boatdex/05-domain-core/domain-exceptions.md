---
title: "Domain exceptions"
created: 2026-07-05
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["BoatDexError", "domain exception hierarchy"]
sources: []
---

# Domain exceptions

*One base exception and one subclass per domain invariant, so every rule
violation raises a specific, catchable type the api layer maps to an HTTP
status without string-matching messages — while genuine bugs raise builtin
`ValueError`/`TypeError`, kept deliberately separate.*

The domain core signals every invariant breach by raising, never by returning
error codes or `None`. All *domain* exceptions descend from a single base so
infrastructure can `except BoatDexError` at the boundary.

## Hierarchy

```python
class BoatDexError(Exception):
    """Base for every domain-core invariant violation."""

# — value-object / boundary-input validation (→ HTTP 422) —
class ValidationError(BoatDexError): ...           # base for value-object construction failures
class InvalidMmsiError(ValidationError): ...       # malformed, or kind != VESSEL
class InvalidImoError(ValidationError): ...        # IMO check digit fails
class InvalidCoordinateError(ValidationError): ... # lat/lon out of WGS84 range

# — business-rule invariants (→ HTTP 409 / 404 / 422) —
class SelfFriendshipError(BoatDexError): ...       # canonical_pair(a, a)
class DuplicateEdgeError(BoatDexError): ...        # edge already exists for the pair
class AbsentEdgeError(BoatDexError): ...           # action on a non-existent edge
class InvalidTransitionError(BoatDexError): ...    # (state, action) not in the FSM table
class UnknownVesselError(BoatDexError): ...        # vessel not resolvable
class UnknownRegionError(BoatDexError): ...        # region_id not in the region tree
class SightingValidationError(BoatDexError): ...   # future-dated / missing-region / malformed sighting
```

## Domain errors vs programming errors (the split)

Decision (2026-07-06). Not every failure is a domain exception. Rule of thumb
(Percival & Gregory, *Architecture Patterns with Python*):

- **Business-rule or boundary-input violation** — a user did something the
  domain forbids (self-friendship, illegal transition, malformed MMSI, unknown
  region). → a `BoatDexError` subclass, caught at the api boundary and mapped to
  a **4xx**. Part of the ubiquitous language.
- **Precondition / impossible-state violation** — a *bug*: a negative count or
  `α ≤ 0` reaching `rarity`, `distinct_vessels < 1`, a `None` where the type
  forbids one. → a **builtin `ValueError`/`TypeError`**, never a `BoatDexError`;
  it surfaces as a **500** because the caller — not the user — is at fault.

Concretely: `rarity(...)` with a negative `n_{v,r}` raises **`ValueError`**, not
a domain exception — reaching it means an adapter breached the
[[regional-presence-port|presence-port]] contract.

**Naming:** `<Context><Violation>Error`. **Structured attributes:** each carries
the offending value(s) — `InvalidMmsiError(value=..., kind=...)`,
`InvalidTransitionError(state=..., action=...)` — so handlers never parse
messages.

## Which invariant raises which

| Exception | Raised by | Trigger |
|-----------|-----------|---------|
| `InvalidMmsiError` | [[value-objects|`MMSI`]] ctor | malformed, or `kind != VESSEL` |
| `InvalidImoError` | [[value-objects|`IMO`]] ctor | check digit fails |
| `InvalidCoordinateError` | [[value-objects|`Coordinate`]] ctor | lat/lon out of range |
| `SelfFriendshipError` | [[friendship-fsm]] `canonical_pair` | `a == b` |
| `DuplicateEdgeError` | friend service | request when a live edge exists |
| `AbsentEdgeError` | friend service | accept/decline/unfriend a missing edge |
| `InvalidTransitionError` | [[friendship-fsm]] `_apply` | illegal `(state, action)` |
| `UnknownVesselError` | sighting validation | vessel not in `vessel` |
| `UnknownRegionError` | sighting validation | coarsened point maps to no region |
| `SightingValidationError` | sighting validation | `observed_at` in the future; region required but absent |

## Invariants

1. **Single root.** Every domain exception `isinstance(_, BoatDexError)`.
2. **No bare raises for a domain rule.** A domain *rule* raises a `BoatDexError`
   subclass, never a bare `Exception`. Builtin `ValueError`/`TypeError` are
   reserved for precondition *bugs* (the split above), not rules.
3. **Specificity.** Each invariant has its own subclass (no shared "generic
   error" for two distinct rules).

## Acceptance tests

**Example (pytest), one per invariant:**

- `test_self_friendship_raises` — `canonical_pair(7, 7)` ⇒ `SelfFriendshipError`.
- `test_invalid_transition_raises` — `accept` from `accepted` ⇒ `InvalidTransitionError`.
- `test_future_sighting_raises` — `observed_at > now` ⇒ `SightingValidationError`.
- `test_unknown_region_raises` — point outside the region tree ⇒ `UnknownRegionError`.
- `test_invalid_mmsi_raises` — an AtoN MMSI (`99…`) ⇒ `InvalidMmsiError`.
- `test_rarity_negative_count_raises_valueerror` — a negative count reaching
  `rarity` ⇒ builtin `ValueError` (a bug, **not** a `BoatDexError`).

**Property:**

- `test_all_domain_errors_subclass_base` — reflection over the module: every
  public exception is a `BoatDexError` subclass (guards against a stray
  `ValueError` regressing in as a "domain" error).

## Non-goals

- No HTTP status mapping here — that is an api-layer concern (a single
  `except BoatDexError` handler maps to 4xx; uncaught builtins → 500).
- No error message i18n / user-facing copy — messages are developer-facing.

#type/concept #status/active #domain/backend #project/boatdex

## Related

- [[value-objects|Value objects]] — raise the `ValidationError` family
- [[friendship-fsm|Friendship FSM]] — raises `SelfFriendshipError`, `InvalidTransitionError`
- [[rarity-surprisal|Rarity as regional surprisal]] — precondition bugs raise builtin `ValueError`
- [[../10-quality-and-ops/coding-standards|Coding standards]] — the domain-vs-builtin rule
- [[_MOC|Domain-core MOC]]
