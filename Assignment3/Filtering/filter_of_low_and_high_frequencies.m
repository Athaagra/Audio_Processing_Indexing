function filterband = filter_of_low_and_high_frequencies(bc,fs)
N = length(bc);
frange{1} = [10 400];
frange{2} = [1500 3000];
filteredSig = cell(2,1);
for filteri=1:length(frange)
    order    = round( 10*fs/frange{1}(1) );
    filtkern = fir1(order,frange{filteri}/(fs/2));
    for chani=1:1
        dat1chan = bc(:,chani);
        sigR = [dat1chan(end:-1:1); dat1chan; dat1chan(end:-1:1)]; % reflect
        fsig = filter(filtkern,1,sigR);                 % forward filter
        fsig = filter(filtkern,1,fsig(end:-1:1));       % reverse filter
        fsig = fsig(end:-1:1);                          % reverse again for 0phase
        fsig = fsig(N+1:end-N);                         % chop off reflected parts
        filteredSig{filteri}(:,chani) = fsig;
    end
end
filterband = filteredSig{1};
audiowrite('band_pass_tone_and_noise.wav',filteredSig{1},fs);
end

