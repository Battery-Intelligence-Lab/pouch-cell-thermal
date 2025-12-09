% This file is for revision of the Gosia paper. 
% Date: 01 October 2025
% Author: Volkan Kumtepeli

clear variables; close all; clc;

addpath('../aux_fun')

import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true);

% Hot-cold-mean fitting:
paper_2026 = [2.6151  187.1257    9.9508    0.2895    9.4501    1.6648   50.0000         0   -0.0476;  % 30% params
                  2.7970  220.3830    9.6504    0.2358   12.3307    2.1885   50.0000         0    0.1007   % 50% params
                  2.5869  218.1668    9.4508    0.2401   15.0029    2.2676   50.0000         0    0.1154]; % 70% params


xname = "paper_2026";

results_dir = "../results/paper_results_" + xname + "_revision";

x0s = eval(xname); %#OK

soc_arr = [30, 50, 70];

if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

pulse_Cr = [8];


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
        tic
        [Simt, SimV, SimT, Qgen] = run_sim(x_now, model, data);
        etime = toc;
        [SimT_hot, SimT_cold, SimT_mean] = calculate_hot_cold_mean(SimT, data.n_square);

        fname = fitting_mode + "_" + SOC + "_" + Cr + "C_linear.mat";
        save(fullfile(results_dir, fname));

        fprintf("%s took %4.4f time.\n", fname, etime);
    end
end

%% Pulse simulations BV:
fitting_mode = "pulse";
model = mphload("vk_Gosia_v2.15_ButlerVolmer.mph"); % Because seggregrated is better for this job.
%
for i_soc = 1:3
    SOC = soc_arr(i_soc);
    x_now = x0s(i_soc, :);
    for Cr = pulse_Cr % We don't have Cr = 6 and 10 for pulse.

        data = data_loader(SOC, Cr, fitting_mode);

        model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));
        tic
        [Simt, SimV, SimT, Qgen] = run_sim(x_now, model, data);
        etime = toc;
        [SimT_hot, SimT_cold, SimT_mean] = calculate_hot_cold_mean(SimT, data.n_square);

        fname = fitting_mode + "_" + SOC + "_" + Cr + "C.mat";
        save(fullfile(results_dir, fname));

        fprintf("%s took %4.4f time (BV).\n", fname, etime);
    end
end
