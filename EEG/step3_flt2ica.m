clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\4.flt\';
path_out_eeg = 'E:\Data\202305\EEG\5.ica\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;
%CH_IND = [1:17 19:23 25:32];

%% Main
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end

    for iblk = 1:NBLK
        % Load EEG block
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);

        % get channel index
        ch_idx_no = get_eeg_ch_idx(EEG, {'M1', 'M2', 'EKG'});
        CH_IND = setdiff(1:EEG.nbchan, ch_idx_no);

        % Run ICA
        EEG = pop_chanedit(EEG, 'eval','','load',[],'lookup','D:\MATLAB\Toolbox\eeglab2023.1\plugins\dipfit\standard_BEM\elec\standard_1005.elc');
        EEG = eeg_checkset(EEG);
        EEG = pop_runica(EEG, 'icatype', 'runica', 'reorder', 'on', 'chanind', CH_IND, 'extended',1,'interrupt','on');
        EEG = eeg_checkset(EEG);

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


