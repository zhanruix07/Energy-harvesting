clc;
clearvars;

mysize=5000;

T = readtable("railtrack1.txt");
acc = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3};
Dis = detrend(Dis);

acc = detrend(acc * 9.81);

tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 
fs = 1 / tStep; % 采样率


% 循环部分
% 定义频率范围
fc_values = 2:0.5:5;
figureNumber = 1;

% 扫描
for fc = fc_values
    % Define fitter
    N = 2;
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
    figure(figureNumber);
    subplot(1,2,1);
    plot(t, displacement);
    title(['Displacement-simpson fc=', num2str(fc)]);
    
  
    subplot(1,2,2);
    plot(t, Dis);
    title(['Displacement-Actual fc=', num2str(fc)]);

    % print with number
    sgtitle(['Figure ', num2str(figureNumber)]);
    figureNumber = figureNumber + 1;
end
