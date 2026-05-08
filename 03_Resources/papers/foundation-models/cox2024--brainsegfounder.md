---
title: "Cox2024 — BrainSegFounder: Towards Foundation Models for Neuroimage Segmentation"
created: 2026-05-08
updated: 2026-05-08
type: paper
status: review
tags: [type/paper, status/review, domain/foundation-model, domain/brainsegfounder, domain/segmentation, domain/brain-mri, venue/preprint]
aliases: ["BrainSegFounder", "BSF"]
sources:
  - "arxiv:2406.10395"
authors: ["Joseph Cox", "Peng Liu", "Skylar E. Stolte", "Yunchao Yang", "Kang Liu", "Kyle B. See", "Huiwen Ju", "Ruogu Fang"]
year: 2024
venue: "arXiv preprint (eess.IV)"
---

# Cox2024 — BrainSegFounder: Towards Foundation Models for Neuroimage Segmentation

*Two-stage SSL SwinUNETR pretrained on 82,800 healthy-brain UKB MRIs, then disease-specific SSL + supervised fine-tune; Dice 0.9115 on BraTS-2021 and top-3 on ATLAS.*

## TL;DR

BSF addresses the scarcity of annotated pathological brain MRI by first
building a latent representation of normal anatomy on 41,400 UKB
subjects (Stage 1), then specialising the representation toward pathology
on the target dataset via a second SSL stage (Stage 2), and finally
fine-tuning with labels (Stage 3). The backbone is a SwinUNETR encoder
adapted for arbitrary input channels. On BraTS-2021 the best variant
(64M params) reaches mean Dice 0.9115 across five folds, vs. 0.8971 for
the SwinUNETR baseline. On ATLAS-v2.0 stroke lesion segmentation it
reaches Dice 0.712 / Lesion-F1 0.711 as a single non-ensemble model.

## Problem

Annotated pathological brain MRI datasets are scarce; models trained
only on small diseased cohorts generalise poorly. Existing 2D foundation
models (SAM, MedSAM) cannot natively process 3D volumes. The gap is a
robust, 3D, modality-flexible pretrained encoder for neuroimaging
segmentation.

## Method

**Architecture.** SwinUNETR backbone: Swin Transformer encoder with 4
stages (patch $2{\times}2{\times}2$, feature dim 8, embedding 48), UNETR
upsampling decoder. Three scale variants — Tiny 62M / Small 64M / Big
69M params; the differentiator is the number of sliding-window blocks in
Stage 3 (12/12/18). Input channels are flexible; new channels are
Kaiming-initialised.

**Stage 1 — UKB SSL.** 82,800 volumes (T1w + T2-FLAIR), random crops to
$96^3$. Three SSL proxies from Tang et al. (arXiv:2111.14791): masked
volume inpainting, 3D rotation prediction, contrastive coding. AdamW,
$\mathrm{lr}{=}6\!\times\!10^{-6}$, batch 2/GPU, 64 A100 80GB, 15,000
iterations (≈3–6 days).

**Stage 2 — Target SSL.** SSL repeated on the target dataset (BraTS
1,251 subjects or ATLAS 665 subjects), no labels. Encoder weights
transferred; decoder discarded. $\mathrm{lr}{=}10^{-4}$, batch 2, 2–4
A100s, ≤72 h.

**Stage 3 — Supervised fine-tune.** Pretrained encoder + fresh UNETR
decoder, Dice loss. 50,000 steps for BraTS; 600 epochs for ATLAS;
dropout 10% on ATLAS.

Curriculum assumption: pretrain on normal anatomy *before* pathology
exposure transfers beneficially.

## Results

BraTS-2021 (Dice, 5-fold CV, BSF-Small 64M):

| Model              | Mean Dice |
|--------------------|-----------|
| **BSF-S (64M)**    | **0.9115** |
| SwinUNETR baseline | 0.8971     |
| nnU-Net (winner)   | 0.908      |
| SegResNet          | 0.907      |
| TransBTS           | 0.891      |

T1w-only modality restriction: BSF 0.721 vs SwinUNETR 0.678 (+0.043).

Few-shot on BraTS (5-repeat avg): at 5% data BSF 0.787 vs 0.782; at 10%
0.876 vs 0.859 (+0.017); at 40% 0.895 vs 0.894 (converging).

ATLAS-v2.0: BSF Dice 0.712 / Lesion-F1 0.711 (single model) vs CTRL
challenge winner 0.663 (ensemble) and HeRN leaderboard 0.718 (ensemble).

No significance tests; effect sizes are raw Dice deltas.

## Strengths

- Large, diverse healthy-brain pretraining (41,400 subjects) yields
  transferable anatomy features unavailable to pathology-only training.
- Three-size family (62M/64M/69M) for deployment trade-offs.
- Modality-flexible inputs: single-modality adaptation is a channel-layer
  change, no architectural surgery.
- Competitive *as a single model* with ensemble baselines on ATLAS.
- Few-shot advantage holds at every data fraction tested.
- Code + weights public (`lab-smile/BrainSegFounder`).

## Weaknesses / open questions

- No formal significance tests; cross-fold variance is visual only.
- ATLAS evaluation lacks CV; not directly comparable to ensemble leaderboard entries.
- Stage 2 adds little over Stage 1 alone for the 62M model — unexplained.
- UKB cohort is 96.8% White British; demographic-bias implications for downstream clinical use are not discussed.
- No ablation on which SSL proxy task drives performance.
- No PEFT experiments — encoder is fully fine-tuned in all reported runs.
- No OOD evaluation across scanners, field strengths, sites.

## Relevance to my work

- For [[../../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth Prediction · Uncertainty Propagation]]: BSF is the segmentation backbone. The four-stage SwinViT encoder (resolutions $48^3 \to 24^3 \to 12^3 \to 6^3$) is the substrate for our LoRA adapters on `kqv + proj + fc1 + fc2` at all four stages.
- The Stage 1 UKB normal-anatomy prior is exactly what we want for meningiomas (extra-axial masses that displace normal structures): the encoder already knows what "normal" is, so the LoRA delta has only to encode displacement and mass cues.
- Few-shot evidence (BSF > SwinUNETR at every data fraction) directly supports our data-scarce regime (58 patients, ~174 studies).
- T1w-only result (Dice 0.721 vs 0.678) matters for our cohort if some patients lack the full BraTS-style modality stack.
- **Caveat for our setup**: BSF always trains the UNETR decoder during Stage 3. Our pipeline freezes the decoder and adapts only the encoder via LoRA — this departure from the paper's protocol is unvalidated and may bottleneck performance if decoder layers need to co-adapt. Worth flagging as a design decision (`decisions/`) and possibly ablating.

## Quotes (sparse, ≤15 words each)

- "two-stage pretraining ... normal brain anatomy first" — § method

## Related

- [[_MOC|Foundation models MOC]]
- [[../../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth project README]]
- [[../../../05_Attachments/2406.10395v3.pdf|PDF]]

#type/paper #status/review #domain/foundation-model #domain/brainsegfounder #domain/segmentation #venue/preprint
