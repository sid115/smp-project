function [lag, acf] = autoCorrelationAnalysis(signal, fs)

% Perform auto-correlation on the signal
[acf, lags] = xcorr(signal, 'coeff');
    
% Normalize lags to time
lag = lags / fs;
    
% Here, 'acf' is the auto-correlation function, and 'lag' are the corresponding time lags.
% You might want to limit the lag range based on expected BPMs to improve accuracy and reduce noise.
end
