---
title: "Tag Taxonomy"
type: moc
status: active
created: 2026-05-08
updated: 2026-07-05
tags: [type/moc, meta/taxonomy, status/active]
---

# Tag Taxonomy

*Canonical hierarchical tag namespace. Adding a new tag is a meta change:
update this file in the same commit. Never invent ad-hoc tags.*

All tags are nested with `/`. Use the **most specific** level that still
fits. If a domain doesn't exist, add it here first.

*See also: [[conventions|Conventions]] · [[/99_Index|Vault Index]]*

## `#type/*` — what kind of note this is

- `#type/project` — top-level project entry
- `#type/session` — coding-session log
- `#type/paper` — literature note (one paper per note)
- `#type/concept` — atomic Zettel idea
- `#type/dataset` — dataset description
- `#type/decision` — architecture / design decision (ADR-style)
- `#type/experiment` — run / experiment log
- `#type/moc` — Map of Content
- `#type/area` — ongoing area (PARA "Areas")
- `#type/inbox` — quick capture, unprocessed
- `#type/tool` — software / library / framework
- `#type/book` — book / monograph note

## `#status/*` — workflow state

- `#status/draft` — incomplete, do not cite from elsewhere
- `#status/active` — currently being worked on
- `#status/review` — ready for self-review or revision
- `#status/done` — finished, frozen
- `#status/archived` — moved to `04_Archive/`
- `#status/blocked` — waiting on something external

## `#domain/*` — research domains (Mario-specific)

### Generative modelling

- `#domain/diffusion-models`
- `#domain/flow-matching`
- `#domain/score-matching`
- `#domain/latent-diffusion`
- `#domain/vae`
- `#domain/gan`
- `#domain/normalizing-flows`
- `#domain/consistency-models`
- `#domain/mean-flow`
- `#domain/repa` — REPresentation Alignment

### Medical imaging

- `#domain/medical-imaging`
- `#domain/brain-mri`
- `#domain/3d-mri`
- `#domain/glioma`
- `#domain/meningioma`
- `#domain/fcd-epilepsy`
- `#domain/segmentation`
- `#domain/synthesis`
- `#domain/longitudinal`
- `#domain/missing-modality`

### Foundation / representation

- `#domain/foundation-model`
- `#domain/ssl` — self-supervised learning
- `#domain/lora`
- `#domain/peft`
- `#domain/brainsegfounder` — BSF
- `#domain/maisi`

### Statistical modelling / forecasting

- `#domain/lme` — Linear Mixed-Effects models
- `#domain/heteroscedastic` — heteroscedastic noise models
- `#domain/growth-prediction` — volumetric / longitudinal growth forecasting
- `#domain/tumor-forecasting` — tumour-trajectory prediction
- `#domain/uncertainty-propagation` — propagation of upstream uncertainty into downstream models

### Methods / theory

- `#domain/uncertainty`
- `#domain/equivariance`
- `#domain/tokenization`
- `#domain/optimization`
- `#domain/evaluation-metrics`
- `#domain/fid-3d`

### Software / product (non-research side projects)

Added 2026-07-05 for BoatDex (non-research app). These extend the existing
`#domain/*` namespace to cover product-engineering subjects; no new
top-level namespace is introduced.

- `#domain/software-product` — a shipped product (vs. a research artifact)
- `#domain/product` — product definition / UX / go-to-market
- `#domain/mobile-app` — mobile client concerns
- `#domain/backend` — server-side / infrastructure
- `#domain/api-design` — HTTP/WS interface design
- `#domain/data-modeling` — relational / domain schema design
- `#domain/geospatial` — geographic data (PostGIS, coordinates)
- `#domain/social-graph` — friendship / social-network structure
- `#domain/information-retrieval` — IDF / surprisal / ranking (BoatDex rarity)
- `#domain/privacy-gdpr` — data protection / GDPR compliance

## `#project/*` — active project slugs

- `#project/repa-maisi-3d-mri`
- `#project/inter-lora-rank-bsf`
- `#project/meningioma-growth`
- `#project/mengrowth-prediction-uncertainty-propagation`
- `#project/slim-diff`
- `#project/boatdex`
- *(extend as projects start; mirror the folder slug under `01_Projects/`)*

## `#venue/*` — publication venues / conferences

- `#venue/miccai`
- `#venue/midl`
- `#venue/cvpr`
- `#venue/eccv`
- `#venue/iccv`
- `#venue/neurips`
- `#venue/iclr`
- `#venue/icml`
- `#venue/icip`
- `#venue/ieee-tmi` — IEEE Transactions on Medical Imaging
- `#venue/melba`
- `#venue/seram`

## `#dataset/*` — frequently referenced datasets

- `#dataset/brats-gli`
- `#dataset/brats-men`
- `#dataset/fomo-60k`
- `#dataset/fomo-300k`
- `#dataset/mengrowth`
- `#dataset/hospital-malaga` — local longitudinal cohort
- `#dataset/idri-fcd`

## `#priority/*` — only on `01_Projects/` and `02_Areas/` notes

- `#priority/p0` — drop everything
- `#priority/p1` — high
- `#priority/p2` — normal
- `#priority/p3` — backburner

## `#meta/*` — vault-internal infrastructure

- `#meta/conventions`
- `#meta/taxonomy`
- `#meta/template`
- `#meta/skill`

## Adding a new tag

1. Open this file.
2. Add the tag in the appropriate `#<namespace>/*` section, alphabetised.
3. If you're starting a new top-level namespace (rare), justify it in a
   one-line comment.
4. Commit with `meta(tags): add #<namespace>/<tag>`.

#type/moc #meta/taxonomy
