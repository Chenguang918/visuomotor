

% Change detection ʵ�����
% set-size two four 
% Coded by DW. Li @ BNU 2020-07-28

    %% ����ǰ׼������
    clear; %������б����������ϴ����еĲ�������Ӱ�챾������
    clc; %������������֣��Ա㱾���������������ϴεĻ���
    close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
    Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

    
    %% �������ò���
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Eyesight','BenefitedHand','CueColor','CondtionType','Times'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','5.0','right','Blue','Loadfour','first'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    path='E:\Song\Song\ldw\Data\';
    
    % ------��ʾ����------
    bSkipSyncTests = 0; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    nMonitorID = max(Screen('Screens'))-1; %��Ļ���
    HideCursor(nMonitorID); %����ָ��
    distance = 100;         % distance between subject and monitor
    monitorwidth = 40;      % The width of the monitor
    clrBg = [130 130 130];  %ָ��������ɫ��ɫ
    
    % �˴����ڿ�����رմ�ֱͬ������
    Screen('Preference','SkipSyncTests',bSkipSyncTests);
    
    % ��ʼ����Ļ���õ���Ļ����
    [wPtr , wRect]  = Screen('OpenWindow',nMonitorID, clrBg); % Open the stimulus window on the specified display
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
    [xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
    slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree

    % ------ע�ӵ����------
    AngleFix = 0.2;
    Fixcir_size = fix(AngleFix * ppd);      %ע�ӵ�Ĵ�ϸ
    center = [xCenter-Fixcir_size, yCenter-Fixcir_size,xCenter+Fixcir_size, yCenter+Fixcir_size]';
    clrCross = [0 0 0];   %ָ��ע�ӵ���ɫΪ��ɫ
    
    % ------��������------
    AngleArrowCue = fix(1.2 * ppd);
    CenterLeftArrowxyLists = [-AngleArrowCue,0;0,AngleArrowCue/2;0,-AngleArrowCue/2];    %���ͷ����
    CenterRightArrowxyLists = [AngleArrowCue,0;0,AngleArrowCue/2;0,-AngleArrowCue/2];    %�Ҽ�ͷ����
    if strcmp(subinfo{7} , 'Blue')
       TclrArrow = [21 165 234];  % Ŀ�����ɫ����
       DclrArrow = [133 194 18];  % �޹ص���ɫ����
    else
       TclrArrow = [133 194 18];  % Ŀ�����ɫ����
       DclrArrow = [21 165 234];  % �޹ص���ɫ����
    end
    
    % ------�̼�����------
    AngStimBar_length = 2.4; %�̼��ӽ�
    StimBar_length = AngStimBar_length * ppd;
    AngStimBar_width = 0.4;
    WideBar = AngStimBar_width * ppd;
    BarOri = [16, 36, 56, 76, 96, 116, 136, 156, 176]; %�̼����п��ܵ�9�ֳ���
    clrStim = [255, 0, 0];           % Red
    load([path,'sub',subinfo{1},'_triallists.mat'])
    
    % ------ʱ������̿���------
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tCueOnsetDuraion = 0.3; %�������ֵ�ʱ��
    tStimOnsetDuraion = 0.2; %�̼����ֵ�ʱ��
    tRentionDuraion = 1; %���䱣��ʱ��
    tITI = 0.3 * rand; % Inter Trial Interval
    StimTrialNum = 48; % ÿ��block��trial��
    Blocknum = 6;
    response_interval = 3; %�����ʱ�� 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------trigger����------
    %NetStation('Connect', '10.10.10.42');
    %NetStation('Synchronize');

    MarkerLoadTwoBlockBegin = 1;   MarkerLoadTwoBlockEnd = 2;   MarkerLoadFourBlockBegin = 3;   MarkerLoadFourBlockEnd = 4;
    MarkerCorrectResponse = 100;   MarkerWrongResponse = 99;   MarkerNoResponse = 999;
    MarkerLowloadTestLeftNochange = 111;   MarkerLowloadTestLeftChange = 112;    MarkerLowloadTestRightNochange = 121;    MarkerLowloadTestRightChange = 122;
    MarkerHighloadTestLeftNochange = 211;    MarkerHighloadTestLeftChange = 212;    MarkerHighloadTestRightNochange = 221;    MarkerHighloadTestRightChange = 222;
    MarkerLowloadLeftcue = 101;   MarkerLowloadRightcue = 102;    MarkerHighloadLeftcue = 201;    MarkerHighloadRightcue = 202;
    MarkerLowloadLeftMemory = 11;   MarkerLowloadRightMemory = 12;    MarkerHighloadLeftMemory = 21;    MarkerHighloadRightMemory = 22;
    MarkerPreCueFixation = 254;   MarkerPostMemoryFixation = 253;
    

    % ------trial ˳��------
    StimIDs = [111,112,113,121,122,123,211,212,213,221,222,223]; %���ɶ���1:StimNum���� ��һλ��/�� �ڶ�λ����/��
    StimIDs = repmat(StimIDs,1,StimTrialNum*Blocknum/length(StimIDs));
    StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %���������

    %% �̼����ֲ���    
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

%�ةЩةУ����ܣߣ�����
%�ЩةЩب�    ������������
%�ةЩأ���  ��            ��
%�ЩبM              ��      ��
%�ةШ�                ��    ��
%�Щب�                      ����
%�ب�������              �ܣߣߣ�
%�Ш�����������              ��                                            MAIN PROGRAM IS COMMING !!!
%�ب���������������������������
%�������������������������������}�{
%�������������������������������}�{
%������������������������������������
%������������ ������������������      ��
%�ب���������  ��������������           ��
%�Щ�      ��������������                ��
%�ة�      ��                            ��
%�ШM      �M        ����������         �M
%*�M�ߣ�_����      �M           ��    ����
%�ЩةЩةЩأ�     ��_        ����        ��
%�ةЩةЩةЩ� �ܣߣߣߣ�         ��������   ��������
%���������W�i�i�i�i�i�i�i�i��      �M    ������  ������

%% Body Program

% ----------Load Two Condition ----------

   if strcmp(subinfo{8} , 'Loadtwo')

      for iBlock = 1:Blocknum
         %NetStation('Event', num2str(MarkerLoadTwoBlockBegin));
       for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        %NetStation('Event', num2str(MarkerPreCueFixation), tFixOnset, 0.001);
        
        % ���Ƽ�ͷ����Cue
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
        Screen('FillPoly',wPtr, TclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else  % cue right
        Screen('FillPoly',wPtr, TclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);            
        end
        tCueOnset = Screen('Flip', wPtr, tFixOnset + tPreFix + tITI - slack); %����ע�ӵ㣬��¼����ʱ��
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerLowloadLeftcue), tCueOnset, 0.001);
        else
           %NetStation('Event', num2str(MarkerLowloadRightcue), tCueOnset, 0.001);
        end
            

        % ���Ƽ���̼�
        DrawStimDisplay(wPtr, clrCross, center);
        % bars�ĳ��������
        BarOriIDs = BarOri(:,randperm(9));  %���������
        % �̼�λ������
        FarID = rand;
        if FarID > 0.5  % ����Ұ��Զ�����
           StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))];
        else   % ����Ұ��Զ�����
           StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(4))];
        end      
        Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
         
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %�̼����֣�����ע�ӵ�
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerLowloadLeftMemory), tStimOnsetTime, 0.001);
        else
           %NetStation('Event', num2str(MarkerLowloadRightMemory), tStimOnsetTime, 0.001);
        end
        
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        %NetStation('Event', num2str(MarkerPostMemoryFixation), tCrossdelayOnset, 0.001);
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % ����
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
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
       
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerLowloadTestLeftNochange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerLowloadTestRightNochange), tTestStimOnsetTime, 0.001);
           end

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
           
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              %NetStation('Event', num2str(MarkerCorrectResponse));
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              %NetStation('Event', num2str(MarkerWrongResponse));
              break
              elseif find(keyCode)== Esckey % �˳�
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
            Screen('Flip', wPtr);           %����ע�ӵ�           
        end
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % ��
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                if mod(StimIDs(totaltrialnum),10) == 1 % �����Χ��
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
                elseif mod(StimIDs(totaltrialnum),10) == 2  % �����·���
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
                else % ��Բ�
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
                if mod(StimIDs(totaltrialnum),10) == 1 % �����Χ��
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
                elseif mod(StimIDs(totaltrialnum),10) == 2  % �����·���
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
                else % ��Բ�
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
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerLowloadTestLeftChange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerLowloadTestRightChange), tTestStimOnsetTime, 0.001);
           end

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
                   
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;
                 %NetStation('Event', num2str(MarkerWrongResponse));
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
                 %NetStation('Event', num2str(MarkerCorrectResponse));
                 break
              elseif find(keyCode)== Esckey % �˳�
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
            Screen('Flip', wPtr);           %����ע�ӵ�           
    end

      %% ��¼����
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
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    %NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('StartRecording');

    % �ȴ�������ʼʵ��
    KbWait();

      end
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% �رմ���
     Screen('CloseAll');        
   end


% ----------Load Four Condition ----------

   if strcmp(subinfo{8} , 'Loadfour')

      for iBlock = 1:Blocknum       
         %NetStation('Event', num2str(MarkerLoadFourBlockBegin));
        for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        %NetStation('Event', num2str(MarkerPreCueFixation), tFixOnset, 0.001);
        
        % ���Ƽ�ͷ����Cue
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
        Screen('FillPoly',wPtr, TclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        else  % cue right
        Screen('FillPoly',wPtr, TclrArrow, CenterRightArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);
        Screen('FillPoly',wPtr, DclrArrow, CenterLeftArrowxyLists + [xCenter, yCenter;xCenter, yCenter;xCenter, yCenter]);            
        end
        tCueOnset = Screen('Flip', wPtr, tFixOnset + tPreFix + tITI - slack); %����ע�ӵ㣬��¼����ʱ��
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerHighloadLeftcue), tCueOnset, 0.001);
        else
           %NetStation('Event', num2str(MarkerHighloadRightcue), tCueOnset, 0.001);
        end

        % ���Ƽ���̼�
        DrawStimDisplay(wPtr, clrCross, center);
        % bars�ĳ��������
        BarOriIDs = BarOri(:,randperm(9));  %���������
        % �̼�λ������
        StimLines = ppd*[locX(totaltrialnum,1)-1.2*sind(BarOriIDs(1)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(1)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(2)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(2)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(3)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(3)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(4)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(4)) ...
                        locX(totaltrialnum,1)-1.2*sind(BarOriIDs(5)) locX(totaltrialnum,1)+1.2*sind(BarOriIDs(5)) -locX(totaltrialnum,1)-1.2*sind(BarOriIDs(6)) -locX(totaltrialnum,1)+1.2*sind(BarOriIDs(6)) ...
                        locX(totaltrialnum,2)-1.2*sind(BarOriIDs(7)) locX(totaltrialnum,2)+1.2*sind(BarOriIDs(7)) -locX(totaltrialnum,2)-1.2*sind(BarOriIDs(8)) -locX(totaltrialnum,2)+1.2*sind(BarOriIDs(8));...
                        locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(1)) locY(totaltrialnum,1)-1.2*cosd(BarOriIDs(2)) locY(totaltrialnum,1)+1.2*cosd(BarOriIDs(2))...
                        locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(3)) locY(totaltrialnum,2)-1.2*cosd(BarOriIDs(4)) locY(totaltrialnum,2)+1.2*cosd(BarOriIDs(4))...
                        locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(5)) locY(totaltrialnum,3)-1.2*cosd(BarOriIDs(6)) locY(totaltrialnum,3)+1.2*cosd(BarOriIDs(6))...
                        locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(7)) locY(totaltrialnum,4)-1.2*cosd(BarOriIDs(8)) locY(totaltrialnum,4)+1.2*cosd(BarOriIDs(8))];
  
        Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
         
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tCueOnset + tCueOnsetDuraion - slack); %�̼����֣�����ע�ӵ�
        if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
           %NetStation('Event', num2str(MarkerHighloadLeftMemory), tStimOnsetTime, 0.001);
        else
           %NetStation('Event', num2str(MarkerHighloadRightMemory), tStimOnsetTime, 0.001);
        end
                
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        %NetStation('Event', num2str(MarkerPostMemoryFixation), tCrossdelayOnset, 0.001);
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % ����
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
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerHighloadTestLeftNochange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerHighloadTestRightNochange), tTestStimOnsetTime, 0.001);
           end

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
           
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              %NetStation('Event', num2str(MarkerCorrectResponse));
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
              %NetStation('Event', num2str(MarkerWrongResponse));
              break
              elseif find(keyCode)== Esckey % �˳�
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
            Screen('Flip', wPtr);           %����ע�ӵ�           
        end
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % ��
            if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
                if mod(StimIDs(totaltrialnum),10) == 1 % �����Χ��
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
                    
                elseif mod(StimIDs(totaltrialnum),10) == 2  % �����·���
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

                else % ��Բ�
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
                if mod(StimIDs(totaltrialnum),10) == 1 % �����Χ��
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
                    
                elseif mod(StimIDs(totaltrialnum),10) == 2  % �����·���
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

                else % ��Բ�
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
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�
           if floor(StimIDs(totaltrialnum)/100) ==1 % cue left
              %NetStation('Event', num2str(MarkerHighloadTestLeftChange), tTestStimOnsetTime, 0.001);
           else
              %NetStation('Event', num2str(MarkerHighloadTestRightChange), tTestStimOnsetTime, 0.001);
           end

           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawStimDisplay(wPtr, clrCross, center);
                   
           %�ȴ�������Ӧ����¼����
            while GetSecs - tTestStimOnsetTime <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              Data(totaltrialnum).RTs = secs - tTestStimOnsetTime;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;
                 %NetStation('Event', num2str(MarkerWrongResponse));
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
                 %NetStation('Event', num2str(MarkerCorrectResponse));
                 break
              elseif find(keyCode)== Esckey % �˳�
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
            Screen('Flip', wPtr);           %����ע�ӵ�           
        end
        
      %% ��¼����
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
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    %NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    %NetStation('StartRecording');
    % �ȴ�������ʼʵ��
    KbWait();

      end
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% �رմ���
     Screen('CloseAll');        
   end
% 
