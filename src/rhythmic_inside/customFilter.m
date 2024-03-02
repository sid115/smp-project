function filteredSignal = customFilter(signal, fs, high, normalizedCutoff)

% Include configuration file
source('config.m');

if size(signal, 2) > 1
    signal = mean(signal, 2); % Averaging two channels to convert stereo to mono
end

% Set filter type based on 'high' flag
if high
    variant = 'high'; % High-pass filter
else
    variant = 'low'; % Low-pass filter
end

% Check for valid normalized cutoff frequency
if normalizedCutoff <= 0 || normalizedCutoff >= 1
    error('Invalid normalized cutoff frequency');
end

% Calculate filter order and normalized cutoff using Butterworth design
[n, Wn] = buttord(normalizedCutoff, normalizedCutoff * 1.1, PASSBAND_RIPPLE, STOPBAND_ATTENUATION);

% Limit filter order to prevent instability
order = min(n, FILTER_ORDER_LIMIT);

% Design Butterworth filter according to the specified variant (high or low)
[b, a] = butter(order, Wn, variant);

% Apply filter using zero-phase method
filteredSignal = filtfilt(b, a, signal);

end
