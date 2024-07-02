clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\2.blk\';
path_out_eeg = 'E:\Data\202305\EKG\1.ekg\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;


%% Main
blk_typ = 'tsk';
for isub = 1:NSUB
    %% Check existence of file and load data
    EEG_BLK = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end

    %% Every block
    for iblk = 1:NBLK
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);
        if EEG.srate ~= FS_EEG
            fprintf('Sample Rate ERROR!!!!!!!!!!!!!!!!!');
        end

        ch_name = {'EKG'};
        ch_idx = get_eeg_ch_idx(EEG, ch_name);

        EKG_BLK(iblk).data = EEG.data(ch_idx,:);
        EKG_BLK(iblk).event = EEG.event;
    end

    %% Save data
    file_out_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['EKG_' upper(blk_typ) ' = EKG_BLK;']);
    save([path_out_eeg file_out_eeg], ['EKG_' upper(blk_typ)], '-mat');
end

%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function EEG_BLK = check_and_get_data(isub, path_in_eeg, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_BLK = [];
        return;
    else
        load([path_in_eeg file_in_eeg]);
        eval(['EEG_BLK = EEG_' upper(blk_typ) ';']);
    end
end


function ch_idx = get_eeg_ch_idx(EEG, ch_name)
    ch_idx = [];
    for ii = 1:length(ch_name)
        for ich = 1:length(EEG.chanlocs)
            if (strcmp(ch_name(ii), EEG.chanlocs(ich).labels))
                ch_idx = [ch_idx, ich];
            end
        end
    end
end




