function bpm = processSignalForBPM(signal, fs)

% Calculate the energy signal and smooth it
[smoothedEnergySignal] = calculateEnergy(signal, fs);

% Use the auto-correlation function to identify the periodicity in the signal
[lag, acf] = autoCorrelation(smoothedEnergySignal, fs);

% Detect peaks
[peaks, locations] = detectPeaks(acf, lag, fs);

% Calculate the BPM
bpm = calculateBPM(locations);

end
