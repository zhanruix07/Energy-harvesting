 
clc;
clearvars;

T = readtable("railtrack1.txt");
acc = T{:, 2};
acc1 = detrend(acc)
T = readtable("railtrack1.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

acc1 = acc1(1:10000)
Dis = Dis(1:10000)

tStep = 0.0002;
t = 0:tStep:(length(acc1)-1)*tStep; 
%% detrend method 1
p = polyfit(t, acc1, 8); % n是多项式的阶数
trend = polyval(p, t);
acc1 = acc1 - trend; 
acc1 = acc1 * 9.8
%% detrend method 2
% acc = detrend(acc * 9.81);

%% Moving Average Subtraction:
% windowSize = 1200; % for example
% movingAverage = movmean(acc1, windowSize);
% acc = acc1 - movingAverage;
% acc = detrend(acc * 9.81)
%% Method 1 Fitter
N = 2;
fc = 4.5; % 截止频率为0.5 Hz
fs = 1 / tStep; % 采样率
[B, A] = butter(N, 2*fc/fs, 'high');
acc_filtered = filter(B, A, acc1);

% %% PLOT ACC
% figure;
% plot(t,acc);
% title('1')
% figure;
% plot(t,acc1);
% title('1')

%% Method 2 moving 
% window_size = 5; % Number of points in the moving window
% poly_order = 3;  % The order of the polynomial
% 
% % Your data vector 'data'
% data = acc;
% 
% % Initialize the smoothed data vector
% smoothed_data = zeros(size(data));
% 
% % Apply the 5-point 3rd-order smoothing
% for i = 1:length(data)-(window_size-1)
%     window_data = data(i:i+(window_size-1));
%     p = polyfit((1:window_size), window_data, poly_order);
%     smoothed_data(i) = polyval(p, ceil(window_size/2));
% end
% 
% % Handle the boundaries (you can pad the signal or truncate the smoothed data)
% acc_filtered = smoothed_data(1:length(data));


%% Integral velocity
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
