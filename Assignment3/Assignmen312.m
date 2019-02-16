clc,clear;
[X,Fs] = audioread('sound.wav');
X = X(:,1);
N = length(X);

% time vector
timevec = (0:N-1)/Fs;

% plot the data
figure(1), clf
plot(timevec,X,'k')
xlabel('Time (seconds)'), ylabel('Amplitude')

% window length in seconds*Frequency
winlength = 1 * Fs;

%number of points of overlap
nOverlap = round(winlength/2);

% window onset times
winonsets = 1:winlength:N-winlength;

% note: different-length signal needs a different-length Hz vector
hzW = linspace(0,nOverlap,winlength);

matrix = zeros(1,length(hzW));
% loop over frequencies
for wi=1:length(winonsets)
    % get a chunk of data from this time window
    datachunk = X(winonsets(wi):winonsets(wi)+winlength-1);
    % compute its chunk the fourier transform 
    tmppow = abs(fft(datachunk)).^2;
    new = ifft(tmppow);
    matrix =matrix + new(1:length(hzW));
end

y1 = ifft(matrix,N);
audiowrite('neww.wav',y1,Fs);