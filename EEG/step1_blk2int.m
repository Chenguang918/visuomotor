clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\2.blk\';
path_out_eeg = 'E:\Data\202305\EEG\3.int\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;
load('EEG_CHANLOCS.mat');
CH_NO_INT = [18,24,33];

TH_STD.L = 10;
TH_STD.H = 10000;

%% Main
blk_typ = 'tsk';
sta_all_blk_avg = zeros(NCH, NBLK, NSUB);
sta_all_blk_std = zeros(NCH, NBLK, NSUB);
fileID = fopen([path_out_eeg 'log_' blk_typ '.txt'],'w');

for isub = 1:NSUB
    %% Check existence of file and load data
    EEG_BLK = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end

    %% Check every block
    EEG_BAD = [];
    %EEG_BLK_new = struct(EEG_BLK);
    for iblk = 1:NBLK
        % Load EEG block
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);

        % Remove M1 and M2
        %EEG = pop_select( EEG, 'rmchannel',{'M1','M2'});

        % Check and fix channel number
        [EEG, bad_ch] = check_fix_channel_num(EEG, EEG_CHANLOCS, TH_STD);
        EEG_BAD = [EEG_BAD, bad_ch];
        
        % Interpolate
        bad_ch(CH_NO_INT) = 0;
        bad_ch = find(bad_ch == 1);
        if ~isempty(bad_ch)
            EEG = pop_interp(EEG, bad_ch, 'spherical');
            fprintf(fileID, 'Sub[%d] - blk%d - %d bad: %s \r\n', isub, iblk, length(bad_ch), num2str(bad_ch'));
            %fprintf('Sub[%d] : %s \r\n', isub, num2str(bad_ch));
        end

        % Save EEG block
        EEG_BLK_new(iblk) = EEG;
    end
    EEG_BLK = EEG_BLK_new;
    clear EEG_BLK_new;
    fprintf('\r\n');

    %% Save data
    file_out_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['EEG_' upper(blk_typ) ' = EEG_BLK;']);
    save([path_out_eeg file_out_eeg], ['EEG_' upper(blk_typ)], 'EEG_BAD', '-mat');
end

%% Done
load gong.mat;
sound(y);
fclose(fileID);

%% Check existence of file and load data
function EEG_BLK = check_and_get_data(isub, path_in_eeg, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_BLK = [];
    else
        load([path_in_eeg file_in_eeg]);
        eval(['EEG_BLK = EEG_' upper(blk_typ) ';']);
    end
end


% Load EEG block
function EEG = load_block(EEG_BLK, iblk)
    EEG = EEG_BLK(iblk);
    EEG = eeg_checkset(EEG);
    EEG = pop_chanedit(EEG, 'eval','','load',[],'lookup','D:\MATLAB\Toolbox\eeglab2023.1\plugins\dipfit\standard_BEM\elec\standard_1005.elc');
    EEG = eeg_checkset(EEG);
end


% Check channel number
function [EEG, bad_ch] = check_fix_channel_num(EEG, EEG_CHANLOCS, TH_STD)
    tmp_data = [];
    bad_ch = zeros(length(EEG_CHANLOCS),1);
    for ich = 1:length(EEG_CHANLOCS)
        idx = get_eeg_label_num(EEG, EEG_CHANLOCS(ich).labels);
        if (idx > 0)
            tmp_data(ich,:) = EEG.data(idx,:);
        else % miss channel
            tmp_data(ich,:) = zeros(1, EEG.pnts);
            fprintf('\t%d', ich);
        end
    end
    EEG.data = tmp_data;
    EEG.nbchan = length(EEG_CHANLOCS);
    EEG.chanlocs = EEG_CHANLOCS;
    tmp_std = std(tmp_data')';
    bad_ch(tmp_std<TH_STD.L | tmp_std>TH_STD.H) = 1;
end



function idx = get_eeg_label_num(EEG, label)
    for ii = 1:EEG.nbchan
        if (strcmp(EEG.chanlocs(ii).labels, label))
            idx = ii;
            return;
        end
    end
    idx = 0;
end


