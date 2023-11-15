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

% FFT变换到频率域
fft_acc = fft(acc);

% 频率向量
n = length(acc);
f = (0:n-1)*(fs/n);

% 截止频率和衰减系数(需要从文档中确定这些值)
fc = 2; % 截止频率
alpha = 0.98; % 衰减系数

% 创建衰减函数
delta = (1 - alpha) ./ (1 + (f / fc).^4);
delta = [delta, fliplr(delta(2:end-1))]; % 确保衰减函数是对称的

% 应用衰减函数到FFT结果
filtered_fft_acc = fft_acc .* delta';

% IFFT变换回时间域
acc_filtered = real(ifft(filtered_fft_acc));

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
