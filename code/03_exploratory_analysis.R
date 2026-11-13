# ============================================================
# 03_exploratory_analysis.R
# Project: Exploring Antibiotic Resistance Patterns in E. coli
# Purpose: Exploratory Data Analysis (EDA)
# ============================================================


# ------------------------------------------------------------
# PART 1: Load required packages
# ------------------------------------------------------------

library(data.table)
library(ggplot2)


# ------------------------------------------------------------
# PART 2: Load cleaned dataset
# ------------------------------------------------------------

# Read the cleaned dataset created in script 02

amr_clean <- readRDS("data/processed/amr_clean.rds")

# Display dataset dimensions

cat("Total records:", nrow(amr_clean), "\n")
cat("Total columns:", ncol(amr_clean), "\n")


# ------------------------------------------------------------
# PART 3: Select Escherichia coli records
# ------------------------------------------------------------

ecoli_data <- amr_clean[
  as.character(`Taxon ID`) == "562"
]

cat("E. coli records:", nrow(ecoli_data), "\n")


# ------------------------------------------------------------
# PART 4: Basic dataset summary
# ------------------------------------------------------------

# Calculate important dataset information

basic_summary <- data.table(
  Measurement = c(
    "Total records",
    "Number of columns",
    "Unique genome IDs",
    "Unique antibiotics",
    "Laboratory records",
    "Computational records"
  ),
  
  Value = c(
    nrow(ecoli_data),
    ncol(ecoli_data),
    uniqueN(ecoli_data$`Genome ID`),
    uniqueN(ecoli_data$Antibiotic),
    sum(ecoli_data$Evidence == "Laboratory Method", na.rm = TRUE),
    sum(ecoli_data$Evidence == "Computational Method", na.rm = TRUE)
  )
)

print(basic_summary)

fwrite(
  basic_summary,
  "results/basic_summary.csv"
)


# ------------------------------------------------------------
# PART 5: Analyse evidence types
# ------------------------------------------------------------

# Count laboratory and computational records

evidence_summary <- ecoli_data[
  ,
  .N,
  by = Evidence
]

setnames(
  evidence_summary,
  "N",
  "Records"
)

print(evidence_summary)

fwrite(
  evidence_summary,
  "results/evidence_summary.csv"
)


# ------------------------------------------------------------
# PART 6: Analyse resistance phenotype distribution
# ------------------------------------------------------------

# Count Resistant, Susceptible, Intermediate, etc.
# Missing values are kept as a separate category.

phenotype_summary <- ecoli_data[
  ,
  .N,
  by = .(
    Phenotype = fifelse(
      is.na(`Resistant Phenotype`),
      "Missing",
      as.character(`Resistant Phenotype`)
    )
  )
]

setnames(
  phenotype_summary,
  "N",
  "Records"
)

print(phenotype_summary)

fwrite(
  phenotype_summary,
  "results/phenotype_summary.csv"
)


# ------------------------------------------------------------
# PART 7: Laboratory phenotype analysis
# ------------------------------------------------------------

# Select laboratory-tested records with known phenotypes

lab_data <- ecoli_data[
  Evidence == "Laboratory Method" &
    !is.na(`Resistant Phenotype`)
]

cat(
  "Laboratory records with known phenotypes:",
  nrow(lab_data),
  "\n"
)

# Count each laboratory phenotype

lab_phenotype_summary <- lab_data[
  ,
  .N,
  by = `Resistant Phenotype`
]

setnames(
  lab_phenotype_summary,
  "N",
  "Records"
)

print(lab_phenotype_summary)

fwrite(
  lab_phenotype_summary,
  "results/lab_phenotype_summary.csv"
)


# ------------------------------------------------------------
# PART 8: Identify frequently tested antibiotics
# ------------------------------------------------------------

# Count laboratory records for each antibiotic

antibiotic_summary <- lab_data[
  ,
  .N,
  by = Antibiotic
]

setnames(
  antibiotic_summary,
  "N",
  "Records"
)

# Sort antibiotics from highest to lowest record count

setorder(
  antibiotic_summary,
  -Records
)

print(head(antibiotic_summary, 15))

fwrite(
  antibiotic_summary,
  "results/antibiotic_summary.csv"
)


# ------------------------------------------------------------
# PART 9: Missing value analysis
# ------------------------------------------------------------

# Count missing values in each column

missing_summary <- data.table(
  Column = names(ecoli_data),
  
  Missing_Values = sapply(
    ecoli_data,
    function(x) sum(is.na(x))
  )
)

missing_summary[
  ,
  Missing_Percentage :=
    round(
      (Missing_Values / nrow(ecoli_data)) * 100,
      2
    )
]

print(missing_summary)

fwrite(
  missing_summary,
  "results/missing_summary.csv"
)


# ------------------------------------------------------------
# PART 10: Visualisation 1 - Phenotype distribution
# ------------------------------------------------------------

p1 <- ggplot(
  lab_phenotype_summary,
  aes(
    x = `Resistant Phenotype`,
    y = Records
  )
) +
  
  geom_col() +
  
  labs(
    title = "Distribution of Antibiotic Resistance Phenotypes",
    x = "Resistance Phenotype",
    y = "Number of Records"
  ) +
  
  theme_minimal()


print(p1)

ggsave(
  "figures/phenotype_distribution.png",
  plot = p1,
  width = 8,
  height = 6,
  dpi = 300
)


# ------------------------------------------------------------
# PART 11: Visualisation 2 - Top 15 antibiotics
# ------------------------------------------------------------

top_antibiotics <- head(
  antibiotic_summary,
  15
)

p2 <- ggplot(
  top_antibiotics,
  aes(
    x = reorder(Antibiotic, Records),
    y = Records
  )
) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    title = "Top 15 Frequently Tested Antibiotics",
    x = "Antibiotic",
    y = "Number of Laboratory Records"
  ) +
  
  theme_minimal()


print(p2)

ggsave(
  "figures/top_15_antibiotics.png",
  plot = p2,
  width = 10,
  height = 7,
  dpi = 300
)


# ------------------------------------------------------------
# PART 12: Visualisation 3 - Evidence distribution
# ------------------------------------------------------------

p3 <- ggplot(
  evidence_summary,
  aes(
    x = Evidence,
    y = Records
  )
) +
  
  geom_col() +
  
  labs(
    title = "Distribution of Evidence Types",
    x = "Evidence Type",
    y = "Number of Records"
  ) +
  
  theme_minimal()


print(p3)

ggsave(
  "figures/evidence_distribution.png",
  plot = p3,
  width = 8,
  height = 6,
  dpi = 300
)


# ------------------------------------------------------------
# PART 13: Display completion message
# ------------------------------------------------------------

cat("\n====================================\n")
cat("Exploratory Data Analysis completed!\n")
cat("====================================\n")

cat("Summary tables saved in results/ folder.\n")
cat("Figures saved in figures/ folder.\n")