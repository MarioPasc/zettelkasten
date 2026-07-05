---
title: "MOC — MenGrowth Project · Decisions"
type: moc
created: 2026-05-08
updated: 2026-05-08
tags: [type/moc, project/mengrowth-prediction-uncertainty-propagation]
---

# MOC — MenGrowth Project · Decisions

*ADR-style design decisions: LoRA stage selection, ensemble size, LME
random-effect structure, identifiability strategy, headline metric.*

## Children

<!-- Auto-managed by the moc-update skill. -->

- [[0001--frozen-decoder-bsf-lora|0001 — Freeze UNETR decoder during BSF + LoRA fine-tuning]] — provisional; ablation pending
- [[0002--logvol-plus-one-target|0002 — Model log(V+1) as the LME target]]
- [[0003--qc-threshold-max-logvol-std|0003 — Apply QC filter max_logvol_std=1.0]]
- [[0004--ensemble-size-m20|0004 — Use M=20 LoRA ensemble members]]
- [[0005--lme-predictive-variance-fe-term|0005 — LME predictive variance includes the FE term]]
- [[0006--candidate-metrics-staged-diagnostic|0006 — Two-stage candidate-metrics diagnostic]] — active

## Parent

- [[../_MOC|MenGrowth Project MOC]]

#type/moc #project/mengrowth-prediction-uncertainty-propagation
