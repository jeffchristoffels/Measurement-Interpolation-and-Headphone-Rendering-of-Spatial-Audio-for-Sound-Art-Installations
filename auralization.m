function [Y] = auralization(Positions, DOAs, PressureSignals, x, y, headphonesAzimuth, headphonesElevation, S)

fs = 44.1e3;    % Sampling frequency
gain = 50;      % Constant gain

fn = fieldnames(DOAs);
    
if(16 < x && 15.5 < y)              % If listener is at Module 11
    DOA = DOAs.module11;
    P = PressureSignals.module11;
    z = Positions.module11(3);
elseif(16 < x && y < 4)             % If listener is at Module 12
    DOA = DOAs.module12;
    P = PressureSignals.module12;
    z = Positions.module12(3);
elseif(x < 4 && y < 4)              % If listener is at Module 13
    DOA = DOAs.module13;
    P = PressureSignals.module13;
    z = Positions.module13(3);
elseif(x < 4 && 15.5 < y)           % If listener is at Module 14
    DOA = DOAs.module14;
    P = PressureSignals.module14;
    z = Positions.module14(3);
else                                % If listener is on the Spiral
    
    closest = "Not found";              % Initiate closest measurement position
    secondClosest = "Not found";        % Initiate second closest measurement position

    closestDistance = 100;              % Initiate closest measurement distance
    secondClosestDistance = 100;        % Initiate second closest measurement distance
    
    for i = 1:numel(fn)
        if(fn{i}(1:end - 2) == "spiral")    % Only check spiral positions, skip modules
            distance = (Positions.(fn{i})(1) - x)^2 + (Positions.(fn{i})(2) - y)^2; % Euclidian distance
            if(distance < closestDistance)
                secondClosestDistance = closestDistance;
                closestDistance = distance;
                secondClosest = closest;
                closest = fn{i};
            elseif (distance < secondClosestDistance)
                secondClosestDistance = distance;
                secondClosest = fn{i};
            end
        end
    end
    
    DOA = DOAs.(closest) * (secondClosestDistance / (closestDistance + secondClosestDistance)) + DOAs.(secondClosest) * (closestDistance / (closestDistance + secondClosestDistance));
    P = PressureSignals.(closest) * (secondClosestDistance / (closestDistance + secondClosestDistance)) + PressureSignals.(secondClosest) * (closestDistance / (closestDistance + secondClosestDistance));
    z = Positions.(closest)(3) * (secondClosestDistance / (closestDistance + secondClosestDistance)) + Positions.(secondClosest)(3) * (closestDistance / (closestDistance + secondClosestDistance));
    
end
    
dx = Positions.loudspeaker(1);      % Loudspeaker x coordinate
dy = Positions.loudspeaker(2);      % Loudspeaker y coordinate
dz = Positions.loudspeaker(3);      % Loudspeaker z coordinate

azimuth = atand((dx - x)/(dy - y)) - headphonesAzimuth;
elevation = atand((dz - z)/(sqrt((dx - x)^2 + (dy - y)^2))) - headphonesElevation;


%% Create a struct for synthesis with a set of parameters

distance = sqrt((dx - x)^2 + (dy - y)^2 + (dz - z)^2);

s = createSynthesisStruct('Binaural', true, ...
        'lspLocs', [azimuth elevation distance], ...    % Loudspeaker location (azimuth, elevation, radius) 
        'HRTFset', 58, ...                              % CIPIC HRTF subject number
        'snfft', length(P), ...                         % Length of the Impulse Response
        'fs', fs, ...                                   % Sampling frequency
        'c', 345);                                      % Assumed speed of sound                
    
%% Synthesize the spatial impulse response with NLS as binaural

[H, Hbin] = synthesizeSDMCoeffs(P, DOA, s);


%% Convolution with the source signal

Y = zeros(size(S, 1), 2);

Hbin = resample(Hbin, 480, 441);    % Resample to 48 kHz sampling frequency for auralization

for channel = 1:2   % Left and Right Channel
    for lsp = 1:2   % Left and Right Ear
        Y(:,lsp) = Y(:,lsp) +  fftfilt(Hbin(:,lsp), S(:,channel)); % Convolution with Matlab's overlap-add
    end
end

Y = gain * Y;

end

