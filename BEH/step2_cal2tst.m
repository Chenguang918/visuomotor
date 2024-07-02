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
for isub = 1:NSUB
    %% Check existence of file and load data
    BEH = check_and_get_data(isub, path_in_beh);
    if isempty(BEH)
        continue;
    end

    tot_sub = tot_sub + 1;
    AVG_SAME(tot_sub,:) = avg_beh(BEH(1:NSTSK,:), SCORE_DELTA);
    AVG_DIFF(tot_sub,:) = avg_beh(BEH(1+NSTSK:NATSK,:), SCORE_DELTA);

end

save([path_out_beh 'tst.mat'],'AVG_SAME','AVG_DIFF','-mat');

for ii = 1:6
    [h(ii), p(ii)] = ttest(AVG_SAME(:,ii),AVG_DIFF(:,ii));
end
z_avg(1,:) = mean(AVG_SAME,1);
z_avg(2,:) = mean(AVG_DIFF,1);
z_std(1,:) = std(AVG_SAME,0,1);
z_std(2,:) = std(AVG_DIFF,0,1);


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

function avg = avg_beh(BEH, SCORE_DELTA)
    tot_hit = 0;
    rt1 = [];
    rt2 = [];
    rt3 = [];
    dst = [];
    dth = [];
    sco = [];
    for iblk = 1:size(BEH,2)
        for itrl = 1:size(BEH,1)
            if (BEH(itrl,iblk).Acc>0)
                tot_hit = tot_hit + 1;
                rt1 = [rt1 ; BEH(itrl,iblk).Rt1];
                rt2 = [rt2 ; BEH(itrl,iblk).Rt2];
                rt3 = [rt3 ; BEH(itrl,iblk).Rt3];
                dst = [dst ; BEH(itrl,iblk).Dst];
                delta_theta = abs(BEH(itrl,iblk).dTh);
                dth = [dth ; delta_theta];
                sco = [sco ; exp(-(delta_theta^2)./(2*SCORE_DELTA*SCORE_DELTA))];
            end
        end
    end
    avg_rt1 = mean(rt1);
    avg_rt2 = mean(rt2);
    avg_rt3 = mean(rt3);
    avg_dst = mean(dst);
    avg_dth = mean(dth);
    avg_sco = mean(sco);
    avg = [avg_rt1, avg_rt2, avg_rt3, avg_dst, avg_dth, avg_sco];
end
