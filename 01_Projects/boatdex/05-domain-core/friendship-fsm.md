---
title: "Friendship finite state machine"
created: 2026-07-05
updated: 2026-07-05
type: concept
status: active
tags: [type/concept, status/active, domain/backend, project/boatdex]
aliases: ["friendship FSM", "canonical_pair", "friend edge"]
sources: []
---

# Friendship finite state machine

*The social graph is an undirected edge with an explicit state machine:
requests are mutual-consent, every edge is stored once in canonical order, and
only the transitions in the table are legal — everything else raises.*

BoatDex is **private-friends-only** (the resolved social-model decision): a
catalogue is readable iff it is yours or an *accepted* edge exists. That
authorization rule ([[../07-api/_MOC|API]]) rests on this FSM being correct, so
it is pure, table-driven, and 100%-branch-covered.

## Canonical edge

```python
def canonical_pair(a: UserId, b: UserId) -> tuple[UserId, UserId]:
    if a == b:
        raise SelfFriendshipError(a)
    return (a, b) if a < b else (b, a)
```

Every edge is stored as `(user_low, user_high)` with `user_low < user_high`
(mirrors the DB `CHECK` in [[../04-data-model/_MOC|the data model]]), so the
pair `{a, b}` has exactly one row regardless of who initiated.

## States and transitions

`FriendshipStatus ∈ {pending, accepted, declined, blocked}`.

| From | Action | To | Notes |
|------|--------|----|-------|
| — | request | `pending` | create edge; the requester side is recorded |
| `pending` | accept | `accepted` | only the *addressee* may accept |
| `pending` | decline | `declined` | |
| `pending` | block | `blocked` | |
| `accepted` | block | `blocked` | |
| `declined` | request | `pending` | re-request allowed |
| `blocked` | — | — | **terminal**: no legal transition; *unblock = delete the edge* (a repo op), then re-request |

Any `(state, action)` not in the table raises `InvalidTransitionError` from a
**single** raise site (one `_apply` function), so the illegal surface is one
tested branch, not scattered `if`s.

## Invariants

1. **Order invariance.** `canonical_pair(a, b) == canonical_pair(b, a)`.
2. **No self-edge.** `a == b ⇒ SelfFriendshipError`.
3. **Uniqueness.** At most one edge per unordered pair (enforced by canonical
   storage + DB unique constraint).
4. **Table completeness.** Exactly the listed transitions succeed; all others
   raise `InvalidTransitionError`.
5. **Terminality.** `blocked` has no successor state.
6. **Mutuality.** `accepted` requires a distinct addressee to have accepted a
   `pending` request (no self-accept, no accept of an already-`accepted` edge).

## Acceptance tests

**Property (hypothesis):**

- `test_canonical_order_invariant` — `∀ a≠b: canonical_pair(a,b) == canonical_pair(b,a)`.
- `test_self_pair_raises` — `∀ a: canonical_pair(a,a)` raises `SelfFriendshipError`.
- `test_fsm_table_exhaustive` — over the full `state × action` product, exactly
  the table cells succeed; every other cell raises `InvalidTransitionError`.

**Example (pytest):**

- `test_happy_path` — `request → pending → accept → accepted`.
- `test_rerequest_after_decline` — `declined → request → pending`.
- `test_blocked_is_terminal` — every action from `blocked` raises.

## Non-goals

- No follow/asymmetric model (private-friends-only was chosen; there are no
  public profiles to follow).
- No unblock *transition*: `blocked` is terminal; unblocking is **edge deletion**
  (like unfriend), after which a fresh `request` may start (decided 2026-07-06).
- Does not persist — persistence is a repository adapter; this is pure logic.

#type/concept #status/active #domain/backend #project/boatdex

## Related

- [[domain-exceptions|Domain exceptions]] — `SelfFriendshipError`, `InvalidTransitionError`
- [[catalogue-similarity|Catalogue similarity]] — comparison needs an `accepted` edge
- [[../04-data-model/_MOC|Data model]] — the `friendship` table and its `CHECK`
- [[_MOC|Domain-core MOC]]
