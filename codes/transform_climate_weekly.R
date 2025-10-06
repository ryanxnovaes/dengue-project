# =====================================================
# Climate Data — Presidente Prudente (SP)
# Transform & Aggregation: Daily -> Weekly
# Bronze (parquet) -> Silver (parquet)
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

load_or_install(c("dplyr", "lubridate", "MMWRweek", "arrow"))

# -----------------------------------------------------
# 1. Process data (direct pipeline, no helper function)
# -----------------------------------------------------
climate_week <- arrow::read_parquet("../data/bronze/climate_prudente_daily.parquet") |>
  dplyr::mutate(
    week_id = MMWRweek::MMWRweek(YYYYMMDD)$MMWRweek,
    year_id = MMWRweek::MMWRweek(YYYYMMDD)$MMWRyear
  ) |> 
  dplyr::group_by(year_id, week_id) |>
  dplyr::summarise(
    rain_sum       = sum(PRECTOTCORR, na.rm = TRUE),      # total precipitation (mm)
    temp           = mean(T2M, na.rm = TRUE),             # average air temperature at 2m (°C)
    temp_abs_max   = max(T2M_MAX, na.rm = TRUE),          # absolute max temperature (°C)
    temp_abs_min   = min(T2M_MIN, na.rm = TRUE),          # absolute min temperature (°C)
    rh             = mean(RH2M, na.rm = TRUE),            # relative humidity at 2m (%)
    sh             = mean(QV2M, na.rm = TRUE),            # specific humidity at 2m (kg/kg)
    wind_speed_2m  = mean(WS2M, na.rm = TRUE),            # avg wind speed at 2m (m/s)
    wind_speed_2m_max = max(WS2M_MAX, na.rm = TRUE),      # max wind speed at 2m (m/s)
    wind_speed_2m_min = min(WS2M_MIN, na.rm = TRUE),      # min wind speed at 2m (m/s)
    wind_speed_10m = mean(WS10M, na.rm = TRUE),           # avg wind speed at 10m (m/s)
    wind_dir       = {                                    # mean wind direction (°)
      rad <- WD2M * pi / 180
      u   <- mean(-WS2M * sin(rad), na.rm = TRUE)
      v   <- mean(-WS2M * cos(rad), na.rm = TRUE)
      (atan2(u, v) * 180 / pi + 180) %% 360
    },
    pressure       = mean(PS, na.rm = TRUE),              # surface pressure (Pa)
    dew_point      = mean(T2MDEW, na.rm = TRUE),          # dew point temperature at 2m (°C)
    wet_bulb       = mean(T2MWET, na.rm = TRUE),          # wet-bulb temperature at 2m (°C)
    radiation      = mean(ALLSKY_SFC_SW_DWN, na.rm = TRUE), # downward solar radiation (MJ/m²/day)
    soil_moisture  = mean(GWETTOP, na.rm = TRUE),         # soil moisture (0-1)
    .groups = "drop"
  ) |>
  dplyr::mutate(
    season = dplyr::case_when(
      week_id %in% 1:11  ~ "Summer",
      week_id %in% 12:25 ~ "Autumn",
      week_id %in% 26:38 ~ "Winter",
      week_id %in% 39:51 ~ "Spring",
      week_id == 52      ~ "Summer",
      TRUE ~ NA_character_
    )
  )

# -----------------------------------------------------
# 2. Export
# -----------------------------------------------------
arrow::write_parquet(climate_week, "../data/silver/climate_prudente_weekly.parquet")

message("CLIMATE WEEKLY DATA successfully saved as PARQUET.")

# -----------------------------------------------------
# 3. Clean up
# -----------------------------------------------------
rm(load_or_install)
