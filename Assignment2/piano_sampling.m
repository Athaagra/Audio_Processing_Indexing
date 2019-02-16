[y,fs,wmode,fidx]=readwav('about_time.wav','r',-1,0);
left=y(:,1);
plot(left);
figure;
spgrambw(left,16000);
frames=enframe(left, double(length(left)/8));
frames=transpose(frames);
fftdata=rfft(frames);
fftdata=fftdata.*conj(fftdata);
plot(fftdata);
plot(fftdata(:,1))
figure
plot(fftdata(:,2))
figure
%%%%%%%%%%%%%%%%%%%
