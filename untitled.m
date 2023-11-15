T = readtable("20Hz.txt");
acc = T{:, 2};
T = readtable("20Hz.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

% 假设 acc 是您的加速度数据，t 是对应的时间向量
% 这里的 tStep 是根据您提供的采样率 25000 Hz 确定的
tStep = 0.00004; % 时间步长
fs = 1 / tStep;

t = (0:length(acc)-1) * tStep; % 完整的时间向量

% 移动平均滤波器参数
windowSize = 10; % 窗口大小，需要根据数据进行调整

% Step 1: 应用移动平均滤波器平滑加速度数据
acc_smoothed = movmean(acc, windowSize);

% Step 2: 高通滤波器设计和应用
N = 2; % 滤波器阶数
fc = 0.5; % 高通滤波器截止频率
[B, A] = butter(N, fc/(fs/2), 'high');
acc_filtered = filtfilt(B, A, acc_smoothed); % 使用 filtfilt 避免相位偏移

% Step 3: 频域积分
f = (0:length(acc)-1) * (fs/length(acc)); % 频率向量
omega = 2 * pi * f; % 角频率
ACC = fft(acc_filtered); % FFT转换到频域
omega(1) = 1; % 避免除以零
VEL_F = ACC ./ (1i * omega); % 频域积分得到速度
VEL_F(1) = 0; % 移除直流分量
velocity = real(ifft(VEL_F)); % 逆FFT转换回时域

DISP_F = VEL_F ./ (1i * omega); % 再次积分得到位移
DISP_F(1) = 0; % 移除直流分量
displacement = real(ifft(DISP_F)) * 1000; % 逆FFT转换回时域并转换单位为毫米

% Step 4: 绘制结果
figure;
subplot(3, 1, 1);
plot(t, acc_smoothed);
title('Smoothed Acceleration');

subplot(3, 1, 2);
plot(t, velocity);
title('Velocity');

subplot(3, 1, 3);
plot(t, displacement);
title('Displacement');
