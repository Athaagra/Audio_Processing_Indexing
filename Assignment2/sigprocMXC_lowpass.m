clc;
clear;

% simulation parameters
[X,fs] = audioread('piano.wav');
N = length(X);
timevec = (0:N-1)/fs;
npnts   = length(timevec);


% power spectrum of signal
yX = abs(fft(X)/npnts).^2;
hz = linspace(0,fs/2,floor(npnts/2)+1);


% plot its power spectrum
subplot(212)
plot(hz,yX(1:length(hz)),'k','linew',1)
xlabel('Frequency (Hz)'), ylabel('Power')
title('Frequency domain')
set(gca,'yscale','log')

%% now for lowpass filter

fcutoff = 30;
transw  = .2;
order   = round( 7*fs/fcutoff );

shape   = [ 1 1 0 0 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);

% filter kernel
filtkern = firls(order,frex,shape);

% its power spectrum
filtkernX = abs(fft(filtkern,npnts)).^2;



figure(2), clf
subplot(321)
plot((-order/2:order/2)/fs,filtkern,'k','linew',3)
xlabel('Time (s)')
title('Filter kernel')

subplot(322), hold on
plot(frex*fs/2,shape,'r','linew',1)
plot(hz,filtkernX(1:length(hz)),'k','linew',2)
set(gca,'xlim',[0 60])
xlabel('Frequency (Hz)'), ylabel('Gain')
title('Filter kernel spectrum')



%%% now apply the filter to the data
yFilt = filtfilt(filtkern,1,X);




%%% power spectra of original and filtered signal
yOrigX = abs(fft(X)/npnts).^2;
yFiltX = abs(fft(yFilt)/npnts).^2;



y1 = ifft(yFiltX,fs,'symmetric');
hplayer = audioplayer(y1, fs);
play(hplayer);
%% done.
