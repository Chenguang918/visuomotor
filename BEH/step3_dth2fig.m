clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\4.tst\';
path_out_beh = 'E:\Data\202305\BEH\4.tst\';

load([path_in_beh 'dth4fig.mat']);

tot_sub = size(DTH_SAME_RAW,1);

avg_same = mean(DTH_SAME_RAW);
avg_diff = mean(DTH_DIFF_RAW);

sem_same = std(DTH_SAME_RAW)/sqrt(tot_sub);
sem_diff = std(DTH_DIFF_RAW)/sqrt(tot_sub);

% plot(x_th-0.1, avg_same,'b'); hold on;
% plot(x_th+0.1, avg_diff,'r'); hold on;

errorbar(x_th, avg_same, sem_same, '-ob', "LineWidth",2, "CapSize",15, "MarkerSize",6, "MarkerFaceColor",'b'); hold on;
errorbar(x_th, avg_diff, sem_diff, '-or', "LineWidth",2, "CapSize",15, "MarkerSize",6, "MarkerFaceColor",'r'); hold on;

legend('Easy','Hard');
