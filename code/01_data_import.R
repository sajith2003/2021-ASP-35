# ==========================================
# PROJECT: Exploring Multidrug Resistance
# Patterns in Escherichia coli
# ==========================================

# STEP 1: Install and load required packages

install.packages("readr")

library(readr)


# STEP 2: Define dataset location

file_path <- "data/raw/BVBRC_genome_amr.csv"


# STEP 3: Check whether the dataset exists

file.exists(file_path)


# STEP 4: Check dataset file size

file.info(file_path)$size / (1024^2)


# STEP 5: Read only first 10 records

amr_sample <- read_csv(
  file_path,
  n_max = 10,
  show_col_types = FALSE
)


# STEP 6: Display column names

colnames(amr_sample)


# STEP 7: Display first 10 records

print(amr_sample)


# STEP 8: Check data structure

str(amr_sample)

# ==========================================
# STEP 9: Inspect dataset quality
# ==========================================

# Load data.table package
install.packages("data.table")

library(data.table)

# Read the CSV in a memory-efficient way
amr_data <- fread(
  file_path,
  nThread = 2
)

# Total number of rows
nrow(amr_data)

# Total number of columns
ncol(amr_data)

# Dataset dimensions
dim(amr_data)

# First 6 records
head(amr_data)

# Check data types
str(amr_data)

# Step 12: Check resistance categories by evidence type

table(
  amr_data$Evidence,
  amr_data$`Resistant Phenotype`,
  useNA = "ifany"
)
#13 Check unique Taxon IDs
unique(amr_data$`Taxon ID`)

# Count unique Genome IDs
length(unique(amr_data$`Genome ID`))

# Count missing Genome IDs
sum(is.na(amr_data$`Genome ID`))

# Check missing evidence values
sum(is.na(amr_data$Evidence))

# Step 14: Check duplicate records

# Count duplicate rows
sum(duplicated(amr_data))

# Display the first 10 duplicate records
duplicates <- amr_data[duplicated(amr_data), ]

head(duplicates, 10)

# Step 15: Check repeated genome-antibiotic combinations

# Count records for each genome and antibiotic combination
pair_counts <- amr_data[
  ,
  .N,
  by = .(`Genome ID`, Antibiotic)
]

# Find combinations with more than one record
repeated_pairs <- pair_counts[N > 1]

# Count repeated combinations
nrow(repeated_pairs)

# Display the first 10 repeated combinations
head(repeated_pairs[order(-N)], 10)

# Step 16: Investigate repeated records

example_records <- amr_data[
  `Genome ID` == 562.1445 &
    Antibiotic == "ceftazidime"
]

# Display important columns
example_records[, .(
  `Genome ID`,
  Antibiotic,
  `Resistant Phenotype`,
  Measurement,
  `Laboratory Typing Method`,
  `Testing Standard`,
  `Testing Standard Year`,
  Evidence,
  PubMed
)]


# Step 17: Verify the repeated combination

# Check the number of records
nrow(example_records)

# Get the exact Genome ID from repeated_pairs
example_id <- repeated_pairs[
  Antibiotic == "ceftazidime"
][order(-N)][1, `Genome ID`]

# Display the selected ID
print(example_id)

# Count matching records using the selected ID
check_records <- amr_data[
  `Genome ID` == example_id &
    Antibiotic == "ceftazidime"
]

nrow(check_records)

# Check the evidence types
table(check_records$Evidence, useNA = "ifany")