function [cost, costV, costT, residuals, costTmean, costThot, costTcold] = calculate_costs(SimT_raw, SimV_raw, Simt_raw, data, x)
% Function to calculate all costs from simulation outputs.
% Author: Volkan Kumtepeli

set_params;

[len_w, len_h, ~] = size(data.ExpT);

if (SimT_raw(1) < 0) % Fix later
    cost1 = 1e9;
    cost2 = 1e9;
    cost = 1e14;
    residuals = inf((len_h*len_w + 1)*data_number,1);
    return;
else
    %% Here, we can extrapolate the output if needed.

    SimT = SimT_raw;
    SimV = SimV_raw;

    %% Extract cost

    % Normalisation factors
    factorV = max(data.ExpV(:));
    factorT = max(data.ExpT(:));

    if(length(data.ExpV(:)) ~= length(SimV(1:end-1)))
        % If simulation is not finished, then take simulation output zero.
        diff_V = (data.ExpV(:))/factorV;
        diff_T = (data.ExpT(:))/factorT;
        fprintf("Simulation failed for: ");
        fprintf("%4.6f, ", x);
        fprintf("\n");

        residuals = [250*diff_V(:); diff_T(:)];
        cost = norm(residuals,2)^2;
        cost1 = norm(diff_V(:))^2/numel(diff_V);% + 0.05*norm(diff_dV)^2 / length(diff_dV);
        cost2 = norm(diff_T(:))^2/numel(diff_T);% + 0.1*cost_Tdx + 0.1*cost_Tdy;%  + cost_maxT;
        return;
    else
        diff_V = (SimV(1:end-1) - data.ExpV(:))/factorV;
        diff_T = (SimT(:,:,1:end-1) - data.ExpT)/factorT;
    end

    costV = norm(diff_V(:))^2/numel(diff_V);%
    costT = norm(diff_T(:))^2/numel(diff_T);%

    n_square = 5;
    [SimT_constHot, SimT_constCold, SimT_constMean] = calculate_hot_cold_mean(SimT(:,:,1:end-1), n_square);
    [ExpT_constHot, ExpT_constCold, ExpT_constMean] = calculate_hot_cold_mean(data.ExpT, n_square);


    diff_Tmean = (SimT_constMean - ExpT_constMean)./factorT;
    diff_Tmax  = (SimT_constHot - ExpT_constHot)./factorT;
    diff_Tmin  = (SimT_constCold - ExpT_constCold)./factorT;

    % [z_opt, cost] = get_zOpt(cost1, cost2); % For MLE cost function

    costTmean = norm(diff_Tmean(:), 2)^2;
    costThot = norm(diff_Tmax(:), 2)^2;
    costTcold = norm(diff_Tmin(:), 2)^2;

    residuals = [diff_V(:); diff_Tmean(:); diff_Tmax(:); diff_Tmin(:)];
    cost = norm(residuals,2)^2;
end


end