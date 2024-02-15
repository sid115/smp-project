% OCTAVE SCRIPT FOR BPM DETECTION

% Static variables / constants
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

% Read the audio file and preprocess it
[filteredSignal, fs] = readAndPreprocess(wavFilePath);

% Calculate the energy signal and smooth it
[smoothedEnergySignal] = calculateEnergy(filteredSignal, fs);

% Use the auto-correlation function to identify the periodicity in the signal
% TODO: [lag, acf] = autoCorrelationAnalysis(signal, fs);

% Detect peaks and calculate the BPM
[filteredBPM, filteredLocations] = detectPeaksAndCalculateBPM(smoothedEnergySignal, fs);

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
