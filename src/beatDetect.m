% OCTAVE SCRIPT FOR BPM DETECTION

% Static variables / constants
CUTOFF_FREQUENCY = 300; % Low-pass filter cutoff frequency in Hz
PASSBAND_RIPPLE = 3; % Passband ripple in dB for the Butterworth filter
STOPBAND_ATTENUATION = 40; % Stopband attenuation in dB for the Butterworth filter
FILTER_ORDER_LIMIT = 5; % Maximum order for the Butterworth filter
SMOOTHING_WINDOW_DURATION = 0.01; % Duration of the smoothing window in seconds
MIN_PEAK_MULTIPLIER = 2; % Multiplier for the minimum peak height
EXPECTED_BPM = 150; % Expected BPM for calculating minimum samples between beats
OUTPUT_FILENAME = '../assets/DetectedPeaksPlot.png'; % Filename for the output plot

% Check if any arguments are passed
args = argv();
if length(args) < 1
  disp('Usage: octave beatDetect.m "/path/to/file.wav"');
  return;
end

wavFilePath = args{1}; % First argument is the WAV file path

% Check if the 'signal' package is installed and load it
if isempty(pkg('list', 'signal'))
    error('The "signal" package is not installed. Please install it using "pkg install -forge signal".');
else
    pkg load signal;
end

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

% Calculate the energy of the filtered signal
energySignal = filteredSignal.^2; % Square signal to calculate energy

% Normalize the energy signal
energySignal = energySignal / max(abs(energySignal)); % Normalize energy signal to range [0, 1]

% Smooth the energy signal with a moving average filter
windowSize = round(SMOOTHING_WINDOW_DURATION * fs); % Calculate window size in samples
movAvgFilter = ones(windowSize, 1) / windowSize; % Create moving average filter coefficients
smoothedEnergySignal = conv(energySignal, movAvgFilter, 'same'); % Apply convolution for smoothing

% Detect peaks in the smoothed energy signal
[peaks, locations] = findpeaks(smoothedEnergySignal); % Detect peaks in the energy signal

% Filter by peak height
minPeakHeight = mean(smoothedEnergySignal) * MIN_PEAK_MULTIPLIER; % Calculate minimum peak height
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
filteredBPM = 60 / avgTimePerFilteredBeat; % Convert average time per beat to BPM

% Display the estimated BPM
fprintf('Estimated BPM: %d\n', round(filteredBPM));

% Create a figure window but make it invisible
fig = figure('visible', 'off');

% Plot the smoothed energy signal and detected peaks
plot(smoothedEnergySignal); % Plot smoothed energy signal
hold on;
plot(filteredLocations, smoothedEnergySignal(filteredLocations), 'r*'); % Plot filtered detected peaks
xlabel('Sample Number'); % Label x-axis
ylabel('Energy'); % Label y-axis
title('Detected Peaks on Energy Signal'); % Title for the plot
legend('Smoothed Energy Signal', 'Filtered Detected Peaks'); % Legend for the plot

% Specify the filename and format for the output plot
print(fig, OUTPUT_FILENAME, '-dpng'); % Save the plot as a PNG file

% Close the figure
close(fig);
