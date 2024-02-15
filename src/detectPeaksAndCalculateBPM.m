function [bpm, filteredLocations] = detectPeaksAndCalculateBPM(signal, fs)

% Static variables / constants
MIN_PEAK_MULTIPLIER = 2; % Multiplier for the minimum peak height
EXPECTED_BPM = 150; % Expected BPM for calculating minimum samples between beats

% Detect peaks in the smoothed energy signal
[peaks, locations] = findpeaks(signal); % Detect peaks in the energy signal

% Filter by peak height
minPeakHeight = mean(signal) * MIN_PEAK_MULTIPLIER; % Calculate minimum peak height
validPeaksIdx = peaks > minPeakHeight; % Find indices of peaks that are above the minimum height
peaks = peaks(validPeaksIdx); % Filter peaks by height
locations = locations(validPeaksIdx); % Filter locations by height

% Calculate the minimum number of samples between beats
beatsPerSecond = EXPECTED_BPM / 60; % Convert BPM to beats per second
minSamplesBetweenBeats = fs / beatsPerSecond; % Calculate minimum samples between beats

% Initialize arrays for filtered peaks based on minimum distance
filteredPeaks = [];
filteredLocations = [];
lastLocation = 0;

% Filter peaks based on minimum distance
for i = 1:length(locations)
    if isempty(filteredLocations) || (locations(i) - lastLocation) > minSamplesBetweenBeats
        filteredPeaks = [filteredPeaks, peaks(i)]; % Add peak to filtered list
        filteredLocations = [filteredLocations, locations(i)]; % Add location to filtered list
        lastLocation = locations(i); % Update last location
    end
end

% Recalculate the time between peaks using filtered locations
timeBetweenFilteredPeaks = diff(filteredLocations) / fs; % Calculate time between filtered peaks

% Recalculate BPM using filtered peaks
avgTimePerFilteredBeat = mean(timeBetweenFilteredPeaks); % Calculate average time per beat
bpm = 60 / avgTimePerFilteredBeat; % Convert average time per beat to BPM

end
