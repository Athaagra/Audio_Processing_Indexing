clc,clear;
[y,fs] = audioread('sound.wav');
windowing(y,fs);
windowing_half_overlap(y,fs);
windowing_half_overlap_hann(y,fs);
[y,fs] = audioread('sweep_full.wav');
windowing(y,fs);
windowing_half_overlap(y,fs);
windowing_half_overlap_hann(y,fs);