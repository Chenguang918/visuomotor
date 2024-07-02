clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\3.fix\';
path_out_eye = 'E:\Data\202305\EYE\4.dat\';
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
blk_typ = 'tsk';
tot_sub = 1;

for isub = 1:NSUB
    %% Check existence of file and load data
    EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ);
    if isempty(EYE_BLK)
        continue;
    elseif isub == 25
        continue;
    end

    %% Get eye data
    for iblk = 1:NBLK
        [eye_dat, idx_tag] = get_eye_data(TPT_TW, MK_EEG, EYE_BLK(iblk), N_TSK_ALL);
        EYE_DAT(:,:,:,iblk,tot_sub) = eye_dat;
        EYE_TAG(:,iblk,tot_sub) = idx_tag';
    end
    tot_sub = tot_sub + 1;

    %% Save data
end
save([path_out_eye 'EYE_DAT.mat'], 'EYE_DAT','EYE_TAG', '-mat');



%% Check existence of file and load data
function EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eye = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eye '\' file_in_eye],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EYE_BLK = [];
    else
        load([path_in_eye file_in_eye]);
        eval(['EYE_BLK = EYE_' upper(blk_typ) ';']);
    end
end


function [eye_dat, idx_tag] = get_eye_data(TPT_TW, MK_EEG, EYE, N_TSK_ALL)
    for ievt = 1:N_TSK_ALL
        tim_evt(ievt,1) = EYE.event(ievt*3-2,1); %Show Target
        idx_tag(ievt,1) = EYE.event(ievt*3-1,2) - MK_EEG.Target1 + 1;
    end

    for ii = 1:length(tim_evt)
        tw = TPT_TW + tim_evt(ii);
        idxs = (EYE.data(:,1)>=tw(1) & EYE.data(:,1)<=tw(2));
        dat_sel = EYE.data(idxs,2:4);
        eye_dat(:,:,ii) = dat_sel;
    end
end



