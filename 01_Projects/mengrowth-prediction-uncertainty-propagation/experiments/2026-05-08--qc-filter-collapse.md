---
title: "QC filter (max_logvol_std=1.0) collapses propagation effect to non-significance"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# QC filter (`max_logvol_std=1.0`) collapses propagation effect to non-significance

*Removing 11 segmentation-failure scans halves the headline high-tertile gain and brings $\Delta\mathrm{IS}@95$ to $p{=}0.43$. Half of the pre-QC propagation effect was carried by pipeline failures, not measurement noise.*

## Source document

`EXPERIMENT.md`

## Setup

- **Filter.** `max_logvol_std = 1.0` on the per-scan $\sigma_v = \mathrm{SD}_m[\log(V^{(m)}+1)]$ vector.
- **Drops 11/179 scans.** Inspection: 3 zero-volume targets (members disagree on whether to predict any mask), sub-cm³ tumours where mask presence is binary across the ensemble, FOV-edge cases.
- **Cohort.** Pre-QC: 56 patients, 179 scans. Post-QC: 54 patients, 163 scans. The 11 drops concentrate in 2 patients with otherwise valid trajectories.
- **Statistical test.** Paired BCa bootstrap on $\Delta$ metrics in the high-tertile cell.

## Results — high-tertile contrasts

| Contrast | $\Delta\mathrm{IS}@95$ | $p$ | $\Delta\mathrm{cov}_{95}$ | $p$ |
|---|---:|---:|---:|---:|
| LME → LMEHetero (no QC, $n{=}19$) | $-7.84$ | 0.22 | $+0.105$ | 0.25 |
| LME → LMEHetero (with QC, $n{=}17$) | $-3.28$ | 0.43 | $+0.118$ | 0.25 |

## Interpretation

- **Half the headline came from failures.** $-7.84 \to -3.28$ is a 58% reduction in the IS@95 effect.
- **Post-QC effect is not statistically significant** at any conventional threshold. The clean-cohort $\sigma^2_v$ distribution does not have enough dispersion to exercise the propagation mechanism at $N{=}54$.
- **The QC filter is a methodological correction, not a results-massaging step.** The 11 dropped scans are pipeline failures; reporting only the pre-QC headline would attribute to measurement noise an effect that is partly a consequence of the segmenter occasionally failing to detect the tumour.

## Consequence for the thesis chapter

- Both pre- and post-QC results must be reported.
- The sensitivity analysis sweeping the QC threshold $\{0.5, 0.75, 1.0, 1.25, 1.5\}$ is a TODO ([[../decisions/0003--qc-threshold-max-logvol-std|0003]]); without it the threshold is a free hyperparameter.
- This experiment is the strongest argument that, on this cohort, the propagation mechanism cannot rescue the chapter on its own — only a more informative summary (candidate-metrics) or a larger / dispersively richer cohort could.

## Related

- [[../_MOC|Project MOC]]
- [[../decisions/0003--qc-threshold-max-logvol-std|0003 — QC threshold]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Pre-QC homo-vs-hetero result]]
- [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 — candidate-metrics protocol]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation
