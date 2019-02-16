frames=enframe(left, uint16(length(left)/6));
frames=transpose(frames);
fftdata=rfft(frames);
fftdata=fftdata.*conj(fftdata);
plot(fftdata);