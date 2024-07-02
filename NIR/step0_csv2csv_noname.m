clc;clear;close all;

%% File path and name
path_in_nir = 'E:\Data\202305\NIR\0.csv\';
path_out_nir = 'E:\Data\202305\NIR\0.csv\noname\';
name_mid1 = 'MES_Probe1';
name_mid2 = 'MES_Probe2';

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
    f1 = readlines([path_in_nir file_in_nir1]);
    f2 = readlines([path_in_nir file_in_nir2]);
    f1(5,:) = strcat("Name,sub", num2str(isub));
    f2(5,:) = strcat("Name,sub", num2str(isub));

    writelines(f1, [path_out_nir file_in_nir1]);
    writelines(f2, [path_out_nir file_in_nir2]);

    fprintf('--------------------------------- \r\n');
end
