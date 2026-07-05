---
title: "0004 — Use M=20 LoRA ensemble members for procedural uncertainty"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: done
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty, domain/lora]
project: mengrowth-prediction-uncertainty-propagation
---

# 0004 — Use $M = 20$ LoRA ensemble members

*$M=20$ seed-randomised LoRA fine-tunes per architecture. Robustness verified empirically: cohort and per-tertile $\overline{\sigma^2_v}$ are stable from $m \geq 5$.*

## Decision

Train $M{=}20$ LoRA members per architecture (encoder LoRA on stages 1–4, modules `{kqv, proj, fc1, fc2}`, frozen decoder). Members differ only in initialisation seed.

## Rationale

- **Convergence of cohort mean** $\overline{\sigma^2_v}$ within $\pm 1\%$ from $m \geq 5$ over $S{=}200$–$500$ random subsets ([[../experiments/2026-05-08--sigma-v-stability-vs-m|σ²_v stability sweep]]).
- **Per-tertile means flat** across the entire $m{=}2{\dots}20$ sweep; no regime where conditional results would change with more or fewer members.
- **Per-scan MC stability** of $\sigma_v(m)$ reaches $\leq 20\%$ relative SD by $m \approx 10$, an order of magnitude smaller than the bimodality the propagation depends on.

## Consequence

The high-tertile conditional gap and its post-QC collapse are **not** driven by undersampled procedural uncertainty. Anything that is going to fail on this cohort is going to fail equally with $M=20$ or $M=10$.

## Trade-offs

- **Compute cost.** 20 members × per-member training cost; tractable on a single A100 over a long run.
- **Procedural-only.** $M=20$ samples the procedural component of epistemic uncertainty (random seed). It does *not* sample the data component (training-set resampling); per [[../../../03_Resources/papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026]], the resulting $\sigma^2_v$ is a lower bound on total epistemic uncertainty.

## Related

- [[../_MOC|Project MOC]]
- [[../experiments/2026-05-08--sigma-v-stability-vs-m|σ²_v stability vs M]]
- [[../../../03_Resources/concepts/procedural-uncertainty|Procedural uncertainty (concept)]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty
