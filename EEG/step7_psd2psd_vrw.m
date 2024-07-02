clc;clear;close all;

%% File path and name
path_in_psd = 'E:\Data\202305\EEG\8.psd\';
path_out_psd = 'E:\Data\202305\EEG\9.psd_vrw\';


%% Parameter
NSUB = 50;
NTAG = 6;
NBLK = 6;
FS_EEG = 500;
load('..\INF\EEG_LOC.mat');
CH_IND = [1:17 19:23 25:32];

%% Main
% tot_sub = 0;
% for isub = 1:NSUB
%     % Check existence of file and load data
%     [EEG_PSD_SAME, EEG_PSD_DIFF, EEG_PSD_REST] = check_and_get_data_psd(isub, path_in_psd);
%     if isempty(EEG_PSD_SAME)
%         continue;
%     end
% 
%     tot_sub = tot_sub + 1;
%     PSD_SAME(:,:,:,tot_sub) = EEG_PSD_SAME;
%     PSD_DIFF(:,:,:,tot_sub) = EEG_PSD_DIFF;
%     PSD_REST(:,:,:,tot_sub) = EEG_PSD_REST;
% end
% save([path_out_psd 'PSD.mat' ], 'PSD_SAME','PSD_DIFF','PSD_REST','-mat');

load([path_out_psd 'PSD.mat' ], '-mat');

FX = 0:0.1:FS_EEG/2;
PSD_REST = log10(PSD_REST);
PSD_SAME = log10(PSD_SAME);
PSD_DIFF = log10(PSD_DIFF);

PSD_REST = mean(mean(PSD_REST,3),4);
PSD_SAME = mean(mean(PSD_SAME,3),4);
PSD_DIFF = mean(mean(PSD_DIFF,3),4);

view_psd_all(CH_IND, EEG_LOC, FX, PSD_REST, PSD_SAME, PSD_DIFF);

%% Done
load gong.mat;
sound(y);


%% Check existence of file and load data
function [EEG_PSD_SAME, EEG_PSD_DIFF, EEG_PSD_REST] = check_and_get_data_psd(isub, path_in_psd)
    fprintf('[Sub %d] : ', isub);
    file_in_psd = ['EEG_PSD_sub' num2str(isub) '.mat'];
    if ~exist([path_in_psd '\' file_in_psd],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        EEG_PSD_REST = [];
        EEG_PSD_SAME = [];
        EEG_PSD_DIFF = [];
    else
        load([path_in_psd file_in_psd]);
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


function view_psd_all(CH_IND, EEG_LOC, FX, PSD_REST, PSD_SAME, PSD_DIFF)
    fig = figure;
    for ich = CH_IND
        ax = set_axes(fig, EEG_LOC, ich);

        plot(FX, PSD_REST(:,ich), '-k'); hold on;
        plot(FX, PSD_SAME(:,ich), '-b'); hold on;
        plot(FX, PSD_DIFF(:,ich), '-r'); hold on;

        xlim([0.1 30]);
%         ylim([-10 10]);

        title(['ch ' num2str(ich)]);
    end

end


