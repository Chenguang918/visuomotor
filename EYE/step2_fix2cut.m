clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\3.fix\';
path_out_eye = 'E:\Data\202305\EYE\4.cut\';
load('..\INF\MK_EEG.mat');

%% Parameter
FS_EYE = 1000;
NSUB = 50;
NBLK = 6;
NTAG = 6;
N_TSK_SAM = 43;
N_TSK_ALL = 172;
T1 = 1; %s
T2 = 6; %s

%% Main
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ);
    if isempty(EYE_BLK)
        continue;
    end

    %% Get eye data
    data_same = {[],[],[],[],[],[]};
    data_diff = {[],[],[],[],[],[]};
    for iblk = 1:NBLK
        EYE = EYE_BLK(iblk);

        for ievt = 1:N_TSK_SAM
            idx_tag = EYE.event(ievt*3-1,2) - MK_EEG.Target1 + 1;
            idx_dat = find(EYE.data(:,1) == EYE.event(ievt*3-2,1));
            tmp = EYE.data((idx_dat-FS_EYE*T1):(idx_dat+FS_EYE*T2),2:4);
            data_same{idx_tag} = cat( 3, data_same{idx_tag}, tmp);
        end

        for ievt = N_TSK_SAM+1:N_TSK_ALL
            idx_tag = EYE.event(ievt*3-1,2) - MK_EEG.Target1 + 1;
            idx_dat = find(EYE.data(:,1) == EYE.event(ievt*3-2,1));
            tmp = EYE.data((idx_dat-FS_EYE*T1):(idx_dat+FS_EYE*T2),2:4);
            data_diff{idx_tag} = cat( 3, data_diff{idx_tag}, tmp);
        end
    end
    
    EYE_CUT_SAME = [];
    EYE_CUT_DIFF = [];
    for itag = 1:NTAG
        EYE_CUT_SAME(:,:,:,itag) = data_same{itag};
        EYE_CUT_DIFF(:,:,:,itag) = data_diff{itag};
    end

    %% Save data
    file_out_eye = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    save([path_out_eye file_out_eye], 'EYE_CUT_SAME', 'EYE_CUT_DIFF', '-mat');
end



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


% function [data, itag] = get_eye_dat_tag_same(FS_EYE, NSTSK, T1, T2, EYE, MK_EEG)
%     itag = EYE.event(2,2) - MK_EEG.Target1 + 1;
%     idx_tag = (1:NSTSK)*3-1;
%     tpt_tag = EYE.event(idx_tag-1, 1);
%     for ii = 1:length(tpt_tag)
%         idx_dat = find(EYE.data(:,1) == tpt_tag(ii));
%         data(:,:,ii) = EYE.data(idx_dat-T1*FS_EYE:idx_dat+T2*FS_EYE-1,2:4);
%     end
% end
% 
% 
% function data = get_eye_dat_tag_diff(FS_EYE, NSTSK, T1, T2, EYE, MK_EEG, itsk)
%     idx_tag = find( EYE.event((NSTSK)*3:end,2) == MK_EEG.(['Target' num2str(itsk)]) ) + (NSTSK)*3 - 1;
%     tpt_tag = EYE.event(idx_tag-1, 1);
%     for ii = 1:length(tpt_tag)
%         idx_dat = find(EYE.data(:,1) == tpt_tag(ii));
%         data(:,:,ii) = EYE.data(idx_dat-T1*FS_EYE:idx_dat+T2*FS_EYE-1,2:4);
%     end
% end



