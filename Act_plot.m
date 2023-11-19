clc
clearvars

T = readtable("railtrack1.txt");
Dis1 = T{:, 3};
T = readtable("railtrack2.txt");
Dis2 = T{:, 3};

tStep1 = 0.0002; 
tStep2 = 0.00004;
t1 = 0:tStep1:(length(Dis1)-1)*tStep1; 
t2 = 0:tStep2:(length(Dis2)-1)*tStep2; 
Dis1 = detrend(Dis1)
Dis2 = detrend(Dis2)
figure
% subplot(1,2,1)
plot(t1,Dis1);
title(['Act-Dis1']);
% subplot(1,2,2)
plot(t2,Dis2);
title(['Act-Dis2']);