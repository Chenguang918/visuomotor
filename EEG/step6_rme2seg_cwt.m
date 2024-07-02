clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\7.rme\';
path_out_eeg = 'E:\Data\202305\EEG\8.seg_cwt\';

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
TW_RANGE = [-0.2 1.4];
TW_BASE = [-0.2 0];
BAND_ALPHA = [8 12];
BAND_ALL = [1 30];

load('..\INF\MK_EEG.mat');

%% Main
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end
 
    EEG_BLK = get_eeg_env(NBLK, BAND_ALPHA, BAND_ALL, EEG_BLK);
    EEG_EPOCH = get_eeg_epoch(NTAG, NBLK, FS_EEG, MK_EEG, NSTSK, NATSK, TW_RANGE, TW_BASE, EEG_BLK);
    
    %% Save data
    save([path_out_eeg 'EEG_EPOCH_' num2str(isub) '.mat'],'EEG_EPOCH','-mat');
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

function EEG_BLK = get_eeg_env(NBLK, BAND_ALPHA, BAND_ALL, EEG_BLK)
    for iblk = 1:NBLK
        EEG = EEG_BLK(iblk);
        for ich = 1:EEG.nbchan
            x = double(squeeze(EEG.data(ich,:)));
            [wt,f] = cwt(x,EEG.srate);
            idx_alpha = (f>BAND_ALPHA(1)) & (f<BAND_ALPHA(2));
            idx_all = (f>BAND_ALL(1)) & (f<BAND_ALL(2));
            wt = abs(wt);
            pwr_alpha = sum(wt(idx_alpha,:),1);
            %pwr_all = sum(wt(idx_all,:),1);
            EEG.data(ich,:) = pwr_alpha;
        end
        EEG_BLK(iblk) = EEG;
        fprintf('\r\n %d   -- %d  ', length(x), length(f));
    end
end


function EEG_EPOCH = get_eeg_epoch(NTAG, NBLK, FS_EEG, MK_EEG, NSTSK, NATSK, TW_RANGE, TW_BASE, EEG_BLK)
    idx_range = round(FS_EEG * TW_RANGE(1)) : round(FS_EEG * TW_RANGE(2)-1);
    idx_base = round(FS_EEG * TW_BASE(1)) : round(FS_EEG * TW_BASE(2)-1);

    for ii = 1:NTAG
        marker = ['S' num2str(ii)];
        EEG_EPOCH.(marker) = [];
        marker = ['D' num2str(ii)];
        EEG_EPOCH.(marker) = [];
    end

    for iblk = 1:NBLK
        % Load EEG block
        EEG = EEG_BLK(iblk);
        % Get all target event
        ievt_target_all = [];
        for ievt = 1:length(EEG.event)
            if ismember(EEG.event(ievt).type, MK_EEG.Target1:MK_EEG.Target6)
                ievt_target_all = [ievt_target_all, ievt];
            end
        end
        % Task same
        for ii = 1:NSTSK
            ievt = ievt_target_all(ii);
            latency = round(EEG.event(ievt-1).latency);
            type = EEG.event(ievt).type;
            marker = ['S' num2str(type - 80)];
            tmp = EEG.data(:,latency+idx_range);
            %tmp = tmp - mean(EEG.data(:,latency+idx_base),2);
            EEG_EPOCH.(marker) = cat(3, EEG_EPOCH.(marker), tmp);
        end
        % Task diff
        for ii = (NSTSK+1):(NATSK-1)
            ievt = ievt_target_all(ii);
            latency = round(EEG.event(ievt-1).latency);
            type = EEG.event(ievt).type;
            marker = ['D' num2str(type - 80)];
            tmp = EEG.data(:,latency+idx_range);
            %tmp = tmp - mean(EEG.data(:,latency+idx_base),2);
            EEG_EPOCH.(marker) = cat(3, EEG_EPOCH.(marker), tmp);
        end
        ievt = ievt_target_all(NATSK);
        type = EEG.event(ievt).type;
        marker = ['D' num2str(type - 80)];
        tmp = zeros(size(EEG.data,1), length(idx_range));
        EEG_EPOCH.(marker) = cat(3, EEG_EPOCH.(marker), tmp);
    end
end








