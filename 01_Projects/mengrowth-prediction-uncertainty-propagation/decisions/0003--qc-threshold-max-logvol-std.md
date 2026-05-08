---
title: "0003 — QC threshold (SynthSeg q ≥ 0.80 in thesis; max_logvol_std=1.0 in planning docs)"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: active
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# 0003 — QC threshold (SynthSeg $q \geq 0.80$ in thesis; `max_logvol_std=1.0` in planning docs)

*The thesis defines the post-QC growth-model cohort via SynthSeg self-consistency $q \geq 0.80$. A separate `max_logvol_std=1.0` filter exists in planning docs but is not the QC step that produces the main-experiment cohort.*

## Two filters, different stages

| Filter | Where | Mechanism | Cohort effect |
|---|---|---|---|
| **SynthSeg $q \geq 0.80$** | `sections/results/preprocessing.tex` (thesis) | Per-study automated MR-segmentation reliability score | **179 → 163 scans, 58 → 54 patients (16 scans, 4 patients drop)** |
| `max_logvol_std = 1.0` | UQ_PRED planning docs in `MenGrowth-Model/docs/UQ_PRED` | Per-scan SD of $\log(V+1)$ across the LoRA $M{=}20$ ensemble | Described as dropping 11 scans from 179 — but this is on the pre-QC pre-SynthSeg cohort and is not applied in the main experiment as currently typeset |

## SynthSeg threshold (canonical, used in thesis)

- **Threshold.** $q \geq 0.80$.
- **Pass rate.** 170 / 179 (95.0%).
- **Below $q = 0.75$.** 5 studies; 4 belong to MenGrowth-0007 and MenGrowth-0025.
- **Cohort minimum.** $q = 0.547$ on MenGrowth-0007-000 (T1n slice spacing 7 mm, large convexity meningioma).
- **Spacing regression.** $\hat\beta_1 = -0.007$ (SE 0.001, $p < 0.001$); $\hat\sigma^2_u = 0.001$.
- **Deep-grey-matter acceptance.** Median CV 0.029 (threshold 0.05); all 6 DGM structures pass.

## Effect on calibration

The `max_logvol_std = 1.0` planning-doc framing predicted that filtering 11 high-$\sigma_v$ scans would *collapse* a high-tertile propagation gain. **The thesis main experiment does not show that gain in the first place** ([[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|main experiment]]) — LMEHomo and LMEHetero are equivalent to four significant figures at every level. The earlier vault framing of "QC collapses the effect" is therefore retired.

## Decision

- **Authoritative QC for the chapter:** SynthSeg $q \geq 0.80$, applied during preprocessing.
- **Stay-out filter:** `max_logvol_std = 1.0` is not currently applied. Document its existence in planning docs but flag that it has no impact on the post-QC main experiment as typeset.
- **Sensitivity analysis (TODO).** Sweep $q \in \{0.70, 0.75, 0.80, 0.85, 0.90\}$ on the SynthSeg threshold to characterise cohort-size vs reliability trade-off. Sweep `max_logvol_std` only if a downstream stage requires the filter.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[../experiments/2026-05-08--qc-filter-collapse|QC filter — defines post-QC cohort]]
- [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Main experiment]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation
