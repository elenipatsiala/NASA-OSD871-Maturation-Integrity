# ITERATE GATE REPORT

## Central Question

Does the LEO-associated transcriptional maturation phenotype in human dopaminergic organoids represent biologically useful maturation while preserving dopaminergic identity and integrity, or can the apparent maturation signal coexist with loss of identity, stress or altered developmental state?

---

## 1. Predeclared Framework

Before inspecting program-score results, four biological programs were defined from published literature:

1. Neuronal Maturation
2. Dopaminergic Identity / Integrity
3. Progenitor / Cell-Cycle
4. Cellular Stress

Astroglial and microglial signals were retained as separate annotations rather than combined with the Stress score.

The scoring rule was also frozen before result inspection:

- NASA-processed normalized expression
- log2(expression + 1)
- gene-wise z-score across the 23 samples
- equal-weight mean across genes in each program

All preregistered genes were present in the OSD-871 expression matrix.

---

## 2. Overall Ground-versus-LEO Result

Mean program scores showed the following LEO-associated pattern:

- Maturation: increased
- Dopaminergic Identity / Integrity: increased
- Progenitor / Cell-Cycle: decreased
- Stress: decreased

Approximate LEO minus Ground shifts:

- Maturation: +0.475
- Dopaminergic Identity: +0.193
- Progenitor / Cell-Cycle: -0.586
- Stress: -0.606

At the overall level, this pattern is consistent with the preregistered useful-maturation hypothesis.

---

## 3. Subgroup Heterogeneity

The overall pattern was not universal.

Maturation increased in all four matched subgroups.

Dopaminergic Identity increased in three of four matched subgroups.

The exception was:

**Control + microglia**

In this subgroup:

- Maturation increased
- Dopaminergic Identity decreased
- Stress decreased

This is an important counterexample because it shows that maturation-associated transcription can increase without preservation of dopaminergic identity.

Therefore, maturation and dopaminergic fidelity should remain separate biological axes.

---

## 4. Leave-One-Gene-Out Sensitivity

The overall program-score directions were robust to removal of any single gene.

Overall directional preservation:

- Maturation: 8/8 leave-one-gene-out tests
- Dopaminergic Identity: 10/10
- Progenitor / Cell-Cycle: 8/8
- Stress: 8/8

No overall direction failures occurred.

This indicates that the overall pattern is not driven by a single gene.

However, subgroup sensitivity revealed important exceptions.

### Control + microglia

The decrease in Dopaminergic Identity persisted across all leave-one-gene-out versions.

This makes the subgroup counterexample more convincing because it is not driven by one individual identity gene.

### PD without microglia

Dopaminergic Identity increased in the primary score, but removal of DDC reversed the direction.

This subgroup is therefore largely, but not completely, robust.

### Control without microglia

The Stress decrease was fragile.

Removal of HSPA5, HSP90B1, DDIT3 or ATF4 reversed the Stress direction.

Therefore, reduced Stress should not be considered a robust conclusion in this subgroup.

---
## Pathway-Level Evidence

As a secondary exploratory analysis, selected MSigDB Hallmark gene sets were scored using the same transparent sample-level framework used for the preregistered biological programs.

This was curated pathway scoring rather than formal GSEA.

All eight selected Hallmark pathways showed lower overall mean scores in LEO than Ground:

- TNFA signaling via NF-kB: -0.538
- E2F targets: -0.338
- G2M checkpoint: -0.333
- Unfolded protein response: -0.238
- Inflammatory response: -0.197
- Oxidative phosphorylation: -0.191
- Reactive oxygen species pathway: -0.122
- Glycolysis: -0.080

The decreases in E2F Targets and G2M Checkpoint are consistent with the preregistered reduction in progenitor / cell-cycle state.

Lower TNFA/NF-kB, inflammatory-response and unfolded-protein-response scores are broadly consistent with lower stress / inflammatory-associated transcription overall.

However, the reduction in oxidative-phosphorylation score indicates that the pathway-level response should not be interpreted simply as globally beneficial maturation. It may also reflect metabolic remodeling or altered cellular composition.

Subgroup results were not perfectly uniform. Small positive shifts occurred for some pathways in specific Control conditions, reinforcing the conclusion that the LEO response is heterogeneous rather than universal.

Therefore, pathway-level evidence supports a broader LEO-associated transcriptional state shift, but does not independently demonstrate functional maturation.

## 5. Cross-Study Triangulation

Comparison with the Park et al. 2026 clinostat cerebral-organoid study provided an important challenge to a simplistic maturation interpretation.

In the clinostat model, reduced SOX2 / stemness-associated transcription occurred alongside:

- reduced neuronal differentiation-associated genes,
- reduced regional-identity programs,
- lower dopamine and other neurotransmitters,
- and increased GFAP.

This demonstrates that reduced progenitor-associated transcription does not automatically indicate beneficial neuronal maturation.

The clinostat study is not a direct replication of OSD-871 because:

- cerebral organoids are not dopaminergic organoids,
- a 3D clinostat is not actual ISS / LEO spaceflight,
- and the studies use different biological readouts.

It is therefore used for triangulation rather than direct comparison.

---

## 6. What the Iterate Supports

The current evidence supports the following qualified interpretation:

**OSD-871 shows an overall LEO-associated transcriptional shift toward higher neuronal maturation, lower progenitor / cell-cycle state and higher dopaminergic identity, with the overall directions robust to removal of individual genes.**

However:

**preservation of dopaminergic identity is subgroup-dependent, and maturation-associated transcription should not be interpreted as proof of functional or biologically faithful maturation.**

---

## 7. What the Iterate Does NOT Support

This analysis does not demonstrate that:

- LEO universally improves dopaminergic organoids,
- microgravity itself caused the observed effects,
- the organoids are functionally more mature,
- dopamine release or electrophysiological function improved,
- LEO produces a better Parkinson's disease model,
- disease-specific differences can be generalized,
- or the proposed program scores are validated biomarkers.

---

## 8. Falsification Outcome

The framework was designed so that the useful-maturation interpretation would weaken if maturation increased while dopaminergic identity decreased or stress increased substantially.

A partial counterexample was observed:

**Control + microglia showed increased maturation but decreased dopaminergic identity.**

Therefore, the framework did not simply confirm the original hypothesis.

Instead, it identified biological heterogeneity that would have been hidden by the overall average.

---

## 9. ITERATE GATE DECISION

**PASS — with a qualified claim.**

The maturation-versus-integrity framework:

- was defined before final score inspection,
- produced an interpretable overall pattern,
- survived overall leave-one-gene-out sensitivity testing,
- identified meaningful subgroup heterogeneity,
- and generated a falsifiable distinction between maturation and dopaminergic fidelity.

The next stage should therefore not attempt to build a single “maturity score.”

The Create stage should instead develop an interpretable framework that keeps maturation and biological fidelity as separate dimensions.

---

## Frozen Core Insight

**More mature is not necessarily more faithful.**

A useful dopaminergic organoid model should not only show maturation-associated transcription, but should also preserve dopaminergic identity and avoid major dysregulation.

Status: ITERATE GATE PASSED