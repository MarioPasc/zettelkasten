---
title: "MOC — MenGrowth Project · Experiments"
type: moc
created: 2026-05-08
updated: 2026-05-08
tags: [type/moc, project/mengrowth-prediction-uncertainty-propagation]
---

# MOC — MenGrowth Project · Experiments

*Run logs and results: BSF+LoRA segmentation runs, ensemble training,
LME fits (homoscedastic, heteroscedastic), ablations.*

## Children

<!-- Auto-managed by the moc-update skill. -->

- [[2026-05-08--bsf-lora-rank-sweep-segmentation|BSF + LoRA rank sweep — segmentation Dice]] — frozen 0.632 → r=2 0.862 → r=32 0.879; final config r=16; M=20 plateaus at k=10–15
- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|LMEHomo vs LMEHetero — main experiment, post-QC null]] — IS@95 8.286 vs 8.287 marginally; tertile cells equivalent
- [[2026-05-08--qc-filter-collapse|QC filter (SynthSeg q ≥ 0.80) defines post-QC cohort]] — 16 scans / 4 patients drop; main experiment is null on the cleaned cohort
- [[2026-05-08--smooth-shift-tau-sweep|τ-sweep on post-QC cohort]] — at τ=0 hetero is slightly worse (+0.064 IS@95, 13/20 BH-rejected); large τ saturates trivially
- [[2026-05-08--sigma-v-stability-vs-m|Ensemble-size convergence]] — performance plateaus k=10–15 across all five LoRA ranks
- [[2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test (PRE-QC N=56 PILOT, archived)]] — A/B/C/D/E profiles; 17.66 high-tertile from this pilot, not the main experiment

## Parent

- [[../_MOC|MenGrowth Project MOC]]

#type/moc #project/mengrowth-prediction-uncertainty-propagation
