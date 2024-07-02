clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\4.two\';
path_out_eye = 'E:\Data\202305\EYE\5.hot\';

W_SCREEN = 1920;
H_SCREEN = 1080;

%'latency'	'endtime'	'duration'	'fix_avgpos_x'	'fix_avgpos_y'	'fix_avgpupilsize'
% load([path_in_eye 'EYE_12.mat']);
% [fix_prob_easy_tw1, fix_area_easy_tw1] = get_fix(W_SCREEN, H_SCREEN, EYE_EASY_TW1);
% [fix_prob_easy_tw2, fix_area_easy_tw2] = get_fix(W_SCREEN, H_SCREEN, EYE_EASY_TW2);
% [fix_prob_hard_tw1, fix_area_hard_tw1] = get_fix(W_SCREEN, H_SCREEN, EYE_HARD_TW1);
% [fix_prob_hard_tw2, fix_area_hard_tw2] = get_fix(W_SCREEN, H_SCREEN, EYE_HARD_TW2);
% map_avg_easy_tw1 = get_avg(W_SCREEN, H_SCREEN, fix_prob_easy_tw1, fix_area_easy_tw1);  save([path_out_eye 'map_avg_easy_tw1.mat'], 'map_avg_easy_tw1', '-mat');
% map_avg_easy_tw2 = get_avg(W_SCREEN, H_SCREEN, fix_prob_easy_tw2, fix_area_easy_tw2);  save([path_out_eye 'map_avg_easy_tw2.mat'], 'map_avg_easy_tw2', '-mat');
% map_avg_hard_tw1 = get_avg(W_SCREEN, H_SCREEN, fix_prob_hard_tw1, fix_area_hard_tw1);  save([path_out_eye 'map_avg_hard_tw1.mat'], 'map_avg_hard_tw1', '-mat');
% map_avg_hard_tw2 = get_avg(W_SCREEN, H_SCREEN, fix_prob_hard_tw2, fix_area_hard_tw2);  save([path_out_eye 'map_avg_hard_tw2.mat'], 'map_avg_hard_tw2', '-mat');


load([path_out_eye 'map_avg_easy_tw1.mat']);
load([path_out_eye 'map_avg_easy_tw2.mat']);
load([path_out_eye 'map_avg_hard_tw1.mat']);
load([path_out_eye 'map_avg_hard_tw2.mat']);

TH = [1e-6 5e-5];
figure('WindowState','maximized');
tiledlayout(2,2, 'TileSpacing','compact', 'Padding','compact');

nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_easy_tw1); title('easy 0~200ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_easy_tw2); title('easy 200~300ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_hard_tw1); title('hard 0~200ms');
nexttile; fig_heat(W_SCREEN, H_SCREEN, TH, 0.2, path_out_eye, map_avg_hard_tw2); title('hard 200~300ms');


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

    %map_avg = log10(map_avg);
    map_avg(map_avg<TH(1))=-Inf;
    map_alpha = repmat(0.2, W_SCREEN, H_SCREEN);
    map_alpha(map_avg<TH(1))=0;

    
    %fig = figure('WindowState','maximized');
    %contourf(map_avg', "LineStyle", "none", "FaceAlpha", pic_alpha);
    imagesc(map_avg', 'AlphaData',map_alpha');
    clim([TH(1) TH(2)]);
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






function map_avg = get_avg(W_SCREEN, H_SCREEN, prob, area)
    [X,Y] = meshgrid(1:W_SCREEN, 1:H_SCREEN);
    r = sqrt(area/pi);
    rr = r;
    d2 = rr.^2;
    map_avg = zeros(W_SCREEN, H_SCREEN);
    for ix = 1:W_SCREEN
        tStart = tic;
        for iy = 1:H_SCREEN
            %rz = (30)^2; test = (1/2/pi/rz)*exp(-((X-ix).^2+(Y-iy).^2)/(2*rz));
            if (prob(ix,iy)>0) && (d2(ix,iy)>0)
                gz = (1/2/pi/d2(ix,iy))*exp(-((X-ix).^2+(Y-iy).^2)/(2*d2(ix,iy)));
                map_avg = map_avg + gz'*prob(ix,iy);
            end
        end
        tThis = toc(tStart);
        tRemain = round(tThis*(W_SCREEN-ix));
        fprintf("%d / 1920\t Remain Time: %dm, %ds\r\n", ix, round(tRemain/60), mod(tRemain, 60));
    end
end



function [fix_prob, fix_area] = get_fix(W_SCREEN, H_SCREEN, EYE_DAT)
    fix_cnt = zeros(W_SCREEN, H_SCREEN);
    fix_area = zeros(W_SCREEN, H_SCREEN);
    for itrl = 1:size(EYE_DAT,1)
        for iblk = 1:size(EYE_DAT,2)
            for isub = 1:size(EYE_DAT,3)
                tmp = EYE_DAT(itrl, iblk, isub).Fix;
                if ~isempty(tmp)
                    tmp = mean(tmp,1);
                    x = round(tmp(4));
                    y = round(tmp(5));
                    area = round(tmp(6));
                    if (0<x) && (x<W_SCREEN) && (0<y) && (y<H_SCREEN)
                        fix_cnt(x,y) = fix_cnt(x,y) + 1;
                        fix_area(x,y) = fix_area(x,y) + area;
                    end
                end
            end
        end
    end
    fix_prob = fix_cnt/(size(EYE_DAT,1)*size(EYE_DAT,2)*size(EYE_DAT,3));
    fix_area = fix_area./fix_cnt;
end
