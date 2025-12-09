% Sweep simulation for `keff` parameter. 
% Author: Volkan Kumtepeli

clear variables; close all; clc;

% Import COMSOL libraries. 
import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true); % Show progress (works on Windows)

SOC          = 50;      % SOC in percent (30, 50 or 70)
Cr           = 8;       % C-rate
fitting_mode = "pulse"; % Fitting mode ("pulse", "ch" or "dch")
Tend         = 2498;    % End time (s)

data  = data_loader(SOC, Cr, fitting_mode, Tend);

model = mphload("model_v2.10.mph");

cost_fun = @(x) run_pulse(x, model, data);
res_fun  = @(x) get_residual(x, model, data);

%    Cpel     keff       h1        ku       keref     alfa_ke  i0ref     Ei0       Del_mag 
x0 = [2.04    198.2133   1.5437    0.1094   6.8897    0.6814   10.8934   48.6052   0.0380];
lb = [2.04    0.100      1.00000   0.0100   0.5       0.001    0.1000    0.50000  -0.3]; 
ub = [2.04    200.00     40.0000   0.4000   60.0000   20.000   50.0000   80.0000   0.3];

keff_space = logspace(log10(0.1),log10(200),200);
cost_arr = zeros(1,200);

x_now = x0;
for i=1:length(keff_space)
    x_now(2) = keff_space(i);
    cost_arr(i) = cost_fun(x_now);
    fprintf('Finished %d simulation Cost is %4.4f for keff %4.4f.\n',i, cost_arr(i), keff_space(i));
end