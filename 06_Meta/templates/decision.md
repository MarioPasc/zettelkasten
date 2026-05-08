---
title: "<NNNN — Decision Title>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: decision
status: active
tags: [type/decision, status/active, project/<slug>]
project: <slug>
deciders: ["Mario"]
---

# <NNNN — Decision Title>

*<One-line summary of what was decided.>*

## Context

What forced the decision. The constraints, the trade-offs visible at the
time. Two to four sentences.

## Considered options

1. **Option A** — <one line>. Pros: ..., Cons: ...
2. **Option B** — <one line>. Pros: ..., Cons: ...
3. **Option C** — <one line>. Pros: ..., Cons: ...

## Decision

The chosen option, in one paragraph. Explicit.

## Consequences

- ✅ ...
- ⚠️ ...
- 🔄 To revisit when: <trigger>

## Related

- [[../_MOC|Project decisions MOC]]
- [[../_README|Project README]]

#type/decision #project/<slug> #status/active
