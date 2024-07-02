clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\4.tst\';
path_out_beh = 'E:\Data\202305\BEH\4.tst\';

%% Parameter
NSUB = 50;
NBLK = 6;
NTAG = 6;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task
W_XY = 65536;
TH.THETA_BAD = [-15 15];
TH.THETA_MISSING = [-10 10];
TH.THETA_ACCHIT = [-0.5 0.5];
TH.RT_START = [0.21 2.2];
TH.RT_END = [0.002 2.19];
TH.POS_DIST = 500;

load([path_in_beh 'tst.mat'],'-mat');
tot_sub = size(AVG_SAME,1);

for ii = 1:6
    [h(ii), p(ii)] = ttest(AVG_SAME(:,ii),AVG_DIFF(:,ii));
end
z_avg(1,:) = mean(AVG_SAME,1);
z_avg(2,:) = mean(AVG_DIFF,1);
z_std(1,:) = std(AVG_SAME,0,1);
z_std(2,:) = std(AVG_DIFF,0,1);

subplot(2,2,1);
swarmchart(ones(tot_sub)*1,AVG_SAME(:,1),10,'b'); hold on;
swarmchart(ones(tot_sub)*2,AVG_DIFF(:,1),10,'r'); hold on;
swarmchart(ones(tot_sub)*3,AVG_SAME(:,2),10,'b'); hold on;
swarmchart(ones(tot_sub)*4,AVG_DIFF(:,2),10,'r'); hold on;
swarmchart(ones(tot_sub)*5,AVG_SAME(:,3),10,'b'); hold on;
swarmchart(ones(tot_sub)*6,AVG_DIFF(:,3),10,'r'); hold on;
plot([-0.2,0.2]+1,[z_avg(1,1), z_avg(1,1)],'b','LineWidth',3);
plot([-0.2,0.2]+2,[z_avg(2,1), z_avg(2,1)],'r','LineWidth',3);
plot([-0.2,0.2]+3,[z_avg(1,2), z_avg(1,2)],'b','LineWidth',3);
plot([-0.2,0.2]+4,[z_avg(2,2), z_avg(2,2)],'r','LineWidth',3);
plot([-0.2,0.2]+5,[z_avg(1,3), z_avg(1,3)],'b','LineWidth',3);
plot([-0.2,0.2]+6,[z_avg(2,3), z_avg(2,3)],'r','LineWidth',3);
title('反应时 '); xlabel(''); ylabel('RT (s)'); xticks(1:6);
subtitle('p=1.35e-23     p=0.14     p=6.53e-13');
xticklabels({'启动反应时 - 简单任务','启动反应时 - 复杂任务','信念形成时 - 简单任务','信念形成时 - 复杂任务','总反应时 - 简单任务','总反应时 - 复杂任务'});


subplot(2,2,2);
swarmchart(ones(tot_sub)*1,AVG_SAME(:,5),10,'b','filled'); hold on;
swarmchart(ones(tot_sub)*3,AVG_DIFF(:,5),10,'r','filled'); hold on;
errorbar(1, z_avg(1,5), z_std(1,5),'b','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
errorbar(3, z_avg(2,5), z_std(2,5),'r','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
title('偏差角度'); subtitle('p=9.6e-06'); xlabel(''); ylabel('Angle (°)'); xticks(1:2); xlim([-1 4]);
xticklabels({'简单任务','复杂任务'});

subplot(2,2,4);
swarmchart(ones(tot_sub)*1,AVG_SAME(:,6),10,'b','filled'); hold on;
swarmchart(ones(tot_sub)*3,AVG_DIFF(:,6),10,'r','filled'); hold on;
errorbar(1, z_avg(1,6), z_std(1,6),'b','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
errorbar(3, z_avg(2,6), z_std(2,6),'r','LineStyle','none','LineWidth',2,'Marker','_','MarkerSize',30);
title('击中得分 Score (0~1)'); subtitle('p=9.6e-06'); xlabel(''); ylabel('Score'); xticks(1:2); xlim([-1 4]);
xticklabels({'简单任务','复杂任务'});


subplot(2,2,3);
r1_s = 1./(AVG_SAME(:,5).*AVG_SAME(:,1));
r1_d = 1./(AVG_DIFF(:,5).*AVG_DIFF(:,1));
r2_s = 1./(AVG_SAME(:,5).*AVG_SAME(:,2));
r2_d = 1./(AVG_DIFF(:,5).*AVG_DIFF(:,2));
r3_s = 1./(AVG_SAME(:,5).*AVG_SAME(:,3));
r3_d = 1./(AVG_DIFF(:,5).*AVG_DIFF(:,3));
swarmchart(ones(tot_sub)*1,r1_s,10,'b'); hold on;
swarmchart(ones(tot_sub)*2,r1_d,10,'r'); hold on;
swarmchart(ones(tot_sub)*3,r2_s,10,'b'); hold on;
swarmchart(ones(tot_sub)*4,r2_d,10,'r'); hold on;
swarmchart(ones(tot_sub)*5,r3_s,10,'b'); hold on;
swarmchart(ones(tot_sub)*6,r3_d,10,'r'); hold on;
[h, p11] = ttest(r1_s, r1_d);
[h, p22] = ttest(r2_s, r2_d);
[h, p33] = ttest(r3_s, r3_d);
title('偏差角度/反应时 Score / RT'); xlabel(''); ylabel('Dfficiency index'); xticks(1:6);
subtitle('三组都显著 p<0.001');
xticklabels({'启动反应时 - 简单任务','启动反应时 - 复杂任务','信念形成时 - 简单任务','信念形成时 - 复杂任务','总反应时 - 简单任务','总反应时 - 复杂任务'});



fprintf('\r\n  All sub done.\r\n');
