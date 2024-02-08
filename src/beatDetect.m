% Read WAV file
[signal, fs] = audioread('techno.wav'); % Replace 'your_audio_file.wav' with your file path

% Convert stereo to mono if necessary
if size(signal, 2) > 1
    signal = mean(signal, 2);
end

% Design and apply a low-pass filter
cutoffFrequency = 300; % Cutoff frequency in Hz
normalizedCutoff = cutoffFrequency / (fs / 2);
[n, Wn] = buttord(normalizedCutoff, normalizedCutoff * 1.1, 3, 40);
[b, a] = butter(n, Wn);
filteredSignal = filter(b, a, signal);

% Calculate the energy of the filtered signal
energySignal = filteredSignal.^2;

% Smooth the energy signal with a moving average filter
windowSize = round(0.01 * fs);
movAvgFilter = ones(windowSize, 1) / windowSize;
smoothedEnergySignal = conv(energySignal, movAvgFilter, 'same'); % Apply convolution

% Detect peaks in the smoothed energy signal
[peaks, locations] = findpeaks(smoothedEnergySignal);

% Filter by MinPeakHeight
minPeakHeight = mean(smoothedEnergySignal) * 2;
validPeaksIdx = peaks > minPeakHeight;
peaks = peaks(validPeaksIdx);
locations = locations(validPeaksIdx);

% Calculate the time in seconds between peaks to estimate beats
timeBetweenPeaks = diff(locations) / fs;

% Calculate BPM
avgTimePerBeat = mean(timeBetweenPeaks);
bpm = 60 / avgTimePerBeat;

fprintf('Estimated BPM: %f\n', bpm);

% Plotting
plot(smoothedEnergySignal);
hold on;
plot(locations(peaks), smoothedEnergySignal(locations(peaks)), 'r*'); % Plot detected peaks
hold off;
xlabel('Sample Number');
ylabel('Energy');
title('Detected Peaks on Energy Signal');
legend('Smoothed Energy Signal', 'Detected Peaks');
