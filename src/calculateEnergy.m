function [energySignal] = calculateEnergy(signal, fs)

% Static variables / constants
SMOOTHING_WINDOW_DURATION = 0.01; % Duration of the smoothing window in seconds

% Calculate the energy of the filtered signal
energySignal = signal.^2; % Square signal to calculate energy

% Normalize the energy signal
energySignal = energySignal / max(abs(energySignal)); % Normalize energy signal to range [0, 1]

% Smooth the energy signal with a moving average filter
windowSize = round(SMOOTHING_WINDOW_DURATION * fs); % Calculate window size in samples
movAvgFilter = ones(windowSize, 1) / windowSize; % Create moving average filter coefficients
energySignal = conv(energySignal, movAvgFilter, 'same'); % Apply convolution for smoothing

end
