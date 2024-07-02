clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\2.blk\';
path_out_eye = 'E:\Data\202305\EYE\3.fix\';

%% Parameter
NSUB = 50;
NBLK = 6;

%% Main
blk_typ = 'tsk';

for isub = 1:NSUB
    %% Check existence of file and load data
    EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ);
    if isempty(EYE_BLK)
        continue;
    end

    %% Remove dup sample time
    for iblk = 1:NBLK
        EYE = EYE_BLK(iblk);
        dup_tpts = find( diff(EYE.data(:,1)) == 0 );
        EYE.data(dup_tpts,:) = [];
        EYE_BLK(iblk) = EYE;
    end

    %% Save data
    file_out_eye = ['sub' num2str(isub) '_' lower(blk_typ) '.mat'];
    eval(['EYE_' upper(blk_typ) ' = EYE_BLK;']);
    save([path_out_eye file_out_eye], ['EYE_' upper(blk_typ)], '-mat');
end

%% Check existence of file and load data
function EYE_BLK = check_and_get_data(isub, path_in_eye, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eye = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eye '\' file_in_eye],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EYE_BLK = [];
    else
        load([path_in_eye file_in_eye]);
        eval(['EYE_BLK = EYE_' upper(blk_typ) ';']);
    end
end


