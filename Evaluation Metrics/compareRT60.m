function compareRT60(filt, y, Fs)

    % Normalize both signals
    filt = filt(:) / max(abs(filt));
    y = y(:) / max(abs(y));

    % Compute RT60 from Impulse Response
    rt60_ir = computeRT60(filt, Fs);
    fprintf('Estimated RT60 from Impulse Response: %.3f s\n', rt60_ir);

    % Estimate RT60 from real-space recording (via Energy Decay Curve) 
    % For real signal, reverse integrate the envelope to simulate EDC
    env = abs(hilbert(y)); % use Hilbert envelope
    rt60_real = computeRT60(env, Fs);
    fprintf('Estimated RT60 from Real Recording: %.3f s\n', rt60_real);
end

function rt60 = computeRT60(sig, Fs)
    % Compute energy decay curve (EDC) using Schroeder's method
    edc = flipud(cumsum(flipud(sig.^2)));
    edc_db = 10 * log10(edc / max(edc));
    
    % Find time indices at -5 dB and -35 dB
    idx_start = find(edc_db <= -5, 1, 'first');
    idx_end   = find(edc_db <= -35, 1, 'first');

    % Guard against empty values
    if isempty(idx_start) || isempty(idx_end)
        rt60 = NaN;
        warning('Could not estimate RT60: insufficient decay in signal.');
        return;
    end

    % Time corresponding to each index
    t1 = idx_start / Fs;
    t2 = idx_end / Fs;

    % Linear extrapolation for RT60
    rt60 = (t2 - t1) * (60 / (35 - 5));
end