clc;
clearvars;

T = readtable("railtrack1.txt");
acc = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

% acc = detrend(acc * 9.81);

tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 

% 假设acc是已经加载进来的加速度数据
p = polyfit(t, acc, 2); % n是多项式的阶数
trend = polyval(p, t);
acc = acc - trend; % 去除趋势

tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 


% Define fitter
N = 2;
fc = 5.6; % 截止频率为0.5 Hz
fs = 1 / tStep; % 采样率
[B, A] = butter(N, 2*fc/fs, 'high');
acc_filtered = filter(B, A, acc);

% Integral velocity
velocity = zeros(size(acc_filtered));
for i = 1:length(acc_filtered)
    velocity(i) = simpson_integration(acc_filtered(1:i), tStep);
end
velocity = detrend(velocity);

% Integral displacement
displacement = zeros(size(velocity));
for i = 1:length(velocity)
    displacement(i) = simpson_integration(velocity(1:i), tStep);
end
displacement = detrend(displacement) * 1000;

% plot
% figure;
% plot(t, acc_filtered);
% title('Filtered Acceleration-simpson');
% figure;
% plot(t, velocity);
% title('Velocity-simpson');
figure;
subplot(1,2,1)
plot(t, displacement);
title('Displacement-simpson');
subplot(1,2,2)
% figure;
plot(t,Dis);
title(['Displacement-Actual']);
