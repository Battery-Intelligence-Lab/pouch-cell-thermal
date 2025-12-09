% Some manual testing
% Author: Volkan Kumtepeli
clear variables; close all; clc;

load('Checkpoint_Pulse_8C_90.mat') % Load some checkpoints. 
ExpT = double(load('../exp/pulse/50SOC/8C50s/ExpIR.mat').ExpIR);
ExpT_CC = double(load('../exp/CC/10C/dch/ExpIR.mat').ExpIR);
temp = load('../exp/pulse/50SOC/8C50s/Expivium.mat').Expivium;
Expt = temp(:,1)-1;
ExpV = temp(:,2);
ExpI = temp(:,3);
ExpT_outside = temp(:,4);
Tend = size(ExpT,3);

sigma = 3; % Smoothing factor, taken from the PhD thesis of M. E. Wojtala. 
ExpT_smoothted = imgaussfilt(ExpT, sigma);
ExpT_smoothed_rot = rot90(ExpT_smoothted, 2);
%%
golden_ratio = 1.618;
x0 = 1;
y0 = 1;

text_font = 12;
width  = 14; % 3.5 inch / 9 cm 
height = width/golden_ratio/2;

fig1=figure('Units','inches',...
'Position',[x0 y0 (x0+width) (y0+height)],...
'PaperPositionMode','auto');

first_time = true; 
for i = 1:5:2480%1:(Tend-1)
subplot(1,4,1);
imagesc(SimT(:,:,i)); 
if(first_time)
    colorbar;
    clim([21,30]);
    hold on;
    cmocean('thermal')
end
contourf(SimT(:,:,i),'w')
title('SimT');
sgtitle(sprintf('t = %d s',i-1));


subplot(1,4,2);
imagesc((ExpT_smoothted(:, :,i))); 
if(first_time)
    colorbar;
    clim([21,30]);
    hold on;
    cmocean('thermal')
end
contourf(ExpT_smoothted(:, : ,i),'w');
title('ExpT-smoothed');

subplot(1,4,3);
imagesc((ExpT(:, :,i))); 
if(first_time)
    colorbar;
    clim([21,30]);
    hold on;
    cmocean('thermal')
    set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',text_font,...
    'FontName','Times');
    set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
  %  set(gcf,'renderer','Painters')
end
%contourf(rot90(ExpT(6:end-5, 3:end-2,i), 2));
title('ExpT');

subplot(1,4,4);
imagesc((ExpT_smoothed_rot(:, :,i))); 
if(first_time)
    colorbar;
    clim([21,30]);
    hold on;
    cmocean('thermal')
end
contourf(ExpT_smoothed_rot(:, : ,i),'w');
title('ExpT-smoothed-rot');

pause(0.02);
first_time = false;
end
%% Average etc: 

ExpT_mean = reshape(mean(ExpT(6:end-5, 3:end-2,:),   [1,2]),[],1);
ExpT_max  = reshape(max(ExpT(6:end-5, 3:end-2,:), [], [1,2]),[],1);
ExpT_min  = reshape(min(ExpT(6:end-5, 3:end-2,:), [], [1,2]),[],1);

SimT_mean = reshape(mean(SimT,   [1,2]),[],1);
SimT_max  = reshape(max(SimT, [], [1,2]),[],1);
SimT_min  = reshape(min(SimT, [], [1,2]),[],1);

figure; 

plot(SimT_mean); hold on;
plot(ExpT_mean); grid on; 
xlabel('Time (s)');
ylabel('Mean temperature (^oC)')
 
%plot(SimV); hold on;
%plot(ExpV_temp); grid on; 

%%
figure; 
ExpV_temp = ExpV;
ExpV_temp(2) = [];
subplot(1,3,1)
plot(SimT_mean); hold on;
plot(ExpT_mean); grid on; 
ylim([21,30])

subplot(1,3,2)
plot(SimT_max);  hold on; grid on; 
plot(ExpT_max)
ylim([21,30])

subplot(1,3,3)

plot(SimT_min); hold on; grid on; 
plot(ExpT_min)
ylim([21,30])


xlabel('Time (s)');
ylabel('Mean temperature (^oC)')

%% Where is this TAB!
figure;
first_time = true;
for i = 1:5:360
imagesc(rot90(ExpT_CC(:, :,i),2)); 
if(first_time)
    colorbar;
    clim([24,31]);
    hold on;
    cmocean('thermal')
end
%contourf(flipud(ExpT_CC(:, : ,i)),'w');
title(['ExpT-smoothed', sprintf('t=%d s',i-1)]);
pause(0.1)
end