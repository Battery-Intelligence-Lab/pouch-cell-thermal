% Revision plots
% Author: Volkan Kumtepeli
% Date: 2025-09-29

clear variables; close all; clc;

addpath('../aux_fun');

% Configuration
results_dir = "../results/paper_results_" + "paper_2026_revision/";
output_dir = fullfile(results_dir, 'plots/');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

half_U =  load(fullfile(results_dir, "dch_100_4C_4.mat"));
full_U =  load(fullfile(results_dir, "dch_100_4C_4_revision_NOHALF.mat"));

figure('Position', [100, 100, 650, 300]);
t = tight_subplot(1, 2, [0.1, 0.04], [0.2, 0.28], [0.1, 0.05]);

Nfreq = 200;
n_half = size(half_U.SOCmat.data,1);
n_full = size(full_U.SOCmat.data,1);

% Determine colors for each plotted series based on header containing min/avg/max
headers = half_U.SOCmat.headers; % full list, index aligned with columns
diamondCols = [4+1, 1+1, 6+1]; % order used in plots
starCols = [5+1, 3+1, 2+1];

% Palettes
diamondPalette.min = [1.00 0.00 0.00];     % red
diamondPalette.avg = [1.00 0.50 0.00];     % orange
diamondPalette.max = [0.00 0.60 0.00];     % green
starPalette.min    = [0.00 0.447 0.741];   % blue
starPalette.avg    = [0.494 0.184 0.556];  % purple
starPalette.max    = [0.301 0.745 0.933];  % light blue

getColor = @(label, palette) ( ...
    (contains(lower(label), 'min') * palette.min) + ...
    (contains(lower(label), 'avg') * palette.avg) + ...
    (contains(lower(label), 'mean') * palette.avg) + ...
    (contains(lower(label), 'max') * palette.max) );

dColors = cell(1, numel(diamondCols));
for k = 1:numel(diamondCols)
    lbl = headers{diamondCols(k)};
    c = getColor(lbl, diamondPalette);
    if isequal(c, 0) % fallback if none matched
        c = diamondPalette.avg;
    end
    dColors{k} = c;
end

sColors = cell(1, numel(starCols));
for k = 1:numel(starCols)
    lbl = headers{starCols(k)};
    c = getColor(lbl, starPalette);
    if isequal(c, 0)
        c = starPalette.avg;
    end
    sColors{k} = c;
end

% Left subplot (Half)
plot(t(1), half_U.SOCmat.data(:, diamondCols(1))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{1}, 'MarkerIndices', 1:Nfreq:n_half); hold(t(1));
plot(t(1), half_U.SOCmat.data(:, diamondCols(2))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{2}, 'MarkerIndices', 1:Nfreq:n_half);
plot(t(1), half_U.SOCmat.data(:, diamondCols(3))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{3}, 'MarkerIndices', 1:Nfreq:n_half);
plot(t(1), half_U.SOCmat.data(:, starCols(1))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{1}, 'MarkerIndices', 1:Nfreq:n_half);
plot(t(1), half_U.SOCmat.data(:, starCols(2))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{2}, 'MarkerIndices', 1:Nfreq:n_half);
plot(t(1), half_U.SOCmat.data(:, starCols(3))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{3}, 'MarkerIndices', 1:Nfreq:n_half);

xlabel(t(1), 'Time (s)');
ylabel('SOC (%)');
title(t(1), 'U_{anode} = -U_{full}/2');
ylim(t(1), [-5,105]);
ylabel(t(1), 'SOC (%)');
% Right subplot (Full)
plot(t(2), full_U.SOCmat.data(:, diamondCols(1))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{1}, 'MarkerIndices', 1:Nfreq:n_full); hold(t(2));
plot(t(2), full_U.SOCmat.data(:, diamondCols(2))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{2}, 'MarkerIndices', 1:Nfreq:n_full);
plot(t(2), full_U.SOCmat.data(:, diamondCols(3))*100, '-d', 'LineWidth', 1.2, 'Color', dColors{3}, 'MarkerIndices', 1:Nfreq:n_full);
plot(t(2), full_U.SOCmat.data(:, starCols(1))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{1}, 'MarkerIndices', 1:Nfreq:n_full);
plot(t(2), full_U.SOCmat.data(:, starCols(2))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{2}, 'MarkerIndices', 1:Nfreq:n_full);
plot(t(2), full_U.SOCmat.data(:, starCols(3))*100,    '-*', 'LineWidth', 1.2, 'Color', sColors{3}, 'MarkerIndices', 1:Nfreq:n_full);
xlabel(t(2), 'Time (s)');
%ylabel('SOC (%)');
t(2).YTick = [];
title(t(2), 'Grounded anode');
ylim(t(2), [-10,110]);

xlim(t(1),[-5,905])
xlim(t(2),[-5,905])

% Build shared legend labels from headers, keeping substring starting at 'SOC'
headers = half_U.SOCmat.headers; % cell array of char arrays
labels = headers(2:end);
cleanLabels = regexprep(labels, '.*?(SOC.*)', '$1');
cleanLabels = cleanLabels([4,1,6,5,3,2]);
leg = legend(cleanLabels, 'Orientation','horizontal','NumColumns',3);
% Position the legend near top center
leg.Position(2) = 0.85;
leg.Position(1) = 0.12;

save_plt(gcf, output_dir, "SOCmat_plots");