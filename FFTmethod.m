clc
clearvars

T = readtable("railtrack.txt");
acc = T{:, 2};

% Convert acceleration data from g to m/s^2 and detrend
acc = acc * 9.81;
acc = detrend(acc);

% Time parameters
tStep = 0.0002;
t = 0:tStep:(length(acc) - 1) * tStep;

% Perform FFT
acc_fft = fft(acc);

% Get frequency vector
n = length(acc);              % number of points
f = (0:n-1)*(1/(tStep*n));    % frequency range
omega = 2*pi*f;               % angular frequency

% Perform integration in the frequency domain
% Avoid division by zero at the first element (DC component)
omega(1) = 1;
vel_fft = acc_fft ./ (1i * omega);
disp_fft = vel_fft ./ (1i * omega);

% Set the DC component (mean of the signal) to zero after integration
vel_fft(1) = 0;
disp_fft(1) = 0;

% Perform IFFT
velocity = real(ifft(vel_fft));
displacement = real(ifft(disp_fft)) * 1000;  % convert to mm

% Plot the results
figure;
plot(t, acc);
title('Acceleration');
figure;
plot(t, velocity);
title('Velocity');
figure;
plot(t, displacement);
title('Displacement');
