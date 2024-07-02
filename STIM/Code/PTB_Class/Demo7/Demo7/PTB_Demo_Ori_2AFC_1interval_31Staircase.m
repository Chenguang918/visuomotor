function PTB_Demo_Ori_2AFC_1interval_31Staircase()
% 心理物理与Psychtoolbox编程演示程序
% 通过1个interval 2AFC的方法获得线段朝向辨别的心理测量曲线
% Coded by Y. Yan @ BNU 2018-04-15

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
    fStartSize = 10; %起始差别
    fStepSize = 0.5; %以对于缩小的补偿，每一次的刺激差别都乘以fStepSize
    fStimLength = 50; %刺激长度
    fStimWidth = 5; %刺激宽度
    clrStim = [127 127 127]; %刺激颜色
    % 时间和流程控制
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tStimOnsetDuraion = 0.1; %刺激出现的时间
    tISI = 0.3; % Inter Trial Interval
    TotalReversalNum = 10; %完成多少个reversal结束

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
    ConsecutiveCorrect = 0; %记录连续做对的次数
    AdjustDirection = 0; %记录当前调整任务难度的方向,1表示在变难，-1表示在变简单，0表示未知
    iReversalTime = 0; %记录发生反转的次数
    DeltaOri = fStartSize; %刺激距离垂直方向的差别，最开始设置为起始值
    iTrial = 0;
    while iReversalTime < TotalReversalNum
        iTrial = iTrial + 1;
        % 绘制刺激呈现前的注视点
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻

        % 绘制刺激
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %绘制注视点
        LorR = (rand>0.5)*2-1; %生成一个1或-1的，1表示刺激偏左，-1表示偏右
        Ori = fRefOri+DeltaOri*LorR; %得到当前trial随机生成的朝向
        DrawOrientedLine(wPtr, StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %绘制线段

        %呈现刺激和消失
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %刺激呈现，保留注视点
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %刺激消失，呈现保留的注视点
        
        %等待按键响应并记录数据
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).DeltaOri = DeltaOri;
        Data(iTrial).LorR = LorR;
        Data(iTrial).Keypress = find(keyCode);
        if (find(keyCode)==37 && LorR==1) || (find(keyCode)==39 && LorR==-1) %做对的trial
            ConsecutiveCorrect = ConsecutiveCorrect+1; %调整连续做对的trial数
            if ConsecutiveCorrect == 3 %如果连续作对3次就增加难度
                DeltaOri = DeltaOri*fStepSize;
                ConsecutiveCorrect = 0;
                if AdjustDirection < 0 %检测有没有发生反转，如果发生了记录反转数据
                    iReversalTime = iReversalTime+1;
                    Reversal(iReversalTime).DeltaOri = DeltaOri;
                    Reversal(iReversalTime).AdjustDirection = AdjustDirection;
                end
                AdjustDirection = 1;
            end
        elseif (find(keyCode)==37 && LorR==-1) || (find(keyCode)==39 && LorR==1) %做错的trial
            ConsecutiveCorrect = 0;
            DeltaOri = DeltaOri/fStepSize; %降低难度
            DeltaOri = min([DeltaOri 45]); %不要让DeltaOri超过45度
            if AdjustDirection > 0 %检测有没有发生反转，如果发生了记录反转数据
                iReversalTime = iReversalTime+1;
                Reversal(iReversalTime).DeltaOri = DeltaOri;
                Reversal(iReversalTime).AdjustDirection = AdjustDirection;
            end
            AdjustDirection = -1;
        elseif find(keyCode)==27 %ESC
            fprintf('实验人为终止');
            Screen('CloseAll');
            break;
        else %按了其他键
            %如果按错键了什么也不做
        end
        WaitSecs(tISI);
    end
    
    %% 保存数据
    tbData = struct2table(Data);
    writetable(tbData, strcat('Data_2AFC_Ori_',strSubjectName));
    tbReversal = struct2table(Reversal);
    writetable(tbReversal, strcat('Reversal_2AFC_Ori_',strSubjectName));
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