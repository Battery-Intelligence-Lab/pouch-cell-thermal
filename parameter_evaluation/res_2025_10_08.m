clear variables; close all; clc;

addpath('../aux_fun')

import('com.comsol.model.*')
import('com.comsol.model.util.*')

ModelUtil.showProgress(true);

x0s_fix3_Veq50 = [2.6151  187.1257    9.9508    0.2895    9.4501    1.6648   50.0000         0   -0.0476;  % 30% params
                  2.7970  220.3830    9.6504    0.2358   12.3307    2.1885   50.0000         0    0.1007   % 50% params
                  2.5869  218.1668    9.4508    0.2401   15.0029    2.2676   50.0000         0    0.1154]; % 70% params

xname = "x0s_fix3_Veq50";

results_dir = "../results/paper_results_" + xname + "_revision";

x0s = eval(xname); %#OK

x0_CCs = [mean(x0s(1:3,:)); x0s(1:3,:)]; % First the mean then all of them.
soc_arr = [30, 50, 70];

if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

CC_Cr = 2;% 10:-2:2;%[2,4,6,8,10];
CC_modes =  ["ch"]%, "dch"];

%fitting_mode = "pulse";
%model = mphload("vk_Gosia_v2.15_pulse.mph"); % Because seggregrated is better for this job.

%% CC simulations:
model = mphload("ch_0_2C_4_revision.mph");
for i_CC = 4%1:size(x0_CCs,1)
    for fitting_mode = CC_modes
        if(strcmpi(fitting_mode, "ch"))
            SOC = 0;
        else
            SOC = 100;
        end

        for Cr = CC_Cr
            x_now = x0_CCs(i_CC, :);

            data = data_loader(SOC, Cr, fitting_mode);

            model.param.set('U0', sprintf('%4.4f [V]',data.ExpV_0));

            model_initialise(x_now, model, data); % run_sim
            mname = fitting_mode + "_" + SOC + "_" + Cr + "C_" + i_CC + "_revision.mph";

    %        mphsave(model, mname);

            [Simt, SimV, SimT, Qgen, SOCmat] = run_sim(x_now, model, data); % run_sim
            [SimT_hot, SimT_cold, SimT_mean] = calculate_hot_cold_mean(SimT, data.n_square);

            fname = fitting_mode + "_" + SOC + "_" + Cr + "C_" + i_CC + "_revision.mat";


            save(fullfile(results_dir, fname));

        end
    end
end


