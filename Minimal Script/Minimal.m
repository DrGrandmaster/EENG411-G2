%% Minimal Audio Filtering Script
clear; close all;

%% Load audio data from an audio file in double precision
[x,Fs] = audioread('fan2.ogg', 'double');

%% Design linear-phase FIR filter to attenuate all frequencies above 15kHz

% Frequencies / Hz
f = [14e3 15e3];

% Ripple / dB
passRip = 3;
stopRip = 50;

rip = [(10^(passRip/20)-1)/(10^(passRip/20)+1) 10^(-stopRip/20)]; 

% FIR - Parks-McClellan
[M,fo,ao,w] = firpmord(f,[1 0],rip,Fs);
filt = firpm(M, fo, ao, w);

% Show Filter Response
%freqz(filt);

%% Apply Filter
y = filter(filt, 1, x);

%% Play Sound
sound(y,Fs);