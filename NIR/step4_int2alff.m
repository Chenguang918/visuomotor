clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\5.int\';
path_out_nir = 'E:\Data\202305\NIR\6.alf\';

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

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3';
% setpaths();

%% Main
blk_typ = 'rst';
for isub = 1:NSUB
    % Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        tot_sALFF_r(isub,:,:) = NaN(NBLK, NCH);
        tot_fALFF_r(isub,:,:) = NaN(NBLK, NCH);
        continue;
    end

    % Check every block
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);

        [tot_sALFF_r(isub,iblk,:), tot_fALFF_r(isub,iblk,:)] = calc_nir_alff(FS_NIR, NCH, FRQ_HPF, FRQ_LPF, FRQ_APF, NIR.HbO);
    end
end
fprintf('Sub - Done.\r\n');

blk_typ = 'tsk';
for isub = 1:NSUB
    % Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        tot_sALFF_s(isub,:,:) = NaN(NBLK, NCH);
        tot_fALFF_s(isub,:,:) = NaN(NBLK, NCH);
        tot_sALFF_d(isub,:,:) = NaN(NBLK, NCH);
        tot_fALFF_d(isub,:,:) = NaN(NBLK, NCH);
        continue;
    end

    % Check every block
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);
        
        idx_evt = find(NIR.Evt>0);
        idx1 = idx_evt(NSTSK*2);
        idx2 = idx_evt(NSTSK*2+1);
        [tot_sALFF_s(isub,iblk,:), tot_fALFF_s(isub,iblk,:)] = calc_nir_alff(FS_NIR, NCH, FRQ_HPF, FRQ_LPF, FRQ_APF, NIR.HbO(1:idx1,:));
        [tot_sALFF_d(isub,iblk,:), tot_fALFF_d(isub,iblk,:)] = calc_nir_alff(FS_NIR, NCH, FRQ_HPF, FRQ_LPF, FRQ_APF, NIR.HbO(idx2:end,:));
    end
end
fprintf('Sub - Done.\r\n');


zs_fALFF_r = calc_alff_zscore(tot_fALFF_r);
zs_fALFF_s = calc_alff_zscore(tot_fALFF_s);
zs_fALFF_d = calc_alff_zscore(tot_fALFF_d);

% zs_fALFF_r = (tot_fALFF_r);
% zs_fALFF_s = (tot_fALFF_s);
% zs_fALFF_d = (tot_fALFF_d);

zs_fALFF_r([2 6 8 44],:,:) = [];
zs_fALFF_s([2 6 8 44],:,:) = [];
zs_fALFF_d([2 6 8 44],:,:) = [];

fALFF_REST = squeeze( mean(zs_fALFF_r,2,'omitnan'));
fALFF_SAME = squeeze( mean(zs_fALFF_s,2,'omitnan'));
fALFF_DIFF = squeeze( mean(zs_fALFF_d,2,'omitnan'));

save([path_out_nir 'fALFF.mat'], 'fALFF_REST', 'fALFF_SAME', 'fALFF_DIFF', '-mat');



zs_sALFF_r = calc_alff_zscore(tot_sALFF_r);
zs_sALFF_s = calc_alff_zscore(tot_sALFF_s);
zs_sALFF_d = calc_alff_zscore(tot_sALFF_d);

zs_sALFF_r([2 6 8 44],:,:) = [];
zs_sALFF_s([2 6 8 44],:,:) = [];
zs_sALFF_d([2 6 8 44],:,:) = [];

sALFF_REST = squeeze( mean(zs_sALFF_r,2,'omitnan'));
sALFF_SAME = squeeze( mean(zs_sALFF_s,2,'omitnan'));
sALFF_DIFF = squeeze( mean(zs_sALFF_d,2,'omitnan'));
save([path_out_nir 'sALFF.mat'], 'sALFF_REST', 'sALFF_SAME', 'sALFF_DIFF', '-mat');


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


function [sALFF, fALFF] = calc_nir_alff(FS, NCH, FRQ_HPF, FRQ_LPF, FRQ_APF, HbO)
    for ich = 1:NCH
        dat = HbO(:,ich);
        snan = sum(isnan(dat));
        if (sum(dat)~=0) && (snan==0)
            nt = length(dat);
            idx_hpf = round(FRQ_HPF/FS*nt)+1;
            idx_lpf = round(FRQ_LPF/FS*nt)+1;
            idx_apf = round(FRQ_APF/FS*nt)+1;
            dat = detrend(dat);
            dat = 2*abs(fft(dat))/sqrt(nt);
            sALFF(ich) = rms(dat(idx_hpf:idx_lpf));
            fALFF(ich) = sum(dat(idx_hpf:idx_lpf))/sum(dat(1:idx_apf));
        else
            sALFF(ich) = NaN;
            fALFF(ich) = NaN;
        end
    end
    nan_ch_s = isnan(sALFF);
    nan_ch_f = isnan(fALFF);
    if sum(nan_ch_s) + sum(nan_ch_f) > 8
        sALFF = nan(1,NCH);
        fALFF = nan(1,NCH);
    elseif sum(nan_ch_s) + sum(nan_ch_f) > 0
        sALFF(nan_ch_s) = mean(sALFF(~nan_ch_s));
        fALFF(nan_ch_s) = mean(fALFF(~nan_ch_s));
    end
end




function z_alff = calc_alff_zscore(tot_alff)
    for isub = 1:size(tot_alff,1)
        for iblk = 1:size(tot_alff,2)
            z_alff(isub,iblk,:) = zscore(tot_alff(isub,iblk,:));
        end
    end
end

