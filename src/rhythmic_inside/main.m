% Include configuration file
source('config.m');

% Check if any arguments are passed
args = argv();
if length(args) >= 1
  % Use the first argument as the WAV file path if provided
  wavFilePath = args{1};
else
  % Use the file picker to select the WAV file
  wavFilePath = selectWAV();;
end

% Check if the 'signal' package is installed and load it
if isempty(pkg('list', 'signal'))
    error('The "signal" package is not installed. Please install it using "pkg install -forge signal".');
else
    pkg load signal;
end

% Read WAV file
[signal, fs] = audioread(wavFilePath); % Read audio data and sampling frequency from WAV file

% Initialize the BPM array and cutoff frequency
bpmArray = [];
cutoff = 0.5;

% Call the recursive filter function
bpmArray = recursiveFilter(signal, fs, cutoff, bpmArray);

% TODO: plot the BPM array

% Calculate the average BPM from the collected BPMs
averageBPM = mean(bpmArray);

% Display average BPM
disp(['Average BPM: ', num2str(averageBPM)]);
