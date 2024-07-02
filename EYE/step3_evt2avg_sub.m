clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\4.evt\';
path_out_eye = 'E:\Data\202305\EYE\5.avg\';
load('..\INF\MK_EEG.mat');

%% Parameter
FS_EYE = 1000;
NSUB = 50;
NBLK = 6;
NTAG = 6;
N_TSK_SAM = 43;
N_TSK_ALL = 172;
TPT_TW = [0.2 0.30]*FS_EYE; % sample

%% Main
tot_sub = 0;
fix_duration = [];
fix_avgpupilsize = [];
sac_duration = [];
sac_amplitude = [];
sac_vmax = [];


for isub = 1:NSUB
    %% Check existence of file and load data
    EYE = check_and_get_data(isub, path_in_eye);
    if isempty(EYE)
        continue;
    end

    %% Get sub avg
    tot_sub = tot_sub + 1;
    [fix_avg_same, sac_avg_same] = get_sub(EYE(1:N_TSK_SAM));
    [fix_avg_diff, sac_avg_diff] = get_sub(EYE(N_TSK_SAM+1:N_TSK_ALL));
    fix_duration(tot_sub,1) = fix_avg_same.end - fix_avg_same.start;
    fix_duration(tot_sub,2) = fix_avg_diff.end - fix_avg_diff.start;
    fix_avgpupilsize(tot_sub,1) = fix_avg_same.avgpupilsize;
    fix_avgpupilsize(tot_sub,2) = fix_avg_diff.avgpupilsize;
    sac_duration(tot_sub,1) = sac_avg_same.end - sac_avg_same.start;
    sac_duration(tot_sub,2) = sac_avg_diff.end - sac_avg_diff.start;
    sac_amplitude(tot_sub,1) = sac_avg_same.amplitude;
    sac_amplitude(tot_sub,2) = sac_avg_diff.amplitude;
    sac_vmax(tot_sub,1) = sac_avg_same.vmax;
    sac_vmax(tot_sub,2) = sac_avg_diff.vmax;

    sac_cnt(tot_sub,1) = sac_avg_same.cnt;
    sac_cnt(tot_sub,2) = sac_avg_diff.cnt;
end

save([path_out_eye 'sac_sub.mat'], 'sac_duration', '-mat');

% [h,zp1] = ttest(fix_duration(:,1),fix_duration(:,2));
% [h,zp2] = ttest(fix_avgpupilsize(:,1),fix_avgpupilsize(:,2));
[h,zp3] = ttest(sac_duration(:,1),sac_duration(:,2));  % 只有这个显著
% [h,zp4] = ttest(sac_amplitude(:,1),sac_amplitude(:,2));
% [h,zp5] = ttest(sac_vmax(:,1),sac_vmax(:,2));


function [fix_avg, sac_avg] = get_sub(EYE)
    fix_sub.start = [];
    fix_sub.end = [];
    fix_sub.avgpupilsize = [];
    sac_sub.start = [];
    sac_sub.end = [];
    sac_sub.amplitude = [];
    sac_sub.vmax = [];
    for iblk = 1:size(EYE,2)
        for itrl = 1:size(EYE,1)
            [fix_trl, sac_trl] = get_fix_sac(EYE, itrl,iblk);
            if ~isempty(fix_trl)
                fix_sub.start = [fix_sub.start fix_trl.start];
                fix_sub.end = [fix_sub.end fix_trl.end];
                fix_sub.avgpupilsize = [fix_sub.avgpupilsize, fix_trl.avgpupilsize];
            end
            if ~isempty(sac_trl)
                sac_sub.start = [sac_sub.start sac_trl.start];
                sac_sub.end = [sac_sub.end sac_trl.end];
                sac_sub.amplitude = [sac_sub.amplitude, sac_trl.amplitude];
                sac_sub.vmax = [sac_sub.vmax, sac_trl.vmax];
            end
        end
    end

    fix_avg.start = mean(fix_sub.start);
    fix_avg.end = mean(fix_sub.end);
    fix_avg.avgpupilsize = mean(fix_sub.avgpupilsize);
    fix_avg.cnt = length(fix_sub.start)/(size(EYE,1)*size(EYE,2));

    if isempty(sac_sub.start)
        sac_avg.start = 0;
        sac_avg.end = 0;
        sac_avg.amplitude = 0;
        sac_avg.vmax = 0;
        sac_avg.cnt = 0;
    else
        sac_avg.start = mean(sac_sub.start);
        sac_avg.end = mean(sac_sub.end);
        sac_avg.amplitude = mean(sac_sub.amplitude);
        if isnan(sac_avg.amplitude)
            sac_avg.amplitude = 0;
        end
        sac_avg.vmax = mean(sac_sub.vmax);
        sac_avg.cnt = length(sac_sub.start)/(size(EYE,1)*size(EYE,2));
    end
end


function [fix, sac] = get_fix_sac(EYE, itrl,iblk)
    %% fixation
    evt = EYE(itrl,iblk).Fix;
    if ~isempty(evt)
        fix.start = mean(evt(:,1));
        fix.end = mean(evt(:,2));
        fix.avgpupilsize = mean(evt(:,6));
    else
        fix = [];
    end
    %% saccade
    evt = EYE(itrl,iblk).Sac;
    if ~isempty(evt)
        sac.start = mean(evt(:,1));
        sac.end = mean(evt(:,2));
        sac.amplitude = mean(evt(:,8));
        sac.vmax = mean(evt(:,9));
    else
        sac = [];
    end
end




%% Check existence of file and load data
function EYE = check_and_get_data(isub, path_in_eye)
    fprintf('[Sub %d] : ', isub);
    file_in_eye = ['sub' num2str(isub) '.mat' ];
    if ~exist([path_in_eye '\' file_in_eye],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EYE = [];
    else
        load([path_in_eye file_in_eye]);
    end
end




