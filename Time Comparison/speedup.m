%% Minimal Audio Filtering Script
clear; close all;

%% Select Input Audio Filename
music = 'StillAlive';
format = '.flac';

%% Select Input IR Filename
IR = 'Bunker2025-04-23_1';

%% Load audio data from an audio file in double precision
[x,Fs] = audioread(['../Test Files/', music, format], 'double');

%% Load impulse response audio data from an audio file in double precision
filt = audioread(['../Impulse Responses/', IR, '.wav'], 'double');

%% Fast FFT Based Filtering
tic;
y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));

% Normalize output audio (prevents clipping)
y = y ./ max(y);

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);

timeFast = toc; % Measures time to apply filter

%% Slow Convolution Based Filtering
tic;
y = filter(filt, 1, x);

% Normalize output audio (prevents clipping)
y = y ./ max(y);

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);

timeSlow = toc;

speedUp = timeSlow/timeFast;

% 'The FFT implementation was 424.95 times faster.'
disp(['The FFT implementation was ', sprintf('%.2f', speedUp), ' times faster.']);