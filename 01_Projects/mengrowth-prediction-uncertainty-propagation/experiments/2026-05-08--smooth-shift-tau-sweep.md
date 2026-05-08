---
title: "τ-sweep — at τ=0 hetero is slightly worse (+0.064 IS@95), 13/20 BH-rejected"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation, domain/evaluation-metrics]
project: mengrowth-prediction-uncertainty-propagation
---

# τ-sweep — at $\tau=0$ hetero is slightly worse (+0.064 IS@95), 13/20 BH-rejected

*Exponential rescaling $\sigma^2_v(\tau) = e^\tau \sigma^2_{v,\text{emp}}$ on the post-QC cohort. At the empirical baseline $\tau{=}0$, mean $\Delta\mathrm{IS}@95 = +0.064$ (hetero slightly worse) and 13/20 seeds reject paired Wilcoxon under BH-FDR ($\alpha=0.05$). Earlier vault entry ("$\Delta=-0.04$, 0/20 BH-rejected") was wrong on sign, magnitude, and rejection count.*

## Source

`results/uncertainty_propagation_volume_prediction/main_experiment/aggregated/wilcoxon_results.json`

## Setup

- **Cohort.** Post-QC main experiment, 54 patients / 163 scans.
- **Rescaling.** $\sigma^2_v(\tau) = \exp(\tau) \cdot \sigma^2_{v,\text{empirical}}$.
- **Range.** $\tau \in \{-7.105, -4.614, -2.124, 0.000, 2.857, 5.348, 7.839, 10.329, 12.820\}$ (9 levels).
- **Seeds.** 20.
- **Test.** Paired Wilcoxon ΔIS@95 (LMEHetero − LMEHomo); BH-FDR over the 20 seeds at $\alpha=0.05$.

## Results

| $\tau$ | mean $\Delta\mathrm{IS}@95$ | median $p$ | BH rejected / 20 |
|---:|---:|---:|---:|
| $-7.105$ | $+0.001$ | 0.0002 | 20/20 |
| $-4.614$ | $+0.002$ | 0.0008 | 14/20 |
| $-2.124$ | $+0.016$ | 0.0038 | 14/20 |
| **$0.000$** | **$+0.064$** | **0.0059** | **13/20** |
| $+2.857$ | $-0.071$ | 0.0108 | 11/20 |
| $+5.348$ | $+1.595$ | 0.0019 | 12/20 |
| $+7.839$ | $+5.500$ | $<10^{-4}$ | 20/20 |
| $+10.329$ | $+16.586$ | $<10^{-4}$ | 20/20 |
| $+12.820$ | $+19.642$ | $<10^{-4}$ | 20/20 |

## Reading

- **$\tau \to -\infty$.** Hetero converges to homo (the propagation term vanishes); $\Delta\mathrm{IS}$ near zero. The 20/20 rejection at $\tau{=}-7.105$ is a sign that hetero is systematically and slightly *worse* than homo even when the perturbation is tiny — consistent with seed-level precision artifacts, not a meaningful effect.
- **$\tau{=}0$ (empirical $\sigma^2_v$).** Mean $\Delta\mathrm{IS}@95 = +0.064$. Hetero is *worse* on average, with 13/20 seeds individually significant. This is a stronger version of the post-QC null than the synthesis suggested: the propagation term does not just fail to help, it slightly *hurts* with the empirical $\sigma^2_v$.
- **$\tau{=}+2.857$.** The only level with negative $\Delta\mathrm{IS}$ ($-0.071$), but with 11/20 rejections — a marginal signal that may reflect coverage gain from inflated widths in the high tail rather than true informativeness.
- **$\tau \geq +5.348$.** Brute-force coverage: widths inflate, IS rises monotonically as the variance overwhelms the data.

## Interpretation

- Confirms the IS-saturation analytics ([[../notes/interval-score-saturation|note]]): monotone rescaling cannot recover information that the ranking does not have.
- **Sharper than before.** With the corrected numbers, the τ-sweep is a positive argument for H2 — at $\tau{=}0$ the empirical $\sigma^2_v$ is slightly *anti-informative* on this cohort.
- The pre-QC pilot's apparent benefit at $\tau{=}0$ does not survive QC.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[../notes/interval-score-saturation|IS saturation note]]
- [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 — candidate-metrics protocol]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Main experiment — homo vs hetero]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/evaluation-metrics
