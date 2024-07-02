 
% Free time NeuroFeedback Visual search 
% Coded by ZCG @ BNU 2020-9-23

    %% 运行前准备部分
    clear; %
    clc; %
    close all; %
    Priority(1); %
    rand('state',sum(100*clock));  % 
    %% connection config
    config_io
    outp(888, 0);    
    com1=serial('com1');
    set(com1,'BaudRate',9600,'StopBits',1,'Parity','none','DataBits',8,'InputBufferSize',255);
    try 
        fopen(com1);
    catch
        fclose(instrfind)
        fopen(com1)
    end        
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','Loadfour'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    commandwindow;
    dataPath='E:\Zhaochenguang\NFB\';

   
    %%
    subid_name_file=strcat('sub',subinfo{1},subinfo{2});
    filepath=strcat(dataPath,'\experimentdata\subexpdata\','sub',subinfo{1},subinfo{7},'\');
    if ~exist(filepath,'dir')
         mkdir(filepath);
    end
   filename=strcat(filepath,'\',subid_name_file);
    
    % ------显示参数------
    bSkipSyncTests = 0; %是否禁用垂直同步测试，正式实验时切勿禁用
    screenNumber = max(Screen('Screens')); %屏幕编号
    %HideCursor(screenNumber); %隐藏指针
    distance = 65;         % distance between subject and monitor
    monitorwidth = 48.3;      % The width of the monitor
%     clrBg = [127 127 127];  %指定背景颜色灰色

%     % Define black, white and grey
    white = WhiteIndex(screenNumber);
    clrBg = white / 2;
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);
    
    % 初始化屏幕并得到屏幕参数
    %[wPtr , wRect]  = Screen('OpenWindow',screenNumber-1, clrBg); % Open the stimulus window on the specified display
     [wPtr , wRect] = PsychImaging('OpenWindow', screenNumber-1, clrBg, [], 32, 2,...
     [], [],  kPsychNeed32BPCFloat);
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree

    % ------注视点参数------
    CrossLength = 10;    %注视点十字的长度
    CrossWidth = 3;      %注视点十字线的粗细
    clrCross_b = [0 0 0];   %指定注视点颜色为黑色
    clrCross_w = [255 255 255];   %指定注视点颜色为黑色
    % ------Garbo参数------
    aspectRatio = 1.0;
    phase = 50;
    numCycles = 6;
    clrText = [255, 255, 255];           % white
  
    % ------时间和流程控制------
    tPreFix = 5.0; %刺激出现前注视点呈现的时间
    tCueOnsetDuraion = 0.1; %线索出现的时间
    tStimOnsetDuraion =1; %刺激出现的时间
    tRentionDuraion = 3; %记忆保持时间
    tITI = 0.5 * rand; % Inter Trial Interval
    StimTrialNum = 60; %总的trial数
    Blocknum = 4;
    response_interval = 3; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    hitnum = 0;
    missnum = 0;
    
    %% 刺激呈现部分    
    % Introduction
    sttext = 'Welcome to our Experiment!';
    resttext = 'Take a rest!';
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
       taskindex=2;
      for iBlock = 1:Blocknum       
          
        outp(888, 1);
        WaitSecs(0.004);
        outp(888, 0);
     
        for iTrial = 1:StimTrialNum
        totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;    
       % 随机生成刺激参数
        Change_or_not = (rand > 0.5);    % 1为不变 -1为变                
        orientation=fix(180*rand); 
        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_w);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_w); 
        tPreFixOnset=Screen('Flip', wPtr, tCrossOnset+tPreFix-slack);

        % triger NFB
        contrast=0; 
        [gabortex,propertiesMat]=gaborplot(wRect,wPtr,contrast,aspectRatio,phase,numCycles);
        Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [], kPsychDontDoRotation, propertiesMat');        
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %绘制注视点        
        tNFB1Onset =Screen('Flip', wPtr, tPreFixOnset+tStimOnsetDuraion-slack); %刺激呈现，保留注视点
        outp(888, 1*100+1);
        WaitSecs(0.004);
        outp(888, 0);

        % Feedback

            tic
        contrast=serial_receive(com1); 
        connection_time=toc
        [gabortex,propertiesMat]=gaborplot(wRect,wPtr,contrast,aspectRatio,phase,numCycles);
        Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [], kPsychDontDoRotation, propertiesMat');        
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %绘制注视点        
        tNFB1Onset=Screen('Flip', wPtr,tNFB1Onset+tStimOnsetDuraion-slack); %刺激呈现，保留注视点
        outp(888, 1*100);
        WaitSecs(0.004);
        outp(888, 0);
%         WaitSecs(tStimOnsetDuraion)

        tStim = GetSecs;
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
        tCrossdelayOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
        WaitSecs(tRentionDuraion)
        tDelayCross = GetSecs;
        
        
        % Discrimination Task when change
        if Change_or_not==0
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %绘制注视点
           Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [],...
           kPsychDontDoRotation, propertiesMat');
           %呈现再认刺激
           Screen('Flip', wPtr); %刺激呈现，保留注视点
           tic
           outp(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           outp(888, 0);
           %绘制注视点           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
           
           %等待按键响应并记录数据
            while toc < response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              RT = secs;
              Data(totaltrialnum).RTs = RT;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %选左
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              res_trg=100;  
              acc=1;
              noRespond=0;
              break
              elseif find(keyCode)== rightkey %选右
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              res_trg=99;  
                                acc=0;
                                 noRespond=0;
                  missnum = missnum+1;
              break
              else
              Data(totaltrialnum).Feedback = nan;
              Data(totaltrialnum).response = nan;
              Data(totaltrialnum).RTs = nan;
              res_trg=99;  
              acc=0;
              noRespond=1;
              end
            end
                 Screen('Flip', wPtr);           %呈现注视点 
                 WaitSecs(tITI);
                 outp(888, res_trg);
                 WaitSecs(0.004);
                 outp(888, 0);
        end
        
        % Discrimination Task when nochange      
        if Change_or_not==1 %变
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %绘制注视点
           change_ori=fix(-90+180*rand);
           Screen('DrawTextures', wPtr, gabortex, [], [], orientation+change_ori, [], [], [], [],...
           kPsychDontDoRotation, propertiesMat');        
           %呈现再认刺激
           Screen('Flip', wPtr); %刺激呈现，保留注视点
           tic
           outp(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           outp(888, 0);
           %绘制注视点           
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
        
           %等待按键响应并记录数据
            while toc <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              RT = toc;
              Data(totaltrialnum).RTs = RT;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %选左
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;   
                               res_trg=99;  
                               acc=0;
                               noRespond=0;
                 break
              elseif find(keyCode) == rightkey %选右
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;  
                               res_trg=100;  
                                acc=1;
                                noRespond=0;
                 break
              else
                 Data(totaltrialnum).Feedback = nan;
                 Data(totaltrialnum).response = nan;
                 Data(totaltrialnum).RTs = nan;
                               res_trg=99;  
                                acc=0;
                                hitnum=hitnum+1;
                                noRespond=1;
                           
              end
            end
                Screen('Flip', wPtr);           %呈现注视点
                 WaitSecs(tITI);
                 outp(888, res_trg);
                 WaitSecs(0.004);
                 outp(888, 0);
        end
        
%% 记录数据
%        Data(totaltrialnum).LorR = Left_or_Right;
       Data(totaltrialnum).ChangeorNot = Change_or_not;
       Data(totaltrialnum).TrialNum = totaltrialnum;
%        Data(totaltrialnum).Locx = Locx;
%        Data(totaltrialnum).Locy = Locy;
%        Data(totaltrialnum).PreColor = ClrPreitem;
%        Data(totaltrialnum).PostColor = ClrPostitem;
%        Data(totaltrialnum).tResponse = secs;
%        Data(totaltrialnum).BlockNum = iBlock;
       
%        calculate behavioral results
       Data(totaltrialnum).acc = acc;
       Data(totaltrialnum).RT = RT;            
                
%        if noRespond == 0
%           fprintf('\n\nblocknum=%f\ncondition=LoadTwo\ntrialnum=%f\nRt=%f\nAcc=%f%',iBlock,iTrial,RT,acc)
%        end
%        if noRespond == 1
%           fprintf('\n\nblocknum=%f\ncondition=LoadTwo\ntrialnum=%f\nRt=%f\nAcc=%f%',iBlock,iTrial,999,999)
%        end
       
        end
%         meanACC(iBlock) = mean(Distractortrials_ACC);
%         meanRT(iBlock) = mean(Distractortrials_Rts);
%          Kscores = hitnum;
%         fprintf('\n\nBlockNum=%f\nACC=%f\nRt=%f%',iBlock,meanACC(iBlock),meanRT(iBlock))
%         clear Distractortrials_ACC Distractortrials_Rts

        Screen('TextSize', wPtr ,fontsize);
        Screen('TextFont', wPtr, font);
        Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10,  [255,255,255]);
        Screen('Flip', wPtr);
        
        outp(888, 255);
        WaitSecs(0.004);
        outp(888, 0);
     
%         behaviordataname=strcat(filename,num2str(GetSecs),'.mat');
%         save(behaviordataname,'subinfo','Data','meanACC','meanRT');   

        WaitSecs(10);
        Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10,  [255,255,255]);
        Screen('Flip', wPtr);
        
        % 等待按键开始实验
        KbWait();

      end
      
% behaviordataname=strcat(filename,'.mat');
% save(behaviordataname,'subinfo','Data','meanACC','meanRT' );   
         KbWait();
  
    %% 关闭窗口
     Screen('CloseAll');      