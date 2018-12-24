% reset the command window, environment variables, and all figures.
clear;
close all;
clc;
% read the audio
filename = 'trial_sound.wav';
[audio, Fs0] = audioread(filename);
%sound(audio);
info = audioinfo(filename);
duration = info.Duration;
Fc = 100*1000;  % carrier frequency
Wc = 2*pi*Fc;
Beta = 5; % it equals to dTheta
Fs = 3*Fc; % new sampling rate
audio2 = resample(audio, Fs, Fs0); % resampling the audio so that it can be demodulated.
dF = Beta * (Fs0 /2); % max frequency deviation
Am = max(audio2);
Kf = (dF*2*pi)/Am;    % frequency deviation constant
[num, bla] = size(audio2);
T = 1/Fs;
t = 0:T:(num-1)*T;
m_t = cumsum(audio2)/Fs;     % phase deviation = m(t)
modulated = cos(Wc*t' + Kf*m_t);

idx = 1;
% apply different noise values to the signal
for snr = 0:20
    noised = awgn(modulated, snr);
    demodulated = fmdemod(noised, Fc, Fs, dF);
	demodulated = resample(demodulated, Fs0, Fs);
    %sound(demodulated, Fs0);
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
plot(SNRs, MSEs);