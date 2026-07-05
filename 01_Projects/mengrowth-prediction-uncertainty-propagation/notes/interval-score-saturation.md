---
title: "Interval Score saturation under monotone rescaling"
created: 2026-05-08
updated: 2026-05-08
type: note
status: active
tags: [type/note, project/mengrowth-prediction-uncertainty-propagation, status/active, domain/evaluation-metrics, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# Interval Score saturation under monotone rescaling

*The Winkler/Gneiting–Raftery interval score has linear width and a miss-penalty floored at zero. No monotone rescaling of an information-poor ranking can add information; the IS surface saturates at a level set by the existing rank correlation between the predictor and the target residual.*

## The interval score

For a central $(1-\alpha)$ prediction interval $[L, U]$ and observed $y$,

$$
\mathrm{IS}_\alpha(L, U; y) \;=\; (U - L) \;+\; \frac{2}{\alpha}\bigl[(L - y)_+ + (y - U)_+\bigr].
$$

Width $(U - L)$ is linear; the miss penalty $\bigl[(L-y)_+ + (y-U)_+\bigr]$ is non-negative with a floor at zero (Gneiting & Raftery 2007, *JASA*).

## Why monotone rescaling cannot help

Suppose the per-scan predictive SD is $\sigma_*$ and the held-out residual is $r_* = y_* - \hat\mu_*$. Under a Gaussian predictive distribution, $L_* = \hat\mu_* - q_\alpha\sigma_*$, $U_* = \hat\mu_* + q_\alpha\sigma_*$, $q_\alpha = z_{1-\alpha/2}$.

Apply a monotone rescaling $\sigma_* \mapsto h(\sigma_*)$:

- The **ranking** of $\sigma_*$ across scans is preserved.
- The **width axis** stretches according to $h$.
- The **miss penalty** changes only via the floor at zero.

The expected IS is

$$
\mathbb{E}[\mathrm{IS}_\alpha] \;=\; 2 q_\alpha\,\mathbb{E}[h(\sigma_*)] \;+\; \frac{2}{\alpha}\,\mathbb{E}\bigl[(|r_*| - q_\alpha h(\sigma_*))_+\bigr].
$$

Differentiating with respect to $h$ at fixed ranking: the only way to reduce $\mathbb{E}[\mathrm{IS}_\alpha]$ beyond a saturation floor is to *re-rank* the per-scan widths so that wider intervals coincide with larger $|r_*|$. Monotone rescaling cannot re-rank. The minimum achievable IS at fixed ranking is bounded below by the rank-correlation structure of $(\sigma_*, |r_*|)$.

## Implication for the propagation chapter

- The $\tau$-sweep ([[../experiments/2026-05-08--smooth-shift-tau-sweep|τ-scaling experiment]]) saturates at $\tau{=}0$ ($\Delta\mathrm{IS}{=}-0.04$) and degrades for large $\tau$ (brute-force coverage with width inflation).
- *Information must come from a different ranking*, not from a transform of the existing one. This is the analytic basis for the candidate-metrics protocol ([[../decisions/0006--candidate-metrics-staged-diagnostic|0006]]).
- A Stage-1 rank-correlation gate ($|\hat\rho| > 0.20$ Steiger 1980) is the right test: only rank correlation determines whether Stage 2 can deliver $\Delta\mathrm{IS}<0$.

## Related

- [[../_MOC|Project MOC]]
- [[../experiments/2026-05-08--smooth-shift-tau-sweep|τ-sweep saturation result]]
- [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 — staged diagnostic]]

#type/note #project/mengrowth-prediction-uncertainty-propagation #domain/evaluation-metrics #domain/uncertainty-propagation
