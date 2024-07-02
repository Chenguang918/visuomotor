

% Change detection 实验程序
% set-size two four 
% Coded by DW. Li @ BNU 2020-07-28

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

    
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Eyesight','BenefitedHand','CueColor','CondtionType','Times'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','right','Blue','Loadfour','first'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='E:\Song\Song\ldw\Data\';
    
    % ------显示参数------
    bSkipSyncTests = 0; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens'))-1; %屏幕编号
    HideCursor(nMonitorID); %隐藏指针
    distance = 100;         % distance between subject and monitor
    monitorwidth = 40;      % The width of the monitor
    clrBg = [130 130 130];  %指定背景颜色灰色
    
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);
    
    % 初始化屏幕并得到屏幕参数
    [wPtr , wRect]  = Screen('OpenWindow',nMonitorID, clrBg); % Open the stimulus window on the specified display
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree

    % ------注视点参数------
    AngleFix = 0.2;
    Fixcir_size = fix(AngleFix * ppd);      %注视点的粗细
    center = [xCenter-Fixcir_size, yCenter-Fixcir_size,xCenter+Fixcir_size, yCenter+Fixcir_size]';
    clrCross = [0 0 0];   %指定注视点颜色为黑色
    
    % ------线索参数------
    AngleArrowCue = fix(1.2 * ppd);
    CenterLeftArrowxyLists = [-AngleArrowCue,0;0,AngleArrowCue/2;0,-AngleArrowCue/2];    %左箭头坐标
    CenterRightArrowxyLists = [AngleArrowCue,0;0,AngleArrowCue/2;0,-AngleArrowCue/2];    %右箭头坐标
    if strcmp(subinfo{7} , 'Blue')
       TclrArrow = [21 165 234];  % 目标的颜色线索
       DclrArrow = [133 194 18];  % 无关的颜色线索
    else
       TclrArrow = [133 194 18];  % 目标的颜色线索
       DclrArrow = [21 165 234];  % 无关的颜色线索
    end
    
    % ------刺激参数------
    AngStimBar_length = 2.4; %刺激视角
    StimBar_length = AngStimBar_length * ppd;
    AngStimBar_width = 0.4;
    WideBar = AngStimBar_width * ppd;
    BarOri = [16, 36, 56, 76, 96, 116, 136, 156, 176]; %刺激所有可能的9种朝向
    clrStim = [255, 0, 0];           % Red
    load([path,'sub',subinfo{1},'_triallists.mat'])
    
    % ------时间和流程控制------
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tCueOnsetDuraion = 0.3; %线索出现的时间
    tStimOnsetDuraion = 0.2; %刺激出现的时间
    tRentionDuraion = 1; %记忆保持时间
    tITI = 0.3 * rand; % Inter Trial Interval
    StimTrialNum = 48; % 每个block的trial数
    Blocknum = 6;
    response_interval = 3; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------trigger定义------
    %NetStation('Connect', '10.10.10.42');
    %NetStation('Synchronize');

    MarkerLoadTwoBlockBegin = 1;   MarkerLoadTwoBlockEnd = 2;   MarkerLoadFourBlockBegin = 3;   MarkerLoadFourBlockEnd = 4;
    MarkerCorrectResponse = 100;   MarkerWrongResponse = 99;   MarkerNoResponse = 999;
    MarkerLowloadTestLeftNochange = 111;   MarkerLowloadTestLeftChange = 112;    MarkerLowloadTestRightNochange = 121;    MarkerLowloadTestRightChange = 122;
    MarkerHighloadTestLeftNochange = 211;    MarkerHighloadTestLeftChange = 212;    MarkerHighloadTestRightNochange = 221;    MarkerHighloadTestRightChange = 222;
    MarkerLowloadLeftcue = 101;   MarkerLowloadRightcue = 102;    MarkerHighloadLeftcue = 201;    MarkerHighloadRightcue = 202;
    MarkerLowloadLeftMemory = 11;   MarkerLowloadRightMemory = 12;    MarkerHighloadLeftMemory = 21;    MarkerHighloadRightMemory = 22;
    MarkerPreCueFixation = 254;   MarkerPostMemoryFixation = 253;
    

    % ------trial 顺序------
    StimIDs = [111,112,113,121,122,123,211,212,213,221,222,223]; %生成多组1:StimNum的数 第一位左/右 第二位不变/变
    StimIDs = repmat(StimIDs,1,StimTrialNum*Blocknum/length(StimIDs));
    StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %进行随机化

    %% 刺激呈现部分    
    % Introduction
    sttext = 'Welcome to our Experiment!';
    endtext = 'Congratulations! The exp has been finished!';
    tips = 'Press SPACE key to start if getting ready';
    resttext = 'Take a rest!';
    font = 'Arial';
    fontsize = 30;
    clrText = [0 0 0];
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, sttext, 2*xCenter/3, yCenter-50, clrText);
    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter , clrText);
    Screen('Flip', wPtr);
    %NetStation('StartRecording');
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

      for iBlock = 1:Blocknum
         %NetStation('Event', num2str(MarkerLoadTwoBlockBegin));
       for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % 绘制刺激呈现前的注视点
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        %NetStation('Event', num2str(MarkerPreCueFixation), tFixOnset, 0.001);
        
        % 绘制箭头线索Cue
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
        Screen('FillPoly',wPtr, TclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else  % cue right
        Screen('FillPoly',wPtr, TclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);            
        end
        tCueOnset = Screen('Flip', wPtr, tFixOnset + tPreFix + tITI - slack); %呈现注视点，记录呈现时刻
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerLowloadLeftcue), tCueOnset, 0.001);
        else
           %NetStation('Event', num2str(MarkerLowloadRightcue), tCueOnset, 0.001);
        end
            

        % 绘制记忆刺激
        DrawStimDisplay(wPtr, clrCross, center);
        % bars的朝向的序列
        BarOriIDs = BarOri(:,randperm(9));  %进行随机化
        % 刺激位置序列
        FarID = rand;
        if FarID > 0.5  % 下视野较远的情况
           StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))];
        else   % 上视野较远的情况
           StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(4))];
        end      
        Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
         
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %刺激呈现，保留注视点
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerLowloadLeftMemory), tStimOnsetTime, 0.001);
        else
           %NetStation('Event', num2str(MarkerLowloadRightMemory), tStimOnsetTime, 0.001);
        end
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        %NetStation('Event', num2str(MarkerPostMemoryFixation), tCrossdelayOnset, 0.001);
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % 不变
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                if rand < 0.5
                    TestStimLine = StimLines(:,[3,4]);
                else
                    TestStimLine = StimLines(:,[7,8]);
                end
            else   % cue right
                if rand < 0.5
                    TestStimLine = StimLines(:,[1,2]);
                else
                    TestStimLine = StimLines(:,[5,6]);
                end
            end
                  
           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
       
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerLowloadTestLeftNochange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerLowloadTestRightNochange), tTestStimOnsetTime, 0.001);
           end

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              %NetStation('Event', num2str(MarkerCorrectResponse));
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              %NetStation('Event', num2str(MarkerWrongResponse));
              break
              elseif find(keyCode)== Esckey % 退出
                 Screen('CloseAll');
                 break
              else
              Data(totaltrialnum).Feedback = 999;
              Data(totaltrialnum).response = 999;
              Data(totaltrialnum).RTs = 999;
              end
            end
            if Data(totaltrialnum).response == 999
                %NetStation('Event', num2str(MarkerNoResponse));
            end
            Screen('Flip', wPtr);           %呈现注视点           
        end
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % 变
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                if mod(StimIDs(totaltrialnum),10) == 1 % 变成周围的
                    if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(4))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(2))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(4))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(2))];
                        end
                    end
                elseif mod(StimIDs(totaltrialnum),10) == 2  % 变其新方向
                     if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(9))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(9))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(9))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(9))];
                        end
                     end
                else % 变对侧
                     if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(1))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1))];
                        else
                            TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(3))];
                        end
                     end
                end
            else
                if mod(StimIDs(totaltrialnum),10) == 1 % 变成周围的
                    if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(3))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(1))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(3))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(1))];
                        end
                    end
                elseif mod(StimIDs(totaltrialnum),10) == 2  % 变其新方向
                     if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(9))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(9))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(9))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(9))];
                        end
                     end
                else % 变对侧
                     if FarID >0.5
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(2))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))];
                        end
                    else
                        if rand < 0.5
                            TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))];
                        else
                            TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(4))];
                        end
                     end                    
                end
            end

           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerLowloadTestLeftChange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerLowloadTestRightChange), tTestStimOnsetTime, 0.001);
           end

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
                   
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;
                 %NetStation('Event', num2str(MarkerWrongResponse));
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
                 %NetStation('Event', num2str(MarkerCorrectResponse));
                 break
              elseif find(keyCode)== Esckey % 退出
                 Screen('CloseAll');
                 break
              else
              Data(totaltrialnum).Feedback = 999;
              Data(totaltrialnum).response = 999;
              Data(totaltrialnum).RTs = 999;
              end
            end
            if Data(totaltrialnum).response == 999
                %NetStation('Event', num2str(MarkerNoResponse));
            end
            Screen('Flip', wPtr);           %呈现注视点           
    end

      %% 记录数据
       Data(totaltrialnum).LorR = floor(StimIDs(totaltrialnum)/100);
       Data(totaltrialnum).ChangeorNot = mod(StimIDs(totaltrialnum),100);
       Data(totaltrialnum).TotalTrialNum = totaltrialnum;
       Data(totaltrialnum).BlockNum = iBlock;
       Data(totaltrialnum).TrialNum = iTrial;
       Data(totaltrialnum).StimLines = StimLines;
       Data(totaltrialnum).TestStimLine = TestStimLine;
        end
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('Event', num2str(MarkerLoadTwoBlockEnd));
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    %NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('StartRecording');

    % 等待按键开始实验
    KbWait();

      end
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end


% ----------Load Four Condition ----------

   if strcmp(subinfo{8} , 'Loadfour')

      for iBlock = 1:Blocknum       
         %NetStation('Event', num2str(MarkerLoadFourBlockBegin));
        for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % 绘制刺激呈现前的注视点
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        %NetStation('Event', num2str(MarkerPreCueFixation), tFixOnset, 0.001);
        
        % 绘制箭头线索Cue
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
        Screen('FillPoly',wPtr, TclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else  % cue right
        Screen('FillPoly',wPtr, TclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);            
        end
        tCueOnset = Screen('Flip', wPtr, tFixOnset + tPreFix + tITI - slack); %呈现注视点，记录呈现时刻
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerHighloadLeftcue), tCueOnset, 0.001);
        else
           %NetStation('Event', num2str(MarkerHighloadRightcue), tCueOnset, 0.001);
        end

        % 绘制记忆刺激
        DrawStimDisplay(wPtr, clrCross, center);
        % bars的朝向的序列
        BarOriIDs = BarOri(:,randperm(9));  %进行随机化
        % 刺激位置序列
        StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4)) ...
                        locX(totaltrialnum,1)-1.2*sind(BarOriIDs(5)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(5)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(6)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(6)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(7)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(7)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(8)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(8));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(6)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(6))...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(8)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(8))];
  
        Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
         
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %刺激呈现，保留注视点
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerHighloadLeftMemory), tStimOnsetTime, 0.001);
        else
           %NetStation('Event', num2str(MarkerHighloadRightMemory), tStimOnsetTime, 0.001);
        end
                
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        %NetStation('Event', num2str(MarkerPostMemoryFixation), tCrossdelayOnset, 0.001);
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % 不变
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                x=rand;
                if x <= 0.25
                    TestStimLine = StimLines(:,[3,4]);
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = StimLines(:,[7,8]);
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = StimLines(:,[11,12]);
                else
                    TestStimLine = StimLines(:,[15,16]);                    
                end
            else   % cue right
                x=rand;
                if x <= 0.25
                    TestStimLine = StimLines(:,[1,2]);
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = StimLines(:,[5,6]);
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = StimLines(:,[9,10]);
                else
                    TestStimLine = StimLines(:,[13,14]);                    
                end
            end
                  
           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerHighloadTestLeftNochange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerHighloadTestRightNochange), tTestStimOnsetTime, 0.001);
           end

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
           
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              %NetStation('Event', num2str(MarkerCorrectResponse));
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              %NetStation('Event', num2str(MarkerWrongResponse));
              break
              elseif find(keyCode)== Esckey % 退出
                 Screen('CloseAll');
                 break
              else
              Data(totaltrialnum).Feedback = 999;
              Data(totaltrialnum).response = 999;
              Data(totaltrialnum).RTs = 999;
              end
            end
            if Data(totaltrialnum).response == 999
                %NetStation('Event', num2str(MarkerNoResponse));
            end
            Screen('Flip', wPtr);           %呈现注视点           
        end
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % 变
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                if mod(StimIDs(totaltrialnum),10) == 1 % 变成周围的
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(4))];
                elseif (x>0.25 && x<=0.5)
                    if rand > 0.5
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(2))];
                    else
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(6)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(6));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(6)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(6))];
                    end                        
                elseif (x>0.5 && x<=0.75)
                    if rand > 0.5
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(4))];
                    else
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(8)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(8));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(8)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(8))];
                    end                        
                else
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(6)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(6));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(6)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(6))];
                end
                    
                elseif mod(StimIDs(totaltrialnum),10) == 2  % 变其新方向
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(9))];
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(9))];
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(9))];
                else
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(9))];
                end

                else % 变对侧
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1))];
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3))];
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = ppd*[-locX(totaltrialnum,1)-1.2*sind(BarOriIDs(5)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(5));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(5))];
                else
                    TestStimLine = ppd*[-locX(totaltrialnum,2)-1.2*sind(BarOriIDs(7)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(7));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(7))];
                end

                end
            else
                if mod(StimIDs(totaltrialnum),10) == 1 % 变成周围的
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(3))];
                elseif (x>0.25 && x<=0.5)
                    if rand > 0.5
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(1));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(1))];
                    else
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(5)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(5));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(5))];
                    end                        
                elseif (x>0.5 && x<=0.75)
                    if rand > 0.5
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(3));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(3))];
                    else
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(7)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(7));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(7))];
                    end                        
                else
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(5)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(5));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(5))];
                end
                    
                elseif mod(StimIDs(totaltrialnum),10) == 2  % 变其新方向
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(9))];
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(9))];
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(9))];
                else
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(9)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(9));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(9)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(9))];
                end

                else % 变对侧
                  x=rand;
                if x <= 0.25
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))];
                elseif (x>0.25 && x<=0.5)
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))];
                elseif (x>0.5 && x<=0.75)
                    TestStimLine = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(6)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(6));...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(6)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(6))];
                else
                    TestStimLine = ppd*[locX(totaltrialnum,2)-1.2*sind(BarOriIDs(8)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(8));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(8)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(8))];
                end

                end
            end

           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerHighloadTestLeftChange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerHighloadTestRightChange), tTestStimOnsetTime, 0.001);
           end

           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
                   
           %等待按键响应并记录数据
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;
                 %NetStation('Event', num2str(MarkerWrongResponse));
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
                 %NetStation('Event', num2str(MarkerCorrectResponse));
                 break
              elseif find(keyCode)== Esckey % 退出
                 Screen('CloseAll');
                 break
              else
              Data(totaltrialnum).Feedback = 999;
              Data(totaltrialnum).response = 999;
              Data(totaltrialnum).RTs = 999;
              end
            end
            if Data(totaltrialnum).response == 999
                %NetStation('Event', num2str(MarkerNoResponse));
            end
            Screen('Flip', wPtr);           %呈现注视点           
        end
        
      %% 记录数据
       Data(totaltrialnum).LorR = floor(StimIDs(totaltrialnum)/100);
       Data(totaltrialnum).ChangeorNot = mod(StimIDs(totaltrialnum),100);
       Data(totaltrialnum).TotalTrialNum = totaltrialnum;
       Data(totaltrialnum).BlockNum = iBlock;
       Data(totaltrialnum).TrialNum = iTrial;
       Data(totaltrialnum).StimLines = StimLines;
       Data(totaltrialnum).TestStimLine = TestStimLine;
        end
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('Event', num2str(MarkerLoadTwoBlockEnd));
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    %NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('StartRecording');
    % 等待按键开始实验
    KbWait();

      end
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% 关闭窗口
     Screen('CloseAll');        
   end
% 
