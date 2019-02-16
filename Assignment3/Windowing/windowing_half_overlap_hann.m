function [data_full]  = windowing_half_overlap_hann(y,fs,name)
y = y(:,1);
window_size = 512;        % individual block size 
overlap_win = window_size/2;         % 50% overlap
data_full = zeros(1,length(y));
w = hanning(window_size);         % hanning windowing   
for ii = 1:(length(y)/window_size)-1

  data_range = ((ii-1)*overlap_win)+1:((ii-1)*overlap_win)+window_size;
%     [data_range(1) data_range(end)]
  data_block = y(data_range);

  % windowing function
  data_block = data_block.*w;
%     plot(data_block,'-rx');
%     ii 

 fft_sig = fft(data_block);                 %FFT of the signal

 % I will multiply the frequency data with an Equalizer

 ifft_sig = ifft(fft_sig);                  %iFFT of the signal

 data_full(((ii-1)*window_size)+1:((ii-1)*window_size)+window_size) = ifft_sig;

 end

audiowrite('signal_half_overlap_hanning.wav',data_full,fs);