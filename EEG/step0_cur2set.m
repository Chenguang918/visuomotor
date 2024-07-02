clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\0.cdt\';
path_out_eeg = 'E:\Data\202305\EEG\1.set\';

%% Parameter
NSUB = 50;
FS_EEG = 500;

%% Main
for isub = 8:8
    %% Check existence of file and load data
    file_in_eeg = ['sub' num2str(isub, '%d') '.cdt' ];
    fprintf('[Sub %d] : ', isub);
    if ~exist([path_in_eeg file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        continue;
    end
    EEG1 = loadcurry([path_in_eeg file_in_eeg], 'KeepTriggerChannel', 'False', 'CurryLocations', 'True');
    % 由于原始cdt文件包含TriggerChannel，会导致重复和错误的标记
    % 在loadcurry中527增加 data(trigindx,:) = data(trigindx,:)*0; 去掉TriggerChannel
    EEG = eeg_checkset(EEG);
    
    %% Change Sample Rate
    if (isub == 27) || (isub == 28) || (isub == 29)
        EEG = pop_resample( EEG, FS_EEG);
        EEG = eeg_checkset(EEG);
    end

    %% Save data
    file_out_eeg = ['sub' num2str(isub, '%d') '.set' ];
    EEG.setname = ['set - ' 'sub' num2str(isub, '%d')];
    EEG = pop_saveset( EEG, 'filename', file_out_eeg, 'filepath', path_out_eeg);
end

%% Done
load gong.mat;
sound(y);
