function [data_full]  = windowing(y,fs)
y = y(:,1);
window_size = 512;        % individual block size 
overlap_win = 0;         % 0 overlap
data_full = zeros(1,length(y));
%w = hanning(512);         % hanning windowing   
for ii = 1:(length(y)/window_size)-1

 data_range = ((ii-1)*overlap_win)+1:((ii-1)*overlap_win)+512;
%     [data_range(1) data_range(end)]
 data_block = y(data_range);

 fft_sig = fft(data_block);                 %FFT of the signal

 % I will multiply the frequency data with an Equalizer

 ifft_sig = ifft(fft_sig);                  %iFFT of the signal

 data_full(((ii-1)*window_size)+1:((ii-1)*window_size)+512) = ifft_sig;

 end
audiowrite('signal_no_overlap.wav',data_full,fs);