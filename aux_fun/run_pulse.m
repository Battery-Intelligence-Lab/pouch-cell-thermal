function [cost, costV, costT, residuals, costTmean, costThot, costTcold] = run_pulse(x, model, data)
% This function combines running simulation, calculating cost values and saving Checkpoints. 
% Author: Volkan Kumtepeli

[Simt, SimV, SimT] = run_sim(x, model, data);

Crate = data.Cr;
[cost, costV, costT, residuals, costTmean, costThot, costTcold] = calculate_costs(SimT, SimV, Simt, data, x);

iter = get_lastIteration(Crate, data.fitting_mode) + 1;
save("Checkpoints/Checkpoint_" + data.fitting_mode + "_" + num2str(Crate) + 'C_' + string(iter) + ".mat",...
    'x','Crate',"cost","costV", "costT", "costTmean", "costThot", "costTcold", "SimT","SimV","Simt","iter");

end