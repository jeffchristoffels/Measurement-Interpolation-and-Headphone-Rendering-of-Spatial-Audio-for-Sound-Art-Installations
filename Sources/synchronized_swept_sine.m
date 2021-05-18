
clear;
clc;


%% Synchronized Swept-Sine Signal Generation

f1 = 10;        % Initial frequency
f2 = 48000;     % Final frequency
fs = 96000;     % Sampling frequency
T_ = 15;        % Approx. time duration

L = round(f1/log(f2/f1) * T_)/f1;           % Rate of frequency increase
T = L * log(f2/f1);                         % Duration of the swept sine
t = (0:ceil(fs * T) - 1)./fs;
x = sin(2 * pi * f1 * L * (exp(t/L))).';    % Synchronized Swept-Sine signal


%% fade-out the input signal

fd2 = 9216; % number of samlpes 
fade_out = (1-cos((0:fd2-1)/fd2*pi))/2;
index = (1:fd2)-1; x(end-index) = x(end-index).*fade_out.';


%% Add a segment of silence to the input signal

zerosamples = 2 * fs;   % Two seconds of zero samples
x(end + 1:length(x) + zerosamples) = 0;


%% Write to audio file

audiowrite('synchronized_swept_sine_15.wav', x, fs)   % Write Synchronized Swept-Sine to .flac file
