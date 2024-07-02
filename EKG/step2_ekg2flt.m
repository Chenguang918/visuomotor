clc;clear;close all;

%% File path and name
path_in_ekg = 'E:\Data\202305\EKG\1.ekg\';
path_out_ekg = 'E:\Data\202305\EKG\2.flt\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;


%% Main
blk_typ = 'tsk';
for isub = 1:NSUB
    %% Check existence of file and load data
    EKG_BLK = check_and_get_data(isub, path_in_ekg, blk_typ);
    if isempty(EKG_BLK)
        continue;
    end

    %% Every block
    for iblk = 1:NBLK
        EKG = EKG_BLK(iblk);

        % High-pass and Low-pass filter
        mEEG = eeg_emptyset();
        mEEG.data = double(EKG.data);
        mEEG.srate = double(FS_EEG);
        mEEG = eeg_checkset(mEEG);
        mEEG = pop_eegfiltnew(mEEG, 'locutoff',0.01,'hicutoff',40);
        mEEG = eeg_checkset(mEEG);

        EKG_BLK(iblk).data = mEEG.data;
    end

    %% Save data
    file_out_ekg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['EKG_' upper(blk_typ) ' = EKG_BLK;']);
    save([path_out_ekg file_out_ekg], ['EKG_' upper(blk_typ)], '-mat');
end

%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function EKG_BLK = check_and_get_data(isub, path_in_ekg, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_ekg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_ekg '\' file_in_ekg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EKG_BLK = [];
        return;
    else
        load([path_in_ekg file_in_ekg]);
        eval(['EKG_BLK = EKG_' upper(blk_typ) ';']);
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




