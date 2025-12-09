%% Hotspot tracking (Experiment vs Simulation, 2x5)
% Creates the figure like the reference image.
% Requirements: results_dir points to your .mat files.
close all;

addpath('../aux_fun');

% Files and column labels (left->right like your image: 10C,8C,6C,4C,2C)
cc_files  = { 'ch_0_10C_4.mat','ch_0_8C_4.mat','ch_0_6C_4.mat','ch_0_4C_4.mat','ch_0_2C_4.mat' };
cc_titles = { '10C dch','8C dch','6C dch','4C dch','2C dch' };


results_dir = "../results/paper_results_" + "paper_2026_revision/";
output_dir = fullfile(results_dir, 'plots/');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end


for i=1:length(cc_files)
    cc_data{i} = load(fullfile(results_dir, cc_files{i}));
    nz = size(cc_data{i}.SimT,3);
    x{i} = zeros(nz, 1);
    y{i} = x{i};
    val{i} = x{i};
    for j = 1:nz
        [M,I] = max(cc_data{i}.SimT(:,:,j) , [], "all","linear");
        [dim1, dim2] = ind2sub(size(cc_data{i}.SimT(:,:,j)),I);
        val{i}(j) = M;
        x{i}(j) = dim1;
        y{i}(j) = dim2;
        imagesc(cc_data{i}.SimT(:,:,j));
        pause(0.01);
    end
end