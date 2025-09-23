# Forecasting Dengue Incidence in Brazil (2024–2025) Using SARIMAX Models with Climatic and Demographic Covariates

[![R >= 4.3](https://img.shields.io/badge/R-%3E%3D%204.3-276DC3.svg?logo=r&logoColor=white)](https://www.r-project.org/)
[![Status: WIP](https://img.shields.io/badge/status-work%20in%20progress-orange.svg)](#)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

Time-series analysis and forecasting of dengue incidence in Brazil (2024–2025) through SARIMAX models with exogenous climatic and demographic covariates.

This repository contains the codes, data, and preliminary outputs associated with the research project **"Forecasting Dengue Incidence in Brazil (2024–2025) Using SARIMAX Models with Climatic and Demographic Covariates"**. The study develops and evaluates statistical models for the short-term forecasting of probable dengue cases reported across Brazilian municipalities, using seasonal autoregressive integrated moving average models with exogenous variables (SARIMAX).

## 📂 Repository Structure (current)

```
dengue-project/
├── codes/
│   ├── codes.Rproj
│   ├── fetch_power_west_sp.R        # Script to download daily climate data (NASA POWER API)
│   └── transform_dengue_west_sp.R   # Script to transform weekly dengue data (bronze → silver)
│
├── data/
│   ├── bronze/                      # Raw/bronze-level data
│   │   ├── climate_west_sp_daily.parquet     # Daily climate data (MERRA-2, 2024–2025)
│   │   ├── dengue_weekly_west_sp.xlsx        # Weekly dengue cases (Arboviral Panel, 2025)
│   │   └── municipal_data_west_sp.xlsx       # IBGE codes + coordinates (West São Paulo)
│   │
│   └── silver/                      # Silver-level (cleaned/processed) data
│       └── dengue_weekly_west_sp.parquet     # Cleaned weekly dengue data (Arboviral Panel, 2025)
│
├── figures/                         # Exploratory plots, diagnostics, forecasts
│
├── .gitignore
└── README.md
```

## 📊 Project Overview

- **Objective:** Forecast the number of probable dengue cases in Brazil during 2024–2025, integrating epidemiological, meteorological, and sociodemographic data.
- **Methodology:** Time-series forecasting using SARIMAX models with exogenous covariates (climate and demographics).

- **Focus:**
  - Weekly temporal dynamics (seasonality, trends, structural breaks)
  - Role of climate and demographic variables in shaping dengue incidence
  - Comparison of SARIMAX with simpler univariate baselines (ARIMA/SARIMA)

## 🛠️ How to Reproduce

1. Clone this repository:
   ```bash
   git clone https://github.com/ryanxnovaes/dengue-project.git
   ```

2. Open the `codes.Rproj` file in **RStudio**.

3. Run the scripts in the following order:
   - `source("codes/fetch_power_west_sp.R")` (Climate data fetcher)

## 📄 Data Description



### Main Variables

| Variable             | Source | Description                                                 |
| -------------------- | ------ | ----------------------------------------------------------- |
| PRECTOTCORR          | NASA   | Daily precipitation (corrected, mm/day)                     |
| T2M                  | NASA   | Mean air temperature at 2 meters (°C)                       |
| T2M\_MAX             | NASA   | Maximum air temperature at 2 meters (°C)                    |
| T2M\_MIN             | NASA   | Minimum air temperature at 2 meters (°C)                    |
| RH2M                 | NASA   | Relative humidity at 2 meters (%)                           |
| WS2M                 | NASA   | Wind speed at 2 meters (m/s)                                |
| WS2M\_MAX            | NASA   | Maximum wind speed at 2 meters (m/s)                        |
| WS2M\_MIN            | NASA   | Minimum wind speed at 2 meters (m/s)                        |
| WS10M                | NASA   | Wind speed at 10 meters (m/s)                               |
| WD2M                 | NASA   | Wind direction at 2 meters (degrees)                        |
| PS                   | NASA   | Surface pressure (kPa)                                      |
| QV2M                 | NASA   | Specific humidity at 2 meters (g/kg)                        |
| T2MDEW               | NASA   | Dew point temperature at 2 meters (°C)                      |
| T2MWET               | NASA   | Wet-bulb temperature at 2 meters (°C)                       |
| ALLSKY\_SFC\_SW\_DWN | NASA   | All-sky surface shortwave downward irradiance (kW·h/m²/day) |
| GWETTOP              | NASA   | Soil moisture in the top layer (fraction, 0–1)              |
| DENGUE_CASES	        | Arboviroses Panel   | Probable dengue cases (weekly count)           |


## 📬 Contact

For questions, suggestions, or collaboration proposals, please contact:

**Ryan Novaes Pereira**  
📧 Email: [ryan.novaes@unesp.br](mailto:ryan.novaes@unesp.br)

**Nicolle Rye Fukushima dos Santos**  
📧 Email: [ryan.novaes@unesp.br](mailto:nicolle.rye@unesp.br)

---