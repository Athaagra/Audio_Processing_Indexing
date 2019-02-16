[y,fs,wmode,fidx]=readwav('1000hz.wav','r',-1,0);

%The wave has only 1 channel, we do not have to select one.
left = y;
plot(left);
figure;

spgrambw(left,16000);
figure;

% Just some verbose feedback
fprintf('Number of samples: %d\n',length(left));
% Window-length of 16000 samples = 1sec
win = (length(left)/30);
disp('Window length: ');
disp(win);

%Divide the wav in frames of length win
frames = enframe(left, win);

frames=transpose(frames);
fftdata=rfft(frames);
fftdata=fftdata.*conj(fftdata);
plot(fftdata);
figure;

%Divide the wav in frames of length 0.5*win = 0.5 sec
frames = enframe(left, 0.5*win);

frames=transpose(frames);
fftdata=rfft(frames);
fftdata=fftdata.*conj(fftdata);
plot(fftdata);
figure;

%Read a square wave with the same format and length as before
[y,fs,wmode,fidx]=readwav('piano.wav','r',-1,0);

%The wave has only 1 channel, we do not have to select one.
left = y;
plot(left);
figure;

spgrambw(left,16000);
figure;

% Just some verbose feedback
fprintf('Number of samples: %d\n',length(left));

% Window-length of 16000 samples = 1sec, no overlap
win = round((length(left)/344));
disp('Window length: ');
disp(win);

%Divide the wav in frames of length win
frames = enframe(left, win);

frames=transpose(frames);
fftdata=rfft(frames);
fftdata=fftdata.*conj(fftdata);
plot(fftdata);


figure;
plot(fftdata(:,1));
figure;
plot(fftdata(:,2));
figure;
plot(fftdata(:,3));