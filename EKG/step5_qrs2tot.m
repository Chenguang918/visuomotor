clc;clear;close all;

%% File path and name
path_in_ekg = 'E:\Data\202305\EKG\4.qrs\';
path_out_ekg = 'E:\Data\202305\EKG\5.tot\';
addpath('HRVTool\');

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

varn_list = {'MEANRR', 'SDNN', 'RMSSD', 'PNN50'};
for ivar = 1:length(varn_list)
    tot_sub = 0;
    %% Main
    for isub = 1:NSUB
        %% Check existence of file and load data
        HRV_BLK = check_and_get_data(isub, path_in_ekg);
        if isempty(HRV_BLK)
            continue;
        end
    
        %% Every block
        vals = get_hrv_vals(NBLK, HRV_BLK, varn_list{ivar});
        if ~isempty(vals)
            tot_sub = tot_sub + 1;
            HRV.(varn_list{ivar})(tot_sub,:) = vals;
        else
            fprintf('err \r\n');
        end
    end
    fprintf("\r\n");
end

save([path_out_ekg 'HRV.mat'],'HRV','-mat');

%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function HRV_BLK = check_and_get_data(isub, path_in_ekg)
    fprintf('[Sub %d] : ', isub);
    file_in_ekg = ['sub' num2str(isub) '.mat' ];
    if ~exist([path_in_ekg '\' file_in_ekg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        HRV_BLK = [];
        return;
    else
        load([path_in_ekg file_in_ekg]);
    end
end


function vals = get_hrv_vals(NBLK, HRV_BLK, varn)
    vals_rest = [];
    vals_same = [];
    vals_diff = [];
    for iblk = 1:NBLK
        if (length(HRV_BLK(iblk).REST.RR)>100) && (length(HRV_BLK(iblk).REST.RR)<1000)
            vals_rest = [vals_rest HRV_BLK(iblk).REST.(varn)];
        end
        if (length(HRV_BLK(iblk).SAME.RR)>100) && (length(HRV_BLK(iblk).SAME.RR)<1000)
            vals_same = [vals_same HRV_BLK(iblk).SAME.(varn)];
        end
        if (length(HRV_BLK(iblk).DIFF.RR)>100) && (length(HRV_BLK(iblk).DIFF.RR)<1000)
            vals_diff = [vals_diff HRV_BLK(iblk).DIFF.(varn)];
        end
    end
    if (length(vals_rest)>=1) && (length(vals_same)>=1) && (length(vals_diff)>=1) 
        vals(1,1) = mean(vals_rest);
        vals(1,2) = mean(vals_same);
        vals(1,3) = mean(vals_diff);
    else
        vals = [];
    end
end
