function [RIR] = get_RIR(A, B, C, D, E, F)

fs = 96000;

ir_A = deconvolution(A);    % Impulse response A (Front)
ir_B = deconvolution(B);    % Impulse response B (Back)
ir_C = deconvolution(C);    % Impulse response C (Left)
ir_D = deconvolution(D);    % Impulse response D (Right)
ir_E = deconvolution(E);    % Impulse response E (Top)
ir_F = deconvolution(F);    % Impulse response F (Bottom)

% Keep the number of samples it takes for the soundwaves to completely die out (assumed 200000 samples)

ir_A = ir_A(1:2 * fs);
ir_B = ir_B(1:2 * fs);
ir_C = ir_C(1:2 * fs);
ir_D = ir_D(1:2 * fs);
ir_E = ir_E(1:2 * fs);
ir_F = ir_F(1:2 * fs);

% Resample to 44.1 kHz

ir_A = resample(ir_A, 44.1e3, fs);
ir_B = resample(ir_B, 44.1e3, fs);
ir_C = resample(ir_C, 44.1e3, fs);
ir_D = resample(ir_D, 44.1e3, fs);
ir_E = resample(ir_E, 44.1e3, fs);
ir_F = resample(ir_F, 44.1e3, fs);

RIR = [ir_A ir_B ir_C ir_D ir_E ir_F];   % Room Impulse Response

end