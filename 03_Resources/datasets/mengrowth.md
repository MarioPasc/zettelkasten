---
title: "MenGrowth — UMA longitudinal meningioma cohort"
created: 2026-05-08
updated: 2026-05-08
type: dataset
status: active
tags: [type/dataset, status/active, domain/meningioma, domain/brain-mri, domain/longitudinal, dataset/mengrowth]
aliases: ["MenGrowth", "MenGrowth cohort"]
sources: []
---

# MenGrowth — UMA longitudinal meningioma cohort

*58-patient longitudinal meningioma MRI cohort, ~3 studies/patient, BraTS-style preprocessed, packed in HDF5 for the MenGrowth growth-prediction project.*

## Summary

- **Patients:** 58
- **Mean studies per patient:** 3 (longitudinal)
- **Preprocessing:** BraTS-style (skull-strip, co-registration to common atlas, intensity normalisation, resampling to 1 mm³)
- **Format:** HDF5 (one file per study or per patient — confirm in session log when first opened)
- **Storage path:** `/media/mpascual/MeningD2/MENINGIOMAS/MENGROWTH/050526/h5_format`
- **Provenance:** UMA / Hospital de Málaga collaboration (local longitudinal cohort)

## Use in projects

- [[../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth Prediction · Uncertainty Propagation]] — segmentation + LME growth model

## Splits

> [!note] To document
> Patient-level split (train/val/test) used for BSF+LoRA segmentation
> and for the LME fit. Record once the first coding session opens the
> H5 files.

## Caveats

- Small cohort relative to public BraTS-Men (`#dataset/brats-men`); useful for adaptation, not pretraining.
- Sparse longitudinal sampling (~3 timepoints) limits identifiability of complex random-effect structures in LME.
- Volumes near zero distort log-volume scaling — note the use of $\log(V+1)$ in growth models.

## Related

- [[../_MOC|03 Resources MOC]]
- [[../../06_Meta/tag-taxonomy|Tag taxonomy]]

#type/dataset #domain/meningioma #domain/longitudinal #dataset/mengrowth
