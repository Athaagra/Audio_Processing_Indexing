[y,Fs] = audioread('sound.wav');
Nx = length(x);
n = 0:Nx-1;

Nwin = 1024;
Mov = ceil(3*Nwin/4);
Nfft = 2*Nwin;
w = hamming(Nwin);

[Xs,f,t] = spectrogram(x,w,Mov,Nfft,Fs);