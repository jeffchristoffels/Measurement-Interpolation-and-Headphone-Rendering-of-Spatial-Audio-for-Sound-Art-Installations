
fs = 96e3;  % Sampling frequency
gain = 50;

load("Data/Positions.mat");         % Load coordinates of measurement positions

[L, fs] = audioread("Measurements/module13_head0L.1.wav");
[R, fs] = audioread("Measurements/module13_head0R.1.wav");

L = L(4 * fs:21 * fs);      % Only keep relevant parts of the measurements
R = R(4 * fs:21 * fs);

ir_L = deconvolution(L);    % Left Impulse Response
ir_R = deconvolution(R);    % Right Impulse Response

ir_L = ir_L(1:2 * fs);      % Assumed echoes die out after two seconds during measurements
ir_R = ir_R(1:2 * fs);

Hbin = [ir_L ir_R];                 % Binaural Impulse Response
Hbin = resample(Hbin, 48e3, fs);    % Resample to 48 kHz sampling frequency for auralization


%% Convolution with the source signal

S = audioread(['Audio Signals/clair_de_lune.mp3']);     % Read stereo signal
Sr = resample(S, 480, 441);                             % Resample to 48 kHz

Y = zeros(size(Sr,1),2);

Hbin = resample(Hbin, 48e3, fs);    % Resample to 48 kHz sampling frequency for auralization

for channel = 1:2   % Left and Right Channel
    for lsp = 1:2   % Left and Right Ear
        Y(:,lsp) = Y(:,lsp) +  fftfilt(Hbin(:,lsp), Sr(:,channel)); % Convolution with Matlab's overlap-add
    end
end

Y = gain * Y;
audiowrite('module13_binauralhead0.wav', Y, 48000);

