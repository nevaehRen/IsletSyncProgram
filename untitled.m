
clear;
clc;
close all;

load Data.mat

time=data(:,1)';
data=data(:,2:end)';


figure(1)
imagesc(data)


Index=[14 15];
figure(2)
plot(data(Index,:)')
legend('14','15')