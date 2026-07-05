---
title: "0005 — LME predictive variance includes the FE term x*ᵀ Cov(β̂) x*"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: done
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# 0005 — LME predictive variance includes the FE term $\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^*$

*Patch `lme_model.py` and `lme_hetero.py` to include the fixed-effect contribution in the predictive variance. Statsmodels' `MixedLM.predict` omits it by default; ~91% of the pre-QC high-tertile gap traces to this implementation difference.*

## Decision

Predictive variance at a held-out time $t_*$ for an LME with design row $\mathbf{x}^*$ and random-effect design row $\mathbf{z}^*$:

$$
s^{*2} \;=\; \underbrace{\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\,\mathbf{x}^*}_{\text{FE estimation}} \;+\; \underbrace{\mathbf{z}^{*\top}\widehat{\Omega}\,\mathbf{z}^*}_{\text{RE / BLUP}} \;+\; \hat\sigma_n^2 \;+\; \sigma^2_{v,*},
$$

where the last term is dropped for LMEHomo and equals the LoRA-ensemble per-scan variance for LMEHetero.

## Rationale

- **Statsmodels gap.** `MixedLM.predict` returns $\mathbf{x}^{*\top}\hat\beta$ but does *not* compose the FE-estimation variance into the prediction interval; downstream calibration metrics inherit a partial $s^{*2}$.
- **Effect on the propagation chapter.** The synthetic stress test (Profile A: constant $\sigma^2_v \equiv c$) recovers ~10 pp of high-tertile coverage and ~7 IS units relative to a `MixedLM`-default LMEHomo *without using $\sigma^2_v$ at all*. Of the LME→LMEHetero high-tertile $\Delta\mathrm{IS}@95 \approx -8$, **~91% is this structural FE-variance fix; ~9% is genuine $\sigma^2_v$ propagation** ([[../experiments/2026-05-08--synthetic-variance-stresstest|stress test]]).
- **Tests.** Custom REML in LMEHetero now produces intervals that strictly widen vs `MixedLM` baseline; new unit tests cover this.

## Consequence

Any pre-implementation-fix calibration result is unsafe to cite. The thesis baseline is the FE-corrected LMEHomo; the propagation gain is measured against this corrected baseline, not against `statsmodels.MixedLM`.

## Related

- [[../_MOC|Project MOC]]
- [[../experiments/2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test]]
- [[../notes/lme-predictive-variance|LME predictive variance decomposition]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/lme
