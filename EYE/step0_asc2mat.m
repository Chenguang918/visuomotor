clc;clear;close all;

%% File path and name
path_in_eye = 'E:\Data\202305\EYE\0.asc\';
path_out_eye = 'E:\Data\202305\EYE\1.mat\';

%% Parameter
NSUB = 50;

%% Main
for isub = 1:NSUB
    %% Check existence of file and load data
    file_in_eye = ['sub' num2str(isub, '%d') '_1.asc' ];
    fprintf('[Sub %d] : ', isub);
    if ~exist([path_in_eye file_in_eye],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        continue;
    end

    %% Convert data ASCII to mat
    file_out_eye = ['sub' num2str(isub, '%d') '.mat' ];
    ET = parseeyelink([path_in_eye file_in_eye], [path_out_eye file_out_eye]);

    %% Get events from 'othermessages', only [number] type
    ievt = 1;
    event = [];
    for ii = 1:length(ET.othermessages)
        msg_txt = ET.othermessages(ii).msg;
        ispace = strfind(msg_txt, ' ');
        evt_type = str2num(msg_txt(ispace(1)+1:end));
        if ~isempty(evt_type)
            event(ievt,1) = ET.othermessages(ii).timestamp;
            event(ievt,2) = evt_type;
            ievt = ievt + 1;
        end
    end
    ET.event = event;

    %% Save again
    save([path_out_eye file_out_eye], '-struct', 'ET');
end

%% Done
load gong.mat;
sound(y);
