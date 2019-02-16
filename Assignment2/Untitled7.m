[data,srate] = audioread('tone_and_noise.wav');
% time vector
pnts = length(data);
time = (0:pnts-1)/srate;

% compute power spectrum and frequencies vector
pwr = abs(fft(data)/pnts).^2;
hz  = linspace(0,srate,pnts);


%%% plotting
figure(1), clf
% time-domain signal
subplot(211)
plot(time,data,'k')
xlabel('Time (s)'), ylabel('Amplitude')
title('Time domain')

% plot power spectrum
subplot(212)
plot(hz,pwr,'k')
set(gca,'xlim',[0 400],'ylim',[0 2])
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')

