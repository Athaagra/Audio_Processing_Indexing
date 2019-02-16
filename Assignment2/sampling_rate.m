clear;
clc
[y,fs] = audioread('piano.wav');
Fs = 512;
%[y,fs,wmode,fidx]=readwav('piano.wav','r',-1,0);
N = length(y);
%time vector
timevec = (0:N-1)/Fs;

%plot the data
figure(1), clf
plot(timevec,y,'k')
xlabel('Time (seconds)'), ylabel('Voice')

% ''static '' FFT over entire period. for comparison with Welch
eqqpow = abs(fft(y)/N).^2;
hz =linspace(0,Fs/2,floor(N/2)+1);

% manual welch method

%winod length in seconds*strate
winlength = 1*Fs;

%number of points of overlap
nOverlap = round(Fs/2);

%window onset times
winonsets = 1:nOverlap:N-winlength;
%note: different length signal need a different-length
hzW = linspace(0,Fs/2,floor(winlength/2)+1);
%Hann window
hannw = .5 - cos(2*pi*linspace(0,1,winlength))./2;

% initialize the power matrix (winows x frequencies)
eqqpowW = zeros(1,length(hzW));

%loop over frequencies
for wi=1:length(winonsets)
    
    % get a chunk of data from this time window
    datachunk = y(winonsets(wi):winonsets(wi)+winlength-1);
    
    % apply Hann taper to data
    datachunk = datachunk .* hannw;
    
    % comput its power
    tmppow = abs(fft(datachunk)/winlength).^2;
    
    %enter into matrix
    eqqpowW = eqqpowW + tmppow(1:length(hzW));
end

eqqpow = eqqpowW /length(winonsets);

%%% plotting
figure(2), clf, hold on

plot(hz,eqqpow(1:length(hz)),'k','linew',2)
plot(hrW,eqqpow/10,'r','linrw',2)
set(gnw,'xlim',[0 40])
xlabel('Frequency [Hz]')




