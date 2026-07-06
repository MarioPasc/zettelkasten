---
title: "Code note — social"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — social

*`canonical_pair` for order-invariant friendship identity; FSM encoded as a single `_TRANSITIONS` dict with a single raise site in `assert_transition`. There is no `apply_transition`.*

## Goal

Enforce friendship lifecycle rules (the FSM) in pure domain code; no persistence, no HTTP — only state validation and transition result.

## Key implementation facts

- **`FriendshipAction(StrEnum)`**: four variants — `REQUEST = "request"`, `ACCEPT = "accept"`, `DECLINE = "decline"`, `BLOCK = "block"`.
- **`canonical_pair(a: UUID, b: UUID) -> tuple[UUID, UUID]`**: returns `(a, b) if a < b else (b, a)` for order-invariant edge identity. Raises `SelfFriendshipError(a)` if `a == b`.
- **`_TRANSITIONS: dict[tuple[FriendshipStatus, FriendshipAction], FriendshipStatus]`** — the complete legality table (any pair absent is illegal):
  - `(PENDING, ACCEPT)` → `ACCEPTED`
  - `(PENDING, DECLINE)` → `DECLINED`
  - `(PENDING, BLOCK)` → `BLOCKED`
  - `(ACCEPTED, BLOCK)` → `BLOCKED`
  - `(DECLINED, REQUEST)` → `PENDING`
  - `BLOCKED` has no outgoing entries — it is terminal.
- **`assert_transition(current: FriendshipStatus, action: FriendshipAction) -> FriendshipStatus`**: looks up `(current, action)` in `_TRANSITIONS`; if absent, raises `InvalidTransitionError(current, action)`. This is the **single raise site** for all illegal-transition errors. Returns the resulting `FriendshipStatus`; callers apply it to the entity.
- There is **no `apply_transition`** function in this module.
- Unblock is modelled as edge deletion (remove the `Friendship` row entirely), not a state transition — there is no `UNBLOCKED` state.

## Tests / coverage

`tests/domain/test_social.py`: `canonical_pair` symmetry and self-friendship, all five legal transitions, illegal transitions (each raises `InvalidTransitionError`), `BLOCKED` terminal state. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/friendship-fsm|spec: friendship FSM]]
