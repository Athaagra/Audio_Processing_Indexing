function y_squared = SumAmplitudes(y)
    %N = 250; % window length
    Fs = 500; % sample frequency
    %df = Fs/N; % frequency increment
    y_squared = (y/Fs).*conj(y/Fs);  % Fs is used to normalize the FFT amplitudes
    plot(y_squared);
end
%energy_10Hz_to_90Hz = 2*sum(y_squared( f>=10 & f<=90,: ))*df; 