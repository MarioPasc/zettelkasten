---
title: "<Project Name>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: project
status: active
tags: [type/project, status/active, domain/<x>, project/<slug>]
project: <slug>
priority: p2
---

# <Project Name>

*<One-line elevator description. Used by `01_Projects/_MOC.md`.>*

## Goal

The single sentence stating what success looks like. If you can't write
this in one sentence, the project isn't framed yet.

## Context and motivation

Why this project, why now, what does it unlock. Three to five sentences.

## Stack

- **Code repo:** `<github-url-or-local-path>`
- **HPC:** Picasso (SLURM, Singularity, A100 40GB) / local
- **Frameworks:** PyTorch, MONAI, …
- **Datasets:** [[03_Resources/datasets/<dataset>|<Dataset>]], …

## Status

Updated weekly (or after major sessions). Keep it short.

- **Phase:** <feasibility | training | ablation | writing | wrap-up>
- **Last session:** [[coding-sessions/YYYY-MM-DDTHHMM--<slug>|<title>]]
- **Blockers:** <list, or "none">

## Roadmap

| Phase           | Goal                          | Target date | Status         |
|-----------------|-------------------------------|-------------|----------------|
| Feasibility     | ...                           | YYYY-MM-DD  | active         |
| Main training   | ...                           | YYYY-MM-DD  | not started    |
| Ablations       | ...                           | YYYY-MM-DD  | not started    |
| Writing         | ...                           | YYYY-MM-DD  | not started    |

## Key references

The 5–10 papers this project is built on. Link to literature notes.

- [[03_Resources/papers/<topic>/<paper-slug>|<Author><Year>]] — <why it matters>
- ...

## Open questions

- ...

## Related

- [[_MOC|Project MOC]]
- [[../_MOC|01_Projects MOC]]

#type/project #status/active #project/<slug>
