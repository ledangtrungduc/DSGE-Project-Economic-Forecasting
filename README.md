# Macroeconometric Forecasting with Time Series and DSGE Models

**Author:** Le Dang Trung Duc

## Overview
This repository contains the code and report for an advanced macroeconometric forecasting project. The study evaluates and compares the forecasting performance of various time series models (ARMA, ARIMA, ARFIMA, VECM) against a structural New Keynesian Dynamic Stochastic General Equilibrium (NK-DSGE) model. The project focuses on predicting key U.S. macroeconomic indicators, analyzing both short-term (one-step ahead) and long-term (multi-step) forecasting horizons.

## Data Description
The empirical analysis uses U.S. macroeconomic data, split into an **in-sample** estimation period (1971Q3 to 2021Q3) and an **out-of-sample** evaluation period (2021Q4 to 2024Q1). 

The core variables analyzed include:
- **Real Gross Domestic Product (GDP):** Log-transformed.
- **Real Consumption Expenditure:** Log-transformed.
- **Inflation Rate:** Derived from the Consumer Price Index for All Urban Consumers.
- **Interest Rate:** Effective Federal Funds Rate.

## Methodology
The project employs a dual approach, contrasting data-driven time series models with a theory-driven structural model:

1. **Univariate & Multivariate Time Series Modeling (Stata)**
   - **ARMA/ARIMA:** Employed information criteria (AIC/BIC) to identify optimal lag structures. Identified that U.S. Real GDP closely follows a random walk with drift (ARIMA 0,1,0).
   - **ARFIMA:** Utilized fractional differencing to capture long-memory properties in the macroeconomic series.
   - **VECM (Vector Error Correction Model):** Conducted Johansen cointegration tests to identify long-run equilibrium relationships among the non-stationary variables (I(1)) before estimating the VECM.

2. **DSGE Modeling and Bayesian Estimation (MATLAB/Dynare)**
   - **Data Transformation:** Applied a one-sided HP-filter to isolate the cyclical components of real GDP and consumption, and de-meaned inflation and interest rates to prepare the data for the log-linearized DSGE model.
   - **Estimation:** Estimated the structural parameters of the NK-DSGE model using Bayesian Maximum Likelihood (BML) via Markov Chain Monte Carlo (MCMC) methods. Priors were carefully calibrated based on standard macroeconomic literature.

## Repository Structure
- `TakeHomeProject_21523002.pdf`: The comprehensive final report detailing data visualization, model selection criteria (AIC/HQIC/SBIC), regression outputs, and forecasting evaluations.
- `TakeHomeProject_STATA_21523002.do`: Stata script containing all univariate and multivariate time series estimations (ARMA, ARFIMA, ARIMA, VECM), unit root tests (ADF, DF-GLS), and forecasting commands.
- `transform_data_DSGE_21523002.m`: MATLAB script for initial data housekeeping, applying the one-sided HP-filter, and saving the transformed variables for Dynare estimation.
- `TakeHomeProject_MATLAB_21523002.m`: The master MATLAB script that initializes the data transformation and executes the Dynare `.mod` file.
- `TakeHomeProject_DYNARE_21523002.mod`: The Dynare code containing the log-linearized model equations, declared priors, and Bayesian estimation commands.

## Key Findings
- **Time Series Performance:** The ARIMA(0,1,0) model (random walk with drift) outperformed other models, including the DSGE model, in both one-step and multi-step forecasting for U.S. Real GDP based on Root Mean Square Error (RMSE) evaluations.
- **DSGE Limitations:** While the estimated DSGE model provides excellent structural narratives and mean-reverting properties, it faces limitations in capturing short-term, non-stationary fluctuations (like the persistent upward trend in GDP) compared to purely data-driven models.

## Software Requirements
- **Stata:** For time series analysis (`.do` file).
- **MATLAB:** For data transformation and executing Dynare.
- **Dynare:** For DSGE Bayesian estimation.
