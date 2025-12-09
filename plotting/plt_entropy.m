% Entropy Plot:
entropy_Lin_supp = readmatrix('../data/misc/entropy_Lin_supp.csv');
figure; plot(entropy_Lin_supp(:,1), entropy_Lin_supp(:,2));
hold on;
entropy_pulse = [0.3, pulse_data.soc30_cr8.x_now(end)
    0.5, pulse_data.soc50_cr8.x_now(end)
    0.7, pulse_data.soc70_cr8.x_now(end)];

s = scatter(entropy_pulse(:,1), entropy_pulse(:,2),'filled');
s.SizeData = 100;
grid on;
ylabel('dOCP/dt  (mV/K)');
xlabel('State of charge (-)');
legend('Lin et al.', 'Pulse experiments', 'location','southeast')

% Save figure
fig_filename = sprintf('%sentropy_comparison.fig', output_dir, soc, cr);
png_filename = sprintf('%sentropy_comparison.png', output_dir, soc, cr);
set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02));
set(gcf, 'renderer', 'Painters');
if(write_file)
    saveas(gcf, fig_filename);
    print(gcf, png_filename, '-dpng', '-r600');
    fprintf('Saved: %s\n', fig_filename);
    fprintf('Saved: %s\n', png_filename);
end