


cls           // clear display in results window
clear         // clear previous work out of memory 
cd D:\VGU\GFE\DSGE\Project
         // change working directory
log using LogFileprojectModels, replace  
         // create log file
		 
 * Load Data 
 import excel using "data_project_atmf24", first
* U.S. Time Series for Core Financial and Macroeconomic Variables 
* from 1970:Q1 to 2024:Q1 from St. Louis Fed Database ("Fred"):
* r: Effective Federal Funds Rate (Percent)
* pi: Annualized Rate of Inflation Based on Gross Domestic Product Implicit 
*     Price Deflator
* ygap: Percentage Difference Between 
*       Logarithm of Real Potential Gross Domestic Product and
*       Logarithm of Real Gross Domestic Product 

* Declare to be Time-Series Data
generate obsindex = _n
tsset obsindex, quarterly
generate time = q(1970q1)+obsindex-1  
           // Setting the First Observation to Correspond to 1970:Q1
label variable time " "
tsset time, quarterly
drop obsindex
edit

* In the Following:
* Observations Set Aside for Model Initialization etc.: 
* 1970:Q1 to 1970:Q4
* Observations for In-Sample Estimation: 
* 1971:Q1 to 2021:Q4
* Observations for Out-Of-Sample (Pseudo) Forecasting: 
* 2022:Q1 to 2024:Q1
global insample tin(1971q3,2021q3)
global outsample tin(2021q4,2024q1)

summarize if $insample
summarize if $outsample



*Question 1: graph all the series



* Line Graph Federal Funds Rate:			 
			 * Line Graph US Interest Rate - Federal Funds Rate
tsline r if $insample ,                                                     ///
       title("U.S Interest Rate - In Sample")                             ///
	   name(liner, replace)
graph export USInterestRate.pdf, replace logo(off)         ///
             orientation(portrait) 

tsline r if $outsample ,                                                    ///
       title("U.S Interest Rate - Out Sample")                             ///
	   name(liner, replace)
graph export USInterestRate1.pdf, replace logo(off)         ///
             orientation(portrait) 			 
			 
* Line Graph US Real GDP in logarithm
tsline ly if $insample ,                                                      ///
       title("U.S Real GDP in Logarithm - In Sample")                             ///
	   name(liner, replace)
graph export USRealGDPinLogarithm.pdf, replace logo(off)         ///
             orientation(portrait) 	

tsline ly if $outsample ,                                                      ///
       title("U.S Real GDP in Logarithm - Out Sample")                             ///
	   name(liner, replace)
graph export USRealGDPinLogarithm1.pdf, replace logo(off)         ///
             orientation(portrait) 			 
			 
* Line Graph US Real Consumption Expenditure in logarithm
tsline lc if $insample ,                                                      ///
       title("U.S Real Consumption Expenditure in Logarithm - In Sample") ///
	   name(liner, replace)
graph export USRealConsumptionExpenditure.pdf, replace logo(off)         ///
             orientation(portrait) 			

tsline lc if $outsample ,                                                      ///
       title("U.S Real Consumption Expenditure in Logarithm - Out sample") ///
	   name(liner, replace)
graph export USRealConsumptionExpenditure1.pdf, replace logo(off)         ///
             orientation(portrait)

* Line Graph US Rate of Inflation based on GDP deflator
tsline pi if $insample ,                                                      ///
       title("U.S Rate of Inflation - In Sample")                             ///
	   name(liner, replace)
graph export USRateInflation.pdf, replace logo(off)         ///
             orientation(portrait) 

tsline pi if $outsample ,                                                      ///
       title("U.S Rate of Inflation - Out Sample")                             ///
	   name(liner, replace)
graph export USRateInflation.pdf1, replace logo(off)         ///
             orientation(portrait)
			 
			 
			 
			 
			 
*Question 2: 
//Criterion to select an optimal in-sample period ARMA(p,q) model for GDP. 
arimasoc ly if $insample, maxar(2) maxma(2)
arima ly if $insample, arima(1,0,2)

* In-Sample Actual vs. In-Sample Predicted Values for ARMA(1,2) (vẽ)
predict lyhat if $insample, xb
* Line Graph
label variable ly "Actual"
label variable lyhat "Predicted, ARMA(1,2)"
tsline ly lyhat if $insample,                                    ///
       title(Actual vs. In-Sample Predicted Values)            ///
       subtitle(GDP)                            ///
	   name(InSampleFit, replace)
arima ly if $insample, arima(1,0,2)	 

* Forcasting for ARMA(1,2) Model
quietly arima ly if $insample, arima(1,0,2)
predict ly1, t0(tq(1971q3)) 
label variable ly1 "One-Step, ARMA(1,2)"
predict ly2, dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly2 "Multi-Step, ARMA(1,2)"
label variable ly "Real GDP"
summarize 
tsline ly ly1 ly2                                             ///
       if $outsample, title("Actual vs. One-Step Forecasted Values")      ///
       subtitle("U.S real GDP")                                     ///
       name(ComparisonForecastOneStep, replace)
*forcast long-period ahead
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quietly arima ly if $insample, arima(1,0,2)
predict ly3, dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly3 "Multi-Step, ARIMA(1,0,2)"	
tsline ly3 if $newoutsample,                                 ///                 
       title(Multi-Step Long-run ahead)                              ///            
       subtitle(Federal Funds Rate)                                     ///
	   name(ComparisonForecastOneStep, replace)
* Root Mean-Square Forecast Errors
predict ly1e, residuals t0(tq(1971q3))
generate rmsearma = sqrt(ly1e^2) if $outsample
/*alternative ARMA(3,0):


arimasoc ly if $insample, maxar(3) maxma(3)
arima ly if $insample, arima(3,0,0)
* In-Sample Actual vs. In-Sample Predicted Values for ARMA(3,0) (vẽ)
predict lyhat4 if $insample, xb
*Line Graph
label variable ly "Actual"
label variable lyhat4 "Predicted, ARMA(3,0)"
tsline ly lyhat4 if $insample,                                    ///
       title(Actual vs. In-Sample Predicted Values)            ///
       subtitle(U.S real GDP)                            ///
	   name(InSampleFit, replace)


* Forcasting for ARMA(3,0) Model
quietly arima ly if $insample, arima(3,0,0)
predict ly11, t0(tq(1971q3)) 
label variable ly11 "One-Step, ARMA(3,0)"
predict ly12, dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly12 "Multi-Step, ARMA(3,0)"
label variable ly "Real GDP"
summarize 
tsline ly ly11 ly12                                             ///
       if $outsample, title("Actual vs. One-Step Forecasted Values")      ///
       subtitle("U.S real GDP")                                     ///
       name(ComparisonForecastOneStep, replace)
*forcast long-period ahead
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quietly arima ly if $insample, arima(3,0,0)
predict ly13, dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly13 "Multi-Step, ARIMA(3,0,0)"	
tsline ly13 if $newoutsample,                                 ///                 
       title(Multi-Step Forecasted Values)                              ///            
       subtitle(U.S Real GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)

*/


*Question 3:
* Display Estimation Results for ARFIMA(0,3) Model
arfimasoc ly if $insample , maxar(3) maxma(3)

arfima ly, ma(1/3) 
*predict on-sample by ARFIMA
*Selecting ARFIMA(p,d,q) Model
* Forecasting for ARFIMA(0,0,3) Model
predict arfimaf1, xb 
label variable arfimaf1 "One-Step, ARFIMA(0,3)"
predict arfimaf2, xb dynamic(tq(2021q4)) 
label variable arfimaf2 "Multi-Step, ARFIMA(0,3)"
label variable ly "Actual"
* Root Mean-Square Forecast Errors
predict arfimaf1e, residuals 
generate rmsearfima = sqrt(arfimaf1e^2) if $outsample

*Forecast Comparisons: Plots of Forecasts
tsline ly arfimaf1 if $outsample,                                   ///             
       title("Actual vs. One-Step Forecasted Values")             ///
       subtitle("US Real GDP in logarithm")                             ///
       name(ComparisonForecastOneStep, replace)
graph export LogUSRealGDPOneStepForecast_ARFIMA.pdf,      ///
      replace logo(off) orientation(portrait) 	
tsline ly arfimaf2 if $outsample,                                   ///
       title("Actual vs. Multi-Step Forecasted Values")           ///
       subtitle("US Real GDP in logarithm")                             ///
       name(ComparisonForecastMultiStep, replace)
tsline ly arfimaf1 arfimaf2 if $outsample,                                   ///
       title("Actual vs. Multi-Step/One-Step Forecasted Values")           ///
       subtitle("US Real GDP in logarithm")                             ///
       name(ComparisonForecastMultiStep, replace)
graph export LogUSRealGDPMultiStepForecast_ARFIMA.pdf,    ///           
      replace logo(off) orientation(portrait) 	
* Forecasting for Extended Out-of-Sample Period
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quietly arfima ly if $insample, ma(1/3)
predict ly4, dynamic(tq(2021q4)) 
label variable ly4 "Multi-Step, ARFIMA(0,3)"	
* Forecast Results
tsline ly4 if $newoutsample,                                 ///                 
       title(Multi-Step Long-run Forecasted Values)                              ///            
       subtitle(Log U.S Real GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)
graph export LogUSRealGDPActualMultiStepForecast_ARIMA_e.pdf,   ///
      replace logo(off) orientation(portrait)
predict arfimaf1e, residuals 
generate rmsearfima = sqrt(arfimaf1e^2) if $outsample




*Question 4:
*select an optimal in-sample period ARIMA(p,1,q) model for GDP
arimasoc d.ly if $insample, maxar(3) maxma(3)
arima ly if $insample, arima(0,1,0)
predict ly5, y t0(tq(1971q3))   // level forecasts

label variable ly5 "One-Step, ARIMA(0,1,0)"
predict ly6, y dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly6 "Multi-Step, ARIMA(0,1,0)"
label variable ly "Actual"
tsline ly5 ly6 ly if $outsample,                                      ///
       title("Actual vs. One- and Multi-Step Forecasted Values")     ///
       subtitle("Federal Funds Rate")                                ///
       name(Forecast, replace)
global lastobs tin(2021Q3,2021Q3)
summarize ly if $lastobs
* Root Mean-Square Forecast Errors
predict ly5e, yresiduals t0(tq(1971q3))
generate rmsearima = sqrt(ly5e^2) if $outsample

* Forecasting for Extended Out-of-Sample Period
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quietly arima ly if $insample, arima(0,1,0)
predict ly7, y dynamic(tq(2021q4)) t0(tq(1971q3))
label variable ly7 "Multi-Step, ARIMA(0,1,0)"	
* Forecast Results
tsline ly7 if $newoutsample,                                 ///                 
       title(Multi-Step Forecasted Values)                              ///            
       subtitle(U.S Real GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)

	   
	   
	   
* Question 5: 

*test lag var
varsoc ly lc r pi if $insample, maxlag(4)
* Lag Length Selection 
varsoc r if $insample, maxlag(6)
* Augmented Dickey Fuller
dfuller r if $insample, lags(5) regress
* Dickey-Fuller GLS
dfgls r if $insample, maxlag(6) notrend
* 2) pi
* Lag Length Selection
varsoc pi if $insample, maxlag(6)  
* Augmented Dickey Fuller
dfuller pi if $insample, lags(5) regress
* Dickey-Fuller GLS
dfgls pi if $insample, maxlag(6) notrend
* 3) ly
* Lag Length Selection 
varsoc ly if $insample, maxlag(6) 
* Augmented Dickey Fuller
dfuller ly if $insample, lags(0) regress
* Dickey-Fuller GLS
dfgls ly if $insample, maxlag(6) notrend
*4) lc
* Lag Length Selection 
varsoc lc if $insample, maxlag(6) 
* Augmented Dickey Fuller
dfuller lc if $insample, lags(0) regress
* Dickey-Fuller GLS
dfgls lc if $insample, maxlag(5) notrend
*VEC:

vecrank r pi ly lc if $insample, trend(rconstant) lags(4) levela 
vec ly lc pi r if $insample, trend(rconstant) lags(3) rank(2) 
*forcast:
predict ly15, level equation(D_ly) 
label variable ly15 "One-Step, VEC(3)"
fcast compute f7, step(21) 
rename f7ly ly17
label variable ly17 "Multi-Step, VEC(3)"
label variable ly "Actual"
tsline ly ly15 ly17 if $outsample,                                           ///   
       title("Actual vs. One- and Multi-Step Forecasted Values")          ///
       subtitle("U.S GDP ")                                     ///
       name(Forecast, replace) 
* Root Mean-Square Forecast Errors
generate ly15e = ly - ly15 if $outsample
generate rmsevec = sqrt(ly15e^2) if $outsample

*forcast long-run ahead:
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quietly vec r pi ly lc if $insample, trend(rconstant) lags(3) rank(2)
fcast compute f15, step(120) 
rename f15ly ly18
label variable ly18 "Multi-Step, VEC(3)"	
tsline ly18 if $newoutsample,                                 ///                 
       title(Multi-Step Forecasted Values)                              ///            
       subtitle(US GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)

	   
	   
	   
*question 6:

constraint 1 _b[beta] = 0.99 
constraint 2 _b[theta] = 0.0500 
constraint 3 _b[rho_r] = 0.8131 
constraint 4 _b[phipi] = 2.2843 
constraint 5 _b[phiy] = 0.2184  
constraint 6 _b[rho_z] = 0.9761 
constraint 7 _b[rho_u] = 0.9299 
constraint 8 _b[rho_m] = 0.0504 
constraint 9 _b[rho_g] = 0.9405 
constraint 10 _b[sc] = 0.8476
constraint 11 _b[sg] = 0.1145
dsge (ly = {sc}*lc + {sg}*g)                                              ///
     (lc = E(F.lc) - (r - E(F.pi)) + z)                                   ///
     (pi = {beta}*E(F.pi) + (1-{theta})*(1-{theta}*{beta})/{theta}*ly + u)                ///
     (r = {rho_r}*lr + {phipi}*E(F.pi) + {phiy}*ly + m)      ///
     (F.lr = r, state noshock)                                          ///
     (F.z = {rho_z}*z, state)                                           ///
     (F.u = {rho_u}*u, state)                                           ///
     (F.m = {rho_m}*m, state)                                           ///
	 (F.g = {rho_g}*g, state)                                           ///
     if $insample, constraints(1/11) iterate(25)                        
estimates store nkdsgeest

* DSGE ModelForecasts
forecast create nkdsgemodel, replace
forecast estimates nkdsgeest
forecast solve, prefix(f1_) begin(tq(2021q4)) static
rename f1_ly dsgef1
label variable dsgef1 "One-Step, NKDSGE"
forecast solve, prefix(f2_) begin(tq(2021q4))
rename f2_ly dsgef2
label variable dsgef2 "Multi-Step, NKDSGE"
label variable ly "Actual Values"
tsline ly dsgef1 dsgef2 if $outsample,                                         ///
       title(Actual vs. One- and Multi-Step Forecasted Values)          ///
       subtitle((U.S GDP))                              ///
       name(Forecast1, replace)
* Forcast long-run ahead:
tsappend, add(317)
edit
global newoutsample tin(2021q4,2049q4)	
quiet forecast create nkdsgemodel, replace
quiet forecast estimates nkdsgeest
forecast solve, prefix(f10n_) begin(tq(2021q4))
rename f10n_ly lyf10n
label variable lyf10n "Multi-Step, DSGE"	
* Forecast Results
tsline lyf10n if $newoutsample,                                 ///                 
       title(Multi-Step Long-run Forecasted Values)                              ///            
       subtitle(U.S Real GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)

	   
*extend to 2100:	   
global newoutsample tin(2021q4,2100q1)	
tsline lyf10n if $newoutsample,                                 ///                 
       title(Multi-Step Long-run Forecasted Values)                              ///            
       subtitle(U.S Real GDP)                                     ///
	   name(ComparisonForecastOneStep, replace)
	   
	   
* Root Mean-Square Forecast Errors
generate yf1e = ly-dsgef1 if $outsample
generate rmsedsge = sqrt(yf1e^2) if $outsample


*Question 7:

* Comparison Forecasts

* Plots of Comparison Forecasts   
* Plots of Comparison Forecasts   
tsline ly ly1 arfimaf1 ly5 ly15 dsgef1                                      ///
       if $outsample, title("Actual vs. One-Step Forecasted Values")       ///
       subtitle("Log US Real GDP")                                      ///
       name(ComparisonForecastOneStep, replace)
graph export                                                               ///
      USRealGDPActualOneStepForecast_AR_ARMA_ARIMA_VAR_VEC_DSGE.pdf,    ///
      replace logo(off) orientation(portrait)
tsline ly ly2 arfimaf2 ly6 ly17 dsgef2                                        ///
       if $outsample, title("Actual vs. Multi-Step Forecasted Values")     ///
       subtitle("Log US Real GDP")                                      ///
       name(ComparisonForecastMultiStep, replace) 
graph export                                                               ///
      LogUSRealGDPActualMultiStepForecast_AR_ARMA_ARIMA_VAR_VEC_DSGE.pdf,  ///
      replace logo(off) orientation(portrait)
* Listing of Root Mean-Square Forecast Errors
summarize rmsearma rmsearfima rmsearima rmsevec rmsedsge
* Plots of Comparison Forecasts  for long-run ahead
tsline ly4 ly7 ly18 lyf10n ly3 ly                                    ///
       if $newoutsample, title("Multi-Step Long-run ahead")       ///
       subtitle("Log US Real GDP")                                      ///
       name(ComparisonForecastOneStep, replace)
 
 log close