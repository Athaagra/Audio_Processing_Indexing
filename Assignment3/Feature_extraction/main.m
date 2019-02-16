[y, fs] = audioread('metal.wav');
[y1, fs1] = audioread('classical.wav');
[y2, fs2] = audioread('unknown.wav');

xMet =  ZCR(y);
xClas = ZCR(y1);
xUn = ZCR(y2);

disp("Metal:"+xMet);
disp("Classical:"+xClas);
disp("Unknown:"+xUn);
c = categorical({'metal','classical','unkown'});
values = [xMet xClas xUn];
bar(c,values)

sMetal = SumAmplitudes(y,fs);
sClas = SumAmplitudes(y1,fs);
sU = SumAmplitudes(y2,fs);

x = melcepst(y,fs);
meanx = mean(x);
plot(meanx)
title('Mel-Cept Metal wav');
x1 = melcepst(y1,fs1);
meanx1 = mean(x1);
plot(meanx1)
title('Mel-Cept Classical wav');
x2 = melcepst(y2,fs2);
meanx2 = mean(x2);
plot(meanx2)
title('Mel-Cept Unknown wav');

xMe =Bands_energy(y,fs);
bar(xMe);
title('Energy of Metal wav of 20Hz');
xCl =Bands_energy(y1,fs1);
bar(xCl)
title('Energy of Classical wav of 20Hz');
xU =Bands_energy(y2,fs2);
bar(xU)
title('Energy of Unkown wav of 20Hz');



