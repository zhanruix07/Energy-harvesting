clc;
clearvars;

%read
T = readtable("railtrack1.txt");
acc = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3}
Dis = detrend(Dis)

%define t 
tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 

%% Method 1 detrend
acc_detrend= detrend(acc);

%% Method 2 moving 
window_size = 5; % Number of points in the moving window
poly_order = 3;  % The order of the polynomial

% Your data vector 'data'
data = acc_detrend;

% Initialize the smoothed data vector
smoothed_data = zeros(size(data));

% Apply the 5-point 3rd-order smoothing
for i = 1:length(data)-(window_size-1)
    window_data = data(i:i+(window_size-1));
    p = polyfit((1:window_size), window_data, poly_order);
    smoothed_data(i) = polyval(p, ceil(window_size/2));
end

% Handle the boundaries (you can pad the signal or truncate the smoothed data)
smoothed_data = smoothed_data(1:length(data));

%% Method 3 Fitter
N = 2;
fc =5.6; % 截止频率为0.5 Hz
fs = 1 / tStep; % 采样率
[B, A] = butter(N, 2*fc/fs, 'high');
acc_filtered = filter(B, A, acc);

% plot
% figure;
% plot(t, displacement);
% title('Displacement')

figure;
subplot(1,4,1);
plot(t, acc);
title('acc')

subplot(1,4,2);
plot(t, acc_detrend);
title('accdetrend')

subplot(1,4,3);
plot(t, acc_filtered);
title('accfiltered ')

subplot(1,4,4);
plot(t, smoothed_data);
title('accsmoothed ')




