---
title: "Synthesis: Stage 1 uncertainty-propagation arc — current state and live question"
created: 2026-05-08
updated: 2026-05-08
type: session
status: done
tags: [type/session, project/mengrowth-prediction-uncertainty-propagation, status/done, domain/uncertainty-propagation, domain/lme]
project: mengrowth-prediction-uncertainty-propagation
---

# Synthesis: Stage 1 uncertainty-propagation arc — current state and live question

*Reconstructs the empirical and methodological trajectory of the Stage 1 propagation chapter through the 11 UQ_PRED docs, locates the current open question (candidate-metrics diagnostic), and produces the in-vault notes that capture each step.*

## Source documents reviewed

`/home/mpascual/research/code/MenGrowth-Model/docs/UQ_PRED/`:

- `EXPERIMENT.md`
- `UQ_CALIBRATION_STORY.md`
- `UQ_CANDIDATE_METRICS_MOTIVATION.md` (foundational for the next step)
- `UQ_HETERO_CALIBRATION_ANSWER.md`
- `UQ_SIGMA_V_VS_M_RESULTS.md`
- `UQ_SMOOTH_SHIFT_STRESSTEST.md`
- `UQ_SYNTHETIC_VARIANCE_STRESSTEST.md`
- `UQ_SYNTHETIC_VARIANCE_STRESSTEST_RESULTS.md`
- `UQ_THESIS_GAP_ANALYSIS.md`

## What the trajectory looks like, end to end

1. **Pre-registered claim.** Heteroscedastic LME with $\sigma^2_{v,ij}$ from a LoRA $M{=}20$ ensemble of $\log(V+1)$ should improve marginal IS@95 and $\mathrm{cov}_{95}$ vs a homoscedastic LME baseline.
2. **First empirical hit.** Marginal LMEHetero is sharper but slightly under-covers ($\bar w_{95}$ 5.39→4.97, $\mathrm{cov}_{95}$ 0.893→0.875), CRPS flat. Root cause: bimodal $\sigma^2_v$ ($N{=}179$, median 0.0012, mean 0.4165, 11 scans with $\sigma_v>1$) → REML satisfies the **propagation budget identity** $\hat\sigma^2_{n,\text{homo}} \approx \hat\sigma^2_{n,\text{het}} + \overline{\sigma^2_v}$ ($0.95 \approx 0.55 + 0.40$). Modal scan: $s^{*2}_{\text{het}}\approx 0.55$ vs $s^{*2}_{\text{homo}}\approx 0.95$, so hetero is mechanically narrower than homo on the typical scan.
3. **Reframe to conditional calibration.** Tertile-stratified by $\sigma^2_{v,*}$, the textbook propagation result emerges: high tertile $\mathrm{IS@95}$ $17.66 \to 9.82$, $\mathrm{cov}_{95}$ $0.789 \to 0.895$. *Re-allocates sharpness where the data justifies it; homo is stuck at the average.*
4. **Robustness on $M$.** Cohort $\overline{\sigma^2_v}$ converges to $\pm 1\%$ from $m{\geq}5$; per-tertile means flat over $m{=}2{\dots}20$; per-scan MC stability ${\leq}20\%$ rel-SD by $m{\approx}10$. Effect is not an ensemble-size artefact.
5. **Causal stress test (16 cells × 10 seeds).** Decomposition of the $-8$ IS@95 high-tertile gap: **~91% structural** (statsmodels `MixedLM` predictive variance omits the FE term $\mathbf{x}^{*\top}\widehat{\mathrm{Cov}}(\hat\beta)\mathbf{x}^*$; LMEHetero's custom REML includes it), **~9% genuine $\sigma^2_v$ propagation**. Profile E (empirical pass-through) gives the lowest IS@95 in the sweep (informativeness, not just dispersion).
6. **QC reframe.** With `max_logvol_std=1.0` filter (drops 11 segmentation-failure scans → 54 patients, 163 scans), the high-tertile contrast collapses to $\Delta\mathrm{IS}{=}-3.28$ ($p{=}0.43$), $\Delta\mathrm{cov}{=}+0.118$ ($p{=}0.25$). Half the headline gain came from pipeline failures, not legitimate measurement noise.
7. **Scaling sweeps.** Beta $\alpha$-sweep and $\tau$-rescaling $\sigma^2_v(\tau){=}e^\tau \sigma^2_{v,\text{emp}}$: at $\tau{=}0$, $\Delta\mathrm{IS}{=}-0.04$, 0/20 BH-rejections; the only $\tau$ regime that "works" is brute-force coverage. **No monotone rescaling of an information-poor ranking adds information.**
8. **Live question.** Two competing live hypotheses:
   - **H1:** $\sigma^2_v=\mathrm{Var}_m[\log(V^{(m)}+1)]$ is the wrong scalar; a different summary of the same $M{=}20$ ensemble (boundary-restricted entropy, BALD/MI, MEN-region stats, composite) might track $|y_*-\hat\mu_*^{\text{homo}}|$.
   - **H2:** No scalar from the LoRA ensemble is informative on this cohort; residuals are dominated by Gompertz first-order linearisation $\delta_{\text{Gompertz}}(t_*)$ and biological volatility $\eta_{\text{biology}}(t_*)$, neither observable from segmentation.
9. **Diagnostic protocol** (`UQ_CANDIDATE_METRICS_MOTIVATION.md`). Two-stage:
   - **Stage 1 (cheap):** Spearman/Pearson/Kendall between candidate $c_k$ and $|y_k-\hat\mu_k^{\text{homo}}|$ over 54 LOPO targets, 95% BCa CI, $B{=}10\,000$. Pass at $|\hat\rho|>0.20$ with CI excluding zero (Steiger 1980).
   - **Stage 2 (~25 min/8 cores):** per-(candidate, scaling) LOPO-LMEHetero, paired BCa $\Delta\mathrm{IS}@95$ vs LME-homo, BH-FDR $q{=}0.05$.
10. **Status note on `spearman_results.json`.** Every record currently `{"rho": NaN, "p": NaN, "n_levels": 0}`. The loader has zero levels; this is the diagnostic stub *before* candidate vectors are wired in. **Not evidence for H2 yet** — Stage 1 has not been executed against actual candidate vectors.

## Notes captured in this session

- Decisions: frozen decoder · log(V+1) target · QC threshold · M=20 ensemble · FE-variance fix · candidate-metrics protocol
  - [[../decisions/0001--frozen-decoder-bsf-lora|0001 Frozen decoder for BSF+LoRA]]
  - [[../decisions/0002--logvol-plus-one-target|0002 log(V+1) target]]
  - [[../decisions/0003--qc-threshold-max-logvol-std|0003 QC threshold max_logvol_std=1.0]]
  - [[../decisions/0004--ensemble-size-m20|0004 M=20 LoRA ensemble]]
  - [[../decisions/0005--lme-predictive-variance-fe-term|0005 LME predictive variance includes FE term]]
  - [[../decisions/0006--candidate-metrics-staged-diagnostic|0006 Candidate-metrics two-stage diagnostic]]
- Experiments:
  - [[../experiments/2026-05-08--lme-homo-vs-hetero-marginal-and-tertile|LMEHomo vs LMEHetero — marginal + tertile-stratified]]
  - [[../experiments/2026-05-08--sigma-v-stability-vs-m|σ²_v stability vs ensemble size M]]
  - [[../experiments/2026-05-08--synthetic-variance-stresstest|Synthetic variance stress test (16 profile×level)]]
  - [[../experiments/2026-05-08--qc-filter-collapse|QC filter collapses propagation effect]]
  - [[../experiments/2026-05-08--smooth-shift-tau-sweep|Smooth-shift α-sweep and τ-scaling]]
- Working notes:
  - [[../notes/propagation-budget-identity|Propagation budget identity (REML)]]
  - [[../notes/lme-predictive-variance|LME predictive variance decomposition]]
  - [[../notes/interval-score-saturation|Interval Score saturation under monotone rescaling]]
  - [[../notes/residual-decomposition-h1-h2|Residual decomposition: H1 vs H2 framing]]
- Atomic concept (Zettel): [[../../../03_Resources/concepts/procedural-uncertainty|Procedural uncertainty]]

## Decisions made in this session

- Move all decisions/experiments/notes from the code repo's `docs/UQ_PRED/` into the vault as primary records (the code-repo docs become mirrors of the canonical vault notes). Keeps the literature/context layer with the rest of the research, separate from implementation.
- Treat `spearman_results.json` empty state as a *plumbing* state, not as evidence for H2.

## Next steps

- Wire candidate-metric vectors (`logvol-MAD`, $\mathrm{CV}^2$, mean entropy, BALD/MI, voxel variance, MEN-restricted entropy/MI, MEN-boundary entropy/MI, composite) into the diagnostic loader; re-run Stage 1.
- File a decision note on the headline metric (IS@95 vs CRPS vs coverage at fixed levels) — currently implicit.
- Run a frozen-decoder ablation (decoder-frozen vs decoder-trainable, LoRA-only delta) — flagged in [[../decisions/0001--frozen-decoder-bsf-lora|0001]].

## Related

- [[../_README|MenGrowth project README]]
- [[../_MOC|Project MOC]]
- [[../../../03_Resources/papers/uncertainty/jimenez2026--epistemic-uncertainty-incomplete|Jimenez 2026 — epistemic uncertainty incomplete]]

#type/session #project/mengrowth-prediction-uncertainty-propagation #domain/uncertainty-propagation #domain/lme
