clc,clear;
[bc,fs] = audioread('tone_and_noise.wav');


%time vector
N = length(bc);
time = (0:N-1)/fs;

% compute power spectrum and frequencies vector
pwr = abs(fft(bc)/N).^2;
hz = linspace(0,fs,N);

%%%ploting
figure(1),clf
%time-domain signal
subplot(211)
plot(time,bc,'r')
xlabel('Time (s)'),ylabel('Amplitude')
title('Time domain')

%plot power spectrum
subplot(212)
plot(hz,pwr,'k')
set(gca,'xlim',[0 1000],'ylim',[0 2])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')

freqnoise = [333];

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

audiowrite('cleanNoise.wav',y1,fs);


