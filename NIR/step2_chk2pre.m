clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\3.chk\';
path_out_nir = 'E:\Data\202305\NIR\4.pre\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_NIR = 10;
NCH = 44;
CH_NO_INT = [18,24,33];

NIR_HPF = 0.01;
NIR_LPF = 0.2;
EN_CBSI = 1;

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3'; setpaths();

%% Main
blk_typ = 'tsk';
sta_all_blk_avg = zeros(NCH, NBLK, NSUB);
sta_all_blk_std = zeros(NCH, NBLK, NSUB);

for isub = 1:NSUB
    %% Check existence of file and load data
    [NIR_BLK, NIR_BAD] = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    end

    %% Check every block
    for iblk = 1:NBLK
        % Load EEG block
        NIR = NIR_BLK(iblk);

        %% Load data and Preprocess
        snirf = SnirfClass(NIR.d, NIR.t, NIR.SD, sum(NIR.aux*(1:8)',2), NIR.s);
        snirf.metaDataTags = MetaDataTagsClass();  % Generate default mdt
        dod = hmrR_Intensity2OD(snirf.data);
        %dod = hmrR_BandpassFilt(dod, NIR_HPF, NIR_LPF);
        dc = hmrR_OD2Conc(dod, snirf.probe, [1.0 1.0]);
        dc = hmrR_BandpassFilt(dc, NIR_HPF, NIR_LPF);
        dc = hmrR_MotionCorrectCbsi(dc, [], EN_CBSI);

        %% Get data and events
        [NIR_BLK_NEW(iblk).HbO, NIR_BLK_NEW(iblk).HbR, NIR_BLK_NEW(iblk).HbT] = get_all_data(dc, NCH, EN_CBSI);
        NIR_BLK_NEW(iblk).Evt = get_all_event(snirf);
    end

    %% Save data
    NIR_BLK = NIR_BLK_NEW;
    file_out_nir = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['NIR_' upper(blk_typ) ' = NIR_BLK;']);
    save([path_out_nir file_out_nir], ['NIR_' upper(blk_typ)], 'NIR_BAD', '-mat');
end



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


function evt_all = get_all_event(snirf)
    aux = snirf.GetAuxiliary();
    aux = aux.data;
    for ii = 1:size(aux,1)
        for jj = 1:size(aux,2)
            aux(ii,jj) = aux(ii,jj)*jj;
        end
    end
    evt_all = sum(aux,2);
end


function [dat_hbo, dat_hbr, dat_hbt] = get_all_data(dc, NCH, EN_CBSI)
    if EN_CBSI == 0
        dat_hbo = squeeze( dc.dataTimeSeries(:,(1:NCH)*3-2) );
        dat_hbr = squeeze( dc.dataTimeSeries(:,(1:NCH)*3-1) );
        dat_hbt = squeeze( dc.dataTimeSeries(:,(1:NCH)*3-0) );
    elseif EN_CBSI == 1
        dat_hbo = squeeze(dc.dataTimeSeries(:,1,:));
        dat_hbr = squeeze(dc.dataTimeSeries(:,2,:));
        dat_hbt = squeeze(dc.dataTimeSeries(:,3,:));
    end
end





