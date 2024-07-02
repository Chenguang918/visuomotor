

% K-scores程序
% set-size one two three four five 
% Coded by DW. Li @ BNU 2018-04-17

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

    
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','CondtionType'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','Loadfour'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='D:\lidongwei\vWM_Precision\data\';
    
    % ------显示参数------
    bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens')); %屏幕编号
    HideCursor(nMonitorID); %隐藏指针
    clrBg = [130 130 130];  %指定背景颜色灰色
    
    % ------注视点参数------
    CrossLength = 10;    %注视点十字的长度
    CrossWidth = 3;      %注视点十字线的粗细
    clrCross = [0 0 0];   %指定注视点颜色为黑色
    
    % ------刺激参数------
    StimLength = 100; %刺激边长
    StimLbx = -350; %此处以屏幕中心为0, 向右为正，为刺激左下角的初始横坐标
    StimLby = -380; %此处以屏幕中心为0, 向右为正，为刺激左下角的初始纵坐标
    StimLocationx = (0:300:600)+StimLbx; %刺激左下角所有可能的横坐标
    StimLocationy = (0:220:660)+StimLby; %刺激左下角所有可能的纵坐标
    clrStim = [139 0 0; 0 0 139; 0 205 0; 205 205 0; 255 130 171; 155 48 255; 255 165 0; 0 0 0]; %刺激所有可能的8种颜色
    clrText = [255, 255, 255];           % white
  
    % ------时间和流程控制------
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tStimOnsetDuraion = 0.2; %刺激出现的时间
    tRentionDuraion = 0.9; %记忆保持时间
    tITI = 0.5 * rand; % Inter Trial Interval
    StimTrialNum = 100; %总的trial数
    response_interval = 3; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    %% 刺激呈现部分
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % 初始化屏幕并得到屏幕参数
    wPtr  = Screen('OpenWindow',nMonitorID-1, clrBg); %在指定的显示器打开刺激窗口
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
    
    % Introduction
    sttext = 'Welcome to our Experiment!';
    endtext = 'Congratulations! The exp has been finished!';
    tips = 'Press SPACE key to start if getting ready';
    font = 'Arial';
    fontsize = 30;
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, sttext, 2*xCenter/3, yCenter-50, clrText);
    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter , clrText);
    Screen('Flip', wPtr);
    WaitSecs(2);
 
    % 等待按键开始实验
    KbWait();
    
   %% Body Program 
   
   % ----------Load Two Condition ----------

   if strcmp(subinfo{8} , 'Loadtwo')
        for iTrial = 1:StimTrialNum
    
       % 随机生成刺激参数
        ClrChange_num=[1:2];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1为不变 -1为变           
            
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        tCross = GetSecs;
        
        % 绘制记忆刺激
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
        Locx = StimxIDs(1:2)'; %得到当前trial随机生成的位置横坐标
        Locy = StimyIDs(1:2)'; %得到当前trial随机生成的位置纵坐标
        ClrPreitem = StimClrIDs(1:2,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %刺激呈现，保留注视点
        tStim = GetSecs;
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        tDelayCross = GetSecs;
        
        % 绘制再认刺激
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = StimxIDs(1:2)'; %得到当前trial随机生成的位置横坐标
           Locy = StimyIDs(1:2)'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:2,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %选右
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
        % 绘制再认刺激       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = StimxIDs(1:2)'; %得到当前trial随机生成的位置横坐标
           Locy = StimyIDs(1:2)'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:2,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(3,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;
 
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
      %% 记录数据
       Data(iTrial).TrialNum = iTrial;
       Data(iTrial).Locx = Locx;
       Data(iTrial).Locy = Locy;
       Data(iTrial).PreColor = ClrPreitem;
       Data(iTrial).PostColor = ClrPostitem;
       Data(iTrial).tFixation = tCross;
       Data(iTrial).tStimulus = tStim;
       Data(iTrial).tDelayFixation = tDelayCross;
       Data(iTrial).tTestStimlus = tTestStim;
       Data(iTrial).tResponse = secs;
    end
        
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end
    
   
% ----------Load Four Condition ----------

   if strcmp(subinfo{8} , 'Loadfour')
       
        for iTrial = 1:StimTrialNum    
       % 随机生成刺激参数
        ClrChange_num=[1:4];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1为不变 -1为变           
            
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        tCross = GetSecs;

        % 绘制记忆刺激
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
        Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
        Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
        ClrPreitem = StimClrIDs(1:4,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %刺激呈现，保留注视点
        tStim = GetSecs;
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        tDelayCross = GetSecs;
        
        % 绘制再认刺激
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
           Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:4,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %选右
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
        % 绘制再认刺激       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
           Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:4,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(5,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;
 
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
      %% 记录数据
       Data(iTrial).TrialNum = iTrial;
       Data(iTrial).Locx = Locx;
       Data(iTrial).Locy = Locy;
       Data(iTrial).PreColor = ClrPreitem;
       Data(iTrial).PostColor = ClrPostitem;
       Data(iTrial).tFixation = tCross;
       Data(iTrial).tStimulus = tStim;
       Data(iTrial).tDelayFixation = tDelayCross;
       Data(iTrial).tTestStimlus = tTestStim;
       Data(iTrial).tResponse = secs;
    end
        
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end
   
   

  
   
%% ----------Load Six Condition ----------

   if strcmp(subinfo{8} , 'Loadsix')
       
        for iTrial = 1:StimTrialNum    
       % 随机生成刺激参数
        ClrChange_num=[1:3];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1为不变 -1为变           
            
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        tCross = GetSecs;

        % 绘制记忆刺激
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
        Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %得到当前trial随机生成的位置横坐标
        Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
        ClrPreitem = StimClrIDs(1:6,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %刺激呈现，保留注视点
        tStim = GetSecs;
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        tDelayCross = GetSecs;
        
        % 绘制再认刺激
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %得到当前trial随机生成的位置横坐标
           Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:6,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %选右
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
        % 绘制再认刺激       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %得到当前trial随机生成的位置横坐标
           Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:6,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(7,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           tTestStim = GetSecs;
 
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %等待按键响应并记录数据
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
        end
        
      %% 记录数据
       Data(iTrial).TrialNum = iTrial;
       Data(iTrial).Locx = Locx;
       Data(iTrial).Locy = Locy;
       Data(iTrial).PreColor = ClrPreitem;
       Data(iTrial).PostColor = ClrPostitem;
       Data(iTrial).tFixation = tCross;
       Data(iTrial).tStimulus = tStim;
       Data(iTrial).tDelayFixation = tDelayCross;
       Data(iTrial).tTestStimlus = tTestStim;
       Data(iTrial).tResponse = secs;
    end
        
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end
   
   
   
   


%% 用于绘制注视点的子函数
% function DrawCross(wPtr, x, y, length, width, color)
%     ptsCrossLines = [-length length 0 0; 0 0 -length length];
%     Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %在屏幕上画反锯齿线段
% end
% 
% 
% 
% 
% %% 用于绘制矩形刺激的子函数
% function DrawRect2% 

