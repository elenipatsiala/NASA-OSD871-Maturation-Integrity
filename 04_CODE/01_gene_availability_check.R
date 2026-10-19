# ============================================================
# 01_gene_availability_check.R
# Purpose:
# Check whether preregistered Iterate genes are available
# in the NASA OSD-871 expression matrix BEFORE scoring.
# ============================================================


# ----------------------------
# 1. Define Build data paths
# ----------------------------

counts_file <- paste0(
  "../BUILD_LEO_Dopaminergic_Organoids/",
  "01_RAW_DATA/",
  "GLDS-720_rna_seq_Normalized_Counts_GLbulkRNAseq.csv"
)

dge_file <- paste0(
  "../BUILD_LEO_Dopaminergic_Organoids/",
  "04_RESULTS/",
  "GLDS-720_rna_seq_differential_expression_GLbulkRNAseq.csv"
)


# ----------------------------
# 2. Confirm files exist
# ----------------------------

stopifnot(file.exists(counts_file))
stopifnot(file.exists(dge_file))


# ----------------------------
# 3. Load expression matrix
# ----------------------------

counts <- read.csv(
  counts_file,
  row.names = 1,
  check.names = FALSE
)


# ----------------------------
# 4. Load NASA gene annotation
# ----------------------------

dge <- read.csv(
  dge_file,
  check.names = FALSE
)

gene_map <- unique(
  dge[, c("ENSEMBL", "SYMBOL")]
)


# ----------------------------
# 5. Frozen Iterate gene sets
# ----------------------------

maturation_genes <- c(
  "MAP2",
  "NEFL",
  "NEFM",
  "SYP",
  "SYT1",
  "SNAP25",
  "VAMP2",
  "SYN1"
)

dopaminergic_identity_genes <- c(
  "FOXA2",
  "LMX1A",
  "EN1",
  "NR4A2",
  "PITX3",
  "TH",
  "DDC",
  "SLC6A3",
  "SLC18A2",
  "KCNJ6"
)

progenitor_cellcycle_genes <- c(
  "SOX2",
  "PAX6",
  "NES",
  "VIM",
  "MKI67",
  "TOP2A",
  "CCNB2",
  "CENPF"
)

stress_genes <- c(
  "HSPA5",
  "HSP90B1",
  "DDIT3",
  "ATF4",
  "DNAJB1",
  "PGK1",
  "ARCN1",
  "GORASP2"
)

astroglial_genes <- c(
  "GFAP",
  "S100B",
  "AQP4",
  "ALDH1L1"
)

microglial_genes <- c(
  "AIF1",
  "CX3CR1",
  "P2RY12",
  "TMEM119"
)


# ----------------------------
# 6. Build preregistered table
# ----------------------------

frozen_genes <- data.frame(
  SYMBOL = c(
    maturation_genes,
    dopaminergic_identity_genes,
    progenitor_cellcycle_genes,
    stress_genes,
    astroglial_genes,
    microglial_genes
  ),
  
  Program = c(
    rep("Maturation", length(maturation_genes)),
    rep(
      "Dopaminergic_identity",
      length(dopaminergic_identity_genes)
    ),
    rep(
      "Progenitor_cellcycle",
      length(progenitor_cellcycle_genes)
    ),
    rep("Stress", length(stress_genes)),
    rep("Astroglial_annotation", length(astroglial_genes)),
    rep("Microglial_annotation", length(microglial_genes))
  ),
  
  stringsAsFactors = FALSE
)


# ----------------------------
# 7. Match symbols to Ensembl IDs
# ----------------------------

availability <- merge(
  frozen_genes,
  gene_map,
  by = "SYMBOL",
  all.x = TRUE
)

availability$Present_in_expression_matrix <-
  availability$ENSEMBL %in% rownames(counts)


# ----------------------------
# 8. Print full availability table
# ----------------------------

print(
  availability[
    order(
      availability$Program,
      availability$SYMBOL
    ),
  ]
)


# ----------------------------
# 9. Summarize by biological program
# ----------------------------

availability_summary <- aggregate(
  Present_in_expression_matrix ~ Program,
  data = availability,
  FUN = function(x) {
    paste0(sum(x), "/", length(x))
  }
)

print(availability_summary)


# ----------------------------
# 10. Explicitly list unavailable genes
# ----------------------------

missing_genes <- availability[
  !availability$Present_in_expression_matrix |
    is.na(availability$Present_in_expression_matrix),
]

print("Unavailable preregistered genes:")
print(missing_genes)


# ----------------------------
# 11. Save audit tables
# ----------------------------

dir.create(
  "05_RESULTS",
  showWarnings = FALSE,
  recursive = TRUE
)

write.csv(
  availability,
  "05_RESULTS/Gene_Availability_Audit.csv",
  row.names = FALSE
)

write.csv(
  availability_summary,
  "05_RESULTS/Gene_Availability_Summary.csv",
  row.names = FALSE
)
source("04_CODE/01_gene_availability_check.R")
# 01_gene_availability_check.R

counts_file <- "../BUILD_LEO_Dopaminergic_Organoids/01_RAW_DATA/GLDS-720_rna_seq_Normalized_Counts_GLbulkRNAseq.csv"

dge_file <- "../BUILD_LEO_Dopaminergic_Organoids/04_RESULTS/GLDS-720_rna_seq_differential_expression_GLbulkRNAseq.csv"

stopifnot(file.exists(counts_file))
stopifnot(file.exists(dge_file))

counts <- read.csv(
  counts_file,
  row.names = 1,
  check.names = FALSE
)

dge <- read.csv(
  dge_file,
  check.names = FALSE
)

gene_map <- unique(
  dge[, c("ENSEMBL", "SYMBOL")]
)

maturation_genes <- c(
  "MAP2", "NEFL", "NEFM", "SYP",
  "SYT1", "SNAP25", "VAMP2", "SYN1"
)

dopaminergic_identity_genes <- c(
  "FOXA2", "LMX1A", "EN1", "NR4A2", "PITX3",
  "TH", "DDC", "SLC6A3", "SLC18A2", "KCNJ6"
)

progenitor_cellcycle_genes <- c(
  "SOX2", "PAX6", "NES", "VIM",
  "MKI67", "TOP2A", "CCNB2", "CENPF"
)

stress_genes <- c(
  "HSPA5", "HSP90B1", "DDIT3", "ATF4",
  "DNAJB1", "PGK1", "ARCN1", "GORASP2"
)

astroglial_genes <- c(
  "GFAP", "S100B", "AQP4", "ALDH1L1"
)

microglial_genes <- c(
  "AIF1", "CX3CR1", "P2RY12", "TMEM119"
)

frozen_genes <- data.frame(
  SYMBOL = c(
    maturation_genes,
    dopaminergic_identity_genes,
    progenitor_cellcycle_genes,
    stress_genes,
    astroglial_genes,
    microglial_genes
  ),
  Program = c(
    rep("Maturation", length(maturation_genes)),
    rep("Dopaminergic_identity", length(dopaminergic_identity_genes)),
    rep("Progenitor_cellcycle", length(progenitor_cellcycle_genes)),
    rep("Stress", length(stress_genes)),
    rep("Astroglial_annotation", length(astroglial_genes)),
    rep("Microglial_annotation", length(microglial_genes))
  ),
  stringsAsFactors = FALSE
)

availability <- merge(
  frozen_genes,
  gene_map,
  by = "SYMBOL",
  all.x = TRUE
)

availability$Present_in_expression_matrix <-
  availability$ENSEMBL %in% rownames(counts)

availability_summary <- aggregate(
  Present_in_expression_matrix ~ Program,
  data = availability,
  FUN = function(x) paste0(sum(x), "/", length(x))
)

missing_genes <- availability[
  is.na(availability$ENSEMBL) |
    !availability$Present_in_expression_matrix,
]

print(availability_summary)

print("Unavailable preregistered genes:")
print(missing_genes)

dir.create(
  "05_RESULTS",
  showWarnings = FALSE,
  recursive = TRUE
)

write.csv(
  availability,
  "05_RESULTS/Gene_Availability_Audit.csv",
  row.names = FALSE
)

write.csv(
  availability_summary,
  "05_RESULTS/Gene_Availability_Summary.csv",
  row.names = FALSE
)
