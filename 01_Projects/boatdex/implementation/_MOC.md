---
title: "MOC — BoatDex · Implementation (code truth)"
type: moc
created: 2026-07-06
updated: 2026-07-06
tags: [type/moc, project/boatdex]
---

# MOC — BoatDex · Implementation (code truth)

*The **implementation zone**: documentation authored by the coding agent while
building the BoatDex code repo (`github.com/MarioPasc/boatdex`). It records
**what was actually built** — code reality — and is kept **deliberately
disentangled** from the specification (the numbered areas `01-product` …
`11-roadmap` + `decisions/`, which describe **what to build**).*

## The disentanglement contract

- The numbered spec areas + `decisions/` = **design truth**, authored in vault
  sessions. The coding agent **reads** them and **never edits** them.
- This `implementation/` subtree = **code truth**, authored **only** by the
  coding agent (via its `impl-doc` skill in the boatdex repo).
- Every note here **links back** to the spec note(s) it implements (one-way:
  implementation → spec). Traceability without entanglement.

## Children

- [[progress|Progress board]] — live status: which specs are implemented, coverage %, milestone state (the first file to read when resuming a build)
- [[build-sessions/_MOC|Build sessions]] — dated logs of coding sessions (what changed, outcomes, next steps)
- [[code-decisions/_MOC|Code decisions]] — implementation ADRs (code-level choices; distinct from the design ADRs in `../decisions/`)
- [[code-notes/_MOC|Code notes]] — durable per-module documentation (how the code works, deviations from spec, gotchas)

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex
