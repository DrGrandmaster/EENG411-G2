%% Evaluating Performance of Audio Filtering Script
clear; close all;

%% Select Input Audio Filename
music = 'StillAlive';
format = '.flac';

%% Select Input IR Filename
IR = 'BBW280_2025-04-28_1';

%% Load audio data from an audio file in double precision
[x,Fs] = audioread(['../Test Files/', music, format], 'double');
x = x(:,1) + x(:,2); % Sum channels (convert to mono)
x = x ./ max(abs(x)); % Normalize input audio

%% Load impulse response audio data from an audio file in double precision
filt = audioread(['../Impulse Responses/', IR, '.wav'], 'double');
filt = filt ./ mean(filt); % Normalize filter

%% Select Input Measured Response Filename
MR = 'StillAliveBBW280'; % Double check this is the same space as the IR and song as x

%% Load real reverb'd sound
trueY = audioread(['../Measured Responses/', MR, '.wav'], 'double');
trueY = trueY ./ max(abs(trueY)); % Normalize real audio

%% Select Input Dry Response Filename
DRY = 'StillAliveDry'; % Double check this is the same song as x

%% Load dry sound (speaker only, minimized room effects)
dryY = audioread(['../Measured Responses/', DRY, '.wav'], 'double');
dryY = dryY ./ max(abs(dryY)); % Normalize dry audio

%% Apply Filter

% Fast FFT Based Filtering
y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));

% Remove DC offset
% This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
y = y - mean(y);

% Normalize output audio (prevents clipping)
y = y ./ max(abs(y));

%% Use Cross-Correlation to Evaluate Filter Accuracy

% Compare Source Audio and Dry Audio
% We will use this as our benchmark for matching (we need an idea of how close a match is realistic)
corrXtoDryY = xcorr(x, trueY);
bench = max(corrXtoDryY);

% Compare True Audio and Processed Audio
corrYtoTrueY = xcorr(y, trueY);
comp = max(corrYtoTrueY);

% Score, based on comparing the peaks of the cross correlations
score = comp / bench;
disp(['The reverb effect matches the true reverb ', sprintf('%.2f', score*100), '% as well as the original audio matches the dry audio.']);

%% Compare Spectra to Evaluate Filter Accuracy

% FFT length (same for all)
N = 2^15;

% Find Spectra (magnitude only, xcorr was comparing time info
specY = abs(fft(y, N));
specTrueY = abs(fft(trueY, N));

% Compare True Audio and Processed Audio Spectra
scoreSpect = corrcoef(specY, specTrueY);
scoreSpect = scoreSpect(1, 2);
disp(['The spectrum of the reverb effect correlates with the spectrum of true reverb with R = ', sprintf('%.2f', scoreSpect), '.']);

%% Apply inverse filter to real sound and compare to original sound
simX = ifft(fft(trueY) .* ((fft(padarray(filt,length(trueY)-length(filt),1,'post'))).^(-1)));
simX = simX ./ max(abs(simX)); % Normalize

% Compare True Audio and Processed Audio
corrSimXtoX = xcorr(simX, x);
compInv = max(corrSimXtoX);

% Score, based on comparing the peaks of the cross correlations
scoreInv = compInv / bench;
disp(['The reverse effect matches the original sound ', sprintf('%.2f', scoreInv*100), '% as well as the original audio matches the dry audio.']);