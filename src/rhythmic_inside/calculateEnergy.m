function [smoothedEnergySignal] = calculateEnergy(signal, fs, iteration)

% Include configuration file
source('config.m');

% Original energy signal calculation without smoothing
energySignal = signal.^2; % Square signal to calculate energy

% Normalize the original energy signal
normalizedEnergySignal = energySignal / max(abs(energySignal)); % Normalize energy signal to range [0, 1]

% Calculate the smoothed energy signal
windowSize = round(SMOOTHING_WINDOW_DURATION * fs); % Calculate window size in samples
movAvgFilter = ones(windowSize, 1) / windowSize; % Create moving average filter coefficients
smoothedEnergySignal = conv(normalizedEnergySignal, movAvgFilter, 'same'); % Apply convolution for smoothing

% Plot the original and smoothed energy signal
fig = figure('visible', 'off');
xValues = (1:length(normalizedEnergySignal)) / 1000;
plot(xValues, normalizedEnergySignal, 'b'); % Plot original energy signal in blue
hold on;
plot(xValues, smoothedEnergySignal, 'r'); % Plot smoothed energy signal in red
xlabel('Samples / 1000');
ylabel('Normalized Energy');
title('Energy Signal Before and After Smoothing');
legend('Original Energy Signal', 'Smoothed Energy Signal');
print(fig, strcat(PLOTS_PREFIX, 'energy', num2str(iteration), '.png'), '-dpng'); % Save plot
hold off;
close(fig);

end
