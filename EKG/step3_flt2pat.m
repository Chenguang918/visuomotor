clc;clear;close all;

%% File path and name
path_in_ekg = 'E:\Data\202305\EKG\2.flt\';
path_out_ekg = 'E:\Data\202305\EKG\3.pat\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_EEG = 500;
NCH = 33;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task
load('..\INF\MK_EEG.mat');


%% Main
for isub = 1:NSUB
    %% Check existence of file and load data
    EKG_BLK_TSK = check_and_get_data(isub, path_in_ekg, 'tsk');
    EKG_BLK_RST = check_and_get_data(isub, path_in_ekg, 'rst');
    if isempty(EKG_BLK_TSK)
        continue;
    end

    %% Every block
    for iblk = 1:NBLK
        EKG = EKG_BLK_TSK(iblk);
        [latency_same, latency_diff] = get_event_latency(MK_EEG, NSTSK, NATSK, EKG);
        EKG_BLK(iblk).REST = EKG_BLK_RST(iblk).data;
        EKG_BLK(iblk).SAME = EKG.data(latency_same(1):latency_same(2));
        EKG_BLK(iblk).DIFF = EKG.data(latency_diff(1):latency_diff(2));
    end

    %% Save data
    file_out_ekg = ['sub' num2str(isub) '.mat'];
    save([path_out_ekg file_out_ekg], 'EKG_BLK', '-mat');
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


function [latency_same, latency_diff] = get_event_latency(MK_EEG, NSTSK, NATSK, EEG)
    % Get all target event
    ievt_target_all = [];
    for ievt = 1:length(EEG.event)
        if ismember(EEG.event(ievt).type, MK_EEG.Target1:MK_EEG.Target6)
            ievt_target_all = [ievt_target_all, ievt];
        end
    end
    latency_same(1) = round(EEG.event(ievt_target_all(1)-1).latency);
    latency_same(2) = round(EEG.event(ievt_target_all(NSTSK)+1).latency);
    latency_diff(1) = round(EEG.event(ievt_target_all(NSTSK+1)-1).latency);
    latency_diff(2) = round(EEG.event(ievt_target_all(NATSK)+1).latency);
end


