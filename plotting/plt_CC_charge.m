%% Plot Charge (CC) results
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