clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\3.int\';
path_out_eeg = 'E:\Data\202305\EEG\4.flt\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

%% Main
blk_typ = 'tsk';

for isub = 9:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end

    for iblk = 1:NBLK
        % Load EEG block
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);

        % High-pass and Low-pass filter
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.1,'hicutoff',30);
        EEG = eeg_checkset(EEG);
%         EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1);
%         EEG = eeg_checkset(EEG);

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


