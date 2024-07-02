

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
    nMonitorID = max(Screen('Screens')); %��Ļ���
    HideCursor(nMonitorID); %����ָ��
    distance = 80;         % distance between subject and monitor
    monitorwidth = 40.5;      % The width of the monitor
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
    
    % ------�̼�����------
    AngStimBar_length = 2; %�̼��ӽ�
    StimBar_length = AngStimBar_length * ppd;
    AngStimBar_width = 0.4;
    WideBar = AngStimBar_width * ppd;
    BarOri = [16, 36, 56, 76, 96, 116, 136, 156, 176]; %�̼����п��ܵ�9�ֳ���
    clrStim = [255, 0, 0];           % Red
    load([path,'sub',subinfo{1},'_triallists.mat'])
    
    % ------ʱ������̿���------
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimOnsetDuraion = 0.2; %�̼����ֵ�ʱ��
    tRentionDuraion = 0.9; %���䱣��ʱ��
    tITI = 0.2 * rand; % Inter Trial Interval
    StimTrialNum = 60; % ÿ��block��trial��
    Blocknum = 6;
    response_interval = 3; %�����ʱ�� 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    
    % ------trial ˳��------
    StimIDs = [111,112,113,121,122,123,211,212,213,221,222,223,311,312,313,321,322,323]; %���ɶ���1:StimNum���� ��һλ��/�� �ڶ�λ����/��
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
    NetStation('StartRecording');
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
      for iBlock = 1:Blocknum
       for iTrial = 1:StimTrialNum
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;  
            
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawStimDisplay(wPtr, clrCross, center);
        tFixOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��

        % ���Ƽ���̼�
        DrawStimDisplay(wPtr, clrCross, center);
        % bars�ĳ��������
        BarOriIDs = BarOri(:,randperm(9));  %���������
        % �̼�λ������
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
         Screen('DrawLines', wPtr, StimLines, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�            
                  
        %���ּ���̼�
        tStimOnsetTime = Screen('Flip', wPtr, tFixOnset + tPreFix - slack); %�̼����֣�����ע�ӵ�
        
        % ���Ƽ���̼����ֺ��ע�ӵ�
        Screen('FillRect', wPtr, clrBg);
        DrawStimDisplay(wPtr, clrCross, center);
        tCrossdelayOnset = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==1 % ����
            if fix(StimIDs(totaltrialnum)/100)==1 % L2
                    TestStimLine = StimLines(:,[(fix(rand*2)+1)*2-1,(fix(rand*2)+1)*2]);
            elseif fix(StimIDs(totaltrialnum)/100)==2 % L4
                    TestStimLine = StimLines(:,[randi([1,4])*2-1,randi([1,4])*2]);
            else
                    TestStimLine = StimLines(:,[randi([1,6])*2-1,randi([1,6])*2]);
            end
                  
           DrawStimDisplay(wPtr, clrCross, center);
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
       
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�

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
              break
              elseif find(keyCode)== rightkey %ѡ��
              Data(totaltrialnum).Feedback = 0;
              Data(totaltrialnum).response = 2;
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

            Screen('Flip', wPtr);           %����ע�ӵ�           
        end
        
        % �������ϴ̼�
        if fix(mod(StimIDs(totaltrialnum),100)/10)==2 % ��
            
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
           Screen('DrawLines', wPtr, TestStimLine, WideBar, clrStim,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�
        
           %�������ϴ̼�
           tTestStimOnsetTime = Screen('Flip', wPtr,tCrossdelayOnset + tRentionDuraion - slack); %�̼����֣�����ע�ӵ�

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
                 break
              elseif find(keyCode) == rightkey %ѡ��
                 Data(totaltrialnum).Feedback = 1;
                 Data(totaltrialnum).response = 2;
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
 
            Screen('Flip', wPtr);           %����ע�ӵ�           
    end

      %% ��¼����
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
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Kscores_',subinfo{8},'_',subinfo{9},'_',num2str(GetSecs),'.mat');
     save([path,behaviordataname],'Data','subinfo');

    NetStation('StopRecording');
    WaitSecs(20);

    Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10, clrText);
    Screen('Flip', wPtr);
    NetStation('StartRecording');

    % �ȴ�������ʼʵ��
    KbWait();

      end
    %% ��������
     behaviordataname=strcat('sub',subinfo{1},'_Kscores_',subinfo{8},'_',subinfo{9},'.mat');
     save([path,behaviordataname],'Data','subinfo');
     
    %% �رմ���
     Screen('CloseAll');        


     
     
     
