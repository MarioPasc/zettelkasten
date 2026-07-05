---
title: "0001 — Freeze UNETR decoder during BSF + LoRA fine-tuning"
created: 2026-05-08
updated: 2026-05-08
type: decision
status: review
tags: [type/decision, project/mengrowth-prediction-uncertainty-propagation, status/review, domain/lora, domain/peft, domain/brainsegfounder]
project: mengrowth-prediction-uncertainty-propagation
---

# 0001 — Freeze UNETR decoder during BSF + LoRA fine-tuning

*Adapt the BrainSegFounder SwinViT encoder with LoRA on stages 1–4 (kqv + proj + fc1 + fc2); leave the UNETR decoder frozen at its random/Stage-3-trained weights. Provisional — ablation pending.*

## Context

Cox 2024 (BSF) trains the UNETR decoder during supervised Stage 3 fine-tuning. Our pipeline freezes the decoder and adapts only the encoder via LoRA adapters on every transformer stage. The departure is unvalidated by the source paper.

## Decision

Freeze decoder; LoRA on encoder stages 1–4, modules `{kqv, proj, fc1, fc2}`. $M{=}20$ members trained with seed-only randomisation.

## Rationale

- **Parameter budget.** LoRA on the encoder is ~1–3% of full encoder params; freezing the decoder removes another ~30M trainable params. Critical at $N\!\approx\!54$ patients.
- **Inductive bias preservation.** Encoder LoRA biases the model to inherit BSF's normal-anatomy prior and adjust only what is needed for meningioma localisation; decoder freezing prevents the small fine-tuning set from over-fitting upsampling weights.
- **Procedural uncertainty channel.** Restricting the trainable surface to encoder LoRA concentrates ensemble diversity in the place where boundary cues for extra-axial masses are encoded, which is the channel we propose to summarise.

## Trade-offs / risks

- **Unvalidated departure from BSF.** Source paper always trains the decoder; freezing may bottleneck performance if decoder layers need to co-adapt with LoRA-shifted encoder features.
- **Ensemble diversity.** All members share the frozen decoder, so ensemble disagreement reflects encoder-LoRA seed variability only — possibly an under-estimate of total procedural uncertainty (cf. [[../../../03_Resources/papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026]]: deep ensembles already capture only the procedural component).
- **Decoder freezing interacts with the propagation channel.** If the decoder is the bottleneck, the segmentation residuals tracked in `|y_*-\hat\mu_*^{\text{homo}}|` may carry decoder noise that the encoder ensemble cannot represent, biasing Stage 1 of the candidate-metrics diagnostic toward H2.

## Status

`#status/review` — provisional. Promote to `#status/done` only after the ablation below.

## Ablation requested

Decoder-frozen vs decoder-trainable (with and without LoRA on encoder), reporting BraTS-Men-style Dice on the held-out fold, $\overline{\sigma^2_v}$, per-scan rel-SD of $\sigma_v(m)$, and downstream IS@95 in LMEHetero. Target: 2026-06.

## Related

- [[../_MOC|Project MOC]]
- [[../coding-sessions/2026-05-08T1500--uq-propagation-stage1-synthesis|Stage 1 synthesis]]
- [[../../../03_Resources/papers/foundation-models/cox2024--brainsegfounder|Cox 2024 — BrainSegFounder]]

#type/decision #project/mengrowth-prediction-uncertainty-propagation #domain/lora #domain/brainsegfounder
