clc,clear;
[X,Fs] = audioread('sound.wav');
N = length(X);

% time vector
timevec = (0:N-1)/Fs;

% plot the data
figure(1), clf
plot(timevec,X,'k')
xlabel('Time (seconds)'), ylabel('Amplitude')

% window length in seconds*Frequency
winlength = Fs/31.2;
% number of points of overlap
nOverlap = winlength;

% window onset times
winonsets = 1:nOverlap:N;

% note: different-length signal needs a different-length Hz vector
hzW = linspace(0,nOverlap,winlength);

matrix = zeros(1,length(hzW));
% loop over frequencies
for wi=1:length(winonsets)
    
    % get a chunk of data from this time window
    datachunk = X(winonsets(wi):winonsets(wi)+winlength-1);
    
    % compute its chunk the fourier transform 
    tmppow = fft(datachunk);
    
    new = ifft(tmppow);
    
    matrix =matrix  + new(1:length(hzW));
    
end


plot(matrix)