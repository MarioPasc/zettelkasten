---
title: "Jimenez2026 — Epistemic uncertainty estimation methods are fundamentally incomplete"
created: 2026-05-08
updated: 2026-05-08
type: paper
status: review
tags: [type/paper, status/review, domain/uncertainty, venue/preprint]
aliases: ["Position: Epistemic uncertainty estimation methods are fundamentally incomplete"]
sources:
  - "arxiv:2505.23506"
authors: ["Sebastian Jimenez", "Mira Jurgens", "Willem Waegeman"]
year: 2026
venue: "arXiv preprint (position paper)"
---

# Jimenez2026 — Epistemic uncertainty estimation methods are fundamentally incomplete

*All second-order epistemic uncertainty estimators (deep ensembles included) are provably partial: variance-based methods capture procedural uncertainty but are blind to data uncertainty, so estimates should be read as lower bounds.*

## TL;DR

The paper argues all widely-used epistemic uncertainty estimators fail
on two counts. First, estimation bias from regularisation and finite
data leaks into the aleatoric term, inflating it and compressing the
epistemic term. Second, variance-based decompositions partition
epistemic uncertainty into a *procedural* component (random seed /
initialisation) and a *data* component (training-set sampling), and each
existing method captures at most one. Deep ensembles, in particular,
capture only the procedural component when trained on the same dataset.
The paper formalises this via a bias–variance–Bregman framework,
validates it on synthetic heteroscedastic regression, and recommends
treating epistemic estimates as lower bounds and combining complementary
methods.

## Problem

Existing second-order uncertainty methods claim to disentangle aleatoric
from epistemic uncertainty, but (a) regularisation-induced bias
conflates the two, and (b) the variance component of epistemic
uncertainty itself has two irreducible sub-components — procedural
(initialisation/seed) and data (training-set sampling) — which no single
method captures simultaneously. The literature treats epistemic
estimates as complete characterisations when they are provably partial.

## Method

The paper uses a strictly proper scoring rule $\ell$ with Bregman divergence $D_\ell$ and entropy $\mathbb{H}_\ell$. The generalised bias–variance decomposition is

$$
\mathbb{E}_{\mathcal{D}_N, \gamma}[\mathcal{L}(\hat{p})]
= \underbrace{\mathbb{H}_\ell(p(y\mid\boldsymbol{x}))}_{\text{aleatoric}}
+ \underbrace{D_\ell(p(y\mid\boldsymbol{x}), \bar{p}^*(y\mid\boldsymbol{x}))}_{\text{generalised bias}}
+ \underbrace{\mathbb{E}_{\mathcal{D}_N, \gamma}\!\left[D_\ell(\bar{p}^*(y\mid\boldsymbol{x}), \hat{p}_{N,\gamma}(y\mid\boldsymbol{x}))\right]}_{\text{generalised variance}}.
$$

The variance term decomposes by the law of total variance into

$$
\mathrm{Var}_{\mathcal{D}_N, \gamma}(\hat{y}\mid\boldsymbol{x})
= \underbrace{\mathbb{E}_{\mathcal{D}_N}\!\left[\mathrm{Var}_{\gamma}(\hat{y}\mid\boldsymbol{x},\mathcal{D}_N)\right]}_{\text{procedural}}
+ \underbrace{\mathrm{Var}_{\mathcal{D}_N}\!\left(\mathbb{E}_{\gamma}[\hat{y}\mid\boldsymbol{x},\mathcal{D}_N]\right)}_{\text{data}}.
$$

For deep ensembles with random seed $\gamma$ trained on a fixed dataset, the
epistemic estimate converges to

$$
\mathrm{Var}_{\gamma}\!\left(\mathbb{E}_{y\mid\boldsymbol{x}}[\hat{y}\mid\boldsymbol{x},\gamma]\right)
= \mathbb{E}_{\gamma}\!\left[(f_{\gamma_i}(\boldsymbol{x}) - \bar{f}(\boldsymbol{x}))^2\right],
$$

which is exactly the procedural component; the data term
$\mathrm{Var}_{\mathcal{D}_N}(\mathbb{E}_{\gamma}[\hat{y}\mid\boldsymbol{x},\mathcal{D}_N])$
is absent. A reference distribution $q_{N,\gamma}(\boldsymbol{\theta}\mid\boldsymbol{x},\phi)$
that marginalises over both $P^N$ (dataset draws) and $P^\gamma$
(procedural draws) provides an upper bound for comparison.

Key assumption: a fixed conditional ground-truth $p(y\mid\boldsymbol{x})$;
distributional shift is treated separately as "distributional uncertainty."

## Results

Synthetic heteroscedastic regression
$y_i = \sin(1/(5(x_i+0.16)^3)) + \varepsilon_i$, $\varepsilon_i \sim \mathcal{N}(0, x_i^4)$,
$x_i \sim \mathrm{Beta}(1.2, 0.5)$:

- Deep ensembles ($d{=}10$) produce epistemic estimates consistently below
  the reference distribution variance across the input domain (Fig. 4),
  empirically confirming procedural-only capture.
- Across the second-order methods evaluated (Appendix C.2–C.3), every
  epistemic estimate falls systematically below the reference distribution.
- Bayesian methods with richer posteriors give higher epistemic estimates
  in low-data regimes, but this is attributed to failure to learn the data
  variance — not to correctly capturing data uncertainty.

No tabular numbers, no significance tests, no confidence intervals in
the main text; conclusions rely on visual inspection of figures and a
single synthetic dataset.

## Strengths

- Eq. 8's procedural/data decomposition is a clean formal basis for
  what deep ensembles actually measure.
- The reference-distribution framework gives a principled upper bound
  against which any second-order method can be compared.
- The "lower-bound" reading is directly actionable for practitioners.
- The bias argument explains why learned aleatoric uncertainty absorbs
  systematic prediction error.

## Weaknesses / open questions

- Restricted to second-order methods; conformal and credal-set methods
  are out of scope.
- The reference distribution requires $n_d \times n_\gamma$ independent
  fits — infeasible at medical-imaging scale ($N \ll 100$).
- Position paper, no formal venue, no peer review.
- No analysis of severe model misspecification (e.g. foundation model
  fine-tuned with LoRA), which is the user's regime.
- All conclusions rely on a single 1D synthetic experiment in the main text.

## Relevance to my work

- For [[../../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth Prediction · Uncertainty Propagation]]: directly grounds the claim that deep-ensemble variance is a *lower bound* on epistemic uncertainty. Eq. 8 is the citation that licenses calling our quantity "procedural uncertainty" rather than "epistemic uncertainty" full stop.
- The propagated $\sigma_i^2$ used in the heteroscedastic LME inherits this lower-bound character; report it as such in the thesis.
- The bias argument warns that LoRA acts as a regulariser that further compresses the epistemic estimate — flag in the limitations section.
- Citation context: "Deep ensembles capture procedural uncertainty — variation across initialisation seeds trained on a fixed dataset — but not the data-sampling component of epistemic uncertainty (Jimenez et al., 2026, arXiv:2505.23506); our ensemble-derived variance therefore constitutes a lower bound on total epistemic uncertainty."

## Quotes (sparse, ≤15 words each)

- "treat epistemic uncertainty estimates as lower bounds on reducible uncertainty" — § discussion

## Related

- [[_MOC|Uncertainty MOC]]
- [[../../../01_Projects/mengrowth-prediction-uncertainty-propagation/_README|MenGrowth project README]]
- [[../../../05_Attachments/2505.23506v3.pdf|PDF]]

#type/paper #status/review #domain/uncertainty #venue/preprint
