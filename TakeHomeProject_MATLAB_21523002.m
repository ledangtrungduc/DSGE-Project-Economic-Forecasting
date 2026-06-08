

% Housekeeping
close all     % Close all open figures
clear         % Clear workspace
clc           % Clear command window

% Specify the first observation to be used for data transformation
% Example: If the data set in the first row contains the variable
% names, in the following rows contains r periods for model
% initialization and the model contains s lags of the endogenous
% variables (r>=s), then this value is 1+r-s
start_transform = 4;
% Specify the observation number for the last in-sample period
end_in_sample = 207;

% Load and transform the data
transform_data_DSGE_21523002

% Run the estimation and calculate in-sample predictions
dynare TakeHomeProject_DYNARE_21523002.mod
