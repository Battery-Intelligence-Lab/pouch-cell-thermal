% This function loads and processes the results. 
% Author: Volkan Kumtepeli 

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