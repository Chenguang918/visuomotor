clc;clear;close all;

%% File path and name
path_in_rme = 'E:\Data\202305\EEG\7.rme\';
path_in_seg = 'E:\Data\202305\EEG\8.seg\';
path_out_eeg = 'E:\Data\202305\EEG\9.erp\';

%% Parameter
NSUB = 50;
NTAG = 6;
NBLK = 6;
FS_EEG = 500;
NCH = 32;
TW_RANGE = [-0.2 1.2];
TW_BASE = [-0.2 0];
ATH_HI = [-100 100];
ATH_LO = 2;
TSK_NAME = ['S','D'];
load('..\INF\MK_EEG.mat');
load('..\INF\EEG_LOC.mat');
CH_IND = [1:17 19:23 25:32];

IDX_BASE = 1 : round(-FS_EEG * TW_RANGE(1));
XT_ERP = TW_RANGE(1):1/FS_EEG:(TW_RANGE(2)-1/FS_EEG);
% 
% %% Main
% blk_typ = 'tsk';
% tot_sub = 0;
% for isub = 9:NSUB
%     % Check existence of file and load data
%     EEG_EPOCH = check_and_get_data_seg(isub, path_in_seg);
%     [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_rme, blk_typ);
%     if isempty(EEG_EPOCH)
%         continue;
%     end
% 
%     tot_sub = tot_sub + 1;
%     for itsk = 1:2
%         for itag = 1:NTAG
%             dat = EEG_EPOCH.([TSK_NAME(itsk) num2str(itag)]);
%             for ich = CH_IND
%                 tmp = squeeze(dat(ich,:,:));
%                 tmp = tmp - mean(tmp(IDX_BASE,:),1);
%                 max_trl = max(tmp,[],1);
%                 min_trl = min(tmp,[],1);
%                 idx_vld = (min_trl>ATH_HI(1)) & (max_trl<ATH_HI(2) & ((max_trl-min_trl)>ATH_LO));
%                 if ~((length(idx_vld) == 43) || (length(idx_vld) == 129)) || (sum(idx_vld)==0)
%                     fprintf('\r\n Err \t%d \t%d \t%d', itsk, itag, ich);
%                     erp =  zeros(size(tmp,1),1);
%                     ERP(:,ich,itsk,itag,tot_sub) = erp;
%                 else
%                     erp =  mean(tmp(:,idx_vld),2);
%                     ERP(:,ich,itsk,itag,tot_sub) = erp;
%                 end
%             end
%         end
%     end
%     fprintf('\r\n');
% end
% save([path_out_eeg 'ERP.mat' ], 'ERP','-mat');


load([path_out_eeg 'ERP.mat']); % 700    32     2     6    48
view_cda(XT_ERP, ERP);
view_erp_all(CH_IND, EEG_LOC, XT_ERP, ERP);



%z = squeeze(mean(ERP,4));


%% Done
load gong.mat;
sound(y);

%% Check existence of file and load data
function [EEG_BLK, EEG_BAD] = check_and_get_data(isub, path_in_eeg, blk_typ)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['sub' num2str(isub) '_' lower(blk_typ) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_BLK = [];
        EEG_BAD = [];
    else
        load([path_in_eeg file_in_eeg]);
        eval(['EEG_BLK = EEG_' upper(blk_typ) ';']);
    end
end


%% Check existence of file and load data
function EEG_EPOCH = check_and_get_data_seg(isub, path_in_eeg)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['EEG_EPOCH_' num2str(isub) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_EPOCH = [];
    else
        load([path_in_eeg file_in_eeg]);
    end
end

%%
function ax = set_axes(fig, EEG_LOC, ich)
    col_ch = EEG_LOC.COL(ich);
    row_ch = EEG_LOC.ROW(ich);
    dr_x = (col_ch-1)/max(EEG_LOC.COL);
    dr_y = 1-(row_ch)/max(EEG_LOC.ROW);
    dr_y = dr_y * 0.99;
    ax = axes(fig,'Position',[dr_x+0.01 dr_y+0.02 0.18 0.11]);
end


function view_erp_all(CH_IND, EEG_LOC, XT_ERP, ERP) % 700    32     2     6    48
    fig = figure;
    ERP = squeeze(mean(ERP,4));
    for ich = 1:length(CH_IND)
        ax = set_axes(fig, EEG_LOC, ich);

        dat_tmp = [];
        dat_avg = [];
        for tsk = 1:2
            dat_tmp(:,:,tsk) = squeeze(ERP(:,CH_IND(ich),tsk,:));
            dat_avg(:,tsk) = mean(dat_tmp(:,:,tsk),2);
            dat_std(:,tsk) = std(squeeze(dat_tmp(:,:,tsk))')';
        end
        h1 = ttest(dat_tmp(:,:,1)');
        h2 = ttest(dat_tmp(:,:,2)');
        h3 = ttest(dat_tmp(:,:,1)', dat_tmp(:,:,2)');

        plot(XT_ERP, dat_avg(:,1), '-b'); hold on;
        plot(XT_ERP, dat_avg(:,2), '-r'); hold on;
        plot(XT_ERP, 1000*(h1-1)+7, '.b'); hold on;
        plot(XT_ERP, 1000*(h2-1)+8, '.r'); hold on;
        plot(XT_ERP, 1000*(h3-1)+9, '.k'); hold on;

%         plot(XT_ERP, dat_avg(:,1)+dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,1)-dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,2)+dat_std(:,2), '.r'); hold on;
%         plot(XT_ERP, dat_avg(:,2)-dat_std(:,2), '.r'); hold on;

        xlim([min(XT_ERP) max(XT_ERP)]);
        ylim([-10 10]);

        title(['ch ' num2str(CH_IND(ich))]);
    end

end


function view_cda(XT_ERP, ERP) % 700    32     2     6    48
    ICH_P7 = [25 26];
    ICH_P8 = [29 28];
    
    fig = figure;
    ERP_CON = mean(ERP(:,ICH_P7,:,1:3,:) + ERP(:,ICH_P8,:,4:6,:),2)/2;
    ERP_IPS = mean(ERP(:,ICH_P7,:,4:6,:) + ERP(:,ICH_P8,:,1:3,:),2)/2;
    ERP_CON_avg = squeeze(mean(ERP_CON,4));
    ERP_IPS_avg = squeeze(mean(ERP_IPS,4));
    ERP_CDA = ERP_CON_avg - ERP_IPS_avg;

    for itsk = 1:2
        dat_tmp = squeeze(ERP_CDA(:,itsk,:));
        dat_avg(:,itsk) = mean(dat_tmp,2);
        dat_std(:,itsk) = std(dat_tmp')';
    end
    plot(XT_ERP, dat_avg(:,1), '-b'); hold on;
    plot(XT_ERP, dat_avg(:,2), '-r'); hold on;

    h1 = ttest(squeeze(ERP_CDA(:,1,:))');
    h2 = ttest(squeeze(ERP_CDA(:,2,:))');
    h3 = ttest(squeeze(ERP_CDA(:,1,:))',squeeze(ERP_CDA(:,2,:))');
    plot(XT_ERP, 1000*(h1-1)+1.7, '.b'); hold on;
    plot(XT_ERP, 1000*(h2-1)+1.8, '.r'); hold on;
    plot(XT_ERP, 1000*(h3-1)+1.9, '.k'); hold on;
    
    xlim([min(XT_ERP) max(XT_ERP)]);
    ylim([-2 2]);

    title('CDA');
end

