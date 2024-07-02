 
% Free time NeuroFeedback Visual search 
% Coded by ZCG @ BNU 2020-9-23

    %% ����ǰ׼������
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
    %% �������ò���
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
    
    % ------��ʾ����------
    bSkipSyncTests = 0; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    screenNumber = max(Screen('Screens')); %��Ļ���
    %HideCursor(screenNumber); %����ָ��
    distance = 65;         % distance between subject and monitor
    monitorwidth = 48.3;      % The width of the monitor
%     clrBg = [127 127 127];  %ָ��������ɫ��ɫ

%     % Define black, white and grey
    white = WhiteIndex(screenNumber);
    clrBg = white / 2;
    % �˴����ڿ�����رմ�ֱͬ������
    Screen('Preference','SkipSyncTests',bSkipSyncTests);
    
    % ��ʼ����Ļ���õ���Ļ����
    %[wPtr , wRect]  = Screen('OpenWindow',screenNumber-1, clrBg); % Open the stimulus window on the specified display
     [wPtr , wRect] = PsychImaging('OpenWindow', screenNumber-1, clrBg, [], 32, 2,...
     [], [],  kPsychNeed32BPCFloat);
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
    [xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
    slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree

    % ------ע�ӵ����------
    CrossLength = 10;    %ע�ӵ�ʮ�ֵĳ���
    CrossWidth = 3;      %ע�ӵ�ʮ���ߵĴ�ϸ
    clrCross_b = [0 0 0];   %ָ��ע�ӵ���ɫΪ��ɫ
    clrCross_w = [255 255 255];   %ָ��ע�ӵ���ɫΪ��ɫ
    % ------Garbo����------
    aspectRatio = 1.0;
    phase = 50;
    numCycles = 6;
    clrText = [255, 255, 255];           % white
  
    % ------ʱ������̿���------
    tPreFix = 5.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tCueOnsetDuraion = 0.1; %�������ֵ�ʱ��
    tStimOnsetDuraion =1; %�̼����ֵ�ʱ��
    tRentionDuraion = 3; %���䱣��ʱ��
    tITI = 0.5 * rand; % Inter Trial Interval
    StimTrialNum = 60; %�ܵ�trial��
    Blocknum = 4;
    response_interval = 3; %�����ʱ�� 
    KbName('UnifyKeyNames');
    leftkey=KbName('1');
    rightkey=KbName('2');
    Esckey=KbName('ESCAPE');
    hitnum = 0;
    missnum = 0;
    
    %% �̼����ֲ���    
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
       taskindex=2;
      for iBlock = 1:Blocknum       
          
        outp(888, 1);
        WaitSecs(0.004);
        outp(888, 0);
     
        for iTrial = 1:StimTrialNum
        totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;    
       % ������ɴ̼�����
        Change_or_not = (rand > 0.5);    % 1Ϊ���� -1Ϊ��                
        orientation=fix(180*rand); 
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_w);
        tCrossOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_w); 
        tPreFixOnset=Screen('Flip', wPtr, tCrossOnset+tPreFix-slack);

        % triger NFB
        contrast=0; 
        [gabortex,propertiesMat]=gaborplot(wRect,wPtr,contrast,aspectRatio,phase,numCycles);
        Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [], kPsychDontDoRotation, propertiesMat');        
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %����ע�ӵ�        
        tNFB1Onset =Screen('Flip', wPtr, tPreFixOnset+tStimOnsetDuraion-slack); %�̼����֣�����ע�ӵ�
        outp(888, 1*100+1);
        WaitSecs(0.004);
        outp(888, 0);

        % Feedback

            tic
        contrast=serial_receive(com1); 
        connection_time=toc
        [gabortex,propertiesMat]=gaborplot(wRect,wPtr,contrast,aspectRatio,phase,numCycles);
        Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [], kPsychDontDoRotation, propertiesMat');        
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %����ע�ӵ�        
        tNFB1Onset=Screen('Flip', wPtr,tNFB1Onset+tStimOnsetDuraion-slack); %�̼����֣�����ע�ӵ�
        outp(888, 1*100);
        WaitSecs(0.004);
        outp(888, 0);
%         WaitSecs(tStimOnsetDuraion)

        tStim = GetSecs;
        DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
        tCrossdelayOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
        WaitSecs(tRentionDuraion)
        tDelayCross = GetSecs;
        
        
        % Discrimination Task when change
        if Change_or_not==0
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %����ע�ӵ�
           Screen('DrawTextures', wPtr, gabortex, [], [], orientation, [], [], [], [],...
           kPsychDontDoRotation, propertiesMat');
           %�������ϴ̼�
           Screen('Flip', wPtr); %�̼����֣�����ע�ӵ�
           tic
           outp(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           outp(888, 0);
           %����ע�ӵ�           
           Screen('FillRect', wPtr, clrBg);
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
           
           %�ȴ�������Ӧ����¼����
            while toc < response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              RT = secs;
              Data(totaltrialnum).RTs = RT;
              Data(totaltrialnum).Answer = 1;          
              if find(keyCode)== leftkey %ѡ��
              Data(totaltrialnum).Feedback = 1;
              Data(totaltrialnum).response = 1;
              res_trg=100;  
              acc=1;
              noRespond=0;
              break
              elseif find(keyCode)== rightkey %ѡ��
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
                 Screen('Flip', wPtr);           %����ע�ӵ� 
                 WaitSecs(tITI);
                 outp(888, res_trg);
                 WaitSecs(0.004);
                 outp(888, 0);
        end
        
        % Discrimination Task when nochange      
        if Change_or_not==1 %��
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b); %����ע�ӵ�
           change_ori=fix(-90+180*rand);
           Screen('DrawTextures', wPtr, gabortex, [], [], orientation+change_ori, [], [], [], [],...
           kPsychDontDoRotation, propertiesMat');        
           %�������ϴ̼�
           Screen('Flip', wPtr); %�̼����֣�����ע�ӵ�
           tic
           outp(888, (taskindex-1)*100+(Change_or_not+1)*10+2);
           WaitSecs(0.004);
           outp(888, 0);
           %����ע�ӵ�           
           DrawCross(wPtr, xCenter, yCenter, CrossLength, CrossWidth, clrCross_b);
        
           %�ȴ�������Ӧ����¼����
            while toc <= response_interval
              [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
              RT = toc;
              Data(totaltrialnum).RTs = RT;
              Data(totaltrialnum).Answer = 2;          
              if find(keyCode) == leftkey %ѡ��
                 Data(totaltrialnum).Feedback = 0;
                 Data(totaltrialnum).response = 1;   
                               res_trg=99;  
                               acc=0;
                               noRespond=0;
                 break
              elseif find(keyCode) == rightkey %ѡ��
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
                Screen('Flip', wPtr);           %����ע�ӵ�
                 WaitSecs(tITI);
                 outp(888, res_trg);
                 WaitSecs(0.004);
                 outp(888, 0);
        end
        
%% ��¼����
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
        
        % �ȴ�������ʼʵ��
        KbWait();

      end
      
% behaviordataname=strcat(filename,'.mat');
% save(behaviordataname,'subinfo','Data','meanACC','meanRT' );   
         KbWait();
  
    %% �رմ���
     Screen('CloseAll');      