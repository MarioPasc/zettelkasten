---
title: "BSF + LoRA rank sweep — segmentation Dice on BraTS-MEN held-out test"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/segmentation, domain/lora, domain/peft, domain/brainsegfounder]
project: mengrowth-prediction-uncertainty-propagation
---

# BSF + LoRA rank sweep — segmentation Dice on BraTS-MEN held-out test

*Sweep LoRA rank $r \in \{2, 4, 8, 16, 32\}$ at $\alpha = 2r$, dropout 0.1, $M=20$ ensemble. Frozen BSF baseline 0.632 mean Dice; LoRA r=2 jumps to 0.862 ($+0.230$, $p<0.001$). Final reported configuration: r=16. Marginal gain r=2 → r=32 is +0.017 Dice.*

## Source

`sections/results/segmentation.tex` (Table tab:model_complexity).

## Setup

- **Backbone.** BrainSegFounder SwinUNETR encoder.
- **Adapter.** LoRA on stages 1–4, modules $\{\text{kqv}, \text{proj}, \text{fc1}, \text{fc2}\}$, dropout 0.1.
- **Scaling.** $\alpha = 2r$ (i.e. scaling factor 2.0 across the sweep).
- **Decoder.** Frozen UNETR decoder ([[../decisions/0001--frozen-decoder-bsf-lora|0001]] — provisional).
- **Ensemble.** $M = 20$ members per rank, seed-only randomisation.
- **Test set.** BraTS-MEN held-out partition, 150 scans.

## Results

| Adapter | $\Delta W$ | Total params | Dice (mean ± 95% CI) | Mean inter-member Var |
|---|---:|---:|---:|---:|
| Frozen BSF | 0       | 62.19 M | 0.632 ± 0.065 | 0.0000 ± 0.0000 |
| LoRA r=2   | 46.1 K  | 62.24 M | 0.862 ± 0.035 | 0.0013 ± 0.0009 |
| LoRA r=4   | 92.2 K  | 62.28 M | 0.866 ± 0.035 | 0.0011 ± 0.0007 |
| LoRA r=8   | 184.3 K | 62.38 M | 0.871 ± 0.033 | 0.0014 ± 0.0009 |
| LoRA r=16  | 368.6 K | 62.56 M | 0.874 ± 0.032 | 0.0017 ± 0.0011 |
| LoRA r=32  | 737.3 K | 62.93 M | **0.879 ± 0.032** | 0.0017 ± 0.0011 |

## Per-region (Frozen BSF baseline)

- TC 0.650, WT 0.593, ET 0.653.

## Statistical comparison

- **LoRA r=2 vs Frozen BSF.** $\Delta$ Dice (mean) $= +0.230$; $p < 0.001$ (Wilcoxon signed-rank with Holm–Bonferroni correction).
- **Cohen's $d$ (LoRA r=2 vs Frozen).** TC 0.64, WT 0.77, ET 0.65. WT $\Delta$ Dice $= +0.249$ — largest single-region effect.
- **Adjacent-rank pairs (r=2 ↔ r=4, …, r=16 ↔ r=32).** Cohen's $d < 0.3$ for every adjacent pair; $\Delta$ Dice from r=2 to r=32 is $+0.017$. Statistical significance is overwhelmed by per-rank ensemble variance; effect-size is negligible at this granularity.

## Inter-member variance trend

- Lowest at r=4 (mean Var 0.0011); non-monotonic across the sweep.
- r=16 and r=32 plateau at Var 0.0017.
- Interpretation: the procedural-uncertainty channel (variance across seeds at fixed rank) does not scale meaningfully with adapter rank past r=8.

## Configuration chosen for downstream propagation

- **r = 16, $\alpha = 32$, dropout 0.1, $M = 20$.** Reported in `results/segmentation.tex` as the final configuration.

## Implications

- LoRA on BSF stages 1–4 lifts mean Dice by 0.247 over the frozen baseline at r=32 — a strong adaptation result.
- The per-region pattern (largest gain on WT) is consistent with meningiomas displacing surrounding tissue; the encoder LoRA captures the mass-effect cues that the frozen-anatomy backbone misses.
- The non-monotonic inter-member variance + flat marginal gains past r=2 question whether the rank sweep adds anything for the propagation chapter beyond r=8. Worth tying to [[../decisions/0006--candidate-metrics-staged-diagnostic|the candidate-metrics diagnostic]]: alternative summaries (boundary BALD, MEN-restricted entropy) might show stronger rank dependence than $\sigma^2_v$ does.
- Reinforces the open question on [[../decisions/0001--frozen-decoder-bsf-lora|0001]]: would training the decoder change the inter-member variance scaling, and would the resulting summary be more informative for propagation?

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[../decisions/0001--frozen-decoder-bsf-lora|0001 — frozen decoder]]
- [[../decisions/0004--ensemble-size-m20|0004 — M=20]]
- [[../../../03_Resources/papers/foundation-models/cox2024--brainsegfounder|Cox 2024 — BSF]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/segmentation #domain/lora
