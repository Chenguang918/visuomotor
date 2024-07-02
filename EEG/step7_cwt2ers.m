clc;clear;close all;

%% File path and name
path_in_eeg = 'E:\Data\202305\EEG\8.cwt_seg\';
path_out_eeg = 'E:\Data\202305\EEG\9.ers\';

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
BAND_ALPHA = [8 12];
BAND_THETA = [4 8];

IDX_BASE = 1 : round(-FS_EEG * TW_RANGE(1));
XT_ERP = TW_RANGE(1):1/FS_EEG:(TW_RANGE(2)-1/FS_EEG);

%% Main
% blk_typ = 'tsk';
% tot_sub = 0;
% for isub = 1:NSUB
%     %% Check existence of file and load data
%     [CWT_SEG, FX] = check_and_get_cwt_seg(isub, path_in_eeg);
%     if isempty(CWT_SEG) % 99   700    33     6
%         continue;
%     end
% 
%     FRQ_ALPHA = (FX >= BAND_ALPHA(1)) & (FX <= BAND_ALPHA(2));
%     FRQ_THETA = (FX >= BAND_THETA(1)) & (FX <= BAND_THETA(2));
%     tot_sub = tot_sub + 1;
%     PWR_ALPHA(:,:,:,1,tot_sub) = squeeze(mean(CWT_SEG.SAME(FRQ_ALPHA,:,:,:), 1));
%     PWR_ALPHA(:,:,:,2,tot_sub) = squeeze(mean(CWT_SEG.DIFF(FRQ_ALPHA,:,:,:), 1));
%     PWR_THETA(:,:,:,1,tot_sub) = squeeze(mean(CWT_SEG.SAME(FRQ_THETA,:,:,:), 1));
%     PWR_THETA(:,:,:,2,tot_sub) = squeeze(mean(CWT_SEG.DIFF(FRQ_THETA,:,:,:), 1));
%     fprintf('\r\n');
% end
% save([path_out_eeg 'PWR.mat' ], 'PWR_ALPHA','PWR_THETA','FX', '-mat');


load([path_out_eeg 'PWR.mat']); %    700    33     6     2    48

TAG_L = 4:6;
TAG_R = 1:3;
CH_L = [1,3,4,8,9,13,14,19,20,25,26,30];
CH_R = [2,7,6,12,11,17,16,23,22,29,28,32];

ERS_ALPHA = calc_ers(IDX_BASE, PWR_ALPHA);
ERS_THETA = calc_ers(IDX_BASE, PWR_THETA);


ERS_ALPHA_CON = (mean(ERS_ALPHA(:,CH_L,TAG_R,:,:),3) + mean(ERS_ALPHA(:,CH_R,TAG_L,:,:),3))/2;
ERS_ALPHA_IPS = (mean(ERS_ALPHA(:,CH_L,TAG_L,:,:),3) + mean(ERS_ALPHA(:,CH_R,TAG_R,:,:),3))/2;
ERS_ALPHA_CDA = ERS_ALPHA_CON - ERS_ALPHA_IPS;
ERS_THEHA_CON = (mean(ERS_THETA(:,CH_L,TAG_R,:,:),3) + mean(ERS_THETA(:,CH_R,TAG_L,:,:),3))/2;
ERS_THEHA_IPS = (mean(ERS_THETA(:,CH_L,TAG_L,:,:),3) + mean(ERS_THETA(:,CH_R,TAG_R,:,:),3))/2;
ERS_THEHA_CDA = ERS_THEHA_CON - ERS_THEHA_IPS;


view_erp_cda(CH_L, EEG_LOC, XT_ERP, squeeze(ERS_ALPHA_CDA));
view_erp_cda(CH_L, EEG_LOC, XT_ERP, squeeze(ERS_THEHA_CDA));


view_erp_all(CH_IND, EEG_LOC, XT_ERP, squeeze(mean(ERS_ALPHA,3)));
view_erp_all(CH_IND, EEG_LOC, XT_ERP, squeeze(mean(ERS_THETA,3)));

%% Done
load gong.mat;
sound(y);



%% Check existence of file and load data
function [CWT_SEG, FX] = check_and_get_cwt_seg(isub, path_in_eeg)
    fprintf('[Sub %d] : ', isub);
    file_in_eeg = ['CWT_SEG_sub' num2str(isub) '.mat'];
    if ~exist([path_in_eeg '\' file_in_eeg],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        CWT_SEG = [];
        FX = [];
    else
        load([path_in_eeg file_in_eeg]);
    end
end



function ERS = calc_ers(IDX_BASE, ENV)
    for ich = 1:size(ENV,2)
        for itag = 1:size(ENV,3)
            for itsk = 1:size(ENV,4)
                for isub = 1:size(ENV,5)
                    dat = squeeze( ENV(:, ich, itag, itsk, isub) );
                    bas = mean(dat(IDX_BASE));
                    ERS(:, ich, itag, itsk, isub) = (dat - bas)/bas*100;
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
    ax = axes(fig,'Position',[dr_x+0.03 dr_y+0.02 0.18 0.11]);
end



function view_erp_all(CH_IND, EEG_LOC, XT_ERP, ERP) % 700    32     2    48
    fig = figure;
    for ich = CH_IND
        ax = set_axes(fig, EEG_LOC, ich);

        dat_tmp = [];
        dat_avg = [];
        for tsk = 1:2
            dat_tmp(:,:,tsk) = squeeze(ERP(:,ich,tsk,:));
            dat_avg(:,tsk) = mean(dat_tmp(:,:,tsk),2);
            dat_std(:,tsk) = std(squeeze(dat_tmp(:,:,tsk))')';
        end
        h1 = ttest(dat_tmp(:,:,1)');
        h2 = ttest(dat_tmp(:,:,2)');
        h3 = ttest(dat_tmp(:,:,1)', dat_tmp(:,:,2)');

        plot(XT_ERP, dat_avg(:,1), '-b'); hold on;
        plot(XT_ERP, dat_avg(:,2), '-r'); hold on;
        plot(XT_ERP, 1000*(h1-1)+20, '.b'); hold on;
        plot(XT_ERP, 1000*(h2-1)+25, '.r'); hold on;
        plot(XT_ERP, 1000*(h3-1)+30, '.k'); hold on;


        xlim([min(XT_ERP) max(XT_ERP)]);
        ylim([-25 35]);

        title(['ch ' num2str(ich)]);
    end

end



function view_erp_cda(CH_IND, EEG_LOC, XT_ERP, ERP) % 700    32     2    48
    fig = figure;
    for ich = 1:length(CH_IND)
        ax = set_axes(fig, EEG_LOC, CH_IND(ich));

        dat_tmp = [];
        dat_avg = [];
        for tsk = 1:2
            dat_tmp(:,:,tsk) = squeeze(ERP(:,ich,tsk,:));
            dat_avg(:,tsk) = mean(dat_tmp(:,:,tsk),2);
            dat_std(:,tsk) = std(squeeze(dat_tmp(:,:,tsk))')';
        end
        h1 = ttest(dat_tmp(:,:,1)');
        h2 = ttest(dat_tmp(:,:,2)');
        h3 = ttest(dat_tmp(:,:,1)', dat_tmp(:,:,2)');

        plot(XT_ERP, dat_avg(:,1), '-b'); hold on;
        plot(XT_ERP, dat_avg(:,2), '-r'); hold on;
        plot(XT_ERP, 1000*(h1-1)+2, '.b'); hold on;
        plot(XT_ERP, 1000*(h2-1)+3, '.r'); hold on;
        plot(XT_ERP, 1000*(h3-1)+4, '.k'); hold on;


        xlim([min(XT_ERP) max(XT_ERP)]);
        ylim([-5 5]);

        title(['ch ' num2str(CH_IND(ich))]);
    end

end