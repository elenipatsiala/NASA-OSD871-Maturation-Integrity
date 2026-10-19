# Program Scoring Preregistration — v1

## Purpose

Program scores will summarize relative transcriptional activity of the preregistered biological programs across the 23 OSD-871 organoid samples.

The scores are exploratory biological summaries, not validated biomarkers.

## Frozen scoring rule

For each gene:

1. Use the NASA-processed normalized expression values.
2. Apply log2(expression + 1).
3. Standardize that gene across the 23 samples using a z-score.

For each biological program:

Program score = mean of the available gene-level z-scores in that frozen gene set.

All genes receive equal weight.

## Score direction

Higher Maturation score:
stronger maturation-associated transcription.

Higher Dopaminergic Identity / Integrity score:
stronger ventral-midbrain dopaminergic identity / dopamine-handling program.

Higher Progenitor / Cell-Cycle score:
stronger progenitor or proliferative state.

Higher Stress score:
stronger cellular-stress-associated transcription.

Astroglial and microglial gene sets will be displayed separately as annotations and will not be combined into the Stress score.

## Missing-gene rule

- Gene availability will be checked before scoring.
- Missing genes will be reported explicitly.
- Missing genes will not be imputed.
- Frozen gene sets will not be changed because a result is inconvenient.
- If genes are unavailable, any reduced score will be clearly labelled as using the available subset.

## No composite “goodness” score

Maturation and dopaminergic integrity will remain separate axes.

The analysis will not create a single “better organoid” score at this stage.

## Sensitivity analyses

After the primary scores are generated, robustness will be tested using:

- leave-one-gene-out scoring,
- reasonable alternative literature-derived marker subsets,
- donor/cell-line stratification where feasible.

These analyses will not replace the preregistered primary score.

## Status

Scoring rule frozen before program-score inspection: YES

Program scores inspected: NO

Version: v1