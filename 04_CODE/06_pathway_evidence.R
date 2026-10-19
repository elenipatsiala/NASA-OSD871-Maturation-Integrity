# ============================================================
# 06_pathway_evidence.R
#
# ITERATE — secondary pathway-level evidence
#
# Method:
# MSigDB Hallmark gene sets
# -> log2(expression + 1)
# -> gene-wise z-score across 23 samples
# -> mean z-score across genes in each Hallmark set
#
# IMPORTANT:
# This is exploratory curated gene-set scoring.
# It is NOT being presented as formal GSEA.
# ============================================================


# ------------------------------------------------------------
# 1. Required packages
# ------------------------------------------------------------

if (!requireNamespace("msigdbr", quietly = TRUE)) {
  install.packages("msigdbr")
}

library(msigdbr)
library(ggplot2)


# ------------------------------------------------------------
# 2. Input paths
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

metadata_file <-
  "05_RESULTS/Program_Scores_Sample_Level.csv"


stopifnot(file.exists(counts_file))
stopifnot(file.exists(dge_file))
stopifnot(file.exists(metadata_file))


# ------------------------------------------------------------
# 3. Load data
# ------------------------------------------------------------

counts <- read.csv(
  counts_file,
  row.names = 1,
  check.names = FALSE
)

dge <- read.csv(
  dge_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

metadata <- read.csv(
  metadata_file,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

gene_map <- unique(
  dge[, c("ENSEMBL", "SYMBOL")]
)

gene_map <- gene_map[
  !is.na(gene_map$SYMBOL) &
    gene_map$SYMBOL != "",
]


# ------------------------------------------------------------
# 4. Map Ensembl IDs to gene symbols
# ------------------------------------------------------------

expr_df <- data.frame(
  ENSEMBL = rownames(counts),
  counts,
  check.names = FALSE
)

expr_symbol <- merge(
  gene_map,
  expr_df,
  by = "ENSEMBL"
)

expr_symbol <- expr_symbol[
  ,
  c(
    "SYMBOL",
    colnames(counts)
  )
]


# Collapse duplicate symbols by mean expression
expr_symbol <- aggregate(
  . ~ SYMBOL,
  data = expr_symbol,
  FUN = mean
)

rownames(expr_symbol) <- expr_symbol$SYMBOL

expr_symbol$SYMBOL <- NULL

expr_symbol <- as.matrix(expr_symbol)


# ------------------------------------------------------------
# 5. Log2 transform
# ------------------------------------------------------------

expr_log2 <- log2(
  expr_symbol + 1
)


# ------------------------------------------------------------
# 6. Gene-wise z-score across samples
# ------------------------------------------------------------

expr_z <- t(
  apply(
    expr_log2,
    1,
    function(x) {
      
      if (
        is.na(sd(x, na.rm = TRUE)) ||
        sd(x, na.rm = TRUE) == 0
      ) {
        return(
          rep(0, length(x))
        )
      }
      
      as.numeric(
        scale(x)
      )
    }
  )
)

colnames(expr_z) <- colnames(expr_log2)
rownames(expr_z) <- rownames(expr_log2)


# ------------------------------------------------------------
# 7. Retrieve Human MSigDB Hallmark gene sets
# ------------------------------------------------------------

hallmark <- msigdbr(
  db_species = "HS",
  species = "Homo sapiens",
  collection = "H"
)

message(
  "MSigDB version: ",
  paste(
    unique(hallmark$db_version),
    collapse = ", "
  )
)


# ------------------------------------------------------------
# 8. Preselected exploratory pathways
# ------------------------------------------------------------

selected_pathways <- c(
  "HALLMARK_UNFOLDED_PROTEIN_RESPONSE",
  "HALLMARK_REACTIVE_OXYGEN_SPECIES_PATHWAY",
  "HALLMARK_INFLAMMATORY_RESPONSE",
  "HALLMARK_TNFA_SIGNALING_VIA_NFKB",
  "HALLMARK_OXIDATIVE_PHOSPHORYLATION",
  "HALLMARK_GLYCOLYSIS",
  "HALLMARK_E2F_TARGETS",
  "HALLMARK_G2M_CHECKPOINT"
)

hallmark_selected <- hallmark[
  hallmark$gs_name %in% selected_pathways,
  c(
    "gs_name",
    "gene_symbol"
  )
]


# ------------------------------------------------------------
# 9. Build pathway list
# ------------------------------------------------------------

pathway_list <- split(
  hallmark_selected$gene_symbol,
  hallmark_selected$gs_name
)

pathway_list <- lapply(
  pathway_list,
  unique
)


# ------------------------------------------------------------
# 10. Gene-overlap audit
# ------------------------------------------------------------

overlap_table <- do.call(
  rbind,
  lapply(
    names(pathway_list),
    function(pathway_name) {
      
      genes <- pathway_list[[pathway_name]]
      
      available <- intersect(
        genes,
        rownames(expr_z)
      )
      
      data.frame(
        Pathway = pathway_name,
        MSigDB_genes = length(genes),
        Available_genes = length(available),
        Fraction_available =
          length(available) / length(genes),
        stringsAsFactors = FALSE
      )
    }
  )
)

message(
  "\n=== PATHWAY GENE OVERLAP ==="
)

print(overlap_table)


# Require reasonable representation
stopifnot(
  all(
    overlap_table$Available_genes >= 10
  )
)


# ------------------------------------------------------------
# 11. Calculate sample-level pathway scores
# ------------------------------------------------------------

pathway_scores <- sapply(
  names(pathway_list),
  function(pathway_name) {
    
    available <- intersect(
      pathway_list[[pathway_name]],
      rownames(expr_z)
    )
    
    colMeans(
      expr_z[
        available,
        ,
        drop = FALSE
      ],
      na.rm = TRUE
    )
  }
)

pathway_scores <- as.data.frame(
  pathway_scores,
  check.names = FALSE
)

pathway_scores$sample_id <-
  rownames(pathway_scores)


# Put sample_id first
pathway_scores <- pathway_scores[
  ,
  c(
    "sample_id",
    setdiff(
      colnames(pathway_scores),
      "sample_id"
    )
  )
]


# ------------------------------------------------------------
# 12. Add sample metadata
# ------------------------------------------------------------

pathway_table <- merge(
  metadata[
    ,
    c(
      "sample_id",
      "gravity_plot",
      "disease_plot",
      "microglia_plot",
      "cell_line"
    )
  ],
  pathway_scores,
  by = "sample_id",
  all.x = TRUE,
  sort = FALSE
)

stopifnot(
  nrow(pathway_table) == 23
)


# ------------------------------------------------------------
# 13. Ground vs LEO means
# ------------------------------------------------------------

pathway_columns <- selected_pathways[
  selected_pathways %in%
    colnames(pathway_table)
]

gravity_means <- aggregate(
  pathway_table[
    ,
    pathway_columns,
    drop = FALSE
  ],
  by = list(
    gravity =
      pathway_table$gravity_plot
  ),
  FUN = mean,
  na.rm = TRUE
)


# ------------------------------------------------------------
# 14. Calculate overall LEO - Ground deltas
# ------------------------------------------------------------

overall_delta <- data.frame(
  Pathway = pathway_columns,
  Ground_mean = NA_real_,
  LEO_mean = NA_real_,
  Delta_LEO_minus_Ground = NA_real_,
  stringsAsFactors = FALSE
)

for (
  i in seq_along(pathway_columns)
) {
  
  pathway_name <-
    pathway_columns[i]
  
  ground_value <-
    gravity_means[
      gravity_means$gravity == "Ground",
      pathway_name
    ]
  
  leo_value <-
    gravity_means[
      gravity_means$gravity == "LEO",
      pathway_name
    ]
  
  overall_delta$Ground_mean[i] <-
    ground_value
  
  overall_delta$LEO_mean[i] <-
    leo_value
  
  overall_delta$Delta_LEO_minus_Ground[i] <-
    leo_value - ground_value
}


message(
  "\n=== OVERALL HALLMARK PATHWAY DELTAS ==="
)

print(overall_delta)


# ------------------------------------------------------------
# 15. Stratified subgroup means
# ------------------------------------------------------------

stratified_means <- aggregate(
  pathway_table[
    ,
    pathway_columns,
    drop = FALSE
  ],
  by = list(
    gravity =
      pathway_table$gravity_plot,
    
    disease =
      pathway_table$disease_plot,
    
    microglia =
      pathway_table$microglia_plot
  ),
  FUN = mean,
  na.rm = TRUE
)


# ------------------------------------------------------------
# 16. Matched subgroup deltas
# ------------------------------------------------------------

subgroup_delta <- data.frame()

groups <- unique(
  stratified_means[
    ,
    c(
      "disease",
      "microglia"
    )
  ]
)

for (
  g in seq_len(nrow(groups))
) {
  
  disease_name <-
    groups$disease[g]
  
  microglia_name <-
    groups$microglia[g]
  
  ground_row <- stratified_means[
    stratified_means$gravity == "Ground" &
      stratified_means$disease == disease_name &
      stratified_means$microglia == microglia_name,
  ]
  
  leo_row <- stratified_means[
    stratified_means$gravity == "LEO" &
      stratified_means$disease == disease_name &
      stratified_means$microglia == microglia_name,
  ]
  
  for (
    pathway_name in pathway_columns
  ) {
    
    delta <-
      leo_row[[pathway_name]] -
      ground_row[[pathway_name]]
    
    subgroup_delta <- rbind(
      subgroup_delta,
      data.frame(
        disease = disease_name,
        microglia = microglia_name,
        Pathway = pathway_name,
        Delta_LEO_minus_Ground =
          delta,
        stringsAsFactors = FALSE
      )
    )
  }
}


message(
  "\n=== SUBGROUP HALLMARK PATHWAY DELTAS ==="
)

print(subgroup_delta)


# ------------------------------------------------------------
# 17. Clean pathway names for figures
# ------------------------------------------------------------

clean_name <- function(x) {
  
  x <- gsub(
    "^HALLMARK_",
    "",
    x
  )
  
  x <- gsub(
    "_",
    " ",
    x
  )
  
  x
}


overall_delta$Pathway_clean <-
  clean_name(
    overall_delta$Pathway
  )

subgroup_delta$Pathway_clean <-
  clean_name(
    subgroup_delta$Pathway
  )

subgroup_delta$Group <-
  paste(
    subgroup_delta$disease,
    "|",
    subgroup_delta$microglia
  )


# ------------------------------------------------------------
# 18. Overall pathway figure
# ------------------------------------------------------------

p_overall <- ggplot(
  overall_delta,
  aes(
    x = Delta_LEO_minus_Ground,
    y = reorder(
      Pathway_clean,
      Delta_LEO_minus_Ground
    )
  )
) +
  
  geom_vline(
    xintercept = 0,
    linetype = "dashed"
  ) +
  
  geom_point(
    size = 4
  ) +
  
  labs(
    title =
      "Curated Hallmark Pathway Evidence",
    subtitle =
      "Overall LEO - Ground pathway-score differences",
    x =
      "LEO - Ground pathway score",
    y =
      NULL
  ) +
  
  theme_minimal(
    base_size = 13
  ) +
  
  theme(
    plot.title =
      element_text(
        face = "bold"
      ),
    
    panel.grid.minor =
      element_blank()
  )


# ------------------------------------------------------------
# 19. Subgroup pathway heatmap
# ------------------------------------------------------------

p_subgroup <- ggplot(
  subgroup_delta,
  aes(
    x = Group,
    y = Pathway_clean,
    fill = Delta_LEO_minus_Ground
  )
) +
  
  geom_tile() +
  
  geom_text(
    aes(
      label = sprintf(
        "%.2f",
        Delta_LEO_minus_Ground
      )
    ),
    size = 3
  ) +
  
  scale_fill_gradient2(
    midpoint = 0
  ) +
  
  labs(
    title =
      "Hallmark Pathway Heterogeneity",
    subtitle =
      "LEO - Ground pathway-score differences by matched subgroup",
    x =
      NULL,
    y =
      NULL,
    fill =
      "LEO - Ground"
  ) +
  
  theme_minimal(
    base_size = 12
  ) +
  
  theme(
    plot.title =
      element_text(
        face = "bold"
      ),
    
    axis.text.x =
      element_text(
        angle = 25,
        hjust = 1
      ),
    
    panel.grid =
      element_blank()
  )


print(p_overall)
print(p_subgroup)


# ------------------------------------------------------------
# 20. Save outputs
# ------------------------------------------------------------

write.csv(
  overlap_table,
  "05_RESULTS/Hallmark_Pathway_Gene_Overlap.csv",
  row.names = FALSE
)

write.csv(
  pathway_table,
  "05_RESULTS/Hallmark_Pathway_Scores_Sample_Level.csv",
  row.names = FALSE
)

write.csv(
  overall_delta,
  "05_RESULTS/Hallmark_Pathway_Overall_Deltas.csv",
  row.names = FALSE
)

write.csv(
  subgroup_delta,
  "05_RESULTS/Hallmark_Pathway_Subgroup_Deltas.csv",
  row.names = FALSE
)

ggsave(
  "06_FIGURES/Hallmark_Pathway_Overall_Deltas.png",
  p_overall,
  width = 9,
  height = 6,
  dpi = 300
)

ggsave(
  "06_FIGURES/Hallmark_Pathway_Subgroup_Deltas.png",
  p_subgroup,
  width = 10,
  height = 7,
  dpi = 300
)


# ------------------------------------------------------------
# 21. Final confirmation
# ------------------------------------------------------------

message(
  "\nPATHWAY EVIDENCE COMPLETED SUCCESSFULLY"
)