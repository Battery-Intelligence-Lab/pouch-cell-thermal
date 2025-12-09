% Revision plots.
% Author: Volkan Kumtepeli
% Date: 2025-09-29

clear all; close all; clc;

% Experimental data from Lin et al. 
% Downloaded from https://github.com/Battery-Intelligence-Lab/multiscale-coupling
Lin_data = load('Exp.mat').RunM;

current = Lin_data(:,7); 
voltage = Lin_data(:,6);

Lin_voltage_drop_4C = diff(voltage(1:2));

addpath('../aux_fun');

data_8C_30 = data_loader(30, 8, "pulse");
data_8C_50 = data_loader(50, 8, "pulse");

This_voltage_drop_8C_30 = -data_8C_30.ExpV(1) + data_8C_30.ExpV_0;
This_voltage_drop_8C_50 = -data_8C_50.ExpV(1) + data_8C_50.ExpV_0;

% As Lin's data is 30%: 

fprintf('This 8C 30%% drop: %4.4f vs Lin 4C 30%% drop: %4.4f\n', This_voltage_drop_8C_30, Lin_voltage_drop_4C);

%% Linearised Butler-Volmer Equation assumption. 

% Configuration
results_dir = "../results/paper_results_" + "x0s_fix3_Veq50_revision/";
output_dir = fullfile(results_dir, 'plots/');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% Hotspot trajectories during constant-current charge (1x5)
close all;
write_file = false;

% Files and labels
cc_files = { 'ch_0_2C_4.mat', 'ch_0_4C_4.mat', 'ch_0_6C_4.mat', 'ch_0_8C_4.mat', 'ch_0_10C_4.mat' };
cc_labels = { '2C', '4C', '6C', '8C', '10C' };

% Load data and compute hotspot coordinates per frame
CC = cell(size(cc_files));
for k = 1:numel(cc_files)
    F = fullfile(results_dir, cc_files{k});
    if exist(F, 'file')
        S = load(F);
        if isfield(S, 'SimT')
            simT = S.SimT;
        else
            simT = S.data.SimT; % fallback if nested
        end
        [ny, nx, nt] = size(simT);
        % Convert linear max index to (row,col) each frame
        row_idx = zeros(nt,1); col_idx = zeros(nt,1);
        for t = 1:nt
            [~, lin_idx] = max(simT(:,:,t), [], 'all', 'linear');
            [row_idx(t), col_idx(t)] = ind2sub([ny, nx], lin_idx);
        end
        % Map to physical coordinates using x_dim/y_dim
        x_coords = (col_idx-1) * (x_dim/(nx-1));
        y_coords = (row_idx-1) * (y_dim/(ny-1));
        CC{k} = struct('x', x_coords, 'y', y_coords, 'nt', nt);
    else
        warning('File not found: %s', F);
        CC{k} = struct('x', [], 'y', [], 'nt', 0);
    end
end

% Determine shared time range for colormap scaling
max_nt = max(cellfun(@(c) c.nt, CC));

% Plot scatter trajectories colored by time
figure('Position', [100, 100, 1200, 320]);
tl3 = tiledlayout(1, numel(cc_files));
tl3.TileSpacing = 'tight';

for k = 1:numel(cc_files)
    nexttile;
    if ~isempty(CC{k}.x)
        tvals = 1:CC{k}.nt;
        scatter(CC{k}.x, CC{k}.y, 10, tvals, 'filled');
        hold on;
        set(gca, 'YDir','reverse');
        axis equal tight off;
        title(sprintf('CC %s', cc_labels{k}), 'FontSize', text_font);
        colormap(cmocean('thermal'));
        caxis([1 max_nt]);
    else
        text(0.5, 0.5, 'Missing', 'HorizontalAlignment','center');
        axis off;
    end
end

% Shared colorbar (time)
cb = colorbar();
cb.Layout.Tile = 'east';
cb.Label.String = 'Time index';
cb.Label.FontSize = text_font;

% Save figure
fig_filename = sprintf('%sHotspotTrajectories_CC.fig', output_dir);
png_filename = sprintf('%sHotspotTrajectories_CC.png', output_dir);
eps_filename = sprintf('%sHotspotTrajectories_CC.eps', output_dir);
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
saveas(gcf, fig_filename);
export_fig(gcf, png_filename, '-r1200');
export_fig(gcf, eps_filename);
fprintf('Saved: %s\n', fig_filename);
fprintf('Saved: %s\n', png_filename);
end

soc_levels = [30, 50, 70];

c_rates = 2:2:10;  % 2, 4, 6, 8, 10C

pulse_c_rates = [10];  % Pulse only has 2, 4, 8C

colors = lines(length(c_rates));
pulse_colors = lines(length(pulse_c_rates));

text_font = 14;
set(0, 'DefaultAxesFontSize', text_font);
set(0, 'DefaultAxesFontName', 'Arial');
n_square = 5;


pulse_data = struct();
pulse_files_found = {};

% Load all available pulse files
for soc = soc_levels
    for cr = pulse_c_rates
        filename = sprintf('%spulse_%d_%dC_BVlin.mat', results_dir, soc, cr);
        if exist(filename, 'file')
            fprintf('Loading: %s\n', filename);
            temp_data = load(filename);
            [temp_data.Thot, temp_data.Tcold, temp_data.Tmean] = calculate_hot_cold_mean(temp_data.SimT, n_square);
            temp_data.ExpT_hot = temp_data.data.ExpT_hot;
            temp_data.ExpT_cold = temp_data.data.ExpT_cold;
            temp_data.ExpT_mean  = temp_data.data.ExpT_mean;
            temp_data.ExpV = temp_data.data.ExpV;
            temp_data.Expt = temp_data.data.Expt;
            
            % adding 0th point back!
            [hot0, cold0, mean0] = calculate_hot_cold_mean(temp_data.data.ExpT_0, n_square);
            
            temp_data.ExpV = [temp_data.data.ExpV_0; temp_data.ExpV];
            temp_data.ExpT_hot = [hot0; temp_data.ExpT_hot];
            temp_data.ExpT_cold = [cold0; temp_data.ExpT_cold];
            temp_data.ExpT_mean = [mean0; temp_data.ExpT_mean];
            temp_data.Expt(3:end) = temp_data.Expt(2:end-1);
            temp_data.Expt(2) = 0.05;
            
            pulse_data.(sprintf('soc%d_cr%d_linear', soc, cr)) = temp_data;
            pulse_files_found{end+1} = sprintf('soc%d_cr%d_linear', soc, cr);
        end
    end
end

for soc = soc_levels
    for cr = pulse_c_rates
        filename = sprintf('%spulse_%d_%dC_BVnonlin.mat', results_dir, soc, cr);
        if exist(filename, 'file')
            fprintf('Loading: %s\n', filename);
            temp_data = load(filename);
            [temp_data.Thot, temp_data.Tcold, temp_data.Tmean] = calculate_hot_cold_mean(temp_data.SimT, n_square);
            temp_data.ExpT_hot = temp_data.data.ExpT_hot;
            temp_data.ExpT_cold = temp_data.data.ExpT_cold;
            temp_data.ExpT_mean  = temp_data.data.ExpT_mean;
            temp_data.ExpV = temp_data.data.ExpV;
            temp_data.Expt = temp_data.data.Expt;
            
            % adding 0th point back!
            [hot0, cold0, mean0] = calculate_hot_cold_mean(temp_data.data.ExpT_0, n_square);
            
            temp_data.ExpV = [temp_data.data.ExpV_0; temp_data.ExpV];
            temp_data.ExpT_hot = [hot0; temp_data.ExpT_hot];
            temp_data.ExpT_cold = [cold0; temp_data.ExpT_cold];
            temp_data.ExpT_mean = [mean0; temp_data.ExpT_mean];
            temp_data.Expt(3:end) = temp_data.Expt(2:end-1);
            temp_data.Expt(2) = 0.05;
            
            pulse_data.(sprintf('soc%d_cr%d', soc, cr)) = temp_data;
            pulse_files_found{end+1} = sprintf('soc%d_cr%d', soc, cr);
        end
    end
end

%% Plot the voltage values for BV: 
write_file = false;
close all;
figure; 
i = 1;
for soc = soc_levels
    subplot(2,3,i);
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    plot(pulse_data.(name_LIN).SimV); hold on;
    plot(pulse_data.(name_NL).SimV);
    legend('Linear BV', 'Nonlinear BV');
    xlabel('Time [s]', 'FontSize', text_font);
    ylabel('Voltage [V]', 'FontSize', text_font);
    title(soc + "% SOC");
    grid on;

    ylim([3.1, 3.45]);

    i = i+1;
end

for soc = soc_levels
    subplot(2,3,i);
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    plot(pulse_data.(name_LIN).Tcold, '-', 'Color', [0, 0, 1], ... % Blue for cold
            'LineWidth', 2, 'DisplayName', 'Linear Cold'); hold on;
    
    plot(pulse_data.(name_LIN).Tmean, '-', 'Color', [1, 0.5, 0], ... % Orange for mean
            'LineWidth', 2, 'DisplayName', 'Linear Mean');
    
    plot(pulse_data.(name_LIN).Thot, '-', 'Color', [1, 0, 0], ... % Red for hot
            'LineWidth', 2, 'DisplayName', 'Linear Hot');


    plot(pulse_data.(name_NL).Tcold, '-', 'Color', [0, 0, 1], ... % Blue for cold
            'LineWidth', 2, 'DisplayName', 'Nonlinear Cold'); hold on;
    
    plot(pulse_data.(name_NL).Tmean, '-', 'Color', [1, 0.5, 0], ... % Orange for mean
            'LineWidth', 2, 'DisplayName', 'Nonlinear Mean');
    
    plot(pulse_data.(name_NL).Thot, '-', 'Color', [1, 0, 0], ... % Red for hot
            'LineWidth', 2, 'DisplayName', 'Nonlinear Hot');

    
  %  legend('Linear BV', 'Nonlinear BV');
    xlabel('Time [s]', 'FontSize', text_font);
    ylabel('Voltage [V]', 'FontSize', text_font);
    title(soc + "% SOC");
    grid on;

 %   ylim([3.1, 3.45]);

    i = i+1;
end
%% Butler Volmer 
close all;
write_file = true;
% Physical dimensions (in mm)
x_dim = 145;
y_dim = 195;
t_idx = 2499;

figure('Position', [100, 100, 800, 600]); i = 1;
ttt = tiledlayout(2,3);

ttt.TileSpacing = 'tight';
for soc = soc_levels
    nexttile;
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    
    data = pulse_data.(name_LIN);
    SimT_current = data.SimT(:,:,t_idx);

    % Create meshgrid for physical dimensions
    [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
        linspace(0, y_dim, size(SimT_current, 1)));
    
    % Plot simulation surface
    contourf(x, y, SimT_current, 20, 'LineColor', 'none');
    hold on;
    [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
    colormap(cmocean('thermal'));  % Apply same colormap to first row
    clabel(C, h, 'Color', 'w', 'FontSize', 8);
    axis image off;
    title(sprintf('SOC %d%%', soc), 'FontSize', text_font);
    
    if(i==1)
        ax1 = gca;
    end
    set(gca, 'YDir','reverse');

    i = i+1;
end

for soc = soc_levels
    nexttile;
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    
    data = pulse_data.(name_NL);
    SimT_current = data.SimT(:,:,t_idx);

    % Create meshgrid for physical dimensions
    [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
        linspace(0, y_dim, size(SimT_current, 1)));
    
    % Plot simulation surface
    contourf(x, y, SimT_current, 20, 'LineColor', 'none');
    hold on;
    [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
    colormap(cmocean('thermal'));
    clabel(C, h, 'Color', 'w', 'FontSize', 8);
    axis image off;
   % title(sprintf('SOC %d%%', soc), 'FontSize', text_font);
    set(gca, 'YDir','reverse');
   if(i==4)
       ax2 = gca;
   end
    i = i+1;
end

% Add row labels using text annotations
% First row label (Linearised Butler Volmer)
annotation('textbox', [0.22, 0.51, 0.1, 0.1], 'String', 'Linearised Butler-Volmer', ...
    'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);

% Second row label (Nonlinear Butler Volmer)  
annotation('textbox', [0.22, 0.08, 0.1, 0.1], 'String', 'Nonlinear Butler-Volmer', ...
    'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);

% Add colorbar to the entire tiledlayout (right side)
cb = colorbar();
cb.Layout.Tile = 'east';  % Position colorbar on the right side
cb.Label.String = 'Temperature (°C)';
cb.Label.FontSize = text_font;

% Save figure
fig_filename = sprintf('%sButlerVolmer_pulse.fig', output_dir);
png_filename = sprintf('%sButlerVolmer_pulse.png', output_dir);
eps_filename = sprintf('%sButlerVolmer_pulse.eps', output_dir);
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
saveas(gcf, fig_filename);
print(gcf, png_filename, '-dpng', '-r1200');
print(gcf, eps_filename, '-depsc');
fprintf('Saved: %s\n', fig_filename);
fprintf('Saved: %s\n', png_filename);
end

%% Report eta values for pulse regime
% Max values: 
clc;
max(abs(pulse_data.soc30_cr10.ETAmat.data(:,2:end)))
max(abs(pulse_data.soc50_cr10.ETAmat.data(:,2:end)))
max(abs(pulse_data.soc70_cr10.ETAmat.data(:,2:end)))

mean(abs(pulse_data.soc30_cr10.ETAmat.data(:,2:end)))
mean(abs(pulse_data.soc50_cr10.ETAmat.data(:,2:end)))
mean(abs(pulse_data.soc70_cr10.ETAmat.data(:,2:end)))


%% Report eta values for CC regime
clc;
CCBV_data.ch_0_10C_4_BVnonlin = load(fullfile(results_dir, "ch_0_10C_4_BVnonlin.mat"));
CCBV_data.ch_0_10C_4_BVlin = load(fullfile(results_dir, "ch_0_10C_4.mat"));


% Max values: 
clc;
max(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))
max(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))
max(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))

% mean(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))
% mean(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))
% mean(abs(CCBV_data.ch_0_10C_4_BVnonlin.ETAmat.data(:,2:end)))


%% CCBV contour plots (Linear vs Nonlinear)
close all;
write_file = true;
t_idx = 340;

% Reuse physical dimensions and time index from earlier section: x_dim, y_dim, t_idx
figure('Position', [100, 100, 650, 350]);
tl = tiledlayout(1,2);
tl.TileSpacing = 'tight';

% Extract SimT for linear and nonlinear (support both top-level and nested under .data)
if isfield(CCBV_data.ch_0_10C_4_BVlin, 'SimT')
    simT_lin = CCBV_data.ch_0_10C_4_BVlin.SimT;
else
    simT_lin = CCBV_data.ch_0_10C_4_BVlin.data.SimT;
end

if isfield(CCBV_data.ch_0_10C_4_BVnonlin, 'SimT')
    simT_nonlin = CCBV_data.ch_0_10C_4_BVnonlin.SimT;
else
    simT_nonlin = CCBV_data.ch_0_10C_4_BVnonlin.data.SimT;
end

% Determine shared color limits at t_idx
SimT_lin_current = simT_lin(:,:,t_idx);
SimT_nl_current  = simT_nonlin(:,:,t_idx);
clims = [min(min(SimT_lin_current(:)), min(SimT_nl_current(:))), ...
         max(max(SimT_lin_current(:)), max(SimT_nl_current(:)))];

% Linear (left)
nexttile;
[x, y] = meshgrid(linspace(0, x_dim, size(SimT_lin_current, 2)), ...
    linspace(0, y_dim, size(SimT_lin_current, 1)));
contourf(x, y, SimT_lin_current, 20, 'LineColor', 'none'); hold on;
[C1, h1] = contour(x, y, SimT_lin_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
clabel(C1, h1, 'Color', 'w', 'FontSize', 8);
axis image off;
title('Linearised Butler-Volmer', 'FontSize', text_font);
colormap(cmocean('thermal'));
caxis(clims);
set(gca, 'YDir','reverse');


% Nonlinear (right)
nexttile;
[x, y] = meshgrid(linspace(0, x_dim, size(SimT_nl_current, 2)), ...
    linspace(0, y_dim, size(SimT_nl_current, 1)));
contourf(x, y, SimT_nl_current, 20, 'LineColor', 'none'); hold on;
[C2, h2] = contour(x, y, SimT_nl_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
clabel(C2, h2, 'Color', 'w', 'FontSize', 8);
axis image off;
title('Nonlinear Butler-Volmer', 'FontSize', text_font);
colormap(cmocean('thermal'));
caxis(clims);
set(gca, 'YDir','reverse');


% Shared colorbar at the right of tiledlayout
cb = colorbar();
cb.Layout.Tile = 'east';
cb.Label.String = 'Temperature (°C)';
cb.Label.FontSize = text_font;
annotation('textbox', [0.27, 0.15, 0.1, 0.1], 'String', 'Constant current charge', ...
    'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);


% Save figure
fig_filename = sprintf('%sButlerVolmer_CCBV.fig', output_dir);
png_filename = sprintf('%sButlerVolmer_CCBV.png', output_dir);
eps_filename = sprintf('%sButlerVolmer_CCBV.eps', output_dir);
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
saveas(gcf, fig_filename);
% print(gcf, png_filename, '-dpng', '-r1200');
% print(gcf, eps_filename, '-depsc');
export_fig(gcf, png_filename,'-r1200');
export_fig(gcf, eps_filename);

fprintf('Saved: %s\n', fig_filename);
fprintf('Saved: %s\n', png_filename);
end


%% Combined pulse + constant-current charge contours (2x4)
close all;
write_file = false;

vec = @(x) x(:);

% Use distinct time indices for pulse and CCBV sections
t_idx_pulse = 2499;   % from pulse section
t_idx_ccbv  = 340;    % from CCBV section

figure('Position', [100, 100, 800, 500]);
tl2 = tiledlayout(2,4);
tl2.TileSpacing = 'tight';

% Resolve CCBV SimT containers (support top-level or nested .data)
if isfield(CCBV_data.ch_0_10C_4_BVlin, 'SimT')
    simT_lin_ccbv = CCBV_data.ch_0_10C_4_BVlin.SimT;
else
    simT_lin_ccbv = CCBV_data.ch_0_10C_4_BVlin.data.SimT;
end
if isfield(CCBV_data.ch_0_10C_4_BVnonlin, 'SimT')
    simT_nl_ccbv = CCBV_data.ch_0_10C_4_BVnonlin.SimT;
else
    simT_nl_ccbv = CCBV_data.ch_0_10C_4_BVnonlin.data.SimT;
end

% Collect matrices for color limits
S_all = [];
for soc = soc_levels
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    S_all = [S_all; vec(pulse_data.(name_LIN).SimT(:,:,t_idx_pulse)); ...
                    vec(pulse_data.(name_NL).SimT(:,:,t_idx_pulse))]; %#ok<AGROW>
end
S_all = [S_all; vec(simT_lin_ccbv(:,:,t_idx_ccbv)); vec(simT_nl_ccbv(:,:,t_idx_ccbv))];
clims2 = [min(S_all), max(S_all)];

% Row 1: Linearised BV (SOC 30/50/70 + CCBV linear)
col_idx = 1;
for soc = soc_levels
    nexttile;
    name_NL = "soc" + soc + "_cr10";
    name_LIN = name_NL + "_linear";
    M = pulse_data.(name_LIN).SimT(:,:,t_idx_pulse);
    [x, y] = meshgrid(linspace(0, x_dim, size(M, 2)), linspace(0, y_dim, size(M, 1)));
    contourf(x, y, M, 20, 'LineColor', 'none'); hold on;
    [C, h] = contour(x, y, M, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
    clabel(C, h, 'Color', 'w', 'FontSize', 8);
    axis image off; set(gca, 'YDir','reverse');
    title(sprintf('SOC %d%%', soc), 'FontSize', text_font);
    colormap(cmocean('thermal')); clim(clims2);
    col_idx = col_idx + 1;
end

% Column 4, Row 1: CCBV linear
nexttile;
M = simT_lin_ccbv(:,:,t_idx_ccbv);
[x, y] = meshgrid(linspace(0, x_dim, size(M, 2)), linspace(0, y_dim, size(M, 1)));
contourf(x, y, M, 20, 'LineColor', 'none'); hold on;
[C, h] = contour(x, y, M, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
clabel(C, h, 'Color', 'w', 'FontSize', 8);
axis image off; set(gca, 'YDir','reverse');
title('CC charge', 'FontSize', text_font);
colormap(cmocean('thermal')); clim(clims2);

% Row 2: Nonlinear BV (SOC 30/50/70 + CCBV nonlinear)
for soc = soc_levels
    nexttile;
    name_NL = "soc" + soc + "_cr10";
    M = pulse_data.(name_NL).SimT(:,:,t_idx_pulse);
    [x, y] = meshgrid(linspace(0, x_dim, size(M, 2)), linspace(0, y_dim, size(M, 1)));
    contourf(x, y, M, 20, 'LineColor', 'none'); hold on;
    [C, h] = contour(x, y, M, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
    clabel(C, h, 'Color', 'w', 'FontSize', 8);
    axis image off; set(gca, 'YDir','reverse');
    colormap(cmocean('thermal')); caxis(clims2);
end

% Column 4, Row 2: CCBV nonlinear
nexttile;
M = simT_nl_ccbv(:,:,t_idx_ccbv);
[x, y] = meshgrid(linspace(0, x_dim, size(M, 2)), linspace(0, y_dim, size(M, 1)));
contourf(x, y, M, 20, 'LineColor', 'none'); hold on;
[C, h] = contour(x, y, M, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
clabel(C, h, 'Color', 'w', 'FontSize', 8);
axis image off; set(gca, 'YDir','reverse');
colormap(cmocean('thermal')); clim(clims2);

% Row labels via annotations
annotation('textbox', [0.22, 0.48, 0.1, 0.1], 'String', 'Linearised Butler-Volmer', ...
    'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
annotation('textbox', [0.22, 0.01, 0.1, 0.1], 'String', 'Nonlinear Butler-Volmer', ...
    'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90);
% 
% % Column title for column 4
% annotation('textbox', [0.83, 0.95, 0.1, 0.04], 'String', 'Constant current charge', ...
%     'FontSize', text_font, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
%     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% Shared colorbar at the right of tiledlayout
cb = colorbar();
cb.Layout.Tile = 'east';
cb.Label.String = 'Temperature (°C)';
cb.Label.FontSize = text_font;

% Save figure
fig_filename = sprintf('%sButlerVolmer_combined.fig', output_dir);
png_filename = sprintf('%sButlerVolmer_combined.png', output_dir);
eps_filename = sprintf('%sButlerVolmer_combined.eps', output_dir);
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
saveas(gcf, fig_filename);
print(gcf, png_filename, '-dpng', '-r1200');
print(gcf, eps_filename, '-depsc');
fprintf('Saved: %s\n', fig_filename);
fprintf('Saved: %s\n', png_filename);
end