clc;clear;close all;

%% File path and name
path_in_beh = 'E:\Data\202305\BEH\0.crt\';
path_out_beh = 'E:\Data\202305\BEH\1.ren\';

%% Parameter
NSUB = 50;

%% Main
for isub = 1:NSUB
    %% Check existence of file and load data
    file_in_beh = ['FlyStim6_sub' num2str(isub) '_1_correct.mat'];
    fprintf('[Sub %d] : ', isub);
    if ~exist([path_in_beh file_in_beh],'file')
        fprintf(' <-- Skip !!!!!!!!!!!!!!!!! \r\n');
        continue;
    end
    load([path_in_beh file_in_beh]);

    %% Load BEH Data
    BEH.RTStart          = fidnew.RTStart;			%启动反应时	
    BEH.RTEnd            = fidnew.RTEnd;			%总反应时
    BEH.Duration	     = fidnew.Duration;		    %信念形成时
    BEH.ACC              = fidnew.ACC;				%正确错误
    BEH.Theta            = fidnew.Theta;			%偏差角度
    BEH.SOA              = fidnew.SOA;				%修正后SOA标签
    BEH.SOA_10Hz	     = fidnew.SOA_10Hz;		    %修正后SOA标签 重采样10Hz
    BEH.BlockX	         = fidnew.BlockX;			%确认按键时 坐标X
    BEH.BlockY	         = fidnew.BlockY;			%确认按键时 坐标Y
    BEH.Blockhit	     = fidnew.Blockhit;		    %行为反馈 击中
    BEH.Blockhighhit     = fidnew.Blockhighhit;	    %行为反馈 精确击中
    BEH.Blockmiss	     = fidnew.Blockmiss;		%行为反馈 漏掉
    BEH.Blockwrong	     = fidnew.Blockwrong;		%行为反馈 偏差过大
    BEH.BlockStiT	     = fidnew.BlockStiT;		%目标出现位置
    BEH.BlockTRespOnset	 = fidnew.BlockTRespOnset;	%按键的绝对时间（PC时钟）

    %% Save BEH Data
    file_out_beh = ['sub' num2str(isub) '.mat'];
    save([path_out_beh file_out_beh], '-struct', 'BEH', '-mat');
end

