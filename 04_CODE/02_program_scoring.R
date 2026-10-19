# ============================================================
# 02_program_scoring.R
#
# ITERATE — preregistered biological program scoring
#
# Frozen rule:
# normalized NASA expression
# -> log2(expression + 1)
# -> gene-wise z-score across 23 samples
# -> mean z-score within each biological program
# ============================================================


# ------------------------------------------------------------
# 1. File paths
# ------------------------------------------------------------

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

metadata_file <- paste0(
  "../BUILD_LEO_Dopaminergic_Organoids/",
  "04_RESULTS/",
  "Master_Sample_Audit_Table.csv"
)


# ------------------------------------------------------------
# 2. Confirm required files exist
# ------------------------------------------------------------

stopifnot(file.exists(counts_file))
stopifnot(file.exists(dge_file))
stopifnot(file.exists(metadata_file))


# ------------------------------------------------------------
# 3. Load expression data
# ------------------------------------------------------------

counts <- read.csv(
  counts_file,
  row.names = 1,
  check.names = FALSE
)

metadata <- read.csv(
  metadata_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

dge <- read.csv(
  dge_file,
  check.names = FALSE
)

gene_map <- unique(
  dge[, c("ENSEMBL", "SYMBOL")]
)


# ------------------------------------------------------------
# 4. Frozen preregistered gene sets
# ------------------------------------------------------------

gene_sets <- list(
  
  Maturation = c(
    "MAP2",
    "NEFL",
    "NEFM",
    "SYP",
    "SYT1",
    "SNAP25",
    "VAMP2",
    "SYN1"
  ),
  
  Dopaminergic_identity = c(
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
  ),
  
  Progenitor_cellcycle = c(
    "SOX2",
    "PAX6",
    "NES",
    "VIM",
    "MKI67",
    "TOP2A",
    "CCNB2",
    "CENPF"
  ),
  
  Stress = c(
    "HSPA5",
    "HSP90B1",
    "DDIT3",
    "ATF4",
    "DNAJB1",
    "PGK1",
    "ARCN1",
    "GORASP2"
  ),
  
  Astroglial_annotation = c(
    "GFAP",
    "S100B",
    "AQP4",
    "ALDH1L1"
  ),
  
  Microglial_annotation = c(
    "AIF1",
    "CX3CR1",
    "P2RY12",
    "TMEM119"
  )
)


# ------------------------------------------------------------
# 5. Convert gene symbols to Ensembl IDs
# ------------------------------------------------------------

score_gene_table <- do.call(
  rbind,
  lapply(
    names(gene_sets),
    function(program_name) {
      
      genes <- gene_sets[[program_name]]
      
      data.frame(
        Program = program_name,
        SYMBOL = genes,
        stringsAsFactors = FALSE
      )
    }
  )
)

score_gene_table <- merge(
  score_gene_table,
  gene_map,
  by = "SYMBOL",
  all.x = TRUE
)

stopifnot(!any(is.na(score_gene_table$ENSEMBL)))

stopifnot(
  all(
    score_gene_table$ENSEMBL %in%
      rownames(counts)
  )
)


# ------------------------------------------------------------
# 6. Extract only preregistered genes
# ------------------------------------------------------------

expr <- counts[
  score_gene_table$ENSEMBL,
  ,
  drop = FALSE
]

rownames(expr) <- score_gene_table$SYMBOL


# ------------------------------------------------------------
# 7. Log-transform
# ------------------------------------------------------------

expr_log2 <- log2(expr + 1)


# ------------------------------------------------------------
# 8. Gene-wise z-score across the 23 samples
# ------------------------------------------------------------

expr_z <- t(
  apply(
    expr_log2,
    1,
    function(x) {
      
      if (sd(x, na.rm = TRUE) == 0) {
        return(rep(0, length(x)))
      }
      
      as.numeric(scale(x))
    }
  )
)

colnames(expr_z) <- colnames(expr_log2)
rownames(expr_z) <- rownames(expr_log2)


# ------------------------------------------------------------
# 9. Score each biological program
# ------------------------------------------------------------

program_scores <- sapply(
  names(gene_sets),
  function(program_name) {
    
    genes <- gene_sets[[program_name]]
    
    colMeans(
      expr_z[genes, , drop = FALSE],
      na.rm = TRUE
    )
  }
)

program_scores <- as.data.frame(
  program_scores,
  stringsAsFactors = FALSE
)

program_scores$sample_id <- rownames(program_scores)


# ------------------------------------------------------------
# 10. Put sample ID first
# ------------------------------------------------------------

program_scores <- program_scores[
  ,
  c(
    "sample_id",
    "Maturation",
    "Dopaminergic_identity",
    "Progenitor_cellcycle",
    "Stress",
    "Astroglial_annotation",
    "Microglial_annotation"
  )
]


# ------------------------------------------------------------
# 11. Join biological metadata
# ------------------------------------------------------------

score_table <- merge(
  metadata,
  program_scores,
  by = "sample_id",
  all.x = TRUE,
  sort = FALSE
)

stopifnot(nrow(score_table) == 23)

stopifnot(
  !any(
    is.na(
      score_table$Maturation
    )
  )
)


# ------------------------------------------------------------
# 12. Create cleaner plotting labels
# ------------------------------------------------------------

score_table$gravity_plot <- ifelse(
  score_table$gravity == "Space Flight",
  "LEO",
  "Ground"
)

score_table$microglia_plot <- ifelse(
  grepl(
    "^with microglia$",
    trimws(score_table$microglia),
    ignore.case = TRUE
  ),
  "With",
  "Without"
)

score_table$disease_plot <- ifelse(
  grepl(
    "Parkinson",
    score_table$disease,
    ignore.case = TRUE
  ),
  "PD",
  "Control"
)


# ------------------------------------------------------------
# 13. Group-level descriptive summaries
# ------------------------------------------------------------

score_columns <- c(
  "Maturation",
  "Dopaminergic_identity",
  "Progenitor_cellcycle",
  "Stress",
  "Astroglial_annotation",
  "Microglial_annotation"
)

group_summary <- aggregate(
  score_table[, score_columns],
  by = list(
    gravity = score_table$gravity_plot,
    disease = score_table$disease_plot,
    microglia = score_table$microglia_plot
  ),
  FUN = mean,
  na.rm = TRUE
)


# ------------------------------------------------------------
# 14. Ground-versus-LEO overall summary
# ------------------------------------------------------------

gravity_summary <- aggregate(
  score_table[, score_columns],
  by = list(
    gravity = score_table$gravity_plot
  ),
  FUN = mean,
  na.rm = TRUE
)


# ------------------------------------------------------------
# 15. Print first results
# ------------------------------------------------------------

message(
  "\n=== SAMPLE-LEVEL PROGRAM SCORES ==="
)

print(
  score_table[
    ,
    c(
      "sample_id",
      "gravity_plot",
      "disease_plot",
      "microglia_plot",
      score_columns
    )
  ]
)


message(
  "\n=== GROUND VS LEO MEAN SCORES ==="
)

print(gravity_summary)


message(
  "\n=== STRATIFIED MEAN SCORES ==="
)

print(group_summary)


# ------------------------------------------------------------
# 16. Save outputs
# ------------------------------------------------------------

dir.create(
  "05_RESULTS",
  showWarnings = FALSE,
  recursive = TRUE
)

write.csv(
  score_table,
  "05_RESULTS/Program_Scores_Sample_Level.csv",
  row.names = FALSE
)

write.csv(
  gravity_summary,
  "05_RESULTS/Program_Scores_Ground_vs_LEO.csv",
  row.names = FALSE
)

write.csv(
  group_summary,
  "05_RESULTS/Program_Scores_Stratified.csv",
  row.names = FALSE
)

write.csv(
  expr_z,
  "05_RESULTS/Program_Gene_Zscores.csv"
)


message(
  "\nPROGRAM SCORING COMPLETED SUCCESSFULLY"
)
