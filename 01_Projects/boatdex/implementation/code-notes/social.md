---
title: "Code note — social"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: done
tags: [type/concept, project/boatdex, status/done]
---

# Code note — social

*`canonical_pair` for order-invariant friendship identity; FSM implemented as a single transition table with a single raise site (`assert_transition`).*

## Goal

Enforce friendship lifecycle rules (the FSM) in pure domain code; no persistence, no HTTP — only state validation and transition application.

## Key implementation facts

- **`canonical_pair(a: UUID, b: UUID) -> tuple[UUID, UUID]`**: returns `(min(a,b), max(a,b))` for order-invariant edge identity. Raises `SelfFriendshipError` if `a == b`.
- **FSM transition table** (`dict[FriendshipStatus, frozenset[FriendshipStatus]]`):
  - `PENDING` → `{ACCEPTED, DECLINED, BLOCKED}`
  - `ACCEPTED` → `{BLOCKED}`
  - `DECLINED` → `{PENDING}` (requester may re-send)
  - `BLOCKED` → `{}` (terminal — unblock = edge deletion, not a transition)
- **Single raise site**: `assert_transition(current: FriendshipStatus, target: FriendshipStatus) -> None` — raises `InvalidTransitionError` with `current` and `target` attrs if the transition is not in the table. All other functions call this one function, so the error path is defined in exactly one place.
- **`apply_transition(friendship: Friendship, target: FriendshipStatus, clock: Clock) -> Friendship`**: returns a new `Friendship` (frozen) with `status = target` and `updated_at = clock.now()`.
- **Unblock** is modelled as edge deletion (remove the `Friendship` row entirely), not as a `BLOCKED → UNBLOCKED` transition — per spec, there is no `UNBLOCKED` state.
- `DuplicateEdgeError` and `AbsentEdgeError` are raised by the repository layer (M2), not the FSM.

## Tests / coverage

`tests/domain/test_social.py`: `canonical_pair` symmetry + self-friendship, all valid transitions, all invalid transitions (each raises `InvalidTransitionError`), BLOCKED terminal, `apply_transition` timestamp update. 100% branch coverage.

#type/concept #project/boatdex #status/done

## Related

- [[../../05-domain-core/friendship-fsm|spec: friendship FSM]]
