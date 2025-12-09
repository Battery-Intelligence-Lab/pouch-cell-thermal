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