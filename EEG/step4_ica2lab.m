clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\5.ica\';
path_out_eeg = 'E:\Data\202305\EEG\6.lab\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

%% Main
blk_typ = 'tsk';

IC_ALL = [];
for isub = 1:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end

    for iblk = 1:NBLK
        if (isub == 47) && (iblk == 2)
            continue;
        elseif (isub == 50) && (iblk == 1)
            continue;
        end
        % Load EEG block
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);
        % ICLabel components
        EEG = pop_iclabel(EEG, 'default');
        EEG = eeg_checkset(EEG);
        IC_ALL = cat(3, IC_ALL, EEG.etc.ic_classification.ICLabel.classifications(:,:));
        % Save EEG block
        EEG_BLK(iblk) = EEG;
    end

    %% Save data
    file_out_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['EEG_' upper(blk_typ) ' = EEG_BLK;']);
    save([path_out_eeg file_out_eeg], ['EEG_' upper(blk_typ)], 'EEG_BAD', '-mat');
end

%% Done
load gong.mat;
sound(y);
save([path_out_eeg 'IC_ALL_' blk_typ '.mat'], 'IC_ALL', '-mat');



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


