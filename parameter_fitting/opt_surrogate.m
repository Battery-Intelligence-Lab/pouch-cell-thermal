% Surogate optimisation parameter fitting
% This routine is used to run a large-scale search in parameter space.
% Author: Volkan Kumtepeli
clear variables; close all; clc;

addpath('../aux_fun/');

import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true);

Tref = 25; % Reference temperature degC
SOC = 30;  % SOC percent
Cr  = 8;   % C-rate (1/h)
fitting_mode = "pulse";
Tend = 2498;             % End of 

data  = data_loader(SOC, Cr, fitting_mode, Tend);
model = mphload("model_v2.10.mph");

model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));

%Xinit = get_checkpoints(Crate,data); % -> Run if there are some checkpoints to load.

cost_fun = @(x) run_pulse(x, model, data);
res_fun  = @(x) get_residual(x, model, data);

%    Cpel (1)  keff(2)   h1(3)      ku(4)    keref(5)   alfa_ke(6)  i0ref(7)  Ei0(8)  Del_mag(9) 
%x0 = [3.35    2.1       2.33       0.30    22.4314     2           1         32.8781  -0.0281];
x0 = [2.3794   127       9.2252     0.4158   13.67      2.155       43        30        -0.0816];
lb = [1.8        1       8.0000     0.05     8          0.8         50        0         -0.2]; 
ub = [3.5      180       12.0000    0.7      60.0000    3.5         50        0          0.0];

% keref + alfa_ke*(T0 - Tref)  > 0.1 ! 
% -keref -(T0 - Tref)*alfa_ke < -0.1 !!! 
 
% A  = zeros(1,7); b = zeros(1,1);
% 
% A(3) = -1; %keref coeff. 
% A(4) = -(Tinf - Tref);
% b(1) = -0.5; 
% 
% select_aug = @(x) [x0(1), x0(2), x(1), x(2), x(3), x(4), x(5), x(6), x(7)];
% select_dec = @(x) [x(3), x(4), x(5), x(6), x(7), x(8), x(9)];
%--------

% select_aug = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x0(7), x0(8), x(7)];
% select_dec = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(9)];


select_aug = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9)];
select_dec = @(x) [x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), x(9)];

cost_fun_temp = @(x) cost_fun( select_aug(x) ); % Just optimise first three
res_fun_temp  = @(x) res_fun( select_aug(x) ); % Just optimise first three

%is_inequality = false;

A  = zeros(3,9); b = zeros(3,1);

A(1,5) = -1; %keref coeff. 
A(1,6) = -(Tinf - Tref);
b(1) = -1; 

A(2, [1,3]) = [3.5, -1]; % [3, -1]; 
A(3, [1,3]) = [-5.5, 1]; % [-6, 1]; 

Aeq = []; beq = [];
%Aeq = zeros(1,9);  beq = zeros(1,1);

%Aeq(1, [1,3]) = [5, -1]; 

% 
% % 4.5 <= h/Cpel <= 5.5 
% % 4.5Cpel <= h <= 5.5Cpel
% % 4.5Cpel - h <= 0 
% % -5.5Cpel + h <= 0 
% 

Xinit = get_checkpoints(Crate,data);
% %Xinit2 = Xinit;
% %Xinit2.X = select_dec(Xinit2.X);

% 
% %    Cpel (1)  keff(2)  h1(3)      ku(4)    keref(5)   alfa_ke(6)  i0ref(7)  Ei0(8)  Del_mag(9) 
% %x0 = [3.35     2.1       2.33     0.30     22.4314    2           1        32.8781   -0.0281];
% x0 = [3.3117   72       14.9088    0.2263   21.7005    3.3323      2        29.7826    0.0510];
%lb = [1        25        8.0000     0.1      5          0.1        0.5000    1        -0.1]; 
%ub = [4        250       15.0000    0.5000   25.0000    4.000      50.0000   80.0000   0.1];
% 
% A  = zeros(3,9); b = zeros(3,1);
% 
% A(1,5) = -1; %keref coeff. 
% A(1,6) = -(Tinf - Tref);
% b(1) = -0.5; 
% 
% A(2, [1,3]) = [3.5, -1];
% A(3, [1,3]) = [-5.5, 1];
% 
chck_filename = ['checkfile_Pulse_',num2str(Crate), 'C.mat'];


objconstr = @(x) get_objconstr(x, cost_fun);
% 
options = optimoptions('surrogateopt','PlotFcn','surrogateoptplot',...
    'MaxFunctionEvaluations',25000, 'MinSurrogatePoints',15,...
    'InitialPoints', Xinit, 'Display','iter',...
    'MaxTime', 2*24*3600);
% 
if isfile(chck_filename)
    opt = optimoptions(options, 'MaxTime', 5*24*3600);
    [x,fval,exitflag,output,trials] = surrogateopt(chck_filename,opt);
 %    [x,fval,exitflag,output,trials] = surrogateopt(objconstr, lb, ub, options);
else
    [x,fval,exitflag,output,trials] = surrogateopt(objconstr, lb, ub, [], A,b, Aeq,beq, options);
end

%% Aux functions:
function objconstr = get_objconstr(x, f)
%[y, cost1, cost2] = f(x);

y = f(x);
cost1 = y;

if(cost1>5e8)
    objconstr.Fval = 1;
    objconstr.Ineq = 1;
else
    objconstr.Fval = y;
    objconstr.Ineq = -1;
end

end


function residuals = get_residual(x, model, data)
[~, ~, ~, residuals] = run_pulse(x, model, data);
end