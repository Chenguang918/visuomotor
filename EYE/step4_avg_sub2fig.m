clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\5.avg\';
path_out_eye = 'E:\Data\202305\EYE\5.avg\';

load([path_out_eye 'sac_sub.mat']);

tot_sub = size(sac_duration,1);
swarmchart(ones(tot_sub)*1,sac_duration(:,1),10,'b','filled'); hold on;
swarmchart(ones(tot_sub)*3,sac_duration(:,2),10,'r','filled'); hold on;
errorbar(1, mean(sac_duration(:,1)), std(sac_duration(:,1)),'b','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
errorbar(3, mean(sac_duration(:,2)), std(sac_duration(:,2)),'r','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
title('眼跳持续时间'); subtitle('p=0.00064'); xlabel(''); ylabel('Duration (s)'); xticks(1:3); xlim([-1 5]);
xticklabels({'简单任务',' ','复杂任务'});
