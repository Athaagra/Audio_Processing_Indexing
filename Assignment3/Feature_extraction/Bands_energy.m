function [energy_per_band]  = Bands_energy(y,fs)
Nsamps = length(y);
ham=hamming(Nsamps);
windowed = y .* ham;
ham_fft = fft(windowed);
ham_fft = ham_fft(1:Nsamps/2); 
PowSpec = abs(fft(ham_fft).^2);
BandBarks = [1 2 4 6 8 10 12 14 16 18 20];
energy_per_band = zeros(length(BandBarks)-1,1);
for l = 1:length(BandBarks)-1 
    CurrentBand = [BandBarks(l):BandBarks(l+1)];
    energy_per_band(l) = max(abs(ham_fft(CurrentBand,:)));%% here is the power spectrum for each Barks bands
end 
Bins = zeros(length(BandBarks),1);
for j = 1:length(BandBarks)

    Bins(j)= round(BandBarks(j)/(fs/length(ham_fft)));
    
end
%for l = 1:length(Bins)-1 
%    CurrentBand = [Bins(l):Bins(l+1)];
%    figure(l);
%    plot(PowSpec(CurrentBand,:));
%end 
end
