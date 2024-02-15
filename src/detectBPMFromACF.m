function bpm = detectBPMFromACF(acf, lags, fs)

% Ignore the peak at zero lag to avoid self-correlation
[pks, locs] = findpeaks(acf(lags > 0), 'MinPeakProminence', 0.1); % Adjust parameters as needed

% Convert lag indices to time
peakLags = lags(locs);

% Convert the most significant lag to BPM
if isempty(peakLags)
    bpm = 0; % Handle case with no significant peaks
else
    primaryLag = peakLags(1); % Assuming the first significant peak represents the beat
    bpm = 60 / (primaryLag / fs);
end

end
