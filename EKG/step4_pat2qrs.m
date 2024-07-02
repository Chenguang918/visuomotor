clc;clear;close all;

%% File path and name
path_in_ekg = 'E:\Data\202305\EKG\3.pat\';
path_out_ekg = 'E:\Data\202305\EKG\4.qrs\';
addpath('HRVTool\');

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

HRV_PARA.Fs = FS_EEG;
HRV_PARA.d_fs = 200;
HRV_PARA.Beat_min = 50;
HRV_PARA.Beat_max = 220;
HRV_PARA.wl_tma = 100;
HRV_PARA.wl_we = [167 167];

%% Main
for isub = 1:NSUB
    %% Check existence of file and load data
    EKG_BLK = check_and_get_data(isub, path_in_ekg);
    if isempty(EKG_BLK)
        continue;
    end

    %% Every block
    for iblk = 1:NBLK
        HRV_BLK(iblk).REST = get_hrv(EKG_BLK(iblk).REST, HRV_PARA);
        HRV_BLK(iblk).SAME = get_hrv(EKG_BLK(iblk).SAME, HRV_PARA);
        HRV_BLK(iblk).DIFF = get_hrv(EKG_BLK(iblk).DIFF, HRV_PARA);
    end

    %% Save data
    file_out_ekg = ['sub' num2str(isub) '.mat'];
    save([path_out_ekg file_out_ekg], 'HRV_BLK', '-mat');
    fprintf('\r\n');
end

%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function EKG_BLK = check_and_get_data(isub, path_in_ekg)
    fprintf('[Sub %d] : ', isub);
    file_in_ekg = ['sub' num2str(isub) '.mat' ];
    if ~exist([path_in_ekg '\' file_in_ekg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EKG_BLK = [];
        return;
    else
        load([path_in_ekg file_in_ekg]);
    end
end


function HRV_BLK = get_hrv(data_raw, HRV_PARA)
    data_raw = data_raw(:);
    Ann = singleqrs(data_raw,HRV_PARA.Fs,'Beat_min',HRV_PARA.Beat_min,'Beat_max',HRV_PARA.Beat_max);
    %Ann = singleqrs(data_raw,HRV_PARA.Fs,'downsampling',HRV_PARA.d_fs,'Beat_min',HRV_PARA.Beat_min,'Beat_max',HRV_PARA.Beat_max,'wl_tma',HRV_PARA.wl_tma,'wl_we',HRV_PARA.wl_we);
    Ann = Ann/HRV_PARA.Fs;
    RR = diff(Ann);
    RR = HRV.RRfilter(RR);
    HRV_BLK.RR = RR;
    HRV_BLK.MEANRR = HRV.nanmean(RR);
    HRV_BLK.SDNN = HRV.SDNN(RR,0);
    HRV_BLK.RMSSD = HRV.RMSSD(RR,0);
    HRV_BLK.PNN50 = HRV.pNN50(RR,0);  
end
