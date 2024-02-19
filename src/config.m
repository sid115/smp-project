% Constants

CUTOFF_FREQUENCY = 300; % Low-pass filter cutoff frequency in Hz
EXPECTED_BPM = 150; % Expected BPM for calculating minimum samples between beats
FILTER_ORDER_LIMIT = 5; % Maximum order for the Butterworth filter
MIN_PEAK_MULTIPLIER = 2; % Multiplier for the minimum peak height
PLOTS_PREFIX = '../assets/plots/'; % Prefix for the output plots
PASSBAND_RIPPLE = 3; % Passband ripple in dB for the Butterworth filter
SMOOTHING_WINDOW_DURATION = 0.01; % Duration of the smoothing window in seconds
STOPBAND_ATTENUATION = 40; % Stopband attenuation in dB for the Butterworth filter
