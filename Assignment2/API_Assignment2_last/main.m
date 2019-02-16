[X,Fs] = audioread('piano.wav');
band = Api_piano_feature_extraction(X,Fs);
bands(band);