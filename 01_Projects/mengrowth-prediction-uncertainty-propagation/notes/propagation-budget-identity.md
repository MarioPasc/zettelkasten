---
title: "Propagation budget identity (REML)"
created: 2026-05-08
updated: 2026-05-08
type: note
status: active
tags: [type/note, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/lme, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# Propagation budget identity (REML)

*REML, given a fixed total residual likelihood, splits the noise budget between the LME residual variance $\sigma_n^2$ and the per-scan injected variance $\sigma^2_{v,ij}$. Approximately:* $\hat\sigma^2_{n,\text{homo}} \approx \hat\sigma^2_{n,\text{het}} + \overline{\sigma^2_v}$.

> [!warning]
> The numerical instance ($0.95 \approx 0.55 + 0.40$) and the marginal-null framing in this note were derived from the **pre-QC N=56 pilot epoch**, not the post-QC N=54 main experiment. In the post-QC main experiment, $\sigma^2_v$ is floored at 0.001 with $q_{66}{=}0.004$ and the budget identity is empirically degenerate: $\overline{\sigma^2_v}_\text{post-QC} \approx 0.053$, and the REML residual variances of LMEHomo and LMEHetero match to four significant figures (see [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|main experiment]]). The identity below is conceptually correct as a leading-order REML decomposition; treat the specific numbers as illustrative of the pilot epoch only, and verify against the post-QC `*_baseline` REML estimates before citing in the thesis.

## Statement

Let $\hat\sigma^2_{n,\text{homo}}$ be the REML estimate of the residual variance under the homoscedastic LME

$$
y_{ij} = \mathbf{x}_{ij}^\top\boldsymbol\beta + \mathbf{z}_{ij}^\top\mathbf{u}_i + \varepsilon_{ij}, \quad \varepsilon_{ij}\sim\mathcal{N}(0,\sigma_n^2),
$$

and $\hat\sigma^2_{n,\text{het}}$ the residual variance under

$$
\mathrm{Var}(\varepsilon_{ij}) = \sigma_n^2 + \sigma^2_{v,ij}, \quad \sigma^2_{v,ij}\,\text{known from the LoRA ensemble}.
$$

Then to leading order:

$$
\hat\sigma^2_{n,\text{homo}} \;\approx\; \hat\sigma^2_{n,\text{het}} + \overline{\sigma^2_v}, \quad \overline{\sigma^2_v} = \frac{1}{N}\sum_{ij}\sigma^2_{v,ij}.
$$

Empirically on this cohort: $0.95 \approx 0.55 + 0.40$.

## Why it matters

Combine with the predictive-variance formula at a held-out time $t_*$:

$$
s^{*2}_{\text{homo}} = \mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^* + \mathbf{z}^{*\top}\widehat{\Omega}\mathbf{z}^* + \hat\sigma^2_{n,\text{homo}},
$$

$$
s^{*2}_{\text{het}} = \mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^* + \mathbf{z}^{*\top}\widehat{\Omega}\mathbf{z}^* + \hat\sigma^2_{n,\text{het}} + \sigma^2_{v,*}.
$$

Substituting:

$$
s^{*2}_{\text{het}} - s^{*2}_{\text{homo}} \;\approx\; \sigma^2_{v,*} - \overline{\sigma^2_v}.
$$

For the *modal* scan (where $\sigma^2_{v,*}$ is near the median, far below the mean because of bimodality), this is strongly negative: hetero is mechanically narrower than homo. For *high-tertile* scans, it flips sign and hetero is wider. This is the proximate explanation for the marginal-null / conditional-positive split in [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|the homo-vs-hetero experiment]].

## Practical consequence

- **Marginal coverage of LMEHetero is bounded above by REML's reallocation.** Even with a perfect $\sigma^2_v$, you only redistribute the budget; you don't add it.
- **The propagation mechanism is intrinsically conditional.** Marginal IS@95 / coverage are the wrong place to look for the effect.
- **A bimodal $\sigma^2_v$ distribution maximises this redistribution.** The post-QC distribution is *less* bimodal — which is exactly why the post-QC effect collapses to non-significance ([[../experiments/2026-05-08--qc-filter-collapse|QC filter collapse]]).

## Related

- [[../_MOC|Project MOC]]
- [[lme-predictive-variance|LME predictive variance decomposition]]
- [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Homo vs hetero result]]

#type/note #project/mengrowth-prediction-uncertainty-propagation #domain/lme #domain/uncertainty-propagation
