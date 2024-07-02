clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\4.pre\';
path_out_nir = 'E:\Data\202305\NIR\5.int\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_NIR = 10;
NCH = 44;

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3';
% setpaths();

%% Main
load('CH_INT_MAP');
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    end

    %% Interpolation bad channels
    for iblk = 1:NBLK
        % Read NIR block
        NIR = NIR_BLK(iblk);

        for ich = 1:NCH
            if NIR_BAD(ich,iblk) == 1
                NIR = int_nir_ch(CH_INT_MAP, NIR, find(NIR_BAD(:,iblk) == 1), ich);
            end
        end

        %% Write NIR block
        NIR_BLK(iblk) = NIR;
    end

    %% Save data
    file_out_nir = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['NIR_' upper(blk_typ) ' = NIR_BLK;']);
    save([path_out_nir file_out_nir], ['NIR_' upper(blk_typ)], 'NIR_BAD', '-mat');
end
fprintf('All Done.\r\n');


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

function NIR = int_nir_ch(CH_INT_MAP, NIR, bad_ch, ich)
    all_nan = nan(size(NIR.HbO,1),1);
    idx = ~ismember(CH_INT_MAP{ich}, bad_ch);
    int_ch = CH_INT_MAP{ich}(idx);
    if isempty(int_ch)
        NIR.HbO(:,ich) = all_nan;
        NIR.HbR(:,ich) = all_nan;
        NIR.HbT(:,ich) = all_nan;
    else
        NIR.HbO(:,ich) = mean(NIR.HbO(:,int_ch),2);
        NIR.HbR(:,ich) = mean(NIR.HbR(:,int_ch),2);
        NIR.HbT(:,ich) = mean(NIR.HbT(:,int_ch),2);
    end
end











