---
title: "Reconciliation: thesis-as-written vs vault paraphrase — significant corrections"
created: 2026-05-08
updated: 2026-05-08
type: session
status: done
tags: [type/session, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# Reconciliation: thesis-as-written vs vault paraphrase — significant corrections

*Cross-checked the vault notes against the LaTeX thesis at `bachelor_thesis/68596a200c0e0e3876880afa/sections/` and the canonical result JSONs under `growth/results/uncertainty_propagation_volume_prediction/main_experiment/`. The earlier session [[2026-05-08T1500--uq-propagation-stage1-synthesis|Stage 1 synthesis]] was paraphrased from planning docs and quoted numbers from a pre-QC N=56 pilot run, not from the post-QC N=54 main experiment that the thesis actually reports.*

## Source of authority

- **Typeset .tex** — `sections/results/{preprocessing,segmentation}.tex` (numbers are stable here).
- **Result JSONs** — `main_experiment/{LME_baseline,LMEHetero_Zero_baseline}/{marginal,tertile}_metrics.json`, `main_experiment/aggregated/wilcoxon_results.json`, `main_experiment/cohort_meta.json`. These are programmatic outputs from the post-QC pipeline.
- **Pre-QC pilot** — `previous_tests/synthetic_uq/{summary_rows,...}.json`. Numbers from the N=56 epoch.
- **Stage 3 chapters** — `sections/results/growth.tex`, `sections/discussion/*.tex`, `sections/conclusion/*.tex` are currently `TODO`. No typeset growth-prediction results yet.

## Headline corrections

### Cohort size

| | Pre-QC | Post-QC |
|---|---|---|
| Vault (wrong) | 56 patients, 179 scans | 54 patients, 163 scans |
| Thesis (correct) | **58 patients**, 179 scans | **54 patients, 163 scans** |
| → drops | — | **16 scans, 4 patients** (not 11 / 2) |

### QC mechanism

The thesis QC is **SynthSeg self-consistency $q \geq 0.80$** (`results/preprocessing.tex`). 170/179 studies pass; 5 below $q{=}0.75$, 4 of which belong to MenGrowth-0007 and MenGrowth-0025. Cohort minimum $q{=}0.547$ on MenGrowth-0007-000 (7 mm T1n slice spacing). LME-QC spacing regression: $\hat\beta_1{=}-0.007$ ($p<0.001$).

The `max_logvol_std=1.0` filter the vault originally documented is *not* the thesis QC. It may exist as a downstream filter in planning docs, but the post-QC cohort that all current result JSONs are computed on is the SynthSeg-QC cohort. **`decisions/0003` updated to reflect this.**

### LMEHomo vs LMEHetero — main experiment (post-QC, N=54)

From `LME_baseline/marginal_metrics.json` and `LMEHetero_Zero_baseline/marginal_metrics.json`:

| | n | IS@95 | $\mathrm{cov}_{95}$ | CRPS | $\bar w_{95}$ | NLPD | $R^2_{\log}$ |
|---|---:|---:|---:|---:|---:|---:|---:|
| LMEHomo   | 54 | 8.2857 | 0.9074 | 0.6017 | 4.4186 | 1.7802 | 0.2544 |
| LMEHetero | 54 | 8.2866 | 0.9074 | 0.6017 | 4.4186 | 1.7803 | 0.2543 |

**Indistinguishable to 4 significant figures.** The vault's "5.39 / 4.97" widths and "0.893 / 0.875" coverages were from the pre-QC N=56 synthetic-stress epoch, not the main experiment.

### Tertile-stratified — main experiment (post-QC, N=54)

Cuts $q_{33}=0.001$, $q_{66}=0.004075$ (note: $\sigma^2_v$ is floored at 0.001 in the post-QC pipeline; the empirical median of the unfloored pre-QC distribution was 0.0012).

LMEHomo and LMEHetero high-tertile cells (from `tertile_metrics.json`):

| Tertile | $n$ | LMEHomo IS@95 | LMEHomo cov | LMEHetero IS@95 | LMEHetero cov |
|---|---:|---:|---:|---:|---:|
| low  | 28 | 9.413 | 0.893 | 9.415 | 0.893 |
| mid  | 9  | 4.861 | 0.889 | 4.861 | 0.889 |
| high | 17 | 8.242 | 0.941 | 8.242 | 0.941 |

**Conditionally null too.** The "high-tertile IS@95 17.66 → 9.82" number the vault recorded is from `previous_tests/synthetic_uq/summary_rows.json` (Profile A / c0.001 / LME / pre-QC N=56 / seed 0). The 9.82 LMEHetero recovery is **not reproducible from the post-QC main-experiment files** — it does not appear anywhere except the planning docs.

### τ-sweep — main experiment

From `aggregated/wilcoxon_results.json`, BH at $\alpha{=}0.05$ over 20 seeds:

| $\tau$ | mean $\Delta\mathrm{IS}$ (het − homo) | median $p$ | BH rejected / 20 |
|---:|---:|---:|---:|
| $-7.105$ | $+0.001$ | 0.0002 | 20/20 |
| $-4.614$ | $+0.002$ | 0.0008 | 14/20 |
| $-2.124$ | $+0.016$ | 0.0038 | 14/20 |
| **$0.000$** | **$+0.064$** | **0.0059** | **13/20** |
| $+2.857$ | $-0.071$ | 0.0108 | 11/20 |
| $+5.348$ | $+1.595$ | 0.0019 | 12/20 |
| $+7.839$ | $+5.500$ | $<10^{-4}$ | 20/20 |
| $+10.329$ | $+16.586$ | $<10^{-4}$ | 20/20 |
| $+12.820$ | $+19.642$ | $<10^{-4}$ | 20/20 |

**At $\tau{=}0$, hetero is slightly worse (+0.064 IS@95) and 13/20 seeds reject paired Wilcoxon under BH-FDR.** The vault's "$\Delta\mathrm{IS}=-0.04$, 0/20 BH-rejected" was a paraphrase that contradicts the data on sign, magnitude, and rejection count.

### M-convergence

Thesis (`results/segmentation.tex`) says ensemble performance plateaus between $k{=}10$ and $k{=}15$, consistent across all five LoRA ranks and seeds. **No "$m \geq 5$" tolerance figure appears in any .tex file.** Vault wording corrected.

### Segmentation rank sweep — added as new experiment

Vault had no segmentation experiment note. Adding from `results/segmentation.tex` (BraTS-MEN held-out test, $n{=}150$ scans, $M{=}20$):

| Adapter | $\Delta W$ | Total | Dice (mean ± 95% CI) | Mean inter-member Var |
|---|---:|---:|---:|---:|
| Frozen BSF | 0       | 62.19 M | 0.632 ± 0.065 | 0.0000 |
| LoRA r=2   | 46.1 K  | 62.24 M | 0.862 ± 0.035 | 0.0013 |
| LoRA r=4   | 92.2 K  | 62.28 M | 0.866 ± 0.035 | 0.0011 |
| LoRA r=8   | 184.3 K | 62.38 M | 0.871 ± 0.033 | 0.0014 |
| LoRA r=16  | 368.6 K | 62.56 M | 0.874 ± 0.032 | 0.0017 |
| LoRA r=32  | 737.3 K | 62.93 M | **0.879 ± 0.032** | 0.0017 |

Frozen BSF per-region Dice: TC 0.650, WT 0.593, ET 0.653. LoRA r=2 vs frozen: $\Delta$Dice $= +0.230$ ($p<0.001$, Wilcoxon + Holm–Bonferroni; Cohen's $d$: TC 0.64, WT 0.77, ET 0.65). $\Delta$Dice WT $= +0.249$ (largest). r=2 → r=32: $+0.017$ Dice; Cohen's $d < 0.3$ for adjacent ranks. Final reported configuration: **r=16, $\alpha=32$, dropout 0.1, M=20**.

### Items the thesis does not (yet) report

- **91% / 9% structural-vs-propagation decomposition.** Not in any .tex; only in planning docs.
- **REML budget identity** $\hat\sigma^2_{n,\text{homo}} \approx \hat\sigma^2_{n,\text{het}} + \overline{\sigma^2_v}$. Not in any .tex.
- **Stage-1 candidate-metric ρ values.** `test_candidate_uncertainty_signals` directory does not exist on disk. Stage 1 is planned, **not yet executed**.
- **growth.tex, discussion.tex, conclusion.tex.** All `TODO`. The growth-prediction chapter has no typeset results yet.

## Vault updates applied in this session

- [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|LME homo-vs-hetero]] rewritten with the post-QC null finding; pre-QC pilot numbers moved into a clearly-marked "Pilot epoch" subsection.
- [[../experiments/2026-05-08--qc-filter-collapse|QC effect]] rewritten: *the* finding is that the post-QC distribution is so $\sigma^2_v$-poor that hetero ≡ homo to 4 sig figs at every level. Previous-version "collapse from p=0.22 to p=0.43" framing was wrong.
- [[../experiments/2026-05-08--smooth-shift-tau-sweep|τ-sweep]] corrected with the actual BH counts and signs.
- [[../experiments/2026-05-08--synthetic-variance-stresstest|Synthetic stress test]] re-scoped to the pre-QC N=56 pilot it actually ran on.
- [[../experiments/2026-05-08--sigma-v-stability-vs-m|σ²_v stability vs M]] corrected: plateau k=10–15, not m≥5.
- [[../experiments/2026-05-08--bsf-lora-rank-sweep-segmentation|BSF + LoRA rank sweep — segmentation]] added.
- [[../decisions/0003--qc-threshold-max-logvol-std|0003]] updated: thesis QC is SynthSeg $q \geq 0.80$; `max_logvol_std=1.0` is a planning-doc artifact.
- [[../notes/propagation-budget-identity|Budget identity]] flagged as "inferred / not typeset; verify against REML estimates before citing."
- [[../notes/residual-decomposition-h1-h2|H1/H2 framing]] strengthened: H2 is now consistent with the post-QC main-experiment null at every level.
- [[../_README|README]] roadmap, status, and open questions corrected.

## Lessons

- **Result JSONs > planning docs > paraphrased synthesis.** The next time a synthesis is captured, hash the underlying JSONs into the session log so the reader can tell what epoch the numbers came from.
- **Two epochs co-exist.** The pre-QC N=56 pilot (synthetic stress test) produced the dramatic high-tertile recovery; the post-QC N=54 main experiment is null at every level. Both must be reported, both must be clearly labelled by epoch, and the headline is the post-QC null.
- **The τ-sweep direction matters.** At $\tau{=}0$ hetero is *worse*, not null — a stronger argument for H2 than the synthesis suggested.

## Related

- [[2026-05-08T1500--uq-propagation-stage1-synthesis|Earlier session — Stage 1 synthesis (now superseded for numerical claims)]]
- [[../_README|Project README]]
- [[../_MOC|Project MOC]]

#type/session #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/lme
