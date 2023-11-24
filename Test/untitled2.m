clc;
clearvars;

T = readtable("railtrack2.txt");
acc1 = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

acc1 = acc1(1:10000)
Dis = Dis(1:10000)

tStep = 0.0002;
t = 0:tStep:(length(acc1)-1)*tStep; 

%% detrend method 1
p = polyfit(t, acc1, 2); % n是多项式的阶数
trend = polyval(p, t);
acc = acc1 - trend; 

%% detrend method 2
acc = detrend(acc * 9.81);

%% Method 2 moving 
window_size = 10; % Number of points in the moving window
poly_order = 3;  % The order of the polynomial

% Your data vector 'data'
data = acc;

% Initialize the smoothed data vector
smoothed_data = zeros(size(data));

% Apply the 5-point 3rd-order smoothing
for i = 1:length(data)-(window_size-1)
    window_data = data(i:i+(window_size-1));
    p = polyfit((1:window_size), window_data, poly_order);
    smoothed_data(i) = polyval(p, ceil(window_size/2));
end

% Handle the boundaries (you can pad the signal or truncate the smoothed data)
acc_filtered = smoothed_data(1:length(data));


% 加载加速度数据
acc = acc_filtered;  % 假设acc_filtered是经过去趋势和滤波后的加速度数据

% FFT变换加速度数据
A = fft(acc);

% 计算频率向量
f = (0:length(acc)-1)'/length(acc)/tStep;

% 角频率向量
omega = 2*pi*f;

% 初始化位移频域向量
D_f = zeros(size(A));

% 频域积分，计算位移
% 忽略f=0的直流分量，因为它不对应实际的物理位移
D_f(2:end) = A(2:end)./(-omega(2:end).'.^2);

% 逆FFT得到位移时间序列
displacement = real(ifft(D_f));

% 由于积分可能引入的直流偏移，进行去趋势处理
displacement = detrend(displacement * 1000);

% 绘制处理后的加速度和位移信号
figure;
subplot(2,1,1);
plot(t, acc);
title('处理后的加速度信号');
xlabel('时间 (s)');
ylabel('加速度 (m/s^2)');

subplot(2,1,2);
plot(t, displacement);
title('通过频域积分得到的位移信号');
xlabel('时间 (s)');
ylabel('位移 (m)');



