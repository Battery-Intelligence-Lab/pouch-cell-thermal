% Nonlinear least squares fitting,
% This optimisation routine is used to polish the results from 
% a global optimiser or when the parameter values are approximately known.
% Author: Volkan Kumtepeli

clear variables; close all; clc;

addpath('../aux_fun/');

import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true);

SOC = 30;    % percent
Cr  = 8;     % 1/h
Tend = 2498; % 2498; % 

Tref = 25; % degC
fitting_mode = "pulse";

data = data_loader(SOC, Cr, fitting_mode, Tend);
model = mphload("model_v2.10.mph");

model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));

cost_fun = @(x) run_pulse(x, model, data);
res_fun  = @(x) get_residual(x, model, data);

%    Cpel (1)  keff(2)   h1(3)      ku(4)    keref(5)   alfa_ke(6)  i0ref(7)  Ei0(8)  Del_mag(9) 
%x0 = [3.35    2.1       2.33       0.30    22.4314     2           1         32.8781  -0.0281];
x0 = [2.7256   72.3705   10.6       0.4      22.4826    2.6532      5.7        62     -0.0504];
lb = [1.8        1       8.0000     0.05     5          0.5         0.5       0         -0.2]; 
ub = [3.5      350       12.0000    0.8      60.0000    5.5         12         80        0.2];

% keref + alfa_ke*(T0 - Tref)  > 0.1 ! 
% -keref -(T0 - Tref)*alfa_ke < -0.1 !!! 
 
% A  = zeros(1,7); b = zeros(1,1);
% 
% A(3) = -1; %keref coeff. 
% A(4) = -(Tinf - Tref);
% b(1) = -0.5; 
% 
%--------

select_aug = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x0(7), x0(8), x(7)];
select_dec = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(9)];

% select_aug = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9)];
% select_dec = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9)];

cost_fun_temp = @(x) cost_fun( select_aug(x) ); % Just optimise first three
res_fun_temp  = @(x) res_fun( select_aug(x) ); % Just optimise first three

%is_inequality = false;

% A  = zeros(3,9); b = zeros(3,1);
% 
% A(1,5) = -1; %keref coeff. 
% A(1,6) = -(Tinf - Tref);
% b(1) = -1; 
% 
% A(2, [1,3]) = [3.5, -1]; % [3, -1]; 
% A(3, [1,3]) = [-5.5, 1]; % [-6, 1]; 
% 
% Aeq = []; beq = [];
% %Aeq = zeros(1,9);  beq = zeros(1,1);

%Aeq(1, [1,3]) = [5, -1]; 

% 
% % 4.5 <= h/Cpel <= 5.5 
% % 4.5Cpel <= h <= 5.5Cpel
% % 4.5Cpel - h <= 0 
% % -5.5Cpel + h <= 0 
% 

[x_opt, fval] = lsqnonlin(res_fun_temp, select_dec(x0), select_dec(lb), select_dec(ub),...
    optimoptions('lsqnonlin','Display','iter-detailed', ...
    'PlotFcn','optimplotresnorm', ...
    'TolX',1e-4,'FinDiffRelStep',1e-3));