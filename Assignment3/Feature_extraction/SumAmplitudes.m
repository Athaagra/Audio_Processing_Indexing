function energy = SumAmplitudes(y,Fs)
    N = 250; % window length
    df = Fs/N; % frequency increment
    y_squared = (y/Fs).*conj(y/Fs);  % Fs is used to normalize the FFT amplitudes
    energy = sum(y_squared)^2;
    plot(y_squared);
end
