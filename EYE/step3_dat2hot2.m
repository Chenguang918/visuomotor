clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\4.dat\';
path_out_eye = 'E:\Data\202305\EYE\5.hot\';
load('..\INF\MK_EEG.mat');

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
load([path_in_eye 'EYE_DAT.mat'], 'EYE_DAT', '-mat'); % 501  3  172  6  44

map_tot = zeros(W_SCREEN, H_SCREEN);
for isub = 1:size(EYE_DAT,5)
    for iblk = 1:size(EYE_DAT,4)
        for itrl = 1:N_TSK_ALL
            for itpt = 1:size(EYE_DAT,1)
                x = round(EYE_DAT(itpt,1,itrl,iblk,isub));
                y = round(EYE_DAT(itpt,2,itrl,iblk,isub));
                r = round(EYE_DAT(itpt,3,itrl,iblk,isub));
                if (x>0) && (y>0) && (x<W_SCREEN) && (y<H_SCREEN)
                    map_add = crt_cir(x, y, r, W_SCREEN, H_SCREEN);
                    map_tot = map_tot + map_add';
                    %map_tot(x,y) = map_tot(x,y) + 1;
                end
            end
            fprintf("\t sub: %d\t blk: %d\t trl: %d\r\n", isub, iblk, itrl);
        end
    end
end

%map_tot = log10(map_tot);
imagesc(map_tot);
colorbar;

function map_add = crt_cir(x, y, r, W_SCREEN, H_SCREEN)
    [X,Y]=meshgrid(1:1:W_SCREEN, 1:1:H_SCREEN);
    p=mvnpdf([X(:),Y(:)], [x,y], [r,r]);
    map_add=reshape(p,size(X));
end

function map_add = crt_cir2(x, y, r, W_SCREEN, H_SCREEN)
    map_add = zeros(W_SCREEN, H_SCREEN);
    [X,Y] = meshgrid(-r:1:r, -r:1:r);
    Z = X.^2 + Y.^2;
    Z = (2*r*r-Z)/(2*r*r);
    for ix = 1:size(Z,1)
        for iy = 1:size(Z,2)
            nx = x - r + ix - 1;
            ny = y - r + iy - 1;
            if (nx>0) && (ny>0) && (nx<W_SCREEN) && (ny<H_SCREEN)
                map_add(nx, ny) = Z(ix, iy);
            end
        end
    end
end

