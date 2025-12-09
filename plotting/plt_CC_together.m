i_sel = 1; % Selected parameter set which is 70% params.

text_font = 18;
lw = {'LineWidth',1.5};

x0 = 1; y0 = 1;

golden_ratio = 1.618;
width = 6.3;
height= width/golden_ratio;
colors = cmocean('thermal',6); % Yellow to blue


fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');
h_sim = [];
h_exp = [];
% Plot dch temperature data
for Cr = 2:2:10
    name = "soc100_cr"+Cr +"_" + i_sel;
    data = dch_data.(name);
    
    mytime = data.Simt;
    mytime = [mytime; (mytime(end):mytime(end)+200)']; % Just creating a long time vector
    
    Sim_len = length(data.Tmean);
    Exp_len = length(data.ExpT_mean);

    Sim_len = min(Exp_len, Sim_len);
    
    h1 = plot(data.Simt(1:Sim_len), data.SimV(1:Sim_len), 'Color', colors(Cr/2, :), ...
        'LineWidth', 2, 'DisplayName', 'Sim');
    
    hold on;
    
    h2 = plot(mytime(1:Exp_len), data.ExpV(1:Exp_len), '--', 'Color', colors(Cr/2, :), ... % Gray dashed for exp
        'LineWidth', 2, 'DisplayName', 'Exp');
    
    if(Cr==2) % Store handles for sim and exp
        h_sim = h1;
        h_exp = h2;
    end
    
end

xlabel('Time (s)', 'FontSize', text_font);
ylabel('Voltage (V)', 'FontSize', text_font);

xlim([-25, 1850]);
ylim([2.6, 3.61])
xticks(0:300:1800)
grid on;
% Traditional legend for line styles
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))


cb_pos = [0.64 0.8 0.32 0.03];
cb_ax = axes('Position', cb_pos);

% Create colormap data (horizontal)
cmap_data = repmat(linspace(0, 1, 100), 5, 1);
imagesc(cmap_data);
colormap(cb_ax, colors(1:5,:));

% Customize horizontal colorbar
set(cb_ax, 'YTick', [], 'XTick', [1 25 50 75 100], ...
    'XTickLabel', {'2C', '4C', '6C', '8C', '10C'}, ...
    'FontSize', text_font);
title(cb_ax, 'C-rate', 'FontSize', text_font, 'Position', [50 0]);

leg_pos = cb_pos;
leg_pos(2) = leg_pos(2) + 0.12;
leg_pos(1) = leg_pos(1) - 0.1;
leg = legend([h_exp, h_sim], {'Experimental', 'Simulation'}, ...
    'Position', leg_pos, 'FontSize', text_font, 'TextColor', 'black', ...
    'orientation','horizontal');

if(write_file)
    save_plt(gcf, output_dir, "SimII_Voltage_plots_dch");
end

% ===================================

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');

h_sim = [];
h_exp = [];
% Plot dch voltage data
for Cr = 2:2:10
    name = "soc100_cr"+Cr +"_" + i_sel;
    data = dch_data.(name);
    
    mytime = data.Simt;
    mytime = [mytime; (mytime(end):mytime(end)+200)']; % Just creating a long time vector
    
    Sim_len = length(data.Tmean);
    Exp_len = length(data.ExpT_mean);
    
    Sim_len = min(Exp_len, Sim_len);
    if(Cr == 4)
        Sim_len = 899; %DISCHARGE
    end
    
    h1 = plot(data.Simt(1:Sim_len), data.SimT_mean(1:Sim_len)-data.ExpT_mean(1), 'Color', colors(Cr/2, :), ...
        'LineWidth', 2, 'DisplayName', 'Sim');
    
    hold on;
    
    h2 = plot(mytime(1:Exp_len), data.ExpT_mean(1:Exp_len)-data.ExpT_mean(1), '--', 'Color', colors(Cr/2, :), ... % Gray dashed for exp
        'LineWidth', 2, 'DisplayName', 'Exp');
    
    if(Cr==2) % Store handles for sim and exp
        h_sim = h1;
        h_exp = h2;
    end
    
end

xlabel('Time (s)', 'FontSize', text_font);
ylabel('T_{avg} - T_0 (^oC)', 'FontSize', text_font);

xlim([-25, 1850]);
ylim([-0.5, 10.2])
xticks(0:300:1800);
yticks(0:2:10)
grid on;

set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

cb_pos = [0.64 0.8 0.32 0.03];
cb_ax = axes('Position', cb_pos);

% Create colormap data (horizontal)
cmap_data = repmat(linspace(0, 1, 100), 5, 1);
imagesc(cmap_data);
colormap(cb_ax, colors(1:5,:));

% Customize horizontal colorbar
set(cb_ax, 'YTick', [], 'XTick', [1 25 50 75 100], ...
    'XTickLabel', {'2C', '4C', '6C', '8C', '10C'}, ...
    'FontSize', text_font);
title(cb_ax, 'C-rate', 'FontSize', text_font, 'Position', [50 0]);

leg_pos = cb_pos;
leg_pos(2) = leg_pos(2) + 0.12;
leg_pos(1) = leg_pos(1) - 0.105;
leg = legend([h_exp, h_sim], {'Experimental', 'Simulation'}, ...
    'Position', leg_pos, 'FontSize', text_font, 'TextColor', 'black', ...
    'orientation','horizontal');

% Save figure
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
    save_plt(gcf, output_dir, "SimII_Tavg_plots_dch");
end

% CC ch:
% Plot dch temperature data
fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');

h_sim = [];
h_exp = [];

for Cr = 2:2:10
    name = "soc0_cr"+Cr +"_" + i_sel;
    data = ch_data.(name);
    
    Sim_len = length(data.Tmean);
    Exp_len = min(Sim_len, length(data.ExpT_mean));
    
 %   Sim_len = min(Exp_len, Sim_len);
    if(Cr == 10)
        Sim_len = 350;
    end
    
    if(Cr == 2)
        Sim_len = 1800;
    end
    
    h1 = plot(data.Simt(1:Sim_len), data.SimV(1:Sim_len), 'Color', colors(Cr/2, :), ...
        'LineWidth', 2, 'DisplayName', 'Sim');
    
    hold on;
    
    h2 = plot(data.Simt(1:Exp_len), data.ExpV(1:Exp_len), '--', 'Color', colors(Cr/2, :), ... % Gray dashed for exp
        'LineWidth', 2, 'DisplayName', 'Exp');
    if(Cr==2) % Store handles for sim and exp
        h_sim = h1;
        h_exp = h2;
    end
end

xlabel('Time (s)', 'FontSize', text_font);
ylabel('Voltage (V)', 'FontSize', text_font);

xlim([-25, 1850]);
ylim([2.6, 3.61])
xticks(0:300:1800)
grid on;
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))


cb_pos = [0.64 0.34 0.32 0.03];
cb_ax = axes('Position', cb_pos);

% Create colormap data (horizontal)
cmap_data = repmat(linspace(0, 1, 100), 5, 1);
imagesc(cmap_data);
colormap(cb_ax, colors(1:5,:));

% Customize horizontal colorbar
set(cb_ax, 'YTick', [], 'XTick', [1 25 50 75 100], ...
    'XTickLabel', {'2C', '4C', '6C', '8C', '10C'}, ...
    'FontSize', text_font);
title(cb_ax, 'C-rate', 'FontSize', text_font, 'Position', [50 0]);

leg_pos = cb_pos;
leg_pos(2) = leg_pos(2) - 0.18;
leg_pos(1) = leg_pos(1) - 0.105;
leg = legend([h_exp, h_sim], {'Experimental', 'Simulation'}, ...
    'Position', leg_pos, 'FontSize', text_font, 'TextColor', 'black', ...
    'orientation','horizontal');

set(gcf, 'renderer', 'Painters');
if(write_file)
    save_plt(gcf, output_dir, "SimII_Voltage_plots_ch");
end

%

fig1=figure('Units','inches',...
    'Position',[x0 y0 (x0+width) (y0+height)],...
    'PaperPositionMode','auto');

h_sim = [];
h_exp = [];

% Plot dch voltage data
for Cr = 2:2:10
    name = "soc0_cr"+Cr +"_" + i_sel;
    data = ch_data.(name);
    
    Sim_len = length(data.Tmean);
    Exp_len = min(Sim_len, length(data.ExpT_mean));
    Sim_len = min(Exp_len, Sim_len);

    h1 = plot(data.Simt(1:Sim_len), data.SimT_mean(1:Sim_len)-data.ExpT_mean(1), 'Color', colors(Cr/2, :), ...
        'LineWidth', 2, 'DisplayName', 'Sim');
    
    hold on;
    
    h2 = plot(data.Simt(1:Exp_len), data.ExpT_mean(1:Exp_len)-data.ExpT_mean(1), '--', 'Color', colors(Cr/2, :), ... % Gray dashed for exp
        'LineWidth', 2, 'DisplayName', 'Exp');
    if(Cr==2) % Store handles for sim and exp
        h_sim = h1;
        h_exp = h2;
    end
end

xlabel('Time (s)', 'FontSize', text_font);
ylabel('T_{avg} - T_0 (^oC)', 'FontSize', text_font);

xlim([-25, 1850]);
ylim([-1, 10.2])
xticks(0:300:1800);
yticks(0:2:10)
grid on;

set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

cb_pos = [0.64 0.8 0.32 0.03];
cb_ax = axes('Position', cb_pos);

% Create colormap data (horizontal)
cmap_data = repmat(linspace(0, 1, 100), 5, 1);
imagesc(cmap_data);
colormap(cb_ax, colors(1:5,:));

% Customize horizontal colorbar
set(cb_ax, 'YTick', [], 'XTick', [1 25 50 75 100], ...
    'XTickLabel', {'2C', '4C', '6C', '8C', '10C'}, ...
    'FontSize', text_font);
title(cb_ax, 'C-rate', 'FontSize', text_font, 'Position', [50 0]);

leg_pos = cb_pos;
leg_pos(2) = leg_pos(2) + 0.12;
leg_pos(1) = leg_pos(1) - 0.105;
leg = legend([h_exp, h_sim], {'Experimental', 'Simulation'}, ...
    'Position', leg_pos, 'FontSize', text_font, 'TextColor', 'black', ...
    'orientation','horizontal');

if(write_file)
    save_plt(gcf, output_dir, "SimII_Tavg_plots_ch");
end