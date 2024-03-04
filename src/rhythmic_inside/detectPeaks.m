function [filteredPeaks, filteredLocations] = detectPeaks(acf, lag, fs, iteration)

% Include configuration file
source('config.m');

% Validate input arguments
if isempty(acf), error('acf is empty'); end
if length(acf) ~= length(lag), error('acf and lag are not the same size'); end
if fs <= 0, error('fs is not positive'); end

% Only consider positive lags for peak detection
positiveIdx = lag >= 0;
lagPositive = lag(positiveIdx);
acfPositive = acf(positiveIdx);

% Hotfix: Set negative values to zero
acfPositive(acfPositive < 0) = 0;

% Define the linear function for minimum peak height: f(lag) = -slope * lag + intercept
slope = (mean(acfPositive) * MIN_PEAK_MULTIPLIER) / max(lagPositive); % Example slope calculation
intercept = mean(acfPositive) * MIN_PEAK_MULTIPLIER; % Set intercept such that f(0) equals initial minPeakHeight

% Calculate dynamicMinPeakHeight for each positive lag
dynamicMinPeakHeight = max(-slope * lagPositive + intercept, 0); % Ensure non-negative

% Detect peaks in the ACF (only consider positive lags)
[peaks, locations] = findpeaks(acfPositive);

% Initialize arrays for filtered peaks
filteredPeaks = [];
filteredLocations = [];
lastLocation = -inf;

% Filter peaks by this height and minimum distance
for i = 1:length(locations)
    currentLag = lagPositive(locations(i));
    if peaks(i) > dynamicMinPeakHeight(locations(i))
        % Check if the current peak meets the dynamic height requirement and minimum distance
        if isempty(filteredLocations) || (currentLag - lastLocation) > (60 / EXPECTED_BPM)
            filteredPeaks = [filteredPeaks, peaks(i)];
            filteredLocations = [filteredLocations, currentLag];
            lastLocation = currentLag;
        end
    end
end

% Plot the ACF, detected peaks, and dynamic threshold
fig = figure('visible', 'off');
plot(lagPositive, acfPositive, 'LineWidth', 1); % Plot ACF
hold on;
plot(filteredLocations, filteredPeaks, 'r*', 'MarkerSize', 8); % Plot filtered detected peaks
plot(lagPositive, dynamicMinPeakHeight, 'g.-', 'LineWidth', 1.5); % Plot dynamic threshold
xlabel('Lag / s');
ylabel('ACF');
title('Detected Peaks on ACF with Dynamic Threshold');
legend('ACF', 'Filtered Detected Peaks', 'Dynamic Threshold');
print(fig, strcat(PLOTS_PREFIX, 'peaks', num2str(iteration), '.png'), '-dpng'); % Save plot
close(fig);

end
