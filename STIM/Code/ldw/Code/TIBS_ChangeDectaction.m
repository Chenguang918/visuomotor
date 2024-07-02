

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
    nMonitorID = max(Screen('Screens')); %屏幕编号
    HideCursor(nMonitorID); %隐藏指针
    distance = 80;         % distance between subject and monitor
    monitorwidth = 40.5;      % The width of the monitor
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
    
    % ------刺激参数------
    AngStimBar_length = 2; %刺激视角
    StimBar_length = AngStimBar_length * ppd;
    AngStimBar_width = 0.4;
    WideBar = AngStimBar_width * ppd;
    BarOri = [16, 36, 56, 76, 96, 116, 136, 156, 176]; %刺激所有可能的9种朝向
    clrStim = [255, 0, 0];           % Red
    load([path,'sub',subinfo{1},'_triallists.mat'])
    
    % ------时间和流程控制------
    tPreFix = 1.0; %刺激出现前注视点呈现的时间
    tStimOnsetDuraion = 0.2; %刺激出现的时间
    tRentionDuraion = 0.9; %记忆保持时间
    tITI = 0.2 * rand; % Inter Trial Interval
    StimTrialNum = 60; % 每个block的trial数
    Blocknum = 6;
    response_interval = 3; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------trial 顺序------
    StimIDs = [111,112,113,121,122,123,211,212,213,221,222,223,311,312,313,321,322,323]; %生成多组1:StimNum的数 第一位左/右 第二位不变/变
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
    NetStation('StartRecording');
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
      for iBlock = 1:Blocknum
       for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % 绘制刺激呈现前的注视点
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻

        % 绘制记忆刺激
        DrawStimDisplay(wPtr, clrCross, center);
        % bars的朝向的序列
        BarOriIDs = BarOri(:,randperm(9));  %进行随机化
        % 刺激位置序列
        if fix(StimIDs(totaltrialnum)/100)==1 % L2
           StimLines = ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(1)) LocX(totaltrialnum,2)+sind(BarOriIDs(1)) -LocX(totaltrialnum,2)-sind(BarOriIDs(2)) -LocX(totaltrialnum,2)+sind(BarOriIDs(2)); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(1)) LocY(totaltrialnum,2)+cosd(BarOriIDs(1)) LocY(totaltrialnum,2)-cosd(BarOriIDs(2)) LocY(totaltrialnum,2)+cosd(BarOriIDs(2))];
        elseif fix(StimIDs(totaltrialnum)/100)==2 % L4
           StimLines = ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)) LocX(totaltrialnum,1)+sind(BarOriIDs(1)) -LocX(totaltrialnum,1)-sind(BarOriIDs(2)) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)) ...
                        LocX(totaltrialnum,3)-sind(BarOriIDs(3)) LocX(totaltrialnum,3)+sind(BarOriIDs(3)) -LocX(totaltrialnum,3)-sind(BarOriIDs(4)) -LocX(totaltrialnum,3)+sind(BarOriIDs(4)); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)) LocY(totaltrialnum,1)-cosd(BarOriIDs(2)) LocY(totaltrialnum,1)+cosd(BarOriIDs(2))...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(3)) LocY(totaltrialnum,3)+cosd(BarOriIDs(3)) LocY(totaltrialnum,3)-cosd(BarOriIDs(4)) LocY(totaltrialnum,3)+cosd(BarOriIDs(4))];
        else  % L6
           StimLines = ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)) LocX(totaltrialnum,1)+sind(BarOriIDs(1)) -LocX(totaltrialnum,1)-sind(BarOriIDs(2)) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)) ...
                        LocX(totaltrialnum,2)-sind(BarOriIDs(3)) LocX(totaltrialnum,2)+sind(BarOriIDs(3)) -LocX(totaltrialnum,2)-sind(BarOriIDs(4)) -LocX(totaltrialnum,2)+sind(BarOriIDs(4)) ...
                        LocX(totaltrialnum,3)-sind(BarOriIDs(5)) LocX(totaltrialnum,3)+sind(BarOriIDs(5)) -LocX(totaltrialnum,3)-sind(BarOriIDs(6)) -LocX(totaltrialnum,3)+sind(BarOriIDs(6)); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)) LocY(totaltrialnum,1)-cosd(BarOriIDs(2)) LocY(totaltrialnum,1)+cosd(BarOriIDs(2))...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(3)) LocY(totaltrialnum,2)+cosd(BarOriIDs(3)) LocY(totaltrialnum,2)-cosd(BarOriIDs(4)) LocY(totaltrialnum,2)+cosd(BarOriIDs(4))...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(5)) LocY(totaltrialnum,3)+cosd(BarOriIDs(5)) LocY(totaltrialnum,3)-cosd(BarOriIDs(6)) LocY(totaltrialnum,3)+cosd(BarOriIDs(6))];
            
        end
         Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段            
                  
        %呈现记忆刺激
        tStimOnsetTime = Screen('Flip', wPtr, tFixOnset + tPreFix - slack); %刺激呈现，保留注视点
        
        % 绘制记忆刺激呈现后的注视点
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %呈现注视点，记录呈现时刻
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % 不变
            if fix(StimIDs(totaltrialnum)/100)==1 % L2
                    TestStimLine = StimLines(:,[(fix(rand*2)+1)*2-1,(fix(rand*2)+1)*2]);
            elseif fix(StimIDs(totaltrialnum)/100)==2 % L4
                    TestStimLine = StimLines(:,[randi([1,4])*2-1,randi([1,4])*2]);
            else
                    TestStimLine = StimLines(:,[randi([1,6])*2-1,randi([1,6])*2]);
            end
                  
           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
       
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点

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
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
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

            Screen('Flip', wPtr);           %呈现注视点           
        end
        
        % 绘制再认刺激
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % 变
            
           if fix(StimIDs(totaltrialnum)/100)==1 % L2
               if mod(StimIDs(totaltrialnum),10)==1
                   if rand>0.5
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(2)) LocX(totaltrialnum,2)+sind(BarOriIDs(2)); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(2)) LocY(totaltrialnum,2)+cosd(BarOriIDs(2))];
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(1)) -LocX(totaltrialnum,2)+sind(BarOriIDs(1)); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(1)) LocY(totaltrialnum,2)+cosd(BarOriIDs(1))];
                   end
               elseif mod(StimIDs(totaltrialnum),10)==2
                    if rand>0.5
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(1)+15) LocX(totaltrialnum,2)+sind(BarOriIDs(1)+15); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(1)+15) LocY(totaltrialnum,2)+cosd(BarOriIDs(1)+15)];
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(2)-15) -LocX(totaltrialnum,2)+sind(BarOriIDs(2)-15); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(2)-15) LocY(totaltrialnum,2)+cosd(BarOriIDs(2)-15)];
                    end                  
               else
                    if rand>0.5
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(1)+75) LocX(totaltrialnum,2)+sind(BarOriIDs(1)+75); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(1)+75) LocY(totaltrialnum,2)+cosd(BarOriIDs(1)+75)];
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(2)-75) -LocX(totaltrialnum,2)+sind(BarOriIDs(2)-75); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(2)-75) LocY(totaltrialnum,2)+cosd(BarOriIDs(2)-75)];
                    end                  
               end
 
           elseif fix(StimIDs(totaltrialnum)/100)==2 % L4
               if mod(StimIDs(totaltrialnum),10)==1
                   if rand<0.25
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(3)) LocX(totaltrialnum,1)+sind(BarOriIDs(3));...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(3)) LocY(totaltrialnum,1)+cosd(BarOriIDs(3))];
                   elseif (rand>=0.25 && rand<0.5)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(4)) -LocX(totaltrialnum,1)+sind(BarOriIDs(4));...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(4)) LocY(totaltrialnum,1)+cosd(BarOriIDs(4))];
                 elseif (rand>=0.5 && rand<0.75)
                     TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(4)) LocX(totaltrialnum,3)+sind(BarOriIDs(4));...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(4)) LocY(totaltrialnum,3)+cosd(BarOriIDs(4))];                      
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(3)) -LocX(totaltrialnum,3)+sind(BarOriIDs(3));...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(3)) LocY(totaltrialnum,3)+cosd(BarOriIDs(3))];                       
                   end
               elseif mod(StimIDs(totaltrialnum),10)==2
                   if rand<0.25
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)+15) LocX(totaltrialnum,1)+sind(BarOriIDs(1)+15);...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)+15) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)+15)];
                   elseif (rand>=0.25 && rand<0.5)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(2)-15) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)-15);...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(2)-15) LocY(totaltrialnum,1)+cosd(BarOriIDs(2)-15)];
                 elseif (rand>=0.5 && rand<0.75)
                     TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(3)+15) LocX(totaltrialnum,3)+sind(BarOriIDs(3)+15);...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(3)+15) LocY(totaltrialnum,3)+cosd(BarOriIDs(3)+15)];                      
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(4)-15) -LocX(totaltrialnum,3)+sind(BarOriIDs(4)-15);...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(4)-15) LocY(totaltrialnum,3)+cosd(BarOriIDs(4)-15)];                       
                   end
               else
                   if rand<0.25
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)+75) LocX(totaltrialnum,1)+sind(BarOriIDs(1)+75);...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)+75) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)+75)];
                   elseif (rand>=0.25 && rand<0.5)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(2)-75) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)-75);...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(2)-75) LocY(totaltrialnum,1)+cosd(BarOriIDs(2)-75)];
                 elseif (rand>=0.5 && rand<0.75)
                     TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(3)+75) LocX(totaltrialnum,3)+sind(BarOriIDs(3)+75);...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(3)+75) LocY(totaltrialnum,3)+cosd(BarOriIDs(3)+75)];                      
                   else
                    TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(4)-75) -LocX(totaltrialnum,3)+sind(BarOriIDs(4)-75);...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(4)-75) LocY(totaltrialnum,3)+cosd(BarOriIDs(4)-75)];                       
                   end                
               end
         
           else  % L6
               if mod(StimIDs(totaltrialnum),10)==1
                   if rand<1/6
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(3)) LocX(totaltrialnum,1)+sind(BarOriIDs(3)); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(3)) LocY(totaltrialnum,1)+cosd(BarOriIDs(3))];
                   elseif (rand>=1/6 && rand<1/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(4)) -LocX(totaltrialnum,1)+sind(BarOriIDs(4)); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(4)) LocY(totaltrialnum,1)+cosd(BarOriIDs(4))];
                   elseif (rand>=1/3 && rand<1/2)
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(4)) LocX(totaltrialnum,2)+sind(BarOriIDs(4)); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(4)) LocY(totaltrialnum,2)+cosd(BarOriIDs(4))];                      
                   elseif (rand>=1/2 && rand<2/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(3)) -LocX(totaltrialnum,2)+sind(BarOriIDs(3)); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(3)) LocY(totaltrialnum,2)+cosd(BarOriIDs(3))];                       
                   elseif (rand>=2/3 && rand<5/6)
                    TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(6)) LocX(totaltrialnum,3)+sind(BarOriIDs(6)); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(6)) LocY(totaltrialnum,3)+cosd(BarOriIDs(6))];
                   else
                     TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(5)) -LocX(totaltrialnum,3)+sind(BarOriIDs(5)); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(5)) LocY(totaltrialnum,3)+cosd(BarOriIDs(5))];                      
                   end
               elseif mod(StimIDs(totaltrialnum),10)==2
                   if rand<1/6
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)+15) LocX(totaltrialnum,1)+sind(BarOriIDs(1)+15); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)+15) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)+15)];
                   elseif (rand>=1/6 && rand<1/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(2)-15) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)-15); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(2)-15) LocY(totaltrialnum,1)+cosd(BarOriIDs(2)-15)];
                   elseif (rand>=1/3 && rand<1/2)
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(3)+15) LocX(totaltrialnum,2)+sind(BarOriIDs(3)+15); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(3)+15) LocY(totaltrialnum,2)+cosd(BarOriIDs(3)+15)];                      
                   elseif (rand>=1/2 && rand<2/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(4)-15) -LocX(totaltrialnum,2)+sind(BarOriIDs(4)-15); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(4)-15) LocY(totaltrialnum,2)+cosd(BarOriIDs(4)-15)];                       
                   elseif (rand>=2/3 && rand<5/6)
                    TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(5)+15) LocX(totaltrialnum,3)+sind(BarOriIDs(5)+15); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(5)+15) LocY(totaltrialnum,3)+cosd(BarOriIDs(5)+15)];
                   else
                     TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(6)-15) -LocX(totaltrialnum,3)+sind(BarOriIDs(6)-15); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(6)-15) LocY(totaltrialnum,3)+cosd(BarOriIDs(6)-15)];                      
                   end
               else
                   if rand<1/6
                    TestStimLine =  ppd*[LocX(totaltrialnum,1)-sind(BarOriIDs(1)+75) LocX(totaltrialnum,1)+sind(BarOriIDs(1)+75); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(1)+75) LocY(totaltrialnum,1)+cosd(BarOriIDs(1)+75)];
                   elseif (rand>=1/6 && rand<1/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,1)-sind(BarOriIDs(2)-75) -LocX(totaltrialnum,1)+sind(BarOriIDs(2)-75); ...
                        LocY(totaltrialnum,1)-cosd(BarOriIDs(2)-75) LocY(totaltrialnum,1)+cosd(BarOriIDs(2)-75)];
                   elseif (rand>=1/3 && rand<1/2)
                    TestStimLine =  ppd*[LocX(totaltrialnum,2)-sind(BarOriIDs(3)+75) LocX(totaltrialnum,2)+sind(BarOriIDs(3)+75); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(3)+75) LocY(totaltrialnum,2)+cosd(BarOriIDs(3)+75)];                      
                   elseif (rand>=1/2 && rand<2/3)
                    TestStimLine =  ppd*[-LocX(totaltrialnum,2)-sind(BarOriIDs(4)-75) -LocX(totaltrialnum,2)+sind(BarOriIDs(4)-75); ...
                        LocY(totaltrialnum,2)-cosd(BarOriIDs(4)-75) LocY(totaltrialnum,2)+cosd(BarOriIDs(4)-75)];                       
                   elseif (rand>=2/3 && rand<5/6)
                    TestStimLine =  ppd*[LocX(totaltrialnum,3)-sind(BarOriIDs(5)+75) LocX(totaltrialnum,3)+sind(BarOriIDs(5)+75); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(5)+75) LocY(totaltrialnum,3)+cosd(BarOriIDs(5)+75)];
                   else
                     TestStimLine =  ppd*[-LocX(totaltrialnum,3)-sind(BarOriIDs(6)-75) -LocX(totaltrialnum,3)+sind(BarOriIDs(6)-75); ...
                        LocY(totaltrialnum,3)-cosd(BarOriIDs(6)-75) LocY(totaltrialnum,3)+cosd(BarOriIDs(6)-75)];                      
                   end
               end
           end

        

           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %在屏幕上画反锯齿线段
        
           %呈现再认刺激
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %刺激呈现，保留注视点

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
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
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
 
            Screen('Flip', wPtr);           %呈现注视点           
    end

      %% 记录数据
       Data(totaltrialnum).ChangeorNot = fix(mod(StimIDs(totaltrialnum),100)/10);
       Data(totaltrialnum).ChangeCat = mod(StimIDs(totaltrialnum),10);
       Data(totaltrialnum).Load = fix(StimIDs(totaltrialnum)/100)*2;
       Data(totaltrialnum).TotalTrialNum = totaltrialnum;
       Data(totaltrialnum).BlockNum = iBlock;
       Data(totaltrialnum).TrialNum = iTrial;
       Data(totaltrialnum).StimLines = StimLines;
       Data(totaltrialnum).TestStimLine = TestStimLine;
       clear StimLines TestStimLine
        end
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10, clrText);
    Screen('Flip', wPtr);
    NetStation('Event', num2str(MarkerLoadTwoBlockEnd));
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    NetStation('StartRecording');

    % 等待按键开始实验
    KbWait();

      end
    %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% 关闭窗口
     Screen('CloseAll');        


     
     
     
