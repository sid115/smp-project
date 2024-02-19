function [filteredPeaks, filteredLocations] = detectPeaks(acf, lag, fs)

% Include configuration file
source('config.m');

% Check if the ACF is empty
if isempty(acf)
    error('acf is empty');
end

% Check if the ACF and lag are the same size
if length(acf) ~= length(lag)
    error('acf and lag are not the same size');
end

% Check if the sampling frequency is valid
if fs <= 0
    error('fs is not positive');
end

% Only consider positive lags for peak detection
lagPositive = lag(lag >= 0);
acfPositive = acf(lag >= 0);

% Hotfix: Set negative values to zero
acfPositive(acfPositive < 0) = 0;

% Detect peaks in the ACF (only consider positive lags)
[peaks, locations] = findpeaks(acfPositive);

% Calculate minimum peak height
minPeakHeight = mean(acfPositive) * MIN_PEAK_MULTIPLIER;
validPeaksIdx = peaks > minPeakHeight;

% Filter peaks by height
validPeaks = peaks(validPeaksIdx);
validLocations = lagPositive(locations(validPeaksIdx));

% Calculate the minimum number of samples between beats
beatsPerSecond = EXPECTED_BPM / 60;
minDistanceSeconds = (fs / beatsPerSecond) / fs; % Convert to seconds

% Initialize arrays for filtered peaks
filteredPeaks = [];
filteredLocations = [];
lastLocation = -inf;

% Filter peaks based on minimum distance
for i = 1:length(validLocations)
    if isempty(filteredLocations) || (validLocations(i) - lastLocation) > minDistanceSeconds
        filteredPeaks = [filteredPeaks, validPeaks(i)];
        filteredLocations = [filteredLocations, validLocations(i)];
        lastLocation = validLocations(i);
    end
end

end
