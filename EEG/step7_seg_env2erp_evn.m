clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\8.seg_env\';
path_out_eeg = 'E:\Data\202305\EEG\9.erp_env\';

%% Parameter
NSUB = 50;
NTAG = 6;
NBLK = 6;
FS_EEG = 500;
NCH = 32;
TW_RANGE = [-0.2 1.4];
TW_BASE = [-0.2 0];
ATH_HI = [-100 100];
ATH_LO = 2;
TSK_NAME = ['S','D'];
load('..\INF\MK_EEG.mat');
load('..\INF\EEG_LOC.mat');
CH_IND = [1:17 19:23 25:32];

IDX_BASE = 1 : round(-FS_EEG * TW_RANGE(1));
XT_ERP = TW_RANGE(1):1/FS_EEG:(TW_RANGE(2)-1/FS_EEG);

%% Main
% blk_typ = 'tsk';
% tot_sub = 0;
% for isub = 1:NSUB
%     %% Check existence of file and load data
%     EEG_EPOCH = check_and_get_data(isub, path_in_eeg);
%     if isempty(EEG_EPOCH)
%         continue;
%     end
% 
%     tot_sub = tot_sub + 1;
%     for itsk = 1:2
%         for itag = 1:NTAG
%             dat_all_ch = EEG_EPOCH.([TSK_NAME(itsk) num2str(itag)]);
%             for ich = CH_IND
%                 dat_all_trl = squeeze(dat_all_ch(ich,:,:));
% %                 for itrl = 1:size(dat_all_trl,2)
% %                     bas = mean(dat_all_trl(IDX_BASE,itrl));
% %                     dat_all_trl(:,itrl) = (dat_all_trl(:,itrl) - bas)/bas;
% %                 end
%                 idx_nan = sum(isnan(dat_all_trl),1);
%                 idx_inf = sum(isinf(dat_all_trl),1);
%                 idx_vld = (~idx_nan) & (~idx_inf);
%                 if ~((length(idx_vld) == 43) || (length(idx_vld) == 129)) || (sum(idx_vld)==0)
%                     fprintf('\r\n Err \t%d \t%d \t%d', itsk, itag, ich);
%                     env =  zeros(size(dat_all_trl,1),1);
%                     ENV(:,ich,itsk,itag,tot_sub) = env;
%                 else
%                     env =  mean(dat_all_trl(:,idx_vld),2);
%                     ENV(:,ich,itsk,itag,tot_sub) = env;
%                 end
%             end
%         end
%     end
%     fprintf('\r\n');
% end
% save([path_out_eeg 'ENV.mat' ], 'ENV','-mat');


load([path_out_eeg 'ENV.mat']); % 700    32     2     6    48

tmp(:,:,:,1,:) = mean(ENV(:,:,:,1:3,:),4);
tmp(:,:,:,2,:) = mean(ENV(:,:,:,4:6,:),4);

ERS = calc_ers(IDX_BASE, ENV);

view_erp_all(CH_IND, EEG_LOC, XT_ERP, ERS);

view_ers(XT_ERP, ERS);


%z = squeeze(mean(ERP,4));


%% Done
load gong.mat;
sound(y);



%% Check existence of file and load data
function EEG_EPOCH = check_and_get_data(isub, path_in_eeg)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['EEG_EPOCH_' num2str(isub) '.mat' ];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_EPOCH = [];
    else
        load([path_in_eeg file_in_eeg]);
    end
end



function view_ers(XT_ERP, ERS) % 700    32     2     6    48
%     ROI_L = [25,26,30];
%     ROI_R = [29,28,32];
    ROI_L = [25];
    ROI_R = [29];

    ERS_EL_CL = ERS(:, ROI_L, :, 4:6, :);
    ERS_EL_CR = ERS(:, ROI_L, :, 1:3, :);
    ERS_ER_CL = ERS(:, ROI_R, :, 4:6, :);
    ERS_ER_CR = ERS(:, ROI_R, :, 1:3, :);

    ERS_IPS = (ERS_EL_CL + ERS_ER_CR)/2;
    ERS_CON = (ERS_EL_CR + ERS_ER_CL)/2;

    ERS_IPS_avg = squeeze( mean(ERS_IPS, [2,4,5]) );
    ERS_CON_avg = squeeze( mean(ERS_CON, [2,4,5]) );

    figure;
    plot(XT_ERP, ERS_IPS_avg(:,1), ':b'); hold on;
    plot(XT_ERP, ERS_CON_avg(:,1), '-b'); hold on;
    plot(XT_ERP, ERS_IPS_avg(:,2), ':r'); hold on;
    plot(XT_ERP, ERS_CON_avg(:,2), '-r'); hold on;
    legend('Task-Same  Ipsi', 'Task-Same  Contra', 'Task-Diff  Ipsi', 'Task-Diff  Contra');

    figure;
    plot(XT_ERP, ERS_CON_avg(:,1) - ERS_IPS_avg(:,1), ':b'); hold on;
    plot(XT_ERP, ERS_CON_avg(:,2) - ERS_IPS_avg(:,2), '-r'); hold on;
    
end


function ERS = calc_ers(IDX_BASE, ENV)
    for ich = 1:size(ENV,2)
        for itsk = 1:size(ENV,3)
            for itag = 1:size(ENV,4)
                for isub = 1:size(ENV,5)
                    dat = squeeze( ENV(:, ich, itsk, itag, isub) );
                    bas = mean(dat(IDX_BASE));
                    ERS(:, ich, itsk, itag, isub) = (dat - bas)/bas*100;
                end
            end
        end
    end
end

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
    for ich = CH_IND
        ax = set_axes(fig, EEG_LOC, ich);

        dat_tmp = [];
        dat_avg = [];
        for tsk = 1:2
            dat_tmp(:,:,tsk) = squeeze(ERP(:,ich,tsk,:));
            dat_avg(:,tsk) = mean(dat_tmp(:,:,tsk),2);
            dat_std(:,tsk) = std(squeeze(dat_tmp(:,:,tsk))')';
        end
        plot(XT_ERP, dat_avg(:,1), '-b'); hold on;
        plot(XT_ERP, dat_avg(:,2), '-r'); hold on;

        h = ttest(dat_tmp(:,:,1), dat_tmp(:,:,2));
%         plot(XT_ERP, dat_avg(:,1)+dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,1)-dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,2)+dat_std(:,2), '.r'); hold on;
%         plot(XT_ERP, dat_avg(:,2)-dat_std(:,2), '.r'); hold on;

        xlim([min(XT_ERP) max(XT_ERP)]);
        %ylim([-3 1]);

        title(['ch ' num2str(ich)]);
    end

end

