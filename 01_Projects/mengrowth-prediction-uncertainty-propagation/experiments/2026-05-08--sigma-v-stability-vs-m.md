---
title: "σ²_v stability vs ensemble size M"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty, domain/lora]
project: mengrowth-prediction-uncertainty-propagation
---

# $\sigma^2_v$ stability vs ensemble size $M$

*Sweep $m{=}2,\dots,20$ random subsets of the LoRA ensemble and check that cohort and per-tertile $\overline{\sigma^2_v}$, plus per-scan MC stability, are not undersampling artefacts. They are not: the choice $M{=}20$ is robust; results from $m{\geq}5$ would be qualitatively unchanged.*

## Source document

`UQ_SIGMA_V_VS_M_RESULTS.md`

## Setup

- **Universe:** $M=20$ LoRA members trained with seed-only randomisation.
- **Subset sweep:** for each $m \in \{2,\dots,20\}$, draw $S \in \{200, \dots, 500\}$ random subsets without replacement; compute $\sigma_v^{(m,s)} = \mathrm{SD}_{m \text{ members}}[\log(V^{(m)}+1)]$ for each scan.
- **Aggregations:** cohort mean $\overline{\sigma^2_v}(m)$, per-tertile means, per-scan MC stability (relative SD across the $S$ subsets at fixed $m$).

## Results

- **Cohort mean.** Converges within $\pm 1\%$ of the $m{=}20$ value from $m \geq 5$.
- **Per-tertile means.** Flat across the entire $m{=}2,\dots,20$ sweep; no regime where a different $m$ would change the ranking of low / mid / high.
- **Per-scan MC stability.** $\sigma_v(m)$ has $\leq 20\%$ relative SD by $m \approx 10$.

## Interpretation

The high-tertile conditional gap reported in [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|the homo-vs-hetero experiment]] is **not driven by undersampled segmentation uncertainty.** $M{=}20$ is past the elbow on every aggregation that matters; $M{\geq}10$ would not have changed the qualitative conclusion.

## Consequence for downstream questions

Anything that fails on this cohort — including the post-QC null and the eventual diagnostic of the candidate-metrics protocol — fails for reasons orthogonal to ensemble-size choice.

## Related

- [[../_MOC|Project MOC]]
- [[../decisions/0004--ensemble-size-m20|0004 — M=20 ensemble size]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Homo vs hetero marginal + tertile]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty
