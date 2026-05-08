---
title: "Smooth-shift α-sweep and τ-scaling sweep — IS surface saturates"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation, domain/evaluation-metrics]
project: mengrowth-prediction-uncertainty-propagation
---

# Smooth-shift $\alpha$-sweep and $\tau$-scaling sweep — IS surface saturates

*Beta-family $\alpha$-sweep and exponential $\tau$-rescaling of $\sigma^2_v$ both confirm an analytic ceiling: no monotone rescaling of an information-poor ranking can add information. At $\tau{=}0$, $\Delta\mathrm{IS}{=}-0.04$ with 0/20 cells BH-rejected; the only τ regime that "works" brute-forces coverage and is marginally worse than homo on IS.*

## Source documents

`UQ_SMOOTH_SHIFT_STRESSTEST.md` · supplementary $\tau$-sweep results.

## Setup

- **Smooth-shift sweep.** Beta-family interpolation between empirical $\sigma^2_v$ and a constant baseline at parameter $\alpha \in [0,1]$.
- **τ-scaling sweep.** $\sigma^2_v(\tau) = \exp(\tau) \cdot \sigma^2_{v,\text{emp}}$, $\tau \in [-2, 12]$, paired BCa bootstrap, $B{=}10\,000$, BH-FDR over 20 seeds × 20 $\tau$ levels.
- **Metric.** $\Delta\mathrm{IS}@95$ vs LMEHomo, paired by held-out target.

## Results

- **τ = 0 (empirical).** $\Delta\mathrm{IS}@95 = -0.04$, **0/20 BH-rejections**.
- **τ moderately scaling up.** Marginal narrowing recovered for some scans, marginal coverage drops in others — net null.
- **τ ≥ 10.33.** Brute-force coverage: every interval covers nearly everything by inflated $\sigma^2_v$. $\Delta\mathrm{IS} \geq +11$ — **marginally worse than homo**.

## Why this had to fail — analytics

The Winkler/Gneiting-Raftery interval score at level $\alpha$ is

$$
\mathrm{IS}_\alpha(L, U; y) = (U - L) + \frac{2}{\alpha}\bigl[(L - y)_+ + (y - U)_+\bigr],
$$

so width is linear and the miss-penalty has a floor at zero. Monotone rescaling $\sigma^2_v \mapsto h(\sigma^2_v)$ for any monotone $h$ preserves the ranking of which scans are predicted to be noisy; it only stretches the width axis. Without a *better ranking* (i.e. higher rank correlation with $|y_* - \hat\mu_*^{\text{homo}}|$), the IS surface saturates at a level set by the existing informativeness of $\sigma^2_v$, which is already low (see [[2026-05-08--synthetic-variance-stresstest|stress test]]).

## Consequence

- **Rules out scaling-only fixes.** Any future claim that "we just need to scale $\sigma^2_v$ better" is contradicted by this experiment.
- **Refocuses on the candidate-metrics question.** Information has to come from a *different scalar* (boundary BALD, MEN-restricted entropy, composite), not from a *transform* of the existing $\sigma^2_v$.

## Related

- [[../_MOC|Project MOC]]
- [[../notes/interval-score-saturation|Interval Score saturation note]]
- [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 — candidate-metrics protocol]]
- [[2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/evaluation-metrics
