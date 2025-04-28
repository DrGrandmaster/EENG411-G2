%% Minimal Audio Filtering Script
clear; close all;

%% Load audio data from an audio file in double precision
[x,Fs] = audioread('../Test Files/StillAlive.flac', 'double');

%% Load impulse response audio data from an audio file in double precision
filt = audioread('../Impulse Responses/Bunker2025-04-23_1.wav', 'double');
filt = filt(:, 1); % Only needed for stereo IR

%% Show Filter Response
[mH, mW] = freqz(filt, 2^20);

% Plot
tiledlayout('vertical');
nexttile;

plot(mW/pi, abs(mH), 'k');
xlabel('\(\omega / (\pi\cdot\unit{\radian\per\samp})\)');
ylabel('\(\abs{H(\omega)}\)');
title('Magnitude Response');
xlim('tight');
ylim('padded');
grid on;

nexttile;

plot(mW/pi, unwrap(angle(mH)), 'k');
xlabel('\(\omega / (\pi\cdot\unit{\radian\per\samp})\)');
ylabel('\(\Theta(H(\omega)) / \unit{\radian}\)');
title('Phase Response');
xlim('tight');
ylim('padded');
grid on;

%% Apply Filter
tic;
y = filter(filt, 1, x);
y = y ./ max(y); % Normalize output audio (prevents clipping)
toc % Measures time to apply filter

%% Play Sound
%sound(y,Fs);

%% Write Output To File
audiowrite('../Output Files/output.ogg',y,Fs);