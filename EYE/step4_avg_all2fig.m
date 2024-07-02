clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\5.avg\';
path_out_eye = 'E:\Data\202305\EYE\5.avg\';
load('..\INF\MK_EEG.mat');

%% Parameter
FS_EYE = 1000;
NSUB = 50;
NBLK = 6;
NTAG = 6;
N_TSK_SAM = 43;
N_TSK_ALL = 172;
TPT_TW = [0 0.5]*FS_EYE; % sample


file_out_eye = 'tst_all.mat';
load([path_out_eye file_out_eye]);

for ii = 1:size(SAC_SAME,1)
    [h(ii), p(ii)] = ttest(SAC_SAME(ii,:),SAC_DIFF(ii,:));
end

avg_sac_s = mean(SAC_SAME,2)';
sem_sac_s = (std(SAC_SAME'))./sqrt(size(SAC_SAME,2));
avg_sac_d = mean(SAC_DIFF,2)';
sem_sac_d = (std(SAC_DIFF'))./sqrt(size(SAC_SAME,2));

xt = ((TPT_TW(1):TPT_TW(2))./FS_EYE);
plot(xt,avg_sac_s,'.b'); hold on;
plot(xt,avg_sac_d,'.r'); hold on;
pic01 = fill([xt,fliplr(xt)],[avg_sac_s-sem_sac_s,fliplr(avg_sac_s+sem_sac_s)],'b'); hold on;
set(pic01,'edgealpha', 0, 'facealpha', 0.4);
pic01 = fill([xt,fliplr(xt)],[avg_sac_d-sem_sac_d,fliplr(avg_sac_d+sem_sac_d)],'r'); hold on;
set(pic01,'edgealpha', 0, 'facealpha', 0.4);
title('眼跳事件发生的概率'); xlabel('Time (s)'); ylabel('Probability (%)');
legend('saccade - SAME', 'saccade - DIFF');




