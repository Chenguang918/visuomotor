clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\3.cal\';
path_out_beh = 'E:\Data\202305\BEH\4.tst\';

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
SCORE_DELTA = max(TH.THETA_MISSING)/3;

%% Main
tot_sub = 0;
TH_RG = 30;
TH_SD = 3;
WTH = -TH_RG-(TH_SD/2):TH_SD:TH_RG+(TH_SD/2);
x_th = -TH_RG:TH_SD:TH_RG;

for isub = 1:NSUB
    %% Check existence of file and load data
    BEH = check_and_get_data(isub, path_in_beh);
    if isempty(BEH)
        continue;
    end

    tot_sub = tot_sub + 1;
    DTH_SAME_ACC(tot_sub,:) = get_dtheta_acc(BEH(1:NSTSK,:), WTH);
    DTH_DIFF_ACC(tot_sub,:) = get_dtheta_acc(BEH(1+NSTSK:NATSK,:), WTH);
    DTH_SAME_RAW(tot_sub,:) = get_dtheta_raw(BEH(1:NSTSK,:), WTH);
    DTH_DIFF_RAW(tot_sub,:) = get_dtheta_raw(BEH(1+NSTSK:NATSK,:), WTH);


    THE_EASY_ACC{tot_sub} = get_theta_acc(BEH(1:NSTSK,:));
    THE_HARD_ACC{tot_sub} = get_theta_acc(BEH(1+NSTSK:NATSK,:));
    THE_EASY_RAW{tot_sub} = get_theta_raw(BEH(1:NSTSK,:));
    THE_HARD_RAW{tot_sub} = get_theta_raw(BEH(1+NSTSK:NATSK,:));
end

save([path_out_beh 'dth4fig.mat'],'DTH_SAME_ACC','DTH_DIFF_ACC','DTH_SAME_RAW','DTH_DIFF_RAW','x_th','-mat');
save([path_out_beh 'the4tst.mat'],'THE_EASY_ACC','THE_HARD_ACC','THE_EASY_RAW','THE_HARD_RAW','-mat');

fprintf('\r\n  All sub done.\r\n');

%% Check existence of file and load data
function BEH = check_and_get_data(isub, path_in)
    fprintf('[Sub %d] : ', isub);
    file_in = ['sub' num2str(isub) '.mat' ];
    if ~exist([path_in '\' file_in],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        BEH = [];
    else
        load([path_in file_in]);
    end
end


function sta = get_dtheta_acc(BEH, WTH)
    dth = [];
    for iblk = 1:size(BEH,2)
        for itrl = 1:size(BEH,1)
            if (BEH(itrl,iblk).Acc>0)
                dth = [dth; (BEH(itrl,iblk).dTh)];
            end
        end
    end
    for ii = 1:length(WTH)-1
        sta(ii) = sum( (WTH(ii)<dth) & (dth<=WTH(ii+1)) );
    end
    sta = sta./(length(dth));
end

function sta = get_dtheta_raw(BEH, WTH)
    dth = [];
    for iblk = 1:size(BEH,2)
        for itrl = 1:size(BEH,1)
            dth = [dth; (BEH(itrl,iblk).dTh)];
        end
    end
    for ii = 1:length(WTH)-1
        sta(ii) = sum( (WTH(ii)<dth) & (dth<=WTH(ii+1)) );
    end
    sta = sta./(length(dth));
end


function man_tag = get_theta_acc(BEH)
    man_tag = [];
    for iblk = 1:size(BEH,2)
        for itrl = 1:size(BEH,1)
            if (BEH(itrl,iblk).Acc>0)
                man_tag = [man_tag; [BEH(itrl,iblk).The BEH(itrl,iblk).tTh]];
            end
        end
    end
end


function man_tag = get_theta_raw(BEH)
    man_tag = [];
    for iblk = 1:size(BEH,2)
        for itrl = 1:size(BEH,1)
            man_tag = [man_tag; [BEH(itrl,iblk).The BEH(itrl,iblk).tTh]];
        end
    end
end


