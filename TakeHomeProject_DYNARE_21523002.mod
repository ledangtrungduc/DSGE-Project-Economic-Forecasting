% Dynare code to solve and estimate a three-equation NK-DSGE model
% in output, inflation, and the nominal interest rate,
% as well as obtain model-implied forecasts of these variables. 
%
% The model is log-linearized, and all variables are expressed in terms of 
% percentage deviations from steady state. This implies that the data 
% need to be transformed to the same format; the m-file transform_data.m
% accomplishes this and needs to be run prior to running this Dynare file.
%
% Compiled by Stefan Girstmair with Text Editing by Michael Binder
%
% Chair of International Macroeconomics and Macroeconometrics
% Goethe University Frankfurt
% This Version: May 3, 2024

% Define endogenous variables
var 
y c r pi 
z m u g
r_obs pi_obs y_obs c_obs;

% Define exogenous variables
varexo
e_z e_m e_u e_g;

% Define parameters
parameters
sigma phi_pi phi_y beta theta rho_z rho_m rho_u rho_g rho_r varphi sc sg;

% Declare parameter-values
varphi = 1;
sigma = 1;
phi_pi = 1.5;
phi_y = 0.159;
beta = 0.99;
theta = 0.8;
rho_r = 0.7;
rho_z = 0.855;
rho_m = 0.7;
rho_u = 0.924;
rho_g = 0.949;
sc = 0.85;
sg = 0.15;

% The (log-linearized) model equations
model(linear);
# lambda = (1-theta)*(1-theta*beta)/(theta);
% kappa = lambda*(varphi+sigma);

c = c(+1) - (r - pi(+1)) + z;
r = rho_r * r(-1) + (phi_pi * pi (+1) + phi_y * y) + m;
pi = beta * pi(+1) + y * lambda + varphi * u;
y = sc * c + sg * g;

z = rho_z * z(-1) + e_z;
u = rho_u * u(-1) + e_u;
m = rho_m * m(-1) + e_m;
g = rho_g * g(-1) + e_g;
y_obs = y;
pi_obs = pi;
r_obs = r;
c_obs = c;
end;

% Check residuals (not needed)
resid;
check;

% Declare shocks
shocks;
var e_z; stderr 0.336;
var e_g; stderr 0.325;
var e_m; stderr 0.081;
var e_u; stderr 0.017;
end;

% Declare observational variables 
varobs y_obs pi_obs r_obs c_obs;

% Declare endogenous variables to be estimated
% as well as the prior distributions
estimated_params;
theta,  normal_pdf, 0.6,0.15;

sigma,  normal_pdf, 2.5,0.25;

phi_pi, normal_pdf, 1.5,0.25;

phi_y,  normal_pdf, 0.125,0.1;

rho_r,  beta_pdf, 0.75,0.1;

rho_z,  beta_pdf, 0.75,0.1;

rho_u,  beta_pdf, 0.75,0.1;

rho_m,  beta_pdf, 0.50,0.2;

rho_g,  beta_pdf, 0.50,0.2;

sc, normal_pdf, 0.75,0.1;

sg, normal_pdf, 0.75,0.1;

stderr e_z, inv_gamma_pdf, 0.05,2;
stderr e_u, inv_gamma_pdf, 0.05,2;
stderr e_m, inv_gamma_pdf, 0.05,2;
stderr e_g, inv_gamma_pdf, 0.875,0.430;
end;

% Estimation command 

load estimation_data.mat;
dataseries_in.y_obs = y_obs(:);
dataseries_in.pi_obs = pi_obs(:);
dataseries_in.r_obs = r_obs(:);
dataseries_in.c_obs = c_obs(:);
save ('DYNARE_estimdata_in','-STRUCT','dataseries_in')

% Set mode_compute = 6 to run the mode finder (necessary if mode file 
% has not been constructed before, or if model and/or sample size have 
% been changed). The (new) set of modes can then be found in the
% folder estimation_DSGE/Output as the file with the name 
% simple_NK_mode.mat, and should be copied into the same folder where 
% estimation_DSGE_mode.mat was initially located.
% Set mode_compute = 0 to use the mode that for this model has been 
% calculated earlier and is stored under estimation_DSGE_mode.mat.

% mh_replic: Number of replications for each chain of the 
% Metropolis-Hastings algorithm.
% mh_nblocks: Number of parallel chains for the Metropolis-Hastings 
% algorithm

mode_compute = 6
estimation(datafile=DYNARE_estimdata_in, mh_replic=20000, mh_nblocks=1,
mode_compute=6, plot_priors=0, irf=12, forecast=12) y_obs pi_obs r_obs c_obs; 

% Option 2: mode_compute = 0
%estimation(datafile=DYNARE_estimdata_in, mh_replic=20000, mh_nblocks=1,
%mode_compute=0, plot_priors=0, irf=12, forecast=12,
%mode_file=estimation_DSGE_mode) y_obs pi_obs r_obs;