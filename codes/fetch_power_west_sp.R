# =====================================================
# NASA POWER Climate Data — West São Paulo Municipalities
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
load_or_install(c("dplyr", "purrr", "nasapower", "readxl", "arrow"))

# Load only the packages that are used extensively
library(dplyr)
library(purrr)
library(nasapower)

# -----------------------------------------------------
# 1. Load input data (municipality codes + coordinates)
# -----------------------------------------------------
muni_data <- readxl::read_xlsx("../data/bronze/municipal_data_west_sp.xlsx") |>
  mutate(across(c(Latitude, Longitude), as.numeric))

# -----------------------------------------------------
# 2. Variables of interest
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
# 3. Download function for a single municipality
# -----------------------------------------------------
download_power <- function(lat, lon, name, code) {
  get_power(
    community    = "AG",
    pars         = vars,
    temporal_api = "daily",
    lonlat       = c(lon, lat),   # order: longitude, latitude
    dates        = c("2024-12-29", "2025-07-05")
  ) |>
    mutate(
      municipality = name,
      ibge_code    = code
    )
}

# -----------------------------------------------------
# 4. Apply to all municipalities in the dataset
# -----------------------------------------------------
climate_data <- pmap_dfr(
  muni_data,
  ~ download_power(..3, ..4, ..2, ..1)
)

# -----------------------------------------------------
# 5. Export results
# -----------------------------------------------------
arrow::write_parquet(climate_data, "../data/bronze/climate_west_sp_daily.parquet")

message("Climate data successfully saved as Parquet.")

# -----------------------------------------------------
# 6. Clean up auxiliary objects
# -----------------------------------------------------
rm(load_or_install, download_power, vars)
