% Fly Fly Fly! Introduce and Practice
% Edit by 21/12/06
clear all;
clc
clear all

bSkipSyncTests =0; 
Screen('Preference','SkipSyncTests',bSkipSyncTests);
commandwindow;
dataPath = pwd;
Screen('Preference', 'SkipSyncTests', 1);%The path of the data files


%% parameters

stimtime = 0.2;  
repeat=1;
PositionNum= 6; 
SampleRate = 15; %Hz 
SOADuration= 3-0.2; %s 43个点
MinSOA= 1.8 ; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;



block=1;
trial = TimePoint*PositionNum*repeat ;                                                         % 6block*80 trial*2days
distance = 57; %�?                                                    %The distance between subject and monitor(cm)
Estimated_time = ((MinSOA+MaxSOA)*0.5+1)*trial/60*4/3;
monitorwidth = 53;                                                 %The width of the monitor(cm)
background = [63,63,63];                                       %The background color                                                         %The trial number
red = [0.79,0.15,0.03]'*255;
gre = [0.07,0.91,0.15]'*255;
gra = [192,192,192]';
black=[0,0,0]'*255;


screens = Screen('Screens');
screenNumber = max(screens);
[w, rect] = Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
winWidth = rect(3);
winHeight = rect(4);
% HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐�?
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   
slack = Screen('GetFlipInterval',w)/2; %得到每一帧时间的�?��


%% line
linedeg = 1.2;                                                       %The visual angel of the line
Length = ceil(linedeg*ppd);

%% fixation+
fixrect=[];
fixrect=[fixrect;0,1/2*Length;0,-1/2*Length];
fixrect=[fixrect;-1/2*Length,0;1/2*Length,0];
firstfixtime=0.5;
fixationtime=randi([1200,1600],1,1)/1000;
responsetime=2;
fixdeg = 0.1;                                                     %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 


%% 生成target�?��位置序列，在每个SOA点都重复出现4�?
SOAID= 1:TimePoint;
targettrial=30;
StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID7=700+SOAID; % target at position 6
StimIDs=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDRepeat1=StimIDs(:,randperm(length(StimIDs)));     % �?��重复
StimIDRepeat2=StimIDs(:,randperm(length(StimIDs)));     % 
StimIDRepeat3=StimIDs(:,randperm(length(StimIDs)));     % 
StimIDs=[StimIDRepeat1,StimIDRepeat2,StimIDRepeat3]; % Detect Exp stimID
StimIDs=StimIDs(1,1:targettrial);


    
%% Introduction
Practicetext='��ȷ�ϼ���ʼ��ϰ';
breaktext='��ȷ�ϼ�������ϰ';
font = 'Arial';
fontsize = 30;
IntroductionFly(w,rect,fontsize,font,background,center,gra)


%% cue&target array
trialnum=0;trial_main=0; trial_control=0;hit=0;miss=0;wrong=0;
controltrial=4;

for blockindex=1:block %:block
%% Practice begin
  Screen('TextSize', w ,fontsize);
  Screen('TextFont', w, font);
  Screen('FillRect', w, background);
  Screen('DrawText', w, Practicetext, 2*center(1)/3, center(2), gra);
  Screen('Flip', w);
  WaitSecs(1);
  KbWait_HID;%等待直到按键 
   
    control_SOA=SOAID(:,randperm(length(SOAID)));
    control_SOA=control_SOA(1,1:controltrial);
    trial_control=0;

    
for ntrial=1:targettrial
    %Eyelink('command', 'record_status_message "TRIAL%d Block%d"', ntrial,blockindex);
   
    trial_main=trial_main+1;
    stiindex=StimIDs(trial_main);
    mt=fix(stiindex/100);   % target index 百分�?fix取整 
    ms=mod(stiindex,100);   % SOA d1index 取余mod    
    control_index=0;
    markerindex=1;



    switch mt        
        case 1 
            tarloca=1;

        case 2 
            tarloca=2;

        case 3
            tarloca=3;
             
        case 4
          tarloca=4;
          
        case 5
          tarloca=5;
          
        case 6
          tarloca=6;
          
        case 7
          tarloca=7;
                
    end
    
             
    % Fix Before target
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w);                    %绘制反应时�?的Fix，并且确定以此反应时刻为下一个trial的初始时�?
   
            
    % Fly target (load the pciture)
    M=imread(['target',num2str(tarloca),'-s.jpg ']);
    GIndex=Screen('MakeTexture',w,M); 
    GRect=Screen('Rect',GIndex);
    cGRect=CenterRect(GRect,rect);
    Screen('DrawTexture',w,GIndex,GRect,cGRect);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      %draw the fixation
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);                        % 刺激出现的时刻点(以上个反应结束为起始点）
    tic
    

    % Resp Fix
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      
    tRespOnset=Screen('Flip', w,tTargetOnset+stimtime-slack);                        %反应时的注视�?
    
    
%% Fly response
buffer = toc;
[RT1,RT2,acc,theta,duration,x,y] = joystick2beh(tarloca,30,2,buffer);

    % Marker
    
             if RT1==999
                miss=miss+1;
                % load feedback image
                M=imread('Trialmiss.jpg');
                GIndex=Screen('MakeTexture',w,M);
                GRect=Screen('Rect',GIndex);
                cGRect=CenterRect(GRect,rect);
                Screen('DrawTexture',w,GIndex,GRect,cGRect);
                Screen('Flip', w);
                WaitSecs(1);
            elseif acc==1
                hit=hit+1;
                if theta <=5 
                   % load feedback image
                    M=imread('Trialhighhit.jpg');
                    GIndex=Screen('MakeTexture',w,M);
                    GRect=Screen('Rect',GIndex);
                    cGRect=CenterRect(GRect,rect);
                    Screen('DrawTexture',w,GIndex,GRect,cGRect);
                    Screen('Flip', w);
                    WaitSecs(1);
                else
                   % load feedback image
                    M=imread('Trialhit.jpg');
                    GIndex=Screen('MakeTexture',w,M);
                    GRect=Screen('Rect',GIndex);
                    cGRect=CenterRect(GRect,rect);
                    Screen('DrawTexture',w,GIndex,GRect,cGRect);
                    Screen('Flip', w);
                    WaitSecs(1);
                end
                
             else
                wrong=wrong+1;
               % load feedback image
                M=imread('Trialwrong.jpg');
                GIndex=Screen('MakeTexture',w,M);
                GRect=Screen('Rect',GIndex);
                cGRect=CenterRect(GRect,rect);
                Screen('DrawTexture',w,GIndex,GRect,cGRect);
                Screen('Flip', w);
                WaitSecs(1);
             end


end
%% feedback

Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
WaitSecs(2);
      
   KbWait_HID;%等待直到按键
end

sca;

ListenChar(0);