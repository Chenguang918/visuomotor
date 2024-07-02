clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\2.blk\';
path_out_nir = 'E:\Data\202305\NIR\3.chk\';

%% Parameter
NSUB = 50;
NBLK = 6;
FS_NIR = 10;
NCH = 44;
CH_NO_INT = [18,24,33];

TH_STD.L = 0.05;
TH_STD.H = 1;

%% Set Homer3 paths
% cd 'D:\Matlab\Toolbox\Homer3';
% setpaths();

%% Main
blk_typ = 'tsk';
sta_all_blk_avg = zeros(NCH, NBLK, NSUB);
sta_all_blk_std = zeros(NCH, NBLK, NSUB);

for isub = 1:NSUB
    %% Check existence of file and load data
    NIR_BLK = check_and_get_data(isub, path_in_nir, blk_typ);
    if isempty(NIR_BLK)
        continue;
    end

    %% Check every block
    NIR_BAD = [];
    %EEG_BLK_new = struct(EEG_BLK);
    for iblk = 1:NBLK
        % Load EEG block
        NIR = NIR_BLK(iblk);
    
        % Check 1 - [raw] Mark Negative & Inf. & NaN. Channels
        bad_ch_isn = find_nir_zero_inf(NCH, NIR.d);
        
        % Check 2 - [raw] Mark Abnormal Coefficient of variation Channels
        bad_ch_acv = find_nir_abnormal_cv(NCH, TH_STD, NIR.d);

        % Fill bad channels with numb data
        bad_ch = zeros(NCH,1);
        bad_ch(union(bad_ch_isn, bad_ch_acv)) = 1;
        NIR.d(:,find(bad_ch>0)) = 1;

        NIR_BAD = [NIR_BAD, bad_ch];
    end

    %% Save data
    file_out_nir = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['NIR_' upper(blk_typ) ' = NIR_BLK;']);
    save([path_out_nir file_out_nir], ['NIR_' upper(blk_typ)], 'NIR_BAD', '-mat');
end



%% Check existence of file and load data
function NIR_BLK = check_and_get_data(isub, path_in_nir, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_nir = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_nir '\' file_in_nir],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        NIR_BLK = [];
    else
        load([path_in_nir file_in_nir]);
        eval(['NIR_BLK = NIR_' upper(blk_typ) ';']);
    end
end


function bad_ch = find_nir_zero_inf(NCH, d)
    bad_ch = [];
    for ich = 1:NCH
        is_neg = isempty(find(d(:,ich) <= 0, 1));
        is_inf = isempty(find(isinf(d(:,ich)), 1));
        is_nan = isempty(find(isnan(d(:,ich)), 1));
        if ~(is_neg && is_inf && is_nan)
            bad_ch = [bad_ch, ich];
        end
    end
end


function bad_ch = find_nir_abnormal_cv(NCH, TH_STD, d)
    bad_ch = [];
    for ich = 1:NCH
        avg_700 = mean(d(:,ich));
        std_700 = std(d(:,ich));
        avg_830 = mean(d(:,ich+NCH));
        std_830 = std(d(:,ich+NCH));
        cv = abs(std_700/avg_700) + abs(std_830/avg_830);
        if ((cv<TH_STD.L) || (cv>TH_STD.H))
            bad_ch = [bad_ch, ich];
        end
    end
end




