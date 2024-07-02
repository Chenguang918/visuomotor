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
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);
        idx_evt = find((NIR.Evt > 0) & (NIR.Evt < 7));
        idx_evt = idx_evt(1:2:end);
        evt_mtx = zeros(size(NIR.Evt,1),2);
        evt_mtx(idx_evt(1:NSTSK),1) = 1;
        evt_mtx(idx_evt(NSTSK+1:end),2) = 1;
        X = design_matrix(evt_mtx , HRF);
        for ich = 1:NCH
            y = NIR.HbO(:,ich);
            if sum(isnan(y)) == 0
                y = bpf(y, FRQ_APF, FRQ_HPF, FS_NIR);
                X = bpf(X, FRQ_APF, FRQ_HPF, FS_NIR);
                [b,dev,stats] = glmfit(X, y);
                BETA_SAME(ich, iblk, tot_sub) = b(2);
                BETA_DIFF(ich, iblk, tot_sub) = b(3);
            else
                BETA_SAME(ich, iblk, tot_sub) = NaN;
                BETA_DIFF(ich, iblk, tot_sub) = NaN;
                fprintf('\t -blk %d -ch %d', iblk, ich);
            end
        end

    end
    fprintf('\r\n');
end
fprintf('Sub - Done.\r\n');

glm_SAME = squeeze(mean(BETA_SAME,2,'omitnan'));
glm_DIFF = squeeze(mean(BETA_DIFF,2,'omitnan'));
save([path_out_nir 'glm.mat'], 'glm_SAME', 'glm_DIFF', '-mat');


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





