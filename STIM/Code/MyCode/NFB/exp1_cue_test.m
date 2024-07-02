% Exp1 with pre-cue for ERP class
% Coded by YQ.Hu @ BNU 2020-11-25
    %% ����ǰ׼������
    clear; %
    clc; %
    close all; %
%     Priority(1); %
    rand('state',sum(100*clock));  
    
    % ---Connection Config---
%     config_io
%     outp(888, 0);  

    % ------Submessage-----
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Hand','run'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','hu','1','19940501','right','1'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    commandwindow;
%     dataPath='E:\Huyiqing\Exp1_Cue\';
    dataPath='C:\Users\15455\Documents\MyWork\Data\Exp1_Cue\';
    dataname='beha_data.mat';
    filename=strcat(dataPath,dataname);
    
    % --------Store------
    subid_name_file=strcat('sub',subinfo{1});
    filepath=strcat(dataPath,'\experimentdata\subexpdata\','sub',subinfo{1},'\');
    if ~exist(filepath,'dir')
         mkdir(filepath);
    end
    
     % ------��ʾ����------
     screenNumber = max(Screen('Screens')); %
     distance = 57;         % distance between subject and monitor
     monitorwidth = 41;      % The width of the monitor
     
     % ---PTB Parameters---
     % �˴����ڿ�����رմ�ֱͬ������
     bSkipSyncTests = 0; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
     Screen('Preference','SkipSyncTests',bSkipSyncTests);   
     [w, wRect] = PsychImaging('OpenWindow', screenNumber, [0,0,0], [], 32, 2,[], [],  kPsychNeed32BPCFloat);
     Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  %��͸���Ȼ�Ϲ���(�������Ҫ)
     [center(1), center(2)] = WindowCenter(w);                          
     slack = Screen('GetFlipInterval',w)/2;
     ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;  % ���ݾ���ĻԶ������Ļ��С���ʴ̼���С
%      HideCursor;

%% MAIN PROGRAM
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


%% ��������
     % -----ɫ�ʲ���------
     background = [0,0,0];                                       %The background color            
     gra = [128,128,128];                                        %The sti color
     colorindex=[];
     
     % ------��������------
    CenterLeftArrowxyLists = [-36,0;-20,12;-20,4;20,4;20,-4;-20,-4;-20,-12];    %���ͷ����
    CenterRightArrowxyLists = [36,0;20,12;20,4;-20,4;-20,-4;20,-4;20,-12];    %�Ҽ�ͷ����
    CenterNeuralArrowxyLists = [-36,0;-20,12;-20,4;20,4;20,12;36,0;20,-12;20,-4;-20,-4;-20,-12];    %�Ҽ�ͷ����

    % ----ʱ������̿���----
    tPreFix = 0.2;          %�̼�����ǰע�ӵ���ֵ�ʱ��
    tCueOnsetDuraion = 0.2; %�������ֵ�ʱ��
    tCrossDalyDuraion = 1;  %�������ֺ�ע�ӵ����ʱ��
    tStimDuraion = 0.2;     % �̼�����ʱ��
    tITI = 0.5 * rand;      % Inter Trial Interval
    response_interval = 2;  %�����ʱ�� 
    
    % ------��������------
    KbName('UnifyKeyNames');
    upkey = KbName('2'); 
    downkey = KbName('1');
    EscapeKey = KbName('ESCAPE'); % �жϳ��򰴡�Esc��

    % ----block & trial----
    trial=4; % ���ڲ�ͬ�̼�����ռ�Ȳ�ͬ
    block=2;

    % trial=80; % ���ڲ�ͬ�̼�����ռ�Ȳ�ͬ
    % block=6;


%% -----Introduction-----
sttext = 'Welcome! Press SPACE key to start';
breaktext='Take a break and then press SPACE key to start';
endtext = 'Congratulations! The exp has been finished!';
font = 'Arial';
fontsize = 30;
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background);
Screen('DrawText', w , sttext, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
KbWait;%�ȴ�ֱ������ 

%% ----Condition List----
list=randperm(trial); % ������̼�

condition_index(list(1))=21;         %  up left
condition_index(list(2))=22;         %  up right
condition_index(list(3))=13;         %  down left
condition_index(list(4))=14;         %  down right

%  Target can be at 4 positions 
% condition_index(list(1:20))=21;    %  up left
% condition_index(list(21:40))=22;   %  up right
% condition_index(list(41:60))=13;   %  down left
% condition_index(list(61:80))=14;   %  down right

%% --- fixation+ ---
linedeg = 1;                                                      %The visual angel of the line
length = ceil(linedeg*ppd);

fixrect=[];
fixrect=[fixrect;0,1/2*length;0,-1/2*length];
fixrect=[fixrect;-1/2*length,0;1/2*length,0];
firstfixtime=1;                                                  % ÿ��block��ʼǰfix������ʱ��
fixationtime=randi([1000,1200],1,1)/1000;                        %���������
responsetime=1;
fixdeg = 0.14;                                                    %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 
%% ----- Sti -----
 % diamonds
diamonddeg =3.0;                                                   %The visual angle of the diamond(deg)
diamondiameter = ceil(diamonddeg*ppd);                             %The diameter of the diamond(pixel)
 % round
rounddeg = 2.7;                                                    %The visual angle of the circle(deg)
rounddiameter = ceil(rounddeg*ppd);                                %The diameter of the circle(pixel)      

 % Sti array 
stifromfix = 9.2;                                                   %The visual angle between the fixation and the stimulus
radius = stifromfix * ppd;                                          %The clock radius
stinum=12;
anglestep = 360/stinum;                                             %The angle between two closest stimulus
circlerect = [];                                                    %To store the coordinates of all the stis' boders
relcenterx = [];
relcentery = [];
relcenterxAll = [];
relcenteryAll = [];


%% --- draw round ---
for clocknumber = 1:12
    relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every sti
    relcentery = radius * cos(anglestep*clocknumber*pi/180);
    bodercoordinate = [center(1)+relcenterx-rounddiameter/2, center(2)-rounddiameter/2-relcentery, center(1)+relcenterx+rounddiameter/2, center(2)-relcentery+rounddiameter/2];     %The boders' coordinates of all the circle
    circlerect = [circlerect;bodercoordinate];
    relcenterxAll = [relcenterxAll,relcenterx] ;
    relcenteryAll = [relcenteryAll,relcentery];
end

circlerect = circlerect'; % ת��

%% -- cue target array--
Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime); 

for blockindex=1:block
for ntrial=1:trial
   %% Sti Type
    totaltrialnum = ntrial+(blockindex-1)*trial;
    stiindex = condition_index(ntrial);
    Targetlocindex = fix(stiindex/10);        %to decide the direction of the round  1:down 2:up
    StiType =mod(stiindex,10);                % ȡ�� to decide sti type 1 2 3 4,Բ���ڵ��ĸ�λ��
    TargetDirect = mod(StiType,2);            % �ж�Բ������������ 1:left 0:right
    diamonterx = relcenterxAll;
    diamontery = relcenteryAll;
    
    %% ����cue����ǰ��ע�ӵ�
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1); 
    tCrossOnset = Screen('Flip', w);          %����ע�ӵ㣬��¼����ʱ��
    
    %% draw cue 
     Neural_or_not = (rand > 0.5);            % 1ΪNeural,0Ϊ����          
     
    if Neural_or_not == 1
        Screen('FillPoly',w, gra, CenterNeuralArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
    else 
         if TargetDirect == 1
        Screen('FillPoly',w, gra, CenterLeftArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
        else
        Screen('FillPoly',w, gra, CenterRightArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
        end
    end
 
     tCueOnset = Screen('Flip', w, tCrossOnset + tPreFix - slack); %����cue����¼����ʱ�� 
%      oupt(888,(Change_or_not+1)*100+mb*10+ma); % �ٷ�λ��2����cue,1����cue ʮ��λ��1T��0T�� ��λ��sti����
     WaitSecs(0.004);
%      oupt(888, 0); 

     %% cue�����ע�ӵ�
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  % ����ע�ӵ�
     tCrossDelayTime = Screen('Flip', w, tCueOnset + tCueOnsetDuraion - slack); %�̼����֣�����ע�ӵ�
     
      %% ����Stiλ��
    switch StiType        
        case 1 % cue:yellow & green  dis middleline-Nt
                   tarloca=10;
                   tarloca2=8;
        case 2 % cue:red&green  tar midline  _Pd
                   tarloca=2;
                   tarloca2=4;
        case 3
                   tarloca=8;
                   tarloca2=10;
        case 4  % opposite
                   tarloca=4;
                   tarloca2=2;
    end
    
    roundlocal(:,1)= circlerect(:,tarloca); % T
    diamonterx(tarloca2) = [];
    diamontery(tarloca2) = [];
    
    
      %% ����
        switch Targetlocindex
        case 2
            rightkey = upkey;
            wrongkey = downkey;
        case 1
            rightkey = downkey;
            wrongkey = upkey;
        end
        
      %% ����Sti��
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation

 for clocknumber2 = 1:11
%     diamonterx(clocknumber2) = radius * sin(anglestep*clocknumber2*pi/180);        %To calculate the coordinates of the center of every sti
%     diamontery(clocknumber2) = radius * cos(anglestep*clocknumber2*pi/180);
      bodercoordinate2 = [center(1)+diamonterx(clocknumber2), center(2)+diamontery(clocknumber2)+diamondiameter/2;
                          center(1)+diamonterx(clocknumber2)+diamondiameter/2, center(2)+diamontery(clocknumber2);
                          center(1)+diamonterx(clocknumber2), center(2)+diamontery(clocknumber2)-diamondiameter/2;
                          center(1)+diamonterx(clocknumber2)-diamondiameter/2, center(2)+diamontery(clocknumber2);];     %The boders' coordinates of all the circle
%     circlerect2(clocknumber2,:,:) = bodercoordinate2;
    Screen('FillPoly', w, gra, bodercoordinate2);  
 end 
    Screen('FillOval', w, gra, roundlocal);                                          %��round   
    tStimOnsetTime = Screen('Flip', w, tCrossDelayTime + tCrossDalyDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
    
%     outp(888, stiindex);
    WaitSecs(0.004);
%     outp(888, 0);
    
    %% ���ƴ̼����ֺ��ע�ӵ�,��¼��Ӧ
     Screen('FillRect', w, background);                                              %draw the background
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
     tCrossRespTime = Screen('Flip', w, tStimOnsetTime + tStimDuraion - slack); %����ע�ӵ㣬��¼����ʱ��
     
    %% �ȴ�������Ӧ
    while GetSecs - tStimOnsetTime <= response_interval
         [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
         Data(totaltrialnum).RTs = secs - tStimOnsetTime;   
            if find(keyCode)== rightkey     %ѡ��
              Data(totaltrialnum).ACC = 1;
              Data(totaltrialnum).response = str2num(KbName(rightkey));
              res_trg=100; 
              break
            elseif find(keyCode)== wrongkey  %ѡ��
              Data(totaltrialnum).ACC = 0;
              Data(totaltrialnum).response = str2num(KbName(wrongkey)); 
              res_trg=99; 
              break
            elseif  find(keyCode) == EscapeKey
              Data(totaltrialnum).RTs = nan;
              Screen('CloseAll'); 
              break
            else
              Data(totaltrialnum).RTs = nan;
              Data(totaltrialnum).ACC = nan;
              Data(totaltrialnum).response = nan;
              res_trg=99;  
            end
    end
     Screen('FillRect', w, background);                                              %draw the background
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
     Screen('Flip', w);           %����ע�ӵ�  
%    outp(888, res_trg); 
     WaitSecs(0.004);
%    outp(888, 0);
     WaitSecs(tITI);
    
 %% ��¼����
       Data(totaltrialnum).StiType = stiindex;
       Data(totaltrialnum).CResp = Targetlocindex;
       Data(totaltrialnum).CueType=(Neural_or_not+1)*100+TargetDirect*10+StiType; % % �ٷ�λ��2����cue,1����cue ʮ��λ��1T��0T�� ��λ��sti����
       Data(totaltrialnum).TrialNum = totaltrialnum;

end
% һ��block����
Screen('DrawText', w, breaktext, 5*center(1)/10, center(2), gra, background);
Screen('Flip', w);
KbWait;%�ȴ�ֱ������

end
% ʵ�����
Screen('FillRect', w, background);
Screen('DrawText', w , endtext, 3.2*center(1)/5, center(2), gra);
Screen('Flip', w);
WaitSecs(2);

 %% ��������
behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Exp1_Cue_',subinfo{6},'.mat');
save([filepath,behaviordataname],'Data');

ShowCursor
Screen('CloseAll');
