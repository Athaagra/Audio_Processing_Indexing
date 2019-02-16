clc,clear;
Fs = 44100;
y = audioread('piano.wav');

NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*Fs).';

magnitudeY = abs(Y);        % Magnitude of the FFT
phaseY = unwrap(angle(Y));  % Phase of the FFT


fcutoff = 100;
transw  = .2;
order   = round( 7*Fs/fcutoff );

shape   = [ 1 1 0 0 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw Fs/2 ] / (Fs/2);

% filter kernel
filtkern = firls(order,frex,shape);

% its power spectrum
filtkernX = abs(fft(filtkern,F)).^2;

yFilt = filtfilt(filtkern,1,Y);


y1 = ifft(yFilt,NFFT,'symmetric');
hplayer = audioplayer(y1, Fs);
play(hplayer);