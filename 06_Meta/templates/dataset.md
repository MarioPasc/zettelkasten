---
title: "<Dataset Name>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: dataset
status: active
tags: [type/dataset, status/active, domain/<x>, dataset/<slug>]
sources: []
---

# <Dataset Name>

*<One-line: what is this dataset and why do I have it.>*

## Provenance

- **Source:** <URL / DOI / origin institution>
- **Licence:** <licence terms>
- **Access:** <how it was acquired; ethical approvals if applicable>
- **Local path:** `<absolute path on Picasso / local>`
- **Size:** N subjects, M scans, X GB

## Modalities and structure

| Modality | Resolution | Format | Notes |
|----------|------------|--------|-------|
| T1w      | 1×1×1 mm³  | NIfTI  | …     |
| T2w      | …          | NIfTI  | …     |

Directory layout:

```
<dataset-root>/
  subject_id/
    session_id/
      T1w.nii.gz
      ...
```

## Splits

- Train: N subjects, listed in `<path/to/train.txt>`
- Val:   N subjects, listed in `<path/to/val.txt>`
- Test:  N subjects, listed in `<path/to/test.txt>`

Stratification rationale: <one or two lines>.

## Preprocessing

The pipeline applied before this dataset is consumable. Link to the
script or BraTS-Orchestrator config.

1. Skull-strip with HD-BET.
2. Co-register to MNI152.
3. ...

## Known issues / quirks

- ...

## Used in

- [[01_Projects/<project>/_README|<Project>]] — <how>

## Related

- [[../_MOC|03_Resources/datasets MOC]]

#type/dataset #domain/<x> #dataset/<slug> #status/active
