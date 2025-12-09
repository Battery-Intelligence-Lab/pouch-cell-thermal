% This is to plot i0 and Ei0 sweep results
% Author: Volkan Kumtepeli 

clear all; close all; clc;
addpath("../aux_fun");

fls = dir("i0ref_Ei0_sweep/**/*.mat");

SOC = 70;
Cr = 8;
fitting_mode = "pulse";

pulse = data_loader(SOC, Cr, fitting_mode);

sim = struct;
Ei0s = zeros(1,length(fls));
i0s  = zeros(1,length(fls));

n_square = 5;

for i=1:length(fls)
    temp = load(fullfile(fls(i).folder, fls(i).name));
    
    [sim(i).Thot, sim(i).Tcold, sim(i).Tmean] = calculate_hot_cold_mean(temp.SimT, n_square);
    sim(i).V = temp.SimV;
    sim(i).cost = temp.cost;
    
    sim(i).rmse_V = rmse(sim(i).V, pulse.ExpV);
    sim(i).rmse_Tmean = rmse(sim(i).Tmean, pulse.ExpT_mean);
    sim(i).rmse_Tcold = rmse(sim(i).Tcold, pulse.ExpT_cold);
    sim(i).rmse_Thot  = rmse(sim(i).Thot,  pulse.ExpT_hot);
    sim(i).rmse_Tall  = sqrt(sim(i).rmse_Tmean^2 + sim(i).rmse_Tcold^2 + sim(i).rmse_Thot^2);
    
    Ei0s(i) = temp.x(8);
    i0s(i)  = temp.x(7);
    
    fprintf('Read file %d.\n', i)
end

% Organize data by unique i0 levels
unique_i0s = unique(i0s);
n_unique_i0s = length(unique_i0s);

% Create arrays to store organized data
organized_data = struct();

for i = 1:n_unique_i0s
    current_i0 = unique_i0s(i);
    indices = find(i0s == current_i0);
    
    organized_data(i).i0 = current_i0;
    organized_data(i).Ei0s = Ei0s(indices);
    organized_data(i).rmse_V = [sim(indices).rmse_V];
    organized_data(i).rmse_Tmean = [sim(indices).rmse_Tmean];
    organized_data(i).rmse_Tcold = [sim(indices).rmse_Tcold];
    organized_data(i).rmse_Thot = [sim(indices).rmse_Thot];
    organized_data(i).rmse_Tall = [sim(indices).rmse_Tall];
    organized_data(i).cost = [sim(indices).cost];
end
%%
% Create semilogy plots for different error types
figure('Position', [100, 100, 1200, 800]);

% Voltage RMSE
subplot(2,3,1);
hold on;
colors = lines(n_unique_i0s);
for i = 1:n_unique_i0s
    semilogx(organized_data(i).Ei0s, organized_data(i).rmse_V, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('RMSE Voltage');
title('Voltage RMSE vs Ei0');
legend(arrayfun(@(x) sprintf('i0 = %4.1f', x), unique_i0s, 'UniformOutput', false), 'Location', 'north', 'NumColumns', 2);
grid on;

% Tmean RMSE
subplot(2,3,2);
hold on;
for i = 1:n_unique_i0s
    semilogy(organized_data(i).Ei0s, organized_data(i).rmse_Tmean, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('RMSE T_{mean}');
title('Mean Temperature RMSE vs Ei0');
grid on;

% Tcold RMSE
subplot(2,3,3);
hold on;
for i = 1:n_unique_i0s
    semilogy(organized_data(i).Ei0s, organized_data(i).rmse_Tcold, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('RMSE T_{cold}');
title('Cold Temperature RMSE vs Ei0');
grid on;

% Thot RMSE
subplot(2,3,4);
hold on;
for i = 1:n_unique_i0s
    semilogy(organized_data(i).Ei0s, organized_data(i).rmse_Thot, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('RMSE T_{hot}');
title('Hot Temperature RMSE vs Ei0');
grid on;

% Tall RMSE
subplot(2,3,5);
hold on;
for i = 1:n_unique_i0s
    plot(organized_data(i).Ei0s, organized_data(i).rmse_Tall, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('RMSE T_{all}');
title('All Temperature RMSE vs Ei0');
grid on;

% Cost function
subplot(2,3,6);
hold on;
for i = 1:n_unique_i0s
    semilogy(organized_data(i).Ei0s, organized_data(i).cost, 'o-', 'Color', colors(i,:), 'LineWidth', 2, 'MarkerSize', 6);
end
xlabel('Ei0');
ylabel('Cost Function');
title('Cost Function vs Ei0');
grid on;

sgtitle(sprintf('Error Analysis for i0-Ei0 Sweep (SOC=%d%%, Cr=%dC)', SOC, Cr), 'FontSize', 14);

% Create heatmaps for different error types
error_types = {'rmse_V', 'rmse_Tmean', 'rmse_Tcold', 'rmse_Thot', 'rmse_Tall', 'cost'};
error_names = {'Voltage RMSE', 'T_{mean} RMSE', 'T_{cold} RMSE', 'T_{hot} RMSE', 'T_{all} RMSE', 'Cost Function'};

%%
figure('Position', [200, 200, 1500, 1000]);

for e = 1:length(error_types)
    subplot(2,3,e);
    
    % Create data matrix for heatmap
    all_Ei0s = unique([organized_data.Ei0s]);
    heatmap_data = zeros(n_unique_i0s, length(all_Ei0s));
    
    for i = 1:n_unique_i0s
        for j = 1:length(all_Ei0s)
            idx = find(organized_data(i).Ei0s == all_Ei0s(j));
            if ~isempty(idx)
                heatmap_data(i, j) = organized_data(i).(error_types{e})(idx);
            else
                heatmap_data(i, j) = NaN;
            end
        end
    end
    
    % Create heatmap
    imagesc(all_Ei0s, unique_i0s, heatmap_data);
    colorbar;
    xlabel('Ei0');
    ylabel('i0');
    title(error_names{e});
    
    % Set axis properties
    set(gca, 'YDir', 'normal');
    if e == 1
        ylabel(colorbar, 'Error Value');
    end
end

sgtitle(sprintf('Error Heatmaps for i0-Ei0 Sweep (SOC=%d%%, Cr=%dC)', SOC, Cr), 'FontSize', 14);

% Print summary statistics
fprintf('\n=== Summary Statistics ===\n');
fprintf('Number of unique i0 levels: %d\n', n_unique_i0s);
fprintf('i0 range: [%.2e, %.2e]\n', min(unique_i0s), max(unique_i0s));
fprintf('Ei0 range: [%.2e, %.2e]\n', min(Ei0s), max(Ei0s));

for i = 1:n_unique_i0s
    fprintf('\ni0 = %.2e:\n', unique_i0s(i));
    fprintf('  Number of Ei0 points: %d\n', length(organized_data(i).Ei0s));
    [~, idx_v] = min(organized_data(i).rmse_V);
    fprintf('  Best Ei0 for voltage RMSE: %.2e (RMSE = %.4f)\n', ...
        organized_data(i).Ei0s(idx_v), ...
        min(organized_data(i).rmse_V));
    [~, idx_c] = min(organized_data(i).cost);
    fprintf('  Best Ei0 for cost function: %.2e (Cost = %.4f)\n', ...
        organized_data(i).Ei0s(idx_c), ...
        min(organized_data(i).cost));
end