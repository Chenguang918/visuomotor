clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\6.alf\';
path_out_nir = 'E:\Data\202305\NIR\6.alf\';

load([path_in_nir 'fALFF.mat']);

NCH = 44;

subplot(2,2,[1,2]);
errorbar((1:NCH)+0.0, mean(fALFF_REST,1), std(fALFF_REST), "ok"); hold on;
errorbar((1:NCH)+0.2, mean(fALFF_SAME,1), std(fALFF_SAME), "ob"); hold on;
errorbar((1:NCH)+0.4, mean(fALFF_DIFF,1), std(fALFF_DIFF), "or"); hold on;
title('三种状态 fALFF的Zscore');
legend('休息','简单任务','复杂任务');
xlabel('Channel');
ylabel('Z score (fALFF)');

subplot(2,2,3);
[h,p,ci,stats] = ttest(fALFF_SAME, fALFF_REST);
p_fdr = mafdr(p);
tval_ss = tinv(1- p_fdr/2, 46-1).*sign(stats.tstat);
tval_ss(p_fdr>0.05) = 0;

[h,p,ci,stats] = ttest(fALFF_DIFF, fALFF_REST);
p_fdr = mafdr(p);
tval_dd = tinv(1- p_fdr/2, 46-1).*sign(stats.tstat);
tval_dd(p_fdr>0.05) = 0;
bar(1:NCH,[tval_ss;tval_dd]); hold on;
title('两种任务 与 休息(Baseline)的比较');
legend('简单任务 v.s. 休息(Baseline)','复杂任务 v.s. 休息(Baseline)');
xlabel('Channel');
ylabel('t value');

subplot(2,2,4);
[h,p,ci,stats] = ttest(fALFF_DIFF, fALFF_SAME);
tval_ssdd = stats.tstat;
tval_ssdd(p>0.05) = 0;
p_fdr = mafdr(p);
tval_ssdd_mdr = tinv(1- p_fdr/2, 46-1).*sign(stats.tstat);
tval_ssdd_mdr(p_fdr>0.05) = 0;

bar(tval_ssdd_mdr);
title('两种任务 fALFF的Zscore比较');
xlabel('Channel');
ylabel('t value');

