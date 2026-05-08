---
title: "Ensemble-size convergence — performance plateaus between k=10 and k=15"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty, domain/lora]
project: mengrowth-prediction-uncertainty-propagation
---

# Ensemble-size convergence — performance plateaus between $k=10$ and $k=15$

*BSF + LoRA ensemble performance plateaus between $k=10$ and $k=15$ members across all five LoRA ranks ($r \in \{2, 4, 8, 16, 32\}$). $M=20$ is sufficient without redundancy. The "tolerance from $m \geq 5$" the vault originally quoted does not appear in any thesis section.*

## Source

`sections/results/segmentation.tex`

## Setup

- **Universe.** $M = 20$ LoRA members per rank, seed-only randomisation.
- **Subset analysis.** For each rank and each $k = 1, \dots, 20$, evaluate Dice / per-region Dice / inter-member variance over random subsets.
- **Aggregations reported.** Performance vs $k$, consistent across all five LoRA ranks and across data-augmentation seeds.

## Result (qualitative — thesis does not typeset a numeric tolerance)

- **Plateau between $k=10$ and $k=15$.** Adding members beyond $k \approx 15$ produces no measurable Dice improvement and no measurable change in the inter-member variance estimate.
- **$M=20$ chosen.** Captures the plateau without redundancy; consistent across all 5 ranks and seeds.
- **No "$m \geq 5$" claim in the thesis.** The earlier vault entry stated cohort $\overline{\sigma^2_v}$ converges within $\pm 1\%$ from $m \geq 5$. That tolerance is not in `results/segmentation.tex`; it may exist in planning docs but is not typeset and not extractable from the result JSONs.

## Implication

- The post-QC null finding ([[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|main experiment]]) is not driven by ensemble-size undersampling. With $M=20$ past the plateau, the $\sigma^2_v$ vector represents the asymptotic procedural disagreement of the pipeline.
- This makes the post-QC null a stronger statement: the channel is information-poor on this cohort even at the pipeline's asymptotic resolution.

## Open TODO

- Cross-check the planning-doc "$\pm 1\%$ from $m \geq 5$" against `cohort_meta.json` and the pre-QC subset-sweep outputs. If reproducible, promote it back into the thesis with a citable number.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[../decisions/0004--ensemble-size-m20|0004 — M=20 ensemble size]]
- [[2026-05-08--bsf-lora-rank-sweep-segmentation|BSF + LoRA rank sweep]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty
