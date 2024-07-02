clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\1.ren\';
path_in_eeg = 'E:\Data\202305\EEG\1.set\';
path_in_eye = 'E:\Data\202305\EYE\1.mat\';
path_in_nir = 'E:\Data\202305\NIR\1.nir\';
path_out_beh = 'E:\Data\202305\BEH\2.blk\';
path_out_eeg = 'E:\Data\202305\EEG\2.blk\';
path_out_eye = 'E:\Data\202305\EYE\2.blk\';
path_out_nir = 'E:\Data\202305\NIR\2.blk\';
path_out_tst = 'E:\Data\202305\TST\';
name_mid1 = 'MES_Probe1';
name_mid2 = 'MES_Probe2';
addpath('..\FUN\Hitachi_2_Homer_v3');
file_pos = '3x5.pos';
load('..\INF\MK_EEG.mat');
load('..\INF\MK_NIR.mat');

%% Parameter
NSUB = 50;
FS_EEG = 500;
FS_NIR = 10;
FS_EYE = 1000;
IS_FIG = 1; % <---------- 


%% Main
for isub = 1:NSUB
    fprintf("[sub %d]:", isub);
    % Load all data
    [EEG, NIR, BEH, EYE, lack_inf] = load_all(isub, path_in_eeg, path_in_nir, path_in_beh, path_in_eye);
    if ~contains(lack_inf, 'ALL')
        fprintf("\t[Missing Data] %s\t\r\n", lack_inf);
        if contains(lack_inf, 'EEG')
            continue;
        end
    end

    % Figure
    if IS_FIG == 1
        fig = figure('WindowState','maximized');
        tiledlayout(2,2,'TileSpacing','compact', 'Padding','compact');
    end
    [EEG, NIR, BEH, EYE] = pre_fix(isub, EEG, NIR, BEH, EYE);

    % Get all events
    [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_all(EEG, NIR, BEH, EYE, FS_EEG, FS_NIR, FS_EYE);

    % Get information from events
    [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_inf(evt_eeg, evt_nir, evt_beh, evt_eye, MK_EEG, MK_NIR);
    % Check information from events
    [evt_eeg, evt_nir, evt_beh, evt_eye] = chk_evt_inf(evt_eeg, evt_nir, evt_beh, evt_eye);
    % Get slope and offset of time steps
    [fit_nir, fit_beh, fit_eye]  = get_polyfit_all(evt_eeg, evt_nir, evt_beh, evt_eye, MK_EEG, IS_FIG);

    % Align time steps
    [NIR, BEH, EYE] = align_RAW(NIR, BEH, EYE, fit_nir, fit_beh, fit_eye, FS_NIR, FS_EYE, evt_eeg);
    % Get all events
    [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_all(EEG, NIR, BEH, EYE, FS_EEG, FS_NIR, FS_EYE);
    % Get information from events
    [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_inf(evt_eeg, evt_nir, evt_beh, evt_eye, MK_EEG, MK_NIR);

    % Get & Check SOA
    BEH = get_chk_SOA(evt_eeg, BEH, IS_FIG);

    % Segment into block
    [EEG_RST, EEG_TSK, NIR_RST, NIR_TSK, BEH_TSK, EYE_TSK] = get_blk(EEG, NIR, BEH, EYE, MK_EEG, MK_NIR, FS_EEG, FS_NIR);

    % save data
%     file_out_eeg = ['sub' num2str(isub) '_rst.mat'];
%     save([path_out_eeg file_out_eeg], 'EEG_RST', '-mat');
%     file_out_eeg = ['sub' num2str(isub) '_tsk.mat'];
%     save([path_out_eeg file_out_eeg], 'EEG_TSK', '-mat');
%     file_out_nir = ['sub' num2str(isub) '_rst.mat'];
%     save([path_out_nir file_out_nir], 'NIR_RST', '-mat');
%     file_out_nir = ['sub' num2str(isub) '_tsk.mat'];
%     save([path_out_nir file_out_nir], 'NIR_TSK', '-mat');
%     file_out_beh = ['sub' num2str(isub) '_tsk.mat'];
%     save([path_out_beh file_out_beh], 'BEH_TSK', '-mat');
%     file_out_eye = ['sub' num2str(isub) '_tsk.mat'];
%     save([path_out_eye file_out_eye], 'EYE_TSK', '-mat');
    
    % save figure
    if IS_FIG == 1
        saveas(fig, [path_out_tst '\sub' num2str(isub, '%d') '.png'], 'png');
        close(fig);
        delete(fig);
    end

    fprintf("\t[Done]\r\n");
end


%% Functions

function [EEG, NIR, BEH, EYE, lack_inf] = load_all(isub, path_in_eeg, path_in_nir, path_in_beh, path_in_eye)
    lack_inf = [];
    % Load Data - EEG
    file_in_eeg = ['sub' num2str(isub, '%d') '.set' ];
    if exist([path_in_eeg file_in_eeg],'file')
        EEG = pop_loadset('filename', file_in_eeg, 'filepath', path_in_eeg);
        EEG = eeg_checkset(EEG);
    else
        EEG = [];
        lack_inf = [lack_inf ' No EEG!'];
    end
    % Load Data - NIRS
    file_in_nir = ['sub' num2str(isub) '.nirs'];
    if exist([path_in_nir file_in_nir],'file')
        NIR = load([path_in_nir file_in_nir], '-mat');
    else
        NIR = [];
        lack_inf = [lack_inf ' No NIR!'];
    end
    % Load Data - BEH
    file_in_beh = ['sub' num2str(isub) '.mat'];
    if exist([path_in_beh file_in_beh],'file')
        BEH = load([path_in_beh file_in_beh], '-mat');
    else
        BEH = [];
        lack_inf = [lack_inf ' No BEH!'];
    end
    % Load Data - EYE
    file_in_eye = ['sub' num2str(isub) '.mat'];
    if exist([path_in_eye file_in_eye],'file')
        EYE = load([path_in_eye file_in_eye], '-mat');
    else
        EYE = [];
        lack_inf = [lack_inf ' No EYE!'];
    end
    % All Data
    if isempty(lack_inf)
        lack_inf = 'ALL';
    end
end

function [EEG, NIR, BEH, EYE] = pre_fix(isub, EEG, NIR, BEH, EYE)
    if isub == 3
        EEG.event = [EEG.event(1:2026) EEG.event(2028:end)];
    elseif isub == 4
        tmp(1,1) = 18318454;
        tmp(1,2) = 250;
        EYE.event = [EYE.event(1:749,:); tmp; EYE.event(750:end,:)];
    elseif isub == 6
        EEG.event = EEG.event([1:2432 2434:end]);
    elseif isub == 7
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [1311 1313]));
    elseif isub == 9
        EEG.event = EEG.event([17, 30:1066, 1069:3145]);
    elseif isub == 12
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [1432 2509 2522]));
    elseif isub == 13
        tmp(1,1) = 947358;
        tmp(1,2) = 250;
        EYE.event = [EYE.event(1:230,:); tmp; EYE.event(231:end,:)];
    elseif isub == 14
        EEG.event = EEG.event(setdiff(1:length(EEG.event), 2469));
    elseif isub == 15
        EEG.event = [EEG.event(1:2412) EEG.event(2414:end)];
    elseif isub == 16
        EEG.event = [EEG.event(1:323) EEG.event(325:end)];
        EEG.event = [EEG.event(1:2997) EEG.event(2999:end)];
    elseif isub == 20
        EEG.event = [EEG.event(1:991) EEG.event(993:end)];
    elseif isub == 21
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [2616 3023]));
    elseif isub == 23
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [987 2647 2963]));
    elseif isub == 24
        EEG.event = [EEG.event(1:28) EEG.event(30:end)];
    elseif isub == 27
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [150 2920]));
    elseif isub == 30
        EEG.event = EEG.event(setdiff(1:length(EEG.event), 1512));
    elseif isub == 31
        EEG.event = [EEG.event(1:2397) EEG.event(2399:end)];
        tmp(1,1) = 3684244;
        tmp(1,2) = 250;
        EYE.event = [EYE.event(1:563,:); tmp; EYE.event(564:end,:)];
    elseif isub == 32
        EEG.event = [EEG.event(1:2992) EEG.event(2994:end)];
    elseif isub == 33
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [699 2907]));
    elseif isub == 34
        EEG.event = [EEG.event(1:169) EEG.event(171:end)];
        EEG.event = [EEG.event(1:1084) EEG.event(1086:end)];
    elseif isub == 35
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [904 2836]));
    elseif isub == 36
        EEG.event = [EEG.event(1:950) EEG.event(952:end)];
    elseif isub == 37
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [1466 2836]));
    elseif isub == 38
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [116 1994]));
    elseif isub == 39
        EEG.event = EEG.event(setdiff(1:length(EEG.event), 947));
    elseif isub == 40
        EEG.event = [EEG.event(1:1081) EEG.event(1083:end)];
    elseif isub == 41
        EEG.event = EEG.event([1:1300, 1302:2082, 2084:3117]);
    elseif isub == 42
        EEG.event = EEG.event([1:2077, 2079:3116]);
    elseif isub == 43
        EEG.event = EEG.event(setdiff(1:length(EEG.event), 201));
    elseif isub == 45
        tmp(1,1) = 23475714;
        tmp(1,2) = 250;
        EYE.event = [EYE.event(1:593,:); tmp; EYE.event(594:end,:)];
        EEG.event = EEG.event(setdiff(1:length(EEG.event), 2065));
    elseif isub == 46
        EEG.event = [EEG.event(1:378) EEG.event(380:end)];
        len_evt = length(EEG.event);
        for ii = 1562:len_evt
            EEG.event(ii).latency = EEG.event(ii).latency + 113365;
        end
        EEG.data = [EEG.data(:,1:2661500), zeros(EEG.nbchan, 113365), EEG.data(:,2661501:end)];
        EEG.pnts = size(EEG.data, 2);
        EEG.xmax = EEG.pnts/EEG.srate;
        EEG.times = (0:1:EEG.pnts-1)/EEG.srate*1000;
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [2 763]));
        EEG.event(1559).type = 252;
        EEG.event(1559).latency = 2850005;
    elseif isub == 49
        EEG.event = EEG.event(setdiff(1:length(EEG.event), [746 2542]));
    elseif isub == 50
        EEG.event = [EEG.event(1:2238) EEG.event(2240:end)];
    end
    EEG = eeg_checkset(EEG);
end

function [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_all(EEG, NIR, BEH, EYE, FS_EEG, FS_NIR, FS_EYE)
    % Get Events - EEG
    if ~isempty(EEG)
        for ii = 1:length(EEG.event)
            evt_eeg.type(ii,1) = EEG.event(ii).type;
            evt_eeg.latency(ii,1) = EEG.event(ii).latency/FS_EEG;
        end
    else
        evt_eeg = [];
    end
    % Get Events - NIR
    if ~isempty(NIR)
        evt_all = NIR.aux*(1:size(NIR.aux,2))';
        evt_nir.type = evt_all(evt_all~=0);
        evt_nir.latency = find(evt_all~=0)/FS_NIR;
    else
        evt_nir = [];
    end
    % Get Events - BEH
    if ~isempty(BEH)
        evt_beh.type = reshape(BEH.BlockStiT',[],1);
        evt_beh.latency = reshape(BEH.BlockTRespOnset',[],1);
    else
        evt_beh = [];
    end
    % Get Events - EYE
    if ~isempty(EYE)
        if size(EYE.event,1) == 3096
            evt_eye.type = EYE.event(:,2);
            evt_eye.latency = EYE.event(:,1)/FS_EYE;
        else
            cnt = 1;
            for ii = 37:length(EYE.othermessages)
                msg = split(string(EYE.othermessages(ii).msg));
                typ = str2num(msg(3));
                tim = str2num(msg(2));
                if (length(msg) == 4) && ~(isempty(typ))
                    evt_eye.type(cnt,1) = typ;
                    evt_eye.latency(cnt,1) = tim/FS_EYE;
                    cnt = cnt + 1;
                end
            end
        end
    else
        evt_eye = [];
    end
end

function [evt_eeg, evt_nir, evt_beh, evt_eye] = get_evt_inf(evt_eeg, evt_nir, evt_beh, evt_eye, MK_EEG, MK_NIR)
    % get markers information from EEG
    if ~isempty(evt_eeg)
        evt_eeg.idx_SOA = find( ((evt_eeg.type >= MK_EEG.SOA_C1) & (evt_eeg.type <= MK_EEG.SOA_C43)) | ...
                            ((evt_eeg.type >= MK_EEG.SOA_L1) & (evt_eeg.type <= MK_EEG.SOA_L43)) | ...
                            ((evt_eeg.type >= MK_EEG.SOA_R1) & (evt_eeg.type <= MK_EEG.SOA_R43)) );
        evt_eeg.idx_orit = find((evt_eeg.type >= MK_EEG.Target1) & (evt_eeg.type <= MK_EEG.Target6));
        evt_eeg.idx_resp = find( (evt_eeg.type == MK_EEG.Response_Correct) | ...
                                 (evt_eeg.type == MK_EEG.Response_Wrong) | ...
                                 (evt_eeg.type == MK_EEG.Response_No) );
        evt_eeg.mark_SOA = evt_eeg.type(evt_eeg.idx_SOA);
        evt_eeg.mark_orit = evt_eeg.type(evt_eeg.idx_orit) - MK_EEG.Target1 + 1;
        evt_eeg.mark_resp = evt_eeg.type(evt_eeg.idx_resp);
        evt_eeg.tpts_SOA = evt_eeg.latency(evt_eeg.idx_SOA);
        evt_eeg.tpts_orit = evt_eeg.latency(evt_eeg.idx_orit);
        evt_eeg.tpts_resp = evt_eeg.latency(evt_eeg.idx_resp);
        evt_eeg.idx_blk_begin = find(evt_eeg.type == MK_EEG.Blk_Begin);
        evt_eeg.idx_blk_end = find(evt_eeg.type == MK_EEG.Blk_End);
    end
    % get markers information from NIR
    if ~isempty(evt_nir)
        evt_nir.idx_resp = find((evt_nir.type >= MK_NIR.Target1) & (evt_nir.type <= MK_NIR.Target6));
        evt_nir.idx_resp = evt_nir.idx_resp(1:2:end);
        evt_nir.mark_orit = evt_nir.type(evt_nir.idx_resp) - MK_NIR.Target1 + 1;
        evt_nir.tpts_resp = evt_nir.latency(evt_nir.idx_resp);
    end
    % get markers information from BEH
    if ~isempty(evt_beh)
        evt_beh.mark_orit = evt_beh.type;
        evt_beh.tpts_orit = evt_beh.latency;
    end
    % get markers information from EYE
    if ~isempty(evt_eye)
        evt_eye.idx_SOA = find( ((evt_eye.type >= MK_EEG.SOA_C1) & (evt_eye.type <= MK_EEG.SOA_C43)) | ...
                            ((evt_eye.type >= MK_EEG.SOA_L1) & (evt_eye.type <= MK_EEG.SOA_L43)) | ...
                            ((evt_eye.type >= MK_EEG.SOA_R1) & (evt_eye.type <= MK_EEG.SOA_R43)) );
        evt_eye.idx_orit = find((evt_eye.type >= MK_EEG.Target1) & (evt_eye.type <= MK_EEG.Target6));
        evt_eye.idx_resp = find( (evt_eye.type == MK_EEG.Response_Correct) | ...
                                 (evt_eye.type == MK_EEG.Response_Wrong) | ...
                                 (evt_eye.type == MK_EEG.Response_No) );
        evt_eye.mark_SOA = evt_eye.type(evt_eye.idx_SOA);
        evt_eye.mark_orit = evt_eye.type(evt_eye.idx_orit) - MK_EEG.Target1 + 1;
        evt_eye.mark_resp = evt_eye.type(evt_eye.idx_resp);
        evt_eye.tpts_SOA = evt_eye.latency(evt_eye.idx_SOA);
        evt_eye.tpts_orit = evt_eye.latency(evt_eye.idx_orit);
        evt_eye.tpts_resp = evt_eye.latency(evt_eye.idx_resp);
    end
end

function  [evt_eeg, evt_nir, evt_beh, evt_eye, msg_err] = chk_evt_inf(evt_eeg, evt_nir, evt_beh, evt_eye)
    N_TRL1 = 43;
    N_TRL2 = 129;
    N_BLK = 6;
    N_TRL_ALL = (N_TRL1 + N_TRL2)*N_BLK;
    msg_err = [];
    % check EEG makers
    if ~isempty(evt_eeg)
        if (length(evt_eeg.idx_resp) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EEG Rsp Cnt]'];
        elseif (length(evt_eeg.idx_orit) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EEG Ori Cnt]'];
        elseif (length(evt_eeg.idx_SOA) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EEG SOA Cnt]'];
        elseif (length(evt_eeg.idx_blk_begin) ~= N_BLK) || (length(evt_eeg.idx_blk_end) ~= N_BLK)
            msg_err = [msg_err ' [EEG Blk Cnt]'];
        elseif ~isequal(evt_eeg.idx_blk_end - evt_eeg.idx_blk_begin, ones(N_BLK,1)*517)
            msg_err = [msg_err ' [EEG Mak Cnt]'];
        end
    end

    % check NIR makers
    if ~isempty(evt_nir)
        if (length(evt_nir.idx_resp) ~= N_TRL_ALL)
            msg_err = [msg_err ' [NIR Rsp Cnt]'];
        elseif ~isequal(evt_eeg.mark_orit, evt_nir.mark_orit)
            msg_err = [msg_err ' [EEG NIR Ori]'];
        end
    end

    % check BEH makers
    if ~isempty(evt_beh)
        if (length(evt_beh.tpts_orit) ~= N_TRL_ALL)
            msg_err = [msg_err ' [BEH Ori Cnt]'];
        elseif (length(evt_beh.mark_orit) ~= N_TRL_ALL)
            msg_err = [msg_err ' [BEH Ori Cnt]'];
        elseif ~isequal(evt_eeg.mark_orit, evt_beh.mark_orit)
            msg_err = [msg_err ' [EEG BEH Ori]'];
        end
    end

    % check EYE makers
    if ~isempty(evt_eye)
        if (length(evt_eye.idx_resp) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EYE Rsp Cnt]'];
        elseif (length(evt_eye.idx_orit) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EYE Ori Cnt]'];
        elseif (length(evt_eye.idx_SOA) ~= N_TRL_ALL)
            msg_err = [msg_err ' [EYE SOA Cnt]'];
        elseif ~isequal(evt_eeg.mark_orit, evt_eye.mark_orit)
            msg_err = [msg_err ' [EEG EYE Orit]'];
        elseif ~isequal(evt_eeg.mark_resp, evt_eye.mark_resp)
            msg_err = [msg_err ' [EEG EYE Resp]'];
        end
    end

    % output err msg
    if isempty(msg_err)
        fprintf("Check OK!\r\n");
    else
        fprintf("Check Err: %s\r\n", msg_err);
    end

end

function [fit_nir, fit_beh, fit_eye] = get_polyfit_all(evt_eeg, evt_nir, evt_beh, evt_eye, MK_EEG, is_fig)
    N_TRL1 = 43;
    N_TRL2 = 129;
    N_TRL_BLK = (N_TRL1 + N_TRL2);
    N_BLK = 6;
    N_TRL_ALL = (N_TRL1 + N_TRL2)*N_BLK;

    % get markers information from NIR
    if ~isempty(evt_nir)
        idx_eeg_sel = union(43:N_TRL_BLK:N_TRL_ALL, N_TRL_BLK:N_TRL_BLK:N_TRL_ALL);
        idx_eeg_sel = setdiff(1:1:N_TRL_ALL, idx_eeg_sel);
        idx_nir_sel = union(1:N_TRL_BLK:N_TRL_ALL, (N_TRL1+1):N_TRL_BLK:N_TRL_ALL);
        idx_nir_sel = setdiff(1:1:N_TRL_ALL, idx_nir_sel);
        tpts_sel_eeg = evt_eeg.tpts_resp(idx_eeg_sel);
        tpts_sel_nir = evt_nir.tpts_resp(idx_nir_sel);
        delta_nir_resp = tpts_sel_eeg - tpts_sel_nir;
        p = polyfit(tpts_sel_eeg, tpts_sel_nir, 1);
        fit_nir.slope = p(1);
        fit_nir.offset = p(2);
        delta_nir_resp2 = tpts_sel_eeg - (tpts_sel_nir-fit_nir.offset)/fit_nir.slope;
    else
        fit_nir = [];
    end

    % get offset & slope of time steps for BEH
    if ~isempty(evt_beh)
        delta_beh_orit = evt_eeg.tpts_orit - evt_beh.tpts_orit;
        p = polyfit(evt_eeg.tpts_orit, evt_beh.tpts_orit, 1);
        fit_beh.slope = p(1);
        fit_beh.offset = p(2);
        delta_beh_orit2 = evt_eeg.tpts_orit - (evt_beh.tpts_orit-fit_beh.offset)/fit_beh.slope;
    else
        fit_beh = [];
    end

    % get offset & slope of time steps for EYE
    if ~isempty(evt_eye)
        delta_eye_SOA = evt_eeg.tpts_SOA - evt_eye.tpts_SOA;
        delta_eye_orit = evt_eeg.tpts_orit - evt_eye.tpts_orit;
        delta_eye_resp = evt_eeg.tpts_resp - evt_eye.tpts_resp;
        p = polyfit(evt_eeg.tpts_resp, evt_eye.tpts_resp, 1);
        fit_eye.slope = p(1);
        fit_eye.offset = p(2);
        delta_eye_resp2 = evt_eeg.tpts_resp - (evt_eye.tpts_resp-fit_eye.offset)/fit_eye.slope;
    else
        fit_eye = [];
    end

%     calc offset
%     offset_nir = evt_eeg.latency(1) - evt_nir.latency(1);
%     offset_beh = evt_eeg.latency(5) - evt_beh.latency(1);
%     offset_eye = evt_eeg.latency(3) - evt_eye.latency(1);

    if (is_fig == 1)
        % delta before fit
        nexttile;
        if ~isempty(evt_nir)
            plot(tpts_sel_eeg, delta_nir_resp - delta_nir_resp(1), '.r'); hold on;
        end
        if ~isempty(evt_beh)
            plot(evt_eeg.tpts_orit, delta_beh_orit - delta_beh_orit(1), '.k'); hold on;
        end
        if ~isempty(evt_eye)
            plot(evt_eeg.tpts_SOA, delta_eye_SOA - delta_eye_SOA(1), '.g'); hold on;
            plot(evt_eeg.tpts_orit, delta_eye_orit -  delta_eye_orit(1), 'xg'); hold on;
            plot(evt_eeg.tpts_resp, delta_eye_resp - delta_eye_resp(1), '+g'); hold on;
        end
        yline([-0.1 0.1],'--'); hold on;
        title('Delta time of differet markers');
        legend('NIR Resp','BEH Orit','EYE SOA','EYE Orit','EYE Resp');
        
        % delta after fit
        nexttile;
        if ~isempty(evt_nir)
            plot(tpts_sel_eeg, delta_nir_resp2 , '.r'); hold on;
        end
        if ~isempty(evt_beh)
            plot(evt_eeg.tpts_orit, delta_beh_orit2 , '.k'); hold on;
        end
        if ~isempty(evt_eye)
            plot(evt_eeg.tpts_resp, delta_eye_resp2 , '.g'); hold on;
        end
        yline([-0.1 0.1],'--'); hold on;
        ylim([-0.2 0.2]);
        title('Delta time of differet markers after [fit] ');
        legend('NIR Resp','BEH Orit','EYE Resp');
        % marker match
        nexttile;
        [evt_eeg2, evt_eye2] = change_evt_type(evt_eeg, evt_eye, MK_EEG);
        stem(evt_eeg2.latency, evt_eeg2.type, 'b'); hold on;
        if ~isempty(evt_nir)
            stem((evt_nir.latency-fit_nir.offset)/fit_nir.slope, 0.2-evt_nir.type, 'r'); hold on;
        end
        if ~isempty(evt_beh)
            stem((evt_beh.latency-fit_beh.offset)/fit_beh.slope, -0.1+evt_beh.type, 'k'); hold on;
        end
        if ~isempty(evt_eye)
            stem((evt_eye2.latency-fit_eye.offset)/fit_eye.slope, 0.1+evt_eye2.type, 'g'); hold on;
        end
        ylim([-8 8]); yline([-0.1 0.1],'--');
        title('All Markers');
        legend('EEG','NIR','BEH','EYE');
    end
end

function [NIR, BEH, EYE] = align_RAW(NIR, BEH, EYE, fit_nir, fit_beh, fit_eye, FS_NIR, FS_EYE, evt_eeg)
    % Align NIR
    if ~isempty(NIR)
        idx_sft = round(fit_nir.offset*FS_NIR);
        if (idx_sft >= 0)
            %NIR.aux = NIR.aux(idx_sft+1:end,:);
            NIR.d = NIR.d(idx_sft+1:end,:);
            NIR.s = NIR.s(idx_sft+1:end,:);
            NIR.t = NIR.t(idx_sft+1:end,:);
            NIR.t = NIR.t - NIR.t(1);
        else
            %NIR.aux = [zeros(-idx_sft, size(NIR.aux,2)); NIR.aux];
            NIR.d = [zeros(-idx_sft, size(NIR.d,2)); NIR.d];
            NIR.s = [zeros(-idx_sft, size(NIR.s,2)); NIR.s];
            NIR.t = [zeros(-idx_sft, size(NIR.t,2)); NIR.t];
            NIR.t = NIR.t - NIR.t(1);
        end
        NIR.aux(:,1:6) = 0;
        idx_soa = round(evt_eeg.tpts_SOA*FS_NIR);
        idx_resp = round(evt_eeg.tpts_resp*FS_NIR);
        for ii = 1:length(idx_soa)
            NIR.aux(idx_soa(ii), evt_eeg.mark_orit(ii)) = 1;
            NIR.aux(idx_soa(ii)+2, evt_eeg.mark_orit(ii)) = 1;
            NIR.aux(idx_resp(ii), 8) = 1;
        end
    end

    % Align BEH
    if ~isempty(BEH)
        BEH.BlockTRespOnset = (BEH.BlockTRespOnset - fit_beh.offset)/fit_beh.slope;
    end

    % Align EYE
    if ~isempty(EYE)
        EYE.event(:,1) = round((EYE.event(:,1)-fit_eye.offset*FS_EYE)/fit_eye.slope);
        EYE.eyeevent.blinks.data(:,1:2) = round((EYE.eyeevent.blinks.data(:,1:2)-fit_eye.offset*FS_EYE)/fit_eye.slope);
        EYE.eyeevent.blinks.data(:,3) = EYE.eyeevent.blinks.data(:,2) - EYE.eyeevent.blinks.data(:,1) + 1;
        EYE.eyeevent.fixations.data(:,1:2) = round((EYE.eyeevent.fixations.data(:,1:2)-fit_eye.offset*FS_EYE)/fit_eye.slope);
        EYE.eyeevent.fixations.data(:,3) = EYE.eyeevent.fixations.data(:,2) - EYE.eyeevent.fixations.data(:,1) + 1;
        EYE.eyeevent.saccades.data(:,1:2) = round((EYE.eyeevent.saccades.data(:,1:2)-fit_eye.offset*FS_EYE)/fit_eye.slope);
        EYE.eyeevent.saccades.data(:,3) = EYE.eyeevent.saccades.data(:,2) - EYE.eyeevent.saccades.data(:,1) + 1;
        for ii = 1:length(EYE.othermessages)
            EYE.othermessages(ii).timestamp = round((EYE.othermessages(ii).timestamp-fit_eye.offset*FS_EYE)/fit_eye.slope);
            EYE.othermessages(ii).timestamp = max(EYE.othermessages(ii).timestamp, 1);
        end
        EYE.data(:,1) = round((EYE.data(:,1)-fit_eye.offset*FS_EYE)/fit_eye.slope);
        % -------------- EYE.messages -------------
        PAT_TYPE1 = ("START"|"END"|"INPUT"|"MSG"|"SSACC L"|"SFIX L"|"SBLINK L");
        PAT_TYPE2 = ("ESACC L"|"EFIX L"|"EBLINK L");
        pat1 = PAT_TYPE1 + wildcardPattern + digitsPattern;
        pat2 = PAT_TYPE2 + wildcardPattern + digitsPattern + wildcardPattern + digitsPattern;
        for ii = 1:length(EYE.messages)
            str = EYE.messages(ii);
            if contains(str, pat1)
                s1 = extractBefore(str, digitsPattern);
                s2 = extract(str, digitsPattern);
                t1 = str2num(s2{1});
                s3 = extractAfter(str, digitsPattern);
                t1 = round((t1-fit_eye.offset*FS_EYE)/fit_eye.slope);
                t1 = max(1,t1);
                EYE.messages(ii) = join([s1, num2str(t1), s3],'');
            elseif contains(str, pat2)
                s1 = extractBefore(str, digitsPattern);
                s2 = extract(str, digitsPattern);
                t1 = str2num(s2{1});
                str2 = extractAfter(str, digitsPattern);
                s3 = extractBefore(str2, digitsPattern);
                s4 = extract(str2, digitsPattern);
                t2 = str2num(s4{1});
                s5 = extractAfter(str2, digitsPattern);
                t1 = round((t1-fit_eye.offset*FS_EYE)/fit_eye.slope);
                t2 = round((t2-fit_eye.offset*FS_EYE)/fit_eye.slope);
                t1 = max(1,t1);
                t2 = max(1,t2);
                EYE.messages(ii) = join([s1, num2str(t1), s3, num2str(t2), s5],'');
            end
        end
        % -------------- EYE.messages -------------
    end
end


function BEH = get_chk_SOA(evt_eeg, BEH, is_fig)
    soa_eeg = evt_eeg.tpts_SOA(2:end) - evt_eeg.tpts_resp(1:end-1);
    %soa_beh1 = [BEH.SOA(1,:),0, BEH.SOA(2,:),0, BEH.SOA(3,:),0, BEH.SOA(4,:),0, BEH.SOA(5,:),0, BEH.SOA(6,:)]';
    tpts_beh_orit = reshape(BEH.BlockTRespOnset',[],1);
    durn_beh_trl = tpts_beh_orit(2:end)-tpts_beh_orit(1:end-1);
    durn_beh_rtend= reshape(BEH.RTEnd',[],1);
    soa_beh = durn_beh_trl - durn_beh_rtend(1:end-1);
    if is_fig == 1
        nexttile;
        plot(sort(soa_eeg),'o'); hold on;
        plot(sort(soa_beh),'+');
        yline([2.2 4.8], '--');
        ylim([1.5 5.5]);
        xlim([-50 length(soa_beh)+50]);
        title('Sorting SOA');
        legend('from EEG','from BEH');
    end
    BEH.SOA_New = [0; soa_beh];
end


function [EEG_RST, EEG_TSK, NIR_RST, NIR_TSK, BEH_TSK, EYE_TSK] = get_blk(EEG, NIR, BEH, EYE, MK_EEG, MK_NIR, FS_EEG, FS_NIR)
    N_BLK = 6;
    % Get time points of markers
    tpts_rst_nir = NIR.t(NIR.aux(:,MK_NIR.Rest) == 1);
    tpts_rst_nir = reshape(tpts_rst_nir,2,[])';
    tpts_rst_begin = tpts_rst_nir(:,1)+1;
    tpts_rst_end = tpts_rst_nir(:,2);
    tpts_tsk_begin = [];
    tpts_tsk_end = [];
    for ii = 1:length(EEG.event)
        if EEG.event(ii).type == MK_EEG.Blk_Begin
            tpts_tsk_begin = [tpts_tsk_begin; EEG.event(ii).latency/FS_EEG];
        elseif EEG.event(ii).type == MK_EEG.Blk_End
            tpts_tsk_end = [tpts_tsk_end; EEG.event(ii).latency/FS_EEG];
        end
    end

    % Block - EEG
    for ii = 1:N_BLK
        EEG_RST(ii) = get_inf_dat_EEG(EEG, tpts_rst_begin(ii), tpts_rst_end(ii), FS_EEG);
        EEG_TSK(ii) = get_inf_dat_EEG(EEG, tpts_tsk_begin(ii), tpts_tsk_end(ii), FS_EEG);
    end

    % Block - NIR
    if ~isempty(NIR)
        for ii = 1:N_BLK
            NIR_RST(ii) = get_inf_dat_NIR(NIR, tpts_rst_begin(ii), tpts_rst_end(ii), FS_NIR);
            NIR_TSK(ii) = get_inf_dat_NIR(NIR, tpts_tsk_begin(ii), tpts_tsk_end(ii), FS_NIR);
        end
    else
        NIR_RST = struct([]);
        NIR_TSK = struct([]);
    end

    % Block - BEH
    if ~isempty(BEH)
        for ii = 1:N_BLK
            BEH_TSK(ii) = get_inf_dat_BEH(BEH, ii);
        end
    else
        BEH_TSK = struct([]);
    end

    % Block - EYE
    if ~isempty(EYE)
        idx_msg_blk = [];
        idx_msg_blk(:,2) = find(contains(EYE.messages, 'END'))';
        idx_msg_blk(:,1) = [1; idx_msg_blk(1:5,2)];
        for ii = 1:N_BLK
            EYE_TSK(ii) = get_inf_dat_EYE(EYE, idx_msg_blk(ii,:));
        end
    else
        EYE_TSK = struct([]);
    end
end

function EEG_BLK = get_inf_dat_EEG(EEG, tpts_begin, tpts_end, FS_EEG)
    idx1 = round(tpts_begin*FS_EEG);
    idx2 = round(tpts_end*FS_EEG);
    EEG_BLK= eeg_emptyset();
    EEG_BLK.setname = EEG.setname;
    EEG_BLK.filename = EEG.filename;
    %EEG_OUT.filepath = EEG.filepath;
    EEG_BLK.nbchan = EEG.nbchan;
    EEG_BLK.trials = EEG.trials;
    EEG_BLK.srate = EEG.srate;
    EEG_BLK.chanlocs = EEG.chanlocs;
    EEG_BLK.chaninfo = EEG.chaninfo;
    EEG_BLK.ref = EEG.ref;
    EEG_BLK.event = [];
    for ii = 1:length(EEG.event)
        if (idx1 <= EEG.event(ii).latency) && (EEG.event(ii).latency <= idx2)
            EEG_BLK.event = [EEG_BLK.event, EEG.event(ii)];
            EEG_BLK.event(end).latency = EEG_BLK.event(end).latency - idx1 + 1;
        end
    end
    EEG_BLK.urevent = EEG.urevent;
    EEG_BLK.datfile = EEG.datfile;
    EEG_BLK.times = EEG.times(idx1:idx2);
    EEG_BLK.times = EEG_BLK.times - EEG_BLK.times(1);
    EEG_BLK.data = EEG.data(:,idx1:idx2);
    EEG_BLK.xmax = (length(EEG_BLK.times)-1) / FS_EEG;
    EEG_BLK.pnts = length(EEG_BLK.times);
    EEG_BLK = eeg_checkset(EEG_BLK);
end

function NIR_BLK = get_inf_dat_NIR(NIR, tpts_begin, tpts_end, FS_NIR)
    idx1 = round(tpts_begin*FS_NIR);
    idx2 = round(tpts_end*FS_NIR);
    NIR_BLK.SD = NIR.SD;
    NIR_BLK.aux = NIR.aux(idx1:idx2,:);
    NIR_BLK.d = NIR.d(idx1:idx2,:);
    NIR_BLK.ml = NIR.ml;
    NIR_BLK.s = NIR.s(idx1:idx2,:);
    NIR_BLK.t = NIR.t(idx1:idx2,:);
    NIR_BLK.t = NIR_BLK.t - NIR_BLK.t(1);
end

function BEH_BLK = get_inf_dat_BEH(BEH, idx_blk)
    N_TRLS = 172;
    idx_trl = (1:N_TRLS)+N_TRLS*(idx_blk-1);
    BEH_BLK.SOA = BEH.SOA_New(idx_trl);
    BEH_BLK.ACC = BEH.ACC(idx_trl)';
    BEH_BLK.Orit_Type = BEH.BlockStiT(idx_blk,:)';
    BEH_BLK.Orit_Time = BEH.BlockTRespOnset(idx_blk,:)';
    BEH_BLK.Pos_X = BEH.BlockX(idx_blk,:)';
    BEH_BLK.Pos_Y = BEH.BlockY(idx_blk,:)';
    BEH_BLK.Theta = BEH.Theta(idx_trl)';
    BEH_BLK.RT_Start = BEH.RTStart(idx_trl);
    BEH_BLK.RT_Duration = BEH.Duration(idx_trl);
    BEH_BLK.RT_End = BEH.RTEnd(idx_trl);
    BEH_BLK.Cnt.HighHit = BEH.Blockhighhit(idx_blk);
    BEH_BLK.Cnt.Hit = BEH.Blockhit(idx_blk);
    BEH_BLK.Cnt.Miss = BEH.Blockmiss(idx_blk);
    BEH_BLK.Cnt.Wrong = BEH.Blockwrong(idx_blk);
end

function EYE_BLK = get_inf_dat_EYE(EYE, idx_msg_blk)
    tmp = extract( EYE.messages( idx_msg_blk(1) ) , digitsPattern);
    tpts_start = str2num(tmp{1});
    tmp = extract( EYE.messages( idx_msg_blk(2) ) , digitsPattern);
    tpts_end = str2num(tmp{1});

    EYE_BLK.colheader = EYE.colheader;
    EYE_BLK.comments = EYE.comments;
    EYE_BLK.data = EYE.data((EYE.data(:,1)>=tpts_start) & (EYE.data(:,1)<=tpts_end),:);
    EYE_BLK.event = EYE.event(((EYE.event(:,1)>=tpts_start) & (EYE.event(:,1)<=tpts_end)), :);
    EYE_BLK.eyeevent = EYE.eyeevent;
    EYE_BLK.eyeevent.saccades.data = EYE.eyeevent.saccades.data( (tpts_start<=EYE.eyeevent.saccades.data(:,1)) & (EYE.eyeevent.saccades.data(:,1)<=tpts_end) );
    EYE_BLK.eyeevent.saccades.eye = EYE.eyeevent.saccades.eye( (tpts_start<=EYE.eyeevent.saccades.data(:,1)) & (EYE.eyeevent.saccades.data(:,1)<=tpts_end) );
    EYE_BLK.eyeevent.fixations.data = EYE.eyeevent.fixations.data( (tpts_start<=EYE.eyeevent.fixations.data(:,1)) & (EYE.eyeevent.fixations.data(:,1)<=tpts_end) );
    EYE_BLK.eyeevent.fixations.eye = EYE.eyeevent.fixations.eye( (tpts_start<=EYE.eyeevent.fixations.data(:,1)) & (EYE.eyeevent.fixations.data(:,1)<=tpts_end) );
    EYE_BLK.eyeevent.blinks.data = EYE.eyeevent.blinks.data( (tpts_start<=EYE.eyeevent.blinks.data(:,1)) & (EYE.eyeevent.blinks.data(:,1)<=tpts_end) );
    EYE_BLK.eyeevent.blinks.eye = EYE.eyeevent.blinks.eye( (tpts_start<=EYE.eyeevent.blinks.data(:,1)) & (EYE.eyeevent.blinks.data(:,1)<=tpts_end) );
    EYE_BLK.messages = EYE.messages(idx_msg_blk(1):idx_msg_blk(2));
    EYE_BLK.othermessages = [];
    for ii = 1:length(EYE.othermessages)
        if (tpts_start <= EYE.othermessages(ii).timestamp) && (EYE.othermessages(ii).timestamp <= tpts_end)
            EYE_BLK.othermessages = [EYE_BLK.othermessages, EYE.othermessages(ii)];
        end
    end
end

function [evt_eeg, evt_eye] = change_evt_type(evt_eeg, evt_eye, MK_EEG)
    evt_eeg.type(evt_eeg.type == MK_EEG.Rest) = 15;
    evt_eeg.type(evt_eeg.type == MK_EEG.Exp_Begin) = 0;
    evt_eeg.type(evt_eeg.type == MK_EEG.Exp_End) = 0;
    evt_eeg.type(evt_eeg.type == MK_EEG.Blk_Begin) = 12;
    evt_eeg.type(evt_eeg.type == MK_EEG.Blk_End) = 12;
    evt_eeg.type(evt_eeg.type == MK_EEG.Response_No) = -3;
    evt_eeg.type(evt_eeg.type == MK_EEG.Response_Wrong) = -2;
    evt_eeg.type(evt_eeg.type == MK_EEG.Response_Correct) = -1;
    evt_eeg.type(MK_EEG.SOA_C1<=evt_eeg.type & evt_eeg.type<=MK_EEG.SOA_C43) = 0.1;
    evt_eeg.type(MK_EEG.SOA_L1<=evt_eeg.type & evt_eeg.type<=MK_EEG.SOA_L43) = 0.1;
    evt_eeg.type(MK_EEG.SOA_R1<=evt_eeg.type & evt_eeg.type<=MK_EEG.SOA_R43) = 0.1;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target1) = 1;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target2) = 2;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target3) = 3;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target4) = 4;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target5) = 5;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target6) = 6;
    evt_eeg.type(evt_eeg.type == MK_EEG.Target7) = 7;
    evt_eeg.type(evt_eeg.type >100) = -10;

    if ~isempty(evt_eye)
        evt_eye.type(evt_eye.type == MK_EEG.Rest) = 15;
        evt_eye.type(evt_eye.type == MK_EEG.Exp_Begin) = 0;
        evt_eye.type(evt_eye.type == MK_EEG.Exp_End) = 0;
        evt_eye.type(evt_eye.type == MK_EEG.Blk_Begin) = 12;
        evt_eye.type(evt_eye.type == MK_EEG.Blk_End) = 12;
        evt_eye.type(evt_eye.type == MK_EEG.Response_No) = -3;
        evt_eye.type(evt_eye.type == MK_EEG.Response_Wrong) = -2;
        evt_eye.type(evt_eye.type == MK_EEG.Response_Correct) = -1;
        evt_eye.type(MK_EEG.SOA_C1<=evt_eye.type & evt_eye.type<=MK_EEG.SOA_C43) = 0.1;
        evt_eye.type(MK_EEG.SOA_L1<=evt_eye.type & evt_eye.type<=MK_EEG.SOA_L43) = 0.1;
        evt_eye.type(MK_EEG.SOA_R1<=evt_eye.type & evt_eye.type<=MK_EEG.SOA_R43) = 0.1;
        evt_eye.type(evt_eye.type == MK_EEG.Target1) = 1;
        evt_eye.type(evt_eye.type == MK_EEG.Target2) = 2;
        evt_eye.type(evt_eye.type == MK_EEG.Target3) = 3;
        evt_eye.type(evt_eye.type == MK_EEG.Target4) = 4;
        evt_eye.type(evt_eye.type == MK_EEG.Target5) = 5;
        evt_eye.type(evt_eye.type == MK_EEG.Target6) = 6;
        evt_eye.type(evt_eye.type == MK_EEG.Target7) = 7;
    end
    
end




