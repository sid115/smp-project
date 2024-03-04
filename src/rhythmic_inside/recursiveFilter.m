function [bpmArray, iteration] = recursiveFilter(signal, fs, cutoffFrequency, bpmArray, iteration)

% Include config file
source('config.m');

if cutoffFrequency > LOWEST_NORMALIZED_CUTOFF_FREQUENCY
    % Apply highpass filter
    highpassSignal = customFilter(signal, fs, true, cutoffFrequency);

    % Calculate BPM for highpass signal and add to bpmArray
    bpm = processSignalForBPM(highpassSignal, fs, iteration);
    bpmArray(end+1) = bpm;
    %printf('BPM for cutoff frequency %d: %d\n', cutoffFrequency, bpm);
    
    % Apply lowpass filter and then recursively process each half
    lowpassSignal = customFilter(signal, fs, false, cutoffFrequency);
    
    % Calculate new cutoff frequency for the next level
    cutoffFrequency /= 2;

    % Increase iteration
    iteration += 1;
    
    % Recursive call for the next level with highpass of lowpass signal
    [bpmArray, iteration] = recursiveFilter(lowpassSignal, fs, cutoffFrequency, bpmArray, iteration);
end

end
