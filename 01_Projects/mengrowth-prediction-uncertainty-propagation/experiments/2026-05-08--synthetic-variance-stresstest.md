---
title: "Synthetic variance stress test — pre-QC N=56 pilot, not the main experiment"
created: 2026-05-08
updated: 2026-05-08
type: experiment
status: archived
tags: [type/experiment, project/mengrowth-prediction-uncertainty-propagation, status/archived, domain/uncertainty-propagation, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# Synthetic variance stress test — pre-QC N=56 pilot, not the main experiment

*Synthetic injection of controlled $\sigma^2_v$ profiles ran on the pre-QC N=56 cohort, before the SynthSeg-QC pipeline that defines the post-QC main experiment. The dramatic high-tertile recovery (LMEHomo IS@95 17.66 → LMEHetero 9.82) belongs to this pilot. The "~91% structural / ~9% propagation" decomposition the vault originally cited is not typeset anywhere in the thesis and cannot be reproduced from current result files.*

## Source

`results/uncertainty_propagation_volume_prediction/previous_tests/synthetic_uq/summary_rows.json` and adjacent run directories.

This experiment is **scoped to the pre-QC N=56 epoch** and its conclusions do not generalise to the post-QC main experiment ([[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|main experiment]]).

## Setup

- **Cohort.** Pre-QC, N=56 patients (the figure quoted in the original vault synthesis). The post-QC main-experiment cohort is N=54.
- **Targets fixed.** Same LOPO held-outs across all profiles.
- **Profiles.**
  - **A** — constant $\sigma^2_v \equiv c$, 4 levels ($c \in \{0.001, \dots, 1\}$).
  - **B** — matched-mean random dispersion (no rank correlation with the truth).
  - **C** — proportion-contaminated, 5 levels ($p \in \{0, 0.1, 0.2, 0.3, 0.4\}$).
  - **D** — log-normal $\tau$-shifted, 5 levels ($\tau \in \{0, 0.5, 1, 1.5, 2\}$).
  - **E** — empirical pass-through (the LoRA-ensemble $\sigma^2_v$ with no transform).
- **Seeds.** Ten per cell (160 LMEHetero LOPO fits).

## Reproducible numbers (from `summary_rows.json`)

Profile **A** / $c=0.001$ / LME (homo) / seed 0:

- **Marginal:** IS@95 = 10.505, cov_95 = 0.893.
- **High-tertile** ($n=19$, $\overline{\sigma^2_v}=1.785$): **IS@95 = 17.656, cov_95 = 0.789**.
- Low tertile ($n=16$): IS@95 = 5.846, cov_95 = 0.938.

Profile **E** / empirical / LMEHetero / seed 0:

- Marginal: IS@95 = 9.000, cov_95 = 0.893, $\bar w_{95}$ = 5.077.
- Injected $\overline{\sigma^2_v} = 0.346$, p90 = 0.162, fraction high = 0.335.

## Numbers in the original vault entry that are *not* reproducible

- **High-tertile LMEHetero IS@95 = 9.82 / cov_95 = 0.895.** Appears in planning docs but not in `summary_rows.json` for any profile/seed combination found here. May come from a deprecated pipeline state.
- **~91% structural / ~9% propagation decomposition** of the high-tertile $\Delta\mathrm{IS} \approx -8$. Not typeset in any `.tex` file; not present as a numeric output in any JSON found. Treat as planning-doc inference until reproduced.

## Implication

- The conditional-positive narrative ("hetero re-allocates sharpness where the data justifies it") was driven by the pre-QC pilot's empirical $\sigma^2_v$ distribution, which was both unfloored and contaminated by segmentation failures.
- Once the SynthSeg-QC cohort is taken (post-QC main experiment), this stress test would need to be re-run to know whether any redistribution effect survives. **Open TODO.**

## Status

`#status/archived` — kept as a record of the pilot epoch. The thesis's main-experiment numbers come from a different pipeline state (post-QC, $\sigma^2_v$ floored at 0.001, N=54) and are recorded in [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|the homo-vs-hetero experiment note]].

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1900--thesis-results-reconciliation|Reconciliation session]]
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|Main experiment — homo vs hetero]]
- [[2026-05-08--smooth-shift-tau-sweep|τ-sweep]]

#type/experiment #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/lme
