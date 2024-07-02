clc;clear;close all;

%% File path and name
path_in_rme = 'E:\Data\202305\EEG\9.erp\';
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


load([path_out_eeg 'ERP.mat']); % 700    32     2     6    48
view_LADN(XT_ERP, ERP);

%%
function ax = set_axes(fig, EEG_LOC, ich)
    col_ch = EEG_LOC.COL(ich);
    row_ch = EEG_LOC.ROW(ich);
    dr_x = (col_ch-1)/max(EEG_LOC.COL);
    dr_y = 1-(row_ch)/max(EEG_LOC.ROW);
    dr_y = dr_y * 0.99;
    ax = axes(fig,'Position',[dr_x+0.01 dr_y+0.02 0.18 0.11]);
end


function view_LADN(XT_ERP, ERP) % 700    32     2     6    48
    ICH_P7 = [25 26];
    ICH_P8 = [29 28];
%     ICH_P7 = [25];
%     ICH_P8 = [29];

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
    plot(XT_ERP, -dat_avg(:,1), '-b'); hold on;
    plot(XT_ERP, -dat_avg(:,2), '-r'); hold on;

    h1 = ttest(squeeze(ERP_CDA(:,1,:))');
    h2 = ttest(squeeze(ERP_CDA(:,2,:))');
    h3 = ttest(squeeze(ERP_CDA(:,1,:))',squeeze(ERP_CDA(:,2,:))');
    plot(XT_ERP, 1000*(h1-1)+1.7, '.b'); hold on;
    plot(XT_ERP, 1000*(h2-1)+1.8, '.r'); hold on;
    plot(XT_ERP, 1000*(h3-1)+1.9, '.k'); hold on;
    
    xlim([min(XT_ERP) max(XT_ERP)]);
    ylim([-1 2]);

    title('LADN');
end

