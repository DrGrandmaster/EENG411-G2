%% Minimal Audio Filtering Script
clear; close all;

%% Load audio data from an audio file in double precision
[x,Fs] = audioread('../TestFiles/fan2.ogg', 'double');

%% Design a linear-phase FIR filter to attenuate all frequencies above 15kHz

% Frequencies / Hz
f = [14e3 15e3];

% Ripple / dB
passRip = 3;
stopAtten = 50;

rip = [(10^(passRip/20)-1)/(10^(passRip/20)+1) 10^(-stopAtten/20)]; 

% FIR - Parks-McClellan
[M,fo,ao,w] = firpmord(f,[1 0],rip,Fs);
filt = firpm(M, fo, ao, w);

% Show Filter Response
%freqz(filt);

%% Apply Filter
tic;
y = filter(filt, 1, x);
toc % Measures time to apply filter

%% Play Sound
%sound(y,Fs);