---
title: "0006 — Two-stage candidate-metrics diagnostic for the propagation channel"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: active
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/uncertainty-propagation, domain/evaluation-metrics]
project: mengrowth-prediction-uncertainty-propagation
---

# 0006 — Two-stage candidate-metrics diagnostic for the propagation channel

*Test, candidate by candidate, whether any scalar derived from the $M{=}20$ LoRA ensemble predicts trajectory residual difficulty. Stage 1 is a cheap rank-correlation gate; only Stage-1 passers are sent to Stage 2 (LOPO-LMEHetero with paired BCa).*

## Decision

Adopt the protocol specified in `UQ_CANDIDATE_METRICS_MOTIVATION.md`:

### Stage 1 — rank-correlation gate

For each candidate $c_k$ over the 54 LOPO targets, compute Spearman, Pearson, Kendall against $|y_k - \hat\mu_k^{\text{homo}}|$ with 95% BCa CI ($B{=}10\,000$). **Pass if $|\hat\rho| > 0.20$ and the CI excludes zero** (Steiger 1980).

Negative controls: `zero`, `constant_mean`, `permuted` — must fail.

### Stage 2 — downstream calibration (only Stage-1 passers)

Per (candidate, scaling) cell, run LOPO-LMEHetero, compute paired BCa $\Delta\mathrm{IS}@95$ vs LME-homo, BH-FDR at $q{=}0.05$. Cost: ~25 min on 8 cores per cell.

## Candidate list

- $\sigma^2_v$ baseline: $\mathrm{Var}_m[\log(V^{(m)}+1)]$
- `logvol-MAD`: $\mathrm{MAD}_m[\log(V^{(m)}+1)]$
- $\mathrm{CV}^2$ of volume: $\mathrm{Var}_m[V^{(m)}] / \overline{V}_m^2$
- mean predictive entropy
- BALD / mutual information (Houlsby 2011; Gal 2017)
- voxel-wise variance (mean over MEN-mask)
- MEN-restricted entropy / MI
- MEN-boundary entropy / MI (Wickstrøm 2020)
- composite: $\sigma^2_{\log V} \cdot (1 + \beta H_{\text{boundary, MEN}})$

## Rationale

- **The information-poor hypothesis (H2) needs evidence, not assumption.** A clean Stage-1 reject across all candidates *plus* the negative controls is the only honest way to claim that the LoRA ensemble carries no signal about trajectory residuals on this cohort.
- **Avoid wasted Stage-2 runs.** Stage 1 is $O(\text{seconds})$; Stage 2 is $O(25\,\text{min})$. A poorly correlated candidate cannot improve IS@95 (see [[../notes/interval-score-saturation|IS saturation note]]).
- **Steiger 1980 threshold.** $|\hat\rho| > 0.20$ at $n{=}54$ is a standard medium-effect bar with adequate power.

## Decision rule for the thesis chapter

| Stage 1 outcome | Live hypothesis | Chapter framing |
|---|---|---|
| Any candidate passes ($|\hat\rho|>0.20$, CI > 0) | **H1 alive** | "We identified the right summary of segmentation uncertainty for propagation." |
| All candidates reject (incl. boundary BALD, MEN-restricted entropy, composite) | **H2 confirmed** | "Segmentation uncertainty does not predict trajectory residuals at any aggregation on this cohort" — defended negative result, consistent with the small-$N$ + small-$\sigma^2_v$-dispersion bound from the synthetic stress test. |

## Open implementation thread

`spearman_results.json` currently contains `{"rho": NaN, "p": NaN, "n_levels": 0}` for every record — the loader has zero levels because candidate vectors are not yet wired. **Status: Stage 1 plumbing in place, candidate vectors pending.** Not evidence for H2.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1500--uq-propagation-stage1-synthesis|Stage 1 synthesis]]
- [[../notes/residual-decomposition-h1-h2|Residual decomposition: H1 vs H2]]
- [[../notes/interval-score-saturation|IS saturation under monotone rescaling]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/evaluation-metrics
