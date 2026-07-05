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

- **Phase:** Post-QC main experiment is **null at every level** — LMEHomo and LMEHetero match to 4 significant figures both marginally (IS@95 8.2857 vs 8.2866, cov 0.9074) and at every $\sigma^2_v$ tertile. The dramatic high-tertile recovery (IS@95 17.66 → ~9.82) belongs to a separate pre-QC N=56 pilot, not the main experiment. At $\tau=0$ on the post-QC cohort, hetero is slightly *worse* than homo (mean $\Delta$IS $=+0.064$, 13/20 seeds BH-reject). Stage 3 chapters of the thesis (`growth.tex`, `discussion.tex`, `conclusion.tex`) are TODO. Live question: does any candidate scalar from the LoRA ensemble correlate with trajectory residuals?
- **Last session:** [[coding-sessions/2026-05-08T1900--thesis-results-reconciliation|2026-05-08 — Thesis results reconciliation]]
- **Blockers:** Stage 1 of candidate-metrics diagnostic blocked on wiring candidate vectors into the loader (`test_candidate_uncertainty_signals` directory does not exist on disk; Stage 1 is planned but not yet executed).

## Roadmap

| Phase                                    | Goal                                                                                                                              | Target date | Status         |
|------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------------|----------------|
| Cohort + preprocessing                   | MenGrowth (58 pts, 179 scans, BraTS-style, longitudinal) curated and H5-packed                                                    | 2026-04-30  | done           |
| BSF + LoRA segmentation rank sweep       | $r \in \{2,4,8,16,32\}$, $\alpha=2r$, frozen decoder; final r=16, Dice 0.874; r=32 best at 0.879                                 | 2026-05-01  | done           |
| Deep-ensemble uncertainty ($M{=}20$)     | Procedural variance per scan; plateau at $k{=}10{-}15$                                                                            | 2026-05-01  | done           |
| SynthSeg QC ($q \geq 0.80$)              | Define growth-model cohort: 16 scans / 4 patients drop → 54 patients / 163 scans                                                  | 2026-05-02  | done           |
| LME predictive-variance fix              | Include FE term $\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^*$ in `lme_model.py` / `lme_hetero.py`              | 2026-05-05  | done           |
| LMEHomo vs LMEHetero (post-QC main)      | **Null at every level** (IS@95 8.286 vs 8.287, cov 0.9074 both; tertile cells indistinguishable)                                  | 2026-05-05  | done           |
| τ-sweep on the post-QC cohort            | At $\tau{=}0$, mean $\Delta$IS $=+0.064$, 13/20 BH-rejected (hetero slightly worse); large $\tau$ saturates trivially            | 2026-05-07  | done           |
| Pre-QC pilot (synthetic stress test)     | N=56 pilot only: A/B/C/D/E profiles, high-tertile pilot dynamics. Archived; main result is the post-QC null                       | 2026-04-25  | archived       |
| Candidate-metrics Stage 1 (rank-corr)    | Spearman/Pearson/Kendall + 95% BCa CI vs $\lvert y_*-\hat\mu_*^{\text{homo}}\rvert$ for each candidate; pass at $\lvert\hat\rho\rvert{>}0.20$ | 2026-05-15  | active (blocked) |
| Candidate-metrics Stage 2 (LME-hetero)   | Per-(candidate, scaling) LOPO-LMEHetero, paired BCa $\Delta\mathrm{IS}@95$, BH-FDR; only Stage-1 passers                          | 2026-05-22  | not started    |
| Frozen-decoder ablation                  | Decoder-frozen vs trainable, with/without LoRA on encoder                                                                         | 2026-06-15  | not started    |
| Stage 3 thesis sections                  | Write `results/growth.tex`, `discussion/*.tex`, `conclusion/*.tex` (currently `TODO`)                                             | 2026-06-15  | not started    |
| Bachelor thesis final write-up           | Overleaf project `68596a200c0e0e3876880afa`                                                                                       | 2026-06-30  | active         |

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

- **(Live, blocking)** Does any candidate scalar from the LoRA $M{=}20$ ensemble correlate with $\lvert y_* - \hat\mu_*^{\text{homo}}\rvert$ on the post-QC cohort? Candidate set (logvol-MAD, $\mathrm{CV}^2$, mean predictive entropy, BALD/MI, voxel-wise variance, MEN-restricted entropy/MI, MEN-boundary entropy/MI, composite). Stage 1 blocked: `test_candidate_uncertainty_signals` directory absent. See [[decisions/0006--candidate-metrics-staged-diagnostic|0006]].
- Why is the post-QC $\sigma^2_v$ floored at 0.001 ($q_{66}{=}0.004$)? The floor compresses the high-tertile dispersion that drove the pre-QC pilot's effect and is a major contributor to the post-QC null. Is the floor a software default or a deliberate choice?
- Are pre-QC and post-QC $\sigma^2_v$ different distributions, or is the post-QC distribution simply the unfloored pre-QC distribution with a floor applied? Affects whether the pre-QC pilot's high-tertile finding survives a re-run on the SynthSeg-QC cohort.
- Does the τ=0 +0.064 IS@95 deficit and 13/20 BH-rejection of hetero argue *positively* for H2 (anti-informative segmentation channel) rather than just non-informative?
- Is the headline metric IS@95, CRPS, or coverage at fixed nominal levels? Currently implicit; should be filed as a decision.
- Should the random-slope structure $(b_{1,p})$ be removed for patients with $<3$ studies?
- Frozen-decoder vs trainable-decoder ablation: does decoder freezing bottleneck performance and bias ensemble diversity? Reinforced by the LoRA-rank-sweep finding that inter-member variance is non-monotonic and plateaus past r=8. See [[decisions/0001--frozen-decoder-bsf-lora|0001]] and [[experiments/2026-05-08--bsf-lora-rank-sweep-segmentation|rank sweep]].
- QC threshold sensitivity: sweep SynthSeg $q \in \{0.70, 0.75, 0.80, 0.85, 0.90\}$ to characterise the cohort-size vs reliability trade-off. See [[decisions/0003--qc-threshold-max-logvol-std|0003]].
- Does delta-method log-volume variance systematically underestimate true variance for $V \to 0$? The $\log(V+1)$ shift mitigates but does not eliminate.

## Related

- [[_MOC|Project MOC]]
- [[../_MOC|01_Projects MOC]]

#type/project #status/active #project/mengrowth-prediction-uncertainty-propagation #domain/meningioma #domain/uncertainty-propagation #domain/growth-prediction
