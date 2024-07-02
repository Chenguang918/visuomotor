function PTB_Demo_Ori_2AFC_1interval()
% 心理物理与Psychtoolbox编程演示程序
% 通过1个interval 2AFC的方法获得线段朝向辨别的心理测量曲线
% Coded by Y. Yan @ BNU 2018-04-02

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

    %% 参数设置部分
    % 被试信息
    strSubjectName = 'YanY';
    % 显示参数
    bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens')); %屏幕编号，注意此处MacOS和Windows不同
    HideCursor(nMonitorID); %隐藏指针
    clrBg = [50 50 50]; %指定背景颜色
    % 注视点参数
    fFpCrossLength = 10; %注视点十字的长度
    fFpCrossWidth = 3; %注视点十字线的粗细
    clrFpCross = [0 255 0]; %指定注视点颜色
    % 刺激参数
    StimXp = -100; %此处以屏幕中心为0
    StimYp = -100; %此处以屏幕中心为0, 向上为正
    fRefOri = 90; %变化朝向的基准值
    fLineOri = (-3:1:3)+fRefOri; %变化的线段朝向
    fStimLength = 50; %刺激长度
    fStimWidth = 5; %刺激宽度
    clrStim = [127 127 127]; %刺激颜色
    % 时间和流程控制
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tStimOnsetDuraion = 0.1; %刺激出现的时间
    tISI = 0.3; % Inter Trial Interval
    StimTrialNum = 50; %每个条件的trial数

    %% 随机生成刺激参数
    StimNum = numel(fLineOri); %得到刺激条件数
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
    
    for iTrial = 1:StimNum*StimTrialNum
        % 绘制刺激呈现前的注视点
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻

        % 绘制刺激
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %绘制注视点
        Ori = fLineOri(StimIDs(iTrial)); %得到当前trial随机生成的朝向
        DrawOrientedLine(wPtr, +StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %绘制线段

        %呈现刺激和消失
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %刺激呈现，保留注视点
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %刺激消失，呈现保留的注视点
        
        %等待按键响应并记录数据
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).StimID = StimIDs(iTrial);
        if find(keyCode)==37 %选左
            Data(iTrial).Resp = -1;
        elseif find(keyCode)==39 %选右
            Data(iTrial).Resp = 1;
        elseif find(keyCode)==27 %esc
            break
        else
            Data(iTrial).Resp = nan;
        end
        WaitSecs(tISI);
    end
    
    %% 保存数据
    tbData = struct2table(Data);
    writetable(tbData, strcat('Data_2AFC_Ori_',strSubjectName));
    
    %% 关闭窗口
    Screen('CloseAll');
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