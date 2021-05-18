 
clear;
clc;

fr = 96e3;

fs = 44.1e3;        % Sampling frequency

Radius = 0.05/2;    % Radius of the microphones [m]
micArray = ...      % Microphone positions in Cartesian coordinates [m]
    [Radius 0 0;
    -Radius 0 0;
    0 Radius 0;
    0 -Radius 0;
    0 0 Radius;
    0 0 -Radius];

a = createSDMStruct('micLocs', micArray, 'fs', fs); % SDM struct using GRAS 50VI-1 Vector Intensity Probe

RIRs = struct;
DOAs = struct;              % Struct for the Directions-of-arrival
PressureSignals = struct;   % Struct for the Pressure Signals
Positions = struct;         % Struct for Measurement Position Coordinates 


%% Position Coordinates

Positions.spiral22 = [10 19 0];
Positions.spiral23 = [16 15.5 0.75];
Positions.spiral24 = [18 10 0.375];
Positions.spiral25 = [16 4 1.125];
Positions.spiral26 = [10 1.5 1.5];
Positions.spiral27 = [4 4 1.875];
Positions.spiral28 = [1.5 10 2.25];
Positions.spiral29 = [4 15.5 2.625];

Positions.module11 = [17.5 17.5 0.375];
Positions.module12 = [17.5 2 1.125];
Positions.module13 = [2 2 1.875];
Positions.module14 = [2 17.5 2.625];

Positions.loudspeaker =	[7 21.5 2.625];


%% Spiral Positions

for i = 22:29

    %% Load data
    
    currentLocation = "spiral" + i;
    
    [A, fr] = audioread("Measurements/" + currentLocation + "_probeA.1.wav");    % Measurements Probe A
    [B, fr] = audioread("Measurements/" + currentLocation + "_probeB.1.wav");    % Measurements Probe B
    [C, fr] = audioread("Measurements/" + currentLocation + "_probeC.1.wav");    % Measurements Probe C
    [D, fr] = audioread("Measurements/" + currentLocation + "_probeD.1.wav");    % Measurements Probe D
    [E, fr] = audioread("Measurements/" + currentLocation + "_probeE.1.wav");    % Measurements Probe E
    [F, fr] = audioread("Measurements/" + currentLocation + "_probeF.1.wav");    % Measurements Probe F

    A = A(2 * fr:19 * fr);
    B = B(2 * fr:19 * fr);
    C = C(2 * fr:19 * fr);
    D = D(2 * fr:19 * fr);
    E = E(2 * fr:19 * fr);
    F = F(2 * fr:19 * fr);

    %% Generate Room Impulse Response

    RIR = get_RIR(A, B, C, D, E, F);     % Room Impulse Response

    %% Calculating SDM coëfficiënts

    RIRs.(currentLocation) = RIR;
    DOAs.(currentLocation) = SDMPar(RIR, a);        % Direction-of-arrival
    PressureSignals.(currentLocation) = RIR(:,5);   % Use the top-most microphone as the estimate for the pressure in the center of the array
    
end


%% Module Positions
    
for i = 11:14

    %% Load data
    
    currentLocation = "module" + i;
    
    [A, fr] = audioread("Measurements/" + currentLocation + "_probeA.1.wav");    % Measurements Probe A
    [B, fr] = audioread("Measurements/" + currentLocation + "_probeB.1.wav");    % Measurements Probe B
    [C, fr] = audioread("Measurements/" + currentLocation + "_probeC.1.wav");    % Measurements Probe C
    [D, fr] = audioread("Measurements/" + currentLocation + "_probeD.1.wav");    % Measurements Probe D
    [E, fr] = audioread("Measurements/" + currentLocation + "_probeE.1.wav");    % Measurements Probe E
    [F, fr] = audioread("Measurements/" + currentLocation + "_probeF.1.wav");    % Measurements Probe F

    A = A(2 * fr:19 * fr);
    B = B(2 * fr:19 * fr);
    C = C(2 * fr:19 * fr);
    D = D(2 * fr:19 * fr);
    E = E(2 * fr:19 * fr);
    F = F(2 * fr:19 * fr);

    %% Generate Room Impulse Response

    RIR = get_RIR(A, B, C, D, E, F);     % Room Impulse Response

    %% Calculating SDM coëfficiënts
        
    RIRs.(currentLocation) = RIR;
    DOAs.(currentLocation) = SDMPar(RIR, a);        % Direction-of-arrival
    PressureSignals.(currentLocation) = RIR(:,5);   % Use the top-most microphone as the estimate for the pressure in the center of the array
    
end
