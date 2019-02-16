[bc,fs] = audioread('piano.wav');
N = length(bc);


%% select frequency ranges (visual inspection)

frange{1} = [1000 4000];


%% compute and apply FIR filters

% initialize output matrix
filteredSig = cell(2,1);

% loop over filters
for filteri=1:length(frange)
    
    % design filter kernel
    order    = round( 10*fs/frange{1}(1) );
    filtkern = fir1(order,frange{filteri}/(fs/2));
    
    % loop over channels
    for chani=1:2
        
        % get data from this channel
        dat1chan = bc(:,chani);
        
        % zero-phase-shift filter with reflection
        sigR = [dat1chan(end:-1:1); dat1chan; dat1chan(end:-1:1)]; % reflect
        fsig = filter(filtkern,1,sigR);                 % forward filter
        fsig = filter(filtkern,1,fsig(end:-1:1));       % reverse filter
        fsig = fsig(end:-1:1);                          % reverse again for 0phase
        fsig = fsig(N+1:end-N);                         % chop off reflected parts
        
        % enter into the matrix
        filteredSig{filteri}(:,chani) = fsig;
    end
end

%% play

% higher frequency range
audiowrite('highfilter.wav',filteredSig{1},fs);