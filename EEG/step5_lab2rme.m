clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\6.lab\';
path_out_eeg = 'E:\Data\202305\EEG\7.rme\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;

IC_TH = [NaN NaN; ...	%Brain
        0.95 1; ...     %Muscle
        0.85 1; ...     %Eye
        NaN NaN; ...	%Heart
        NaN NaN; ...	%Line Noise
        NaN NaN; ...	%Channel Noise
        NaN NaN];	    %Other


%% Main
blk_typ = 'tsk';

fileID = fopen([path_out_eeg 'log_' blk_typ '.txt'],'w');
for isub = 1:NSUB
    %% Check existence of file and load data
    [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ);
    if isempty(EEG_BLK)
        continue;
    end
    fprintf(fileID, 'Sub[%2d]: \t', isub);

    for iblk = 1:NBLK
        % Load EEG block
        EEG = EEG_BLK(iblk);
        EEG = eeg_checkset(EEG);
        
        % Remove components
        EEG = pop_icflag(EEG, IC_TH);
        rej_idx = find(EEG.reject.gcompreject==1);
        rej_idx = sort(rej_idx);
        rej_idx = rej_idx(1:min(4,length(rej_idx)));
        EEG = pop_subcomp(EEG, rej_idx, 0);
        
        % Re-ref
        % EEG = pop_reref( EEG, [],'exclude',[18 24 33] );

        fprintf(fileID, '%d\t', length(rej_idx));
        % Save EEG block
        EEG_BLK(iblk) = EEG;
    end
    fprintf(fileID, '\r\n');

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


