clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\2.blk\';
path_out_beh = 'E:\Data\202305\BEH\3.cal\';

%% Parameter
NSUB = 50;
NBLK = 6;
NTAG = 6;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task
W_XY = 65536;
TH.THETA_BAD = [-15 15];
TH.THETA_MISSING = [-10 10];
TH.THETA_ACCHIT = [-0.5 0.5];
TH.RT_START = [0.21 2.2];
TH.RT_END = [0.002 2.19];
TH.POS_DIST = 500;

%% Main
blk_typ = 'tsk';
for isub = 1:NSUB
    %% Check existence of file and load data
    BEH_BLK = check_and_get_data(isub, path_in_beh, 'BEH', blk_typ);
    if isempty(BEH_BLK)
        continue;
    end

    BEH_BLK = calc_beh_pos_dist_theta(NBLK, W_XY, BEH_BLK);
    theta_avg = get_avg_theta(NTAG, NBLK, TH, BEH_BLK);
    BEH_BLK = calc_beh_dtheta(NBLK, BEH_BLK, theta_avg);
    BEH_BLK = calc_beh_acc(NBLK, BEH_BLK, TH);
    BEH = get_beh_data(BEH_BLK);

    file_out_beh = ['sub' num2str(isub) '.mat'];
    save([path_out_beh file_out_beh], 'BEH', '-mat');
end

fprintf('\r\n  All sub done.\r\n');


%% Check existence of file and load data
function BEH_BLK = check_and_get_data(isub, path_in, dat_typ, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in '\' file_in],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        BEH_BLK = [];
    else
        load([path_in file_in]);
        eval([dat_typ '_BLK = ' dat_typ '_' upper(blk_typ) ';']);
    end
end


function BEH = trs_beh_RT(BEH)
    BEH.RT_Start = BEH.RT_Start';
    BEH.RT_Duration = BEH.RT_Duration';
    BEH.RT_End = BEH.RT_End';
end


function BEH_BLK = calc_beh_pos_dist_theta(NBLK, W_XY, BEH_BLK)
    for iblk = 1:NBLK
        BEH_BLK(iblk).Pos_X = BEH_BLK(iblk).Pos_X-W_XY/2;
        BEH_BLK(iblk).Pos_Y = -(BEH_BLK(iblk).Pos_Y-W_XY/2);
        BEH_BLK(iblk).Dist = sqrt((BEH_BLK(iblk).Pos_X).^2 + (BEH_BLK(iblk).Pos_Y).^2);
        BEH_BLK(iblk).Theta = atan2d(BEH_BLK(iblk).Pos_Y, BEH_BLK(iblk).Pos_X);
    end
end



function dat = round360(dat)
    dat(dat<-180) = dat(dat<-180) + 360;
    dat(dat>180) = dat(dat>180) - 360;
end

function theta_avg = get_avg_theta(NTAG, NBLK, TH, BEH_BLK)
    r = [45 0 -45 -135 -180 135];
    for itag = 1:NTAG
        tmp = [];
        for iblk = 1:NBLK
            idx = (BEH_BLK(iblk).Orit_Type==itag);
            tmp = [tmp ; BEH_BLK(iblk).Theta(idx)];
        end
        theta_all = tmp - r(itag);
        theta_all = round360(theta_all);
        theta_test = theta_all - mean(theta_all);
        idx_vld = ((theta_test>TH.THETA_BAD(1)) & (theta_test<TH.THETA_BAD(2)));
        theta_avg(itag) = mean(theta_all(idx_vld)) + r(itag);
    end
end

function BEH_BLK = calc_beh_dtheta(NBLK, BEH_BLK, theta_avg)
    for iblk = 1:NBLK
        for itrl = 1:length(BEH_BLK(iblk).Orit_Type)
            avg_trl(itrl,1) = theta_avg(BEH_BLK(iblk).Orit_Type(itrl));
        end
        BEH_BLK(iblk).tTheta = avg_trl;
        BEH_BLK(iblk).dTheta = BEH_BLK(iblk).Theta - avg_trl;
        BEH_BLK(iblk).dTheta = round360(BEH_BLK(iblk).dTheta);
    end
end


% TH.THETA_BAD = [-15 15];
% TH.THETA_MISSING = [-10 10];
% TH.THETA_ACCHIT = [-0.5 0.5];
% TH.RT_START = [0.21 2.2];
% TH.RT_END = [0.002 2.19];
% TH.MOV_DIST = 500;

function BEH_BLK = calc_beh_acc(NBLK, BEH_BLK, TH)
    for iblk = 1:NBLK
        ACC = ones(length(BEH_BLK(iblk).dTheta),1)*2; % Accurate hit
        ACC((BEH_BLK(iblk).dTheta<TH.THETA_ACCHIT(1)) | (BEH_BLK(iblk).dTheta>TH.THETA_ACCHIT(2))) = 1; % Normal Accuracy
        ACC((BEH_BLK(iblk).dTheta<TH.THETA_MISSING(1)) | (BEH_BLK(iblk).dTheta>TH.THETA_MISSING(2))) = 0; % Excessive angular deviation
        ACC( (sqrt((BEH_BLK(iblk).Pos_X).^2 + (BEH_BLK(iblk).Pos_Y).^2) < TH.POS_DIST) ) = 0; % Excessive distance deviation
        ACC((BEH_BLK(iblk).RT_Start<TH.RT_START(1)) | (BEH_BLK(iblk).RT_Start>TH.RT_START(2))) = -1; % Time out
        ACC((BEH_BLK(iblk).RT_End<TH.RT_END(1)) | (BEH_BLK(iblk).RT_End>TH.RT_END(2))) = -1; % Time out
        BEH_BLK(iblk).ACC = ACC;
    end
end


function BEH = get_beh_data(BEH_BLK)
    for iblk = 1:size(BEH_BLK,2)
        for itrl = 1:size(BEH_BLK(iblk).SOA,1)
            BEH(itrl,iblk).Tag = BEH_BLK(1,iblk).Orit_Type(itrl);
            BEH(itrl,iblk).Soa = BEH_BLK(1,iblk).SOA(itrl);
            BEH(itrl,iblk).Rt1 = BEH_BLK(1,iblk).RT_Start(itrl);
            BEH(itrl,iblk).Rt2 = BEH_BLK(1,iblk).RT_Duration(itrl);
            BEH(itrl,iblk).Rt3 = BEH_BLK(1,iblk).RT_End(itrl);
            BEH(itrl,iblk).MvX = BEH_BLK(1,iblk).Pos_X(itrl);
            BEH(itrl,iblk).MvY = BEH_BLK(1,iblk).Pos_Y(itrl);
            BEH(itrl,iblk).Dst = BEH_BLK(1,iblk).Dist(itrl);
            BEH(itrl,iblk).The = BEH_BLK(1,iblk).Theta(itrl);
            BEH(itrl,iblk).dTh = BEH_BLK(1,iblk).dTheta(itrl);
            BEH(itrl,iblk).tTh = BEH_BLK(1,iblk).tTheta(itrl);
            BEH(itrl,iblk).Acc = BEH_BLK(1,iblk).ACC(itrl);
        end
    end
end


