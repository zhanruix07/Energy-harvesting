clc;
clearvars;

mysize=5000;

T = readtable("railtrack1.txt");
acc = T{:, 2};
T = readtable("railtrack1.txt");
Dis = T{:, 3};
Dis = detrend(Dis)

acc = detrend(acc * 9.81);

tStep = 0.0002;
t = 0:tStep:(length(acc)-1)*tStep; 
fs = 1 / tStep; % 采样率
% 定义频率范围
fc_values = 0.5:0.5:6;
figureNumber = 1;

% 对每个截止频率进行迭代
for fc = fc_values
    % 定义滤波器
    N = 2;
    [B, A] = butter(N, 2*fc/fs, 'high');
    acc_filtered = filter(B, A, acc);

    % 积分速度
    velocity = zeros(size(acc_filtered));
    for i = 1:length(acc_filtered)
        velocity(i) = simpson_integration(acc_filtered(1:i), tStep);
    end
    velocity = detrend(velocity);

    % 积分位移
    displacement = zeros(size(velocity));
    for i = 1:length(velocity)
        displacement(i) = simpson_integration(velocity(1:i), tStep);
    end
    displacement = detrend(displacement) * 1000;

    % 绘制并保存位移图
    figure(figureNumber);
    subplot(1,2,1);
    plot(t, displacement);
    title(['Displacement-simpson fc=', num2str(fc)]);
    
    % 假设 Dis 是之前计算好的实际位移数据
    subplot(1,2,2);
    plot(t, Dis);
    title(['Displacement-Actual fc=', num2str(fc)]);

    % 打印图形编号
    sgtitle(['Figure ', num2str(figureNumber)]); % 如果你的MATLAB版本较老，可能不支持 sgtitle 函数
    % 如果是的话，请改用 suptitle 或者为每个 subplot 单独设置标题
   
    % 递增图形编号
    figureNumber = figureNumber + 1;
end
