
clear
clc

load("Data/Positions.mat");         % Load coordinates of measurement positions
load("Data/DOAs.mat");              % Load Directions-of-arrival
load("Data/PressureSignals.mat");   % Load Pressure Signals

Sr = audioread(['Audio Signals/clair_de_lune_shortened.mp3']);  % Read stereo signal
S = resample(Sr, 480, 441);

zerosamples = 2 * 48e3;                 % Two seconds of zero samples
S(end + 1:length(S) + zerosamples, 1) = 0;

Y = zeros(size(S,1) + 2 * 48000, 2);    % Add two seconds of silence to the end of the signal
Snew = zeros(3 * 48000, 2); 

headphonesElevation = 0;    % Listener's head is not elevated during simulation
rotation = 3.21;            % Degrees the listener rotates on the spiral every second

degrees = min(floor(315/rotation), floor(size(S,1)/48000 - 1));  % Either walk to the top or until end of audio

for(i = 0:degrees)  % Simulate a full spiral rotation
    
    Snew(1:48000, 1) = S(1 + 48000 * i:48000 + 48000 * i,1);    % Take next second of stereo signal with two seconds of silence added
    Snew(1:48000, 2) = S(1 + 48000 * i:48000 + 48000 * i,2);
    
    x = 10 + 8.75 * cosd(90 - i * rotation);    % Calculate next position
    y = 10 + 8.75 * sind(90 - i * rotation);
    
    headphonesAzimuth = 90 + i * rotation;      % Calculate next azimuth
        
    Ynew = auralization(Positions, DOAs, PressureSignals, x, y, headphonesAzimuth, headphonesElevation, Snew);    % Auralization at new location
    
    Y(1 + 48000 * i:(3 + i) * 48000, 1) = Y(1 + 48000 * i:(3 + i) * 48000, 1) + Ynew(:,1);
    Y(1 + 48000 * i:(3 + i) * 48000, 2) = Y(1 + 48000 * i:(3 + i) * 48000, 2) + Ynew(:,2);
    
end

audiowrite('simulation.wav', Y, 48000);       % Write to file
