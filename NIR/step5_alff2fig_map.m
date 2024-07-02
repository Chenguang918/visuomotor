clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\6.alf\';
path_out_nir = 'E:\Data\202305\NIR\6.alf\';

load('NIR_LOC_P1P2.mat');
load([path_in_nir 'fALFF.mat']);
MNI_NIR = readmatrix("E:\Work\BNU_2023\SA\Matlab\INF\MNI_NIR.xlsx");
NCH = 44;

ChID = (1:NCH)';
MNI_x = MNI_NIR(:,1);
MNI_y = MNI_NIR(:,2);
MNI_z = MNI_NIR(:,3);
TN = {'ChID', 'MNI_x', 'MNI_y', 'MNI_z', 'Stat_Value'};


dm_r_p1 = get_dat_map_int(NIR_LOC_P1, mean(fALFF_REST,1));
dm_r_p2 = get_dat_map_int(NIR_LOC_P2, mean(fALFF_REST,1));
dm_s_p1 = get_dat_map_int(NIR_LOC_P1, mean(fALFF_SAME,1));
dm_s_p2 = get_dat_map_int(NIR_LOC_P2, mean(fALFF_SAME,1));
dm_d_p1 = get_dat_map_int(NIR_LOC_P1, mean(fALFF_DIFF,1));
dm_d_p2 = get_dat_map_int(NIR_LOC_P2, mean(fALFF_DIFF,1));

[h,p,ci,stats] = ttest(fALFF_DIFF, fALFF_SAME);
tval_ssdd = stats.tstat;
p_fdr = mafdr(p);
tval_ssdd_mdr = tinv(1- p_fdr/2, 46-1).*sign(stats.tstat);
tval_ssdd_mdr(p_fdr>0.05) = 0;
dm_tval_ssdd_p1 = get_dat_map_int(NIR_LOC_P1, tval_ssdd_mdr);
dm_tval_ssdd_p2 = get_dat_map_int(NIR_LOC_P2, tval_ssdd_mdr);


figure;
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_r_p1, 'dm_r_p1');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_s_p1, 'dm_s_p1');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_d_p1, 'dm_d_p1');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_r_p2, 'dm_r_p2');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_s_p2, 'dm_s_p2');
nexttile; map_dat(path_out_nir, 'jet', [-1,1], 2, dm_d_p2, 'dm_d_p2');
%save_colorbar(path_out_nir, 'jet', [-1,1], 'dm_colorbar');
% 
% figure;
% tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
% nexttile; map_dat(path_out_nir, 'bluewhitered', [-4,7], 4, dm_tval_ssdd_p1, 'dm_tval_ssdd_p1');
% nexttile; map_dat(path_out_nir, 'bluewhitered', [-4,7], 4, dm_tval_ssdd_p2, 'dm_tval_ssdd_p2');
% %save_colorbar(path_out_nir, 'bluewhitered', [-4,7], 'dm_tval_colorbar');


Stat_Value = mean(fALFF_REST,1)';
A = [TN; num2cell([ChID, MNI_x, MNI_y, MNI_z, Stat_Value])];
xlswrite([path_out_nir 'T3d_avg_fALFF_REST.xlsx'],A);
Stat_Value = mean(fALFF_SAME,1)';
A = [TN; num2cell([ChID, MNI_x, MNI_y, MNI_z, Stat_Value])];
xlswrite([path_out_nir 'T3d_avg_fALFF_SAME.xlsx'],A);
Stat_Value = mean(fALFF_DIFF,1)';
A = [TN; num2cell([ChID, MNI_x, MNI_y, MNI_z, Stat_Value])];
xlswrite([path_out_nir 'T3d_avg_fALFF_DIFF.xlsx'],A);

Stat_Value = tval_ssdd_mdr';
A = [TN; num2cell([ChID, MNI_x, MNI_y, MNI_z, Stat_Value])];
xlswrite([path_out_nir 'T3d_DIFF_SAME_tval.xlsx'],A);



function dat_map = get_dat_map_int(NIR_LOC, dat)
    dat_map = zeros(size(NIR_LOC));
    for irow = 1:size(NIR_LOC,1)
        for icol = 1:size(NIR_LOC,2)
            dat_map(irow, icol) = mean(dat(NIR_LOC{irow, icol}));
        end
    end
end


function map_dat(path_out_nir, c_map, c_lim, int_k, data, name)
    int_dat = interp2(data,int_k,'cubic');
    imagesc(int_dat);
    %contourf(int_dat, 'LineStyle','none'); axis ij;
    clim(c_lim);
    axis equal; axis off;
    colormap(c_map);
    ax = gca;
    exportgraphics(ax,[path_out_nir '\' name '.png'],'Resolution',500);
end


function save_colorbar(path_out_nir, c_map, c_lim, name)
    fig = figure('WindowState','maximized');
    clim(c_lim);
    colormap(c_map);
    cla;
    colorbar;
    ax = gca;
    exportgraphics(ax,[path_out_nir '\' name '.png'],'Resolution',500);
    close(fig);
    delete(fig);
end


function save_fig(path_out_nir, data, name)
    fig = figure('WindowState','maximized');
    tiledlayout(1,1,'TileSpacing','none', 'Padding','tight');
    map_dat(data);
    saveas(fig, [path_out_nir '\' name '.png'], 'png');
    close(fig);
    delete(fig);
end



