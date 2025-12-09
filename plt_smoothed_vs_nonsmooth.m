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
x_start_h = pos1(1);          % Left edge of first subplot
x_end_h = pos1(1) + pos1(3);  % Right edge of first subplot
y_arrow_h = pos1(2)+0.01;     % Position below the subplot

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
y_start_v = pos1(2)+0.035;              % Bottom edge of subplot
y_end_v = pos1(2) + pos1(4)-0.035;      % Top edge of subplot

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

% Add dimension labels as axis labels instead of annotations
% xlabel(ha(1), 'Width: 145 mm', 'FontSize', text_font-2);
% ylabel(ha(1), 'Height: 195 mm', 'FontSize', text_font-2);

% Save figure
if(write_file)
    save_plt(gcf, output_dir, "SmoothingFig");
end