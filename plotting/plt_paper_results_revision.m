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

rmse =  @(x,y) sqrt(mean((x-y).^2, "all"));

% Colors:
dark_red = [134, 35, 52]/255; % Howie Chu's red.
dark_green = [119, 170, 47]/255;
dark_blue  = [13, 34, 70]/255;

elo_purple = [63, 40, 171]/255;
elo_cyan   = [66, 190, 186]/255;
elo_yellow = [249, 201, 21]/255;

Lin_blue = [18, 112, 184]/255;
Lin_red  = [160, 50, 50]/255;
Lin_dark_red = [72, 16, 27]/255;
Lin_dark_blue = [39, 51, 111]/255;

%
pulse_data = struct();
pulse_files_found = {};

% Load all available pulse files
for soc = soc_levels
    for cr = pulse_c_rates
        filename = sprintf('%spulse_%d_%dC.mat', results_dir, soc, cr);
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

ch_data = struct();
ch_files_found = {};

% Load all available charge files
for soc = 0
    for cr = c_rates
        lst = dir(sprintf('%sch_%d_%dC_*.mat', results_dir, soc, cr));
        for i_lst = 1:length(lst)
            filename = fullfile(lst(i_lst).folder, lst(i_lst).name);
            fprintf('Loading: %s\n', lst(i_lst).name);
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
            
            temp_name = sprintf('soc%d_cr%d_%d', soc, cr, i_lst);
            ch_data.(temp_name) = temp_data;
            ch_files_found{end+1} = temp_name;
        end
    end
end

dch_data = struct();
dch_files_found = {};

% Load all available discharge files
for soc = 100
    for cr = c_rates
        lst = dir(sprintf('%sdch_%d_%dC_*.mat', results_dir, soc, cr));
        
        for i_lst = 1:length(lst)
            filename = fullfile(lst(i_lst).folder, lst(i_lst).name);
            fprintf('Loading: %s\n', lst(i_lst).name);
            
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
            
            temp_name = sprintf('soc%d_cr%d_%d', soc, cr, i_lst);
            dch_data.(temp_name) = temp_data;
            dch_files_found{end+1} = temp_name;
        end
        
        
    end
end

%% Load and plot Charge (CC) results
close all;
fprintf('Processing Charge (CC) results...\n');

% Plot mean temperature for charge
if ~isempty(ch_files_found)
    % Create separate plots for each file (each SOC-C-rate combination)
    for i = 1:length(ch_files_found)
        data_key = ch_files_found{i};
        data = ch_data.(data_key);
        
        % Extract SOC and C-rate from key
        parts = strsplit(data_key, '_');
        soc = str2double(parts{1}(4:end));
        cr = str2double(parts{2}(3:end));
        i_lst = str2double(parts{3});
        
        
        figure('Position', [100, 100, 1500, 800]);
        
        % Temperature subplot
        ha = tight_subplot(2, 1, [0.1, 0.15], [0.05, 0.05], [0.04, 0.03]);
        % hold(ha(1),"on");
        
        Sim_len = length(data.Tmean);
        
        % Plot temperature data
        plot(ha(1), data.Simt(1:Sim_len), data.Tcold(1:Sim_len), '-', 'Color', [0, 0, 1], ... % Blue for cold
            'LineWidth', 2, 'DisplayName', 'Cold'); hold(ha(1),"on");
        plot(ha(1), data.Simt(1:Sim_len), data.Tmean(1:Sim_len), '-', 'Color', [1, 0.5, 0], ... % Orange for mean
            'LineWidth', 2, 'DisplayName', 'Mean');
        plot(ha(1), data.Simt(1:Sim_len), data.Thot(1:Sim_len), '-', 'Color', [1, 0, 0], ... % Red for hot
            'LineWidth', 2, 'DisplayName', 'Hot');
        
        Exp_len = min(length(data.Simt), length(data.ExpT_mean));
        
        % Plot experimental temperature data
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_cold(1:Exp_len), '--', 'Color', [0, 0, 1], ... % Blue dashed for exp cold
            'LineWidth', 2, 'DisplayName', 'Exp Cold');
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_mean(1:Exp_len), '--', 'Color', [1, 0.5, 0], ... % Orange dashed for exp mean
            'LineWidth', 2, 'DisplayName', 'Exp Mean');
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_hot(1:Exp_len), '--', 'Color', [1, 0, 0], ... % Red dashed for exp hot
            'LineWidth', 2, 'DisplayName', 'Exp Hot');
        
        xlabel(ha(1), 'Time [s]', 'FontSize', text_font);
        ylabel(ha(1), 'Temperature [°C]', 'FontSize', text_font);
        title(ha(1), sprintf('Charge (CC) - Temperature vs Time (%d%% SOC, %dC %s param)', soc, cr, CC_means(i_lst)), 'FontSize', text_font+2);
        legend(ha(1), 'Location', 'northwest', 'FontSize', text_font, 'NumColumns', 2);
        grid(ha(1), 'on');
        
        % Voltage subplot
        plot(ha(2), data.Simt(1:Sim_len), data.SimV(1:Sim_len), 'Color', colors(cr/2, :), ...
            'LineWidth', 2, 'DisplayName', 'Sim'); hold(ha(2),"on");
        plot(ha(2), data.Simt(1:Exp_len), data.ExpV(1:Exp_len), '--', 'Color', [0.5, 0.5, 0.5], ... % Gray dashed for exp
            'LineWidth', 2, 'DisplayName', 'Exp');
        
        xlabel(ha(2), 'Time [s]', 'FontSize', text_font);
        ylabel(ha(2), 'Voltage [V]', 'FontSize', text_font);
        title(ha(2), sprintf('Charge (CC) - Voltage vs Time (%d%% SOC, %dC)', soc, cr), 'FontSize', text_font+2);
        legend(ha(2), 'Location', 'northwest', 'FontSize', text_font, 'NumColumns', 2);
        grid(ha(2), 'on');
        linkaxes(ha, 'x');
        xlim(ha(2), [-data.Simt(end)*0.01, data.Simt(end)*1.01]);
        
        Sim_select = 1:Exp_len-1;
        Exp_select = [1, 3:Exp_len]; % Because Expt(2) = 0.5 seconds...
        
        % Error calculations:
        ch_data.(data_key).RMSE.Tcold = rmse(data.Tcold(Sim_select), data.ExpT_cold(Exp_select));
        ch_data.(data_key).RMSE.Tmean = rmse(data.Tmean(Sim_select), data.ExpT_mean(Exp_select));
        ch_data.(data_key).RMSE.Thot  = rmse(data.Thot(Sim_select), data.ExpT_hot(Exp_select));
        %       ch_data.(data_key).RMSE.T = rmse(data.SimT(:,:,1:Exp_len), data.data.ExpT(:,:,1:Exp_len));
        ch_data.(data_key).RMSE.V = rmse(data.SimV(1:Exp_len), data.ExpV(1:Exp_len));
        
        % Save figure
        fig_filename = sprintf('%scharge_soc%d_cr%d_%d.fig', output_dir, soc, cr, i_lst);
        png_filename = sprintf('%scharge_soc%d_cr%d_%d.png', output_dir, soc, cr, i_lst);
        set(gcf, 'renderer', 'Painters');
        if(write_file)
            saveas(gcf, fig_filename);
            print(gcf, png_filename, '-dpng', '-r600');
            fprintf('Saved: %s\n', fig_filename);
            fprintf('Saved: %s\n', png_filename);
        end
    end
end

% Load and plot Discharge (CC) results
close all;
fprintf('\nProcessing Discharge (CC) results...\n');
write_file = false;
% Plot mean temperature for discharge
if ~isempty(dch_files_found)
    % Create separate plots for each file (each SOC-C-rate combination)
    for i = 1:length(dch_files_found)
        data_key = dch_files_found{i};
        data = dch_data.(data_key);
        
        % Extract SOC and C-rate from key
        parts = strsplit(data_key, '_');
        soc = str2double(parts{1}(4:end));
        cr = str2double(parts{2}(3:end));
        i_lst = str2double(parts{3});
        
        figure('Position', [100, 100, 1500, 800]);
        
        % Temperature subplot
        ha = tight_subplot(2, 1, [0.1, 0.15], [0.05, 0.05], [0.04, 0.03]);
        
        
        Sim_len = length(data.Tmean);
        
        % Plot temperature data
        plot(ha(1), data.Simt(1:Sim_len), data.Tcold(1:Sim_len), '-', 'Color', [0, 0, 1], ... % Blue for cold
            'LineWidth', 2, 'DisplayName', 'Cold'); hold(ha(1),"on");
        plot(ha(1), data.Simt(1:Sim_len), data.Tmean(1:Sim_len), '-', 'Color', [1, 0.5, 0], ... % Orange for mean
            'LineWidth', 2, 'DisplayName', 'Mean');
        plot(ha(1), data.Simt(1:Sim_len), data.Thot(1:Sim_len), '-', 'Color', [1, 0, 0], ... % Red for hot
            'LineWidth', 2, 'DisplayName', 'Hot');
        
        Exp_len = min(length(data.Simt), length(data.ExpT_mean));
        
        % Plot experimental temperature data
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_cold(1:Exp_len), '--', 'Color', [0, 0, 1], ... % Blue dashed for exp cold
            'LineWidth', 2, 'DisplayName', 'Exp Cold');
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_mean(1:Exp_len), '--', 'Color', [1, 0.5, 0], ... % Orange dashed for exp mean
            'LineWidth', 2, 'DisplayName', 'Exp Mean');
        plot(ha(1), data.Simt(1:Exp_len), data.ExpT_hot(1:Exp_len), '--', 'Color', [1, 0, 0], ... % Red dashed for exp hot
            'LineWidth', 2, 'DisplayName', 'Exp Hot');
        
        xlabel(ha(1), 'Time [s]', 'FontSize', text_font);
        ylabel(ha(1), 'Temperature [°C]', 'FontSize', text_font);
        title(ha(1), sprintf('Discharge (CC) - Temperature vs Time (%d%% SOC, %dC %s param)', soc, cr, CC_means(i_lst)), 'FontSize', text_font+2);
        legend(ha(1), 'Location', 'northwest', 'FontSize', text_font, 'NumColumns', 2);
        grid(ha(1), 'on');
        
        % Voltage subplot
        plot(ha(2), data.Simt(1:Sim_len), data.SimV(1:Sim_len), 'Color', colors(cr/2, :), ...
            'LineWidth', 2, 'DisplayName', 'Sim'); hold(ha(2),"on");
        plot(ha(2), data.Simt(1:Exp_len), data.ExpV(1:Exp_len), '--', 'Color', [0.5, 0.5, 0.5], ... % Gray dashed for exp
            'LineWidth', 2, 'DisplayName', 'Exp');
        
        xlabel(ha(2), 'Time [s]', 'FontSize', text_font);
        ylabel(ha(2), 'Voltage [V]', 'FontSize', text_font);
        title(ha(2), sprintf('Discharge (CC) - Voltage vs Time (%d%% SOC, %dC)', soc, cr), 'FontSize', text_font+2);
        legend(ha(2), 'Location', 'northwest', 'FontSize', text_font, 'NumColumns', 2);
        grid(ha(2), 'on');
        linkaxes(ha, 'x');
        xlim(ha(1), [-data.Simt(end)*0.01, data.Simt(end)*1.01]);
        
        
        % Error calculations:
        Sim_select = 1:Exp_len;
        Exp_select = [1, 2:Exp_len]; % Because Expt(2) = 0.5 seconds...
        
        dch_data.(data_key).RMSE.Tcold = rmse(data.Tcold(Sim_select), data.ExpT_cold(Exp_select));
        dch_data.(data_key).RMSE.Tmean = rmse(data.Tmean(Sim_select), data.ExpT_mean(Exp_select));
        dch_data.(data_key).RMSE.Thot  = rmse(data.Thot(Sim_select), data.ExpT_hot(Exp_select));
        %       dch_data.(data_key).RMSE.T = rmse(data.SimT(:,:,1:Exp_len), data.data.ExpT(:,:,1:Exp_len));
        dch_data.(data_key).RMSE.V = rmse(data.SimV(1:Exp_len), data.ExpV(1:Exp_len));
        
        % Save figure
        fig_filename = sprintf('%sdischarge_soc%d_cr%d_%d.fig', output_dir, soc, cr, i_lst);
        png_filename = sprintf('%sdischarge_soc%d_cr%d_%d.png', output_dir, soc, cr, i_lst);
        set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
        set(gcf, 'renderer', 'Painters');
        if(write_file)
            saveas(gcf, fig_filename);
            print(gcf, png_filename, '-dpng', '-r600');
            fprintf('Saved: %s\n', fig_filename);
            fprintf('Saved: %s\n', png_filename);
        end
    end
end

%% Load and plot Pulse results
% close all;
% fprintf('\nProcessing Pulse results...\n');
% 
% % Create pulse plots for each SOC-C-rate combination
% if ~isempty(pulse_files_found)
%     % Create separate plots for each file (each SOC-C-rate combination)
%     for i = 1:length(pulse_files_found)
%         data_key = pulse_files_found{i};
%         data = pulse_data.(data_key);
% 
%         % Extract SOC and C-rate from key
%         parts = strsplit(data_key, '_');
%         soc = str2double(parts{1}(4:end));
%         cr = str2double(parts{2}(3:end));
%         cr_idx = find(pulse_c_rates == cr);
% 
%         figure('Position', [100, 100, 1500, 800]);
% 
%         % Temperature subplot
%         ha = tight_subplot(2, 1, [0.1, 0.15], [0.05, 0.05], [0.04, 0.03]);
% 
% 
%         Sim_len = length(data.Tmean);
% 
%         % Plot temperature data
%         plot(ha(1), data.Simt(1:Sim_len), data.Tcold(1:Sim_len), '-', 'Color', [0, 0, 1], ... % Blue for cold
%             'LineWidth', 2, 'DisplayName', 'Cold'); hold(ha(1),"on");
%         plot(ha(1), data.Simt(1:Sim_len), data.Tmean(1:Sim_len), '-', 'Color', [1, 0.5, 0], ... % Orange for mean
%             'LineWidth', 2, 'DisplayName', 'Mean');
%         plot(ha(1), data.Simt(1:Sim_len), data.Thot(1:Sim_len), '-', 'Color', [1, 0, 0], ... % Red for hot
%             'LineWidth', 2, 'DisplayName', 'Hot');
% 
%         Exp_len = min(Sim_len, length(data.ExpT_mean));
% 
%         % Plot experimental temperature data
%         plot(ha(1), data.Expt(1:Exp_len), data.ExpT_cold(1:Exp_len), '--', 'Color', [0, 0, 1], ... % Blue dashed for exp cold
%             'LineWidth', 2, 'DisplayName', 'Exp Cold');
%         plot(ha(1), data.Expt(1:Exp_len), data.ExpT_mean(1:Exp_len), '--', 'Color', [1, 0.5, 0], ... % Orange dashed for exp mean
%             'LineWidth', 2, 'DisplayName', 'Exp Mean');
%         plot(ha(1), data.Expt(1:Exp_len), data.ExpT_hot(1:Exp_len), '--', 'Color', [1, 0, 0], ... % Red dashed for exp hot
%             'LineWidth', 2, 'DisplayName', 'Exp Hot');
% 
%         % Error calculations:
%         Sim_select = 1:Exp_len-1;
%         Exp_select = [1, 3:Exp_len]; % Because Expt(2) = 0.5 seconds...
% 
%         pulse_data.(data_key).RMSE.Tcold = rmse(data.Tcold(Sim_select), data.ExpT_cold(Exp_select));
%         pulse_data.(data_key).RMSE.Tmean = rmse(data.Tmean(Sim_select), data.ExpT_mean(Exp_select));
%         pulse_data.(data_key).RMSE.Thot  = rmse(data.Thot(Sim_select), data.ExpT_hot(Exp_select));
%         %    pulse_data.(data_key).RMSE.T = rmse(data.SimT(:,:,1:Exp_len), data.data.ExpT(:,:,1:Exp_len));
%         pulse_data.(data_key).RMSE.V = rmse(data.SimV(Sim_select), data.ExpV(Exp_select));
% 
%         % Sanity check:
%         %figure; plot(data.SimV(Sim_select)); hold on; plot(data.ExpV(Exp_select));
% 
%         xlabel(ha(1), 'Time [s]', 'FontSize', text_font);
%         ylabel(ha(1), 'Temperature [°C]', 'FontSize', text_font);
%         title(ha(1), sprintf('Pulse - Temperature vs Time (%d%% SOC, %dC)', soc, cr), 'FontSize', text_font+2);
%         legend(ha(1), 'Location', 'northwest', 'FontSize', text_font, 'NumColumns', 2);
%         grid(ha(1), 'on');
% 
%         % Voltage subplot
% 
% 
%         % Plot voltage
%         plot(ha(2), data.Simt(1:Sim_len), data.SimV(1:Sim_len), 'Color', pulse_colors(cr_idx, :), ...
%             'LineWidth', 2, 'DisplayName', 'Sim'); hold(ha(2),"on");
%         plot(ha(2), data.Expt(1:Exp_len), data.ExpV(1:Exp_len), '--', 'Color', [0.5, 0.5, 0.5], ... % Gray dashed for exp
%             'LineWidth', 2, 'DisplayName', 'Exp');
% 
%         xlabel(ha(2), 'Time [s]', 'FontSize', text_font);
%         ylabel(ha(2), 'Voltage [V]', 'FontSize', text_font);
%         title(ha(2), sprintf('Pulse - Voltage vs Time (%d%% SOC, %dC)', soc, cr), 'FontSize', text_font+2);
%         legend(ha(2), 'Location', 'northeast', 'FontSize', text_font, 'NumColumns', 2);
%         grid(ha(2), 'on');
%         linkaxes(ha, 'x');
%         xlim(ha(1), [-data.Simt(end)*0.01, data.Simt(end)*1.01]);
% 
%         % Save figure
%         fig_filename = sprintf('%spulse_soc%d_cr%d.fig', output_dir, soc, cr);
%         png_filename = sprintf('%spulse_soc%d_cr%d.png', output_dir, soc, cr);
%         set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
%         set(gcf, 'renderer', 'Painters');
%         if(write_file)
%             saveas(gcf, fig_filename);
%             print(gcf, png_filename, '-dpng', '-r600');
%             fprintf('Saved: %s\n', fig_filename);
%             fprintf('Saved: %s\n', png_filename);
%         end
%     end
% end
% 
% fprintf('\nPlotting completed! All figures saved to: %s\n', output_dir);

%% Entropy Plot:

% entropy_Lin_supp = readmatrix('../data/misc/entropy_Lin_supp.csv');
% figure; plot(entropy_Lin_supp(:,1), entropy_Lin_supp(:,2));
% hold on;
% entropy_pulse = [0.3, pulse_data.soc30_cr8.x_now(end)
%     0.5, pulse_data.soc50_cr8.x_now(end)
%     0.7, pulse_data.soc70_cr8.x_now(end)];
% 
% s = scatter(entropy_pulse(:,1), entropy_pulse(:,2),'filled');
% s.SizeData = 100;
% grid on;
% ylabel('dOCP/dt  (mV/K)');
% xlabel('State of charge (-)');
% legend('Lin et al.', 'Pulse experiments', 'location','southeast')
% 
% % Save figure
% fig_filename = sprintf('%sentropy_comparison.fig', output_dir, soc, cr);
% png_filename = sprintf('%sentropy_comparison.png', output_dir, soc, cr);
% set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
% set(gcf, 'renderer', 'Painters');
% if(write_file)
%     saveas(gcf, fig_filename);
%     print(gcf, png_filename, '-dpng', '-r600');
%     fprintf('Saved: %s\n', fig_filename);
%     fprintf('Saved: %s\n', png_filename);
% end

%% Print errors with params:
% 
% best30_T3_Veq = load('../fitting_no_flip_minavgmax_30/best30_T3_Veq.mat');
% best30_T3_Veq_fixed_i0 = load('../fitting_no_flip_minavgmax_30/best30_T3_Veq_fixed_i0.mat');
% best30_T3 = load('../fitting_no_flip_minavgmax_30/best30_T3.mat');
% 
% best50_T3_Veq = load('../fitting_no_flip_minavgmax_50/best50_T3_Veq.mat');
% best50_T3_Veq_fixed_i0 = load('../fitting_no_flip_minavgmax_50/best50_T3_Veq_fixed_i0.mat');
% best50_T3 = load('../fitting_no_flip_minavgmax_50/best50_T3.mat');
% 
% best70_T3_Veq = load('../fitting_no_flip_minavgmax_70/best70_T3_Veq.mat');
% best70_T3_Veq_fixed_i0 = load('../fitting_no_flip_minavgmax_70/best70_T3_Veq_fixed_i0.mat');
% best70_T3 = load('../fitting_no_flip_minavgmax_70/best70_T3.mat');
% 
% i=1;
% alldat{i} = best30_T3_Veq; i = i + 1;
% alldat{i} = best50_T3_Veq; i = i + 1;
% alldat{i} = best70_T3_Veq; i = i + 1;
% 
% alldat{i} = best30_T3_Veq_fixed_i0; i = i + 1;
% alldat{i} = best50_T3_Veq_fixed_i0; i = i + 1;
% alldat{i} = best70_T3_Veq_fixed_i0; i = i + 1;
% 
% alldat{i} = best30_T3; i = i + 1;
% alldat{i} = best50_T3; i = i + 1;
% alldat{i} = best70_T3; i = i + 1;

%%
% clc;
% F_const = 96485.3321;
% i1 = 4;
% i2 = 6;
% 
% fprintf('Volumetric heat capacity: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(1));
% end
% fprintf('\n');
% 
% fprintf('Heat transfer coefficient: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(3));
% end
% fprintf('\n');
% 
% fprintf('Heat transfer velocity: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(3)/alldat{i}.x(1));
% end
% fprintf('\n');
% 
% fprintf('Effective thermal conductivity: ')
% for i=i1:i2
%     fprintf('%4.1f\t', alldat{i}.x(2));
% end
% fprintf('\n');
% 
% 
% fprintf('Voltage slope: ')
% for i=i1:i2
%     fprintf('%4.3f\t', alldat{i}.x(4));
% end
% fprintf('\n');
% 
% fprintf('Ionic conductivity: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(5));
% end
% fprintf('\n');
% 
% fprintf('Temperature dependence of kappa: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(6));
% end
% fprintf('\n');
% 
% fprintf('Exchange current density: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(7));
% end
% fprintf('\n');
% 
% fprintf('Reaction activation energy: ')
% for i=i1:i2
%     fprintf('%4.2f\t', alldat{i}.x(8));
% end
% fprintf('\n');
% 
% fprintf('Local reaction entropy: ')
% for i=i1:i2
%     fprintf('%4.3f\t', alldat{i}.x(9));
% end
% fprintf('\n');
% 
% fprintf('Local reaction entropy: ')
% for i=i1:i2
%     fprintf('%4.3f\t', alldat{i}.x(9)*F_const*1e-3);
% end
% fprintf('\n');
% 
% fprintf('Voltage RMSE: ')
% 
% flds =["soc30_cr8", "soc50_cr8", "soc70_cr8"];
% for fld=flds
%     fprintf('%4.1f\t', pulse_data.(fld).RMSE.V*1e3);
% end
% fprintf('\n');
% 
% fprintf('Temperature mean RMSE: ')
% for i=i1:i2
%     fprintf('%4.2f\t', pulse_data.(fld).RMSE.Tmean);
% end
% fprintf('\n');
% 
% fprintf('Temperature hot RMSE: ')
% for i=i1:i2
%     fprintf('%4.2f\t', pulse_data.(fld).RMSE.Thot);
% end
% fprintf('\n');
% 
% fprintf('Temperature cold RMSE: ')
% for i=i1:i2
%     fprintf('%4.2f\t', pulse_data.(fld).RMSE.Tcold);
% end
% fprintf('\n');

%% Other RMSE:
clear chargeVals dischargeVals avgCharge avgDischarge generalAvg;

% Preallocate arrays for each RMSE metric
chargeVals.V     = [];
chargeVals.Thot  = [];
chargeVals.Tmean = [];
chargeVals.Tcold = [];

dischargeVals.V     = [];
dischargeVals.Thot  = [];
dischargeVals.Tmean = [];
dischargeVals.Tcold = [];

i_key = 1; % Yes it is normally 4 but it is confusing that I load only 4th data and it corresponds to i=1 now.

for cr = 2:2:10
    dch_key = sprintf('soc100_cr%d_%d', cr, i_key);
    ch_key  = sprintf('soc0_cr%d_%d', cr, i_key);
    
    rch = ch_data.(ch_key).RMSE;
    rdc = dch_data.(dch_key).RMSE;
    
    % Store values for averaging later
    chargeVals.V(end+1)     = rch.V;
    chargeVals.Thot(end+1)  = rch.Thot;
    chargeVals.Tmean(end+1) = rch.Tmean;
    chargeVals.Tcold(end+1) = rch.Tcold;
    
    dischargeVals.V(end+1)     = rdc.V;
    dischargeVals.Thot(end+1)  = rdc.Thot;
    dischargeVals.Tmean(end+1) = rdc.Tmean;
    dischargeVals.Tcold(end+1) = rdc.Tcold;
    
    % Print individual results
    fprintf('For charge/discharge Cr = %d C:\n', cr);
    fprintf('Charge RMSE:    V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
        rch.V*1e3, rch.Thot, rch.Tmean, rch.Tcold);
    fprintf('Discharge RMSE: V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n\n', ...
        rdc.V*1e3, rdc.Thot, rdc.Tmean, rdc.Tcold);
end

% Calculate averages for each metric
avgCharge.V     = mean(chargeVals.V);
avgCharge.Thot  = mean(chargeVals.Thot);
avgCharge.Tmean = mean(chargeVals.Tmean);
avgCharge.Tcold = mean(chargeVals.Tcold);

avgDischarge.V     = mean(dischargeVals.V);
avgDischarge.Thot  = mean(dischargeVals.Thot);
avgDischarge.Tmean = mean(dischargeVals.Tmean);
avgDischarge.Tcold = mean(dischargeVals.Tcold);

% General average is mean of all charge and discharge values combined
generalAvg.V     = mean([chargeVals.V,     dischargeVals.V]);
generalAvg.Thot  = mean([chargeVals.Thot,  dischargeVals.Thot]);
generalAvg.Tmean = mean([chargeVals.Tmean, dischargeVals.Tmean]);
generalAvg.Tcold = mean([chargeVals.Tcold, dischargeVals.Tcold]);

% Print averages
fprintf('\nAverage RMSE Values:\n');
fprintf('Charge RMSE:    V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    avgCharge.V*1e3, avgCharge.Thot, avgCharge.Tmean, avgCharge.Tcold);
fprintf('Discharge RMSE: V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    avgDischarge.V*1e3, avgDischarge.Thot, avgDischarge.Tmean, avgDischarge.Tcold);
fprintf('General RMSE:   V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    generalAvg.V*1e3, generalAvg.Thot, generalAvg.Tmean, generalAvg.Tcold);


%% CC plots together:
clc; close all;
write_file = true;
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

%% Pulse plots together:
close all; clc;
write_file = false;
golden_ratio = 1.618;
width = 16.3;
height= 4.5;

% Define time ranges for zoomed plots
t_start = 1;      % Start index for first zoomed plot (0-250s)
t_end = 200;      % End index for first zoomed plot
t_last_start = length(pulse_data.soc30_cr8.Simt) - 200;  % Start index for last 250s
t_last_end = length(pulse_data.soc30_cr8.Simt);          % End index for last 250s

text_font = 18;
lw = {'LineWidth',1.5};

% SOC levels to plot
soc_levels_pulse = [30, 50, 70];
cr_pulse = 8;  % 8C pulse

for soc_idx = 1:length(soc_levels_pulse)
    soc = soc_levels_pulse(soc_idx);
    name = sprintf("soc%d_cr%d", soc, cr_pulse);
    data = pulse_data.(name);
    
    Sim_len = length(data.Tmean);
    Exp_len = min(Sim_len, length(data.ExpT_mean));
    
    % Create 2x3 subplot figure
    fig = figure('Units','inches',...
        'Position',[2 2 (x0+width) (y0+height)],...
        'PaperPositionMode','auto');
    
    % Create tight subplots: 2 rows, 3 columns
    ha = tight_subplot(2, 3, [0.02, 0.07], [0.13, 0.02], [0.047, 0.1]);
    
    % Row 1: Voltage plots (subplots 1, 2, 3)
    % 1. Full voltage plot
    plot(ha(1), data.Expt(1:Exp_len), data.ExpV(1:Exp_len), '--', ...
        'Color', Lin_blue, 'LineWidth', 2, 'DisplayName', 'Exp');
    hold(ha(1), 'on');
    plot(ha(1), data.Simt(1:Sim_len), data.SimV(1:Sim_len), ...
        'Color', Lin_red, 'LineWidth', 2, 'DisplayName', 'Sim');
    %  xlabel(ha(1), 'Time (s)', 'FontSize', text_font);
    ylabel(ha(1), 'Voltage (V)', 'FontSize', text_font);
    % title(ha(1), sprintf('%d%% SOC - Full', soc), 'FontSize', text_font);
    xlim(ha(1), [-25, data.Simt(end)*1.01]);
    grid(ha(1), 'on');
    %   xticks(ha(1),[]);
    ha(1).XTickLabel = {};
    
    % 2. Zoomed voltage plot (0-250s)
    plot(ha(2), data.Expt(t_start:t_end), data.ExpV(t_start:t_end), '--', ...
        'Color', Lin_blue, 'LineWidth', 2, 'DisplayName', 'Exp');
    hold(ha(2), 'on');
    plot(ha(2), data.Simt(t_start:t_end), data.SimV(t_start:t_end), ...
        'Color', Lin_red, 'LineWidth', 2, 'DisplayName', 'Sim');
    % xlabel(ha(2), 'Time (s)', 'FontSize', text_font);
    % ylabel(ha(2), 'Voltage (V)', 'FontSize', text_font);
    % title(ha(2), sprintf('%d%% SOC - 0-250s', soc), 'FontSize', text_font);
    xlim(ha(2), [0, t_end]);
    grid(ha(2), 'on');
    %  xticks(ha(2),[]);
    ha(2).XTickLabel = {};
    ylim(ha(1),[min(data.ExpV)-0.05, max(data.ExpV)+0.05])
    
    % 3. Zoomed voltage plot (last 250s)
    plot(ha(3), data.Expt(t_last_start:t_last_end), data.ExpV(t_last_start:t_last_end), '--', ...
        'Color', Lin_blue, 'LineWidth', 2, 'DisplayName', 'Exp');
    hold(ha(3), 'on');
    plot(ha(3), data.Simt(t_last_start:t_last_end), data.SimV(t_last_start:t_last_end), ...
        'Color', Lin_red, 'LineWidth', 2, 'DisplayName', 'Sim');
    % xlabel(ha(3), 'Time (s)', 'FontSize', text_font);
    %  ylabel(ha(3), 'Voltage (V)', 'FontSize', text_font);
    % title(ha(3), sprintf('%d%% SOC - Last 250s', soc), 'FontSize', text_font);
    xlim(ha(3), [data.Simt(t_last_start), data.Simt(t_last_end)]);
    grid(ha(3), 'on');
    %  xticks(ha(3),[]);
    ha(3).XTickLabel = {};
    
    % Link y-axes for voltage plots
    linkaxes(ha(1:3), 'y');
    ylim(ha(1), [3.09, 3.43]);
    
    % Row 2: Temperature plots (subplots 4, 5, 6)
    % 4. Full temperature plot
    plot(ha(4), data.Expt(1:Exp_len), data.ExpT_cold(1:Exp_len), '--', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (Exp)');
    hold(ha(4), 'on');
    plot(ha(4), data.Expt(1:Exp_len), data.ExpT_mean(1:Exp_len), '--', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (Exp)');
    plot(ha(4), data.Expt(1:Exp_len), data.ExpT_hot(1:Exp_len), '--', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (Exp)');
    plot(ha(4), data.Simt(1:Sim_len), data.Tcold(1:Sim_len), '-', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (Sim)');
    plot(ha(4), data.Simt(1:Sim_len), data.Tmean(1:Sim_len), '-', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (Sim)');
    plot(ha(4), data.Simt(1:Sim_len), data.Thot(1:Sim_len), '-', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (Sim)');
    xlabel(ha(4), 'Time (s)', 'FontSize', text_font);
    ylabel(ha(4), 'Temperature (°C)', 'FontSize', text_font);
    %  title(ha(4), sprintf('%d%% SOC - Full', soc), 'FontSize', text_font);
    xlim(ha(4), [-25, data.Simt(end)*1.01]);
    %  ylim(ha(4), [0.99*data.ExpT_cold(1), 1.01*max(data.ExpT_hot)]);
    grid(ha(4), 'on');
    
    
    % 5. Zoomed temperature plot (0-250s)
    plot(ha(5), data.Expt(t_start:t_end), data.ExpT_cold(t_start:t_end), '--', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (Exp)');
    hold(ha(5), 'on');
    plot(ha(5), data.Expt(t_start:t_end), data.ExpT_mean(t_start:t_end), '--', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (Exp)');
    plot(ha(5), data.Expt(t_start:t_end), data.ExpT_hot(t_start:t_end), '--', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (Exp)');
    plot(ha(5), data.Simt(t_start:t_end), data.Tcold(t_start:t_end), '-', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (Sim)');
    plot(ha(5), data.Simt(t_start:t_end), data.Tmean(t_start:t_end), '-', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (Sim)');
    plot(ha(5), data.Simt(t_start:t_end), data.Thot(t_start:t_end), '-', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (Sim)');
    xlabel(ha(5), 'Time (s)', 'FontSize', text_font);
    %   ylabel(ha(5), 'Temperature (°C)', 'FontSize', text_font);
    %  title(ha(5), sprintf('%d%% SOC - 0-250s', soc), 'FontSize', text_font);
    xlim(ha(5), [0, t_end]);
    grid(ha(5), 'on');
    
    % 6. Zoomed temperature plot (last 250s)
    plot(ha(6), data.Expt(t_last_start:t_last_end), data.ExpT_cold(t_last_start:t_last_end), '--', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (exp)');
    hold(ha(6), 'on');
    plot(ha(6), data.Expt(t_last_start:t_last_end), data.ExpT_mean(t_last_start:t_last_end), '--', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (exp)');
    plot(ha(6), data.Expt(t_last_start:t_last_end), data.ExpT_hot(t_last_start:t_last_end), '--', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (exp)');
    plot(ha(6), data.Simt(t_last_start:t_last_end), data.Tcold(t_last_start:t_last_end), '-', 'Color', dark_blue, ...
        'LineWidth', 2, 'DisplayName', 'Cold (sim)');
    plot(ha(6), data.Simt(t_last_start:t_last_end), data.Tmean(t_last_start:t_last_end), '-', 'Color', dark_green, ...
        'LineWidth', 2, 'DisplayName', 'Mean (sim)');
    plot(ha(6), data.Simt(t_last_start:t_last_end), data.Thot(t_last_start:t_last_end), '-', 'Color', dark_red, ...
        'LineWidth', 2, 'DisplayName', 'Hot (sim)');
    xlabel(ha(6), 'Time (s)', 'FontSize', text_font);
    %  ylabel(ha(6), 'Temperature (°C)', 'FontSize', text_font);
    %   title(ha(6), sprintf('%d%% SOC - Last 250s', soc), 'FontSize', text_font);
    xlim(ha(6), [data.Simt(t_last_start), 2505]);
    grid(ha(6), 'on');
    ha(6).XTick = 2300:100:2500;
    
    
    ha(4).YLim = [20.7, 28.49];
    ha(5).YLim = [20.7, 24.5];
    ha(6).YLim = [26.7, 28.49];
    
    linkaxes(ha([2,5]),'x');
    linkaxes(ha([3,6]),'x');
    
    % Set consistent font sizes for all axes
    for iii = 1:6
        set(ha(iii), 'FontSize', text_font);
    end
    
    % Adjust subplot positions to prevent overlap
    for iii = [1,4] % Big plots
        ha(iii).Position(3) = 0.552;
    end
    for iii = [2,5] % Mid plots
        ha(iii).Position(3) = 0.15;
        ha(iii).Position(1) = sum(ha(1).Position([1,3])) + 0.04; % Increased gap
    end
    for iii = [3,6] % Last plots
        ha(iii).Position(3) = 0.15;
        ha(iii).Position(1) = sum(ha(2).Position([1,3])) + 0.045; % Increased gap
    end
    
    % Add tight insets to prevent text overlap
    for iii = 1:6
        set(ha(iii), 'LooseInset', max(get(ha(iii), 'TightInset'), 0.02));
    end
    
    purple = [81, 66, 245]/255;
    
    ib = 3;
    rectangle(ha(ib), 'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor',elo_cyan,'Linewidth',2);
    rectangle(ha(1),  'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor',elo_cyan,'Linewidth',2);
    
    ib = 2;
    rectangle(ha(ib), 'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor', elo_purple ,'Linewidth',2);
    rectangle(ha(1),  'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor', elo_purple,'Linewidth',2);
    
    ib = 6;
    rectangle(ha(ib), 'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor',elo_cyan,'Linewidth',2);
    rectangle(ha(4),  'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(ha(ib).XLim), diff(ha(ib).YLim)],'EdgeColor',elo_cyan,'Linewidth',2);
    
    ib = 5;
    XLIMS = ha(ib).XLim; YLIMS = ha(ib).YLim;
    rectangle(ha(ib), 'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(XLIMS), diff(YLIMS)],'EdgeColor',elo_purple,'Linewidth',2);
    rectangle(ha(4),  'position',[ha(ib).XLim(1) ha(ib).YLim(1) diff(XLIMS), diff(YLIMS)],'EdgeColor',elo_purple,'Linewidth',2);
    ha(ib).YLim = YLIMS; % Restore limits because when you draw rectangle it may automatically change.
    
    
    % Create legend for voltage plots (top right, outside axes)
    leg_voltage = legend(ha(1), {'Experimental', 'Simulation'}, ...
        'FontSize', text_font-1, 'TextColor', 'black', ...
        'NumColumns',2, 'Box',  'off',...
        'Position', [0.36, 0.56, 0.15, 0.08]);
    
    % Create legend for temperature plots (top right, outside axes)
    leg_temp = legend(ha(4), {'Cold spot (experimental)', 'Average  (experimental)', 'Hot spot  (experimental)', 'Cold spot (simulation)', 'Average  (simulation)', 'Hot spot  (simulation)'}, ...
        'FontSize', text_font-1, 'TextColor', 'black', 'NumColumns', 2, ...
        'Location','southeast', 'Box', 'off');
    
    % Save figure
    if(write_file)
        save_plt(gcf, output_dir, sprintf("SimII_Pulse_combined_%d", soc));
    end
end

%% Plot smoothed vs. not smoothed version with proper dimension annotations
close all; clc;

% Load data
Tcc10_last = ch_data.soc0_cr10_4.data.ExpT(:,:,end);
sigma = 3;

% Define figure layout and parameters
x0 = 1; y0 = 1;
width = 7;
height = 4.5;

text_font = 18;
lw = {'LineWidth', 1.5};

% Create figure
fig = figure('Units', 'inches', ...
    'Position', [2 2 (x0 + width) (y0 + height)], ...
    'PaperPositionMode', 'auto');

% Create tight subplots
ha = tight_subplot(1, 2, [0.01, 0.01], [0.08, 0.05], [0.06, 0.12]);

% Physical dimensions (in mm)
x_dim = 145;
y_dim = 195;
[x, y] = meshgrid(linspace(0, x_dim, size(Tcc10_last, 2)), ...
    linspace(0, y_dim, size(Tcc10_last, 1)));
temp = 0.000;
ha(1).Position(1) = ha(1).Position(1) + temp;
ha(2).Position(1) = ha(2).Position(1) - temp;

% --- Subplot 1: Unsmoothed ---
axes(ha(1));
contourf(x, y, Tcc10_last, 20, 'LineColor', 'none');
hold on;
[C1, h1] = contour(x, y, Tcc10_last, 5, 'LineColor', 'w');
% No clabel for left plot
axis image off;
title('Unsmoothed', 'FontSize', text_font);

% --- Subplot 2: Smoothed ---
axes(ha(2));
Tcc10_smooth = imgaussfilt(Tcc10_last, sigma);
contourf(x, y, Tcc10_smooth, 20, 'LineColor', 'none');
hold on;
[C2, h2] = contour(x, y, Tcc10_smooth, 5, 'LineColor', 'w', "LabelFormat", "%0.1f °C");
clabel(C2, h2, 'Color', 'k', 'FontSize', 15);
axis image off;
title('Smoothed', 'FontSize', text_font);

% --- Shared Colorbar ---
cb = colorbar;
cb.Position = [0.89, 0.12, 0.02, 0.792];
cb.FontSize = text_font;
caxis([28 32]);
cb.Label.String = 'Temperature (°C)';
cb.Ticks = 28:32;
% --- Colormap: cmocean thermal ---
colormap(cmocean('thermal'));

% --- Dimension Annotations ---
% Get position of first subplot for reference
pos1 = get(ha(1), 'Position');

% HORIZONTAL ARROW (145 mm) - below first subplot
x_start_h = pos1(1);  % Left edge of first subplot
x_end_h = pos1(1) + pos1(3);  % Right edge of first subplot
y_arrow_h = pos1(2)+0.01;  % Position below the subplot

% Create horizontal double arrow
annotation('doublearrow', [x_start_h x_end_h], [y_arrow_h y_arrow_h], ...
    'LineWidth', 1, 'Color', 'k');

% Add horizontal text label - properly centered
x_text_h = (x_start_h + x_end_h) / 2;
annotation('textbox', [x_text_h - 0.075, y_arrow_h - 0.05, 0.15, 0.04], ...
    'String', '145 mm', ...
    'FontSize', text_font - 2, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'EdgeColor', 'none', ...
    'BackgroundColor', 'none', ...
    'Margin', 2);

% VERTICAL ARROW (195 mm) - left of first subplot
x_arrow_v = ha(1).Position(1) - 0.018;  % Position to the left of subplot
y_start_v = pos1(2)+0.035;  % Bottom edge of subplot
y_end_v = pos1(2) + pos1(4)-0.035;  % Top edge of subplot

% Create vertical double arrow
annotation('doublearrow', [x_arrow_v x_arrow_v], [y_start_v y_end_v], ...
    'LineWidth', 1, 'Color', 'k');

% Add vertical text label - rotated and centered
y_text_v = (y_start_v + y_end_v) / 2;
annotation('textbox', [x_arrow_v+0.01, y_text_v - 0.1, 0.1, 0.1], ...
    'String', '195 mm', ...
    'FontSize', text_font - 2, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'EdgeColor', 'none', ...
    'Rotation', 90, ...
    'Margin', 2);

% Optional: Add dimension labels as axis labels instead of annotations
% This can be more reliable for alignment
% xlabel(ha(1), 'Width: 145 mm', 'FontSize', text_font-2);
% ylabel(ha(1), 'Height: 195 mm', 'FontSize', text_font-2);

% Save figure
if(write_file)
    save_plt(gcf, output_dir, "SmoothingFig");
end

%% Charge and discharge surface plots comparison
close all; clc;
write_file = false;

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

