---
title: "QC filter (SynthSeg q ≥ 0.80) defines the post-QC cohort; main experiment is null"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# QC filter (SynthSeg $q \geq 0.80$) defines the post-QC cohort; main experiment is null

*The thesis QC is a SynthSeg self-consistency floor at $q{=}0.80$, not the `max_logvol_std=1.0` filter the planning docs sketch. Sixteen scans (4 patients) drop, leaving 54 patients / 163 scans. On this cohort LMEHomo ≡ LMEHetero at every level — the propagation effect does not exist post-QC, it is not "weakened" or "non-significant".*

## Source files

- `sections/results/preprocessing.tex` — typeset QC criterion, threshold, dropped scans, spacing regression.
- `main_experiment/cohort_meta.json` — $n_{\text{patients}}=54$, $n_{\text{scans}}=163$.
- `main_experiment/{LME,LMEHetero_Zero}_baseline/marginal_metrics.json` and `tertile_metrics.json`.

## Filter

- **Metric.** SynthSeg self-consistency score $q$ (per-study automated MR-segmentation reliability).
- **Threshold.** $q \geq 0.80$. Authors' reliability floor.
- **Pass rate.** 170 / 179 studies (95.0%) at or above threshold.
- **Below $q{=}0.75$.** 5 studies; 4 of them belong to MenGrowth-0007 and MenGrowth-0025.
- **Cohort minimum.** $q = 0.547$ on MenGrowth-0007-000 (T1n slice spacing 7 mm, large convexity meningioma).
- **Spacing regression.** $\hat\beta_1 = -0.007$ ($\mathrm{SE}=0.001$, $p<0.001$); $\hat\sigma^2_u = 0.001$.
- **Deep-grey-matter acceptance.** Observed median CV = 0.029 (threshold 0.05); all 6 DGM structures pass individually.

## Effect on cohort

| | Patients | Scans |
|---|---:|---:|
| Preprocessing set | 58 | 179 |
| Post-QC growth-model cohort | 54 | 163 |
| **Drops** | **4** | **16** |

(Vault previously stated "11 scans, 2 patients" — paraphrased from a planning-doc max_logvol_std filter, not the SynthSeg-QC the thesis applies.)

## Effect on growth-prediction calibration

The vault originally framed this experiment as "QC collapses the propagation effect from $p{=}0.22$ to $p{=}0.43$". The thesis main-experiment numbers do not support that framing. Post-QC, **LMEHomo and LMEHetero are equivalent at four significant figures both marginally and at every tertile** ([[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|main experiment]]). There is no effect to "collapse"; the cleaned cohort simply has a $\sigma^2_v$ distribution dominated by the floor at 0.001 ($q_{66}=0.004$), which leaves no dispersion for hetero to redistribute.

## On the `max_logvol_std=1.0` filter

The earlier vault entries described `max_logvol_std=1.0`, which would drop the segmentation-failure tail of the LoRA-ensemble $\sigma_v$ distribution. That filter exists in planning docs (UQ_PRED) but is **not** the QC the thesis applies to define the main-experiment cohort. The two filters could co-exist (SynthSeg upstream, ensemble-stddev-cap downstream); the thesis as currently typeset only documents the SynthSeg one. See [[../decisions/0003--qc-threshold-max-logvol-std|0003]].

## Implication

- The post-QC main-experiment null is the **headline** finding for the propagation chapter.
- Pre-QC pilot effects (high-tertile IS@95 17.66 → ~9.82) belong to a different cohort and a different pipeline state; report them as pilot results only, not as the main result.
- Sensitivity to the QC threshold is still worth a sweep (e.g. $q \in \{0.70, 0.75, 0.80, 0.85, 0.90\}$ for SynthSeg), but the candidate-metrics diagnostic is the higher-leverage next step.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[../decisions/0003--qc-threshold-max-logvol-std|0003 — QC threshold]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Main experiment — homo vs hetero]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation
