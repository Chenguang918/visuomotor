clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\5.int\';
path_out_nir = 'E:\Data\202305\NIR\6.glm\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_NIR = 10;
NCH = 44;
FRQ_HPF = 0.01;
FRQ_LPF = 0.1;
FRQ_APF = 0.2;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task

HRF = HRF_STD(FS_NIR, [6 16 1 1 6 0 30]); TX = (1:length(HRF))/FS_NIR;

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3';
% setpaths();

%% Main
blk_typ = 'tsk';
tot_sub = 0;
for isub = 1:NSUB
    % Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    else
        tot_sub = tot_sub + 1;
    end

    % Check every block
    cnt_L = 1;
    cnt_R = 1;
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);
        idx_evt = find((0 < NIR.Evt) & (NIR.Evt < 7));
        idx_evt = idx_evt(1:2:end);
        idx_evt_SAME = idx_evt(1:NSTSK);
        idx_evt_DIFF = idx_evt(NSTSK+1:end);
        typ_evt = NIR.Evt(idx_evt);

        idx_evt_L = idx_evt((1<=typ_evt) & (typ_evt<=3));
        idx_evt_R = idx_evt((4<=typ_evt) & (typ_evt<=6));

        idx_evt_SAME_L = intersect(idx_evt_SAME, idx_evt_L);
        idx_evt_SAME_R = intersect(idx_evt_SAME, idx_evt_R);
        idx_evt_DIFF_L = intersect(idx_evt_DIFF, idx_evt_L);
        idx_evt_DIFF_R = intersect(idx_evt_DIFF, idx_evt_R);
        if length(idx_evt_SAME_L) > length(idx_evt_SAME_R)
            is_evt_L = 1;
        else
            is_evt_L = 0;
        end
        
        evt_mtx = zeros(size(NIR.Evt,1),3);
        if is_evt_L
            evt_mtx(idx_evt_SAME_L, 1) = 1;
        else
            evt_mtx(idx_evt_SAME_R, 1) = 1;
        end
        evt_mtx(idx_evt_DIFF_L, 2) = 1;
        evt_mtx(idx_evt_DIFF_R, 3) = 1;

        X = design_matrix(evt_mtx , HRF);
        X = bpf(X, FRQ_APF, FRQ_HPF, FS_NIR);
        for ich = 1:NCH
            y = NIR.HbO(:,ich);
            if sum(isnan(y)) == 0
                y = bpf(y, FRQ_APF, FRQ_HPF, FS_NIR);
                [b,dev,stats] = glmfit(X, y);
                if is_evt_L
                    BETA_SAME_L(cnt_L, tot_sub, ich) = b(2);
                else
                    BETA_SAME_R(cnt_R, tot_sub, ich) = b(2);
                end
                BETA_DIFF_L(iblk, tot_sub, ich) = b(3);
                BETA_DIFF_R(iblk, tot_sub, ich) = b(4);
            else
                if is_evt_L
                    BETA_SAME_L(cnt_L, tot_sub, ich) = NaN;
                else
                    BETA_SAME_R(cnt_R, tot_sub, ich) = NaN;
                end
                BETA_DIFF_L(iblk, tot_sub, ich) = NaN;
                BETA_DIFF_R(iblk, tot_sub, ich) = NaN;
                fprintf('\t -blk %d -ch %d', iblk, ich);
            end
        end

        if is_evt_L
            cnt_L = cnt_L + 1;
        else
            cnt_R = cnt_R + 1;
        end
    end
    fprintf('\r\n');
end
fprintf('Sub - Done.\r\n');

save([path_out_nir 'glm.mat'], 'BETA_SAME_L', 'BETA_SAME_R', 'BETA_DIFF_L', 'BETA_DIFF_R', '-mat');


fprintf('Finish.\r\n');

%% Check existence of file and load data
function [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_nir = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_nir '\' file_in_nir],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        NIR_BLK = [];
        NIR_BAD = [];
    else
        load([path_in_nir file_in_nir]);
        eval(['NIR_BLK = NIR_' upper(blk_typ) ';']);
    end
end


%% Functions
function X = design_matrix(evt_mtx, BSFUN)
    X = [];
    ntps = size(evt_mtx,1);
    for ii = 1:size(evt_mtx,2)
        for jj = 1:size(BSFUN,2)
            X = [X, conv(evt_mtx(:,ii), BSFUN(:,jj))];
        end
    end
    X = X(1:ntps,:);
end

function X = bpf(X, LPF, HPF, FS)
    % low pass filter
    lpf_norm = LPF / (FS / 2);
    if lpf_norm > 0  % No lowpass if filter is 
        FilterOrder = 3;
        [z, p, k] = butter(FilterOrder, lpf_norm, 'low');
        [sos, g] = zp2sos(z, p, k);
        X = filtfilt(sos, g, double(X)); 
    end
    
    % high pass filter
    hpf_norm = HPF / (FS / 2);
    if hpf_norm > 0
        FilterOrder = 5;
        [z, p, k] = butter(FilterOrder, hpf_norm, 'high');
        [sos, g] = zp2sos(z, p, k);
        X = filtfilt(sos, g, X);
    end
    
   % X = [X, ones(ntps,1)];
end





