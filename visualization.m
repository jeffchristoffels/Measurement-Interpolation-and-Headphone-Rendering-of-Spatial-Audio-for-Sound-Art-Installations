
clear
clc

fs = 44.1e3;    % Sampling frequency of 44.1 kHz

load("Data/DOAs.mat");              % Load Directions-of-arrival
load("Data/PressureSignals.mat");   % Load Pressure Signals

DOA{1} = DOAs.spiral29;             % To be analyzed DOA
P{1} = PressureSignals.spiral29;    % To be analyzed pressure signal

timeWindows = [0 5 10 50 500 1000]; % Time windows

v = createVisualizationStruct('name', 'Audio Lab', 'fs', fs, ...
    'plotStyle', 'fill', 't', timeWindows, 'DOI', 'backward', 'Colors', gray(length(timeWindows)));

% For visualization purposes, set the text interpreter to latex
set(0, 'DefaultTextInterpreter', 'latex');

v.plane = 'lateral';

parameterVisualization(P, v);                   % Plot analyzed time windows
title('Applied time windowing and impulse responses', 'FontSize', 24);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',30);

timeFrequencyVisualization(P, v);               % Plot time-frequency representation of the measured pressure signal
title('Time frequency visualization', 'FontSize', 24);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',30);

spatioTemporalVisualization(P, DOA, v);         % Plot spatiotemporal visualization
title('', 'FontSize', 24);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18);

figure
spectrogram(P{1}, 256, 250, 256, fs,'yaxis');   % Plot spectrogram
title('Spectrogram impulse response probe E', 'FontSize', 24);
xlabel('Time [s]', 'FontSize', 24);
ylabel('Amplitude', 'FontSize', 24);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',30);
