%% Evaluating Performance of Audio Filtering Script
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

%% Select Input Measured Response Filename
MR = 'StillAliveBBW280'; % Double check this is the same space as the IR

%% Load real reverb'd sound
trueY = audioread(['../Measured Responses/', MR, '.wav'], 'double');
trueY = trueY ./ max(abs(trueY)); % Normalize real audio

%% Apply Filter

% Fast FFT Based Filtering
y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);

% Normalize output audio (prevents clipping)
y = y ./ max(abs(y));

