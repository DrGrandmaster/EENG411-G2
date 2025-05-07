%% Timing Script
clear; close all;

%% Select Input Audio Filename
music = 'StillAlive';
format = '.flac';

%% Select Input IR Filename
IR = 'BBW280_2025-04-28_1';

%% Load audio data from an audio file in double precision
[x,Fs] = audioread(['../Test Files/', music, format], 'double');
x = x(:,1) + x(:,2); % Sum channels (convert to mono)

%% Load impulse response audio data from an audio file in double precision
filt = audioread(['../Impulse Responses/', IR, '.wav'], 'double');
filt = filt ./ mean(filt); % Normalize filter

%% Show Filter Response
%freqz(filt, 1, length(filt));

%% Average time to apply filter
N = 50;

time = zeros(1, N);

for i = 1:N

    %% Apply Filter
    tic;
    
    % Fast FFT Based Filtering
    y = ifft(fft(x) .* fft(padarray(filt,length(x)-length(filt),1,'post')));
    
    % Remove DC offset
    % This is a very rough High-Pass Filter, to prevent a popping sound when the audio first starts playing
    y = y - mean(y);
    
    % Normalize output audio (prevents clipping)
    y = y ./ max(abs(y));
    
    time(i) = toc; % Measures time to apply filter

    clear y;

end

disp(['It took an average of ', sprintf('%.6f', mean(time)), ' seconds to apply the reverb.']);