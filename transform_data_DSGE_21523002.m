% This file transforms the data set so that it can be used for estimation
% of a log-linearized DSGE model in the file DSGE_Main.mod.
% The individual model variables are transfromed to match the
% definitions within the DSGE model as set up in DSGE_Main.mod.
% It is to be noted that the transformed model variables need to be saved
% under the same names as subsequently used in DSGE_Main.mod.
% Edited: Michael Binder and Stefan Girstmair
% May 3, 2024
% Chair for International Macroeconomics and Macroeconometrics
% Goethe University Frankfurt

% Load data 
% Variable names are in first line
data = xlsread('data_project_atmf24.xls');

% Logarithm of Real Gross Domestic Product
% Transformation:
% HP-Filter to render series stationary
ly = data(start_transform:end_in_sample,1); % in-sample period
[ly_trend,ly_cycle] = one_sided_hp_filter(ly);
y_obs = ly_cycle;

% HP-Filter to render series stationary
lc = data(start_transform:end_in_sample,2); % in-sample period
[lc_trend,lc_cycle] = one_sided_hp_filter(lc);
c_obs = lc_cycle;

% Rate of Inflation Based on Consumer Price Index for All Urban Consumers 
% Transformation: None
pi = data(start_transform:end_in_sample,3);
pi_mean = mean(pi)
pi_obs = pi - pi_mean;

% Effective Federal Funds Rate 
% Transformation:
% Log and Render it Quarterly
r = data(start_transform:end_in_sample,4);
r_mean = mean(r)
r_obs = r - r_mean;

% Save data
save('estimation_data','y_obs','pi_obs','r_obs','r_mean','c_obs')
