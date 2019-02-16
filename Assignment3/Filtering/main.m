[bc,fs] = audioread('piano.wav');
lowFrequencyFilter(bc,fs);
highFrequencyFilter(bc,fs);
%%% Bandpass filter
[bc,fs] = audioread('tone_and_noise.wav');
filter_of_low_and_high_frequencies(bc,fs);
%%% Adaptive filter
[bc,fs] = audioread('tone_and_noise.wav');
cleaningnoise_tone_and_noise(bc,fs);
[bc,fs] = readwav('sweep_full_and_noise.wav');
cleaningnoise_sweep_and_noise(bc,fs);
[bc,fs] = readwav('guitar.wav');
cleaningnoise_guitar(bc,fs);