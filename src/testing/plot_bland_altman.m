% Load required packages
pkg load io;
pkg load plot;

% Read the data from the output file
data = dlmread('output_table.txt', '|', 1, 0);
our_bpm = data(:, 2);
tool_bpm = data(:, 3);

% Calculate means and differences
means = (our_bpm + tool_bpm) / 2;
differences = our_bpm - tool_bpm;
relative_diff = (our_bpm - tool_bpm) ./ tool_bpm * 100;  % Calculate relative difference

% Calculate average difference and standard deviation
avg_diff = mean(relative_diff);
std_diff = std(relative_diff);

% Plot Bland-Altman plot
figure;
plot(means, relative_diff, 'o');
hold on;
plot(means, avg_diff + zeros(size(means)), 'r-', means, avg_diff + 1.96*std_diff + zeros(size(means)), 'r--', means, avg_diff - 1.96*std_diff + zeros(size(means)), 'r--');
xlabel('Average BPM');
ylabel('Relative Difference in %');
title('Our BPM vs. bpm-tools');
hold off;

% Save the plot
print('bland_altman_plot.png','-dpng');
