clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\0.csv\';
path_out_nir = 'E:\Data\202305\NIR\1.nir\';
name_mid1 = 'MES_Probe1';
name_mid2 = 'MES_Probe2';
addpath('..\FUN\Hitachi_2_Homer_v3');
load('..\INF\NIR_SD.mat');
file_pos = '3x5.pos';

%% Parameter
NSUB = 50;

%% Main
for isub = 1:NSUB
    % Check existence of file
    fprintf('[Sub %d] : ', isub);
    file_in_nir1 = ['sub' num2str(isub) '_MES_Probe1.csv'];
    file_in_nir2 = ['sub' num2str(isub) '_MES_Probe2.csv'];
    if ~exist([path_in_nir file_in_nir1],'file') || ~exist([path_in_nir file_in_nir2],'file')
        fprintf(' <-- Missing DAT, Skip !!! \r\n');
    end

     % Load NIRS Data
    [t1, d1, SD1, s1, ml1, aux1] = fun_Hitachi_2_Homer_v3(path_in_nir, file_in_nir1, file_pos);
    [t2, d2, SD2, s2, ml2, aux2] = fun_Hitachi_2_Homer_v3(path_in_nir, file_in_nir2, file_pos);

    % Check t s ml aux
    if (t1 ~= t2)
        fprintf(' <-- NOT match t \r\n');
    end
    if (s1 ~= s2)
        fprintf(' <-- NOT match s \r\n');
    end
    if (ml1 ~= ml2)
        fprintf(' <-- NOT match ml \r\n');
    end
    if (aux1 ~= aux2)
        fprintf(' <-- NOT match aux \r\n');
    end

    % Merge 2 probes and Save file
    file_out_nir = ['sub' num2str(isub) '.nirs'];
    t = t1;
    d = [d1 d2];
    SD = NIR_SD;
    s = s1;
    ml = NIR_SD.MeasList;
    aux = aux1;
    save([path_out_nir file_out_nir],'t', 'd', 'SD', 's', 'ml', 'aux');
    fprintf('--------------------------------- \r\n');
end