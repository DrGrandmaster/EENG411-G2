%% IR Freq Response Plotting Script
clear; close all;

%% Select Input IR Filename
IR = 'BBW280_2025-04-28_1';

%% Load impulse response audio data from an audio file in double precision
[filt, Fs] = audioread(['../Impulse Responses/', IR, '.wav'], 'double');
filt = filt ./ mean(filt); % Normalize filter

%% Show Filter Response

% Calculate Magnitude and Phase Response
[mH, mW] = freqz(filt, 1, 100*length(filt));

% Calculate Group Delay
mT = grpdelay(filt, 1, 100*length(filt));

% Plot
tiledlayout('flow');
nexttile;

plot((0:length(filt) - 1) ./ Fs, filt, 'k');
xlabel('\(t / \mathrm{s}\)', Interpreter='latex');
ylabel('\(h\)', Interpreter='latex');
% xlabel('\(t / (\unit{\second})\)');
% ylabel('\(h\)');
title('Impulse Response');
xlim('tight');
ylim('padded');
grid on;

nexttile;

%plot((Fs/2)*(mW/pi), 20*log10(abs(mH)), 'k');
semilogx((Fs/2)*(mW/pi), 20*log10(abs(mH)), 'k');
xlabel('\(f / \mathrm{Hz}\)', Interpreter='latex');
ylabel('\(\left|H(\omega)\right| / \mathrm{dB}\)', Interpreter='latex');
% xlabel('\(\omega / (\pi\cdot\unit{\radian\per\samp})\)');
% ylabel('\(\abs{H(\omega)}\)');
title('Magnitude Response');
xlim('tight');
ylim('padded');
grid on;

nexttile;

%plot((Fs/2)*(mW/pi), rad2deg(unwrap(angle(mH))), 'k');
semilogx((Fs/2)*(mW/pi), rad2deg(unwrap(angle(mH))), 'k');
xlabel('\(f / \mathrm{Hz}\)', Interpreter='latex');
ylabel('\(\angle H(\omega) / ^{\circ}\)', Interpreter='latex');
% xlabel('\(\omega / (\pi\cdot\unit{\radian\per\samp})\)');
% ylabel('\(\Theta(H(\omega)) / \unit{\radian}\)');
title('Phase Response');
xlim('tight');
ylim('padded');
grid on;