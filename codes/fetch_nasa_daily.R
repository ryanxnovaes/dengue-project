# =====================================================
# NASA POWER Climate Data — Presidente Prudente (SP)
# Fetch NASA DATA (Daily)
# Bronze (parquet)
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
load_or_install(c("dplyr", "nasapower", "arrow"))

library(dplyr)
library(nasapower)

# -----------------------------------------------------
# 1. Variables of interest
# -----------------------------------------------------
vars <- c(
  # Core
  "PRECTOTCORR", "T2M", "T2M_MAX", "T2M_MIN", "RH2M", "WS2M",
  # Complementary
  "T2MDEW", "T2MWET", "QV2M", "ALLSKY_SFC_SW_DWN", "GWETTOP",
  # Controls
  "WS2M_MAX", "WS2M_MIN", "WS10M", "PS", "WD2M"
)

# -----------------------------------------------------
# 2. Download climate data for Presidente Prudente
# -----------------------------------------------------
climate_data <- get_power(
  community    = "AG",
  pars         = vars,
  temporal_api = "daily",
  lonlat       = c(-51.388974, -22.120945), # order: longitude, latitude
  dates        = c("2023-12-31", "2025-07-05")
) |>
  mutate(
    municipality = "Presidente Prudente",
    ibge_code    = 3541406
  )

# -----------------------------------------------------
# 3. Export results
# -----------------------------------------------------
arrow::write_parquet(climate_data, "../data/bronze/climate_prudente_daily.parquet")

message("Climate data for Presidente Prudente successfully saved as Parquet.")

# -----------------------------------------------------
# 4. Clean up auxiliary objects
# -----------------------------------------------------
rm(load_or_install, vars)
