# ============================================================
# 05_visualization.R
# Project: Exploring Antibiotic Resistance Patterns in E. coli
# Purpose: Data Visualization
# ============================================================


# ------------------------------------------------------------
# PART 1: Load required packages
# ------------------------------------------------------------

library(data.table)
library(ggplot2)


# ------------------------------------------------------------
# PART 2: Load statistical results
# ------------------------------------------------------------

phenotype_counts <- fread(
  "results/statistical_phenotype_counts.csv"
)

antibiotic_stats <- fread(
  "results/antibiotic_statistical_summary.csv"
)

ci_results <- fread(
  "results/resistance_confidence_intervals.csv"
)

top_antibiotics <- fread(
  "results/top_antibiotics_statistical.csv"
)


# ------------------------------------------------------------
# PART 3: Visualisation 1
# Phenotype Distribution
# ------------------------------------------------------------

p1 <- ggplot(
  phenotype_counts,
  aes(
    x = `Resistant Phenotype`,
    y = Count
  )
) +
  
  geom_col() +
  
  labs(
    title = "Distribution of Antibiotic Resistance Phenotypes",
    subtitle = "Laboratory observations of E. coli",
    x = "Resistance Phenotype",
    y = "Number of Records"
  ) +
  
  theme_minimal() +
  
  theme(
    axis.text.x = element_text(
      angle = 30,
      hjust = 1
    )
  )


print(p1)

ggsave(
  "figures/01_phenotype_distribution.png",
  plot = p1,
  width = 9,
  height = 6,
  dpi = 300
)


# ------------------------------------------------------------
# PART 4: Visualisation 2
# Antibiotic Resistance Percentage
# ------------------------------------------------------------

# Select antibiotics with at least 30
# Resistant or Susceptible observations.

resistance_plot_data <- antibiotic_stats[
  RS_Total >= 30 &
    !is.na(Resistance_Percentage)
]

p2 <- ggplot(
  resistance_plot_data,
  aes(
    x = reorder(Antibiotic, Resistance_Percentage),
    y = Resistance_Percentage
  )
) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    title = "Antibiotic Resistance Percentage in E. coli",
    subtitle = "Based on Resistant and Susceptible observations",
    x = "Antibiotic",
    y = "Resistance Percentage (%)"
  ) +
  
  theme_minimal()


print(p2)

ggsave(
  "figures/02_resistance_percentage.png",
  plot = p2,
  width = 11,
  height = 8,
  dpi = 300
)


# ------------------------------------------------------------
# PART 5: Visualisation 3
# Top 15 Frequently Tested Antibiotics
# ------------------------------------------------------------

p3 <- ggplot(
  top_antibiotics,
  aes(
    x = reorder(Antibiotic, Total),
    y = Total
  )
) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    title = "Top 15 Frequently Tested Antibiotics",
    subtitle = "Laboratory records with known phenotypes",
    x = "Antibiotic",
    y = "Number of Records"
  ) +
  
  theme_minimal()


print(p3)

ggsave(
  "figures/03_top_antibiotics.png",
  plot = p3,
  width = 11,
  height = 8,
  dpi = 300
)


# ------------------------------------------------------------
# PART 6: Visualisation 4
# Confidence Intervals for Resistance Percentage
# ------------------------------------------------------------

# Select antibiotics with sufficient observations
# and valid confidence intervals.

ci_plot_data <- ci_results[
  Total_RS >= 30
]

# Order antibiotics by resistance percentage.

p4 <- ggplot(
  ci_plot_data,
  aes(
    x = reorder(Antibiotic, Resistance_Percentage),
    y = Resistance_Percentage
  )
) +
  
  geom_point(size = 2) +
  
  geom_errorbar(
    aes(
      ymin = Lower_95_CI,
      ymax = Upper_95_CI
    ),
    width = 0.2
  ) +
  
  coord_flip() +
  
  labs(
    title = "95% Confidence Intervals for Antibiotic Resistance",
    x = "Antibiotic",
    y = "Resistance Percentage (%)"
  ) +
  
  theme_minimal()


print(p4)

ggsave(
  "figures/04_resistance_confidence_intervals.png",
  plot = p4,
  width = 11,
  height = 8,
  dpi = 300
)


# ------------------------------------------------------------
# PART 7: Visualisation 5
# Resistant vs Susceptible Records
# ------------------------------------------------------------

# Convert data into long format.

phenotype_comparison <- melt(
  top_antibiotics[
    ,
    .(Antibiotic, Resistant, Susceptible)
  ],
  id.vars = "Antibiotic",
  variable.name = "Phenotype",
  value.name = "Records"
)


p5 <- ggplot(
  phenotype_comparison,
  aes(
    x = reorder(Antibiotic, Records),
    y = Records,
    fill = Phenotype
  )
) +
  
  geom_col(
    position = "dodge"
  ) +
  
  coord_flip() +
  
  labs(
    title = "Comparison of Resistant and Susceptible Records",
    x = "Antibiotic",
    y = "Number of Records",
    fill = "Phenotype"
  ) +
  
  theme_minimal()


print(p5)

ggsave(
  "figures/05_resistant_vs_susceptible.png",
  plot = p5,
  width = 11,
  height = 8,
  dpi = 300
)


# ------------------------------------------------------------
# PART 8: Completion message
# ------------------------------------------------------------

cat("\n========================================\n")
cat("VISUALIZATION COMPLETED SUCCESSFULLY!\n")
cat("========================================\n")

cat("Five figures saved in the figures/ folder.\n")