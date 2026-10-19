# ============================================================
# 05_leave_one_gene_out_sensitivity.R
#
# Purpose:
# Test whether the preregistered program-score directions
# depend strongly on any single gene.
#
# Sensitivity rule:
# remove one gene at a time -> recalculate program score
# -> compare Ground vs LEO
# ============================================================

library(ggplot2)


# ------------------------------------------------------------
# 1. Load preregistered gene-level z-scores
# ------------------------------------------------------------

expr_z <- read.csv(
  "05_RESULTS/Program_Gene_Zscores.csv",
  row.names = 1,
  check.names = FALSE
)

metadata <- read.csv(
  "05_RESULTS/Program_Scores_Sample_Level.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

stopifnot(
  all(metadata$sample_id %in% colnames(expr_z))
)


# ------------------------------------------------------------
# 2. Frozen primary gene sets
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
  )
)


# ------------------------------------------------------------
# 3. Expected direction from preregistration
# ------------------------------------------------------------

expected_sign <- c(
  Maturation = 1,
  Dopaminergic_identity = 1,
  Progenitor_cellcycle = -1,
  Stress = -1
)


# ------------------------------------------------------------
# 4. Helper function
# ------------------------------------------------------------

calculate_score <- function(genes) {
  
  colMeans(
    expr_z[genes, , drop = FALSE],
    na.rm = TRUE
  )
}


# ------------------------------------------------------------
# 5. Overall leave-one-gene-out analysis
# ------------------------------------------------------------

overall_results <- data.frame()

subgroup_results <- data.frame()


for (program_name in names(gene_sets)) {
  
  genes <- gene_sets[[program_name]]
  
  # include the full preregistered set as baseline
  omission_list <- c("NONE", genes)
  
  for (omitted_gene in omission_list) {
    
    if (omitted_gene == "NONE") {
      
      genes_used <- genes
      
    } else {
      
      genes_used <- setdiff(
        genes,
        omitted_gene
      )
    }
    
    scores <- calculate_score(
      genes_used
    )
    
    sensitivity_table <- data.frame(
      sample_id = names(scores),
      sensitivity_score = as.numeric(scores),
      stringsAsFactors = FALSE
    )
    
    sensitivity_table <- merge(
      metadata[
        ,
        c(
          "sample_id",
          "gravity_plot",
          "disease_plot",
          "microglia_plot"
        )
      ],
      sensitivity_table,
      by = "sample_id",
      all.x = TRUE,
      sort = FALSE
    )
    
    # --------------------------------------------------------
    # Overall Ground vs LEO
    # --------------------------------------------------------
    
    overall_means <- aggregate(
      sensitivity_score ~ gravity_plot,
      data = sensitivity_table,
      FUN = mean
    )
    
    ground_mean <- overall_means$sensitivity_score[
      overall_means$gravity_plot == "Ground"
    ]
    
    leo_mean <- overall_means$sensitivity_score[
      overall_means$gravity_plot == "LEO"
    ]
    
    delta <- leo_mean - ground_mean
    
    direction_preserved <-
      sign(delta) == expected_sign[program_name]
    
    overall_results <- rbind(
      overall_results,
      data.frame(
        Program = program_name,
        Omitted_gene = omitted_gene,
        Genes_used = length(genes_used),
        Ground_mean = ground_mean,
        LEO_mean = leo_mean,
        Delta_LEO_minus_Ground = delta,
        Expected_sign = expected_sign[program_name],
        Direction_preserved = direction_preserved,
        stringsAsFactors = FALSE
      )
    )
    
    
    # --------------------------------------------------------
    # Matched subgroup Ground vs LEO
    # --------------------------------------------------------
    
    subgroup_means <- aggregate(
      sensitivity_score ~
        gravity_plot +
        disease_plot +
        microglia_plot,
      data = sensitivity_table,
      FUN = mean
    )
    
    ground_sub <- subset(
      subgroup_means,
      gravity_plot == "Ground"
    )
    
    leo_sub <- subset(
      subgroup_means,
      gravity_plot == "LEO"
    )
    
    names(ground_sub)[
      names(ground_sub) == "sensitivity_score"
    ] <- "Ground_mean"
    
    names(leo_sub)[
      names(leo_sub) == "sensitivity_score"
    ] <- "LEO_mean"
    
    matched <- merge(
      ground_sub[
        ,
        c(
          "disease_plot",
          "microglia_plot",
          "Ground_mean"
        )
      ],
      leo_sub[
        ,
        c(
          "disease_plot",
          "microglia_plot",
          "LEO_mean"
        )
      ],
      by = c(
        "disease_plot",
        "microglia_plot"
      )
    )
    
    matched$Delta_LEO_minus_Ground <-
      matched$LEO_mean -
      matched$Ground_mean
    
    matched$Direction_preserved <-
      sign(
        matched$Delta_LEO_minus_Ground
      ) ==
      expected_sign[program_name]
    
    matched$Program <- program_name
    matched$Omitted_gene <- omitted_gene
    
    subgroup_results <- rbind(
      subgroup_results,
      matched
    )
  }
}


# ------------------------------------------------------------
# 6. Sensitivity summary
# ------------------------------------------------------------

loo_only <- subset(
  overall_results,
  Omitted_gene != "NONE"
)

summary_table <- do.call(
  rbind,
  lapply(
    names(gene_sets),
    function(program_name) {
      
      x <- subset(
        loo_only,
        Program == program_name
      )
      
      data.frame(
        Program = program_name,
        
        N_leave_one_out_tests =
          nrow(x),
        
        N_overall_direction_preserved =
          sum(x$Direction_preserved),
        
        Fraction_overall_direction_preserved =
          mean(x$Direction_preserved),
        
        Minimum_delta =
          min(x$Delta_LEO_minus_Ground),
        
        Maximum_delta =
          max(x$Delta_LEO_minus_Ground),
        
        stringsAsFactors = FALSE
      )
    }
  )
)


# ------------------------------------------------------------
# 7. Subgroup robustness summary
# ------------------------------------------------------------

subgroup_loo <- subset(
  subgroup_results,
  Omitted_gene != "NONE"
)

subgroup_summary <- aggregate(
  Direction_preserved ~
    Program +
    disease_plot +
    microglia_plot,
  data = subgroup_loo,
  FUN = mean
)

names(subgroup_summary)[
  names(subgroup_summary) ==
    "Direction_preserved"
] <- "Fraction_direction_preserved"


# ------------------------------------------------------------
# 8. Print important results
# ------------------------------------------------------------

message(
  "\n=== OVERALL LEAVE-ONE-GENE-OUT SUMMARY ==="
)

print(summary_table)


message(
  "\n=== SUBGROUP ROBUSTNESS SUMMARY ==="
)

print(subgroup_summary)


message(
  "\n=== ANY OVERALL DIRECTION FAILURES? ==="
)

print(
  subset(
    loo_only,
    Direction_preserved == FALSE
  )
)


# ------------------------------------------------------------
# 9. Save result tables
# ------------------------------------------------------------

write.csv(
  overall_results,
  "05_RESULTS/LOO_Overall_Sensitivity.csv",
  row.names = FALSE
)

write.csv(
  subgroup_results,
  "05_RESULTS/LOO_Subgroup_Sensitivity.csv",
  row.names = FALSE
)

write.csv(
  summary_table,
  "05_RESULTS/LOO_Sensitivity_Summary.csv",
  row.names = FALSE
)

write.csv(
  subgroup_summary,
  "05_RESULTS/LOO_Subgroup_Robustness_Summary.csv",
  row.names = FALSE
)


# ------------------------------------------------------------
# 10. Create sensitivity figure
# ------------------------------------------------------------

plot_data <- subset(
  overall_results,
  Omitted_gene != "NONE"
)

p_sensitivity <- ggplot(
  plot_data,
  aes(
    x = Delta_LEO_minus_Ground,
    y = reorder(
      Omitted_gene,
      Delta_LEO_minus_Ground
    )
  )
) +
  
  geom_vline(
    xintercept = 0,
    linetype = "dashed"
  ) +
  
  geom_point(
    size = 3
  ) +
  
  facet_wrap(
    ~ Program,
    scales = "free_y",
    ncol = 2
  ) +
  
  labs(
    title =
      "Leave-One-Gene-Out Sensitivity Analysis",
    subtitle =
      "Each point shows the LEO - Ground program-score shift after removing one gene",
    x =
      "LEO - Ground score difference",
    y =
      "Gene removed"
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


print(
  p_sensitivity
)


ggsave(
  "06_FIGURES/LOO_Sensitivity_Analysis.png",
  p_sensitivity,
  width = 11,
  height = 8,
  dpi = 300
)

ggsave(
  "06_FIGURES/LOO_Sensitivity_Analysis.pdf",
  p_sensitivity,
  width = 11,
  height = 8
)


# ------------------------------------------------------------
# 11. Final confirmation
# ------------------------------------------------------------

message(
  "\nLEAVE-ONE-GENE-OUT SENSITIVITY COMPLETED SUCCESSFULLY"
)