

% [[7 8 12 13], [17 18 22 23]]
% freqbands = [ 7.5 17.5; 12.5 22.5]
% freqs = 8    12    16    20    24
% 
% 
% [6 8 28 30];
% freqs =  8    12    16    20    24    28
%     
% 
% [7 8 22 23]
% freqs 8  12    16    20    24

% Change freqs to freqs = [7.5 12.5 17.5 22.5], remove middle interval?





% Error in train_ersp_clsfr (line 292)
% else                                freqbands(:,bi)=[mean(opts.freqband{bi}([1 2])) mean(opts.freqband([3 4]))];
% else                                freqbands(:,bi)=[mean(opts.freqband{bi}([1 2])) mean(opts.freqband{bi}([3 4]))];
% 

% AUC true positives / false positives normally?
% Entropy as performance measure for AUC
% 1 = a 
% 0 = b
% p_a = x 
% p_b = 1 - x
% Entropy = - p_a * log(p_a) - p_b * log(p_b)
% Higher = worse (max 1 at p_s = 0.5)
% Lower = better (min 0 at p_s = 1.0)
% 
% x = 0.6
% p_a = 0.6
% p_b = 0.4
% Entropy = -0.6 * log(0.6) - 0.4 * log(0.4) = 0.6370
% 
% x = 0.7
% p_a = 0.7
% p_b = 0.3
% Entropy = - p_a * log(p_a) - p_b * log(p_b) = 0.6109
% 
% x = 0.9
% p_a = 0.9
% p_b = 0.1
% Entropy = -0.9 * log(0.9) - 0.1 * log(0.1) = 0.3251
