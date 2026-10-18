# Stress / Glial Program — Evidence v1

## Purpose

This module is intended to distinguish cellular stress from changes in glial identity or composition.

Stress and glial signals will NOT be combined into a single score.

The analysis will use:

1. a core cellular-stress score,
2. an astroglial annotation,
3. a microglial identity annotation.

This separation is important because glial presence is not inherently pathological, and microglia presence is already an experimental factor in OSD-871.

---

## A. Core Stress Program

| Gene | Include | Biological rationale |
|---|---|---|
| HSPA5 | YES | ER chaperone / unfolded-protein-response marker associated with cellular stress |
| HSP90B1 | YES | ER proteostasis chaperone elevated in organoid stress states |
| DDIT3 | YES | CHOP; canonical integrated-stress / ER-stress response gene |
| ATF4 | YES | Central transcriptional regulator of the integrated stress response |
| DNAJB1 | YES | Heat-shock / proteostasis-associated stress-response gene |
| PGK1 | YES | Glycolytic gene reported as enriched in stressed organoid populations |
| ARCN1 | YES | ER/Golgi-associated gene reported as enriched in organoid stress domains |
| GORASP2 | YES | Golgi/ER-associated stress marker reported in stressed organoid tissue |

### Interpretation

A higher stress score will be interpreted as stronger transcriptional evidence of cellular / proteostatic / metabolic stress.

It will NOT be interpreted as proof of cell death or dysfunction without additional evidence.

---

## B. Astroglial Annotation

The following genes will be examined as an annotation rather than averaged into the stress score:

| Gene | Role |
|---|---|
| GFAP | Astrocyte-associated intermediate filament |
| S100B | Astroglial marker used in human midbrain organoids |
| AQP4 | Mature astrocyte-associated water channel |
| ALDH1L1 | Broad astrocyte identity marker |

### Interpretation

An increase in astroglial markers will not automatically be treated as harmful.

It may reflect:
- altered cellular composition,
- developmental progression,
- astroglial maturation,
- or reactive-state changes.

These possibilities require separate interpretation.

---

## C. Microglial Identity Annotation

| Gene | Role |
|---|---|
| AIF1 | IBA1; microglia/macrophage identity marker |
| CX3CR1 | Microglial identity / signaling marker |
| P2RY12 | Homeostatic microglia marker |
| TMEM119 | Microglia-enriched identity marker |

### Interpretation

Because OSD-871 contains organoids cultured with and without microglia, these genes will be used primarily to verify or annotate microglial signal.

They will not be treated as a generic dysregulation score.

---

## Primary Evidence Sources

1. Bhaduri et al. — Cell stress in cortical organoids impairs molecular subtype specification
   https://pmc.ncbi.nlm.nih.gov/articles/PMC7433012/

2. Exposure to dolutegravir impairs structure and neurogenesis in a human forebrain organoid model
   https://pmc.ncbi.nlm.nih.gov/articles/PMC11576471/

3. Monzel et al. — Derivation of Human Midbrain-Specific Organoids from Neuroepithelial Stem Cells
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5425618/

4. Microglia integration into human midbrain organoids leads to increased neuronal maturation and functionality
   https://pmc.ncbi.nlm.nih.gov/articles/PMC9314680/

5. A microglia-containing cerebral organoid model to study early life immune challenges
   https://pmc.ncbi.nlm.nih.gov/articles/PMC11142229/

## Important Rule

The primary Iterate interpretation will focus on:

- maturation score,
- dopaminergic identity/integrity score,
- progenitor/cell-cycle score,
- stress score.

Astroglial and microglial signals will be displayed as separate annotations rather than combined with stress.

## Pre-score rule

These gene sets are frozen before OSD-871 program-score inspection.

Any alternative stress, astroglial or microglial set will be treated as a sensitivity analysis.

Status: STRESS / GLIAL v1 FROZEN