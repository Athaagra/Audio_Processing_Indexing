clc,clear;
[bc,fs] = readwav('sweep_full_and_noise.wav');
bc= bc(:,1);
%time vector
N = length(bc);
time = (0:N-1)/fs;
% compute power spectrum and frequencies vector
pwr = abs(fft(bc)/N).^2;
hz = linspace(0,fs,N);
freqnoise = [423];
datafilt = bc;
%loop over frequncies
for k = 1:length(freqnoise)
    % create filter kernel using firl
    frange = [freqnoise(fi)-.6 freqnoise+.6];
    order = round( 20*fs/frange(1) );
    % filter kernel
    filtkern = fir1( order,frange/(fs/2),'stop' );
    % recursively apply to data
    datafilt = filtfilt(filtkern,1,datafilt); 
end
% compute the power spectrum of the filtered signal
pwrfilt = abs(fft(datafilt)/N).^2;
y1 = ifft(pwrfilt,N,'symmetric');
% original
soundsc(y1,fs)
audiowrite('cleansweepfull_and_noise.wav',y1,fs);


