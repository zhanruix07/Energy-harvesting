clc
clearvars

T = readtable("railtrack1.txt");
acc1 = T{:, 2};

acc1 = acc1(1:1000)

tStep = 0.0002; 

t = 0:tStep:(length(acc1)-1)*tStep; 

%% detrend method 1
% p = polyfit(t, acc1, 50); % n是多项式的阶数
% trend = polyval(p, t);
% acc_moving = acc1 - trend; 

%% Moving Average Subtraction:
windowSize = 1200; % for example
movingAverage = movmean(acc1, windowSize);
acc_w = acc1 - movingAverage;
acc_w = detrend(acc_w * 9.81)

%% Method 1 Fitter
N = 2;
fc = 5.8; % 截止频率为0.5 Hz
fs = 1 / tStep; % 采样率
[B, A] = butter(N, 2*fc/fs, 'high');
acc_filtered = filter(B, A, acc_w);
acc1 = detrend(acc1 * 9.81);
%% detrend method 1
p = polyfit(t, acc1, 5); % n是多项式的阶数
trend = polyval(p, t);
acc_t = acc1 - trend; 

    

figure
subplot(1,3,1)
plot(t,acc1);
title(['accraw']);
subplot(1,3,2)
plot(t,acc_w);
title(['acc_w']);
subplot(1,3,3)
plot(t,acc_filtered);
title(['acc_filtered']);
figure
plot(t,acc_t);
title(['acc_t']);