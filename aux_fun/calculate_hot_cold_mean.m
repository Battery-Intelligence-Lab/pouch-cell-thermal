function [hot, cold, meann] = calculate_hot_cold_mean(ExpT, n_square)
% Calculates the temperature valeus in hotspot, coldspot, and mean
% temperature.
% Author: Volkan Kumtepeli

long_begin_hot = 30;
long_end_hot   = long_begin_hot + n_square;

short_begin_hot = 30;
short_end_hot = short_begin_hot + n_square; 

long_begin_cold = 80;
long_end_cold   = long_begin_cold + n_square;

short_begin_cold = 62;
short_end_cold = short_begin_cold + n_square; 

% First coordinate is long
hot  = squeeze(mean(ExpT(long_begin_hot:long_end_hot, short_begin_hot:short_end_hot, :),[1,2]));
cold = squeeze(mean(ExpT(long_begin_cold:long_end_cold, short_begin_cold:short_end_cold, :),[1,2]));
meann = squeeze(mean(ExpT,   [1,2]));

end