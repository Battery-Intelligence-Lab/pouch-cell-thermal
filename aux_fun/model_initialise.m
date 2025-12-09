function [] = model_initialise(x, model, data)
% This function initialises model from data
% Author: Volkan Kumtepeli
param.names = {'Cpel', 'keff', 'h1', 'ku', 'keref', 'alfa_ke', 'i0ref', 'Ei0', 'delS'};
param.units = {'[MJ/m^3/K]', '[W/m/K]', '[W/m^2/K]', '[V]', '[mS/m]', '[mS/m/K]', '[A/m^2]', '[kJ/mol]','[mV/K]'};

for ip=1:length(param.names)
    model.param.set(param.names{ip},  sprintf('%4.16f %s', x(ip), param.units{ip}));
end

model.param.set('Tend', sprintf('%d [s]',data.Tend));

model.param.set('N_long', sprintf('%d', data.N_long));
model.param.set('N_short', sprintf('%d',data.N_short));

model.param.set('Tinf', sprintf('%4.4f [degC]', data.Tinf)); % Set initial and ambient temperature.

SOC_limited = max(min(data.SOC, 99.99999), 0.000001)/100;

model.param.set('Crate', sprintf('%4.4f [1/h]', data.Cr));

if(strcmpi(data.fitting_mode, "pulse"))
    model.component('comp1').variable('var11').active(false); %-> discharge
    model.component('comp1').variable('var12').active(false); %-> charge
    model.component('comp1').variable('var13').active(true);  %-> pulse

    model.param.set('Qinit', sprintf('%4.4f ',SOC_limited));

elseif(strcmpi(data.fitting_mode, "ch"))
    model.component('comp1').variable('var11').active(false); %-> discharge
    model.component('comp1').variable('var12').active(true);  %-> charge
    model.component('comp1').variable('var13').active(false); %-> pulse
    
    temp = sprintf('1 - U_OCP_ch_inv(%4.6f [V])', data.ExpV_0);
    model.param.set('Qinit', temp);

elseif(strcmpi(data.fitting_mode, "dch"))
    model.component('comp1').variable('var11').active(true);  %-> discharge
    model.component('comp1').variable('var12').active(false); %-> charge
    model.component('comp1').variable('var13').active(false); %-> pulse

    temp = sprintf('1 - U_OCP_dch_inv(%4.6f [V])', data.ExpV_0);
    model.param.set('Qinit', temp);
else
    errror('fitting mode is not recognised!!');
end



end




