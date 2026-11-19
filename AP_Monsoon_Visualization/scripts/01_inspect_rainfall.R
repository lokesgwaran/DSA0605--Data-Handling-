
# ==========================================
# AP NORTHEAST MONSOON PROJECT
# STEP 1: INSPECT RAINFALL DATA
# ==========================================

# Install packages if required
packages <- c("tidyverse", "lubridate", "janitor")

new_packages <- packages[
  !packages %in% installed.packages()[, "Package"]
]

if (length(new_packages) > 0) {
  install.packages(new_packages)
}

# Load libraries
library(tidyverse)
library(lubridate)
library(janitor)

# Read the rainfall dataset
rainfall <- read_csv(
  "data/raw/rainfall_manual_daily_andhra_pradesh_sw_ap_2021_2025.csv",
  show_col_types = FALSE
)

# Clean column names
rainfall <- clean_names(rainfall)

# 1. Dataset size
cat("\n========== DATASET SIZE ==========\n")
cat("Rows:", nrow(rainfall), "\n")
cat("Columns:", ncol(rainfall), "\n")

# 2. Column names
cat("\n========== COLUMN NAMES ==========\n")
print(names(rainfall))

# 3. First six records
cat("\n========== FIRST SIX RECORDS ==========\n")
print(head(rainfall))

# 4. Dataset structure
cat("\n========== DATA STRUCTURE ==========\n")
glimpse(rainfall)

# 5. Missing values
cat("\n========== MISSING VALUES ==========\n")
print(colSums(is.na(rainfall)))

# 6. Duplicate records
cat("\n========== DUPLICATE RECORDS ==========\n")
cat(sum(duplicated(rainfall)), "\n")

# 7. Save an inspection copy
write_csv(
  rainfall,
  "data/processed/rainfall_inspected.csv"
)

cat("\nRainfall inspection completed!\n")

