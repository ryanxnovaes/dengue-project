# =====================================================
# Working Data — Presidente Prudente (SP)
# Integration: Climate (Weekly) + Dengue (Weekly)
# Silver (parquet) -> Gold (parquet)
# =====================================================

# -----------------------------------------------------
# 1. Load input data (Silver layer)
# -----------------------------------------------------
climate_week <- arrow::read_parquet("../data/silver/climate_prudente_weekly.parquet")
dengue_data  <- arrow::read_parquet("../data/silver/dengue_weekly_west_sp.parquet")

# -----------------------------------------------------
# 2. Merge and prepare working dataset
# -----------------------------------------------------
working_data <- dplyr::inner_join(climate_week, dengue_data, by = "week_id") |>
  dplyr::relocate(dengue_cases, .after = week_id)

# -----------------------------------------------------
# 3. Export to Gold layer
# -----------------------------------------------------
arrow::write_parquet(working_data, "../data/gold/working_data.parquet")

message("WORKING DATA successfully saved as PARQUET (Gold layer).")

# -----------------------------------------------------
# 4. Clean up
# -----------------------------------------------------
rm(climate_week, dengue_data)
