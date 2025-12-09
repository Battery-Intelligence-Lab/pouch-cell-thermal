function iter = get_lastIteration(Crate, fitting_mode)
% This function retrieves the checkpoint number for the last iteration. 
% Author: Volkan Kumtepeli

    prefix = "Checkpoint_" + fitting_mode + "_" + num2str(Crate) + "C_";

    check_list = dir(fullfile("Checkpoints", prefix + '*.mat'));
    
    if(isempty(check_list))
        iter = 0;
    else
        namelist = extractBetween(string({check_list(:).name}), prefix,'.mat');              
        iter = max(double(namelist));
    end

end