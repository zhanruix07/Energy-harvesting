clc
clearvars

T = readtable("railtrack2.txt");
acc = T{:, 2};
T = readtable("railtrack2.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

% Acceleration data acc=Acceleration;
acc = acc*9.81;% Add gravity effect
acc = detrend(acc);

% Time
tStep = 0.00004; % Length of each time step
N = length(acc)*tStep;
t = 0:tStep:N;
t(end) = [];
N = length(t);
dt = mean(diff(t)); % Average dt
fs = 1/dt; % Frequency [Hz] or sampling rate
 
% some additional high pass filtering 
N = 2;
fc = 5.6; % Hz
[B,A] = butter(N,2*fc/fs, 'high');
acc2 = filter(B,A,acc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
velocity = cumtrapz(dt, acc2);
velocity = detrend(velocity);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp = -1000* cumtrapz(dt, velocity);

% figure(1)
% plot(t,acc);
% title(['Filtered Acceleration-cumtrapz']);
% figure (2)
% plot(t,velocity);
% title(['Velocity-cumtrapz']);
figure
subplot(1,2,1)
plot(t,disp);
title(['Displacement-cumtrapz']);
subplot(1,2,2)
plot(t,Dis);
title(['Displacement-Actual']);




