# Statistical Analysis of Multidrug Resistance Patterns in Escherichia coli

**Registration Number:** 2021/ASP/35  
**Programming Language:** R  
**Development Environment:** RStudio  
**Dataset:** BVBRC E. coli Dataset  
**Dataset Source:** Kaggle

## 1. Project Abstract

Antimicrobial Resistance (AMR) is a major global health problem because bacteria can develop resistance to antibiotics, making infections more difficult to treat.

This project focuses on the statistical analysis of antibiotic resistance patterns in *Escherichia coli* (E. coli) using R programming.

The dataset contains bacterial genome information, antibiotic names, and resistance phenotypes. Data preprocessing was performed to identify missing values, examine duplicate records, and select relevant E. coli observations.

The project investigates the distribution of antibiotic resistance phenotypes and resistance patterns across antibiotics. Statistical summaries and visualizations are used to support the interpretation of the dataset.

The analysis helps improve understanding of antibiotic resistance patterns and demonstrates how statistical programming can be applied in bioinformatics research.

## 2. Project Objectives

The main objectives are:

1. To import and preprocess a real bacterial antibiotic resistance dataset.
2. To identify and analyze E. coli records.
3. To examine susceptible, resistant, and intermediate phenotypes.
4. To investigate antibiotic resistance patterns.
5. To summarize the data using statistical methods.
6. To visualize resistance patterns using graphs.
7. To interpret the results in a bioinformatics context.

## 3. Dataset Description

The dataset contains bacterial records and antibiotic susceptibility information.

**Initial data audit:**

| Description | Value |
|---|---:|
| Original dataset records | 195,795 |
| Number of columns | 21 |
| E. coli records selected | 194,927 |
| Records with known resistance phenotype | 94,998 |

Important dataset variables include:

- **Genome ID:** Identifier of a bacterial genome.
- **Taxon ID:** Identifier used to classify the organism.
- **Antibiotic:** Name of the antibiotic tested.
- **Resistant Phenotype:** Recorded susceptibility or resistance category.

## 4. Tools and Technologies

- **R:** Statistical programming and analysis.
- **RStudio:** Code development and execution.
- **CSV:** Storage of dataset and analysis results.
- **GitHub:** Project version control and documentation.

## 5. Methodology

### Step 1: Data Collection

The BVBRC E. coli dataset was selected for antibiotic resistance analysis.

### Step 2: Data Import

The CSV dataset was imported into RStudio using R programming.

### Step 3: Data Preprocessing

Data quality checks included:

- Checking missing values.
- Checking variable data types.
- Identifying duplicate records.
- Filtering relevant bacterial records.

### Step 4: Data Filtering

Records belonging to E. coli were selected using Taxon ID 562.

Records with available resistance phenotype information were selected for phenotype analysis.

### Step 5: Statistical Analysis

The project includes output files for:

- Antibiotic statistical summaries.
- Resistance phenotype counts.
- Chi-square test results.
- Resistance confidence intervals.

### Step 6: Data Visualization

Graphs were prepared to represent resistance phenotype distributions and antibiotic patterns.

## 6. Results and Findings

### Resistance Phenotype Distribution

The initial phenotype analysis produced the following results:

| Phenotype | Count | Approximate Percentage |
|---|---:|---:|
| Susceptible | 71,128 | 74.87% |
| Resistant | 21,803 | 22.95% |
| Intermediate | 2,057 | 2.17% |
| Nonsusceptible | 6 | 0.01% |
| Susceptible-dose dependent | 4 | Less than 0.01% |

### Key Findings

- Susceptible records represented the largest group.
- Resistant records accounted for approximately 23% of the analysis records.
- Intermediate records represented approximately 2%.
- Resistance patterns can be compared across different antibiotics.

These findings describe the analyzed records and should not be interpreted as population-wide prevalence estimates.

## 7. Statistical Analysis

The project contains statistical output files for further interpretation.

**Chi-square analysis:** Used to investigate associations between categorical variables.

**Confidence intervals:** Used to describe uncertainty around estimated resistance proportions.

**Descriptive statistics:** Used to summarize the frequency and distribution of resistance phenotypes.

The numerical statistical results should be interpreted using the corresponding output CSV files.

## 8. Project Outputs

The repository contains generated analysis files, including:

- `antibiotic_statistical_summary.csv`
- `antibiotic_summary.csv`
- `basic_summary.csv`
- `chi_square_results.csv`
- `evidence_summary.csv`
- `lab_phenotype_summary.csv`
- `missing_summary.csv`
- `phenotype_summary.csv`
- `resistance_confidence_intervals.csv`
- `statistical_phenotype_counts.csv`
- `top_antibiotics_statistical.csv`

Visualization outputs include:

- `phenotype_distribution.png`
- `top_15_antibiotics.png`

## 9. Limitations

- Missing data can reduce the number of records available for analysis.
- Duplicate records require careful investigation.
- Different antibiotics may have different numbers of observations.
- The dataset may not represent all E. coli populations.
- Observational statistical associations do not establish causation.

## 10. Conclusion

This project demonstrates the use of R programming for analyzing antibiotic resistance patterns in E. coli.

Data preprocessing, statistical analysis, and visualization were used to investigate resistance phenotypes.

The analysis found that most records were susceptible, while a substantial proportion were resistant.

The project demonstrates the importance of statistical methods in understanding antimicrobial resistance and their application in bioinformatics research.

## 11. Future Improvements

- Extend the analysis to additional bacterial species.
- Investigate antibiotic resistance using genomic features.
- Compare resistance patterns across different datasets.
- Develop and evaluate predictive models.
- Validate results using independent datasets.
