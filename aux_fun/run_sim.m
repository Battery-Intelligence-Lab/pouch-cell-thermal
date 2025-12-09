function [Simt, SimV, SimT, Qgen, SOCmat] = run_sim(x, model, data)
% This function initialises model, tries to run the simulation, 
% if the simulation successfully runs then it extracts time, voltage, temperature, heat generation and SOC values. 
% Author: Volkan Kumtepeli

model_initialise(x, model, data);

try

model.sol('sol1').runAll;

Simt      = mphglobal(model,'t'); % Time
SimV      = mphglobal(model,'comp1.bnd4','unit','V'); % Cell voltage (V)
SimT      = get_back_temperature_from_text(model);    % Temperature (degC)
Qgen      = mphtable(model,'tbl25');                  % Heat generation
SOCmat    = mphtable(model,'tbl24');                  % SOC table
catch
    % If simulation fails just assign `1` to all outputs. 
    Simt   = 1;
    SimV   = 1;
    SimT   = 1;
    Qgen   = 1;
    SOCmat = 1;
end



end