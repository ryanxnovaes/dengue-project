# =====================================================
# Dengue Weekly Data — West São Paulo Municipalities
# ETL — Dengue (Weekly) | West São Paulo
# Bronze (xlsx) -> Silver (parquet)
# =====================================================

# -----------------------------------------------------
# 0. Helper: install & load packages if missing
# -----------------------------------------------------
load_or_install <- function(pkgs) {
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(sprintf("Installing package: %s", pkg))
      install.packages(pkg, dependencies = TRUE)
    } else {
      message(sprintf("Package already available: %s", pkg))
    }
  }
}

# Essential packages
load_or_install(c("dplyr", "readxl", "arrow"))

# Load only the packages that are used extensively
library(dplyr)

# -----------------------------------------------------
# 1. Load input data
# -----------------------------------------------------
dengue_data <- readxl::read_xlsx("../data/bronze/dengue_weekly_west_sp.xlsx")

# -----------------------------------------------------
# 2. Filter and clean
# -----------------------------------------------------
dengue_data <- dengue_data |>
  filter(`Região|UF|Município` == "Sudeste") |>  # Keep only Southeast region
  mutate(
    `Casos prováveis de Dengue.` = if_else(
      `Casos prováveis de Dengue.` == "(Em branco)", "0", `Casos prováveis de Dengue.`
    ),
    `Casos prováveis de Dengue.` = as.numeric(`Casos prováveis de Dengue.`),
    YEAR   = as.integer(sub("/.*", "", `Ano/Semana`)),
    WEEK   = as.integer(sub(".*/", "", `Ano/Semana`))
  )

# Standardize column names to ACI/NASA pattern
colnames(dengue_data) <- c(
  "REGION",        # Região|UF|Município
  "STATE",         # UF
  "CITY",          # Município
  "YEAR_WEEK",     # Ano/Semana
  "DENGUE_CASES",  # Casos prováveis de Dengue.
  "YEAR",          # Ano
  "WEEK"           # Semana
)

# -----------------------------------------------------
# 3. Export results
# -----------------------------------------------------
arrow::write_parquet(dengue_data, "../data/silver/dengue_weekly_west_sp.parquet")

message("DENGUE WEEKLY DATA successfully saved as PARQUET.")

# -----------------------------------------------------
# 4. Clean up auxiliary objects
# -----------------------------------------------------
rm(load_or_install)
