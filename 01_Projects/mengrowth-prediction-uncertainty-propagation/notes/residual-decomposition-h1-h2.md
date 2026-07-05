---
title: "Residual decomposition — H1 (wrong scalar) vs H2 (information-poor channel)"
created: 2026-05-08
updated: 2026-05-08
type: note
status: active
tags: [type/note, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/uncertainty-propagation, domain/growth-prediction]
project: mengrowth-prediction-uncertainty-propagation
---

# Residual decomposition — H1 (wrong scalar) vs H2 (information-poor channel)

*Decompose the held-out trajectory residual into segmentation, Gompertz-linearisation, and biological-volatility components. H1 ↔ exists a scalar from the LoRA ensemble that tracks the segmentation component; H2 ↔ no such scalar exists on this cohort.*

## Decomposition

For a held-out scan at time $t_*$ from patient $p$:

$$
\underbrace{y_* - \hat\mu_*^{\text{homo}}}_{\text{LME residual}} \;=\; \underbrace{\frac{\hat V_* - V_*^{\text{true}}}{V_*^{\text{true}}}}_{\delta_{\text{seg}}(t_*)} \;+\; \underbrace{\delta_{\text{Gompertz}}(t_*)}_{\text{model linearisation}} \;+\; \underbrace{\eta_{\text{biology}}(t_*)}_{\text{biological volatility}}.
$$

- **Segmentation residual** $\delta_{\text{seg}}$. Fractional error in the segmented log-volume relative to the true volume; observable in expectation through ensemble disagreement.
- **Gompertz linearisation** $\delta_{\text{Gompertz}}$. The LME assumes linear $\log V$ growth; meningiomas follow Gompertz/exponential dynamics, so a first-order linearisation accumulates error with $|t_* - \bar t_p|$. *Not observable from segmentation*.
- **Biological volatility** $\eta_{\text{biology}}$. Patient-level day-to-day fluctuations in growth rate (hormonal, perfusion, oedema). *Not observable from segmentation*.

## H1 — the right scalar exists

H1 says: $\sigma^2_v = \mathrm{Var}_m[\log(V^{(m)}+1)]$ is a *poor* projection of spatial ensemble disagreement onto a single number. A different scalar $c_k$ from the same $M{=}20$ ensemble — boundary BALD, MEN-restricted entropy, voxel-wise variance, the composite — could correlate with $\delta_{\text{seg}}$ and therefore with $|y_* - \hat\mu_*^{\text{homo}}|$, even though $\sigma^2_v$ does not.

If H1 is true: Stage 1 of the candidate-metrics diagnostic finds at least one candidate with $|\hat\rho| > 0.20$ and a CI excluding zero; Stage 2 can then improve IS@95 beyond the structural FE-variance fix.

## H2 — the channel is information-poor

H2 says: at this cohort scale ($N{=}54$ patients, $N{=}163$ post-QC scans), $\delta_{\text{Gompertz}}$ and $\eta_{\text{biology}}$ dominate the residual. Even a perfectly informative summary of the segmentation channel cannot improve calibration much, because the segmentation channel itself is a small fraction of the residual.

If H2 is true: Stage 1 of the candidate-metrics diagnostic rejects every candidate (incl. boundary BALD, MEN-restricted entropy, the composite) and the negative controls (`zero`, `constant_mean`, `permuted`) behave as expected. The chapter terminates as a defended negative result.

### Independent post-QC evidence already consistent with H2

After the [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|reconciliation against the thesis]], the post-QC main experiment is null at every level:

- LMEHomo and LMEHetero marginal IS@95 $= 8.2857$ vs $8.2866$, identical to 4 s.f. (`main_experiment/*/marginal_metrics.json`).
- Tertile-stratified high-tertile cell ($n=17$): IS@95 $= 8.242$ for both; cov_95 $= 0.941$ for both. No redistribution.
- $\tau$-sweep at $\tau = 0$: mean $\Delta\mathrm{IS} = +0.064$ (hetero slightly worse), 13/20 BH-rejected. The empirical $\sigma^2_v$ does not just *fail* to help — it slightly *hurts*. ([[../experiments/2026-05-08--smooth-shift-tau-sweep|τ-sweep]]).

The candidate-metrics Stage 1 has not been run yet; it could still keep H1 alive (a *different* scalar from the same ensemble could be informative). But the prior weight on H2 has shifted up: the simplest scalar derived from the LoRA ensemble is anti-informative on the post-QC cohort, not just non-informative.

## Why this is publishable either way

- **H1 outcome.** "We identified the right summary of segmentation uncertainty for propagation; downstream IS@95 improves by $\Delta$ on the high-tertile cell."
- **H2 outcome.** "Segmentation uncertainty does not predict trajectory residuals at any aggregation on this cohort; the dominant residual sources are Gompertz first-order linearisation and biological volatility, neither observable from segmentation. This is consistent with the small-$N$ + small-$\sigma^2_v$-dispersion bound from the synthetic stress test."

Both conclusions require a clean Stage-1 implementation with negative-control sanity checks; the current `spearman_results.json` empty state is a plumbing state, not evidence for H2.

## Open methodological questions implied by the decomposition

- Can $\delta_{\text{Gompertz}}$ be quantified by re-fitting the LME with a Gompertz-linearised growth rate as a fixed-effect covariate?
- Can $\eta_{\text{biology}}$ be approximated by a within-patient AR(1) residual process (current LME assumes independent $\varepsilon_{ij}$)?
- Are these orthogonal to the segmentation channel, or does the segmenter's behaviour partly correlate with one of them (e.g. larger lesions are easier to segment *and* further into their Gompertz plateau)?

## Related

- [[../_MOC|Project MOC]]
- [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 — staged diagnostic]]
- [[interval-score-saturation|IS saturation note]]
- [[../experiments/2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test]]

#type/note #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/growth-prediction
