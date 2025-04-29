%% Evaluating Performance of Audio Filtering Script
clear; close all;

%% Select Input Audio Filename for Filtering
music = 'StillAlive';
format = '.flac';

%% Select Input IR Filename
IR = 'BBW280_2025-04-28_1';


%% Load audio data from an audio file in double precision
[x,Fs] = audioread(['../Test Files/', music, format], 'double');

%% Load impulse response audio data from an audio file in double precision
filt = audioread(['../Impulse Responses/', IR, '.wav'], 'double');
filt = filt ./ mean(filt); % Normalize filter

%% Apply Filter
tic;

% Fast FFT Based Filtering
y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));

% Normalize output audio (prevents clipping)
y = y ./ max(abs(y));

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);



%% Select Input Audio Filename from Actual Space
musicInSpace = 'StillAliveActual';
format = '.flac';

%% Load impulse response audio data of space itself from an audio file in double precision
impulseSpace = audioread(['../Impulse Responses/', IR, '.wav'], 'double');



[y, Fs]=audioread("StillAliveBBW280.wav");
lx = length(x);
ly = length(y);
samples = 1:min(lx,ly);
 subplot(3,1,1), plot (x(samples));
 subplot(3,1,2), plot (y(samples));
 [C1, lag1] = xcorr(x(samples),y(samples));
  subplot(3,1,3), plot(lag1/fs,C1);
  ylabel("Amplitude"); grid on
   title("Cross-correlation ")