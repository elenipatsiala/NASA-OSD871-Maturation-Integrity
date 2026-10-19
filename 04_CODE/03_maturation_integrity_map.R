# ============================================================
# 03_maturation_integrity_map.R
# Purpose:
# Create the µG-NeuroTune maturation vs dopaminergic identity map
# ============================================================

library(ggplot2)

# ----------------------------
# 1. Load sample-level scores
# ----------------------------
scores <- read.csv(
  "05_RESULTS/Program_Scores_Sample_Level.csv",
  stringsAsFactors = FALSE
)

print("=== SAMPLE SCORES LOADED ===")
print(dim(scores))
print(head(scores))

# ----------------------------
# 2. Create output folder if needed
# ----------------------------
if (!dir.exists("06_FIGURES")) {
  dir.create("06_FIGURES")
}

# ----------------------------
# 3. Main maturation-integrity map
# ----------------------------
p_map <- ggplot(
  scores,
  aes(
    x = Maturation,
    y = Dopaminergic_identity,
    color = gravity_plot,
    shape = microglia_plot
  )
) +
  geom_point(size = 4, alpha = 0.9) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(
    title = expression(mu*"G-NeuroTune Map v0"),
    subtitle = "Maturation vs Dopaminergic Identity",
    x = "Maturation score",
    y = "Dopaminergic identity score",
    color = "Gravity",
    shape = "Microglia"
  ) +
  theme_minimal(base_size = 13)

print(p_map)

# ----------------------------
# 4. Save main figure
# ----------------------------
ggsave(
  filename = "06_FIGURES/muG_NeuroTune_Map_v0.png",
  plot = p_map,
  width = 8,
  height = 6,
  dpi = 300
)

# ----------------------------
# 5. Group mean map
# ----------------------------
group_means <- aggregate(
  cbind(Maturation, Dopaminergic_identity, Stress) ~ gravity_plot + disease_plot + microglia_plot,
  data = scores,
  FUN = mean
)

print("=== GROUP MEANS ===")
print(group_means)

p_group <- ggplot(
  group_means,
  aes(
    x = Maturation,
    y = Dopaminergic_identity,
    color = gravity_plot,
    shape = microglia_plot,
    size = Stress
  )
) +
  geom_point(alpha = 0.95) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(
    title = expression(mu*"G-NeuroTune Map v0 (Group Means)"),
    subtitle = "Point size reflects Stress score",
    x = "Mean Maturation score",
    y = "Mean Dopaminergic identity score",
    color = "Gravity",
    shape = "Microglia",
    size = "Stress"
  ) +
  theme_minimal(base_size = 13)

print(p_group)

ggsave(
  filename = "06_FIGURES/muG_NeuroTune_Map_v0_group_means.png",
  plot = p_group,
  width = 8,
  height = 6,
  dpi = 300
)

# ----------------------------
# 6. Save group mean table
# ----------------------------
write.csv(
  group_means,
  "05_RESULTS/Maturation_Integrity_Group_Means.csv",
  row.names = FALSE
)

message("MATURATION-INTEGRITY MAP COMPLETED SUCCESSFULLY")
