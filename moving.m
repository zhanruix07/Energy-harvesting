clc;
clearvars;

%read
T = readtable("railtrack1.txt");
acc = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3}
Dis = detrend(Dis)

tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 

acc_detrend= detrend(acc*9.81);

window_size = 5; % Number of points in the moving window
poly_order = 2;  % The order of the polynomial


% Initialize the smoothed data vector
data = acc_detrend;
smoothed_data = zeros(size(data));

% 5-point 3rd-order smoothing
for i = 1:length(data)-(window_size-1)
    window_data = data(i:i+(window_size-1));
    p = polyfit((1:window_size), window_data, poly_order);
    smoothed_data(i) = polyval(p, ceil(window_size/2));
end

% Handle the boundaries
smoothed_data = smoothed_data(1:length(data));

acc_filtered = smoothed_data;

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


subplot(1,2,1);
plot(t, smoothed_data);
title('accsmoothed ')

subplot(1,2,2);
plot(t, displacement);
title('dis ')


