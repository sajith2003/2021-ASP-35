# ==========================================
# Project: Exploring Multidrug Resistance
# Organism: Escherichia coli
# Step 02: Data Cleaning and Preprocessing
# ==========================================

# Load required package
library(data.table)

# Check whether original dataset is loaded
if (!exists("amr_data")) {
  stop("Please run 01_data_import.R first!")
}

# Create a copy of original dataset
amr_clean <- copy(amr_data)

# Check original dimensions
dim(amr_clean)

# Check column names
colnames(amr_clean)

# Check data types
str(amr_clean)

# Check dataset dimensions
nrow(amr_clean)
ncol(amr_clean)

# Remove unnecessary spaces from character columns
character_columns <- names(amr_clean)[
  sapply(amr_clean, is.character)
]

for (col in character_columns) {
  set(
    amr_clean,
    j = col,
    value = trimws(amr_clean[[col]])
  )
}

# Convert empty strings into NA
for (col in character_columns) {
  set(
    amr_clean,
    i = which(amr_clean[[col]] == ""),
    j = col,
    value = NA_character_
  )
}

# Count missing values in each column
missing_values <- colSums(is.na(amr_clean))

print(missing_values)

# Count exact duplicate records before cleaning
duplicates_before <- sum(duplicated(amr_clean))

print(duplicates_before)

# Remove exact duplicate rows
amr_clean <- unique(amr_clean)

# Count rows after removing duplicates
duplicates_after <- sum(duplicated(amr_clean))

print(duplicates_after)

# Check updated dataset dimensions
dim(amr_clean)
# Check updated dataset dimensions
dim(amr_clean)

# Standardise antibiotic name formatting
amr_clean[, Antibiotic := tolower(trimws(Antibiotic))]

# Count different antibiotics
length(unique(amr_clean$Antibiotic))

# Display antibiotic names
sort(unique(amr_clean$Antibiotic))




# Filter Escherichia coli records
ecoli_data <- amr_clean[`Taxon ID` == 562]

# Check number of records
nrow(ecoli_data)

# Check unique Taxon IDs
unique(ecoli_data$`Taxon ID`)

# Check unique Genome IDs
length(unique(ecoli_data$`Genome ID`))



# Select laboratory-tested records
ecoli_lab <- ecoli_data[
  Evidence == "Laboratory Method"
]

# Select computationally predicted records
ecoli_computational <- ecoli_data[
  Evidence == "Computational Method"
]

# Check laboratory records
nrow(ecoli_lab)

# Check computational records
nrow(ecoli_computational)

# Remove records with missing resistance phenotype
ecoli_lab_clean <- ecoli_lab[
  !is.na(`Resistant Phenotype`)
]

# Check remaining records
nrow(ecoli_lab_clean)

# Count resistance categories
table(
  ecoli_lab_clean$`Resistant Phenotype`,
  useNA = "ifany"
)





# Final dataset dimensions
dim(ecoli_lab_clean)

# Check missing values
colSums(is.na(ecoli_lab_clean))

# Check duplicate rows
sum(duplicated(ecoli_lab_clean))

# Check evidence type
table(ecoli_lab_clean$Evidence)

# Check antibiotic count
length(unique(ecoli_lab_clean$Antibiotic))

# Check phenotype distribution
table(ecoli_lab_clean$`Resistant Phenotype`)






# Create output folders if they do not exist
dir.create("data/processed",
           recursive = TRUE,
           showWarnings = FALSE)

# Save cleaned datasets
saveRDS(
  amr_clean,
  "data/processed/amr_clean.rds"
)

saveRDS(
  ecoli_lab_clean,
  "data/processed/ecoli_lab_clean.rds"
)

saveRDS(
  ecoli_computational,
  "data/processed/ecoli_computational.rds"
)

# Confirm files were saved
file.exists("data/processed/amr_clean.rds")
file.exists("data/processed/ecoli_lab_clean.rds")
file.exists("data/processed/ecoli_computational.rds")