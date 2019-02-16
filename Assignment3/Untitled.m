clc,clear;
[y,Fs] = audioread('sound.wav');
y = y(:,1);

timeWindow   = 20e-3;
lengthWindow = round(timeWindow*Fs); % number of samples per window

% third argument specifies the number of overlapping samples
yBuffer = buffer(y, lengthWindow, round(lengthWindow*0.2));
hammWin = hamming(lengthWindow);

yBufferWindowed = bsxfun(@times, yBuffer, hammWin);
yl = reshape(yBufferWindowed, lengthWindow*nW);


y = y(:,1);
t = linspace(0,length(y)/Fs,length(y));
plot(t,y)
winLen = 800;
winOverlap = 0;
winHamm = hamming(winLen);
sigFramed = buffer( y, winLen, winOverlap, 'nodelay');
sigWindowed = diag(sparse(winHamm)) * sigFramed;
audiowrite('neweee.wav',y1,fs);

[y,fs] = audioread('sound.wav');

enframe(y,)
%Read the data to the MATLAB using audioread.
N=length(y);                     %total num of samples
ts=0.01;                         %Frame step in seconds
frame_step=floor(ts*fs);         %Frame step in samples
frame_duration=0.025;        %Frame duration in seconds
frame_length=ceil(frame_duration*fs);  %Number of samples per frame
frame_num=ceil(N/frame_step);
%y1= buffer (N,frame_length,frame_step);

for K = 1 : size(y,2)
  y1{K} = buffer(y(:,K),frame_length,frame_step);
end