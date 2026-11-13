# ============================================================
# 04_statistical_analysis.R
# Project: Exploring Antibiotic Resistance Patterns in E. coli
# Purpose: Statistical Analysis
# ============================================================


# ------------------------------------------------------------
# PART 1: Load required packages
# ------------------------------------------------------------

library(data.table)


# ------------------------------------------------------------
# PART 2: Load cleaned dataset
# ------------------------------------------------------------

amr_clean <- readRDS("data/processed/amr_clean.rds")

# Select Escherichia coli records

ecoli_data <- amr_clean[
  as.character(`Taxon ID`) == "562"
]

cat("Total E. coli records:", nrow(ecoli_data), "\n")


# ------------------------------------------------------------
# PART 3: Select laboratory-tested records
# ------------------------------------------------------------

# Use laboratory evidence only.
# Exclude records without a known phenotype.

lab_data <- ecoli_data[
  Evidence == "Laboratory Method" &
    !is.na(`Resistant Phenotype`) &
    !is.na(Antibiotic)
]

cat("Laboratory records:", nrow(lab_data), "\n")


# ------------------------------------------------------------
# PART 4: Calculate phenotype frequencies
# ------------------------------------------------------------

phenotype_counts <- lab_data[
  ,
  .N,
  by = `Resistant Phenotype`
]

setnames(
  phenotype_counts,
  "N",
  "Count"
)

# Calculate percentages

phenotype_counts[
  ,
  Percentage := round(
    Count / sum(Count) * 100,
    2
  )
]

print(phenotype_counts)

fwrite(
  phenotype_counts,
  "results/statistical_phenotype_counts.csv"
)


# ------------------------------------------------------------
# PART 5: Calculate antibiotic resistance percentages
# ------------------------------------------------------------

# Count each phenotype for each antibiotic

antibiotic_stats <- lab_data[
  ,
  .(
    Resistant = sum(`Resistant Phenotype` == "Resistant"),
    Susceptible = sum(`Resistant Phenotype` == "Susceptible"),
    Intermediate = sum(`Resistant Phenotype` == "Intermediate"),
    Nonsusceptible = sum(`Resistant Phenotype` == "Nonsusceptible")
  ),
  by = Antibiotic
]

# Total records with known phenotype

antibiotic_stats[
  ,
  Total := Resistant + Susceptible +
    Intermediate + Nonsusceptible
]

# Calculate resistance percentage among
# Resistant and Susceptible records only.

antibiotic_stats[
  ,
  RS_Total := Resistant + Susceptible
]

antibiotic_stats[
  ,
  Resistance_Percentage := fifelse(
    RS_Total > 0,
    round(Resistant / RS_Total * 100, 2),
    NA_real_
  )
]

# Sort by resistance percentage

setorder(
  antibiotic_stats,
  -Resistance_Percentage
)

print(antibiotic_stats)

fwrite(
  antibiotic_stats,
  "results/antibiotic_statistical_summary.csv"
)


# ------------------------------------------------------------
# PART 6: Calculate 95% confidence intervals
# ------------------------------------------------------------

# Use Resistant and Susceptible observations only.
# Intermediate and Nonsusceptible records are excluded.

ci_data <- antibiotic_stats[
  RS_Total > 0
]

# Calculate exact binomial confidence intervals

ci_results <- ci_data[
  ,
  {
    test_result <- binom.test(
      Resistant,
      RS_Total,
      conf.level = 0.95
    )
    
    .(
      Resistant = Resistant,
      Susceptible = Susceptible,
      Total_RS = RS_Total,
      Resistance_Percentage =
        round(100 * Resistant / RS_Total, 2),
      Lower_95_CI =
        round(100 * test_result$conf.int[1], 2),
      Upper_95_CI =
        round(100 * test_result$conf.int[2], 2)
    )
  },
  by = Antibiotic
]

setorder(
  ci_results,
  -Resistance_Percentage
)

print(ci_results)

fwrite(
  ci_results,
  "results/resistance_confidence_intervals.csv"
)


# ------------------------------------------------------------
# PART 7: Select commonly tested antibiotics
# ------------------------------------------------------------

# Select the 15 most frequently tested antibiotics
# using laboratory records with known phenotypes.

top_antibiotics <- antibiotic_stats[
  Total >= 30
][
  order(-Total)
][1:min(15, .N)]

print(top_antibiotics)

fwrite(
  top_antibiotics,
  "results/top_antibiotics_statistical.csv"
)


# ------------------------------------------------------------
# PART 8: Chi-square test
# ------------------------------------------------------------

# Investigate whether phenotype distribution
# differs across the selected antibiotics.

selected_antibiotics <- top_antibiotics$Antibiotic

chi_data <- lab_data[
  Antibiotic %in% selected_antibiotics
]

# Create contingency table

phenotype_table <- table(
  chi_data$Antibiotic,
  chi_data$`Resistant Phenotype`
)

print(phenotype_table)

# Perform Chi-square test using simulated p-value.
# Simulation is useful when expected cell counts are small.

if (
  nrow(phenotype_table) >= 2 &&
  ncol(phenotype_table) >= 2
) {
  
  chi_result <- chisq.test(
    phenotype_table,
    simulate.p.value = TRUE,
    B = 10000
  )
  
  print(chi_result)
  
  # Calculate Cramer's V
  
  chi_statistic <- as.numeric(chi_result$statistic)
  
  total_observations <- sum(phenotype_table)
  
  cramer_v <- sqrt(
    chi_statistic /
      (
        total_observations *
          min(
            nrow(phenotype_table) - 1,
            ncol(phenotype_table) - 1
          )
      )
  )
  
  cat("Chi-square statistic:", chi_statistic, "\n")
  
  cat("P-value:", chi_result$p.value, "\n")
  
  cat("Cramer's V:", cramer_v, "\n")
  
  # Save statistical test results
  
  chi_summary <- data.table(
    Test = "Chi-square test",
    Chi_square_statistic = chi_statistic,
    P_value = chi_result$p.value,
    Cramers_V = cramer_v,
    Simulations = 10000
  )
  
  fwrite(
    chi_summary,
    "results/chi_square_results.csv"
  )
  
} else {
  
  cat("Not enough categories for Chi-square test.\n")
  
}


# ------------------------------------------------------------
# PART 9: Final statistical summary
# ------------------------------------------------------------

cat("\n========================================\n")
cat("STATISTICAL ANALYSIS COMPLETED\n")
cat("========================================\n")

cat("Laboratory records analysed:", nrow(lab_data), "\n")

cat("Antibiotics analysed:", uniqueN(lab_data$Antibiotic), "\n")

cat("Statistical results saved in results/ folder.\n")