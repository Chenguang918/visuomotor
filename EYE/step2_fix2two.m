clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\3.fix\';
path_out_eye = 'E:\Data\202305\EYE\4.two\';
load('..\INF\MK_EEG.mat');

%% Parameter
FS_EYE = 1000;
NSUB = 50;
NBLK = 6;
NTAG = 6;
N_TSK_SAM = 43;
N_TSK_ALL = 172;
TPT_TW1 = [0 0.2]*FS_EYE; % sample
TPT_TW2 = [0.2 0.3]*FS_EYE; % sample

%% Main
blk_typ = 'tsk';
tot_sub = 1;
for isub = 1:NSUB
    %% Check existence of file and load data
    EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ);
    if isempty(EYE_BLK)
        continue;
    end

    %% Get eye data
    for iblk = 1:NBLK
        EYE_EASY_TW1(:,iblk,tot_sub) = get_eye_event(TPT_TW1, MK_EEG, EYE_BLK(iblk), [1 N_TSK_SAM])';
        EYE_EASY_TW2(:,iblk,tot_sub) = get_eye_event(TPT_TW2, MK_EEG, EYE_BLK(iblk), [1 N_TSK_SAM])';
        EYE_HARD_TW1(:,iblk,tot_sub) = get_eye_event(TPT_TW1, MK_EEG, EYE_BLK(iblk), [1+N_TSK_SAM N_TSK_ALL])';
        EYE_HARD_TW2(:,iblk,tot_sub) = get_eye_event(TPT_TW2, MK_EEG, EYE_BLK(iblk), [1+N_TSK_SAM N_TSK_ALL])';
    end
    tot_sub = tot_sub + 1;
    %% Save data
end

save([path_out_eye 'EYE_12.mat'], 'EYE_EASY_TW1','EYE_EASY_TW2', 'EYE_HARD_TW1','EYE_HARD_TW2', '-mat');


%% Check existence of file and load data
function EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eye = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eye '\' file_in_eye],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EYE_BLK = [];
    else
        load([path_in_eye file_in_eye]);
        eval(['EYE_BLK = EYE_' upper(blk_typ) ';']);
    end
end


function eye_evt = get_eye_event(TPT_TW, MK_EEG, EYE, tr)
    for ievt = tr(1):tr(2)
        tim_evt(ievt,1) = EYE.event(ievt*3-2,1); %Show Target
        idx_tag(ievt,1) = EYE.event(ievt*3-1,2) - MK_EEG.Target1 + 1;
    end

    for ii = 1:length(tim_evt)
        eye_evt(ii).Fix = get_evt_list(TPT_TW, tim_evt(ii), EYE.eyeevent.fixations.data);
        eye_evt(ii).Sac = get_evt_list(TPT_TW, tim_evt(ii), EYE.eyeevent.saccades.data);
        eye_evt(ii).Bli = get_evt_list(TPT_TW, tim_evt(ii), EYE.eyeevent.blinks.data);
        eye_evt(ii).Tag = idx_tag(ii);
    end
end


function evt_list = get_evt_list(TPT_TW, tpt_sti, data)
    tw = TPT_TW + tpt_sti;
    evt_list = [];
    for jj = 1:size(data,1)
        if (tw(1) <= data(jj,1)) && (data(jj,2) <= tw(2))
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(1)) && (tw(2) <= data(jj,2))
            data(jj,1) = tw(1);
            data(jj,2) = tw(2);
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(1)) && (tw(1) <= data(jj,2))
            data(jj,1) = tw(1);
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(2)) && (tw(2) <= data(jj,2))
            data(jj,2) = tw(2);
            evt_list = [evt_list; data(jj,:)];
        end
    end
    if ~isempty(evt_list)
        evt_list(:,1:2) = evt_list(:,1:2) - tpt_sti - TPT_TW(1) + 1; %%
    end
end


function evt_list = get_evt_data(TPT_TW, tpt_sti, data)
    tw = TPT_TW + tpt_sti;
    evt_list = [];
    for jj = 1:size(data,1)
        if (tw(1) <= data(jj,1)) && (data(jj,2) <= tw(2))
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(1)) && (tw(2) <= data(jj,2))
            data(jj,1) = tw(1);
            data(jj,2) = tw(2);
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(1)) && (tw(1) <= data(jj,2))
            data(jj,1) = tw(1);
            evt_list = [evt_list; data(jj,:)];
        elseif (data(jj,1) <= tw(2)) && (tw(2) <= data(jj,2))
            data(jj,2) = tw(2);
            evt_list = [evt_list; data(jj,:)];
        end
    end
    if ~isempty(evt_list)
        evt_list(:,1:2) = evt_list(:,1:2) - tpt_sti - TPT_TW(1) + 1; %%
    end
end


function evt_list = get_evt_list2(TPT_TW, tpt_sti, data)
    tw = TPT_TW + tpt_sti;
    evt_list = [];
    for jj = 1:size(data,1)
        if (tw(1) <= data(jj,1)) && (data(jj,2) <= tw(2))
            evt_list = [evt_list; data(jj,:)];
        end
    end
    if ~isempty(evt_list)
        evt_list(:,1:2) = evt_list(:,1:2) - tpt_sti - TPT_TW(1) + 1; %%
    end
end




