clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\6.glm\';
path_out_nir = 'E:\Data\202305\NIR\6.glm\';

load([path_in_nir 'glm.mat']);

NCH = 44;

glm_SAME = glm_SAME';
glm_DIFF = glm_DIFF';

subplot(3,1,1);
errorbar((1:NCH)-0.2, mean(glm_SAME,1,'omitnan'), std(glm_SAME,'omitnan'), "ob"); hold on;
errorbar((1:NCH)+0.2, mean(glm_DIFF,1,'omitnan'), std(glm_DIFF,'omitnan'), "or"); hold on;
title('2种状态 glm的Beta');
legend('简单任务','复杂任务');
xlabel('Channel');
ylabel('beta value (glm)');

subplot(3,1,2);
[h,p,ci,stats] = ttest(glm_SAME);
tval_ss = stats.tstat;
tval_ss(p>0.05) = 0;
[h,p,ci,stats] = ttest(glm_DIFF);
tval_dd = stats.tstat;
tval_dd(p>0.05) = 0;
stem((1:NCH)-0.2, tval_ss, "b"); hold on;
stem((1:NCH)+0.2, tval_dd, "r"); hold on;
title('2种状态 glm的Beta');
legend('简单任务','复杂任务');
xlabel('Channel');
ylabel('beta value (glm)');

subplot(3,1,3);
[h,p,ci,stats] = ttest(glm_DIFF, glm_SAME);
tval_ssdd = stats.tstat;
tval_ssdd(p>0.05) = 0;
bar(tval_ssdd);
title('两种任务 glm的beta value比较');
xlabel('Channel');
ylabel('t value');

