clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\4.dat\';
path_out_eye = 'E:\Data\202305\EYE\5.hot\';

%% Parameter
FS_EYE = 1000;
NSUB = 50;
NBLK = 6;
NTAG = 6;
N_TSK_SAM = 43;
N_TSK_ALL = 172;
TPT_TW = [0 0.5]*FS_EYE; % sample

W_SCREEN = 1920;
H_SCREEN = 1080;

%% Main
load([path_in_eye 'EYE_DAT.mat']); % 501  3  172  6  44
[map_val_easy1, map_rng_easy1] = get_val_rng(W_SCREEN, H_SCREEN, EYE_DAT, [1, N_TSK_SAM], [1 200]);
[map_val_easy2, map_rng_easy2] = get_val_rng(W_SCREEN, H_SCREEN, EYE_DAT, [1, N_TSK_SAM], [200 300]);
[map_val_hard1, map_rng_hard1] = get_val_rng(W_SCREEN, H_SCREEN, EYE_DAT, [N_TSK_SAM, N_TSK_ALL], [1 200]);
[map_val_hard2, map_rng_hard2] = get_val_rng(W_SCREEN, H_SCREEN, EYE_DAT, [N_TSK_SAM, N_TSK_ALL], [200 300]);
map_avg_easy1 = get_avg(W_SCREEN, H_SCREEN, map_val_easy1, map_rng_easy1); save([path_out_eye 'map_avg_easy1.mat'], 'map_avg_easy1', '-mat');
map_avg_easy2 = get_avg(W_SCREEN, H_SCREEN, map_val_easy2, map_rng_easy2); save([path_out_eye 'map_avg_easy2.mat'], 'map_avg_easy2', '-mat');
map_avg_hard1 = get_avg(W_SCREEN, H_SCREEN, map_val_hard1, map_rng_hard1); save([path_out_eye 'map_avg_hard1.mat'], 'map_avg_hard1', '-mat');
map_avg_hard2 = get_avg(W_SCREEN, H_SCREEN, map_val_hard2, map_rng_hard2); save([path_out_eye 'map_avg_hard2.mat'], 'map_avg_hard2', '-mat');


%% Figure
load([path_out_eye 'map_avg_easy1.mat']);
load([path_out_eye 'map_avg_easy2.mat']);
load([path_out_eye 'map_avg_hard1.mat']);
load([path_out_eye 'map_avg_hard2.mat']);


TH = 0.2;
figure('WindowState','maximized');
tiledlayout(2,2, 'TileSpacing','compact', 'Padding','compact');

nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_easy1); title('easy 0~200ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_easy2); title('easy 200~300ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_hard1); title('hard 0~200ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_hard2); title('hard 200~300ms');



function [map_val, map_rng] = get_val_rng(W_SCREEN, H_SCREEN, EYE_DAT, tr, tw) % 501  3  172  6  44
    map_val = zeros(W_SCREEN, H_SCREEN);
    map_rng = zeros(W_SCREEN, H_SCREEN);
    for itpt = tw(1):tw(2)
        for isub = 1:size(EYE_DAT, 5)
            for iblk = 1:size(EYE_DAT, 4)
                for itrl = tr(1):tr(2)
                    x = round( EYE_DAT(itpt, 1, itrl, iblk, isub) );
                    y = round( EYE_DAT(itpt, 2, itrl, iblk, isub) );
                    r = round( EYE_DAT(itpt, 3, itrl, iblk, isub) );
                    if (x>0) && (y>0) && (x<W_SCREEN) && (y<H_SCREEN)
                        map_val(x,y) = map_val(x,y) + 1;
                        map_rng(x,y) = map_rng(x,y) + r;
                    end
                end
            end
        end
    end
    map_val = (map_val/(tr(2)-tr(1))/(tw(2)-tw(1)));
    map_rng = (map_rng/(tr(2)-tr(1))/(tw(2)-tw(1)));
    for ix = 1:1:W_SCREEN
        for iy = 1:1:H_SCREEN
            if (map_val(ix,iy)>0)
                map_rng(ix,iy) = map_rng(ix,iy)/map_val(ix,iy);
            else
                map_rng(ix,iy) = 0;
            end
        end
    end
end


function map_avg = get_avg(W_SCREEN, H_SCREEN, map_val, map_rng)
    AX = 1:1:W_SCREEN;
    AY = 1:1:H_SCREEN;
    map_avg = zeros(W_SCREEN, H_SCREEN);
    for ix = 1:W_SCREEN
        tStart = tic;
        cnt = 1;
        for iy = 1:H_SCREEN
            if (map_rng(ix,iy)==0) || (map_val(ix,iy) == 0)
                continue;
            else
                ir = sqrt(map_rng(ix,iy));
                nx = exp(-(AX-ix).^2/(2*ir^2));
                ny = exp(-(AY-iy).^2/(2*ir^2));
                map_add = nx' * ny * map_val(ix,iy);
                map_avg = map_avg + map_add;
            end
        end
        if (cnt>1)
            map_add = gen_map_add(W_SCREEN, H_SCREEN, para);
            map_avg = map_avg + map_add;
        end
        tThis = toc(tStart);
        tRemain = round(tThis*(W_SCREEN-ix));
        fprintf("%d / 1920\t Remain Time: %dm, %ds\r\n", ix, round(tRemain/60), mod(tRemain, 60));
    end
end


function map_add = gen_map_add(W_SCREEN, H_SCREEN, para)
    AX = 1:1:W_SCREEN;
    AY = 1:1:H_SCREEN;
    list_x = para(:,1);
    list_y = para(:,2);
    list_r = sqrt(para(:,3));
    list_val = para(:,4);

    map_add = zeros(W_SCREEN, H_SCREEN);
    for ii = 1:size(para,1)
        nx = exp(-(AX-list_x(ii)).^2/(2*list_r(ii)^2));
        ny = exp(-(AY-list_y(ii)).^2/(2*list_r(ii)^2));
        map_add = map_add + nx'*ny*list_val(ii);
    end
end


function cm = creatcolormap()
    r = [0:2:256, repmat(256,1,127)];
    g = [repmat(256,1,127), 256:-2:0];
    b = zeros(1,256);
    cm = [r;g;b]'/256;
end



function fig_heat(W_SCREEN, H_SCREEN, TH, pic_alpha, path_out_eye, map_avg)
    %zscore(map_avg); %放log之前还是之后？？？试试
    rgbImage = imread([path_out_eye 'target7.jpg']);
    imshow(rgbImage); hold on;

    map_avg = log10(map_avg);
    map_avg(map_avg<TH)=-Inf;
    
    %fig = figure('WindowState','maximized');
    contourf(map_avg', "LineStyle", "none", "FaceAlpha", pic_alpha);
    clim([TH 2]);
    xlim([1 W_SCREEN]);
    ylim([1 H_SCREEN]);
    axis equal;
    
    xticks([]); xticklabels({});
    yticks([]); yticklabels({});
    
    %axis off;
    cm = creatcolormap();
    colormap (cm);
    colorbar;
%     exportgraphics(gca,[path_out_eye 'heat_' num2str(TH,'%1.1f') '.png'], 'Resolution',300);
%     close(fig);
end




