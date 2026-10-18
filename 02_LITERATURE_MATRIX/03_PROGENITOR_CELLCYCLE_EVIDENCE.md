# Progenitor / Cell-Cycle Program — Evidence v1

## Purpose

This program is intended to capture persistence of neural progenitor / radial-glial state and active cell-cycle / proliferative state.

The program deliberately separates progenitor identity from general neuronal maturation and avoids stress-associated cell-cycle arrest genes in the core score.

## Core genes frozen before program-score inspection

| Gene | Include | Biological rationale |
|---|---|---|
| SOX2 | YES | Canonical neural progenitor / radial-glial marker that decreases with maturation in human midbrain organoids |
| PAX6 | YES | Neural progenitor marker used to characterize human neuroepithelial stem / progenitor populations |
| NES | YES | Nestin; canonical neural progenitor marker |
| VIM | YES | Radial-glial / progenitor-associated intermediate filament marker |
| MKI67 | YES | Marker of actively cycling cells and proliferating neural progenitors |
| TOP2A | YES | Strong proliferative / cell-cycle marker in cycling midbrain progenitors |
| CCNB2 | YES | G2/M-associated cell-cycle gene enriched in proliferative floor-plate progenitors |
| CENPF | YES | Proliferation-associated gene enriched in cycling progenitor populations |

## Important interpretation rule

A higher score will be interpreted as stronger progenitor / proliferative state, not automatically as reduced neuronal quality.

A lower score is compatible with exit from the cell cycle and reduced progenitor state, but does not by itself prove functional neuronal maturation.

## Primary evidence sources

1. Monzel et al. — Derivation of Human Midbrain-Specific Organoids from Neuroepithelial Stem Cells
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5425618/

2. Fiorenzano et al. — Single-cell transcriptomics captures features of human midbrain development and dopamine neuron diversity in brain organoids
   https://pmc.ncbi.nlm.nih.gov/articles/PMC8674361/

3. A robust protocol for the generation of human midbrain organoids
   https://pmc.ncbi.nlm.nih.gov/articles/PMC8121770/

4. Single-cell transcriptional and functional analysis of dopaminergic neurons in organoid-like cultures derived from human fetal midbrain
   https://pmc.ncbi.nlm.nih.gov/articles/PMC10114107/

## Excluded from core v1

- CDKN1A — excluded because it may reflect cell-cycle arrest / stress rather than active proliferation
- GADD45A — excluded because it is strongly stress- and DNA-damage-associated
- CCND1 — biologically relevant to cell cycle, but omitted from core v1 to keep the score focused on canonical active-proliferation markers

These genes may be examined later as sensitivity / mechanistic annotations.

## Pre-score rule

This eight-gene progenitor / cell-cycle set will not be modified after inspecting OSD-871 program scores.

Any alternative version will be analysed separately as a sensitivity analysis.

Status: PROGENITOR / CELL-CYCLE v1 FROZEN