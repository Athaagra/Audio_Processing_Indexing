function matrix1 = Api_piano_feature_extraction(X,Fs)
fs = Fs;
N = length(X);
timevec = (0:N-1)/fs;
windowlen = 512;  
nbins = floor(length(timevec)/windowlen);
hzL = linspace(0,fs/2,floor(windowlen/2)+1);
matrix = zeros(1,length(hzL));
for ti=1:nbins
    tidx = (ti-1)*windowlen+1:ti*windowlen;
    tmpdata = X(tidx);
    x = fft(1.*tmpdata)/windowlen;
    matrix = matrix + 2*abs(x(1:length(hzL)));
end
matrix1 = matrix/nbins;








    

