# =====================================================
# Dengue Weekly Data — Presidente Prudente
# ETL — Dengue (Weekly)
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
dengue_data <- readxl::read_xlsx("../data/bronze/dengue_prudente_weekly.xlsx")

# -----------------------------------------------------
# 2. Filter and clean
# -----------------------------------------------------
dengue_data <- dengue_data |>
  mutate(
    semana_epidemiologica = as.integer(sub(".*/", "", `Ano/Semana`))
) |>
  filter(semana_epidemiologica <= 27) |>
  select(semana_epidemiologica,`Casos prováveis de Dengue.`)

# Standardize column names to ACI/NASA pattern
colnames(dengue_data) <- c(
  "week_id",      # Epidemiological week
  "dengue_cases"   # Probable dengue cases
)

# -----------------------------------------------------
# 3. Export results
# -----------------------------------------------------
arrow::write_parquet(dengue_data, "../data/silver/dengue_prudente_weekly.parquet")

message("DENGUE WEEKLY DATA successfully saved as PARQUET.")

# -----------------------------------------------------
# 4. Clean up auxiliary objects
# -----------------------------------------------------
rm(load_or_install)
