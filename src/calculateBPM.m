function bpm = calculateBPM(filteredLocations)

% Check if there are enough locations to calculate BPM
if isempty(filteredLocations) || length(filteredLocations) < 2
    bpm = 0; % Not enough data to determine BPM
    return;
end

% Calculate bpm from median
bpm = 60 / median(diff(filteredLocations));

end
