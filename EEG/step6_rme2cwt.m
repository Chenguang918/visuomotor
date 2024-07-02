clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\7.rme\';
path_out_eeg = 'E:\Data\202305\EEG\8.cwt_seg\';

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
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end
 
    %[EEG_CWT, FX] = get_eeg_cwt(NBLK, EEG_BLK);
    [CWT_SEG, FX]= get_eeg_seg(NTAG, NBLK, FS_EEG, MK_EEG, NSTSK, NATSK, TW_RANGE, EEG_BLK);
    
    %% Save data
    save([path_out_eeg 'CWT_SEG_sub' num2str(isub) '.mat'],'CWT_SEG','FX', '-mat');
    fprintf('\r\n-----------------------------------------\r\n');
end


%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ)
    fprintf('[Sub %d] : ------------------------------', isub);
    file_in_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_BLK = [];
        EEG_BAD = [];
    else
        load([path_in_eeg file_in_eeg]);
        eval(['EEG_BLK = EEG_' upper(blk_typ) ';']);
    end
    fprintf('\r\n');
end


function [EEG_CWT, FX] = get_eeg_cwt(NBLK, EEG_BLK)
    for iblk = 1:NBLK
        fprintf('\t [blk %d]: ch ', iblk);
        EEG = EEG_BLK(iblk);
        for ich = 1:EEG.nbchan
            fprintf(' %d', ich);
            x = double(squeeze(EEG.data(ich,:)));
            [wt, FX] = cwt(x, EEG.srate, VoicesPerOctave=20, FrequencyLimits=[1 30]);
            EEG_CWT{iblk}(:,:,ich) = abs(wt);
        end
        fprintf('\r\n');
    end
end


function [CWT_SEG, FX] = get_eeg_seg(NTAG, NBLK, FS_EEG, MK_EEG, NSTSK, NATSK, TW_RANGE, EEG_BLK)
    idx_range = round(FS_EEG * TW_RANGE(1)) : round(FS_EEG * TW_RANGE(2)-1);

    for itag = 1:NTAG
        CWT.(['S' num2str(itag)]) = [];
        CWT.(['D' num2str(itag)]) = [];
    end

    for iblk = 1:NBLK
        fprintf('\t [blk %d]: ch ', iblk);
        EEG = EEG_BLK(iblk);
        EEG_CWT = [];
        for ich = 1:EEG.nbchan
            fprintf(' %d', ich);
            x = double(squeeze(EEG.data(ich,:)));
            [wt, FX] = cwt(x, EEG.srate, VoicesPerOctave=20, FrequencyLimits=[1 30]);
            EEG_CWT(:,:,ich) = abs(wt);
        end
        fprintf('\r\n');

        fprintf('\t [blk %d]: tsk -', iblk);
        % Get all target event
        ievt_target_all = [];
        for ievt = 1:length(EEG.event)
            if ismember(EEG.event(ievt).type, MK_EEG.Target1:MK_EEG.Target6)
                ievt_target_all = [ievt_target_all, ievt];
            end
        end
        % Task same
        for ii = 1:NSTSK
            fprintf(' %d', ii);
            ievt = ievt_target_all(ii);
            latency = round(EEG.event(ievt-1).latency);
            type = EEG.event(ievt).type;
            marker = ['S' num2str(type - 80)];
            tmp = EEG_CWT(:,latency+idx_range,:);
            CWT.(marker) = cat(4, CWT.(marker), tmp);
        end
        % Task diff
        for ii = (NSTSK+1):(NATSK-1)
            fprintf(' %d', ii);
            ievt = ievt_target_all(ii);
            latency = round(EEG.event(ievt-1).latency);
            type = EEG.event(ievt).type;
            marker = ['D' num2str(type - 80)];
            tmp = EEG_CWT(:,latency+idx_range,:);
            CWT.(marker) = cat(4, CWT.(marker), tmp);
        end
        ievt = ievt_target_all(NATSK);
        type = EEG.event(ievt).type;
        marker = ['D' num2str(type - 80)];
        tmp = zeros(size(tmp,1), size(tmp,2), size(tmp,3));
        CWT.(marker) = cat(4, CWT.(marker), tmp);
        fprintf('\r\n');
    end
    fprintf('\r\n');

    for itag = 1:NTAG
        CWT_SEG.SAME(:,:,:,itag) = squeeze(mean(CWT.(['S' num2str(itag)]),4));
        CWT_SEG.DIFF(:,:,:,itag) = squeeze(mean(CWT.(['D' num2str(itag)]),4));
    end
end








