# Forecasting Dengue Incidence in Presidente Prudente (2022–2025) Using SARIMAX Models with Climatic and Demographic Covariates

[![R >= 4.3](https://img.shields.io/badge/R-%3E%3D%204.3-276DC3.svg?logo=r&logoColor=white)](https://www.r-project.org/)
[![Status: Completed](https://img.shields.io/badge/status-completed-brightgreen.svg)](#)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

Time-series modeling and forecasting of dengue incidence in the municipality of **Presidente Prudente (SP, Brazil)** (2022–2025) using SARIMAX models with exogenous climatic and demographic covariates, integrated into a **machine-learning rolling-window framework** for dynamic model calibration and predictive monitoring.

This repository contains the complete set of codes, datasets, and outputs associated with the research project **"Forecasting Dengue Incidence in Presidente Prudente (SP) (2022–2025) Using SARIMAX Models with Climatic and Demographic Covariates"**.  
The study develops and evaluates statistical–machine learning models for short-term forecasting of probable dengue cases in **Presidente Prudente**, combining **Seasonal Autoregressive Integrated Moving Average models with Exogenous Variables (SARIMAX)** and **sliding-window cross-validation** to ensure temporal robustness and adaptability.

## 📂 Repository Structure (current)

```
dengue-project/
├── codes/
│   ├── codes.Rproj
│   ├── fetch_nasa_daily.R           # Download daily climate data for Presidente Prudente (NASA POWER API)
│   ├── transform_climate_weekly.R   # Transform daily → weekly climate data (bronze → silver)
│   ├── transform_dengue_weekly.R    # Clean and structure dengue data from DATASUS (bronze → silver)
│   ├── prepare_model_data.R         # Join dengue + climate datasets into a unified modeling base (silver → gold)
│   └── time_series_modeling.R       # Model weekly dengue cases with SARIMAX using rolling-window ML approach
│
├── data/
│   ├── bronze/                      # Raw data directly from external sources
│   │   ├── climate_prudente_daily.parquet     # Daily climate data (NASA POWER, 2022–2025)
│   │   └── dengue_prudente_weekly.xlsx        # Weekly dengue data (DATASUS – SINAN/TABNET, 2022–2025)
│   │
│   ├── silver/                      # Processed and temporally aggregated datasets
│   │   ├── climate_prudente_weekly.parquet    # Weekly aggregated climate data (transformed and cleaned)
│   │   └── dengue_prudente_weekly.parquet     # Cleaned weekly dengue data (DATASUS – SINAN/TABNET)
│   │
│   └── gold/                        # Final integrated dataset for modeling
│       └── working_data.parquet
││
├── figures/                         # Exploratory plots, diagnostics, and forecast visualizations
│
├── .gitignore
└── README.md
```

## 📊 Project Overview

- **Objective:** Forecast the weekly number of probable dengue cases in the municipality of **Presidente Prudente (SP, Brazil)** during **2022–2025**, integrating epidemiological, climatic, and demographic data into a unified modeling framework.

- **Methodology:** Time-series forecasting based on **Seasonal Autoregressive Integrated Moving Average with Exogenous Variables (SARIMAX)** models, implemented under a **machine-learning rolling-window scheme** to capture non-stationary temporal patterns and dynamically update model parameters.

- **Focus:**
  - Characterization of weekly temporal dynamics (seasonality, trend components, structural shifts)
  - Assessment of climatic and demographic drivers of dengue incidence
  - Comparative performance of SARIMAX models against univariate baselines (ARIMA/SARIMA)
  - Implementation of a sliding-window learning strategy for adaptive forecasting and epidemiological surveillance

## 🛠️ How to Reproduce

1. Clone this repository:
   ```bash
   git clone https://github.com/ryanxnovaes/dengue-project.git
   ```

2. Open the `codes.Rproj` file in **RStudio**.

3. Run the full ETL and modeling pipeline in sequential order:
   - `source("codes/fetch_nasa_daily.R")` (Climate data fetcher)
   - `source("codes/transform_climate_weekly.R")` (Weekly climate transformer)
   - `source("codes/transform_dengue_weekly.R")` (Dengue data cleaner)
   - `source("codes/prepare_model_data.R")` (Dataset integrator)
   - `source("codes/time_series_modeling.R")` (SARIMAX model runner)

 **Note:** Results are automatically saved in `/figures/` (plots, diagnostics).

## 📄 Data Description

**Data Sources**

- **Epidemiological data:** [DATASUS – SINAN/TABNET (Dengue – Brasil)](http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sinannet/cnv/denguebbr.def)  
  Weekly confirmed and probable dengue cases by municipality, extracted from the national disease notification system (SINAN/TABNET).

- **Climatic data:** [NASA POWER – Data Access Viewer](https://power.larc.nasa.gov/data-access-viewer/)  
  Daily meteorological variables (precipitation, temperature, humidity, radiation, wind, pressure) obtained via NASA’s Prediction Of Worldwide Energy Resources API.

### Main Variables (Raw Level – Bronze)

| Variable             | Source              | Description                                                 |
| -------------------- | ------------------- | ----------------------------------------------------------- |
| PRECTOTCORR          | NASA POWER          | Daily precipitation (corrected, mm/day)                     |
| T2M                  | NASA POWER          | Mean air temperature at 2 meters (°C)                       |
| T2M_MAX              | NASA POWER          | Maximum air temperature at 2 meters (°C)                    |
| T2M_MIN              | NASA POWER          | Minimum air temperature at 2 meters (°C)                    |
| RH2M                 | NASA POWER          | Relative humidity at 2 meters (%)                           |
| WS2M                 | NASA POWER          | Wind speed at 2 meters (m/s)                                |
| WS2M_MAX             | NASA POWER          | Maximum wind speed at 2 meters (m/s)                        |
| WS2M_MIN             | NASA POWER          | Minimum wind speed at 2 meters (m/s)                        |
| WS10M                | NASA POWER          | Wind speed at 10 meters (m/s)                               |
| WD2M                 | NASA POWER          | Wind direction at 2 meters (degrees)                        |
| PS                   | NASA POWER          | Surface pressure (kPa)                                      |
| QV2M                 | NASA POWER          | Specific humidity at 2 meters (g/kg)                        |
| T2MDEW               | NASA POWER          | Dew point temperature at 2 meters (°C)                      |
| T2MWET               | NASA POWER          | Wet-bulb temperature at 2 meters (°C)                       |
| ALLSKY_SFC_SW_DWN    | NASA POWER          | All-sky surface shortwave downward irradiance (kW·h/m²/day) |
| GWETTOP              | NASA POWER          | Soil moisture in the top layer (fraction, 0–1)              |
| DENGUE_CASES         | DATASUS – SINAN/TABNET | Probable dengue cases (weekly count, municipality level)  |

### Derived Weekly Variables (Processed → Modeling Level – Silver → Gold)

| Variable           | Source          | Description |
| ------------------ | --------------- | ------------ |
| rain_sum           | Derived (NASA POWER) | Total weekly precipitation (mm) |
| temp               | Derived (NASA POWER) | Mean weekly air temperature at 2 m (°C) |
| temp_abs_max       | Derived (NASA POWER) | Maximum air temperature recorded during the week (°C) |
| temp_abs_min       | Derived (NASA POWER) | Minimum air temperature recorded during the week (°C) |
| temp_range         | Derived (NASA POWER) | Weekly temperature range (max – min, °C) |
| rh                 | Derived (NASA POWER) | Mean relative humidity at 2 m (%) |
| sh                 | Derived (NASA POWER) | Mean specific humidity at 2 m (kg/kg) |
| wind_speed_2m      | Derived (NASA POWER) | Mean wind speed at 2 m (m/s) |
| wind_speed_2m_max  | Derived (NASA POWER) | Maximum wind speed at 2 m (m/s) |
| wind_speed_2m_min  | Derived (NASA POWER) | Minimum wind speed at 2 m (m/s) |
| wind_speed_10m     | Derived (NASA POWER) | Mean wind speed at 10 m (m/s) |
| wind_dir           | Derived (NASA POWER) | Mean wind direction (°, vector-averaged from 2 m wind components) |
| pressure           | Derived (NASA POWER) | Mean surface pressure (kPa) |
| dew_point          | Derived (NASA POWER) | Mean dew-point temperature at 2 m (°C) |
| wet_bulb           | Derived (NASA POWER) | Mean wet-bulb temperature at 2 m (°C) |
| radiation          | Derived (NASA POWER) | Mean downward solar radiation (kW·h/m²/day) |
| soil_moisture      | Derived (NASA POWER) | Mean volumetric soil moisture in top layer (0–1 fraction) |
| season             | Derived (Calendar week) | Meteorological season inferred from MMWR week (Summer, Autumn, Winter, Spring) |
| premises_index     | Derived (Municipal entomological data) | Percentage of premises with *Aedes aegypti* larvae (%) |
| breteau_index      | Derived (Municipal entomological data) | Number of positive containers per 100 inspected premises |

## 📈 Modeling Overview

The modeling framework integrates **seasonal time-series decomposition** with **machine-learning–based dynamic forecasting**, implemented through a **SARIMAX (Seasonal Autoregressive Integrated Moving Average with Exogenous Variables)** approach.  
The goal is to capture both the **temporal dependency structure** of dengue incidence and the **influence of climatic and entomological covariates** over time.

### Methodological Workflow

1. **Preprocessing and Integration**  
   Weekly climate, entomological, and epidemiological datasets were merged into a unified temporal database (`working_data.parquet`) at the **Gold level**.  
   All variables were standardized and aligned to epidemiological weeks (MMWR format).

2. **Model Specification**  
   The SARIMAX model extends the traditional ARIMA framework by incorporating **exogenous predictors (X)** such as temperature, precipitation, humidity, and entomological indices.  

3. **Rolling-Window Forecasting (Machine-Learning Scheme)**  
   To ensure temporal adaptability, the model was trained using a **sliding-window learning strategy**,  
   where each iteration re-estimates parameters using the most recent observations (e.g., 150-week window).
   This approach mitigates non-stationarity and allows real-time calibration of SARIMAX coefficients as new data become available.
   
4. **Model Evaluation**  
   Predictive performance was assessed using the following metrics:
   - **RMSE (Root Mean Squared Error)**
   - **MAE (Mean Absolute Error)**
   - **MAPE (Mean Absolute Percentage Error)**
   - **SMAPE (Symmetric MAPE)**  
   Additionally, diagnostic plots (ACF/PACF, residual analysis, Ljung–Box test) were used to verify adequacy and temporal independence of residuals.

## 📊 Results & Discussion

The analysis revealed that dengue incidence in **Presidente Prudente (SP)** exhibits strong short-term temporal dependence, a clear **annual seasonal cycle**, and weak stationarity in mean and variance.  
After evaluating multiple SARIMAX specifications under a 150-week rolling-window and a 25-week forecasting horizon, the model with the best overall performance was:

Best model: `Arima(order = c(2, 1, 2), seasonal = list(order = c(1, 1, 0), period = 52), xreg = covariates)`

### 🧮 Model Performance
| Metric | Value |
|:-------|------:|
| MAE  | **≈ 517** |
| RMSE | **≈ 729** |
| MAPE | **≈ 61%** |
| Ljung–Box (p > 0.05) | Residuals consistent with white noise |

These results indicate that the model adequately captured both the **seasonal and autoregressive structure** of the time series, yielding statistically coherent and epidemiologically meaningful forecasts.

### 🌡️ Most Influential Exogenous Variables
| Variable | Interpretation |
|-----------|----------------|
| **Breteau Index** | Strongest predictor; reflects vector density and local transmission potential. |
| **Atmospheric Pressure** | Associated with convective stability and rainfall patterns. |
| **Solar Radiation** | Positively correlated with vector reproduction dynamics. |
| **Temperature Range** | Indicates thermal amplitude influencing mosquito survival. |
| **Total Rainfall** | Drives creation and persistence of breeding sites. |

All variables were standardized (z-score) prior to modeling to ensure comparability and numerical stability.

Together, these covariates explain most of the **inter-weekly variability** in dengue incidence.

### 🧭 Epidemiological Interpretation
Climatic conditions act as **exogenous forcing factors** of the epidemic system, while the **vector density** maintains its endogenous inertia.  
The estimated **lag between environmental variation and new dengue cases (≈ 3 – 6 weeks)** defines an operational prediction horizon, allowing preventive actions **before the seasonal peak (weeks 5–15)**.

Overall, the SARIMAX (2, 1, 2)(1, 1, 0)[52] configuration demonstrated strong predictive capacity and statistical consistency, confirming its suitability as an **early-warning and decision-support tool** for dengue surveillance in Presidente Prudente.

## 📜 Citation
If you use this repository, please cite:

Novaes Pereira, R., & Fukushima dos Santos, N. R. (2025).  
*Forecasting Dengue Incidence in Presidente Prudente (SP, Brazil) Using SARIMAX Models with Climatic and Demographic Covariates.*  
Available at: [https://github.com/ryanxnovaes/dengue-project](https://github.com/ryanxnovaes/dengue-project)

## 📬 Contact

For questions, suggestions, or collaboration proposals, please contact:

**Ryan Novaes Pereira**  
📧 Email: [ryan.novaes@unesp.br](mailto:ryan.novaes@unesp.br)

**Nicolle Rye Fukushima dos Santos**  
📧 Email: [nicolle.rye@unesp.br](mailto:nicolle.rye@unesp.br)

---