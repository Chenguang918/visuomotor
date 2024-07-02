

% visual working memory guide attention程序
% 2 x 3 (Laod one/two X three taget type)  
% Coded by DW. Li @ BNU 2018-07-06

    %% 运行前准备部分
    clear; %清除所有变量，避免上次运行的残留数据影响本次运行
    clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
    close all; %关闭所有figure，同样为避免运行结果和上次混淆
    Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

    
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','Expdata'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','20190423'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='D:\lidongwei\vWM_Precision\data\';
    
    % ------显示参数------
    bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
    nMonitorID = max(Screen('Screens')); %屏幕编号
    HideCursor(nMonitorID); %隐藏指针
    clrBg = [130 130 130];  %指定背景颜色灰色
    
    % ------刺激参数------
    CrossLength = 10;    %注视点十字的长度
    CrossWidth = 3;      %注视点十字线的粗细
    clrCross = [0 0 0];   %指定注视点颜色为黑色

    % ------线索参数------
    CenterLeftArrowxyLists = [-36,0;-20,12;-20,4;36,4;36,-4;-20,-4;-20,-12];    %左箭头坐标
    CenterRightArrowxyLists = [36,0;20,12;20,4;-36,4;-36,-4;20,-4;20,-12];    %右箭头坐标
    LeftArrowxyListsone = [-144,0;-128,12;-128,4;-72,4;-72,-4;-128,-4;-128,-12];    %左箭头坐标
    RightArrowxyListsone = [144,0;128,12;128,4;72,4;72,-4;128,-4;128,-12];    %右箭头坐标
    LeftArrowxyListstwo = [-252,0;-236,12;-236,4;-180,4;-180,-4;-236,-4;-236,-12];    %左箭头坐标
    RightArrowxyListstwo = [252,0;236,12;236,4;180,4;180,-4;236,-4;236,-12];    %右箭头坐标
    LeftArrowxyListsthree = [72,0;88,12;88,4;144,4;144,-4;88,-4;88,-12];    %左箭头坐标
    RightArrowxyListsthree = [-72,0;-88,12;-88,4;-144,4;-144,-4;-88,-4;-88,-12];    %右箭头坐标
    LeftArrowxyListsfour = [180,0;196,12;196,4;252,4;252,-4;196,-4;196,-12];    %左箭头坐标
    RightArrowxyListsfour = [-180,0;-196,12;-196,4;-252,4;-252,-4;-196,-4;-196,-12];    %右箭头坐标
    clrArrow = 0;   %指定箭头颜色为黑色
  
    % ------时间和流程控制------
    tPreFix = 1; %刺激出现前注视点呈现的时间
    tStimDuraion = 0.2; %刺激出现的时间
    StimTrialNum = 50 ; %每个block的trial数
    tITI = 0.5*rand;
    Blocknum = 4; %总的block数
    response_interval = 2; %按键最长时间 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------生成刺激序列------
    StimIDs = [1,2,3,4];
    StimIDs = repmat(StimIDs,1,StimTrialNum*Blocknum/length(StimIDs));
    StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %进行随机化
    ccnum = 0;
    cinum = 0;
    icnum = 0;
    iinum = 0;
    combine = [];
        for i = 2 : length(StimIDs)
           if (StimIDs(i-1) == 1 | StimIDs(i-1) == 3) & (StimIDs(i) == 1 | StimIDs(i) == 3)%cc
               ccnum = ccnum + 1;
           end
           if (StimIDs(i-1) == 1 | StimIDs(i-1) == 3) & (StimIDs(i) == 2 | StimIDs(i) == 4)%ci
               cinum = cinum + 1;
           end
           if (StimIDs(i-1) == 2 | StimIDs(i-1) == 4) & (StimIDs(i) == 1 | StimIDs(i) == 3)%ic
               icnum = icnum + 1;
           end
           if (StimIDs(i-1) == 2 | StimIDs(i-1) == 4) & (StimIDs(i) == 2 | StimIDs(i) == 4)%ii
               iinum = iinum + 1;
           end
       end
       combine = [ccnum,cinum,icnum,iinum];  
    while (max(combine) - min(combine) > 2)
        StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %进行随机化
        ccnum = 0;
        cinum = 0;
        icnum = 0;
        iinum = 0;
        combine = [];
        for i = 2 : length(StimIDs)
           if (StimIDs(i-1) == 1 | StimIDs(i-1) == 3) & (StimIDs(i) == 1 | StimIDs(i) == 3)%cc
               ccnum = ccnum + 1;
           end
           if (StimIDs(i-1) == 1 | StimIDs(i-1) == 3) & (StimIDs(i) == 2 | StimIDs(i) == 4)%ci
               cinum = cinum + 1;
           end
           if (StimIDs(i-1) == 2 | StimIDs(i-1) == 4) & (StimIDs(i) == 1 | StimIDs(i) == 3)%ic
               icnum = icnum + 1;
           end
           if (StimIDs(i-1) == 2 | StimIDs(i-1) == 4) & (StimIDs(i) == 2 | StimIDs(i) == 4)%ii
               iinum = iinum + 1;
           end
       end
       combine = [ccnum,cinum,icnum,iinum];  
    end        
    
    %% 刺激呈现部分
    % 此处用于开启或关闭垂直同步测试
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % 初始化屏幕并得到屏幕参数
    wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %在指定的显示器打开刺激窗口
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
    [xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
    slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
      
    % Introduction
    sttext = 'Welcome to our Experiment!';
    resttext = 'Take a rest!';
    endtext = 'Congratulations! The exp has been finished!';
    tips = 'Press SPACE key to start if getting ready';
    font = 'Arial';
    fontsize = 30;
    clrText = [255,255,255];
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, sttext, 2*xCenter/3, yCenter-50, clrText);
    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter , clrText);
    Screen('Flip', wPtr);
    WaitSecs(2);
 
    % 等待按键开始实验
    KbWait();
    
   %% Body Program 

     for iBlock = 1:Blocknum
        for iTrial = 1:StimTrialNum    
       % 计数器
        totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;

        % 绘制刺激呈现前的注视点
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻

        % 绘制并呈现刺激
        if StimIDs(totaltrialnum) == 1 %lc
           Screen('FillPoly',wPtr, clrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsone + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListstwo + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsthree + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsfour + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        if StimIDs(totaltrialnum) == 2 %ric
           Screen('FillPoly',wPtr, clrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsone + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListstwo + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsthree + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, LeftArrowxyListsfour + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        if StimIDs(totaltrialnum) == 3 %rc
           Screen('FillPoly',wPtr, clrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsone + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListstwo + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsthree + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsfour + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        if StimIDs(totaltrialnum) == 4 %lic
           Screen('FillPoly',wPtr, clrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsone + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListstwo + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsthree + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
           Screen('FillPoly',wPtr, clrArrow, RightArrowxyListsfour + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        end
        tStimOnset = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %呈现注视点，记录呈现时刻
        
        % 绘制刺激呈现后的注视点
         Screen('FillRect', wPtr, clrBg);
         DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
         tCrosspostOnset = Screen('Flip', wPtr, tStimOnset + tStimDuraion - slack); %呈现注视点，记录呈现时刻
        
        %等待按键响应并记录数据
            while GetSecs - tStimOnset <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tStimOnset;
              if (find(keyCode)== leftkey & (StimIDs(totaltrialnum) == 1 | StimIDs(totaltrialnum) == 4))
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              break
              elseif (find(keyCode)== rightkey & (StimIDs(totaltrialnum) == 2 | StimIDs(totaltrialnum) == 3))
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 2;
              break
              elseif (find(keyCode)== leftkey & (StimIDs(totaltrialnum) == 2 | StimIDs(totaltrialnum) == 3))
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 1;
              break
              elseif (find(keyCode)== rightkey & (StimIDs(totaltrialnum) == 1 | StimIDs(totaltrialnum) == 4)) 
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              break
              else
              Data(totaltrialnum).Feedback = nan;
              Data(totaltrialnum).response = nan;
              Data(totaltrialnum).RTs = nan;
              end
            end
            
            DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
            Screen('Flip', wPtr);           %呈现注视点           
            WaitSecs(tITI);
      
        
      %% 记录数据
       Data(totaltrialnum).BlockNum = iBlock;
       Data(totaltrialnum).TrialNum = iTrial;
       Data(totaltrialnum).cond = StimIDs(totaltrialnum);
       Data(totaltrialnum).tFixation = tCrossOnset;
       Data(totaltrialnum).tArrowcue = tStimOnset;
       Data(totaltrialnum).tPreStimFixation = tCrosspostOnset;
       Data(totaltrialnum).tResponse = secs;
        end
           
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10, clrText);
    Screen('Flip', wPtr);
    WaitSecs(10);
    
    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    % 等待按键开始实验
    KbWait();
        
     end
     %% 保存数据
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_',subinfo{8},'_flanker_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');

    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, endtext, xCenter-30, yCenter-10, clrText);
    Screen('Flip', wPtr);
 
    % 等待按键结束实验
    KbWait();
    
    %% 关闭窗口
     Screen('CloseAll');        

   
   
   
%    
%    
% 
% %% 用于绘制注视点的子函数
% function DrawCross(wPtr, x, y, length, width, color)
%     ptsCrossLines = [-length length 0 0; 0 0 -length length];
%     Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %在屏幕上画反锯齿线段
% end
% 
% 
