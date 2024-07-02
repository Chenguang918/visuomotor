clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\8.seg_cwt\';
path_out_eeg = 'E:\Data\202305\EEG\9.erp_cwt\';

%% Parameter
NSUB = 50;
NTAG = 6;
NBLK = 6;
FS_EEG = 500;
NCH = 32;
TW_RANGE = [-0.2 1.2];
TW_BASE = [-0.2 0];
ATH_HI = [-1000 1000];
ATH_LO = 1e-8;
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
%             dat = EEG_EPOCH.([TSK_NAME(itsk) num2str(itag)]);
%             for ich = CH_IND
%                 tmp = squeeze(dat(ich,:,:));
%                 %tmp = tmp - mean(tmp(IDX_BASE,:),1);
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

view_ami(XT_ERP, ERP);
view_erp_all(CH_IND, EEG_LOC, XT_ERP, ERP);

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



function check_nan(tmp,itsk,itag,ich)
    z = reshape(isnan(tmp),[],1);
    if sum(z) > 0
        fprintf('Err %d %d\t',itsk,itag,ich);
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


function view_ami(XT_ERP, ERP) % 700    32     2     6    48
    ROI_L = [25,26,30];
    ROI_R = [29,28,32];

    AP_LE_LC = ERP(:, ROI_L, :, 4:6, :);
    AP_LE_RC = ERP(:, ROI_L, :, 1:3, :);
    AP_RE_LC = ERP(:, ROI_R, :, 4:6, :);
    AP_RE_RC = ERP(:, ROI_R, :, 1:3, :);
%     AP_LE_LCavg = squeeze(mean(AP_LE_LC,4));
%     AP_LE_RCavg = squeeze(mean(AP_LE_RC,4));
%     AP_RE_LCavg = squeeze(mean(AP_RE_LC,4));
%     AP_RE_RCavg = squeeze(mean(AP_RE_RC,4));
% 
%     AP_LEavg_LCavg = squeeze(mean(AP_LE_LCavg,2));
%     AP_LEavg_RCavg = squeeze(mean(AP_LE_RCavg,2));
%     AP_REavg_LCavg = squeeze(mean(AP_RE_LCavg,2));
%     AP_REavg_RCavg = squeeze(mean(AP_RE_RCavg,2));
% 
%     LMI = 2*(AP_LEavg_LCavg-AP_LEavg_RCavg)./(AP_LEavg_LCavg+AP_LEavg_RCavg);
%     RMI = 2*(AP_REavg_LCavg-AP_REavg_RCavg)./(AP_REavg_LCavg+AP_REavg_RCavg);

    LMI = 2*(AP_LE_LC-AP_LE_RC)./(AP_LE_LC+AP_LE_RC);
    RMI = 2*(AP_RE_LC-AP_RE_RC)./(AP_RE_LC+AP_RE_RC);
    LMI = squeeze(mean(mean(LMI,4),2));
    RMI = squeeze(mean(mean(RMI,4),2));

    AMI = LMI - RMI;

    for itsk = 1:2
        dat_tmp = squeeze(AMI(:,itsk,:));
        dat_avg(:,itsk) = mean(dat_tmp,2);
        dat_std(:,itsk) = std(dat_tmp')';
    end
    fig = figure;
    plot(XT_ERP, dat_avg(:,1), '.b'); hold on;
    plot(XT_ERP, dat_avg(:,2), '.r'); hold on;
%     plot(XT_ERP, dat_avg(:,1)+dat_std(:,1)/sqrt(48), ':b'); hold on;
%     plot(XT_ERP, dat_avg(:,1)-dat_std(:,1)/sqrt(48), ':b'); hold on;
%     plot(XT_ERP, dat_avg(:,2)+dat_std(:,2)/sqrt(48), ':r'); hold on;
%     plot(XT_ERP, dat_avg(:,2)-dat_std(:,2)/sqrt(48), ':r'); hold on;
    patch([XT_ERP,flip(XT_ERP)]', [dat_avg(:,1)+dat_std(:,1)/sqrt(48); flip(dat_avg(:,1)-dat_std(:,1)/sqrt(48))],'b','FaceAlpha',0.3,'LineStyle','none');
    patch([XT_ERP,flip(XT_ERP)]', [dat_avg(:,2)+dat_std(:,2)/sqrt(48); flip(dat_avg(:,2)-dat_std(:,2)/sqrt(48))],'r','FaceAlpha',0.3,'LineStyle','none');


    h1 = ttest(squeeze(AMI(:,1,:))');
    h2 = ttest(squeeze(AMI(:,2,:))');
    h3 = ttest(squeeze(AMI(:,1,:))',squeeze(AMI(:,2,:))');
    plot(XT_ERP, 2*(h1-0.5)-1+0.05,'*b'); hold on;
    plot(XT_ERP, 2*(h2-0.5)-1+0.06,'*r'); hold on;
    plot(XT_ERP, 2*(h3-0.5)-1+0.07,'*k'); hold on;

    xlim([min(XT_ERP) max(XT_ERP)]);
    ylim([-0.08 0.08]);
    title('AMI');
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
        plot(XT_ERP, dat_avg(:,1)*100, '-b'); hold on;
        plot(XT_ERP, dat_avg(:,2)*100, '-r'); hold on;
%         plot(XT_ERP, dat_avg(:,1)+dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,1)-dat_std(:,1), '.b'); hold on;
%         plot(XT_ERP, dat_avg(:,2)+dat_std(:,2), '.r'); hold on;
%         plot(XT_ERP, dat_avg(:,2)-dat_std(:,2), '.r'); hold on;

        xlim([min(XT_ERP) max(XT_ERP)]);
        ylim([-5 1]);

        title(['ch ' num2str(ich)]);
    end

end

