---
title: "0002 — Model log(V+1) as the LME target"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: done
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/lme, domain/growth-prediction]
project: mengrowth-prediction-uncertainty-propagation
---

# 0002 — Model log(V+1) as the LME target

*Use $y_{ij} = \log(V_{ij}+1)$ (log-volume of the segmented meningioma plus one) as the LME response, not raw $V$ or $\log V$.*

## Decision

$$
y_{ij} = \log(V_{ij}+1), \quad V_{ij} \in [0, V_{\max}]\,\mathrm{mm}^3.
$$

## Rationale

- **Variance stabilisation.** Tumour volume is right-skewed across patients and within a trajectory; log-transform brings residuals closer to Gaussian, the LME assumption.
- **Multiplicative growth on natural scale.** Meningiomas grow proportionally to current volume in their slow-growing regime; $\log V$ linearises the trajectory and matches the Gompertz/exponential family used in the wider growth-prediction literature.
- **$+1$ regulariser for $V \to 0$.** Three observations in the cohort have segmented volume $0\,\mathrm{mm}^3$ (sub-cm³ tumours where ensemble members disagree on whether to predict any mask). Plain $\log V$ is undefined; $\log(V+1)$ keeps them in the analysis with a defined target.

## Trade-offs / consequences

- **Delta-method log-volume variance underestimates near zero.** $\sigma^2_{\log(V+1)} \approx \sigma^2_V / (V+1)^2$ shrinks rapidly as $V \to 0$; the $\sigma^2_v$ propagated into LMEHetero for sub-cm³ tumours is small even when the segmentation is unreliable. The QC threshold ([[0003--qc-threshold-max-logvol-std|0003]]) is the back-stop for this regime.
- **$+1$ makes $y$ depend on the volume unit.** All volumes are in $\mathrm{mm}^3$; switching to $\mathrm{cm}^3$ would change the bias of the $+1$ shift. Document the unit explicitly in any comparison.
- **Interpretation on the natural scale.** Forecasts of $\hat y_*$ map back via $\hat V_* = \exp(\hat y_*) - 1$; intervals on $\hat V_*$ are asymmetric.

## Related

- [[../_MOC|Project MOC]]
- [[../notes/lme-predictive-variance|LME predictive variance decomposition]]
- [[0003--qc-threshold-max-logvol-std|0003 — QC threshold]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/lme #domain/growth-prediction
