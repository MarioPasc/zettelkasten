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

- [[2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|LMEHomo vs LMEHetero — marginal + σ²_v tertile]] — marginal null, conditional textbook propagation
- [[2026-05-08--sigma-v-stability-vs-m|σ²_v stability vs ensemble size M]] — robust from m≥5; not a sampling artefact
- [[2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test]] — 16 profile×level cells; ~91% structural, ~9% propagation
- [[2026-05-08--qc-filter-collapse|QC filter collapses propagation effect]] — half the headline came from segmentation-failure scans
- [[2026-05-08--smooth-shift-tau-sweep|Smooth-shift α-sweep + τ-scaling]] — IS surface saturates; rules out scaling-only fixes

## Parent

- [[../_MOC|MenGrowth Project MOC]]

#type/moc #project/mengrowth-prediction-uncertainty-propagation
