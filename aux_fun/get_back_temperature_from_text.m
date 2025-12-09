function SimT = get_back_temperature_from_text(model)
% Get cathode CC temperature
% Right top is the hotter tab (i.e. copper/anode/graphite tab)
% However, this tab is behind. 

N_long  = mphevaluate(model, 'N_long','');
N_short = mphevaluate(model, 'N_short','');


model.result.export('data2').run;
SimT = load('SimT_saved.txt');

SimT = SimT(end:-1:1, :);
SimT = reshape(SimT, N_short, N_long, []);
SimT = permute(SimT, [2,1,3]);

end