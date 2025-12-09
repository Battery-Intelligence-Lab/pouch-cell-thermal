function [] = save_plt(fig, plt_folder, plt_name)
% This function is to save plot files.
% Author: Volkan Kumtepeli

savefig(fig, fullfile(plt_folder, plt_name + ".fig"));
print(fig, fullfile(plt_folder, plt_name + ".png"), '-dpng', '-r600');
print(fig, fullfile(plt_folder, plt_name + ".eps"), '-depsc');

fprintf('Saved: %s\n', plt_name);

end