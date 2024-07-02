function PTB_Demo_Ori_2AFC_1interval_UseLog()
% 心理物理与Psychtoolbox编程演示程序
% 通过1个interval 2AFC的方法获得线段朝向辨别的心理测量曲线
% Coded by Y. Yan @ BNU 2018-04-09

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

    %% 参数设置部分
    % 实验信息
    tTimeStamp = now; %记录实验开始的时间
    strStartTime = datestr(tTimeStamp); %将时间转换成标准字符串
    strSubjectName = 'YanYin';
    % 显示参数
    bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens')); %屏幕编号，注意此处MacOS和Windows不同
    HideCursor(nMonitorID); %隐藏指针
    clrBg = [50 50 50]; %指定背景颜色
    % 注视点参数
    fFpCrossLength = 10; %注视点十字的长度
    fFpCrossWidth = 3; %注视点十字线的粗细
    clrFpCross = [0 255 0]; %指定注视点颜色
    % 读取刺激参数
    tbStimParams = readtable('Parameters.xlsx');
    % 时间和流程控制
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tStimOnsetDuraion = 0.1; %刺激出现的时间
    tITI = 0.3; % Inter Trial Interval
    StimTrialNum = 50; %每个条件的trial数

    %% 随机生成刺激参数
    StimNum = size(tbStimParams,1); %得到刺激条件数
    StimIDs = mod(randperm(StimNum*StimTrialNum)-1,StimNum)+1; %生成多组1:StimNum的随机数

    %% 刺激呈现部分
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % 初始化屏幕并得到屏幕参数
    wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %在指定的显示器打开刺激窗口
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半

    % 等待按键开始实验
    KbWait();
    
    iFinishedTrialCount = 0; %为了确认程序是否顺利执行完毕，记录实际运行的trial数
    for iTrial = 1:StimNum*StimTrialNum
        % 得到当前trial的刺激参数
        StimXp = tbStimParams.StimXp(StimIDs(iTrial)); %此处以屏幕中心为0
        StimYp = tbStimParams.StimYp(StimIDs(iTrial)); %此处以屏幕中心为0, 向上为正
        Ori = tbStimParams.LineOri(StimIDs(iTrial)); %线段的朝向
        fStimLength = tbStimParams.StimLength(StimIDs(iTrial)); %刺激长度
        fStimWidth = tbStimParams.StimWidth(StimIDs(iTrial)); %刺激宽度
        clrStim = tbStimParams.StimColor(StimIDs(iTrial)); %刺激颜色
        
        % 绘制刺激呈现前的注视点
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻

        % 绘制刺激
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %绘制注视点
        DrawOrientedLine(wPtr, +StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %绘制线段

        %呈现刺激和消失
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %刺激呈现，保留注视点
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %刺激消失，呈现保留的注视点
        
        %等待按键响应并记录数据
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).StimID = StimIDs(iTrial);
        if find(keyCode)==37 %选左
            Data(iTrial).Resp = -1;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        elseif find(keyCode)==39 %选右
            Data(iTrial).Resp = 1;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        elseif find(keyCode)==27 %ESC
            fprintf('实验人为终止');
            Screen('CloseAll');
            break;
        else
            Data(iTrial).Resp = nan;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        end
        WaitSecs(tITI);
    end
    
    %% 关闭窗口
    Screen('CloseAll');  
    tEnd = now;
    %% 保存数据
    tbData = struct2table(Data);
    writetable(tbData, sprintf('Data_2AFC_Ori_%s_%.0f',strSubjectName,tTimeStamp*24*3600));
    
    %% 保存Log
    fpLog = fopen(sprintf('Data_2AFC_Ori_%s_%.0f.log',strSubjectName,tTimeStamp*24*3600),'w');
    
    fprintf(fpLog, '##### Global parameters #####\r\n');
    fprintf(fpLog, 'Start time: %s\r\n',strStartTime);
    fprintf(fpLog, 'Test duration: %.2f seconds\r\n',(tEnd - tTimeStamp)*24*3600);
    fprintf(fpLog, 'Subject Name: %s\r\n',strSubjectName);
    fprintf(fpLog, 'Total finished trial: %d\r\n',iFinishedTrialCount);
    fprintf(fpLog, 'Trial Number per Stim: %d\r\n',StimTrialNum);
    fprintf(fpLog, 'Skip Sync Test: %d\r\n',bSkipSyncTests);
    fprintf(fpLog, 'Background Color: %d %d %d\r\n',clrBg);
    fprintf(fpLog, 'Fp Cross Length: %.2f\r\n',fFpCrossLength);
    fprintf(fpLog, 'Fp Cross Width: %.2f\r\n',fFpCrossWidth);
    fprintf(fpLog, 'Background Color: %d %d %d\r\n',clrFpCross);
    
    fprintf(fpLog, '##### Timing parameters #####\r\n');
    fprintf(fpLog, 'Pre-stimlus blank time: %.2f\r\n',tPreFix);
    fprintf(fpLog, 'Stimlus onset duration: %.2f\r\n',tStimOnsetDuraion);
    fprintf(fpLog, 'Inter trial interval: %.2f\r\n',tITI);

    fprintf(fpLog, '##### Stimuli parameters #####\r\n');
    ParamNum = size(tbStimParams,2);
    ParamNames = tbStimParams.Properties.VariableNames;
    for iParam = 1:ParamNum
        fprintf(fpLog, '%s: ',ParamNames{iParam});
        for iStim = 1:StimNum
            fprintf(fpLog, '%.4f;',tbStimParams{iStim,iParam});
        end
        fprintf(fpLog, '\r\n');
    end
    
    fclose(fpLog);
end

%% 用于绘制注视点的子函数
function DrawFP(wPtr, x, y, length, width, color)
    ptsCrossLines = [-length length 0 0; 0 0 -length length];
    Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %在屏幕上画反锯齿线段
end

%% 用于绘制指定朝向线段的子函数
function DrawOrientedLine( wPtr, x, y, ori, length, width, color, center)
    oriRad = ori/180*pi; %将角度值转化成弧度
    fromH = round(x+cos(oriRad)*length/2); %计算起始点的横坐标
    toH = round(x-cos(oriRad)*length/2); %计算终止点的横坐标
    fromV = round(y-sin(oriRad)*length/2); %计算起始点的纵坐标，注意y轴正方向向下
    toV = round(y+sin(oriRad)*length/2); %计算终止点的纵坐标，注意y轴正方向向下
    Screen('DrawLines', wPtr, [fromH toH; fromV toV], width, color, center, 2);
end