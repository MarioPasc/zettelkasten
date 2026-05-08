---
title: "Meningioma Growth Prediction via Procedural Uncertainty Propagation to LME"
created: 2026-05-08
updated: 2026-05-08
type: project
status: active
tags: [type/project, status/active, domain/meningioma, domain/brain-mri, domain/segmentation, domain/longitudinal, domain/uncertainty, domain/uncertainty-propagation, domain/growth-prediction, domain/foundation-model, domain/brainsegfounder, domain/lora, domain/peft, domain/lme, project/mengrowth-prediction-uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
priority: p2
---

# Meningioma Growth Prediction via Procedural Uncertainty Propagation to LME

*Predict meningioma volumetric growth from longitudinal MRI by propagating procedural (epistemic) segmentation uncertainty into a heteroscedastic Linear Mixed-Effects model.*

## Goal

Show that a heteroscedastic LME with per-observation variance derived from
deep-ensemble segmentation uncertainty achieves better Interval Score
(higher sharpness at matched calibration) on patient-level log-volume
trajectories than a homoscedastic LME baseline.

## Context and motivation

Meningioma growth is slow, irregular, and often subclinical. Clinical
decisions (watch-and-wait vs. resection vs. radiotherapy) hinge on
volumetric trajectories estimated from sparse longitudinal MRI. Volumes
are not measured — they are *segmented*, and segmentation noise is large
relative to growth. Most growth models ignore this noise or treat it as
homoscedastic. Procedural uncertainty (deep-ensemble disagreement on the
same architecture) is a low-bound estimate of epistemic uncertainty
([[03_Resources/papers/uncertainty/_MOC|uncertainty MOC]]) and provides a
per-study variance that can be propagated into the observation noise of
an LME. The hypothesis: heteroscedastic LME with this variance produces
sharper, well-calibrated 1-year-ahead volume forecasts.

## Stack

- **Code repo:** `/home/mpascual/research/code/MenGrowth-Model`
- **Segmentation repo:** BSF + LoRA training pipeline (separate, sources procedural uncertainty)
- **HPC:** Picasso (SLURM, Singularity, A100 40GB) for ensemble training; local for LME fits
- **Frameworks:** PyTorch, MONAI, `nibabel`, `SimpleITK`; LME via `statsmodels` / `lme4` (R via `rpy2`) / `pymer4`
- **Datasets:**
  - [[../../03_Resources/datasets/mengrowth|MenGrowth cohort]] — 58 patients, ~3 studies/patient, BraTS-style preprocessing
  - Raw H5: `/media/mpascual/MeningD2/MENINGIOMAS/MENGROWTH/050526/h5_format`
  - Segmentation results: `/media/mpascual/Sandisk2TB/research/growth-dynamics/growth/results/uncertainty_segmentation/frozen_decoder/kqv_proj_fc1_fc2/stages_1234`
- **Thesis draft:** `/media/mpascual/Sandisk2TB/research/growth-dynamics/growth/bachelor_thesis/68596a200c0e0e3876880afa`
- **Method docs:** `/home/mpascual/research/code/MenGrowth-Model/docs/UQ_PRED`

## Status

- **Phase:** segmentation done, uncertainty extracted; LME modelling in progress
- **Last session:** *(none logged yet — first session via `coding-session-log` skill)*
- **Blockers:** none

## Roadmap

| Phase                         | Goal                                                                                | Target date | Status         |
|-------------------------------|-------------------------------------------------------------------------------------|-------------|----------------|
| Cohort + preprocessing        | MenGrowth (58 pts, BraTS-style, longitudinal) curated and H5-packed                 | 2026-04-30  | done           |
| BSF + LoRA segmentation       | Train BSF + LoRA (stages 1–4, kqv+proj+fc1+fc2, frozen decoder); extract per-study  | 2026-05-15  | done           |
| Deep-ensemble uncertainty     | Procedural variance per voxel/per study via M-member ensemble                       | 2026-05-15  | done           |
| Homoscedastic LME baseline    | Fit log(V+1) ~ time + (time \| patient); report IS, sharpness, calibration         | 2026-05-22  | active         |
| Heteroscedastic LME           | Per-observation variance from segmentation uncertainty; identifiability analysis    | 2026-06-05  | not started    |
| Comparison + ablations        | IS, CRPS, coverage, sharpness vs. baseline; ablate ensemble size, LoRA stages       | 2026-06-15  | not started    |
| Bachelor thesis writing       | Write-up in Overleaf project `68596a200c0e0e3876880afa`                             | 2026-06-30  | active         |

## Method sketch

Per study $i$ of patient $p$, the deep ensemble $\{f_\theta^{(m)}\}_{m=1}^{M}$ produces $M$ segmentations from which a tumour volume distribution $\{V_i^{(m)}\}_m$ is summarised by mean $\hat{V}_i$ and variance $\hat{s}_i^2$. The growth model is

$$
y_i = \log(\hat{V}_i + 1), \qquad y_i \sim \mathcal{N}\!\left(\beta_0 + \beta_1 t_i + b_{0,p} + b_{1,p} t_i,\ \sigma_i^2\right),
$$

with random effects $(b_{0,p}, b_{1,p}) \sim \mathcal{N}(0, \Psi)$ and the
heteroscedastic observation variance

$$
\sigma_i^2 = \sigma_\varepsilon^2 + \alpha\, g(\hat{s}_i^2),
$$

where $g(\cdot)$ is a delta-method propagation from voxel-level variance
to log-volume variance and $\alpha$ scales the procedural variance.
Identifiability of $(\sigma_\varepsilon^2, \alpha)$ is the open question.

## Key references

- [[../../03_Resources/papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026 — Epistemic uncertainty estimation methods are fundamentally incomplete]] — formalises that deep ensembles capture only the *procedural* component of epistemic uncertainty; supports the lower-bound framing
- [[../../03_Resources/papers/foundation-models/cox2024--brainsegfounder|Cox 2024 — BrainSegFounder]] — foundation model used as the segmentation backbone, adapted with LoRA on SwinViT stages 1–4

## Open questions

- Is $(\sigma_\varepsilon^2, \alpha)$ jointly identifiable on $N{\approx}174$ observations? Profile likelihood or fix one of them via prior.
- Does delta-method log-volume variance underestimate true variance for small tumours where $V \to 0$? (log(V+1) trick mitigates but does not eliminate.)
- How does ensemble size $M$ trade off against per-member training cost on Picasso?
- Should the random-slope structure $(b_{1,p})$ be removed for patients with $<3$ studies?
- Is Interval Score the correct headline metric, or should CRPS / coverage at fixed nominal levels lead?

## Related

- [[_MOC|Project MOC]]
- [[../_MOC|01_Projects MOC]]

#type/project #status/active #project/mengrowth-prediction-uncertainty-propagation #domain/meningioma #domain/uncertainty-propagation #domain/growth-prediction
