clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\5.int\';
path_out_nir = 'E:\Data\202305\NIR\6.psd\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_NIR = 10;
NCH = 44;
NFFT = 200;
NSTSK = 43;     % number of trials - same task (simple)
NDTSK = 129;    % number of trials - diff task (search)
NATSK = 172;    % number of trials - all task

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3';
% setpaths();

%% Main
blk_typ = 'rst';
for isub = 1:NSUB
    %% Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    end

    %% Check every block
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);

        psd_r(:,:,iblk,isub) = clac_nir_psd(NFFT, NCH, NIR.HbR);
    end
end
fprintf('Sub - Done.\r\n');

blk_typ = 'tsk';
for isub = 1:NSUB
    %% Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    end

    %% Check every block
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);
        
        idx_evt = find(NIR.Evt>0);
        idx1 = idx_evt(NSTSK*2);
        idx2 = idx_evt(NSTSK*2+1);
        psd_s(:,:,iblk,isub) = clac_nir_psd(NFFT, NCH, NIR.HbR(1:idx1,:));
        psd_d(:,:,iblk,isub) = clac_nir_psd(NFFT, NCH, NIR.HbR(idx2:end,:));
    end
end
fprintf('Sub - Done.\r\n');

%save('psd_all', 'psd_all_r', 'psd_all_s', 'psd_all_d');

psd_all_r = remove_bad_psd(NCH, NBLK, NSUB, psd_r);
psd_all_s = remove_bad_psd(NCH, NBLK, NSUB, psd_s);
psd_all_d = remove_bad_psd(NCH, NBLK, NSUB, psd_d);

psd_avg_s = rms(psd_s,3);
psd_avg_d = rms(psd_d,3);
psd_avg_r = rms(psd_r,3);

fx = (1:(NFFT/2))/(NFFT/2)*5;
for ich = 1:NCH
    subplot(5,9,ich);
    loglog(fx, (psd_avg_r(:,ich)),'r'); hold on;
    loglog(fx, (psd_avg_s(:,ich)),'g'); hold on;
    loglog(fx, (psd_avg_d(:,ich)),'b'); hold on;
end

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


function psd = clac_nir_psd(NFFT, NCH, HbO)
    N = size(HbO,1);
    for ich = 1:NCH
        psd(:,ich) = abs(fft(HbO(:,ich),NFFT));
    end
    psd = psd(1:NFFT/2,:);
end


function psd_all = remove_bad_psd(NCH, NBLK, NSUB, psd)
    psd_all = [];
    n = 0;
    for ich = 1:NCH
        for iblk = 1:NBLK
            for isub = 1:NSUB
                tmp = squeeze(psd(:,ich,iblk,isub));
                t = sum(isnan(tmp));
                if (sum(tmp)~=0) && (t==0)
                    n = n + 1;
                    psd_all(:,ich,n) = tmp;
                end
            end
        end
    end
end
