

% visual working memory guide attention����
% 2 x 3 (Laod one/two X three taget type)  
% Coded by DW. Li @ BNU 2018-07-06

    %% ����ǰ׼������
    clear; %������б����������ϴ����еĲ�������Ӱ�챾������
    clc; %������������֣��Ա㱾���������������ϴεĻ���
    close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
    Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

    
    %% �������ò���
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','Expdata'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','20190423'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='D:\lidongwei\vWM_Precision\data\';
    
    % ------��ʾ����------
    bSkipSyncTests = 1; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    nMonitorID = max(Screen('Screens')); %��Ļ���
    HideCursor(nMonitorID); %����ָ��
    clrBg = [130 130 130];  %ָ��������ɫ��ɫ
    
    % ------�̼�����------
    CrossLength = 10;    %ע�ӵ�ʮ�ֵĳ���
    CrossWidth = 3;      %ע�ӵ�ʮ���ߵĴ�ϸ
    clrCross = [0 0 0];   %ָ��ע�ӵ���ɫΪ��ɫ

    % ------��������------
    CenterLeftArrowxyLists = [-36,0;-20,12;-20,4;36,4;36,-4;-20,-4;-20,-12];    %���ͷ����
    CenterRightArrowxyLists = [36,0;20,12;20,4;-36,4;-36,-4;20,-4;20,-12];    %�Ҽ�ͷ����
    LeftArrowxyListsone = [-144,0;-128,12;-128,4;-72,4;-72,-4;-128,-4;-128,-12];    %���ͷ����
    RightArrowxyListsone = [144,0;128,12;128,4;72,4;72,-4;128,-4;128,-12];    %�Ҽ�ͷ����
    LeftArrowxyListstwo = [-252,0;-236,12;-236,4;-180,4;-180,-4;-236,-4;-236,-12];    %���ͷ����
    RightArrowxyListstwo = [252,0;236,12;236,4;180,4;180,-4;236,-4;236,-12];    %�Ҽ�ͷ����
    LeftArrowxyListsthree = [72,0;88,12;88,4;144,4;144,-4;88,-4;88,-12];    %���ͷ����
    RightArrowxyListsthree = [-72,0;-88,12;-88,4;-144,4;-144,-4;-88,-4;-88,-12];    %�Ҽ�ͷ����
    LeftArrowxyListsfour = [180,0;196,12;196,4;252,4;252,-4;196,-4;196,-12];    %���ͷ����
    RightArrowxyListsfour = [-180,0;-196,12;-196,4;-252,4;-252,-4;-196,-4;-196,-12];    %�Ҽ�ͷ����
    clrArrow = 0;   %ָ����ͷ��ɫΪ��ɫ
  
    % ------ʱ������̿���------
    tPreFix = 1; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimDuraion = 0.2; %�̼����ֵ�ʱ��
    StimTrialNum = 50 ; %ÿ��block��trial��
    tITI = 0.5*rand;
    Blocknum = 4; %�ܵ�block��
    response_interval = 2; %�����ʱ�� 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------���ɴ̼�����------
    StimIDs = [1,2,3,4];
    StimIDs = repmat(StimIDs,1,StimTrialNum*Blocknum/length(StimIDs));
    StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %���������
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
        StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %���������
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
    
    %% �̼����ֲ���
    % �˴����ڿ�����رմ�ֱͬ������
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % ��ʼ����Ļ���õ���Ļ����
    wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %��ָ������ʾ���򿪴̼�����
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
    [xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
    slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��
      
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
 
    % �ȴ�������ʼʵ��
    KbWait();
    
   %% Body Program 

     for iBlock = 1:Blocknum
        for iTrial = 1:StimTrialNum    
       % ������
        totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;

        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��

        % ���Ʋ����ִ̼�
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
        tStimOnset = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %����ע�ӵ㣬��¼����ʱ��
        
        % ���ƴ̼����ֺ��ע�ӵ�
         Screen('FillRect', wPtr, clrBg);
         DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
         tCrosspostOnset = Screen('Flip', wPtr, tStimOnset + tStimDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        
        %�ȴ�������Ӧ����¼����
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
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
      
        
      %% ��¼����
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
    % �ȴ�������ʼʵ��
    KbWait();
        
     end
     %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_',subinfo{8},'_flanker_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');

    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, endtext, xCenter-30, yCenter-10, clrText);
    Screen('Flip', wPtr);
 
    % �ȴ���������ʵ��
    KbWait();
    
    %% �رմ���
     Screen('CloseAll');        

   
   
   
%    
%    
% 
% %% ���ڻ���ע�ӵ���Ӻ���
% function DrawCross(wPtr, x, y, length, width, color)
%     ptsCrossLines = [-length length 0 0; 0 0 -length length];
%     Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %����Ļ�ϻ�������߶�
% end
% 
% 
