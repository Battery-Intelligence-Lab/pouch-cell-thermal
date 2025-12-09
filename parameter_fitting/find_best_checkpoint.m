% This file finds the best Checkpoint file for a cost function.
% Author: Volkan Kumtepeli

clear variables; close all; clc;

addpath('../aux_fun/'); % Add 

SOC          = 30;      % SOC in percent (30, 50 or 70)
Cr           = 8;       % C-rate
fitting_mode = "pulse"; % Fitting mode ("pulse", "ch" or "dch")
Tend         = 2498;    % End time (s)

data = data_loader(SOC, Cr, fitting_mode, Tend);

% lower/upper bounds to select the best Checkpoint between these limits. 
%    Cpel  keff   h1     ku      keref      alfa_ke    i0ref     Ei0      Del_mag 
lb = [1    1      6      0.0     5          0.1        0.1000    0        -0.4]; 
ub = [4    250    15     1.000   60.0000    4.000      90.0000   80.0000   0.4];

objall = [];

for i=1:length(C)
    [o, name] = get_checkpoints(C(i), data);
    objall = [objall, o];
end

% Find only the lb < x < ub
feasibles = sum((lb <= objall(i).X) & (objall(i).X <= ub), 2) == length(lb);

mins = [];
for i=1:length(C)
    objall(i).Fval(~feasibles) = inf;
    [min_Fval, min_i] = min(objall(i).Fval);
    mins(i).Fval = min_Fval;
    mins(i).index = min_i;
    mins(i).x = objall(i).X(min_i, :);
    mins(i).name = name(min_i).name;
end

fprintf('Best ever point:')
mins(1)
mins(1).name