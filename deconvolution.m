function [h] = deconvolution(y)

% Synchronized Swept Sine Characteristics:

f1 = 10;        % Initial frequency
f2 = 48000;     % Final frequency
fs = 96000;     % Sampling frequency
T_ = 15;        % Approx. time duration

L = round(f1/log(f2/f1) * T_)/f1;   % Rate of frequency increase

% Output Signal Spectra:

len = 2^ceil(log2(length(y)));
Y = fft(y, len)./fs;            % FFT of y

% Frequency Axis:

f_ax = linspace(0, fs, len + 1).'; 
f_ax = f_ax(1:end - 1);

% Inverse Filter in Frequency Domain:

X_ = 2 * sqrt(f_ax/L) .* exp(-1i * 2 * pi * f_ax * L .* (1 - log(f_ax/f1)) +  1i * pi/4);

% Deconvolution:

H = Y.*X_;
H(1) = 0;                   % Avoid Inf at DC

h = ifft(H, 'symmetric');   % Higher Harmonic Impulse Responses

end