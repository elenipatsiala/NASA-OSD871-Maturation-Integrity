# ============================================================
# 04_maturation_integrity_map_v1.R
# Purpose:
# Create a polished maturation-integrity map with
# Ground -> LEO arrows for each matched subgroup.
# ============================================================

library(ggplot2)
library(grid)

# ------------------------------------------------------------
# 1. Load sample-level scores
# ------------------------------------------------------------

scores <- read.csv(
  "05_RESULTS/Program_Scores_Sample_Level.csv",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

message("=== SAMPLE SCORES LOADED ===")
print(dim(scores))
print(head(scores))


# ------------------------------------------------------------
# 2. Create output folders if needed
# ------------------------------------------------------------

if (!dir.exists("06_FIGURES")) {
  dir.create(
    "06_FIGURES",
    recursive = TRUE
  )
}

if (!dir.exists("05_RESULTS")) {
  dir.create(
    "05_RESULTS",
    recursive = TRUE
  )
}


# ------------------------------------------------------------
# 3. Compute subgroup means
# ------------------------------------------------------------

group_means <- aggregate(
  cbind(
    Maturation,
    Dopaminergic_identity,
    Stress
  ) ~
    gravity_plot +
    disease_plot +
    microglia_plot,
  data = scores,
  FUN = mean
)

message("=== GROUP MEANS ===")
print(group_means)


# ------------------------------------------------------------
# 4. Separate Ground and LEO means
# ------------------------------------------------------------

ground_means <- subset(
  group_means,
  gravity_plot == "Ground"
)

leo_means <- subset(
  group_means,
  gravity_plot == "LEO"
)

ground_means <- ground_means[
  ,
  c(
    "disease_plot",
    "microglia_plot",
    "Maturation",
    "Dopaminergic_identity",
    "Stress"
  )
]

leo_means <- leo_means[
  ,
  c(
    "disease_plot",
    "microglia_plot",
    "Maturation",
    "Dopaminergic_identity",
    "Stress"
  )
]


# ------------------------------------------------------------
# 5. Rename Ground / LEO columns
# ------------------------------------------------------------

names(ground_means) <- c(
  "disease_plot",
  "microglia_plot",
  "Maturation_ground",
  "Identity_ground",
  "Stress_ground"
)

names(leo_means) <- c(
  "disease_plot",
  "microglia_plot",
  "Maturation_LEO",
  "Identity_LEO",
  "Stress_LEO"
)


# ------------------------------------------------------------
# 6. Join matched subgroup means
# ------------------------------------------------------------

arrow_df <- merge(
  ground_means,
  leo_means,
  by = c(
    "disease_plot",
    "microglia_plot"
  )
)


# ------------------------------------------------------------
# 7. Create subgroup labels
# ------------------------------------------------------------

arrow_df$group_label <- paste(
  arrow_df$disease_plot,
  "|",
  arrow_df$microglia_plot
)


# ------------------------------------------------------------
# 8. Calculate Ground -> LEO shifts
# ------------------------------------------------------------

arrow_df$Maturation_shift <-
  arrow_df$Maturation_LEO -
  arrow_df$Maturation_ground

arrow_df$Identity_shift <-
  arrow_df$Identity_LEO -
  arrow_df$Identity_ground

arrow_df$Stress_shift <-
  arrow_df$Stress_LEO -
  arrow_df$Stress_ground


# ------------------------------------------------------------
# 9. Create simple direction classification
# ------------------------------------------------------------

arrow_df$direction_pattern <- ifelse(
  arrow_df$Maturation_shift > 0 &
    arrow_df$Identity_shift > 0,
  
  "Maturation up / Identity up",
  
  ifelse(
    arrow_df$Maturation_shift > 0 &
      arrow_df$Identity_shift < 0,
    
    "Maturation up / Identity down",
    
    "Other"
  )
)

message("=== ARROW TABLE ===")
print(arrow_df)


# ------------------------------------------------------------
# 10. Create long-format point table
# ------------------------------------------------------------

ground_points <- data.frame(
  gravity_plot = "Ground",
  disease_plot = arrow_df$disease_plot,
  microglia_plot = arrow_df$microglia_plot,
  Maturation = arrow_df$Maturation_ground,
  Dopaminergic_identity =
    arrow_df$Identity_ground,
  group_label = arrow_df$group_label,
  stringsAsFactors = FALSE
)

leo_points <- data.frame(
  gravity_plot = "LEO",
  disease_plot = arrow_df$disease_plot,
  microglia_plot = arrow_df$microglia_plot,
  Maturation = arrow_df$Maturation_LEO,
  Dopaminergic_identity =
    arrow_df$Identity_LEO,
  group_label = arrow_df$group_label,
  stringsAsFactors = FALSE
)

plot_points <- rbind(
  ground_points,
  leo_points
)


# ------------------------------------------------------------
# 11. Create polished LEO NeuroTune Map v1
# ------------------------------------------------------------

p_map_v1 <- ggplot() +
  
  # zero-reference lines
  geom_vline(
    xintercept = 0,
    linetype = "dashed",
    color = "gray45"
  ) +
  
  geom_hline(
    yintercept = 0,
    linetype = "dashed",
    color = "gray45"
  ) +
  
  # Ground -> LEO arrows
  geom_segment(
    data = arrow_df,
    aes(
      x = Maturation_ground,
      y = Identity_ground,
      xend = Maturation_LEO,
      yend = Identity_LEO
    ),
    arrow = arrow(
      length = unit(0.18, "cm")
    ),
    linewidth = 0.9,
    color = "gray35",
    alpha = 0.9
  ) +
  
  # Ground / LEO points
  geom_point(
    data = plot_points,
    aes(
      x = Maturation,
      y = Dopaminergic_identity,
      color = gravity_plot,
      shape = microglia_plot
    ),
    size = 4.2,
    alpha = 0.95
  ) +
  
  # labels shown next to LEO endpoint
  geom_text(
    data = leo_points,
    aes(
      x = Maturation,
      y = Dopaminergic_identity,
      label = group_label
    ),
    nudge_x = 0.05,
    nudge_y = 0.02,
    size = 3.7,
    hjust = 0,
    check_overlap = FALSE
  ) +
  
  # manual display colors
  scale_color_manual(
    values = c(
      "Ground" = "#F8766D",
      "LEO" = "#00BFC4"
    )
  ) +
  
  # give extra room on the right so labels are not cut
  scale_x_continuous(
    expand = expansion(
      mult = c(0.08, 0.35)
    )
  ) +
  
  scale_y_continuous(
    expand = expansion(
      mult = c(0.08, 0.12)
    )
  ) +
  
  labs(
    title = "LEO NeuroTune Map v1",
    subtitle =
      "Arrows show Ground -> LEO shifts across matched subgroups",
    x = "Mean Maturation score",
    y = "Mean Dopaminergic identity score",
    color = "Gravity",
    shape = "Microglia"
  ) +
  
  coord_cartesian(
    clip = "off"
  ) +
  
  theme_minimal(
    base_size = 14
  ) +
  
  theme(
    plot.title = element_text(
      face = "bold",
      size = 20
    ),
    plot.subtitle = element_text(
      size = 13
    ),
    axis.title = element_text(
      face = "bold"
    ),
    legend.position = "right",
    panel.grid.minor = element_blank(),
    plot.margin = margin(
      t = 15,
      r = 80,
      b = 15,
      l = 15
    )
  )


# ------------------------------------------------------------
# 12. Display figure
# ------------------------------------------------------------

print(p_map_v1)


# ------------------------------------------------------------
# 13. Save final figure
# ------------------------------------------------------------

ggsave(
  filename =
    "06_FIGURES/LEO_NeuroTune_Map_v1.png",
  plot = p_map_v1,
  width = 10,
  height = 7,
  dpi = 300
)

ggsave(
  filename =
    "06_FIGURES/LEO_NeuroTune_Map_v1.pdf",
  plot = p_map_v1,
  width = 10,
  height = 7
)


# ------------------------------------------------------------
# 14. Save Ground -> LEO shift table
# ------------------------------------------------------------

write.csv(
  arrow_df,
  "05_RESULTS/Maturation_Integrity_Shifts_v1.csv",
  row.names = FALSE
)


# ------------------------------------------------------------
# 15. Final confirmation
# ------------------------------------------------------------

message(
  "LEO NEUROTUNE MAP V1 COMPLETED SUCCESSFULLY"
)