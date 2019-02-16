clear,clc;
[X,Fs] = audioread('piano.wav');
N = length(X);

% time vector
timevec = (0:N-1)/Fs;

% plot the data
figure(1), clf
plot(timevec,X,'k')
xlabel('Time (seconds)'), ylabel('Amplitude')

% window length in seconds*Frequency
winlength = Fs/46.5;
% number of points of overlap
nOverlap = winlength;

% window onset times
winonsets = 1:nOverlap:N;

% note: different-length signal needs a different-length Hz vector
hzW = linspace(0,nOverlap,winlength);

% initialize the matrix (windows x frequencies)
matrix = zeros((length(winonsets)),8);

% loop over frequencies
for wi=1:length(winonsets)
    
    % get a chunk of data from this time window
    datachunk = X(winonsets(wi):winonsets(wi)+winlength-1);
    
    % compute its chunk the fourier transform 
    tmppow = fft(datachunk,8);
    
    new = abs(tmppow);
    
    %matrix =matrix  + new(wi);
    
    disp(new)
    
    save testfile.dat new -ascii -append

end

load testfile.dat
matrix1 = reshape(testfile,length(testfile)*8,1);
c=0;
up=zeros(1,length(matrix1));
down=zeros(1,length(matrix1));
empty=zeros(1,length(matrix1));
for C=2:length(matrix1)
    c = c +1;
    if matrix1(c)>matrix1(C)
        up(c) = [matrix1(c)];
    elseif matrix1(c)< 0
        empty(c) = [matrix1(c)];
    else
        down(c) = [matrix1(C)];
    end
end
up = nonzeros(up);
down = nonzeros(down);
empty = nonzeros(empty);

name_bands = categorical({'up bands','down bands','empty bands'});
bands = [length(up),length(down),length(empty)];
bar(name_bands,bands)
title('Piano wav bands')
    
        

