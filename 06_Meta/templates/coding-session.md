---
title: "<Session title — what we worked on>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: session
status: done
project: <project-slug>
tags: [type/session, status/done, project/<project-slug>]
sources: []
---

# <Session title — what we worked on>

*<One-line summary used by `coding-sessions/_MOC.md`.>*

## Context

What we were trying to do at the start of the session, and the immediate
trigger. Two or three sentences.

## Decisions

What we decided and why. Link to `decisions/` notes for any choice with
multi-session consequences.

- Decision 1 — rationale.
- Decision 2 — rationale.

## What we did

Concrete actions, in order. Reference commits, files, branches by name.

1. ...
2. ...

## Code references

| File / module                | What changed                          |
|------------------------------|---------------------------------------|
| `path/to/file.py`            | <one line>                            |

Commits: `<short-sha>`, `<short-sha>` (link to repo if applicable).

## Outcome

State at end of session. What works, what doesn't, what's deferred.

- ✅ <thing that landed>
- ⚠️ <thing partially done>
- ❌ <thing blocked / failed>

## Next steps

Concrete, claimable items for the next session. Each starts with a verb.

- [ ] ...
- [ ] ...

## Related

- [[../_MOC|Project MOC]]
- [[../_README|Project README]]
- [[<concept-or-paper-this-session-touched>]]

#type/session #project/<project-slug> #status/done
