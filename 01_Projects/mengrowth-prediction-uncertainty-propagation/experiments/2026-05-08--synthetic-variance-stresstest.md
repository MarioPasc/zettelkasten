---
title: "Synthetic variance stress test — 16 profile×level cells, 10 seeds"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: done
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# Synthetic variance stress test — 16 profile × level cells, 10 seeds

*Inject controlled $\sigma^2_v$ vectors while holding $y$-targets fixed; decompose the LME→LMEHetero high-tertile $\Delta\mathrm{IS}@95 \approx -8$ into structural and propagation components. Conclusion: ~91% structural, ~9% genuine propagation; informativeness (Profile E) beats matched-mean dispersion (Profile B).*

## Source documents

`UQ_SYNTHETIC_VARIANCE_STRESSTEST.md` (design) · `UQ_SYNTHETIC_VARIANCE_STRESSTEST_RESULTS.md` (results).

## Setup

- **Targets fixed.** Same LOPO `last_from_rest` $y$ vector as [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|the homo-vs-hetero experiment]].
- **Injection profiles** for $\sigma^2_v$:
  - **A**: constant $\sigma^2_v \equiv c$ across all scans.
  - **B**: random matched-mean dispersion (no rank correlation with the truth).
  - **D**: log-normal $\tau$-sweep with mean fixed.
  - **E**: empirical pass-through (the actual LoRA-ensemble $\sigma^2_v$).
- **Levels:** 16 profile × level cells, 10 random seeds each → 160 LMEHetero LOPO fits.
- **Reference baseline:** statsmodels `MixedLM` LMEHomo (no FE term in predictive variance, by default).

## Results — high-tertile IS@95

- **Profile A (constant $\sigma^2_v$).** Recovers ~10 pp of high-tertile coverage and ~7 IS units relative to `MixedLM`-default LMEHomo, **without using any informative $\sigma^2_v$**. Diagnoses a structural baseline gap.
- **Profile D ($\tau$-sweep).** Pure dispersion at fixed mean monotonically inflates high-tertile width $5.51 \to 5.84$, $\mathrm{cov}_{95}$ creeps $0.893 \to 0.912$. Clean causal evidence for redistribution but the magnitude is small.
- **Profile E (empirical pass-through).** **Lowest IS@95 in the sweep**: 9.82, vs Profile B 11.71 and Profile D ($\tau{=}2$) 10.26 at matched mean. The advantage is the rank correlation between empirical $\sigma^2_v$ and which scans actually have large residuals — i.e. the *informativeness* of the channel, not just its dispersion.

## Decomposition

Of the LME→LMEHetero high-tertile $\Delta\mathrm{IS}@95 \approx -8$:

- **~91% structural** — the FE-variance term that `MixedLM` omits but LMEHetero (custom REML) includes (see [[../decisions/0005--lme-predictive-variance-fe-term|0005]]).
- **~9% genuine $\sigma^2_v$ propagation** — the remainder attributable to informativeness above and beyond Profile A.

## Implication

The propagation arrow exists but is small on this cohort. The headline gap reported in earlier docs is dominated by an implementation difference, not by the scientific mechanism the chapter is about. This is the strongest internal motivation for [[../decisions/0006--candidate-metrics-staged-diagnostic|0006]]: *if* a different scalar from the ensemble has higher informativeness than $\sigma^2_v$, propagation could become more than 9% of the gap. If no candidate is informative, the chapter terminates as a defended negative result.

## Related

- [[../_MOC|Project MOC]]
- [[../decisions/0005--lme-predictive-variance-fe-term|0005 — FE term in predictive variance]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Homo vs hetero — marginal + tertile]]
- [[2026-05-08--smooth-shift-tau-sweep|Smooth-shift α-sweep and τ-scaling]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/lme
