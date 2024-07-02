function [t, d, SD, s, ml, aux] = fun_Hitachi_2_Homer_v3(path_in, file_in, file_pos)
%% Version 3 update: channels and wavelengths are re-ordered such that they
% are in the order Homer2 software expects.
% User choice to remove marker at end of stimulus as this is not needed in
% Homer. Thanks to Ian Wiggins for your assistance with Version 3 edits.
% Rebecca S Dewey 29th July 2014

%% Revision update: stimulus markers are now read into the "aux" variable
% Rebecca S Dewey 10th December 2012

% Selects and reads in the data file.
%% [filen, pathn] = uigetfile('*.csv','Select the raw probe data file');
path_file_n = [path_in file_in];
if file_in(1) == 0 | path_in(1) == 0
    return;
end
fid = fopen(path_file_n);
fprintf('Loading data...  ');
while 1
    tline = fgetl(fid);

    if isempty(strfind(tline, 'Mode')) == 0
        rindex = find(tline == ',');
        tline(rindex) = ' ';
        text_array = tline(rindex(1)+1:end);
    end
    if isempty(strfind(tline, 'Wave[nm]')) == 0
        windex = find(tline == ',');
        tline(windex) = ' ';
        text_lambda = tline(windex(1)+1:end);
        wavelengths = str2num(text_lambda);
    end
    if isempty(strfind(tline, 'Sampling Period[s]')) == 0
        nindex = find(tline == ',');
        tline(nindex) = ' ';
        txt_fs = tline(nindex(1)+1:end);
        fs = 1./mean(str2num(txt_fs));
    end
    
    if isempty(strfind(tline, 'Data')) == 0
        tline = fgetl(fid);
        nch = length(strfind(tline, 'CH'));
        nindex = find(tline == ',');
        try
            col_mark = strfind(tline, 'Mark');
            col_mark = col_mark(1);
            col_mark = find(nindex == col_mark - 1) + 1;
        end
        try
            col_prescan = strfind(tline, 'PreScan');
            col_prescan = col_prescan(1);
            col_prescan = find(nindex == col_prescan - 1)+1;
        end
        while 1
            tline = fgetl(fid);
            if ischar(tline) == 0, break, end,
            nindex = find(tline == ',');
            tline_data = tline(nindex(1)+1:nindex(nch+1)-1);
            nindex_d = find(tline_data == ',');
            tline_data(nindex_d) = ' ';
            tline_data = str2num(tline_data);
            count = str2num(tline(1:nindex(1)-1));
            nirs_data.rawData(count, :) = tline_data;
            try
                vector_onset(count) = str2num(tline(nindex(col_mark-1)+1:nindex(col_mark)-1));
            end
            try
                baseline(count) = str2num(tline(nindex(col_prescan-1)+1:nindex(col_prescan)-1));
            end
        end
        break;
    end
end

fprintf('Data loaded... Getting more information...  ');
% Asks if you want to remove the marker at the end of the stimulus (i.e. if you 
% have a block design and your stimuli are marked at both beginning and end (as 
% is required by the ETG4000) rather than just at the beginning (as is required
% by HomER2. To hard-code this, replace the next line with offset = 'y' or 'n'.
%% offset = input('Do you want to remove the marker at the end of each stimulus? y/n:    ','s');
offset = 'n';
%% 
% Constructs the arrays that are required in the .nirs file
t = transpose((0:count-1)*(1/fs));
d = nirs_data.rawData;
SD.Lambda = transpose(wavelengths);
SD.MeasList = [];

% Input source / detector configuration using 3D digitiser file
% This will read the optode configuration "Mode" from the .csv file and follow 
% the respective arrangement in creating the MeasList array.
%% modeinstruct = ['Please choose ', text_array, ' position file'];
%% [posfilename,pospath] = uigetfile('*.pos',modeinstruct);
%% channel_pos = importdata(strcat(pospath,posfilename));
channel_pos = importdata(file_pos);
%%
channel_pos_tmp = char(channel_pos);
array_options = ['3x3', '3x5', '4x4'];
text_array = strip(text_array,' ');
if strcmp(text_array, '3x3')|strcmp(text_array, '3x5')|strcmp(text_array, '4x4')
else
    disp('1. Two 3x3 optode arrays');
    disp('2. One 3x5 optode array');
    disp('3. One 4x4 optode array');
    shape = input('Please enter number of optode array shape: ');
    switch(shape)
        case 1
            text_array = '3x3';
        case 2
            text_array = '3x5';
        case 3
            text_array = '4x4';
    end
end
% Calculation of MeasList for two 3x3 optode arrays
if strcmp('3x3', text_array)
    names = {'[LeftEar]','[RightEar]','[Nasion]','[Back]','[Top]',...
        '[Probe1-ch1]','[Probe1-ch2]','[Probe1-ch3]','[Probe1-ch4]',...
        '[Probe1-ch5]','[Probe1-ch6]','[Probe1-ch7]','[Probe1-ch8]',...
        '[Probe1-ch9]','[Probe1-ch10]','[Probe1-ch11]','[Probe1-ch12]',...
        '[Probe1-ch13]','[Probe1-ch14]','[Probe1-ch15]','[Probe1-ch16]',...
        '[Probe1-ch17]','[Probe1-ch18]'};
    optodes = 18;
    x = zeros(optodes,1);
    y = zeros(optodes,1);
    z = zeros(optodes,1);
    for i=1:optodes
        ind = find(strcmp(channel_pos,names{i+5}));
        x(i) = str2num(channel_pos_tmp(ind+1,3:end));
        y(i) = str2num(channel_pos_tmp(ind+2,3:end));
        z(i) = str2num(channel_pos_tmp(ind+3,3:end));
    end
    SD.nSrcs = 10;
    SD.nDets = 8;
    SD.SrcPos = [x(1), y(1), z(1); x(3), y(3), z(3); x(5), y(5), z(5); x(7), y(7), z(7);...
        x(9), y(9), z(9); x(10), y(10), z(10); x(12), y(12), z(12); x(14), y(14), z(14);...
        x(16), y(16), z(16); x(18), y(18), z(18)];
    SD.DetPos = [x(2), y(2), z(2); x(4), y(4), z(4); x(6), y(6), z(6); x(8), y(8), z(8);...
        x(11), y(11), z(11); x(13), y(13), z(13); x(15), y(15), z(15); x(17), y(17), z(17)];
    SD.MeasList(1,:) =  [1 1 1 1];
    SD.MeasList(2,:) =  [1 1 1 2];
    SD.MeasList(3,:) =  [2 1 1 1];
    SD.MeasList(4,:) =  [2 1 1 2];
    SD.MeasList(5,:) =  [1 2 1 1];
    SD.MeasList(6,:) =  [1 2 1 2];
    SD.MeasList(7,:) =  [3 1 1 1];
    SD.MeasList(8,:) =  [3 1 1 2];
    SD.MeasList(9,:) =  [2 3 1 1];
    SD.MeasList(10,:) = [2 3 1 2];
    SD.MeasList(11,:) = [3 2 1 1];
    SD.MeasList(12,:) = [3 2 1 2];
    SD.MeasList(13,:) = [3 3 1 1];
    SD.MeasList(14,:) = [3 3 1 2];
    SD.MeasList(15,:) = [4 2 1 1];
    SD.MeasList(16,:) = [4 2 1 2];
    SD.MeasList(17,:) = [3 4 1 1];
    SD.MeasList(18,:) = [3 4 1 2];
    SD.MeasList(19,:) = [5 3 1 1];
    SD.MeasList(20,:) = [5 3 1 2];
    SD.MeasList(21,:) = [4 4 1 1];
    SD.MeasList(22,:) = [4 4 1 2];
    SD.MeasList(23,:) = [5 4 1 1];
    SD.MeasList(24,:) = [5 4 1 2];
    SD.MeasList(25,:) = [6 5 1 1];
    SD.MeasList(26,:) = [6 5 1 2];
    SD.MeasList(27,:) = [7 5 1 1];
    SD.MeasList(28,:) = [7 5 1 2];
    SD.MeasList(29,:) = [6 6 1 1];
    SD.MeasList(30,:) = [6 6 1 2];
    SD.MeasList(31,:) = [8 5 1 1];
    SD.MeasList(32,:) = [8 5 1 2];
    SD.MeasList(33,:) = [7 7 1 1];
    SD.MeasList(34,:) = [7 7 1 2];
    SD.MeasList(35,:) = [8 6 1 1];
    SD.MeasList(36,:) = [8 6 1 2];
    SD.MeasList(37,:) = [8 7 1 1];
    SD.MeasList(38,:) = [8 7 1 2];
    SD.MeasList(39,:) = [9 6 1 1];
    SD.MeasList(40,:) = [9 6 1 2];
    SD.MeasList(41,:) = [8 8 1 1];
    SD.MeasList(42,:) = [8 8 1 2];
    SD.MeasList(43,:) = [10 7 1 1];
    SD.MeasList(44,:) = [10 7 1 2];
    SD.MeasList(45,:) = [9 8 1 1];
    SD.MeasList(46,:) = [9 8 1 2];
    SD.MeasList(47,:) = [10 8 1 1];
    SD.MeasList(48,:) = [10 8 1 2];

% Calculation of MeasList for one 3x5 optode array
elseif strcmp('3x5', text_array)
    names = {'[LeftEar]','[RightEar]','[Nasion]','[Back]','[Top]',...
        '[Probe1-ch1]','[Probe1-ch2]','[Probe1-ch3]','[Probe1-ch4]',...
        '[Probe1-ch5]','[Probe1-ch6]','[Probe1-ch7]','[Probe1-ch8]',...
        '[Probe1-ch9]','[Probe1-ch10]','[Probe1-ch11]','[Probe1-ch12]',...
        '[Probe1-ch13]','[Probe1-ch14]','[Probe1-ch15]'};
    optodes = 15;
    x = zeros(optodes,1);
    y = zeros(optodes,1);
    z = zeros(optodes,1);
    for i=1:optodes
        ind = find(strcmp(channel_pos,names{i+5}));
        x(i) = str2num(channel_pos_tmp(ind+1,3:end));
        y(i) = str2num(channel_pos_tmp(ind+2,3:end));
        z(i) = str2num(channel_pos_tmp(ind+3,3:end));
    end
    SD.nSrcs = 8;
    SD.nDets = 7;
    SD.SrcPos = [x(1), y(1), z(1); x(3), y(3), z(3); x(5), y(5), z(5); x(7), y(7), z(7);...
        x(9), y(9), z(9); x(11), y(11), z(11); x(13), y(13), z(13); x(15), y(15), z(15)];
    SD.DetPos = [x(2), y(2), z(2); x(4), y(4), z(4); x(6), y(6), z(6); x(8), y(8), z(8);...
        x(10), y(10), z(10); x(12), y(12), z(12); x(14), y(14), z(14)];
    SD.MeasList(1,:) =  [1 1 1 1];
    SD.MeasList(2,:) =  [1 1 1 2];
    SD.MeasList(3,:) =  [2 1 1 1];
    SD.MeasList(4,:) =  [2 1 1 2];
    SD.MeasList(5,:) =  [2 2 1 1];
    SD.MeasList(6,:) =  [2 2 1 2];
    SD.MeasList(7,:) =  [3 2 1 1];
    SD.MeasList(8,:) =  [3 2 1 2];
    SD.MeasList(9,:) =  [1 3 1 1];
    SD.MeasList(10,:) = [1 3 1 2];
    SD.MeasList(11,:) = [4 1 1 1];
    SD.MeasList(12,:) = [4 1 1 2];
    SD.MeasList(13,:) = [2 4 1 1];
    SD.MeasList(14,:) = [2 4 1 2];
    SD.MeasList(15,:) = [5 2 1 1];
    SD.MeasList(16,:) = [5 2 1 2];
    SD.MeasList(17,:) = [3 5 1 1];
    SD.MeasList(18,:) = [3 5 1 2];
    SD.MeasList(19,:) = [4 3 1 1];
    SD.MeasList(20,:) = [4 3 1 2];
    SD.MeasList(21,:) = [4 4 1 1];
    SD.MeasList(22,:) = [4 4 1 2];
    SD.MeasList(23,:) = [5 4 1 1];
    SD.MeasList(24,:) = [5 4 1 2];
    SD.MeasList(25,:) = [5 5 1 1];
    SD.MeasList(26,:) = [5 5 1 2];
    SD.MeasList(27,:) = [6 3 1 1];
    SD.MeasList(28,:) = [6 3 1 2];
    SD.MeasList(29,:) = [4 6 1 1];
    SD.MeasList(30,:) = [4 6 1 2];
    SD.MeasList(31,:) = [7 4 1 1];
    SD.MeasList(32,:) = [7 4 1 2];
    SD.MeasList(33,:) = [5 7 1 1];
    SD.MeasList(34,:) = [5 7 1 2];
    SD.MeasList(35,:) = [8 5 1 1];
    SD.MeasList(36,:) = [8 5 1 2];
    SD.MeasList(37,:) = [6 6 1 1];
    SD.MeasList(38,:) = [6 6 1 2];
    SD.MeasList(39,:) = [7 6 1 1];
    SD.MeasList(40,:) = [7 6 1 2];
    SD.MeasList(41,:) = [7 7 1 1];
    SD.MeasList(42,:) = [7 7 1 2];
    SD.MeasList(43,:) = [8 7 1 1];
    SD.MeasList(44,:) = [8 7 1 2];

% Calculation of MeasList for one 4x4 array
elseif strcmp('4x4', text_array)
    names = {'[LeftEar]','[RightEar]','[Nasion]','[Back]','[Top]',...
        '[Probe1-ch1]','[Probe1-ch2]','[Probe1-ch3]','[Probe1-ch4]',...
        '[Probe1-ch5]','[Probe1-ch6]','[Probe1-ch7]','[Probe1-ch8]',...
        '[Probe1-ch9]','[Probe1-ch10]','[Probe1-ch11]','[Probe1-ch12]',...
        '[Probe1-ch13]','[Probe1-ch14]','[Probe1-ch15]','[Probe1-ch16]'};
    optodes = 16;
    x = zeros(optodes,1);
    y = zeros(optodes,1);
    z = zeros(optodes,1);
    for i=1:optodes
        ind = find(strcmp(channel_pos,names{i+5}));
        x(i) = str2num(channel_pos_tmp(ind+1,3:end));
        y(i) = str2num(channel_pos_tmp(ind+2,3:end));
        z(i) = str2num(channel_pos_tmp(ind+3,3:end));
    end
    SD.nSrcs = 8;
    SD.nDets = 8;
    SD.SrcPos = [x(1), y(1), z(1); x(3), y(3), z(3); x(6), y(6), z(6); x(8), y(8), z(8);...
        x(9), y(9), z(9); x(11), y(11), z(11); x(14), y(14), z(14); x(16), y(16), z(16)];
    SD.DetPos = [x(2), y(2), z(2); x(4), y(4), z(4); x(5), y(5), z(5); x(7), y(7), z(7);...
        x(10), y(10), z(10); x(12), y(12), z(12); x(13), y(13), z(13); x(15), y(15), z(15)];
    SD.MeasList(1,:) =  [1 1 1 1];
    SD.MeasList(2,:) =  [1 1 1 2];
    SD.MeasList(3,:) =  [2 1 1 1];
    SD.MeasList(4,:) =  [2 1 1 2];
    SD.MeasList(5,:) =  [2 2 1 1];
    SD.MeasList(6,:) =  [2 2 1 2];
    SD.MeasList(7,:) =  [1 3 1 1];
    SD.MeasList(8,:) =  [1 3 1 2];
    SD.MeasList(9,:) =  [3 1 1 1];
    SD.MeasList(10,:) = [3 1 1 2];
    SD.MeasList(11,:) = [2 4 1 1];
    SD.MeasList(12,:) = [2 4 1 2];
    SD.MeasList(13,:) = [4 2 1 1];
    SD.MeasList(14,:) = [4 2 1 2];
    SD.MeasList(15,:) = [3 3 1 1];
    SD.MeasList(16,:) = [3 3 1 2];
    SD.MeasList(17,:) = [3 4 1 1];
    SD.MeasList(18,:) = [3 4 1 2];
    SD.MeasList(19,:) = [4 4 1 1];
    SD.MeasList(20,:) = [4 4 1 2];
    SD.MeasList(21,:) = [5 3 1 1];
    SD.MeasList(22,:) = [5 3 1 2];
    SD.MeasList(23,:) = [3 5 1 1];
    SD.MeasList(24,:) = [3 5 1 2];
    SD.MeasList(25,:) = [6 4 1 1];
    SD.MeasList(26,:) = [6 4 1 2];
    SD.MeasList(27,:) = [4 6 1 1];
    SD.MeasList(28,:) = [4 6 1 2];
    SD.MeasList(29,:) = [5 5 1 1];
    SD.MeasList(30,:) = [5 5 1 2];
    SD.MeasList(31,:) = [6 5 1 1];
    SD.MeasList(32,:) = [6 5 1 2];
    SD.MeasList(33,:) = [6 6 1 1];
    SD.MeasList(34,:) = [6 6 1 2];
    SD.MeasList(35,:) = [5 7 1 1];
    SD.MeasList(36,:) = [5 7 1 2];
    SD.MeasList(37,:) = [7 5 1 1];
    SD.MeasList(38,:) = [7 5 1 2];
    SD.MeasList(39,:) = [6 8 1 1];
    SD.MeasList(40,:) = [6 8 1 2];
    SD.MeasList(41,:) = [8 6 1 1];
    SD.MeasList(42,:) = [8 6 1 2];
    SD.MeasList(43,:) = [7 7 1 1];
    SD.MeasList(44,:) = [7 7 1 2];
    SD.MeasList(45,:) = [7 8 1 1];
    SD.MeasList(46,:) = [7 8 1 2];
    SD.MeasList(47,:) = [8 8 1 1];
    SD.MeasList(48,:) = [8 8 1 2];
end

% Sort SD.MeasList by lambda
[SD.MeasList, I] = sortrows(SD.MeasList,4);                             % Version 3

% Re-arrange the measurement signals in the data matrix accordingly
d = d(:,I);                                                             % Version 3

% Reading vector of stimulus markers and arranging this into the format
% required by Homer2 and storing in the variable "aux"
markertimes = [find(vector_onset>0) find(vector_onset<0)];
markers = vector_onset(markertimes);
unique_markers = unique(markers);
aux = zeros(count, length(unique_markers));
for stimuli=1:length(unique_markers)
    if offset == 'y' || offset == 'Y'                                   % Version 3
        stim_on_off = find(vector_onset==(unique_markers(stimuli)));    % Version 3
        stim_markers = stim_on_off(1:2:length(stim_on_off)-1);          % Version 3
        aux(stim_markers,stimuli) = 1;                                  % Version 3
    else                                                                % Version 3
        stim_markers = find(vector_onset==(unique_markers(stimuli)));
        aux(stim_markers,stimuli) = 1;
    end                                                                 % Version 3
end
ml = SD.MeasList;

% As the stimulus markers are stored in "aux", the stimulus matrix "s" still
% needs to be created. This is set to zeroes for now.
s = zeros(size(t));

% Finished rearranging information...
fprintf(' Saving...  ');
%% save(strcat(path_out, file_out),'t', 'd', 'SD', 's', 'ml', 'aux');

fprintf('Done!\r\n');
