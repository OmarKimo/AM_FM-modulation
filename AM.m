% reset the command window, environment variables, and all figures.
clear;
close all;
clc;
% read the audio
filename = 'trial_sound.wav';
[audio, Fs] = audioread(filename);
%sound(audio);
info = audioinfo(filename);
duration = info.Duration;
Fc = 100*1000;  % carrier frequency
Wc = 2*pi*Fc;
[num, bla] = size(audio);
T = 1/Fs;
t = 0:T:(num-1)*T;
Mp = abs(min(audio));
carrier = cos(Wc*t);
Mu = 0.9;
Ac = Mp/Mu;
modulated = (Ac + audio).*carrier';
idx = 1;
% apply different noise values to the signal
for snr = 0:20
    noised = awgn(modulated, snr);
    [yupper, ylower] = envelope(noised);
    demodulated = yupper - mean(yupper);
    %sound(demodulated);
    %pause(duration+1);
    SNRs(idx) = snr;    % build the SNR array.
    MSEs(idx) = immse(audio, demodulated);  % build the Mean Square Error array.
    idx = idx+1;
end
figure;
plot(SNRs, MSEs);
title('SNR vs MSE');
xlabel('SNR value');
ylabel('MSE value');