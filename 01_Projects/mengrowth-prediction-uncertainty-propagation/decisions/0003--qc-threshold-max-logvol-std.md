---
title: "0003 — Apply QC filter max_logvol_std=1.0 before LME fitting"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: done
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation]
project: mengrowth-prediction-uncertainty-propagation
---

# 0003 — Apply QC filter `max_logvol_std=1.0` before LME fitting

*Drop scans with $\sigma_v = \mathrm{SD}_m[\log(V^{(m)}+1)] > 1.0$. These are pipeline failures (zero-volume targets, sub-cm³ disagreement, FOV-edge tumours), not legitimate measurement noise.*

## Decision

Apply `max_logvol_std=1.0` filter to the per-scan $\sigma_v$ vector before fitting LMEHomo / LMEHetero. Effect: 11 of 179 scans removed, cohort reduced from 56 patients / 179 scans to 54 patients / 163 scans.

## Rationale

- **Empirical $\sigma^2_v$ is bimodal.** $N{=}179$, median 0.0012, mean 0.4165, with 6.1% of scans (11/179) exceeding $\sigma_v > 1$ in log-volume. This bimodality is the proximate cause of the propagation budget identity ([[../notes/propagation-budget-identity|note]]) and the marginal under-coverage of LMEHetero.
- **The 11 scans are not measurement noise.** Inspection: 3 zero-volume targets where members disagree on whether to predict any mask; sub-cm³ tumours where mask presence is binary across members; FOV-edge cases where the tumour is partially outside the volume.
- **The propagation framework assumes well-defined per-scan noise.** A scan where ensemble disagreement is "is there a tumour at all?" violates the variance interpretation: $\sigma^2_v$ in that regime is bounded by the binary-mask prior, not by segmentation noise.

## Effect on results

The pre-QC headline (high-tertile $\Delta\mathrm{IS}@95 = -7.84$, $\Delta\mathrm{cov}_{95} = +0.105$) collapses to $\Delta\mathrm{IS}@95 = -3.28$ ($p{=}0.43$, $n{=}17$) and $\Delta\mathrm{cov}_{95} = +0.118$ ($p{=}0.25$). **Half the headline gain came from the 11 failure scans; the post-QC effect is non-significant at any conventional threshold.** See [[../experiments/2026-05-08--qc-filter-collapse|QC filter collapses propagation effect]].

## Trade-offs / consequences

- **Cohort reduction is patient-level small.** 56→54 patients; the 11 scans are concentrated in 2 patients with otherwise valid trajectories.
- **Pre/post-QC should both be reported in the thesis.** The pre-QC result is the headline; the post-QC result is the honest one. Reporting both quantifies how much of the chapter's headline depends on pipeline-failure scans.
- **The QC threshold is a hyperparameter.** A sensitivity analysis sweeping $\{0.5, 0.75, 1.0, 1.25, 1.5\}$ would document the elbow.

## Related

- [[../_MOC|Project MOC]]
- [[../experiments/2026-05-08--qc-filter-collapse|QC filter collapses propagation effect]]
- [[../notes/propagation-budget-identity|Propagation budget identity]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation
