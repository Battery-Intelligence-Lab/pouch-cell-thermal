function [z_opt, cost] = get_zOpt(cost1, cost2)
% This function calculates optimal weight factors for negative likelihood for multi-objective optimisation.
% This function is not used in the paper. 
% Author: Volkan Kumtepeli

cst = @(z) exp(z(1))*cost1 + exp(z(2))*cost2 - z(1) - z(2);

z_opt = fmincon(cst,[1;7], [], [], [], [], [0;0], [18;18], [], optimoptions('fmincon','display','off'));

cost = cst(z_opt);

end