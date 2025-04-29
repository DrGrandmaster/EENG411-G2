%% Minimal Audio Filtering Script
clear; close all;

%% Select Input Audio Filename
music = 'StillAlive';
format = '.flac';

%% Select Input IR Filename
IR = 'BBW280_2025-04-28_1';

%% Load audio data from an audio file in double precision
[x,Fs] = audioread(['../Test Files/', music, format], 'double');

%% Load impulse response audio data from an audio file in double precision
filt = audioread(['../Impulse Responses/', IR, '.wav'], 'double');
filt = filt ./ mean(filt); % Normalize filter

%% Show Filter Response
%freqz(filt, 1, length(filt));

%% Apply Filter
tic;

% Slow Convolution Based Filtering
%y = filter(filt, 1, x);

% Fast FFT Based Filtering
y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));

% Normalize output audio (prevents clipping)
y = y ./ max(abs(y));

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);

time = toc; % Measures time to apply filter
disp(['It took ', sprintf('%.2f', time), ' seconds to apply the reverb.']);

%% Play Sound
player = audioplayer(y, Fs);
play(player);
disp('Press any key to end playback...');
pause;
stop(player);

%% Write Output To File
%audiowrite(['../Output Files/StillAlive', IR, '.ogg'], y, Fs);