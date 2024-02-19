% OCTAVE SCRIPT FOR BPM DETECTION

% Include configuration file
source('config.m');

% Open a GUI dialog to select a WAV file
[FileName, PathName] = uigetfile('*.wav', 'Select the WAV file');
if isequal(FileName,0) || isequal(PathName,0)
   disp('User canceled the operation.');
   return;
else
   wavFilePath = fullfile(PathName, FileName);
   disp(['User selected: ', wavFilePath]);
end

% Check if the 'signal' package is installed and load it
if isempty(pkg('list', 'signal'))
    error('The "signal" package is not installed. Please install it using "pkg install -forge signal".');
else
    pkg load signal;
end

% Read WAV file
[signal, fs] = audioread(wavFilePath); % Read audio data and sampling frequency from WAV file

% Read the audio file and preprocess it
[filteredSignal] = preprocess(signal, fs);

% Calculate the energy signal and smooth it
[smoothedEnergySignal] = calculateEnergy(filteredSignal, fs);

% Use the auto-correlation function to identify the periodicity in the signal
[lag, acf] = autoCorrelation(smoothedEnergySignal, fs);

% Detect peaks
[peaks, locations] = detectPeaks(acf, lag, fs);

% Calculate the BPM
bpm = calculateBPM(locations);

% Display the estimated BPM
fprintf('Estimated BPM: %d\n', round(bpm));

% Create a figure window but make it invisible
fig = figure('visible', 'off');

% Plot the smoothed energy signal and detected peaks
plot(smoothedEnergySignal); % Plot smoothed energy signal
hold on;
indicesForPlotting = round(locations * fs) + 1;
plot(indicesForPlotting, smoothedEnergySignal(indicesForPlotting), 'r*');
xlabel('Sample Number'); % Label x-axis
ylabel('Energy'); % Label y-axis
title('Detected Peaks on Energy Signal'); % Title for the plot
legend('Smoothed Energy Signal', 'Filtered Detected Peaks'); % Legend for the plot

% Specify the filename and format for the output plot
print(fig, OUTPUT_FILENAME, '-dpng'); % Save the plot as a PNG file

% Close the figure
close(fig);
