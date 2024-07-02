clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\6.alf\';
path_out_nir = 'E:\Data\202305\NIR\6.alf\';

load([path_in_nir 'sALFF.mat']);

NCH = 44;

subplot(2,2,[1,2]);
errorbar((1:NCH)+0.0, mean(sALFF_REST,1), std(sALFF_REST), "ok"); hold on;
errorbar((1:NCH)+0.2, mean(sALFF_SAME,1), std(sALFF_REST), "ob"); hold on;
errorbar((1:NCH)+0.4, mean(sALFF_DIFF,1), std(sALFF_REST), "or"); hold on;
title('三种状态 sALFF的Zscore');
legend('休息','简单任务','复杂任务');
xlabel('Channel');
ylabel('Z score (sALFF)');

subplot(2,2,3);
[h,p,ci,stats] = ttest(sALFF_REST, sALFF_SAME);
tval_ss = stats.tstat;
tval_ss(p>0.05) = 0;
[h,p,ci,stats] = ttest(sALFF_REST, sALFF_DIFF);
tval_dd = stats.tstat;
tval_dd(p>0.05) = 0;
bar(1:NCH,[tval_ss;tval_dd]); hold on;
title('两种任务 与 休息(Baseline)的比较');
legend('简单任务 v.s. 休息(Baseline)','复杂任务 v.s. 休息(Baseline)');
xlabel('Channel');
ylabel('t value');

subplot(2,2,4);
[h,p,ci,stats] = ttest(sALFF_DIFF, sALFF_SAME);
tval = stats.tstat;
tval(p>0.05) = 0;
bar(tval);
title('两种任务 sALFF的Zscore比较');
xlabel('Channel');
ylabel('t value');

