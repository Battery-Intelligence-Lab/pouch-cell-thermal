% For long presentation evaluate the simulation things.
clear variables; close all; clc;

addpath('../aux_fun')

import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true);

param.names = {'Cpel', 'keff', 'h1', 'ku', 'keref', 'alfa_ke', 'i0ref', 'Ei0', 'delS'};
param.units = {'[MJ/m^3/K]', '[W/m/K]', '[W/m^2/K]', '[V]', '[mS/m]', '[mS/m/K]', '[A/m^2]', '[kJ/mol]','[mV/K]'};

paper_2026 = [2.6151  187.1257    9.9508    0.2895    9.4501    1.6648   50.0000         0   -0.0476;  % 30% params
    2.7970  220.3830    9.6504    0.2358   12.3307    2.1885   50.0000         0    0.1007   % 50% params
    2.5869  218.1668    9.4508    0.2401   15.0029    2.2676   50.0000         0    0.1154]; % 70% params


xname = "paper_2026";

results_dir = "../results/paper_results_" + xname;

x0s = eval(xname); %#OK

x0_CCs = [mean(x0s(1:3,:)); x0s(1:3,:)]; % First the mean then all of them.

soc_arr = [30, 50, 70];

if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

CC_Cr = [2,4,6,8,10];
CC_modes = ["ch", "dch"];

pulse_Cr = [2,4,8];


%% Pulse simulations:
fitting_mode = "pulse";
model = mphload("vk_Gosia_v2.15_pulse.mph"); % Because seggregrated is better for this job.
%%
for i_soc = 1:3
    SOC = soc_arr(i_soc);
    x_now = x0s(i_soc, :);
    for Cr = pulse_Cr % We don't have Cr = 6 and 10 for pulse.

        data = data_loader(SOC, Cr, fitting_mode);

        model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));
        [Simt, SimV, SimT, Qgen] = run_sim(x_now, model, data);
        [SimT_hot, SimT_cold, SimT_mean] = calculate_hot_cold_mean(SimT, data.n_square);

        fname = fitting_mode + "_" + SOC + "_" + Cr + "C.mat";
        save(fullfile(results_dir, fname));

    end
end

%% CC simulations:
model = mphload("vk_Gosia_v2.15.mph");
for i_CC = 2%1:size(x0_CCs,1)
    for fitting_mode = "ch"%CC_modes
        if(strcmpi(fitting_mode, "ch"))
            SOC = 0;
        else
            SOC = 100;
        end

        for Cr = 10% CC_Cr
            x_now = x0_CCs(i_CC, :);

            data = data_loader(SOC, Cr, fitting_mode);

            model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));

            [Simt, SimV, SimT, Qgen, SOCmat] = run_sim(x_now, model, data);
            [SimT_hot, SimT_cold, SimT_mean] = calculate_hot_cold_mean(SimT, data.n_square);

            fname = fitting_mode + "_" + SOC + "_" + Cr + "C_" + i_CC + ".mat";

            save(fullfile(results_dir, fname));

        end
    end
end