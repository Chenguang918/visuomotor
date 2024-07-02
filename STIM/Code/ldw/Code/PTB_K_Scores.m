

% K-scores����
% set-size one two three four five 
% Coded by DW. Li @ BNU 2018-04-17

    %% ����ǰ׼������
    clear; %������б����������ϴ����еĲ�������Ӱ�챾������
    clc; %������������֣��Ա㱾���������������ϴεĻ���
    close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
    Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

    
    %% �������ò���
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','CondtionType'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','5.0','right','Loadfour'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='D:\lidongwei\vWM_Precision\data\';
    
    % ------��ʾ����------
    bSkipSyncTests = 1; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    nMonitorID = max(Screen('Screens')); %��Ļ���
    HideCursor(nMonitorID); %����ָ��
    clrBg = [130 130 130];  %ָ��������ɫ��ɫ
    
    % ------ע�ӵ����------
    CrossLength = 10;    %ע�ӵ�ʮ�ֵĳ���
    CrossWidth = 3;      %ע�ӵ�ʮ���ߵĴ�ϸ
    clrCross = [0 0 0];   %ָ��ע�ӵ���ɫΪ��ɫ
    
    % ------�̼�����------
    StimLength = 100; %�̼��߳�
    StimLbx = -350; %�˴�����Ļ����Ϊ0, ����Ϊ����Ϊ�̼����½ǵĳ�ʼ������
    StimLby = -380; %�˴�����Ļ����Ϊ0, ����Ϊ����Ϊ�̼����½ǵĳ�ʼ������
    StimLocationx = (0:300:600)+StimLbx; %�̼����½����п��ܵĺ�����
    StimLocationy = (0:220:660)+StimLby; %�̼����½����п��ܵ�������
    clrStim = [139 0 0; 0 0 139; 0 205 0; 205 205 0; 255 130 171; 155 48 255; 255 165 0; 0 0 0]; %�̼����п��ܵ�8����ɫ
    clrText = [255, 255, 255];           % white
  
    % ------ʱ������̿���------
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimOnsetDuraion = 0.2; %�̼����ֵ�ʱ��
    tRentionDuraion = 0.9; %���䱣��ʱ��
    tITI = 0.5 * rand; % Inter Trial Interval
    StimTrialNum = 100; %�ܵ�trial��
    response_interval = 3; %�����ʱ�� 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    %% �̼����ֲ���
    % �˴����ڿ�����رմ�ֱͬ������
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % ��ʼ����Ļ���õ���Ļ����
    wPtr  = Screen('OpenWindow',nMonitorID-1, clrBg); %��ָ������ʾ���򿪴̼�����
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
    [xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
    slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��
    
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
 
    % �ȴ�������ʼʵ��
    KbWait();
    
   %% Body Program 
   
   % ----------Load Two Condition ----------

   if strcmp(subinfo{8} , 'Loadtwo')
        for iTrial = 1:StimTrialNum
    
       % ������ɴ̼�����
        ClrChange_num=[1:2];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1Ϊ���� -1Ϊ��           
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        tCross = GetSecs;
        
        % ���Ƽ���̼�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
        Locx = StimxIDs(1:2)'; %�õ���ǰtrial������ɵ�λ�ú�����
        Locy = StimyIDs(1:2)'; %�õ���ǰtrial������ɵ�λ��������
        ClrPreitem = StimClrIDs(1:2,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %�̼����֣�����ע�ӵ�
        tStim = GetSecs;
        
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        tDelayCross = GetSecs;
        
        % �������ϴ̼�
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = StimxIDs(1:2)'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = StimyIDs(1:2)'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:2,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
        % �������ϴ̼�       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = StimxIDs(1:2)'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = StimyIDs(1:2)'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:2,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(3,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;
 
           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
      %% ��¼����
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
        
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% �رմ���
     Screen('CloseAll');        
   end
    
   
% ----------Load Four Condition ----------

   if strcmp(subinfo{8} , 'Loadfour')
       
        for iTrial = 1:StimTrialNum    
       % ������ɴ̼�����
        ClrChange_num=[1:4];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1Ϊ���� -1Ϊ��           
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        tCross = GetSecs;

        % ���Ƽ���̼�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
        Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %�õ���ǰtrial������ɵ�λ�ú�����
        Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
        ClrPreitem = StimClrIDs(1:4,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %�̼����֣�����ע�ӵ�
        tStim = GetSecs;
        
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        tDelayCross = GetSecs;
        
        % �������ϴ̼�
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:4,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
        % �������ϴ̼�       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = [StimxIDs(1:2),StimxIDs(1:2)]'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = [StimyIDs(1:2),StimyIDs(2),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:4,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(5,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;
 
           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
      %% ��¼����
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
        
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% �رմ���
     Screen('CloseAll');        
   end
   
   

  
   
%% ----------Load Six Condition ----------

   if strcmp(subinfo{8} , 'Loadsix')
       
        for iTrial = 1:StimTrialNum    
       % ������ɴ̼�����
        ClrChange_num=[1:3];
        StimxIDs = StimLocationx(randperm(length(StimLocationx)));   
        StimyIDs = StimLocationy(randperm(length(StimLocationy)));  
        StimClrIDs = clrStim(randperm(length(clrStim)),:);     
        StimchangeClrnumIDs = ClrChange_num(randperm(length(ClrChange_num)));   
        Change_or_not = (rand > 0.5) * 2 - 1;    % 1Ϊ���� -1Ϊ��           
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        tCross = GetSecs;

        % ���Ƽ���̼�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
        Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %�õ���ǰtrial������ɵ�λ�ú�����
        Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
        ClrPreitem = StimClrIDs(1:6,:)';
        DrawRect2( wPtr, Locx, Locy, StimLength, ClrPreitem, xCenter, yCenter);
        
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tCrossOnset + tPreFix - slack); %�̼����֣�����ע�ӵ�
        tStim = GetSecs;
        
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        tDelayCross = GetSecs;
        
        % �������ϴ̼�
        if Change_or_not==1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:6,:)';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
           
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
           
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(iTrial).Feedback = 1;
              Data(iTrial).response = 1;
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(iTrial).Feedback = 0;
              Data(iTrial).response = 2;
              break
              else
              Data(iTrial).Feedback = nan;
              Data(iTrial).response = nan;
              Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
        % �������ϴ̼�       
        if Change_or_not==-1
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross); %����ע�ӵ�
           Locx = [StimxIDs(1:3),StimxIDs(1:3)]'; %�õ���ǰtrial������ɵ�λ�ú�����
           Locy = [StimyIDs(1:3),StimyIDs(2),StimyIDs(3),StimyIDs(1)]'; %�õ���ǰtrial������ɵ�λ��������
           ClrPostitem = StimClrIDs(1:6,:);
           ClrPostitem(StimchangeClrnumIDs(1),:) =  StimClrIDs(7,:);
           ClrPostitem = ClrPostitem';
           DrawRect2( wPtr, Locx, Locy, StimLength, ClrPostitem, xCenter, yCenter);
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           tTestStim = GetSecs;
 
           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross);
        
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStim <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(iTrial).RTs = secs - tTestStimOnsetTime;
              Data(iTrial).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(iTrial).Feedback = 0;
                 Data(iTrial).response = 1;
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(iTrial).Feedback = 1;
                 Data(iTrial).response = 2;
                 break
              else
                 Data(iTrial).Feedback = nan;
                 Data(iTrial).response = nan;
                 Data(iTrial).RTs = nan;
              end
            end
            Screen('Flip', wPtr);           %����ע�ӵ�           
            WaitSecs(tITI);
        end
        
      %% ��¼����
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
        
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data');
     
    %% �رմ���
     Screen('CloseAll');        
   end
   
   
   
   


%% ���ڻ���ע�ӵ���Ӻ���
% function DrawCross(wPtr, x, y, length, width, color)
%     ptsCrossLines = [-length length 0 0; 0 0 -length length];
%     Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %����Ļ�ϻ�������߶�
% end
% 
% 
% 
% 
% %% ���ڻ��ƾ��δ̼����Ӻ���
% function DrawRect2% 

