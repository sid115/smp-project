% Include configuration file
source('config.m');

% Check if any arguments are passed
args = argv();
if length(args) >= 1
  % Use the first argument as the WAV file path if provided
  wavFilePath = args{1};
else
  % Open a GUI dialog to select a WAV file if no arguments are provided
  [fileName, pathName] = uigetfile('*.wav', 'Select the WAV file');
  if isequal(fileName,0) || isequal(pathName,0)
     disp('User canceled the operation.');
     return;
  else
     wavFilePath = fullfile(pathName, fileName);
     disp(['User selected: ', wavFilePath]);
  end
end

% Check if the 'signal' package is installed and load it
if isempty(pkg('list', 'signal'))
    error('The "signal" package is not installed. Please install it using "pkg install -forge signal".');
else
    pkg load signal;
end

% Read WAV file
[signal, fs] = audioread(wavFilePath); % Read audio data and sampling frequency from WAV file

% Preprocess the audio file
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
