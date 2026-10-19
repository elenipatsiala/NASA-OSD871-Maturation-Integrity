# FROZEN CREATE SPEC — v1

## Working Name

LEO-NeuroTune

## Core Problem

A transcriptional shift can look more mature without necessarily preserving the biological identity or function required for a useful disease model.

The Create will therefore avoid treating maturation as a single “goodness” axis.

Instead, it will evaluate maturation and biological fidelity separately.

---

## Core Scientific Question

Can an interpretable framework distinguish:

1. maturation-associated transcription,
2. preservation of dopaminergic identity,
3. progenitor / cell-cycle state,
4. cellular stress,

so that “more mature” is not automatically interpreted as “better”?

---

## Create v1

LEO-NeuroTune will be an interactive, reproducible exploratory research framework for visualizing maturation and dopaminergic integrity as separate biological dimensions.

NASA OSD-871 will be used as the first demonstration dataset.

The framework will NOT be presented as a validated biomarker, diagnostic system or predictive model.

---

## Primary Inputs

For v1:

- gene-expression matrix,
- sample metadata,
- predefined literature-derived biological gene sets.

Primary demonstration dataset:

NASA OSD-871 dopaminergic organoids.

---

## Core Analysis

For each biological program:

1. log2(expression + 1),
2. gene-wise standardization,
3. equal-weight program score,
4. sample-level and group-level summaries.

Primary programs:

- Neuronal Maturation
- Dopaminergic Identity / Integrity
- Progenitor / Cell-Cycle
- Cellular Stress

Additional annotations:

- Astroglial state
- Microglial identity

---

## Flagship Visualization

The central visualization will be a two-dimensional Maturation–Integrity plane.

X-axis:

Neuronal Maturation

Y-axis:

Dopaminergic Identity / Integrity

Ground-to-LEO arrows will show how matched biological subgroups move across this space.

Stress and progenitor-state information will remain separate supporting layers.

---

## Interpretation Logic

The framework will distinguish patterns such as:

### Candidate useful maturation

Maturation increases while dopaminergic identity is preserved or increased, without strong stress dysregulation.

### Maturation–identity divergence

Maturation increases while dopaminergic identity decreases.

### Immature / progenitor-persistent state

Low maturation together with elevated progenitor / cell-cycle signal.

### Dysregulated state

Maturation-associated changes coexist with strong cellular stress or loss of identity.

These are exploratory interpretation patterns, not clinically validated categories.

---

## Robustness Layer

The tool should show whether an interpretation survives:

- leave-one-gene-out analysis,
- alternative reasonable literature-derived marker sets,
- subgroup stratification,
- donor / cell-line stratification where feasible.

A result that changes substantially under reasonable sensitivity tests should be labelled fragile.

---

## OSD-871 Demonstration Result

The current Iterate provides the first demonstration:

Overall LEO-associated pattern:

- Maturation increased
- Dopaminergic Identity increased
- Progenitor / Cell-Cycle decreased
- Stress decreased

All four overall directions survived leave-one-gene-out testing.

However, subgroup analysis identified important heterogeneity.

Control + microglia showed:

- increased Maturation
- decreased Dopaminergic Identity

This counterexample demonstrates why maturation and biological fidelity should remain separate dimensions.

---

## Allowed Claims

LEO-NeuroTune may be described as:

- an exploratory framework,
- an interpretable research tool,
- a framework for separating transcriptional maturation from dopaminergic fidelity,
- a hypothesis-generating approach,
- a reproducible scoring and visualization system.

---

## Forbidden Claims

LEO-NeuroTune must NOT currently be described as:

- a validated biomarker,
- a diagnostic system,
- a clinical tool,
- a predictor of Parkinson's disease,
- a validated measure of neuronal maturity,
- proof that microgravity improves organoids,
- proof that LEO produces better Parkinson's disease models,
- proof of functional maturation.

---

## Falsification Rule

The “useful maturation” interpretation must weaken when:

- maturation increases while dopaminergic identity decreases,
- stress increases substantially,
- results collapse under reasonable gene-set sensitivity,
- or functional evidence contradicts transcriptional maturation.

The framework must display such counterexamples rather than hide them.

---

## Create Deliverables

### 1. Interactive Research Tool

A polished interface showing:

- dataset overview,
- biological-program scores,
- Maturation–Integrity map,
- subgroup trajectories,
- stress / progenitor annotations,
- sensitivity results,
- interpretation warnings.

### 2. Reproducible Analysis Engine

Clean scripts that reproduce:

- gene-set scoring,
- maps,
- sensitivity analyses,
- summary tables.

### 3. Flagship Figure

A publication-quality LEO-NeuroTune Maturation–Integrity map.

### 4. Methods / Technical Note

A concise document explaining:

- biological rationale,
- scoring method,
- assumptions,
- limitations,
- robustness tests.

### 5. External Expert Review

Target feedback from researchers in:

- dopaminergic organoids,
- Parkinson's disease modelling,
- computational transcriptomics,
- or space biology.

Feedback must be documented and incorporated transparently.

---

## Create v1 Success Criteria

Create v1 is considered complete when:

- the interface works end-to-end,
- OSD-871 can be reproduced from clean inputs,
- biological programs are transparent,
- sensitivity results are visible,
- counterexamples are displayed,
- claims and non-claims are explicit,
- documentation is reproducible,
- at least one external expert has been contacted for targeted critique.

External response is desirable but cannot be falsely claimed if no response is received.

---

## Longer-Term Validation Needed

True validation would require additional independent datasets and ideally:

- protein-level dopaminergic markers,
- dopamine production / release,
- electrophysiology,
- cell-type composition measurements,
- single-cell transcriptomics,
- independent organoid lines,
- and additional altered-gravity datasets.

---

## Frozen Create Principle

**More mature is not necessarily more faithful.**

LEO-NeuroTune will keep maturation and dopaminergic fidelity separate and expose uncertainty rather than compressing biology into a single “better organoid” score.

Status: CREATE SPEC v1 FROZEN