clc;
clearvars;

outputFolder = 'C:\Users\zrx\Desktop\Energy-harvesting\scan\n=3';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

T = readtable("railtrack2.txt");
acc = T{:, 2};
T = readtable("railtrack2.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

acc = detrend(acc * 9.81);

tStep = 0.00004;
t = 0:tStep:(length(acc)-1)*tStep; 
fs = 1 / tStep; % 采样率


% 循环部分
% 定义频率范围
fc_values = 3.7:0.1:4.2;
figureNumber = 1;

% 扫描
for fc = fc_values
    % Define fitter
    N = 3;
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
    displacement = detrend(displacement) * -1000;

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
    
    % path to floder
    filename = fullfile(outputFolder, ['fc=', num2str(fc) '.png']);
    
    saveas(gcf, filename);
    
    figureNumber = figureNumber + 1;
end