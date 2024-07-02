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
TPT_TW = [0 0.5]*FS_EYE; % sample

%% Main
tot_sub = 0;
for isub = 1:NSUB
    %% Check existence of file and load data
    EYE = check_and_get_data(isub, path_in_eye);
    if isempty(EYE)
        continue;
    end

    %% Get all data
    tot_sub = tot_sub + 1;
    tst_all(:,:,tot_sub) = EYE;
end

EYE_EVT_SAME = tst_all(1:N_TSK_SAM,:,:);
EYE_EVT_DIFF = tst_all(N_TSK_SAM+1:N_TSK_ALL,:,:);

for isub = 1:size(tst_all,3)
    SAC_SAME(:,isub) = 100*get_tpt_tot(TPT_TW, EYE_EVT_SAME(:,:,isub));
    SAC_DIFF(:,isub) = 100*get_tpt_tot(TPT_TW, EYE_EVT_DIFF(:,:,isub));
end

file_out_eye = 'tst_all.mat';
save([path_out_eye file_out_eye], 'SAC_SAME','SAC_DIFF', '-mat');


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

function tpt_sac = get_tpt_tot(TPT_TW, EYE)
    tpt_sac = zeros(TPT_TW(2)-TPT_TW(1)+1,1);
    for itrl = 1:size(EYE,1)
        for iblk = 1:size(EYE,2)
            eye_evt = EYE(itrl, iblk);
            tpt_sac = tpt_sac + ffill_tpt(TPT_TW, eye_evt.Sac);
        end
    end
    tpt_sac = tpt_sac./(size(EYE,1)*size(EYE,2));
end

function tpt = ffill_tpt(TPT_TW, evt)
    tpt = zeros(TPT_TW(2)-TPT_TW(1)+1,1);
    if ~isempty(evt)
        for ii = 1:size(evt,1)
            tpt(evt(ii,1):evt(ii,2)) = tpt(evt(ii,1):evt(ii,2)) + 1;
        end
    end
end


