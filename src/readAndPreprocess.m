function [filteredSignal, fs] = readAndPreprocess(wavFilePath)

% Static variables / constants
CUTOFF_FREQUENCY = 300; % Low-pass filter cutoff frequency in Hz
PASSBAND_RIPPLE = 3; % Passband ripple in dB for the Butterworth filter
STOPBAND_ATTENUATION = 40; % Stopband attenuation in dB for the Butterworth filter
FILTER_ORDER_LIMIT = 5; % Maximum order for the Butterworth filter

% Read WAV file
[signal, fs] = audioread(wavFilePath); % Read audio data and sampling frequency from WAV file

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
