clear variables; close all; clc;

% import('com.comsol.model.*')
% import('com.comsol.model.util.*')
% 
% ModelUtil.showProgress(true);
% 
% model = mphload("model_v2.10.mph");
% 
% Tend = 2200; %
% model.param.set('Tend', sprintf('%d [s]',Tend));
% 
% model.sol('sol1').runAll;
% 
% SimT = get_front_temperature(model);
% SimT_back = get_back_temperature(model);

%% Testing 

x_test1 = [1.8385 43.7969 11.0312 0.5641 14.4531 3.2422 51.3219 0 -0.1375];
%x_test2 = [3.3232    1.8    2.3654    0.1004    4.0139    0.2852    4.1026   28.9673    0.0513];
%x_test3 = [3.3232    1.5    2.3654    0.1004    4.0139    0.2852    4.1026   28.9673    0.0513];
res_fun(x_test1);

%%


k_eff_arr = 0.2:0.2:10;

for i=1:length(k_eff_arr)
    x_test1 = [3.3232    k_eff_arr(i)    2.3654    0.1004    4.0139    0.2852    4.1026   28.9673    0.0513];
    res_fun(x_test1);
end


%%
load('Checkpoints\Checkpoint_Pulse_8C_442.mat')
ExpT = double(load('exp/pulse/50SOC/8C50s/ExpIR.mat').ExpIR);
Tend = size(SimT,3);
%%
% figure; 
% for i = 1:(Tend-1)
% subplot(1,2,1);
% imagesc(SimT(:,:,i)); 
% if(i==1)
%     colorbar;
%     clim([21,28]);
%     hold on;
% end
% 
% % subplot(1,2,2);
% % imagesc(rot90(ExpT(:,:,i), 2)); 
% % if(i==1)
% %     colorbar;
% %     clim([21,28]);
% %     hold on;
% % end
% 
% pause(0.01)
% end

%  3.1178    2.0096    2.3459    0.0799    4.8502    1.0013    1.6013    1.2121    0.0813
% 


%%
figure; 
first_time = true; 
for i = 1:1:2400%1:(Tend-1)
subplot(1,2,1);
imagesc(SimT(:,:,i)); 
if(first_time)
    colorbar;
    clim([21,28]);
    hold on;
    cmocean('thermal')
end
contourf(SimT(:,:,i),'w')
title(sprintf('t = %d s',i))

% subplot(1,3,2);
% imagesc(SimT_back(:,:,i)); 
% if(i==1)
%     colorbar;
%     clim([21,28]);
%     hold on;
%     cmocean('solar')
% end

subplot(1,2,2);
imagesc(rot90(ExpT(:, :,i), 2)); 
if(first_time)
    colorbar;
    clim([21,28]);
    hold on;
    cmocean('thermal')
end
%contourf(rot90(ExpT(6:end-5, 3:end-2,i), 2));

pause(0.01)
first_time = false;
end

%% test the experimental: 

% 
% figure;
% for i = 1:2200
% imagesc(ExpT(:,:,i)); 
% if(i==1)
%     colorbar;
%     clim([21,28]);
%     hold on;
% end
% pause(0.01)
% end
