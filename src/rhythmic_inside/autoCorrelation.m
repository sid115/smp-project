function [lag, acf] = autoCorrelation(signal, fs)

% Perform auto-correlation on the signal
[acf, lags] = xcorr(signal, 'coeff');
  
% Normalize lags to time
lag = lags / fs;

% 'acf' is the auto-correlation function and 'lag' are the corresponding time lags.
end
