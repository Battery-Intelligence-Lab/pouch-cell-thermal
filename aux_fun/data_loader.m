function data = data_loader(SOC, Cr, fitting_mode, Tend)
% This function loads necessary data. 
% Author: Volkan Kumtepeli

SOC_str = num2str(SOC) + "SOC";
Cr_str = num2str(Cr) + "C";

if(strcmpi(fitting_mode,"dch") || strcmpi(fitting_mode,"ch"))
    temp = load('../exp/CC/' + Cr_str + "/" + fitting_mode + '/Expivium.mat').Expivium;
    ExpT = double(load('../exp/CC/' + Cr_str + "/" + fitting_mode + '/ExpIR.mat').ExpIR);
elseif(strcmpi(fitting_mode,"pulse"))
    if(Cr == 8)
    temp = load('../exp/pulse/' + SOC_str + '/8C50s/Expivium.mat').Expivium;
    ExpT = double(load('../exp/pulse/' + SOC_str + '/8C50s/ExpIR.mat').ExpIR);
    elseif(Cr==4)
    temp = load('../exp/pulse/' + SOC_str + '/4C100s/Expivium.mat').Expivium;
    ExpT = double(load('../exp/pulse/' + SOC_str + '/4C100s/ExpIR.mat').ExpIR);
    elseif(Cr==2)
    temp = load('../exp/pulse/' + SOC_str + '/2C100s/Expivium.mat').Expivium;
    ExpT = double(load('../exp/pulse/' + SOC_str + '/2C100s/ExpIR.mat').ExpIR);
    end
end

Expt = temp(:,1)-1;
ExpV = temp(:,2);
ExpI = temp(:,3);

cropping = true;

if(cropping)
ExpT = ExpT(6:end-5, 3:end-2, :); % Cropping the frame. 
% Cropping numbers by Eloise: 
% 71 -> 67
% 95 -> 85
end

% ROTATE to get the right orientation
ExpT = rot90(ExpT, 2);

[N_long, N_short, ~] = size(ExpT); 

% Vk note: Tabs are around ExpT(beginning, all). 
data.n_square = 5;

if(nargin<4)
    Tend = length(Expt)-1;
end

N = Tend+1;

data.Expt = Expt(1:N);
data.ExpV = ExpV(1:N);
data.ExpI = ExpI(1:N);
data.ExpT = ExpT(:,:,1:N);

data.ExpV_0 = data.ExpV(1); % Still keep previous thing without messing up optimisations.
data.ExpT_0 = data.ExpT(:,:,1);
data.ExpI_0 = data.ExpI(1);

data.ExpI(1) = []; % It is because first sample is t=0-  and second sample is t=0+
data.ExpV(1) = []; % It is because first sample is t=0-  and second sample is t=0+
data.ExpT(:,:,1) = [];

[data.ExpT_hot, data.ExpT_cold, data.ExpT_mean] = calculate_hot_cold_mean(data.ExpT, data.n_square);

data.N_long = N_long;
data.N_short = N_short; 
data.Tinf = data.ExpT_mean(1); 
data.N = N; 
data.SOC = SOC;
data.Cr  = Cr;
data.cropping = cropping;
data.Tend = Tend;
data.fitting_mode = fitting_mode;
end