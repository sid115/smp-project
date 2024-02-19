function [filteredSignal] = preprocess(signal, fs)

% Include configuration file
source('config.m');

% Convert stereo to mono if necessary
if size(signal, 2) > 1
    signal = mean(signal, 2); % Averaging two channels to convert stereo to mono
end

% Design and apply a low-pass filter
normalizedCutoff = CUTOFF_FREQUENCY / (fs / 2); % Normalize cutoff frequency to Nyquist frequency
[n, Wn] = buttord(normalizedCutoff, normalizedCutoff * 1.1, PASSBAND_RIPPLE, STOPBAND_ATTENUATION); % Calculate filter order and normalized cutoff
order = min(n, FILTER_ORDER_LIMIT); % Limit filter order to prevent instability
[b, a] = butter(order, Wn); % Design Butterworth filter
filteredSignal = filtfilt(b, a, signal); % Apply filter using zero-phase method

end
