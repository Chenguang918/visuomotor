

% K-scores程序
% set-size one two three four five 
% Coded by DW. Li @ BNU 2018-04-17

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    commandwindow;
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)
    rand('state',sum(100*clock));                                              % Initialize RAND to a different state each time.
    lptwrite(888, 0);
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','CondtionType'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','Loadfour'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    dataPath='E:\song\exp_stimul_TIBS\colortask\';
    %%
    subid_name_file=strcat('sub',subinfo{1},subinfo{2},subinfo{8});
    filepath=strcat(dataPath,'\experimentdata\subexpdata\','sub',subinfo{1},subinfo{7},subinfo{8},'\');
    if ~exist(filepath,'dir')
         mkdir(filepath);
    end
   filename=strcat(filepath,'\',subid_name_file);
    
    % ------显示参数------
    bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens')); %屏幕编号
    %HideCursor(nMonitorID-1); %隐藏指针
    distance = 50;         % distance between subject and monitor
    monitorwidth = 47.3;      % The width of the monitor
    clrBg = [130 130 130];  %指定背景颜色灰色
    
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);
    
    % 初始化屏幕并得到屏幕参数
    [wPtr , wRect]  = Screen('OpenWindow',nMonitorID-1, clrBg); % Open the stimulus window on the specified display
     Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree

    % ------注视点参数------
    CrossLength = 10;    %注视点十字的长度
    CrossWidth = 3;      %注视点十字线的粗细
    clrCross = [0 0 0];   %指定注视点颜色为黑色
    
    % ------线索参数------
    CenterLeftArrowxyLists = [-36,0;-20,12;-20,4;36,4;36,-4;-20,-4;-20,-12];    %左箭头坐标
    CenterRightArrowxyLists = [36,0;20,12;20,4;-36,4;-36,-4;20,-4;20,-12];    %右箭头坐标
    clrArrow = [0 0 0];  
    % ------刺激参数------
    StimLength = fix(2 * ppd);  %刺激边长
    StimLocationx = fix([-8 -5 3 6] * ppd) + xCenter; %刺激左下角所有可能的横坐标
    StimLocationy = fix([-6 -3 5 8] * ppd) + yCenter; %刺激左下角所有可能的纵坐标
    clrStim = [139 0 0; 0 0 139; 0 205 0; 205 205 0; 255 130 171; 155 48 255; 255 165 0; 0 0 0]; %刺激所有可能的8种颜色
    clrText = [255, 255, 255];           % white
  
    % ------时间和流程控制------
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tCueOnsetDuraion = 0.2; %线索出现的时间
    tStimOnsetDuraion = 0.1; %刺激出现的时间
    tRentionDuraion = 0.9; %记忆保持时间
    tITI = 0.5 * rand; % Inter Trial Interval
    StimTrialNum = 60; %总的trial数
    Blocknum = 4;
    response_interval = 3; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    %% 刺激呈现部分    
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
 

% Wait for the button to start experimenting
KbWait();

%┴┬┴┬／￣＼＿／￣＼
%┬┴┬┴▏    ▏▔▔▔▔＼
%┴┬┴／＼  ／            ﹨
%┬┴∕              ／      ）
%┴┬▏                ●    ▏
%┬┴▏                      ▔█
%┴◢██◣              ＼＿＿／
%┬█████◣              ／                                            MAIN PROGRAM IS COMMING !!!
%┴█████████████◣
%◢██████████████▆▄
%◢██████████████▆▄
%█◤◢██◣◥█████████◤＼
%◥◢████ ████████◤      ＼
%┴█████  ██████◤           ﹨
%┬│      │█████◤                ▏
%┴│      │                            ▏
%┬∕      ∕        ／▔▔▔＼         ∕
%*∕＿＿_／﹨      ∕           ＼    ／＼
%┬┴┬┴┬┴＼     ＼_        ﹨／        ﹨
%┴┬┴┬┴┬┴ ＼＿＿＿＼         ﹨／▔＼   ﹨／▔＼
%▲△▲▲╓╥╥╥╥╥╥╥╥＼      ∕    ／▔﹨  ／▔﹨

%% Body Program

% ----------Load Two Condition ----------

   if strcmp(subinfo{8} , 'Loadtwo')
       taskindex=1;
      for iBlock = 1:Blocknum       
        for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;    
       % 随机生成刺激参数
        ClrChange_num=[1:2];
        YStim = [-6 -3 5 8];
        StimyIDs = YStim(randperm(length(StimLocationy)));  
        while StimyIDs(1)*StimyIDs(2)>0
              StimyIDs = YStim(randperm(length(StimLocationy)));  
        end
        StimyIDs = fix(StimyIDs * ppd) + yCenter; 
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5);    % 1为不变 -1为变           
        Left_or_Right = (rand > 0.5) +1;    % 1为左 -1为右           
            
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        
        % 绘制箭头线索Cue
        if Left_or_Right ==1
        Screen('FillPoly',wPtr, clrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else
        Screen('FillPoly',wPtr, clrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        tCueOnset = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %呈现注视点，记录呈现时刻
        lptwrite(888, (taskindex-1)*100+Left_or_Right*10+1);
        WaitSecs(0.004);
        lptwrite(888, 0);
        % 绘制记忆刺激
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
        
        x=20*(rand(1,10)-0.5); %生成一列 -10到10的随机数
        dif=fix(x(1));         %对这列数的第一个取整
        dif2=fix(x(2));         %对这列数的第二个取整
        StimLocationx(1) = StimLocationx(1) - dif;
        StimLocationx(4) = StimLocationx(4) + dif;
        StimLocationx(2) = StimLocationx(2) - dif;
        StimLocationx(3) = StimLocationx(3) + dif;
        
        Locx = StimLocationx'; %得到当前trial随机生成的位置横坐标            
        Locy = [StimyIDs(1:2),StimyIDs(1:2)]'; %得到当前trial随机生成的位置纵坐标
        ClrPreitem = StimClrIDs(1:4,:)';
        DrawRect( wPtr, Locx, Locy, StimLength, ClrPreitem);
        
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %刺激呈现，保留注视点
        tStim = GetSecs;
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        tDelayCross = GetSecs;
        
        % 绘制再认刺激
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = StimLocationx'; %得到当前trial随机生成的位置横坐标            
           Locy = [StimyIDs(1:2),StimyIDs(1:2)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:4,:)';
           DrawRect( wPtr, Locx, Locy, StimLength, ClrPostitem);
           
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           lptwrite(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           lptwrite(888, 0);
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              res_trg=100; 
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2; 
              res_trg=99; 
              break
              else
              Data(totaltrialnum).Feedback = nan;
              Data(totaltrialnum).response = nan;
              Data(totaltrialnum).RTs = nan;
              res_trg=99;                     
              end
            end
                Screen('Flip', wPtr);           %呈现注视点  
                WaitSecs(tITI);
                 lptwrite(888, res_trg);
                WaitSecs(0.004);
                lptwrite(888, 0);
        end
        
        % 绘制再认刺激       
        if Change_or_not==0
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = StimLocationx'; %得到当前trial随机生成的位置横坐标            
           Locy = [StimyIDs(1:2),StimyIDs(1:2)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:4,:);
           if Left_or_Right ==1
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(5,:);
           else
           ClrPostitem(StimchangeClrnumIDs(1)+2,:) =  StimClrIDs(5,:);
           end
           ClrPostitem = ClrPostitem';
           DrawRect( wPtr, Locx, Locy, StimLength, ClrPostitem);
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
 
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;
                 res_trg=99;           
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
                 res_trg=100;            
                 break
              else
                 Data(totaltrialnum).Feedback = nan;
                 Data(totaltrialnum).response = nan;
                 Data(totaltrialnum).RTs = nan;
                 res_trg=99;   
              end
            end
                 Screen('Flip', wPtr);           %呈现注视点         
                 WaitSecs(tITI);
                 lptwrite(888, res_trg);
                WaitSecs(0.004);
                lptwrite(888, 0);
        end
        
      %% 记录数据
       Data(totaltrialnum).LorR = Left_or_Right;
       Data(totaltrialnum).ChangeorNot = Change_or_not;
       Data(totaltrialnum).TrialNum = totaltrialnum;
       Data(totaltrialnum).Locx = Locx;
       Data(totaltrialnum).Locy = Locy;
       Data(totaltrialnum).PreColor = ClrPreitem;
       Data(totaltrialnum).PostColor = ClrPostitem;
       Data(totaltrialnum).tResponse = secs;
        end
      end
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end

 
% ----------Load Four Condition ----------

   if strcmp(subinfo{8} , 'Loadfour')
       taskindex=2;
      for iBlock = 1:Blocknum       
        for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;    
       % 随机生成刺激参数
        ClrChange_num=[1:4];
%         StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5);    % 1为不变 -1为变           
        Left_or_Right = (rand > 0.5) +1;    % 1为左 -1为右           
            
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        
        % 绘制箭头线索Cue
        if Left_or_Right ==1
        Screen('FillPoly',wPtr, clrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else
        Screen('FillPoly',wPtr, clrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        tCueOnset = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %呈现注视点，记录呈现时刻
        lptwrite(888, (taskindex-1)*100+Left_or_Right*10+1);
        WaitSecs(0.004);
        lptwrite(888, 0);
        % 绘制记忆刺激
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
        
        x=20*(rand(1,10)-0.5); %生成一列 -10到10的随机数
        dif=fix(x(1));         %对这列数的第一个取整
        dif2=fix(x(2));         %对这列数的第二个取整
        StimLocationx1(1) = StimLocationx(1) - dif;
        StimLocationx1(4) = StimLocationx(4) + dif;
        StimLocationx1(2) = StimLocationx(2) - dif2;
        StimLocationx1(3) = StimLocationx(3) + dif2;
        
        dif3=fix(x(3));         %对这列数的第一个取整
        dif4=fix(x(4));         %对这列数的第二个取整
        StimLocationx2(1) = StimLocationx(1) - dif3;
        StimLocationx2(4) = StimLocationx(4) + dif3;
        StimLocationx2(2) = StimLocationx(2) - dif4;
        StimLocationx2(3) = StimLocationx(3) + dif4;
        
        Locx = [StimLocationx1,StimLocationx2]'; %得到当前trial随机生成的位置横坐标            
        Locy = [StimLocationy(2),StimLocationy(1),StimLocationy(1),StimLocationy(2),StimLocationy(3:4),StimLocationy(3:4)]'; %得到当前trial随机生成的位置纵坐标
        ClrPreitem = StimClrIDs(1:8,:)';
       
        DrawRect( wPtr, Locx, Locy, StimLength, ClrPreitem);
        
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %刺激呈现，保留注视点
        tStim = GetSecs;
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        tDelayCross = GetSecs;
        
        % 绘制再认刺激
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimLocationx,StimLocationx]'; %得到当前trial随机生成的位置横坐标            
           Locy = [StimLocationy(2),StimLocationy(1),StimLocationy(1),StimLocationy(2),StimLocationy(3:4),StimLocationy(3:4)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:8,:)';
           DrawRect( wPtr, Locx, Locy, StimLength, ClrPostitem);
           
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           lptwrite(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           lptwrite(888, 0);
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              res_trg=100;  
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              res_trg=99;  
              break
              else
              Data(totaltrialnum).Feedback = nan;
              Data(totaltrialnum).response = nan;
              Data(totaltrialnum).RTs = nan;
              res_trg=99;  
              end
            end
                 Screen('Flip', wPtr);           %呈现注视点 
                 WaitSecs(tITI);
                 lptwrite(888, res_trg);
                 WaitSecs(0.004);
                 lptwrite(888, 0);
        end
        
        % 绘制再认刺激       
        if Change_or_not==0
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
           Locx = [StimLocationx,StimLocationx]'; %得到当前trial随机生成的位置横坐标            
           Locy = [StimLocationy(2),StimLocationy(1),StimLocationy(1),StimLocationy(2),StimLocationy(3:4),StimLocationy(3:4)]'; %得到当前trial随机生成的位置纵坐标
           ClrPostitem = StimClrIDs(1:8,:);
           if Left_or_Right ==1
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(5,:);
           else
           ClrPostitem(StimchangeClrnumIDs(1)+4,:) =  StimClrIDs(8,:); % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           end
           ClrPostitem = ClrPostitem';
           DrawRect( wPtr, Locx, Locy, StimLength, ClrPostitem);
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           lptwrite(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           lptwrite(888, 0);
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;   
                               res_trg=99;  
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;  
                               res_trg=100;  
                 break
              else
                 Data(totaltrialnum).Feedback = nan;
                 Data(totaltrialnum).response = nan;
                 Data(totaltrialnum).RTs = nan;
                               res_trg=99;  
                            
              end
            end
                Screen('Flip', wPtr);           %呈现注视点
                 WaitSecs(tITI);
                 lptwrite(888, res_trg);
                 WaitSecs(0.004);
                 lptwrite(888, 0);
        end
        
      %% 记录数据
       Data(totaltrialnum).LorR = Left_or_Right;
       Data(totaltrialnum).ChangeorNot = Change_or_not;
       Data(totaltrialnum).TrialNum = totaltrialnum;
       Data(totaltrialnum).Locx = Locx;
       Data(totaltrialnum).Locy = Locy;
       Data(totaltrialnum).PreColor = ClrPreitem;
       Data(totaltrialnum).PostColor = ClrPostitem;
       Data(totaltrialnum).tResponse = secs;
        end
      end
     
    %% 关闭窗口
     Screen('CloseAll');        
 end
    
%    
% % ----------Load Four Condition ----------
% 
%    if strcmp(subinfo{8} , 'Loadfour')
%        
%         for iTrial = 1:StimTrialNum    
%        % 随机生成刺激参数
%         ClrChange_num=[1:4];
%         StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
%         StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
%         StimClrIDs = clrStim(randperm(length(clrStim)),:);     
%         StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
%         Change_or_not = (rand > 0.5) * 2 - 1;    % 1为不变 -1为变           
%             
%         % 绘制刺激呈现前的注视点
%         DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
%         tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
%         tCross = GetSecs;
% 
%         % 绘制记忆刺激
%         DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
%         Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
%         Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
%         ClrPreitem = StimClrIDs(1:4,:)';
%         DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
%         
%         %呈现记忆刺激
%         tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %刺激呈现，保留注视点
%         tStim = GetSecs;
%         
%         % 绘制记忆刺激呈现后的注视点
%         Screen('FillRect', wPtr, clrBg);
%         DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
%         tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
%         tDelayCross = GetSecs;
%         
%         % 绘制再认刺激
%         if Change_or_not==1
%            DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
%            Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
%            Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
%            ClrPostitem = StimClrIDs(1:4,:)';
%            DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
%            
%            %呈现再认刺激
%            tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
%            tTestStim = GetSecs;
% 
%            %绘制注视点           
%            Screen('FillRect', wPtr, clrBg);
%            DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
%            
%            %等待按键响应并记录数据
%             while GetSecs - tTestStim <= response_interval
%               [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
%               Data(iTrial).RTs = secs - tTestStimOnsetTime;
%               Data(iTrial).Answer = 1;          
%               if find(keyCode)== leftkey %选左
%               Data(iTrial).Feedback = 1;
%               Data(iTrial).response = 1;
%               break
%               elseif find(keyCode)== rightkey %选右
%               Data(iTrial).Feedback = 0;
%               Data(iTrial).response = 2;
%               break
%               else
%               Data(iTrial).Feedback = nan;
%               Data(iTrial).response = nan;
%               Data(iTrial).RTs = nan;
%               end
%             end
%             Screen('Flip', wPtr);           %呈现注视点           
%             WaitSecs(tITI);
%         end
%         
%         % 绘制再认刺激       
%         if Change_or_not==-1
%            DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %绘制注视点
%            Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %得到当前trial随机生成的位置横坐标
%            Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %得到当前trial随机生成的位置纵坐标
%            ClrPostitem = StimClrIDs(1:4,:);
%            ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(5,:);
%            ClrPostitem = ClrPostitem';
%            DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
%         
%            %呈现再认刺激
%            tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
%            tTestStim = GetSecs;
%  
%            %绘制注视点           
%            Screen('FillRect', wPtr, clrBg);
%            DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
%         
%            %等待按键响应并记录数据
%             while GetSecs - tTestStim <= response_interval
%               [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
%               Data(iTrial).RTs = secs - tTestStimOnsetTime;
%               Data(iTrial).Answer = 2;          
%               if find(keyCode) == leftkey %选左
%                  Data(iTrial).Feedback = 0;
%                  Data(iTrial).response = 1;
%                  break
%               elseif find(keyCode) == rightkey %选右
%                  Data(iTrial).Feedback = 1;
%                  Data(iTrial).response = 2;
%                  break
%               else
%                  Data(iTrial).Feedback = nan;
%                  Data(iTrial).response = nan;
%                  Data(iTrial).RTs = nan;
%               end
%             end
%             Screen('Flip', wPtr);           %呈现注视点           
%             WaitSecs(tITI);
%         end
%         
%       %% 记录数据
%        Data(iTrial).TrialNum = iTrial;
%        Data(iTrial).Locx = Locx;
%        Data(iTrial).Locy = Locy;
%        Data(iTrial).PreColor = ClrPreitem;
%        Data(iTrial).PostColor = ClrPostitem;
%        Data(iTrial).tFixation = tCross;
%        Data(iTrial).tStimulus = tStim;
%        Data(iTrial).tDelayFixation = tDelayCross;
%        Data(iTrial).tTestStimlus = tTestStim;
%        Data(iTrial).tResponse = secs;
%     end
%         
%     %% 保存数据
%      behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
%      save([path,behaviordataname],'Data');
%      
%     %% 关闭窗口
%      Screen('CloseAll');        
%    end
%    
   
behaviordataname=strcat(filename,'.mat');
save(behaviordataname,'subinfo','Data');   





