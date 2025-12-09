function residuals = get_residual(x, model, data)
% This is a helper function for only returning residual values
% for optimisers requiring residual information such as `lsqnonlin` 
% Author: Volkan Kumtepeli

[~, ~, ~, residuals] = run_pulse(x, model, data);
end