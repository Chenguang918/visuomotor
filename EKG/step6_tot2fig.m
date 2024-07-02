clc;clear;close all;

%% File path and name
path_in_ekg = 'E:\Data\202305\EKG\5.tot\';
path_out_ekg = 'E:\Data\202305\EKG\5.tot\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

load([path_in_ekg 'HRV.mat']);


figure;
subplot(2,2,1); plot_avg_std(HRV.MEANRR*1000, 'RR');
subplot(2,2,2); plot_avg_std(HRV.SDNN*1000, 'SDNN');
subplot(2,2,3); plot_avg_std(HRV.RMSSD*1000, 'RMSSD');
subplot(2,2,4); plot_avg_std(HRV.PNN50*100, 'PNN50');



function plot_avg_std(dat, name)
    avg_dat = mean(dat,1);
    std_dat = std(dat)/sqrt(size(dat,1));
    b = bar(avg_dat', "LineStyle","none");
    b.FaceColor = 'flat';
    b.CData(1,:) = [0.5 0.5 0.5];
    b.CData(2,:) = [0 0 0.5];
    b.CData(3,:) = [0.5 0 0];
    hold on;
    errorbar(1, avg_dat(1), std_dat(1), "LineStyle","none","CapSize", 20, "LineWidth",3,"Color",[0 0 0]); hold on;
    errorbar(2, avg_dat(2), std_dat(2), "LineStyle","none","CapSize", 20, "LineWidth",3,"Color",[0 0 1]); hold on;
    errorbar(3, avg_dat(3), std_dat(3), "LineStyle","none","CapSize", 20, "LineWidth",3,"Color",[1 0 0]); hold on;
    xticklabels({'Rest','Same','Diff'});
    title(name);
    [h,zp1,ci,stats1] = ttest(dat(:,2), dat(:,1));
    [h,zp2,ci,stats2] = ttest(dat(:,3), dat(:,1));
    [h,zp3,ci,stats3] = ttest(dat(:,3), dat(:,2));
    fprintf("\t %s", name);
    fprintf("\t p = [ %.5f  %.5f  %.5f ] ", zp1, zp2, zp3);
    fprintf("\t t = [ %.3f  %.3f  %.3f ] ", stats1.tstat, stats2.tstat, stats3.tstat);
    fprintf("\t df = [ %d  %d  %d ] ", stats1.df, stats2.df, stats3.df);
    fprintf("\t avg = [ %.3f  %.3f  %.3f ]", avg_dat);
    fprintf("\t sem = [ %.3f  %.3f  %.3f ]\r\n", std_dat);
end

