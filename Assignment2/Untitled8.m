srate = 1000;
time = 0:1/srate:3;
n = length(time);
p = 15; %poles for random interpolation

%noise level, measured in standard deviations
noiseamp = 5;

%amplitude modulator and noise level
amp1 = interpl(rand(p,1)*30,linspace(1,p,n));
noise = noiseamp + randn(size(time));
signal = ampl + noise;

% substract mean to eliminate DC
signal = signal - mean(signal);

%% create Gaussian kernel

% full-width half-maximum: the key Gaussian parameter
fwhm = 25; 

% then normalize Gaussian to unit energy
gauswin = gauswin/ sum(gauswin);



