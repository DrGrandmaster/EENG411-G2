%% IR Freq Response Plotting Script
clear; close all;

%% Select Input IR Filename
%IR = 'Bunker2025-04-23_3';
IR = 'Marquez2025-04-23_1';

%% Load impulse response audio data from an audio file in double precision
[filt, Fs] = audioread(['../Impulse Responses/', IR, '.wav'], 'double');

%% Show Filter Response
[mH, mW] = freqz(filt, length(filt));

% Plot
tiledlayout('vertical');
nexttile;

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

semilogx((Fs/2)*(mW/pi), rad2deg(unwrap(angle(mH))), 'k');
xlabel('\(f / \mathrm{Hz}\)', Interpreter='latex');
ylabel('\(\angle H(\omega) / ^{\circ}\)', Interpreter='latex');
% xlabel('\(\omega / (\pi\cdot\unit{\radian\per\samp})\)');
% ylabel('\(\Theta(H(\omega)) / \unit{\radian}\)');
title('Phase Response');
xlim('tight');
ylim('padded');
grid on;

set(gca, 'fontname', 'CMU Sans');