% This function converts mat files to *.csv files for other users. 
% Author: Volkan Kumtepeli

Crate = [2, 4, 6, 8, 10]; 
mode = ["ch", "dch"];

for cr = Crate 
    for md = mode
        load("exp/CC/"+ num2str(cr) + "C/" + md + "/Expivium.mat")
        Expivium(:,1) = Expivium(:,1) - 1; 
        
        
        ExpT = double(load("exp/CC/"+ num2str(cr) + "C/" + md + "/ExpIR.mat").ExpIR);
        ExpT = ExpT(6:end-5, 3:end-2, :); % Cropping frame. 

        ExpT = rot90(ExpT, 2);
        [N_long, N_short, ~] = size(ExpT); 

        [ExpT_constHot, ExpT_constCold, ExpT_constMean] = calculate_hot_cold_mean(ExpT, n_square);

        header = {'t','V','I','Tambient','Tmean','Tcoldspot','Thotspot'};
        Expivium = [Expivium, ExpT_constMean, ExpT_constCold, ExpT_constHot];

        Expivium = [header; num2cell(Expivium)];


        writecell(Expivium, "exp/" + num2str(cr) + "C_CC"+md + ".csv");
    end
end

%% Pulse to csv.

Crate = ["2C100s", "4C100s", "8C50s"]; 
mode = ["30SOC", "50SOC", "70SOC"];

for cr = Crate 
    for md = mode
        load("exp/pulse/" + md + "/" + cr + "/Expivium.mat")
        Expivium(:,1) = Expivium(:,1) - 1; 
        
        ExpT = double(load("exp/pulse/" + md + "/" + cr + "/ExpIR.mat").ExpIR);
        ExpT = ExpT(6:end-5, 3:end-2, :); % Cropping frame. 

        ExpT = rot90(ExpT, 2);
        [N_long, N_short, ~] = size(ExpT); 

        [ExpT_constHot, ExpT_constCold, ExpT_constMean] = calculate_hot_cold_mean(ExpT, n_square);

        header = {'t','V','I','Tambient','Tmean','Tcoldspot','Thotspot'};
        Expivium = [Expivium, ExpT_constMean, ExpT_constCold, ExpT_constHot];

        Expivium = [header; num2cell(Expivium)];

        writecell(Expivium, "exp/" + extractBefore(cr,3) + "_"+md + ".csv");
    end
end