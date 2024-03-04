function bpm = processSignalForBPM(signal, fs, iteration)

% Calculate the energy signal and smooth it
[smoothedEnergySignal] = calculateEnergy(signal, fs, iteration);

% Use the auto-correlation function to identify the periodicity in the signal
[lag, acf] = autoCorrelation(smoothedEnergySignal, fs);

% Detect peaks
[peaks, locations] = detectPeaks(acf, lag, fs, iteration);

% Calculate the BPM
bpm = calculateBPM(locations);

end
