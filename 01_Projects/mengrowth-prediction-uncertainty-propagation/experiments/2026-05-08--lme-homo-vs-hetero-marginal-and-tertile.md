---
title: "LMEHomo vs LMEHetero — main experiment (post-QC, N=54) is null at every level"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/lme, domain/uncertainty-propagation, domain/evaluation-metrics]
project: mengrowth-prediction-uncertainty-propagation
---

# LMEHomo vs LMEHetero — main experiment (post-QC, N=54) is null at every level

*Authoritative comparison from the thesis main experiment. LMEHomo and LMEHetero are indistinguishable to 4 significant figures both marginally and at every $\sigma^2_{v,*}$ tertile. The dramatic high-tertile recovery quoted earlier in this vault belongs to a separate pre-QC N=56 pilot, not the main experiment.*

## Source files

- `sections/results/growth.tex` — LaTeX (Stage-3 chapter currently `TODO`; no typeset table yet).
- `results/uncertainty_propagation_volume_prediction/main_experiment/LME_baseline/marginal_metrics.json`
- `.../main_experiment/LMEHetero_Zero_baseline/marginal_metrics.json`
- `.../main_experiment/LME_baseline/tertile_metrics.json`
- `.../main_experiment/LMEHetero_Zero_baseline/tertile_metrics.json`
- `.../main_experiment/cohort_meta.json` ($n_{\text{patients}}=54$, $n_{\text{scans}}=163$).

## Setup

- **Cohort.** 54 patients, 163 scans (post-SynthSeg-QC, $q \geq 0.80$). Cohort meta confirms: 16 scans / 4 patients dropped from the preprocessing set (179 / 58).
- **Protocol.** LOPO `last_from_rest`, 54 held-out targets.
- **Models.**
  - LMEHomo: $\varepsilon_{ij} \sim \mathcal{N}(0, \sigma_n^2)$.
  - LMEHetero: $\mathrm{Var}(\varepsilon_{ij}) = \sigma_n^2 + \sigma^2_{v,ij}$, $\sigma^2_{v,ij}$ from the LoRA $M{=}20$ ensemble of $\log(V+1)$, **floored at 0.001**.
- **Predictive variance** with FE term included (per [[../decisions/0005--lme-predictive-variance-fe-term|0005]]).
- **σ²_v cohort stats** (post-QC, floored at 0.001): median 0.001 (floor), mean 0.053, $q_{33}=0.001$, $q_{66}=0.004075$.

## Marginal results

| | $n$ | IS@95 | $\mathrm{cov}_{95}$ | CRPS | $\bar w_{95}$ | NLPD | $R^2_{\log}$ |
|---|---:|---:|---:|---:|---:|---:|---:|
| LMEHomo   | 54 | 8.2857 | 0.9074 | 0.6017 | 4.4186 | 1.7802 | 0.2544 |
| LMEHetero | 54 | 8.2866 | 0.9074 | 0.6017 | 4.4186 | 1.7803 | 0.2543 |

LMEHomo and LMEHetero are equivalent to four significant figures.

## Tertile-stratified results

Cuts $q_{33}=0.001$, $q_{66}=0.004075$ on $\sigma^2_v$:

| Tertile | $n$ | LMEHomo IS@95 | LMEHomo cov | LMEHetero IS@95 | LMEHetero cov |
|---|---:|---:|---:|---:|---:|
| low  | 28 | 9.413 | 0.893 | 9.415 | 0.893 |
| mid  | 9  | 4.861 | 0.889 | 4.861 | 0.889 |
| high | 17 | 8.242 | **0.941** | 8.242 | **0.941** |

**The conditional propagation pattern does not appear in the post-QC main experiment.** High tertile is *over-covered* under both models (0.941 > 0.95 nominal); LMEHetero adds nothing.

## Why hetero ≡ homo here

The post-QC $\sigma^2_v$ distribution is dominated by the floor at 0.001. With $q_{66}{=}0.004075$, even high-tertile observations carry $\sigma^2_{v,*}$ that is small relative to $\hat\sigma_n^2$, so the propagation term in $s^{*2}_{\text{het}} - s^{*2}_{\text{homo}} = \sigma^2_{v,*} - \overline{\sigma^2_v}$ ([[../notes/propagation-budget-identity|budget identity, qualitative]]) is comparable to the redistribution and the signed difference washes out across the cohort. Hetero buys nothing because there is nothing to buy.

## Pilot epoch — N=56 pre-QC synthetic stress test (separate)

This vault previously quoted "high-tertile IS@95 17.66 → 9.82, cov 0.789 → 0.895". Those numbers come from `previous_tests/synthetic_uq/summary_rows.json` (Profile A / c=0.001 / LME / seed 0, **N=56 pre-QC cohort**). The high-tertile LMEHomo IS@95 = 17.656 and cov_95 = 0.789 are reproducible from the pilot summary. **The LMEHetero IS@95 = 9.82 / cov = 0.895 are not reproducible from any current file** — they appear only in planning docs and may pre-date the main pipeline.

The pilot run is documented in [[2026-05-08--synthetic-variance-stresstest|the synthetic-variance stress-test note]], scoped explicitly to the pre-QC N=56 epoch.

## Statistical test

Paired Wilcoxon across seeds at $\tau{=}0$ (`aggregated/wilcoxon_results.json`): mean $\Delta\mathrm{IS} = +0.064$ (hetero slightly worse), median $p = 0.0059$, BH-rejected at $\alpha{=}0.05$ in **13/20 seeds**. See [[2026-05-08--smooth-shift-tau-sweep|τ-sweep]].

## Implication for the chapter

- The chapter cannot rest on the pilot's high-tertile recovery; the post-QC main experiment shows no gain.
- The candidate-metrics diagnostic ([[../decisions/0006--candidate-metrics-staged-diagnostic|0006]]) is the only remaining live route for H1.
- A clean Stage-1 reject would terminate the chapter as a defended negative result with the post-QC null as the headline.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Thesis-results reconciliation session]]
- [[2026-05-08--qc-filter-collapse|QC reframe]]
- [[2026-05-08--smooth-shift-tau-sweep|τ-sweep]]
- [[../decisions/0005--lme-predictive-variance-fe-term|0005 — FE term]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/lme #domain/uncertainty-propagation
