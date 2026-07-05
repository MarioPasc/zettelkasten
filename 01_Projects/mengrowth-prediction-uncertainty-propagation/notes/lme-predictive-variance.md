---
title: "LME predictive variance decomposition"
created: 2026-05-08
updated: 2026-05-08
type: note
status: active
tags: [type/note, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# LME predictive variance decomposition

*Full predictive variance at a held-out time $t_*$ for a hierarchical linear mixed-effects model with optional heteroscedastic per-observation variance. Documents which terms each implementation includes.*

## Model

$$
y_{ij} = \mathbf{x}_{ij}^\top\boldsymbol\beta + \mathbf{z}_{ij}^\top\mathbf{u}_i + \varepsilon_{ij}, \quad \mathbf{u}_i \sim \mathcal{N}(\mathbf{0}, \Omega), \quad \mathrm{Var}(\varepsilon_{ij}) = \sigma_n^2 + \sigma^2_{v,ij},
$$

with $\sigma^2_{v,ij}$ known (LoRA-ensemble per-scan variance) and zero in the homoscedastic specification.

## Predictive distribution at a held-out point

Conditional on the data:

$$
\hat y_* = \mathbf{x}^{*\top}\hat\beta + \mathbf{z}^{*\top}\hat{\mathbf{u}}_{i(*)},
$$

$$
\boxed{\;s^{*2} = \underbrace{\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\,\mathbf{x}^*}_{\text{FE estimation}} + \underbrace{\mathbf{z}^{*\top}\widehat{\Omega}\,\mathbf{z}^*}_{\text{RE / BLUP}} + \hat\sigma_n^2 + \sigma^2_{v,*}\;}
$$

For LMEHomo, drop the last term. $\hat{\mathbf{u}}_{i(*)}$ is the BLUP of the random effects for the patient holding the held-out scan.

## What each implementation actually returns

| Implementation | FE | RE/BLUP | $\sigma_n^2$ | $\sigma^2_{v,*}$ |
|---|:---:|:---:|:---:|:---:|
| `statsmodels.MixedLM.predict` (default) | ✗ | ✗ | ✗ | ✗ |
| `statsmodels.MixedLM` + manual assembly | ✓ | ✓ | ✓ | ✗ |
| Project: `lme_model.py` (LMEHomo, post-fix) | ✓ | ✓ | ✓ | n/a |
| Project: `lme_hetero.py` (LMEHetero) | ✓ | ✓ | ✓ | ✓ |

The pre-fix project code matched `statsmodels` defaults — the FE term was missing. ~91% of the pre-QC high-tertile gap was the FE term, not the propagation ([[../experiments/2026-05-08--synthetic-variance-stresstest|stress test]]; [[../decisions/0005--lme-predictive-variance-fe-term|0005]]).

## Asymptotic interpretation

- $\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^* \to 0$ as $N \to \infty$ (parameter-estimation uncertainty vanishes).
- $\mathbf{z}^{*\top}\widehat{\Omega}\mathbf{z}^*$ does **not** vanish (population-level RE variance is irreducible from a single patient with finite history).
- $\hat\sigma_n^2$ does not vanish (irreducible residual at the population level).
- $\sigma^2_{v,*}$ is exogenous (set by the segmentation pipeline).

At the cohort scale of MenGrowth ($N{\approx}174$ observations), the FE-estimation term is non-negligible — confirming why omitting it changes calibration metrics materially.

## Related

- [[../_MOC|Project MOC]]
- [[propagation-budget-identity|Propagation budget identity]]
- [[../decisions/0005--lme-predictive-variance-fe-term|0005 — FE term in predictive variance]]

#type/note #project/mengrowth-prediction-uncertainty-propagation #domain/lme
