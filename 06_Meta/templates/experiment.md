---
title: "<YYYY-MM-DD — Experiment slug>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: experiment
status: active
tags: [type/experiment, status/active, project/<slug>]
project: <slug>
run_id: ""
hardware: "Picasso A100 40GB"
---

# <YYYY-MM-DD — Experiment slug>

*<One-line: what hypothesis this run tests.>*

## Hypothesis

A falsifiable statement. "If X then Y because Z."

## Setup

| Field         | Value                          |
|---------------|--------------------------------|
| Code commit   | `<short-sha>`                  |
| Branch        | `<branch>`                     |
| Config        | `<path/to/config.yaml>`        |
| Dataset       | [[03_Resources/datasets/<x>]]  |
| Splits        | train/val/test = .../...       |
| Seed          | 42                             |

### Hyperparameters (delta from baseline)

```yaml
optimizer: adamw
lr: 1e-4
batch_size: 4
# ...
```

## Run log

- `<HH:MM>` — submitted (`squeue` job id `<id>`)
- `<HH:MM>` — first checkpoint, val loss = ...
- ...

## Results

| Metric            | Baseline | This run | Δ      |
|-------------------|----------|----------|--------|
| 3D-FID (T1w)      |  ...     |  ...     |  ...   |
| ...               |  ...     |  ...     |  ...   |

## Verdict

Confirms / refutes / inconclusive. One paragraph.

## Next experiment

- [ ] ...

## Related

- [[../_MOC|Project experiments MOC]]
- [[../decisions/NNNN--<related-decision>]]

#type/experiment #project/<slug> #status/active
