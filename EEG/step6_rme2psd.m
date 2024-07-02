ffclc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\7.rme\';
path_out_eeg = 'E:\Data\202305\EEG\8.psd\';

%% Parameter
NSUB = 50;
NTAG = 6;
NBLK = 6;
FS_EEG = 500;
NCH = 33;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task
IDX_TSK_SAME = (1:NSTSK)*3;
IDX_TSK_DIFF = (NSTSK+1:NATSK-1)*3;
TW_RANGE = [-0.2 1.2];
TW_BASE = [-0.2 0];
BAND_ALPHA = [8 12];
BAND_ALL = [1 30];

load('..\INF\MK_EEG.mat');

%% Main
for isub = 1:NSUB
    blk_typ = 'tsk';
    % Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end
    [EEG_PSD_SAME, EEG_PSD_DIFF] = get_eeg_PSD_tsk(FS_EEG, NBLK, MK_EEG, NSTSK, NATSK, EEG_BLK);

    blk_typ = 'rst';
    % Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end
    EEG_PSD_REST = get_eeg_PSD_rst(FS_EEG, NBLK, EEG_BLK);
    
    % Save data
    save([path_out_eeg 'EEG_PSD_sub' num2str(isub) '.mat'],'EEG_PSD_SAME','EEG_PSD_DIFF','EEG_PSD_REST','-mat');
end


%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_BLK = [];
        EEG_BAD = [];
    else
        load([path_in_eeg file_in_eeg]);
        eval(['EEG_BLK = EEG_' upper(blk_typ) ';']);
    end
end

function [EEG_PSD_SAME, EEG_PSD_DIFF] = get_eeg_PSD_tsk(FS_EEG, NBLK, MK_EEG, NSTSK, NATSK, EEG_BLK)
    for iblk = 1:NBLK
        EEG = EEG_BLK(iblk);
        [latency_same, latency_diff] = get_event_latency(MK_EEG, NSTSK, NATSK, EEG);
        for ich = 1:EEG.nbchan
            x = double(squeeze(EEG.data(ich,:)));
            dat_same = x(latency_same(1):latency_same(2));
            dat_diff = x(latency_diff(1):latency_diff(2));
            w1 = round(length(dat_same)/100);
            o1 = round(length(dat_same)/100*0.5);
            w2 = round(length(dat_diff)/100);
            o2 = round(length(dat_diff)/100*0.5);
            [pxx_same,f] = pwelch(dat_same, w1, o1, 10*FS_EEG, FS_EEG);
            [pxx_diff,f] = pwelch(dat_diff, w2, o2, 10*FS_EEG, FS_EEG);
            EEG_PSD_SAME(:,ich,iblk) = pxx_same;
            EEG_PSD_DIFF(:,ich,iblk) = pxx_diff;
        end
    end
end


function EEG_PSD_REST = get_eeg_PSD_rst(FS_EEG, NBLK, EEG_BLK)
    for iblk = 1:NBLK
        EEG = EEG_BLK(iblk);
        for ich = 1:EEG.nbchan
            dat_rest = double(squeeze(EEG.data(ich,:)));
            w1 = round(length(dat_rest)/100);
            o1 = round(length(dat_rest)/100*0.5);
            [pxx_rest,f] = pwelch(dat_rest, w1, o1, 10*FS_EEG, FS_EEG);
            EEG_PSD_REST(:,ich,iblk) = pxx_rest;
        end
    end
end


function [latency_same, latency_diff] = get_event_latency(MK_EEG, NSTSK, NATSK, EEG)
    % Get all target event
    ievt_target_all = [];
    for ievt = 1:length(EEG.event)
        if ismember(EEG.event(ievt).type, MK_EEG.Target1:MK_EEG.Target6)
            ievt_target_all = [ievt_target_all, ievt];
        end
    end
    latency_same(1) = round(EEG.event(ievt_target_all(1)-1).latency);
    latency_same(2) = round(EEG.event(ievt_target_all(NSTSK)+1).latency);
    latency_diff(1) = round(EEG.event(ievt_target_all(NSTSK+1)-1).latency);
    latency_diff(2) = round(EEG.event(ievt_target_all(NATSK)+1).latency);
end





