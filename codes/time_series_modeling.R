# =====================================================
# Working Data — Presidente Prudente (SP)
# Descriptive Analysis, Visualization and Time-Series Modeling
# Integration: Climatic, Entomological and Epidemiological Data
# =====================================================

# -----------------------------------------------------
# 1. Load working dataset (Gold layer)
# -----------------------------------------------------
working_data <- arrow::read_parquet("../data/gold/working_data.parquet")
# =====================================================

# =====================================================
# 2. Descriptive Analysis
# =====================================================

# -----------------------------------------------------
# 2.1 Summary Statistics
# -----------------------------------------------------
psych::describe(working_data[, c(4:21, 23:24)]) |>
  (\(desc) {
    desc$cv <- desc$sd / desc$mean
    desc[, c(names(desc)[1:5], names(desc)[8:9], names(desc)[11:12], names(desc)[14])]
  })()

# =====================================================
# 2.2 Histograms
# =====================================================
gg_histograms <- function(data, save = FALSE, ncols = 5) {
  
  var_labels <- c("Dengue Cases", "Total Rainfall", "Mean Temperature",
                  "Maximum Temperature", "Minimum Temperature", "Temperature Range",
                  "Relative Humidity", "Specific Humidity", "Wind Speed (2m)",
                  "Max Wind Speed (2m)", "Min Wind Speed (2m)", "Wind Speed (10m)",
                  "Wind Direction", "Atmospheric Pressure", "Dew Point",
                  "Wet-Bulb Temperature", "Solar Radiation", "Soil Moisture",
                  "Premises Index", "Breteau Index")
  
  # Fallback to column names if labels and data columns don't match
  if (length(var_labels) != ncol(data)) 
    var_labels <- names(data)
  
  plots <- purrr::map(seq_len(ncol(data)), function(i) {
    ggplot2::ggplot(data, ggplot2::aes(x = .data[[names(data)[i]]])) +
      ggplot2::geom_histogram(
        ggplot2::aes(y = ggplot2::after_stat(density)),
        bins = max(10, grDevices::nclass.FD(data[[i]])),
        color = "black", fill = "#4c9a29", alpha = 0.6
      ) +
      ggplot2::geom_density(color = "#112f0e", linewidth = 1) +
      ggplot2::labs(title = var_labels[i], x = var_labels[i], y = "Density") +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
        axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 5)),
        axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 5))
      )
  })
  
  half <- ceiling(length(plots) / 2)
  
  panel1 <- patchwork::wrap_plots(plots[1:half], ncol = ncols) + 
    patchwork::plot_annotation(
      title = "Histograms — Part 1",
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
      )
    )
  
  panel2 <- patchwork::wrap_plots(plots[(half + 1):length(plots)], ncol = ncols) + 
    patchwork::plot_annotation(
      title = "Histograms — Part 2",
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
      )
    )
  
  if (save) {
    ggplot2::ggsave("histograms_part1.png", panel1, width = 14, height = 8, dpi = 300)
    ggplot2::ggsave("histograms_part2.png", panel2, width = 14, height = 8, dpi = 300)
  }
  
  list(panel1, panel2)
}

panels <- gg_histograms(working_data[, c(4:21, 23:24)], save = FALSE)

ggplot2::ggsave("figures/histograms_part1.png", panels[[1]], width = 14, height = 8, dpi = 300)
ggplot2::ggsave("figures/histograms_part2.png", panels[[2]], width = 14, height = 8, dpi = 300)

# =====================================================
# 2.3 Boxplots
# =====================================================
gg_boxplots <- function(data, save = FALSE, ncols = 5) {
  
  var_labels <- c("Dengue Cases", "Total Rainfall", "Mean Temperature",
                  "Maximum Temperature", "Minimum Temperature", "Temperature Range",
                  "Relative Humidity", "Specific Humidity", "Wind Speed (2m)",
                  "Max Wind Speed (2m)", "Min Wind Speed (2m)", "Wind Speed (10m)",
                  "Wind Direction", "Atmospheric Pressure", "Dew Point",
                  "Wet-Bulb Temperature", "Solar Radiation", "Soil Moisture",
                  "Premises Index", "Breteau Index")
  
  if (length(var_labels) != ncol(data)) 
    var_labels <- names(data)
  
  plots <- purrr::map(seq_len(ncol(data)), function(i) {
    ggplot2::ggplot(data, ggplot2::aes(y = .data[[names(data)[i]]])) +
      ggplot2::geom_boxplot(
        fill = "#4c9a29", color = "black", alpha = 0.6, outlier.color = "#112f0e"
      ) +
      ggplot2::labs(title = var_labels[i], y = var_labels[i], x = "") +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
        axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 5)),
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank()
      )
  })
  
  half <- ceiling(length(plots) / 2)
  
  panel1 <- patchwork::wrap_plots(plots[1:half], ncol = ncols) + 
    patchwork::plot_annotation(
      title = "Boxplots — Part 1",
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
      )
    )
  
  panel2 <- patchwork::wrap_plots(plots[(half + 1):length(plots)], ncol = ncols) + 
    patchwork::plot_annotation(
      title = "Boxplots — Part 2",
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(hjust = 0.5, face = "bold")
      )
    )
  
  if (save) {
    ggplot2::ggsave("boxplots_part1.png", panel1, width = 14, height = 8, dpi = 300)
    ggplot2::ggsave("boxplots_part2.png", panel2, width = 14, height = 8, dpi = 300)
  }
  
  list(panel1, panel2)
}

box_panels <- gg_boxplots(working_data[, c(4:21, 23:24)], save = FALSE)

ggplot2::ggsave("figures/boxplots_part1.png", box_panels[[1]], width = 14, height = 8, dpi = 300)
ggplot2::ggsave("figures/boxplots_part2.png", box_panels[[2]], width = 14, height = 8, dpi = 300)

# =====================================================
# 2.4 Correlation Analysis
# =====================================================
corr_plot <- ggcorrplot::ggcorrplot(
  {
    cor_matrix <- stats::cor(
      working_data[, c(4:21, 23:24)],
      use = "pairwise.complete.obs",
      method = "pearson"
    )
    colnames(cor_matrix) <- rownames(cor_matrix) <- c(
      "Dengue Cases", "Total Rainfall", "Mean Temperature",
      "Maximum Temperature", "Minimum Temperature", "Temperature Range",
      "Relative Humidity", "Specific Humidity", "Wind Speed (2m)",
      "Max Wind Speed (2m)", "Min Wind Speed (2m)", "Wind Speed (10m)",
      "Wind Direction", "Atmospheric Pressure", "Dew Point",
      "Wet-Bulb Temperature", "Solar Radiation", "Soil Moisture",
      "Premises Index", "Breteau Index"
    )
    cor_matrix
  },
  hc.order = TRUE,
  type = "lower",
  lab = TRUE,
  lab_size = 2.8,
  colors = c("#d9f2e6", "#34c759", "#0b6623"),
  title = "Correlation Matrix — Climatic and Entomological Variables",
  ggtheme = ggplot2::theme_minimal(base_size = 12)
) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 13, face = "bold", hjust = 0.5, color = "#0b6623"),
    panel.grid.major = ggplot2::element_blank(),
    panel.border = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_text(size = 9, angle = 45, hjust = 1, vjust = 1, color = "gray20"),
    axis.text.y = ggplot2::element_text(size = 9, color = "gray20")
  )
ggplot2::ggsave("figures/correlation_matrix.png", corr_plot, width = 10, height = 8, dpi = 300)

png("figures/chart_correlation.png", width = 1400, height = 1200, res = 150)
PerformanceAnalytics::chart.Correlation(
  working_data[, c(4:21, 23:24)],
  histogram = TRUE,
  pch = 21,
  bg = "#69b3a2",
  col = "#1a1a1a",
  main = "Correlation Matrix — Pearson",
  method = "pearson"
)
dev.off()

# -----------------------------------------------------
# Clean-up
# -----------------------------------------------------
rm(box_panels, cor_matrix, panels, gg_histograms, gg_boxplots, corr_plot)
# =====================================================

# =====================================================
# 4. Time-Series Visualization
# =====================================================

# -----------------------------------------------------
# 4.1 Create time series object
# -----------------------------------------------------
dengue_ts <- ts(working_data$dengue_cases, start = c(2022, 01), frequency = 52)

# --- Class and Attributes --- #
class(dengue_ts)
start(dengue_ts)
end(dengue_ts)
frequency(dengue_ts)
length(dengue_ts)

# -----------------------------------------------------
# 4.2 Plot — Weekly Dengue Cases
# -----------------------------------------------------
cases_plot <- ggplot2::ggplot(
  working_data |>
    dplyr::mutate(week_label = sprintf("%02d/%d", week_id, year_id)) |>
    dplyr::arrange(dplyr::desc(dengue_cases)) |>
    dplyr::mutate(rank = dplyr::row_number()),
  ggplot2::aes(x = week_start, y = dengue_cases)
) +
  ggplot2::geom_line(color = "#112f0e", linewidth = 1.1, lineend = "round") +
  ggplot2::geom_point(color = "#112f0e", fill = "#f0fff0", size = 2.6, stroke = 1, shape = 21) +
  ggplot2::geom_point(
    data = dplyr::slice(
      dplyr::arrange(working_data, dplyr::desc(dengue_cases)) |>
        dplyr::mutate(week_label = sprintf("%02d/%d", week_id, year_id)),
      c(1, 5, 25)
    ),
    ggplot2::aes(x = week_start, y = dengue_cases),
    color = "#4C9A2A", size = 3.5
  ) +
  ggplot2::geom_label(
    data = dplyr::slice(
      dplyr::arrange(working_data, dplyr::desc(dengue_cases)) |>
        dplyr::mutate(week_label = sprintf("%02d/%d", week_id, year_id)),
      c(1, 5, 25)
    ),
    ggplot2::aes(x = week_start, y = dengue_cases, label = week_label),
    color = "#4C9A2A", fill = "#f0fff0", label.size = 0.3,
    size = 3.5, nudge_y = max(working_data$dengue_cases) * 0.03
  ) +
  ggplot2::scale_x_date(
    date_breaks = "2 months",
    date_minor_breaks = "1 month",
    date_labels = "%b/%Y",
    expand = ggplot2::expansion(mult = c(0.01, 0.01))
  ) +
  ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0.05, 0.1))) +
  ggplot2::labs(
    title = "Weekly Dengue Cases",
    subtitle = "Weekly series — from 2022 to 2025",
    x = "Time (approx. bimonthly intervals)",
    y = "Dengue Cases"
  ) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(
    plot.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.grid.major = ggplot2::element_line(color = "gray85", linetype = "dotted", linewidth = 0.4),
    panel.grid.minor = ggplot2::element_line(color = "gray90", linetype = "dotted", linewidth = 0.3),
    axis.line = ggplot2::element_line(color = "gray50", linewidth = 0.4),
    axis.text = ggplot2::element_text(color = "gray25"),
    axis.title = ggplot2::element_text(color = "gray20"),
    plot.title = ggplot2::element_text(face = "bold", size = 14, hjust = 0.5, color = "#112f0e"),
    plot.subtitle = ggplot2::element_text(size = 11, hjust = 0.5, color = "gray40"),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    plot.margin = ggplot2::margin(10, 15, 10, 10)
  )

ggplot2::ggsave("figures/weekly_dengue_cases.png", cases_plot, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.3 Plot — Time series with mean
# -----------------------------------------------------
mean_cases_plot <- ggplot2::ggplot(
  working_data |>
    dplyr::mutate(
      week_label = sprintf("%02d/%d", week_id, year_id),
      mean_cases = mean(dengue_cases, na.rm = TRUE)
    ),
  ggplot2::aes(x = week_start, y = dengue_cases)
) +
  ggplot2::geom_line(ggplot2::aes(color = "Weekly Cases"), linewidth = 1.1, lineend = "round") +
  ggplot2::geom_point(ggplot2::aes(color = "Weekly Cases"), fill = "#f0fff0", size = 2.6, stroke = 1, shape = 21) +
  ggplot2::geom_point(
    data = dplyr::slice(
      dplyr::arrange(working_data, dplyr::desc(dengue_cases)) |>
        dplyr::mutate(week_label = sprintf("%02d/%d", week_id, year_id)),
      c(1, 5, 25)
    ),
    ggplot2::aes(x = week_start, y = dengue_cases, color = "Peaks"),
    size = 3.5
  ) +
  ggplot2::geom_label(
    data = dplyr::slice(
      dplyr::arrange(working_data, dplyr::desc(dengue_cases)) |>
        dplyr::mutate(week_label = sprintf("%02d/%d", week_id, year_id)),
      c(1, 5, 25)
    ),
    ggplot2::aes(x = week_start, y = dengue_cases, label = week_label),
    color = "#4C9A2A", fill = "#f0fff0", label.size = 0.3,
    size = 3.5, nudge_y = max(working_data$dengue_cases) * 0.03
  ) +
  # --- Mean line (no warning) ---
  ggplot2::geom_hline(
    yintercept = mean(working_data$dengue_cases, na.rm = TRUE),
    color = "#2e4600", linewidth = 0.8, linetype = "dotdash"
  ) +
  # --- Invisible point to add "Mean" to legend ---
  ggplot2::geom_point(
    ggplot2::aes(color = "Mean"),
    alpha = 0
  ) +
  ggplot2::annotate(
    "text",
    x = min(working_data$week_start) + 750,
    y = mean(working_data$dengue_cases, na.rm = TRUE) * 1.03,
    label = paste0(
      "Mean = ",
      format(round(mean(working_data$dengue_cases, na.rm = TRUE), 3), big.mark = ",")
    ),
    color = "#2e4600",
    hjust = 0, vjust = -0.5,
    size = 3.3
  ) +
  ggplot2::scale_color_manual(
    name = NULL,
    values = c(
      "Weekly Cases" = "#112f0e",
      "Peaks" = "#4C9A2A",
      "Mean" = "#2e4600"
    ),
    breaks = c("Weekly Cases", "Peaks", "Mean")
  ) +
  ggplot2::scale_x_date(
    date_breaks = "2 months",
    date_minor_breaks = "1 month",
    date_labels = "%b/%Y",
    expand = ggplot2::expansion(mult = c(0.01, 0.01))
  ) +
  ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0.05, 0.1))) +
  ggplot2::labs(
    title = "Weekly Dengue Cases",
    subtitle = "Weekly series — from 2022 to 2025",
    x = "Time (approx. bimonthly intervals)",
    y = "Dengue Cases"
  ) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(
    legend.position = "top",
    legend.text = ggplot2::element_text(size = 10, color = "gray20"),
    plot.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.grid.major = ggplot2::element_line(color = "gray85", linetype = "dotted", linewidth = 0.4),
    panel.grid.minor = ggplot2::element_line(color = "gray90", linetype = "dotted", linewidth = 0.3),
    axis.line = ggplot2::element_line(color = "gray50", linewidth = 0.4),
    axis.text = ggplot2::element_text(color = "gray25"),
    axis.title = ggplot2::element_text(color = "gray20"),
    plot.title = ggplot2::element_text(face = "bold", size = 14, hjust = 0.5, color = "#112f0e"),
    plot.subtitle = ggplot2::element_text(size = 11, hjust = 0.5, color = "gray40"),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    plot.margin = ggplot2::margin(10, 15, 10, 10)
  )

ggplot2::ggsave("figures/mean_weekly_dengue_cases.png", mean_cases_plot, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.4 Histogram + Density
# -----------------------------------------------------
hist_cases <- ggplot2::ggplot(
  data.frame(x = working_data$dengue_cases),
  ggplot2::aes(x = x)
) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    breaks = hist(working_data$dengue_cases, breaks = 15, plot = FALSE)$breaks,
    fill = "#112f0e",      # base color (same as time-series line)
    color = "white",
    alpha = 0.8
  ) +
  ggplot2::geom_density(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    color = "#4C9A2A",     # peak/feature green
    linewidth = 1.2
  ) +
  ggplot2::labs(
    title = "Histogram of Weekly Dengue Cases",
    subtitle = "Distribution of dengue incidence from 2022 to 2025",
    x = "Dengue Cases",
    y = "Density"
  ) +
  ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0.05, 0.1))) +
  ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0.02, 0.02))) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.grid.major = ggplot2::element_line(color = "gray85", linetype = "dotted", linewidth = 0.4),
    panel.grid.minor = ggplot2::element_line(color = "gray90", linetype = "dotted", linewidth = 0.3),
    axis.line = ggplot2::element_line(color = "gray50", linewidth = 0.4),
    axis.text = ggplot2::element_text(color = "gray25"),
    axis.title = ggplot2::element_text(color = "gray20"),
    plot.title = ggplot2::element_text(face = "bold", size = 14, hjust = 0.5, color = "#112f0e"),
    plot.subtitle = ggplot2::element_text(size = 11, hjust = 0.5, color = "gray40"),
    plot.margin = ggplot2::margin(10, 15, 10, 10)
  )

ggplot2::ggsave("figures/hist_dengue_cases.png", hist_cases, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.5 Boxplots by Year
# -----------------------------------------------------
plots <- lapply(unique(working_data$year_id), function(y) {
  ggplot2::ggplot(
    data = subset(working_data, year_id == y),
    ggplot2::aes(x = factor(year_id), y = dengue_cases, fill = factor(year_id))
  ) +
    ggplot2::geom_boxplot(
      color = "gray25",
      alpha = 0.75,
      outlier.shape = 21,
      outlier.fill = "white",
      outlier.color = "#112f0e",
      linewidth = 0.5
    ) +
    ggplot2::scale_fill_manual(
      values = c("#4C9A2A")
    ) +
    ggplot2::labs(
      title = paste("Year", y),
      x = "Year",
      y = "Dengue Cases"
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(
      legend.position = "none",
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.grid.major = ggplot2::element_line(color = "gray85", linetype = "dotted", linewidth = 0.4),
      panel.grid.minor = ggplot2::element_line(color = "gray90", linetype = "dotted", linewidth = 0.3),
      axis.line = ggplot2::element_line(color = "gray50", linewidth = 0.4),
      axis.text = ggplot2::element_text(color = "gray25"),
      axis.title = ggplot2::element_text(color = "gray20"),
      plot.title = ggplot2::element_text(face = "bold", size = 12, hjust = 0.5, color = "#112f0e"),
      plot.margin = ggplot2::margin(10, 15, 10, 10)
    )
})

plots_years <- patchwork::wrap_plots(plots, ncol = 2) +
  patchwork::plot_annotation(
    title = "Boxplots of Weekly Dengue Cases by Year",
    subtitle = "Independent scales per year — 2022 to 2025"
  ) &
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = 14, hjust = 0.5, color = "#112f0e"),
    plot.subtitle = ggplot2::element_text(size = 11, hjust = 0.5, color = "gray40")
  )

ggplot2::ggsave("figures/boxplot_dengue_cases.png", plots_years, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.6 Boxplots by Week
# -----------------------------------------------------
plot_week <- ggplot2::ggplot(
  data = working_data,
  ggplot2::aes(x = factor(week_id), y = dengue_cases, fill = "#4C9A2A")
) +
  ggplot2::geom_boxplot(
    color = "gray25",
    alpha = 0.75,
    outlier.shape = 21,
    outlier.fill = "white",
    outlier.color = "#112f0e",
    linewidth = 0.5
  ) +
  ggplot2::scale_fill_identity() +
  ggplot2::labs(
    title = "Boxplot of Dengue Cases by Week",
    subtitle = "Weekly distribution across all available years",
    x = "Week",
    y = "Dengue Cases"
  ) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(
    legend.position = "none",
    plot.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.background = ggplot2::element_rect(fill = "white", color = NA),
    panel.grid.major = ggplot2::element_line(color = "gray85", linetype = "dotted", linewidth = 0.4),
    panel.grid.minor = ggplot2::element_line(color = "gray90", linetype = "dotted", linewidth = 0.3),
    axis.line = ggplot2::element_line(color = "gray50", linewidth = 0.4),
    axis.text = ggplot2::element_text(color = "gray25"),
    axis.title = ggplot2::element_text(color = "gray20"),
    plot.title = ggplot2::element_text(face = "bold", size = 14, hjust = 0.5, color = "#112f0e"),
    plot.subtitle = ggplot2::element_text(size = 11, hjust = 0.5, color = "gray40"),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    plot.margin = ggplot2::margin(10, 15, 10, 10)
  )

ggplot2::ggsave("figures/boxplot_week_dengue_cases.png", plot_week, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.7 Autocorrelation (ACF)
# -----------------------------------------------------
forecast::Acf(dengue_ts, plot = FALSE, lag.max = 30) -> acf_res
acf_df <- data.frame(lag = acf_res$lag, acf = acf_res$acf)

n          <- sum(!is.na(dengue_ts))
conf_limit <- 1.96 / sqrt(n)

acf_df_plot <- acf_df |>
  dplyr::filter(lag != 0) |>
  dplyr::mutate(significant = ifelse(abs(acf) > conf_limit, "Yes", "No"))

acf <- ggplot2::ggplot(acf_df_plot, ggplot2::aes(x = lag, y = acf, fill = significant)) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::geom_hline(
    yintercept = c(0, conf_limit, -conf_limit),
    linetype = "dashed", color = "red"
  ) +
  ggplot2::scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "lightgray")) +
  ggplot2::labs(
    title = "Correlogram (ACF) of Dengue Cases",
    x = "Lag",
    y = "ACF",
    fill = "Significant"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, margin = ggplot2::margin(b = 30)),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 20)),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 20))
  )

ggplot2::ggsave("figures/acf_dengue_cases.png", acf, width = 10, height = 6, dpi = 300)

# -----------------------------------------------------
# 4.8 Partial Autocorrelation (PACF)
# -----------------------------------------------------
forecast::Pacf(dengue_ts, plot = FALSE, lag.max = 30) -> pacf_res
pacf_df <- data.frame(lag = pacf_res$lag, pacf = pacf_res$acf)

n          <- sum(!is.na(dengue_ts))
conf_limit <- 1.96 / sqrt(n)

pacf_df <- pacf_df |>
  dplyr::filter(lag != 0) |>
  dplyr::mutate(significant = ifelse(abs(pacf) > conf_limit, "Yes", "No"))

pacf <- ggplot2::ggplot(pacf_df, ggplot2::aes(x = lag, y = pacf, fill = significant)) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::geom_hline(
    yintercept = c(0, conf_limit, -conf_limit),
    linetype = "dashed", color = "red"
  ) +
  ggplot2::scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "lightgray")) +
  ggplot2::labs(
    title = "Partial Correlogram (PACF) of Dengue Cases",
    x = "Lag",
    y = "PACF",
    fill = "Significant"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, margin = ggplot2::margin(b = 30)),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 20)),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 20))
  )

ggplot2::ggsave("figures/pacf_dengue_cases.png", pacf, width = 10, height = 6, dpi = 300)

rm(list = setdiff(ls(), c("working_data", "dengue_ts")))

# =====================================================
# 5. Stationarity Tests
# =====================================================
tseries::adf.test(dengue_ts)
tseries::kpss.test(dengue_ts, null = "Level")
tseries::pp.test(dengue_ts)

# =====================================================

# =====================================================
# 6. Time-Series Model Fitting — SARIMA Grid Search
# =====================================================

# -----------------------------------------------------
# 6.1 Packages and Model Grid
# -----------------------------------------------------
library(forecast)
library(future.apply)
library(tseries)

grid <- expand.grid(
  p = 0:2, d = 0:1, q = 0:2,
  P = 0:2, D = 0:1, Q = 0:2
)

# -----------------------------------------------------
# 6.2 Model Fitting Function
# -----------------------------------------------------
fit_model <- function(i) {
  params <- grid[i, ]
  
  tryCatch({
    fit <- forecast::Arima(
      dengue_ts,
      order = c(params$p, params$d, params$q),
      seasonal = list(order = c(params$P, params$D, params$Q), period = 52)
    )
    
    cat(sprintf("%d/%d models tested\n", i, nrow(grid)))
    
    data.frame(
      model = paste0("(", params$p, ",", params$d, ",", params$q, ")(",
                     params$P, ",", params$D, ",", params$Q, ")[52]"),
      AIC = fit$aic,
      AICc = fit$aicc,
      BIC = BIC(fit),
      logLik = as.numeric(logLik(fit)),
      sigma2 = fit$sigma2
    )
    
  }, error = function(e) NULL)
}

# -----------------------------------------------------
# 6.3 Parallel Execution (Multisession)
# -----------------------------------------------------
future::plan(future::multisession, workers = (parallel::detectCores() - 1))

results_list <- future.apply::future_lapply(1:nrow(grid), fit_model)
results <- do.call(rbind, Filter(Negate(is.null), results_list))
print(results)

# -----------------------------------------------------
# 6.4 Model Selection and Ranking
# -----------------------------------------------------
best_overall <- results[order(results$AIC), ]
top10 <- head(best_overall, 10)
print(top10)

top5_forecast  <- head(best_overall, 5)
top5_explainer <- results[order(results$BIC, -results$logLik), ][1:5, ]

cat("\n--- Top 5 for Forecasting ---\n")
print(top5_forecast[, c("model", "AIC", "BIC", "logLik", "sigma2")])

cat("\n--- Top 5 for Explanation ---\n")
print(top5_explainer[, c("model", "AIC", "BIC", "logLik", "sigma2")])

# =====================================================
# 6.5 Selected Models and Performance Criteria
# =====================================================

# -----------------------------------------------------
# 6.5.1 Selected SARIMA Models
# -----------------------------------------------------
selected_models <- list(
  # ----- For Forecasting -----
  forecast::Arima(dengue_ts, order = c(2, 1, 2), seasonal = list(order = c(1, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(2, 1, 2), seasonal = list(order = c(1, 1, 0), period = 52)),
  forecast::Arima(dengue_ts, order = c(1, 1, 1), seasonal = list(order = c(0, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(2, 1, 0), seasonal = list(order = c(0, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(2, 0, 1), seasonal = list(order = c(0, 1, 1), period = 52)),
  
  # ----- For Explanation -----
  forecast::Arima(dengue_ts, order = c(1, 1, 0), seasonal = list(order = c(0, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(1, 1, 1), seasonal = list(order = c(0, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(2, 1, 0), seasonal = list(order = c(0, 1, 1), period = 52)),
  forecast::Arima(dengue_ts, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 0), period = 52)),
  forecast::Arima(dengue_ts, order = c(1, 1, 0), seasonal = list(order = c(1, 1, 0), period = 52))
)

# -----------------------------------------------------
# 6.5.2 Model Evaluation Criteria Function
# -----------------------------------------------------
calc_metrics <- function(model, series, original_series = NULL, h = 12) {
  fitted_vals <- fitted(model)
  errors      <- series - fitted_vals
  
  # --- In-sample Fit Metrics ---
  rmse    <- sqrt(mean(errors^2))
  mae     <- mean(abs(errors))
  mape    <- mean(abs(errors / series)) * 100
  mape_adj <- mean(abs(errors[series != 0] / series[series != 0])) * 100
  smape   <- mean(200 * abs(series - fitted_vals) / (abs(series) + abs(fitted_vals)))
  
  loglik  <- as.numeric(logLik(model))
  aic     <- AIC(model)
  bic     <- BIC(model)
  
  n       <- length(series)
  k       <- length(model$coef)
  aicc    <- aic + (2 * k * (k + 1)) / (n - k - 1)
  
  # --- Out-of-sample Forecast Metric ---
  if (!is.null(original_series)) {
    fc <- forecast::forecast(model, h = length(original_series))
    mse_forecast <- mean((original_series - fc$mean)^2)
  } else {
    mse_forecast <- NA
  }
  
  return(c(
    LogLik   = loglik,
    AIC      = aic,
    AICc     = aicc,
    BIC      = bic,
    RMSE     = rmse,
    MAE      = mae,
    MAPE     = mape,
    MAPE_ADJ = mape_adj,
    SMAPE    = smape,
    MSE_FC   = mse_forecast
  ))
}

# -----------------------------------------------------
# 6.5.3 Model Names and Evaluation
# -----------------------------------------------------
model_names <- c(
  "M1: (2,1,2)(1,1,1)[52]",
  "M2: (2,1,2)(1,1,0)[52]",
  "M3: (1,1,1)(0,1,1)[52]",
  "M4: (2,1,0)(0,1,1)[52]",
  "M5: (2,0,1)(0,1,1)[52]",
  "M6: (1,1,0)(0,1,1)[52]",
  "M7: (1,1,1)(0,1,1)[52]",
  "M8: (2,1,0)(0,1,1)[52]",
  "M9: (1,1,1)(1,1,0)[52]",
  "M10: (1,1,0)(1,1,0)[52]"
)

names(selected_models) <- model_names

# Reference series for forecast validation
original_series <- c(96, 98, 61, 59, 44, 71, 95, 95, 86, 70, 45, 45)

# Compute all evaluation metrics
criteria <- t(sapply(selected_models, calc_metrics, series = dengue_ts, original_series = original_series))
criteria <- data.frame(Model = names(selected_models), criteria, row.names = NULL)

# -----------------------------------------------------
# 6.5.4 Output — Full Model Comparison
# -----------------------------------------------------
cat("===================================================================================================================\n",
    "\n                                         Full Model Comparison Table                         \n",
    "\n===================================================================================================================\n\n",
    paste(capture.output(print(criteria, row.names = FALSE)), collapse = "\n"),
    "\n===================================================================================================================\n")


# =====================================================
# 9. Predictive Analysis — SARIMA Forecasts
# =====================================================

# -----------------------------------------------------
# 9.1 Forecast Horizon
# -----------------------------------------------------
h <- 25  # Forecast horizon: 25 weeks (until end of the year)

# -----------------------------------------------------
# 9.2 Model and Naming Setup
# -----------------------------------------------------
models        <- selected_models
model_names   <- model_names

# -----------------------------------------------------
# 9.3 Mean Level (Reference Line)
# -----------------------------------------------------
mean_series <- mean(dengue_ts, na.rm = TRUE)

# -----------------------------------------------------
# 9.4 Forecast Plot Function
# -----------------------------------------------------
generate_forecast_plot <- function(model, name) {
  fc <- forecast::forecast(model, h = h)
  
  df_fc <- data.frame(
    Date  = seq(max(working_data$week_start) + 7, by = "week", length.out = length(fc$mean)),
    Level = as.numeric(fc$mean),
    Lo80  = fc$lower[, 1],
    Hi80  = fc$upper[, 1],
    Lo95  = fc$lower[, 2],
    Hi95  = fc$upper[, 2]
  )
  
  ggplot2::ggplot() +
    ggplot2::geom_line(data = working_data,
                       ggplot2::aes(week_start, dengue_cases, color = "Historical"),
                       linewidth = 1.1) +
    ggplot2::geom_point(data = working_data,
                        ggplot2::aes(week_start, dengue_cases),
                        color = "black", size = 1.6) +
    ggplot2::geom_hline(yintercept = mean_series, linetype = "dashed",
                        color = "darkgreen", linewidth = 0.8) +
    ggplot2::geom_line(data = df_fc,
                       ggplot2::aes(Date, Level, color = "Forecast"),
                       linewidth = 1, linetype = "dashed") +
    ggplot2::geom_ribbon(data = df_fc,
                         ggplot2::aes(Date, ymin = Lo95, ymax = Hi95, fill = "95% CI"),
                         alpha = 0.15) +
    ggplot2::geom_ribbon(data = df_fc,
                         ggplot2::aes(Date, ymin = Lo80, ymax = Hi80, fill = "80% CI"),
                         alpha = 0.25) +
    ggplot2::scale_color_manual(values = c("Historical" = "#005BBB", "Forecast" = "#BB0000")) +
    ggplot2::scale_fill_manual(values = c("95% CI" = "orange", "80% CI" = "green")) +
    ggplot2::labs(
      title = paste("Forecast:", name),
      subtitle = "SARIMA Modeling",
      x = "Epidemiological Week",
      y = "Estimated Cases",
      color = "", fill = ""
    ) +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", margin = ggplot2::margin(b = 5)),
      plot.subtitle = ggplot2::element_text(hjust = 0.5, color = "gray30", size = 10),
      legend.position = "top",
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 15)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 15))
    )
}

# -----------------------------------------------------
# 9.5 Forecast Visualization (All Models)
# -----------------------------------------------------
forecast_plots <- mapply(generate_forecast_plot, models, model_names, SIMPLIFY = FALSE)

forec <- patchwork::wrap_plots(forecast_plots, ncol = 5) +
  patchwork::plot_annotation(
    title = "Forecasts of the 10 Best SARIMA Models",
    subtitle = "Comparison of 10 models with a 25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12)
    )
  )

forec <- patchwork::wrap_plots(forecast_plots, ncol = 5, widths = rep(0.8, 5)) +
  patchwork::plot_annotation(
    title = "Forecasts of the 10 Best SARIMA Models",
    subtitle = "Comparison of 10 models with a 25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
    )
  )

ggplot2::ggsave("figures/forecast.png", forec, width = 20, height = 10, dpi = 300, limitsize = FALSE)

# -----------------------------------------------------
# 9.6 Detailed Panels by Model Group
# -----------------------------------------------------
library(patchwork)

panel_1 <- patchwork::wrap_plots(forecast_plots[1:4], ncol = 2) +
  patchwork::plot_annotation(
    title = "Forecasts — SARIMA Models 1 to 4",
    subtitle = "25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
    )
  )

panel_2 <- patchwork::wrap_plots(forecast_plots[5:8], ncol = 2) +
  patchwork::plot_annotation(
    title = "Forecasts — SARIMA Models 5 to 8",
    subtitle = "25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
    )
  )

panel_3 <- patchwork::wrap_plots(forecast_plots[9:10], ncol = 2) +
  patchwork::plot_annotation(
    title = "Forecasts — SARIMA Models 9 and 10",
    subtitle = "25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
    )
  )

ggplot2::ggsave("figures/panel1.png", panel_1, width = 14, height = 8, dpi = 300, limitsize = FALSE)
ggplot2::ggsave("figures/panel2.png", panel_2, width = 14, height = 8, dpi = 300, limitsize = FALSE)
ggplot2::ggsave("figures/panel3.png", panel_3, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# -----------------------------------------------------
# 9.7 Comparison of the Best-Fit Models
# -----------------------------------------------------
best_idx <- c(7, 5, 4, 6)

panel_list <- lapply(1:2, function(i) {
  idx_range <- seq((i - 1) * 2 + 1, i * 2)
  patchwork::wrap_plots(forecast_plots[best_idx][idx_range], ncol = 2) +
    patchwork::plot_annotation(
      title = paste("Forecasts of the Best SARIMA Models (", i, "–", i * 2, ")", sep = ""),
      subtitle = paste(model_names[best_idx][idx_range], collapse = "  |  "),
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
      )
    )
})

panel_final <- patchwork::wrap_plots(panel_list, ncol = 1) +
  patchwork::plot_annotation(
    title = "Comparison of the 4 Best SARIMA Models",
    subtitle = "25-week forecast horizon",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 13, hjust = 0.5)
    )
  )

ggplot2::ggsave("figures/final_panel.png", panel_final, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# =====================================================
# 10. Residual Analysis — Diagnostic Evaluation
# =====================================================

# -----------------------------------------------------
# 10.1 Residual Plotting Function
# -----------------------------------------------------
plot_residuals <- function(model, name) {
  
  res <- residuals(model)
  n   <- length(res)
  conf_limit <- 1.96 / sqrt(n)
  
  df_res <- data.frame(
    Time = seq_along(res),
    Residual = as.numeric(res)
  )
  
  # --- 1. Residuals over Time --- #
  g1 <- ggplot2::ggplot(df_res, ggplot2::aes(x = Time, y = Residual)) +
    ggplot2::geom_line(color = "#005BBB", linewidth = 1) +
    ggplot2::geom_point(color = "black", size = 1.8) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::labs(
      title = paste("Residuals over Time:", name),
      x = "Time Index",
      y = "Residual"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", margin = ggplot2::margin(b = 20)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 15)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 15))
    )
  
  # --- 2. Histogram with Density --- #
  g2 <- ggplot2::ggplot(df_res, ggplot2::aes(x = Residual)) +
    ggplot2::geom_histogram(ggplot2::aes(y = ggplot2::after_stat(density)),
                            bins = 20, fill = "lightblue", color = "white") +
    ggplot2::geom_density(color = "red", linewidth = 1.2) +
    ggplot2::labs(
      title = paste("Residual Histogram:", name),
      x = "Residual",
      y = "Density"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", margin = ggplot2::margin(b = 20)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 15)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 15))
    )
  
  # --- 3. ACF of Residuals --- #
  acf_res <- stats::acf(res, plot = FALSE)
  acf_df <- data.frame(lag = acf_res$lag[-1], acf = acf_res$acf[-1])
  acf_df <- dplyr::mutate(acf_df, significant = ifelse(abs(acf) > conf_limit, "Yes", "No"))
  
  g3 <- ggplot2::ggplot(acf_df, ggplot2::aes(x = lag, y = acf, fill = significant)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::geom_hline(yintercept = c(0, conf_limit, -conf_limit),
                        linetype = "dashed", color = "red") +
    ggplot2::scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "lightgray")) +
    ggplot2::labs(
      title = paste("Residual ACF:", name),
      x = "Lag",
      y = "Autocorrelation"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", margin = ggplot2::margin(b = 20)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 15)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 15))
    )
  
  # Return list of diagnostic plots
  list(g1, g2, g3)
}

# -----------------------------------------------------
# 10.2 Residual Diagnostics — Best Models
# -----------------------------------------------------
best_idx <- c(7, 5, 4, 6)

residual_plots <- lapply(best_idx, function(i) {
  plot_residuals(models[[i]], model_names[i])
})

res_panel <- patchwork::wrap_plots(do.call(c, residual_plots), ncol = 3) +
  patchwork::plot_annotation(
    title = "Residual Diagnostics — 4 Best SARIMA Models",
    subtitle = "Visual comparison of standardized residuals",
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5),
      plot.title.position = "plot"
    )
  )

ggplot2::ggsave("figures/res_panel.png", res_panel, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# =====================================================

# -----------------------------------------------------
# Clean-up
# -----------------------------------------------------
rm(list = setdiff(ls(), c("working_data", "dengue_ts")))
# =====================================================

# =====================================================
# 11. Rolling Window Forecast — ARIMAX Backtesting
# =====================================================

# -----------------------------------------------------
# 11.1 Data Preparation
# -----------------------------------------------------
db <- working_data

db <- db |>
  dplyr::mutate(
    date          = week_start,
    pressure      = scale(pressure),
    temp_range    = scale(temp_range),
    radiation     = scale(radiation),
    rain_sum      = scale(rain_sum),
    wind_speed_2m = scale(wind_speed_2m),
    breteau_index = scale(breteau_index)
  ) |>
  dplyr::select(date, dengue_cases, pressure, temp_range, radiation, 
                rain_sum, wind_speed_2m, breteau_index)

# -----------------------------------------------------
# 11.2 Correlation and Multicollinearity Diagnostics
# -----------------------------------------------------
cor(db[, -1])
car::vif(stats::lm(dengue_cases ~ ., data = db[, -1]))

# -----------------------------------------------------
# 11.3 ARIMAX Rolling Window Backtesting
# -----------------------------------------------------
window_size <- 150   # Training window (~3 years of weekly data)
h           <- 25    # Forecast horizon

# Initialize results and coefficients
results <- data.frame(
  date = as.Date(character()),
  actual = double(),
  forecast = double(),
  IC_lower_forecast = double(),
  IC_upper_forecast = double(),
  stringsAsFactors = FALSE
)

coef_list <- list()

# Rolling window loop
for (i in 1:(nrow(db) - window_size - h + 1)) {
  
  # --- Define training and test indices --- #
  train_idx <- i:(i + window_size - 1)
  test_idx  <- (i + window_size):(i + window_size + h - 1)
  
  # --- Training and test data --- #
  train_y <- db$dengue_cases[train_idx]
  train_x <- db[train_idx, c("pressure", "temp_range", "radiation",
                             "rain_sum", "wind_speed_2m", "breteau_index")]
  
  test_y  <- db$dengue_cases[test_idx]
  test_x  <- db[test_idx, c("pressure", "temp_range", "radiation",
                            "rain_sum", "wind_speed_2m", "breteau_index")]
  test_dates <- db$date[test_idx]
  
  # --- ARIMAX model fit --- #
  fit <- forecast::Arima(
    train_y,
    order = c(2, 1, 2),
    seasonal = list(order = c(1, 1, 0), period = 52),
    xreg = as.matrix(train_x)
  )
  
  # --- Forecast --- #
  fc <- forecast::forecast(fit, h = h, xreg = as.matrix(test_x))
  
  # --- Store results --- #
  results <- rbind(
    results,
    data.frame(
      date = test_dates,
      actual = test_y,
      forecast = as.numeric(fc$mean),
      IC_lower_forecast = as.numeric(fc$lower[, 2]),
      IC_upper_forecast = as.numeric(fc$upper[, 2])
    )
  )
  
  # --- Store coefficients --- #
  coefs <- stats::coef(fit)[names(stats::coef(fit)) %in%
                              c("pressure", "temp_range", "radiation",
                                "rain_sum", "wind_speed_2m", "breteau_index")]
  coef_list[[i]] <- coefs
}

# -----------------------------------------------------
# 11.4 Performance Metrics
# -----------------------------------------------------
results <- results |>
  dplyr::mutate(
    error = actual - forecast,
    abs_error = abs(error),
    sq_error = error^2,
    perc_error = abs(error) / actual * 100,
    cum_abs_error = cumsum(abs_error)
  )

MAE_rolling  <- mean(results$abs_error)
RMSE_rolling <- sqrt(mean(results$sq_error))
MAPE_rolling <- mean(results$perc_error)

cat(
  "=== ARIMAX Model (Rolling Window) ===\n",
  "MAE :", round(MAE_rolling, 3), "\n",
  "RMSE:", round(RMSE_rolling, 3), "\n",
  "MAPE:", round(MAPE_rolling, 2), "%\n\n"
)

# Ljung–Box test for residual independence
Box.test(stats::residuals(fit), lag = 24, type = "Ljung-Box")

# Information criteria
AIC(fit)
BIC(fit)

# -----------------------------------------------------
# 11.5 Forecast vs Actual Plot
# -----------------------------------------------------
forec_window <- ggplot2::ggplot(results, ggplot2::aes(x = date)) +
  ggplot2::geom_line(ggplot2::aes(y = actual, color = "Observed")) +
  ggplot2::geom_line(ggplot2::aes(y = forecast, color = "Forecasted")) +
  ggplot2::labs(
    title = "ARIMAX Forecast vs Observed (Rolling Window)",
    subtitle = "Model: (2,1,2)(1,1,0)[52]",
    x = "Date",
    y = "Weekly Dengue Cases"
  ) +
  ggplot2::scale_color_manual(values = c("Observed" = "steelblue", "Forecasted" = "firebrick")) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = ggplot2::element_text(hjust = 0.5, color = "gray30")
  )

ggplot2::ggsave("figures/forecw_model5.png", forec_window, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# -----------------------------------------------------
# 11.6 Residual Diagnostics
# -----------------------------------------------------
library(patchwork)

g1 <- ggplot2::ggplot(results, ggplot2::aes(x = date, y = error)) +
  ggplot2::geom_line(color = "darkred") +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed") +
  ggplot2::labs(title = "ARIMAX Forecast Residuals", x = "Date", y = "Residual") +
  ggplot2::theme_minimal()

g2 <- ggplot2::ggplot(results, ggplot2::aes(x = error)) +
  ggplot2::geom_histogram(bins = 30, fill = "tomato", color = "black", alpha = 0.7) +
  ggplot2::labs(title = "Distribution of Forecast Errors", x = "Error", y = "Frequency") +
  ggplot2::theme_minimal()

g3 <- ggplot2::ggplot(results, ggplot2::aes(x = date, y = cum_abs_error)) +
  ggplot2::geom_line(color = "orange") +
  ggplot2::labs(
    title = "Cumulative Absolute Forecast Error (ARIMAX)",
    x = "Date",
    y = "Cumulative |Error|"
  ) +
  ggplot2::theme_minimal()

res_window <- (g1 / g2 / g3) &
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = ggplot2::element_text(hjust = 0.5)
  )

ggplot2::ggsave("figures/resw_model5.png", res_window, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# -----------------------------------------------------
# 11.7 Variable Importance (Standardized Coefficients)
# -----------------------------------------------------
coef_df <- do.call(rbind, lapply(coef_list, function(x) as.data.frame(t(x))))
coef_df$window <- 1:nrow(coef_df)

importance_df <- coef_df |>
  tidyr::pivot_longer(cols = -window, names_to = "variable", values_to = "coefficient") |>
  dplyr::group_by(variable) |>
  dplyr::summarise(importance = mean(abs(coefficient), na.rm = TRUE)) |>
  dplyr::arrange(dplyr::desc(importance))

imp_window <- ggplot2::ggplot(importance_df, ggplot2::aes(x = reorder(variable, importance), y = importance, fill = importance)) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::coord_flip() +
  ggplot2::labs(
    title = "ARIMAX Variable Importance (Standardized, Rolling Window)",
    x = "Variable",
    y = "Mean Coefficient Magnitude"
  ) +
  ggplot2::scale_fill_gradient(low = "skyblue", high = "steelblue") +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"),
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10)),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 10))
  )

ggplot2::ggsave("figures/impw_model5.png", imp_window, width = 14, height = 8, dpi = 300, limitsize = FALSE)

# -----------------------------------------------------
rm(list = setdiff(ls(), c("working_data", "dengue_ts")))