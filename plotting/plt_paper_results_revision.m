% Plot paper results - Generic script for all SOC levels
% Loads mat files and creates plots for charge, discharge, and pulse results
% Author: Volkan Kumtepeli
clear variables; close all; clc;
addpath('../aux_fun');

% Configuration
results_dir = "../results/paper_results_" + "paper_2026_revision/";
output_dir = fullfile(results_dir, 'plots/');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Define SOC levels and C-rates
soc_levels = [30, 50, 70];
c_rates = 2:2:10;  % 2, 4, 6, 8, 10C
pulse_c_rates = [2, 4, 8];  % Pulse only has 2, 4, 8C

% Colors for different C-rates
colors = lines(length(c_rates));
pulse_colors = lines(length(pulse_c_rates));

write_file = false;

% Font settings
text_font = 14;
set(0, 'DefaultAxesFontSize', text_font);
set(0, 'DefaultAxesFontName', 'Arial');
n_square = 5;

CC_means = ["mean", "30%", "50%", "70%"];

plt_settings;
load_and_process_results;

%%
close all;
plt_CC_charge; 

%%
close all;
plt_CC_discharge;

%% 
close all; 
plt_pulse;

fprintf('\nPlotting completed! All figures saved to: %s\n', output_dir);

%% 
close all; 
plt_entropy;

%% RMSE:
print_RMSE;

%% CC plots together:
clc; close all;
write_file = true; 
plt_CC_together;




%% Pulse plots together:
close all; clc;
write_file = true;
plt_pulse_together;



%% Plot smoothed vs. not smoothed version with proper dimension annotations
close all; clc;
write_file = true;
plt_smoothed_vs_nonsmooth;


%% Charge and discharge surface plots comparison
close all; clc;
write_file = true;

% Define figure layout and parameters
x0 = 1; y0 = 1;
width = 16.3;
height = 8.5;
text_font = 14;

% Physical dimensions (in mm)
x_dim = 145;
y_dim = 195;

% C-rates for plotting
c_rates_plot = [2, 4, 6, 8, 10];

sigma = 3;

%% Charge surface plots (2x5) - Time Evolution
% First, determine global colormap limits for charge plots
ch_temp_min = inf;
ch_temp_max = -inf;
for i = 1:5
    cr = c_rates_plot(i);
    ch_key = sprintf('soc0_cr%d_4', cr);
    if isfield(ch_data, ch_key)
        data = ch_data.(ch_key);
        ch_temp_min = min(ch_temp_min, min(data.data.ExpT(:)));
        ch_temp_max = max(ch_temp_max, max(data.data.ExpT(:)));
        ch_temp_min = min(ch_temp_min, min(data.SimT(:)));
        ch_temp_max = max(ch_temp_max, max(data.SimT(:)));
    end
end

% Time evolution loop for charge plots
fig_ch = figure('Units', 'inches', ...
    'Position', [2 2 (x0 + width) (y0 + height)], ...
    'PaperPositionMode', 'auto');
ha_ch = tight_subplot(2, 5, [0.02, 0.07], [0.13, 0.02], [0.047, 0.1]);

for t_now = 1:50:2500
    
    
    % Create tight subplots: 2 rows, 5 columns
    
    % Row 1: Experimental surface plots
    for i = 1:5
        cr = c_rates_plot(i);
        
        % Find the charge data for this C-rate (use first available file)
        ch_key = sprintf('soc0_cr%d_4', cr);
        if isfield(ch_data, ch_key)
            data = ch_data.(ch_key);
            
            % Get experimental surface data at current time step (with saturation)
            t_idx = min(t_now, size(data.data.ExpT, 3));
            ExpT_current = data.data.ExpT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
                linspace(0, y_dim, size(ExpT_current, 1)));
            
            ExpT_current_smooth = imgaussfilt(ExpT_current, sigma);
            
            % Plot experimental surface
            axes(ha_ch(i));
            contourf(x, y, ExpT_current_smooth, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, ExpT_current_smooth, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Experimental %dC (t=%d)', cr, t_now), 'FontSize', text_font);
            hold off;
        end
    end
    
    % Row 2: Simulation surface plots
    for i = 1:5
        cr = c_rates_plot(i);
        
        % Find the charge data for this C-rate (use first available file)
        ch_key = sprintf('soc0_cr%d_4', cr);
        if isfield(ch_data, ch_key)
            data = ch_data.(ch_key);
            
            % Get simulation surface data at current time step (with saturation)
            t_idx = min(t_now, size(data.SimT, 3));
            SimT_current = data.SimT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
                linspace(0, y_dim, size(SimT_current, 1)));
            
            % Plot simulation surface
            axes(ha_ch(i+5));
            contourf(x, y, SimT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Simulation %dC (t=%d)', cr, t_now), 'FontSize', text_font);
        end
    end
    
    % Add common colorbar for charge plots
    cb_ch = colorbar;
    cb_ch.Position = [0.92, 0.12, 0.02, 0.76];
    cb_ch.FontSize = text_font;
    cb_ch.Label.String = 'Temperature (°C)';
    
    % Set colormap and limits for charge plots
    colormap(cmocean('thermal'));
    caxis([ch_temp_min, ch_temp_max]);
    
    % Add overall title
    sgtitle(sprintf('Charge Surface Plots Comparison - Time Step %d', t_now), 'FontSize', text_font + 2);
    
    % Save charge figure
    % if(write_file)
    %     save_plt(gcf, output_dir, sprintf("Charge_Surface_Comparison_t%d", t_now));
    % end
    
    % Close figure to save memory
    %  close(fig_ch);
end

%% Discharge surface plots (2x5) - Time Evolution
% First, determine global colormap limits for discharge plots
dch_temp_min = inf;
dch_temp_max = -inf;
for i = 1:5
    cr = c_rates_plot(i);
    dch_key = sprintf('soc100_cr%d_4', cr);
    if isfield(dch_data, dch_key)
        data = dch_data.(dch_key);
        dch_temp_min = min(dch_temp_min, min(data.data.ExpT(:)));
        dch_temp_max = max(dch_temp_max, max(data.data.ExpT(:)));
        dch_temp_min = min(dch_temp_min, min(data.SimT(:)));
        dch_temp_max = max(dch_temp_max, max(data.SimT(:)));
    end
end

% Time evolution loop for discharge plots
for t_now = 1:50:2500
    fig_dch = figure('Units', 'inches', ...
        'Position', [2 2 (x0 + width) (y0 + height)], ...
        'PaperPositionMode', 'auto');
    
    % Create tight subplots: 2 rows, 5 columns
    ha_dch = tight_subplot(2, 5, [0.02, 0.07], [0.13, 0.02], [0.047, 0.1]);
    
    % Row 1: Experimental surface plots
    for i = 1:5
        cr = c_rates_plot(i);
        
        % Find the discharge data for this C-rate (use first available file)
        dch_key = sprintf('soc100_cr%d_4', cr);
        if isfield(dch_data, dch_key)
            data = dch_data.(dch_key);
            
            % Get experimental surface data at current time step (with saturation)
            t_idx = min(t_now, size(data.data.ExpT, 3));
            ExpT_current = data.data.ExpT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
                linspace(0, y_dim, size(ExpT_current, 1)));
            
            % Plot experimental surface
            axes(ha_dch(i));
            contourf(x, y, ExpT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, ExpT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Experimental %dC (t=%d)', cr, t_now), 'FontSize', text_font);
        end
    end
    
    % Row 2: Simulation surface plots
    for i = 1:5
        cr = c_rates_plot(i);
        
        % Find the discharge data for this C-rate (use first available file)
        dch_key = sprintf('soc100_cr%d_4', cr);
        if isfield(dch_data, dch_key)
            data = dch_data.(dch_key);
            
            % Get simulation surface data at current time step (with saturation)
            t_idx = min(t_now, size(data.SimT, 3));
            SimT_current = data.SimT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
                linspace(0, y_dim, size(SimT_current, 1)));
            
            % Plot simulation surface
            axes(ha_dch(i+5));
            contourf(x, y, SimT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Simulation %dC (t=%d)', cr, t_now), 'FontSize', text_font);
        end
    end
    
    % Add common colorbar for discharge plots
    cb_dch = colorbar;
    cb_dch.Position = [0.92, 0.12, 0.02, 0.76];
    cb_dch.FontSize = text_font;
    cb_dch.Label.String = 'Temperature (°C)';
    
    % Set colormap and limits for discharge plots
    colormap(cmocean('thermal'));
    caxis([dch_temp_min, dch_temp_max]);
    
    % Add overall title
    sgtitle(sprintf('Discharge Surface Plots Comparison - Time Step %d', t_now), 'FontSize', text_font + 2);
    
    % Save discharge figure
    if(write_file)
        save_plt(gcf, output_dir, sprintf("Discharge_Surface_Comparison_t%d", t_now));
    end
    
    % Close figure to save memory
    close(fig_dch);
end

%% Individual C-rate Charge Comparisons - Time Evolution
close all;
% Create individual sections for each C-rate charge comparison
for cr_idx = length(c_rates_plot):length(c_rates_plot)
    cr = c_rates_plot(cr_idx);
    
    % Determine colormap limits for this specific C-rate
    ch_key = sprintf('soc0_cr%d_4', cr);
    if isfield(ch_data, ch_key)
        data = ch_data.(ch_key);
        cr_temp_min = min(min(data.data.ExpT(:)), min(data.SimT(:)));
        cr_temp_max = max(max(data.data.ExpT(:)), max(data.SimT(:)));
        fig_cr_ch = figure('Units', 'inches', ...
            'Position', [2 2 8 4], ...
            'PaperPositionMode', 'auto');
        % Time evolution loop for this C-rate
        for t_now = 250
            
            
            % Create 1x2 subplot layout
            subplot(1, 2, 1);
            
            % Get experimental data at current time step
            t_idx = min(t_now, size(data.data.ExpT, 3));
            ExpT_current = data.data.ExpT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
                linspace(0, y_dim, size(ExpT_current, 1)));
            
            ExpT_current_smooth = imgaussfilt(ExpT_current, sigma);
            
            % Plot experimental surface
            contourf(x, y, ExpT_current_smooth, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, ExpT_current_smooth, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Experimental %dC Charge (t=%d)', cr, t_now), 'FontSize', text_font);
            colorbar;
            caxis([cr_temp_min, cr_temp_max]);
            
            subplot(1, 2, 2);
            
            % Get simulation data at current time step
            t_idx = min(t_now, size(data.SimT, 3));
            SimT_current = data.SimT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
                linspace(0, y_dim, size(SimT_current, 1)));
            
            % Plot simulation surface
            contourf(x, y, SimT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Simulation %dC Charge (t=%d)', cr, t_now), 'FontSize', text_font);
            colorbar;
            caxis([cr_temp_min, cr_temp_max]);
            
            % Set colormap
            colormap(cmocean('thermal'));
            
            % Add overall title
            sgtitle(sprintf('%dC Charge Comparison - Time Step %d', cr, t_now), 'FontSize', text_font + 2);
            
            % Save figure
            if(write_file)
                save_plt(gcf, output_dir, sprintf("%dC_Charge_Comparison_t%d", cr, t_now));
            end
            
            % % Close figure to save memory
            % close(fig_cr_ch);
            pause(0.1);
        end
    end
end

%% Individual C-rate Discharge Comparisons - Time Evolution
% Create individual sections for each C-rate discharge comparison
for cr_idx = 1:length(c_rates_plot)
    cr = c_rates_plot(cr_idx);
    
    % Determine colormap limits for this specific C-rate
    dch_key = sprintf('soc100_cr%d_4', cr);
    if isfield(dch_data, dch_key)
        data = dch_data.(dch_key);
        cr_temp_min = min(min(data.data.ExpT(:)), min(data.SimT(:)));
        cr_temp_max = max(max(data.data.ExpT(:)), max(data.SimT(:)));
        
        % Time evolution loop for this C-rate
        for t_now = 1:50:2500
            fig_cr_dch = figure('Units', 'inches', ...
                'Position', [2 2 8 4], ...
                'PaperPositionMode', 'auto');
            
            % Create 1x2 subplot layout
            subplot(1, 2, 1);
            
            % Get experimental data at current time step
            t_idx = min(t_now, size(data.data.ExpT, 3));
            ExpT_current = data.data.ExpT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
                linspace(0, y_dim, size(ExpT_current, 1)));
            
            % Plot experimental surface
            contourf(x, y, ExpT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, ExpT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Experimental %dC Discharge (t=%d)', cr, t_now), 'FontSize', text_font);
            colorbar;
            caxis([cr_temp_min, cr_temp_max]);
            
            subplot(1, 2, 2);
            
            % Get simulation data at current time step
            t_idx = min(t_now, size(data.SimT, 3));
            SimT_current = data.SimT(:,:,t_idx);
            
            % Create meshgrid for physical dimensions
            [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
                linspace(0, y_dim, size(SimT_current, 1)));
            
            % Plot simulation surface
            contourf(x, y, SimT_current, 20, 'LineColor', 'none');
            hold on;
            [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('Simulation %dC Discharge (t=%d)', cr, t_now), 'FontSize', text_font);
            colorbar;
            caxis([cr_temp_min, cr_temp_max]);
            
            % Set colormap
            colormap(cmocean('thermal'));
            
            % Add overall title
            sgtitle(sprintf('%dC Discharge Comparison - Time Step %d', cr, t_now), 'FontSize', text_font + 2);
            
            % Save figure
            if(write_file)
                save_plt(gcf, output_dir, sprintf("%dC_Discharge_Comparison_t%d", cr, t_now));
            end
            
            % Close figure to save memory
            close(fig_cr_dch);
        end
    end
end

%% Temperature Evolution Video Creation
close all;
fprintf('Creating temperature evolution video...\n');

% Select one C-rate for the video (10C for maximum effect)
cr_video = 10;
ch_key = sprintf('soc0_cr%d_4', cr_video);
dch_key = sprintf('soc100_cr%d_4', cr_video);

% Check if data exists
if isfield(ch_data, ch_key) && isfield(dch_data, dch_key)
    ch_data_video = ch_data.(ch_key);
    dch_data_video = dch_data.(dch_key);
    
    % Determine colormap limits for video
    video_temp_min = min(min(ch_data_video.data.ExpT(:)), min(ch_data_video.SimT(:)));
    video_temp_max = max(max(ch_data_video.data.ExpT(:)), max(ch_data_video.SimT(:)));
    video_temp_min = min(video_temp_min, min(dch_data_video.data.ExpT(:)));
    video_temp_max = max(video_temp_max, max(dch_data_video.SimT(:)));
    
    % Create figure for video
    fig_video = figure('Units', 'inches', ...
        'Position', [2 2 12 5], ...
        'PaperPositionMode', 'auto');
    
    % Create 1x2 subplot layout
    subplot(1, 2, 1);
    title('Charge Process', 'FontSize', text_font + 2);
    subplot(1, 2, 2);
    title('Discharge Process', 'FontSize', text_font + 2);
    
    % Set up video writer
    video_filename = fullfile(output_dir, sprintf('Temperature_Evolution_%dC.mp4', cr_video));
    v = VideoWriter(video_filename, 'MPEG-4');
    v.FrameRate = 10; % 10 fps for 10-15 second video
    v.Quality = 95;
    open(v);
    
    % Calculate total frames for 10-15 second video
    total_time_steps = 2500;
    frames_per_second = 10;
    target_duration = 12; % seconds
    frame_interval = max(1, round(total_time_steps / (frames_per_second * target_duration)));
    
    % Time evolution loop for video
    for t_now = 1:frame_interval:total_time_steps
        % Clear previous plots
        clf;
        
        % Create 1x2 subplot layout
        subplot(1, 2, 1);
        
        % Get charge data at current time step
        t_idx = min(t_now, size(ch_data_video.data.ExpT, 3));
        ExpT_ch_current = ch_data_video.data.ExpT(:,:,t_idx);
        SimT_ch_current = ch_data_video.SimT(:,:,min(t_now, size(ch_data_video.SimT, 3)));
        
        % Create meshgrid for physical dimensions
        [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_ch_current, 2)), ...
            linspace(0, y_dim, size(ExpT_ch_current, 1)));
        
        % Plot charge experimental surface
        ExpT_ch_smooth = imgaussfilt(ExpT_ch_current, sigma);
        contourf(x, y, ExpT_ch_smooth, 20, 'LineColor', 'none');
        hold on;
        [C, h] = contour(x, y, ExpT_ch_smooth, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 10);
        axis image off;
        title(sprintf('Charge - Experimental %dC (t=%d s)', cr_video, t_now), 'FontSize', text_font);
        colorbar;
        caxis([video_temp_min, video_temp_max]);
        
        subplot(1, 2, 2);
        
        % Get discharge data at current time step
        t_idx = min(t_now, size(dch_data_video.data.ExpT, 3));
        ExpT_dch_current = dch_data_video.data.ExpT(:,:,t_idx);
        SimT_dch_current = dch_data_video.SimT(:,:,min(t_now, size(dch_data_video.SimT, 3)));
        
        % Create meshgrid for physical dimensions
        [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_dch_current, 2)), ...
            linspace(0, y_dim, size(ExpT_dch_current, 1)));
        
        % Plot discharge experimental surface
        ExpT_dch_smooth = imgaussfilt(ExpT_dch_current, sigma);
        contourf(x, y, ExpT_dch_smooth, 20, 'LineColor', 'none');
        hold on;
        [C, h] = contour(x, y, ExpT_dch_smooth, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 10);
        axis image off;
        title(sprintf('Discharge - Experimental %dC (t=%d s)', cr_video, t_now), 'FontSize', text_font);
        colorbar;
        caxis([video_temp_min, video_temp_max]);
        
        % Set colormap
        colormap(cmocean('thermal'));
        
        % Add overall title
        sgtitle(sprintf('Temperature Evolution - %dC Rate (Time: %d s)', cr_video, t_now), 'FontSize', text_font + 2);
        
        % Capture frame
        frame = getframe(fig_video);
        writeVideo(v, frame);
        
        % Display progress
        if mod(t_now, 100) == 0
            fprintf('Processing frame at time step %d/%d\n', t_now, total_time_steps);
        end
    end
    
    % Close video writer
    close(v);
    close(fig_video);
    
    fprintf('Video saved as: %s\n', video_filename);
    fprintf('Video duration: ~%.1f seconds\n', target_duration);
else
    fprintf('Warning: Data not found for C-rate %d. Skipping video creation.\n', cr_video);
end

%% Videos: 2x5 Charge and Discharge Surface Plots
close all; clc;
fprintf('Creating 2x5 surface plot videos (charge and discharge)...\n');

% Common settings
fps = 25;                 % frames per second
target_duration = 12;     % seconds
TMAX = 1900;              % max time index
frame_interval = 1;% max(1, round(TMAX / (fps * target_duration)));

% Physical dimensions (ensure defined)
% x_dim, y_dim, c_rates_plot, sigma, text_font assumed defined above

%=============================
% Charge 2x5 video
%=============================
% Determine global colormap limits for charge
ch_temp_min = inf; ch_temp_max = -inf;
for i = 1:5
    cr = c_rates_plot(i);
    ch_key = sprintf('soc0_cr%d_4', cr);
    if isfield(ch_data, ch_key)
        data = ch_data.(ch_key);
        ch_temp_min = 19;%min([ch_temp_min, min(data.data.ExpT(:)), min(data.SimT(:))]);
        ch_temp_max = 32;%max([ch_temp_max, max(data.data.ExpT(:)), max(data.SimT(:,:,end-1),[],'all')]);
    end
end

fig_ch_vid = figure('Units', 'inches', ...
    'Position', [2 2 16 9], ...
    'PaperPositionMode', 'auto');
ha_ch = tight_subplot(2, 5, [0.02, 0.07], [0.02, 0.01], [0.047, 0.1]);

vw_ch = VideoWriter(fullfile(output_dir, 'Charge_Surface_2x5.mp4'), 'MPEG-4');
vw_ch.FrameRate = fps; vw_ch.Quality = 95; open(vw_ch);

for t_now = 1:frame_interval:TMAX
    % Row 1: Experimental
    for i = 1:5
        cr = c_rates_plot(i);
        ch_key = sprintf('soc0_cr%d_4', cr);
        if isfield(ch_data, ch_key)
            data = ch_data.(ch_key);
            t_idx = min(t_now, size(data.data.ExpT, 3));
            if(t_idx<t_now)
                continue;
            end
            ExpT_current = data.data.ExpT(:,:,t_idx);
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
                linspace(0, y_dim, size(ExpT_current, 1)));
            ExpT_s = imgaussfilt(ExpT_current, sigma);
            axes(ha_ch(i)); cla(ha_ch(i));
            contourf(x, y, ExpT_s, 20, 'LineColor', 'none'); hold on;
            clim([ch_temp_min, ceil(ch_temp_max)]); hold on;
            [C, h] = contour(x, y, ExpT_s, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
            clabel(C, h, 'Color', 'k', 'FontSize', 8);
            axis image off;
            title(sprintf('%2.0fC experimental (t=%d s)', cr, t_idx), 'FontSize', text_font);
        end
    end
    % Row 2: Simulation
    for i = 1:5
        cr = c_rates_plot(i);
        ch_key = sprintf('soc0_cr%d_4', cr);
        data = ch_data.(ch_key);
        t_idx = min(t_now, size(data.SimT, 3)-1); %-1 is due to we have more SimT.
        if(t_idx<t_now)
            continue;
        end
        
        SimT_current = data.SimT(:,:,t_idx);
        [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
            linspace(0, y_dim, size(SimT_current, 1)));
        axes(ha_ch(i+5)); cla(ha_ch(i+5));
        contourf(x, y, SimT_current, 20, 'LineColor', 'none');
        clim([ch_temp_min, ceil(ch_temp_max)]); hold on;
        [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 8);
        axis image off;
        
        title(sprintf('%2.0fC simulation (t=%d s)', cr, t_idx), 'FontSize', text_font);
    end
    % Shared colorbar and colormap
    
    % Overall titl
    
    % sgt = sgtitle(sprintf('Charge Surface Plots Comparison'), 'FontSize', text_font + 2,);
    % Write frame
    
    if(t_now==1)
        sgt = annotation('textbox',[0.15 0.9 0.1 0.1],'String','Charge surface plots comparison','EdgeColor','none',...
            'FontSize', text_font+2, 'FitBoxToText','on');
        colormap(cmocean('thermal'));
        cb = colorbar('Position', [0.94, 0.013, 0.02, 0.89]);
        cb.FontSize = text_font; cb.Label.String = 'Temperature (°C)';
        cb.Limits = [ch_temp_min, ceil(ch_temp_max)];%
        %If this is the initial then fix the sizing:
        
        ha_ch(1).Position(1) = 0.01;
        ha_ch(6).Position(1) = 0.01;
        for iihj=1:5
            ha_ch(iihj).Position([2,3]) = [0.46, 0.172];
            ha_ch(iihj+5).Position([2,3]) = [-0.02, 0.172];
            set(ha_ch(iihj), 'YDir','reverse'); % Due to contourf;
            set(ha_ch(iihj+5), 'YDir','reverse'); % Due to contourf;
        end
        
        for iihj=2:5
            ha_ch(iihj).Position(1)   = ha_ch(iihj-1).Position(1) + ha_ch(iihj-1).Position(3) + 0.015;
            ha_ch(iihj+5).Position(1) = ha_ch(iihj+5-1).Position(1) + ha_ch(iihj+5-1).Position(3) + 0.015;
            
            %       ha_ch(iihj+5).Position([2,3]) = [-0.02, 0.17];
        end
        
        sgt.Position(1) = sum(ha_ch(iihj+5).Position([1,3]))/2 - sgt.Position(3)/2;
        
    end
    
    
    writeVideo(vw_ch, getframe(fig_ch_vid));
end
close(vw_ch);
%%
% Common settings
fps = 25;                 % frames per second
target_duration = 12;     % seconds
TMAX = 1900;              % max time index
frame_interval = 1;% max(1, round(TMAX / (fps * target_duration)));


%=============================
% Discharge 2x5 video
%=============================
% Determine global colormap limits for discharge
dch_temp_min = inf; dch_temp_max = -inf;
for i = 1:5
    cr = c_rates_plot(i);
    dch_key = sprintf('soc100_cr%d_4', cr);
    if isfield(dch_data, dch_key)
        data = dch_data.(dch_key);
        dch_temp_min = 20;%min([dch_temp_min, min(data.data.ExpT(:)), min(data.SimT(:))]);
        dch_temp_max = 32;%max([dch_temp_max, max(data.data.ExpT(:)), max(data.SimT(:))]);
    end
end

fig_dch_vid = figure('Units', 'inches', ...
    'Position', [2 2 16 9], ...
    'PaperPositionMode', 'auto');
ha_dch = tight_subplot(2, 5, [0.02, 0.07], [0.02, 0.01], [0.047, 0.1]);

vw_dch = VideoWriter(fullfile(output_dir, 'Discharge_Surface_2x5.mp4'), 'MPEG-4');
vw_dch.FrameRate = fps; vw_dch.Quality = 95; open(vw_dch);

for t_now = 1:frame_interval:TMAX
    % Row 1: Experimental
    for i = 1:5
        cr = c_rates_plot(i);
        dch_key = sprintf('soc100_cr%d_4', cr);
        data = dch_data.(dch_key);
        t_idx = min(t_now, size(data.data.ExpT, 3));
        if(t_idx<t_now)
            continue;
        end
        ExpT_current = data.data.ExpT(:,:,t_idx);
        [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_current, 2)), ...
            linspace(0, y_dim, size(ExpT_current, 1)));
        axes(ha_dch(i)); cla(ha_dch(i));
        ExpT_s = imgaussfilt(ExpT_current, sigma);
        contourf(x, y, ExpT_s, 20, 'LineColor', 'none'); hold on;
        clim([dch_temp_min, ceil(dch_temp_max)]); hold on;
        [C, h] = contour(x, y, ExpT_s, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 8);
        axis image off;
        title(sprintf('%2.0fC experimental (t=%d s)', cr, t_idx), 'FontSize', text_font);
    end
    % Row 2: Simulation
    for i = 1:5
        cr = c_rates_plot(i);
        dch_key = sprintf('soc100_cr%d_4', cr);
        data = dch_data.(dch_key);
        t_idx = min(t_now, size(data.SimT, 3));
        if(t_idx<t_now)
            continue;
        end
        SimT_current = data.SimT(:,:,t_idx);
        [x, y] = meshgrid(linspace(0, x_dim, size(SimT_current, 2)), ...
            linspace(0, y_dim, size(SimT_current, 1)));
        axes(ha_dch(i+5)); cla(ha_dch(i+5));
        contourf(x, y, SimT_current, 20, 'LineColor', 'none'); hold on;
        clim([dch_temp_min, ceil(dch_temp_max)]); hold on;
        [C, h] = contour(x, y, SimT_current, 5, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 8);
        axis image off;
        title(sprintf('%2.0fC simulation (t=%d s)', cr, t_idx), 'FontSize', text_font);
    end
    
    % Align axes positions on first frame to match charge layout
    if(t_now==1)
        % Shared colorbar and colormap
        colormap(cmocean('thermal'));
        cb = colorbar('Position', [0.94, 0.013, 0.02, 0.89]);
        cb.FontSize = text_font; cb.Label.String = 'Temperature (°C)';
        cb.Limits = [dch_temp_min, ceil(dch_temp_max)];
        % Overall title
        sgt = annotation('textbox',[0.15 0.9 0.1 0.1],'String','Discharge surface plots comparison','EdgeColor','none',...
            'FontSize', text_font+2, 'FitBoxToText','on');
        ha_dch(1).Position(1) = 0.01;
        ha_dch(6).Position(1) = 0.01;
        for iihj=1:5
            ha_dch(iihj).Position([2,3]) = [0.46, 0.172];
            ha_dch(iihj+5).Position([2,3]) = [-0.02, 0.172];
            set(ha_dch(iihj), 'YDir','reverse'); % Due to contourf;
            set(ha_dch(iihj+5), 'YDir','reverse'); % Due to contourf;
        end
        for iihj=2:5
            ha_dch(iihj).Position(1)   = ha_dch(iihj-1).Position(1) + ha_dch(iihj-1).Position(3) + 0.015;
            ha_dch(iihj+5).Position(1) = ha_dch(iihj+5-1).Position(1) + ha_dch(iihj+5-1).Position(3) + 0.015;
        end
        sgt.Position(1) = sum(ha_dch(iihj+5).Position([1,3]))/2 - sgt.Position(3)/2;
        
    end
    % Write frame
    writeVideo(vw_dch, getframe(fig_dch_vid));
end
close(vw_dch);

fprintf('Saved videos:\n - %s\n - %s\n', fullfile(output_dir, 'Charge_Surface_2x5.mp4'), fullfile(output_dir, 'Discharge_Surface_2x5.mp4'));

%% Charge Temperature Contours at Different Time Snapshots
close all;
fprintf('\nCreating Charge Temperature Contours at Different Time Snapshots...\n');

% Define common variables (same as video section)
sigma = 3;
x_dim = 15;
y_dim = 20;
c_rates_plot = [2, 4, 6, 8, 10];
text_font = 13;

% Create 5x4 subplot for charge data
figure('Position', [50, 50, 570, 950]);
ha_ch_snap = tight_subplot(5, 4, [0.02, 0.05], [0.02, 0.02], [0.04, 0.02]);

% Define time snapshots (25%, 50%, 75%, 100% of total time)
time_percentages = [0.25, 0.50, 0.75, 1.0];

% Process each C-rate (rows: 2C, 4C, 6C, 8C, 10C)
for row = 1:5
    cr = c_rates_plot(row); % 2, 4, 6, 8, 10C
    
    % Find charge data for this C-rate (SOC=0)
    ch_key = sprintf('soc0_cr%d_4', cr); % Using parameter set 4 like in video
    data = ch_data.(ch_key);
    
    % Get total experimental time length
    total_time_steps = size(data.data.ExpT, 3);
    
    % Process each time snapshot (columns: 25%, 50%, 75%, 100%)
    for col = 1:4
        time_percent = time_percentages(col);
        time_idx = round(total_time_steps * time_percent);
        time_idx = max(1, min(time_idx, total_time_steps)); % Ensure valid index

        idx_1 = round(total_time_steps * time_percentages(1));
        
        % Get current experimental temperature data
        ExpT_current = data.data.ExpT(:,:,time_idx);
        
        % Apply smoothing with sigma = 3
        ExpT_s = imgaussfilt(ExpT_current, sigma);
        
        % Create meshgrid for plotting
        [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_s, 2)), ...
            linspace(0, y_dim, size(ExpT_s, 1)));
        
        % Get subplot index
        subplot_idx = (row-1)*4 + col;
        axes(ha_ch_snap(subplot_idx));

        xticks(0:3:19);
        
        if(col==1)
            ha_ch_snap(subplot_idx).Position(1) = 0.07;
        end
        % Create contour plot
        contourf(x, y, ExpT_s, 20, 'LineColor', 'none');
        hold on;
        
        % Add contour lines with 0.3°C spacing
        temp_range = max(ExpT_s(:)) - min(ExpT_s(:));
        contour_levels = min(ExpT_s(:)):0.3:max(ExpT_s(:));
        [C, h] = contour(x, y, ExpT_s, contour_levels, 'LineColor', 'w', 'LineWidth', 1, 'LabelFormat', '%0.1f °C');
        clabel(C, h, 'Color', 'k', 'FontSize', 8);

        % Set colormap and limits
        colormap(cmocean('thermal'));
        temp_min = min(data.data.ExpT(:,:,idx_1:end),[],'all');
        temp_max = max(data.data.ExpT(:,:,idx_1:end),[],'all');
        clim([temp_min, temp_max]);
        
        % Add colorbar for each row
        if col == 4
            cb = colorbar('Position', [0.89, 0.843-(row-1)*0.2, 0.02, 0.13]);
            cb.FontSize = text_font-1;
            cb.Label.String = 'Temperature (°C)';
        end
        
        % Set axis properties
        axis image;
        set(gca, 'YDir', 'reverse'); % Due to contourf
        
        % Add labels for first column only
        if col == 1
            ylabel(sprintf('z (cm) - %dC', cr), 'FontSize', text_font-1);
        end
        
        % Add xlabel for last row only
      %  if row == 5
            xlabel('x (cm)', 'FontSize', text_font-1);
      %  end
        
        % Add title with time information
        title(sprintf('t=%d s', time_idx), 'FontSize', text_font-1);
        ha_ch_snap(subplot_idx).Position([2,3]) = [0.82-(row-1)*0.2, 0.16];

    end
end

% Set horizontal spacing for columns 2-4
for row = 1:5
    for col = 2:4
        subplot_idx = (row-1)*4 + col;
        prev_subplot_idx = (row-1)*4 + col - 1;
        ha_ch_snap(subplot_idx).Position(1) = ha_ch_snap(prev_subplot_idx).Position(1) + ha_ch_snap(prev_subplot_idx).Position(3) + 0.052;
        ha_ch_snap(subplot_idx).YTickLabel = ha_ch_snap(subplot_idx).YTickLabel(end:-1:1);
    end
end

% Save figure
if write_file
    fig_filename = fullfile(output_dir, 'charge_temperature_snapshots.fig');
    png_filename = fullfile(output_dir, 'charge_temperature_snapshots.png');
    saveas(gcf, fig_filename);
    print(gcf, png_filename, '-dpng', '-r600');
    fprintf('Saved: %s\n', fig_filename);
    fprintf('Saved: %s\n', png_filename);
end

%% Discharge Temperature Contours at Different Time Snapshots
close all;
fprintf('\nCreating Discharge Temperature Contours at Different Time Snapshots...\n');

% Create 5x4 subplot for discharge data
figure('Position', [100, 100, 700, 1000]);
ha_dch_snap = tight_subplot(5, 4, [0.02, 0.05], [0.02, 0.02], [0.04, 0.02]);

% Process each C-rate (rows: 2C, 4C, 6C, 8C, 10C)
for row = 1:5
    cr = c_rates_plot(row); % 2, 4, 6, 8, 10C
    
    % Find discharge data for this C-rate (SOC=100)
    dch_key = sprintf('soc100_cr%d_4', cr); % Using parameter set 4 like in video
    
    if isfield(dch_data, dch_key)
        data = dch_data.(dch_key);
        
        % Get total experimental time length
        total_time_steps = size(data.data.ExpT, 3);
        
        % Process each time snapshot (columns: 25%, 50%, 75%, 100%)
        for col = 1:4
            time_percent = time_percentages(col);
            time_idx = round(total_time_steps * time_percent);
            time_idx = max(1, min(time_idx, total_time_steps)); % Ensure valid index
            
            % Get current experimental temperature data
            ExpT_current = data.data.ExpT(:,:,time_idx);
            
            % Apply smoothing with sigma = 3
            ExpT_s = imgaussfilt(ExpT_current, sigma);
            
            % Create meshgrid for plotting
            [x, y] = meshgrid(linspace(0, x_dim, size(ExpT_s, 2)), ...
                linspace(0, y_dim, size(ExpT_s, 1)));
            
            % Get subplot index
            subplot_idx = (row-1)*4 + col;
            axes(ha_dch_snap(subplot_idx));
            
            % Create contour plot
            contourf(x, y, ExpT_s, 20, 'LineColor', 'none');
            hold on;
            
            % Add contour lines with 0.3°C spacing
            temp_range = max(ExpT_s(:)) - min(ExpT_s(:));
            contour_levels = min(ExpT_s(:)):0.3:max(ExpT_s(:));
            [C, h] = contour(x, y, ExpT_s, contour_levels, 'LineColor', 'w', 'LineWidth', 0.5);
            
            % Set colormap and limits
            colormap(cmocean('thermal'));
            temp_min = min(ExpT_s(:));
            temp_max = max(ExpT_s(:));
            clim([temp_min, temp_max]);
            
            % Add colorbar for each row
            if col == 4
                cb = colorbar('Position', [0.95, 0.8-(row-1)*0.16, 0.02, 0.12]);
                cb.FontSize = text_font-2;
                cb.Label.String = 'Temperature (°C)';
            end
            
            % Set axis properties
            axis image off;
            set(gca, 'YDir', 'reverse'); % Due to contourf
            
            % Add title with time information
            title(sprintf('%dC (t=%d s)', cr, time_idx), 'FontSize', text_font-1);
        end
    else
        % If data not found, create empty subplots
        for col = 1:4
            subplot_idx = (row-1)*4 + col;
            axes(ha_dch_snap(subplot_idx));
            axis off;
            title(sprintf('%dC (No Data)', cr), 'FontSize', text_font-1);
        end
    end
end

% Manual spacing adjustment like in video section
% Set initial positions for first column
ha_dch_snap(1).Position(1) = 0.01;
ha_dch_snap(5).Position(1) = 0.01;
ha_dch_snap(9).Position(1) = 0.01;
ha_dch_snap(13).Position(1) = 0.01;
ha_dch_snap(17).Position(1) = 0.01;

% Set height and width for all subplots
for row = 1:5
    for col = 1:4
        subplot_idx = (row-1)*4 + col;
        ha_dch_snap(subplot_idx).Position([2,3]) = [0.8-(row-1)*0.16, 0.15];
        set(ha_dch_snap(subplot_idx), 'YDir', 'reverse'); % Due to contourf
    end
end

% Set horizontal spacing for columns 2-4
for row = 1:5
    for col = 2:4
        subplot_idx = (row-1)*4 + col;
        prev_subplot_idx = (row-1)*4 + col - 1;
        ha_dch_snap(subplot_idx).Position(1) = ha_dch_snap(prev_subplot_idx).Position(1) + ha_dch_snap(prev_subplot_idx).Position(3) + 0.02;
    end
end

% Add overall title
sgtitle('Discharge Temperature Contours at Different Time Snapshots', 'FontSize', text_font+2);

% Save figure
if write_file
    fig_filename = fullfile(output_dir, 'discharge_temperature_snapshots.fig');
    png_filename = fullfile(output_dir, 'discharge_temperature_snapshots.png');
    saveas(gcf, fig_filename);
    print(gcf, png_filename, '-dpng', '-r600');
    fprintf('Saved: %s\n', fig_filename);
    fprintf('Saved: %s\n', png_filename);
end

fprintf('\nCompleted temperature snapshot plots for both charge and discharge.\n');

