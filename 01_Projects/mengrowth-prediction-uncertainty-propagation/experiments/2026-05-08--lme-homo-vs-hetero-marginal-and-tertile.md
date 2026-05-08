---
title: "LMEHomo vs LMEHetero — marginal calibration and σ²_v tertile stratification"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/lme, domain/uncertainty-propagation, domain/evaluation-metrics]
project: mengrowth-prediction-uncertainty-propagation
---

# LMEHomo vs LMEHetero — marginal calibration and $\sigma^2_v$ tertile stratification

*First empirical comparison of homoscedastic and heteroscedastic LME under LOPO `last_from_rest`. Marginal contrast is null; $\sigma^2_{v,*}$-tertile stratification reveals the textbook propagation pattern (sharper where data justifies, recovers coverage where homo under-covers).*

## Source documents

`UQ_THESIS_GAP_ANALYSIS.md` §4c · `UQ_CALIBRATION_STORY.md` · `UQ_HETERO_CALIBRATION_ANSWER.md`

## Setup

- **Cohort:** 56 patients, 179 scans (pre-QC).
- **Protocol:** LOPO `last_from_rest`, $N{=}56$ held-out targets.
- **Models:** LMEHomo $\varepsilon \sim \mathcal{N}(0, \sigma_n^2)$ vs LMEHetero $\mathrm{Var}(\varepsilon_{ij}) = \sigma_n^2 + \sigma^2_{v,ij}$, $\sigma^2_{v,ij}$ taken as known from the LoRA $M{=}20$ ensemble.
- **Predictive variance:** $s^{*2} = \mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^* + \mathbf{z}^{*\top}\widehat{\Omega}\mathbf{z}^* + \hat\sigma_n^2 (+ \sigma^2_{v,*})$ — FE term included after [[../decisions/0005--lme-predictive-variance-fe-term|0005]].
- **Metrics:** marginal mean width $\bar w_{95}$, coverage $\mathrm{cov}_{95}$, IS@95 (Winkler 1972; Gneiting & Raftery 2007), CRPS.
- **Stratification:** held-out $\sigma^2_{v,*}$ tertiles (low / mid / high), $n \approx 19$ each.

## Marginal results

| | $\bar w_{95}$ | $\mathrm{cov}_{95}$ | IS@95 | CRPS |
|---|---:|---:|---:|---:|
| LMEHomo   | 5.39 | 0.893 | — | flat |
| LMEHetero | 4.97 | 0.875 | — | flat |

Paired tests of $|\text{error}|$ are non-significant ($p \approx 0.4$).

## Tertile-stratified results

| Tertile | $n$ | LME IS@95 | LME cov | LMEHetero IS@95 | LMEHetero cov |
|---|---:|---:|---:|---:|---:|
| low  | 19 | 5.80  | 0.947 | 5.86  | 0.895 |
| mid  | 18 | 7.92  | 0.944 | 11.45 | 0.889 |
| **high** | **19** | **17.66** | **0.789** | **9.82** | **0.895** |

## Interpretation

- **Why marginal is null.** Empirical $\sigma^2_v$ is bimodal (median 0.0012, mean 0.4165, 6.1% of scans with $\sigma_v > 1$). REML satisfies the [[../notes/propagation-budget-identity|propagation budget identity]] $\hat\sigma^2_{n,\text{homo}} \approx \hat\sigma^2_{n,\text{het}} + \overline{\sigma^2_v}$ ($0.95 \approx 0.55 + 0.40$). The modal scan has $\sigma^2_{v,*} \ll \overline{\sigma^2_v}$, so $s^{*2}_{\text{het}} \approx 0.55 < s^{*2}_{\text{homo}} \approx 0.95$ — hetero is mechanically narrower than homo on the typical scan, which is why marginal coverage drops slightly.
- **Why conditional works.** In the high tertile, $\sigma^2_{v,*}$ is large; LMEHetero allocates extra width precisely to those scans, recovering coverage from 0.789 → 0.895 and cutting IS@95 nearly in half (17.66 → 9.82). LME-homo cannot do this without globally inflating $\sigma_n^2$.

## Status of the result after follow-ups

- Robust to $M$ ([[2026-05-08--sigma-v-stability-vs-m|σ²_v vs M]]).
- ~91% of the high-tertile gap is structural FE-variance fix, ~9% is genuine $\sigma^2_v$ propagation ([[2026-05-08--synthetic-variance-stresstest|stress test]]).
- High-tertile gap collapses to non-significance after QC ([[2026-05-08--qc-filter-collapse|QC filter collapse]]).

## Related

- [[../_MOC|Project MOC]]
- [[../decisions/0005--lme-predictive-variance-fe-term|0005 — FE term in predictive variance]]
- [[../notes/propagation-budget-identity|Propagation budget identity]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/lme #domain/uncertainty-propagation
