---
title: "Procedural uncertainty"
created: 2026-05-08
updated: 2026-05-08
type: concept
status: active
tags: [type/concept, status/active, domain/uncertainty]
aliases: ["Procedural epistemic uncertainty"]
sources:
  - "arxiv:2505.23506"
---

# Procedural uncertainty

*The variance component of epistemic uncertainty that arises from random training procedure (initialisation seeds), conditional on a fixed dataset. Deep ensembles capture procedural uncertainty; they are blind to the data component.*

## Definition

Let $\hat y(\boldsymbol{x}; \mathcal{D}_N, \gamma)$ be the prediction of a model trained on dataset $\mathcal{D}_N \sim P^N$ with random procedural seed $\gamma \sim P^\gamma$. By the law of total variance,

$$
\mathrm{Var}_{\mathcal{D}_N, \gamma}(\hat y \mid \boldsymbol{x})
\;=\;
\underbrace{\mathbb{E}_{\mathcal{D}_N}\!\left[\mathrm{Var}_{\gamma}(\hat y \mid \boldsymbol{x}, \mathcal{D}_N)\right]}_{\text{procedural uncertainty}}
\;+\;
\underbrace{\mathrm{Var}_{\mathcal{D}_N}\!\left(\mathbb{E}_{\gamma}[\hat y \mid \boldsymbol{x}, \mathcal{D}_N]\right)}_{\text{data uncertainty}}.
$$

A deep ensemble of $M$ members trained on a *fixed* $\mathcal{D}_N$ with seeds $\{\gamma_m\}$ estimates only the procedural component; the data component requires resampling $\mathcal{D}_N$.

## Why this distinction matters

- **Lower-bound semantics.** Any ensemble-derived "epistemic uncertainty" is a lower bound on the total epistemic component, not the full quantity. Reporting it as the latter overstates calibration claims.
- **Regularisation interaction.** Strong regularisation (LoRA, weight decay, dropout) compresses procedural variance and inflates aleatoric estimates via bias leakage (Jimenez et al. 2026). The lower bound shrinks as regularisation strengthens.
- **Cohort scale.** When $N$ is too small to support resampling $\mathcal{D}_N$ (medical-imaging regime), the data component is unobservable in practice; the procedural component is all you can measure.

## Where this concept is used

- [[../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth project]] — the LoRA ensemble's per-scan variance $\sigma^2_v$ is a procedural-uncertainty estimate, hence the project's emphasis on "procedural uncertainty propagation" as the precise claim.
- [[../papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026]] — formal grounding (Eq. 8).

## Related

- [[_MOC|Concepts MOC]]
- [[../papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026 — epistemic uncertainty incomplete]]

#type/concept #domain/uncertainty
