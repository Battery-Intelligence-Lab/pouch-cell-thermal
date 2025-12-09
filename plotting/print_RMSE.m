clear chargeVals dischargeVals avgCharge avgDischarge generalAvg;

% Preallocate arrays for each RMSE metric
chargeVals.V     = [];
chargeVals.Thot  = [];
chargeVals.Tmean = [];
chargeVals.Tcold = [];

dischargeVals.V     = [];
dischargeVals.Thot  = [];
dischargeVals.Tmean = [];
dischargeVals.Tcold = [];

i_key = 1; % Yes it is normally 4 but it is confusing that I load only 4th data and it corresponds to i=1 now.

for cr = 2:2:10
    dch_key = sprintf('soc100_cr%d_%d', cr, i_key);
    ch_key  = sprintf('soc0_cr%d_%d', cr, i_key);
    
    rch = ch_data.(ch_key).RMSE;
    rdc = dch_data.(dch_key).RMSE;
    
    % Store values for averaging later
    chargeVals.V(end+1)     = rch.V;
    chargeVals.Thot(end+1)  = rch.Thot;
    chargeVals.Tmean(end+1) = rch.Tmean;
    chargeVals.Tcold(end+1) = rch.Tcold;
    
    dischargeVals.V(end+1)     = rdc.V;
    dischargeVals.Thot(end+1)  = rdc.Thot;
    dischargeVals.Tmean(end+1) = rdc.Tmean;
    dischargeVals.Tcold(end+1) = rdc.Tcold;
    
    % Print individual results
    fprintf('For charge/discharge Cr = %d C:\n', cr);
    fprintf('Charge RMSE:    V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
        rch.V*1e3, rch.Thot, rch.Tmean, rch.Tcold);
    fprintf('Discharge RMSE: V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n\n', ...
        rdc.V*1e3, rdc.Thot, rdc.Tmean, rdc.Tcold);
end

% Calculate averages for each metric
avgCharge.V     = mean(chargeVals.V);
avgCharge.Thot  = mean(chargeVals.Thot);
avgCharge.Tmean = mean(chargeVals.Tmean);
avgCharge.Tcold = mean(chargeVals.Tcold);

avgDischarge.V     = mean(dischargeVals.V);
avgDischarge.Thot  = mean(dischargeVals.Thot);
avgDischarge.Tmean = mean(dischargeVals.Tmean);
avgDischarge.Tcold = mean(dischargeVals.Tcold);

% General average is mean of all charge and discharge values combined
generalAvg.V     = mean([chargeVals.V,     dischargeVals.V]);
generalAvg.Thot  = mean([chargeVals.Thot,  dischargeVals.Thot]);
generalAvg.Tmean = mean([chargeVals.Tmean, dischargeVals.Tmean]);
generalAvg.Tcold = mean([chargeVals.Tcold, dischargeVals.Tcold]);

% Print averages
fprintf('\nAverage RMSE Values:\n');
fprintf('Charge RMSE:    V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    avgCharge.V*1e3, avgCharge.Thot, avgCharge.Tmean, avgCharge.Tcold);
fprintf('Discharge RMSE: V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    avgDischarge.V*1e3, avgDischarge.Thot, avgDischarge.Tmean, avgDischarge.Tcold);
fprintf('General RMSE:   V = %4.1f mV, Thot = %4.2f °C, Tavg = %4.2f °C, Tcold = %4.2f °C\n', ...
    generalAvg.V*1e3, generalAvg.Thot, generalAvg.Tmean, generalAvg.Tcold);
