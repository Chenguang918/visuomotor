% Fly Fly Fly!Include Control Condition; 4 blocks and Each has all SOA conditions;
% SampleRate=14Hz; Duration=3s;
% Include feedback
% Edit by 21/12/06
%     img=Screen('GetImage',w); % save the image
%     imwrite(img,'targetIndex.jpg');

clear all;
clc
clear all

bSkipSyncTests =0; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ������ã�1=���ã�0=�����ã�
Screen('Preference','SkipSyncTests',bSkipSyncTests);
commandwindow;
dataPath = pwd;
Screen('Preference', 'SkipSyncTests', 1);%The path of the data files
config_io 
% address = hex2dec('3EFC');
address = hex2dec('0378');
Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)


com1 = serial('com1','BaudRate',9600,'DataBits',8,'Parity','none','StopBits',1);
try
    fopen(com1)
catch
    fclose(instrfind)
    fopen(com1)
end

%% ------submessage-------
prompt={'���Ա��(��ѯ������)','����',' ѧ��','�Ա�','��������','�Դ�','˫������','����״̬[1�ܾ���2����3����4�е���5����','����״̬[1�ܶ� 2�е�� 3���� 4�е��]',...
    '������Ҫ˵����?��:����Ⱦ�'}; %
dlg_title='������Ϣ'; 
num_lines=1;
defaultanswer={'0','�����','2020211111','��','199807','1','5.0','1','1','balabala'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
subid = str2double(subinfo{1,1});
runnumber = str2double(subinfo{6,1});
subjectname=subinfo{2,1};
%% Definite File-Saved Path
subid_name_file=strcat('sub',subinfo{1,1},'_',subinfo{6,1});
filepath=strcat(pwd,'\Beh_data\','sub',subinfo{1,1},'_',subinfo{6,1},'\');
edffilename = strcat('sub',subinfo{1,1},'_',subinfo{6,1});
if ~exist(filepath,'dir')
    mkdir(filepath);
end


%% parameters
% subjectname = input('Enter the subject name: ');                      %The subject's number
% subject = input('Enter the subject number: ');                      %The subject's number
% runnumber = input('Enter the run number: ');                        %The run number
stimtime = 0.2;  
repeat=3;
PositionNum= 6; 
SampleRate = 15; %Hz 
SOADuration= 3-0.2; %s 43����
MinSOA= 2 ; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;



block=6;
trial = TimePoint*PositionNum*repeat ;                                                         % 6block*80 trial*2days
distance = 57; %��                                                     %The distance between subject and monitor(cm)
Estimated_time = ((MinSOA+MaxSOA)*0.5+1)*trial/60*4/3;
monitorwidth = 53;                                                 %The width of the monitor(cm)
background = [63,63,63];                                       %The background color                                                         %The trial number




red = [0.79,0.15,0.03]'*255;
gre = [0.07,0.91,0.15]'*255;
gra = [192,192,192]';
yel = [255,215,0]';
black=[0,0,0]'*255;
colorindex=[];
colorindex(1,:,:,:)=yel;
colorindex(2,:,:,:)=red;
colorindex(3,:,:,:)=gre;
screens = Screen('Screens');
screenNumber = max(screens);
[w, rect] = Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
winWidth = rect(3);
winHeight = rect(4);
% HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center�õ����ĵ�����
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   
slack = Screen('GetFlipInterval',w)/2; %�õ�ÿһ֡ʱ���һ��

%% data
Resp= 999*ones(block,trial/block+length(nSOA));
BlockRT=999*ones(block,trial/block+length(nSOA));
BlockanyRT=999*ones(block,trial/block+length(nSOA));
BlockACC=999*ones(block,trial/block+length(nSOA));
BlockStiT=999*ones(block,trial/block+length(nSOA));
BlockLO=999*ones(block,trial/block+length(nSOA));
BlockTFixOnset =999*ones(block,trial/block+length(nSOA));
BlockTTargetOnset=999*ones(block,trial/block+length(nSOA));
BlockTRespOnset=999*ones(block,trial/block+length(nSOA));
BlockSecs =999*ones(block,trial/block+length(nSOA));
BlockButton= 999*ones(block,trial/block+length(nSOA));

Button=999*ones(1,trial+length(nSOA)*block);
RT=999*ones(1,trial+length(nSOA)*block);
ACC=999*ones(1,trial+length(nSOA)*block);
StiT=999*ones(1,trial+length(nSOA)*block);
LO=999*ones(1,trial+length(nSOA)*block);
TFixOnset = 999*ones(1,trial+length(nSOA)*block);
TTargetOnset=999*ones(1,trial+length(nSOA)*block);
TRespOnset=999*ones(1,trial+length(nSOA)*block);
Secs =999*ones(1,trial+length(nSOA)*block);

SOAIDs=999*ones(1,trial+length(nSOA)*block);
tSOA=999*ones(1,trial+length(nSOA)*block);

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

%% key
horikey = KbName('1');
vertkey = KbName('3'); 
EscapeKey = KbName('9');


%% circle
circledeg = 3.4;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.2;                                                     %The visual of the side thick(deg)
framethick = ceil(framedeg * ppd);                                  %The thick of the side(pixel)



%% ����target����λ�����У���ÿ��SOA�㶼�ظ�����4��
SOAID= 1:TimePoint;

StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID7=700+SOAID; % target at position 6
StimIDs=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDRepeat1=StimIDs(:,randperm(length(StimIDs)));     % һ���ظ�
StimIDRepeat2=StimIDs(:,randperm(length(StimIDs)));     % 
StimIDRepeat3=StimIDs(:,randperm(length(StimIDs)));     % 
StimIDs=[StimIDRepeat1,StimIDRepeat2,StimIDRepeat3]; % Detect Exp stimID


%% Draw circles                                                     %The display time of the target array
stifromfix = 9.2;                                                   %The visual angle between the fixation and the stimulus
radius = stifromfix * ppd;                                          %The clock radius
anglestep = 360/PositionNum;                                                     %The angle between two closest stimulus
circlerect = [];                                                    %To store the coordinates of all the cirles' boders
for clocknumber = 1:PositionNum
    relcenterx = radius * sin(anglestep*clocknumber*pi/180-anglestep/2*pi/180);        %To calculate the coordinates of the center of every circle
    relcentery = radius * cos(anglestep*clocknumber*pi/180-anglestep/2*pi/180);
    bodercoordinate = [center(1)+relcenterx-diameter/2, center(2)-diameter/2-relcentery, center(1)+relcenterx+diameter/2, center(2)-relcentery+diameter/2];     %The boders' coordinates of all the circle
    circlerect = [circlerect;bodercoordinate];
end
circlerect = circlerect';

%% Triger
% EEG Triger
MarkerExpBegin=254;
MarkerExpEnd=255;
MarkerBlockBegin = 252;
MarkerBlockEnd = 253 ;
MarkerCorrectResponse = 251;
MarkerWrongResponse = 250;
MarkerNoResponse = 249;
% fNIRS Triger
trigger(1,:) = sprintf('A \r\n');      %SOA + target Position1-6
trigger(2,:)= sprintf('B \r\n'); 
trigger(3,:) = sprintf('C \r\n'); 
trigger(4,:) = sprintf('D \r\n'); 
trigger(5,:) = sprintf('E \r\n'); 
trigger(6,:) = sprintf('F \r\n'); 
trigger(7,:) = sprintf('G \r\n');      % control 
trigger(8,:) = sprintf('H \r\n');      % ��Ӧ��ȷ
trigger(9,:) = sprintf('I \r\n');      % ��Ӧ����
trigger(10,:) = sprintf('J \r\n');     % ��Ϣ��ʼ�Լ�����
% Eyelink Triger9
EyelinkSetup
Eyelink('Command', 'set_idle_mode');
% Eyelink('StartRecording');
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


    
    
%% Main Program


sttext = '�����뿿�����ӱ�����Ϣ������';
backgroundtext1='�������ڼ�ʻ���ڣ��������ѧϰ���ݸ˵�����';
backgroundtext2='�����Ϊ6�飬ÿ������ʼǰ����Ҫ������Ϣ2���ӡ�';
backgroundtext3='�밴ȷ�ϼ�������һ�';


breaktext='�����������';
Restend='��Ϣ����,�������뽫ͷ���ڼ����ϣ���ȷ�ϼ�������һ��';
eyetext='��ע����Ļ�����γ��ֵĵ�';
actiontext='�밴ȷ�ϼ�������һ��';
font = 'Arial';
fontsize = 30;

%% 
trialnum=0;blocknum=0;trial_main=0;trial_control=0;   RestTime=120; %s
el.window=w;

    outp(address, MarkerExpBegin);
    WaitSecs(0.004);
    outp(address, 0); 
    
% background
M=imread('fly_background.jpg');
GIndex=Screen('MakeTexture',w,M);
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);  
Screen('DrawText', w, backgroundtext1, 1*center(1)/12, 6/8*center(2), black);
Screen('DrawText', w, backgroundtext2, 1*center(1)/12, 7/8*center(2), black);
Screen('DrawText', w, backgroundtext3, 1*center(1)/12, center(2), black);

Screen('Flip', w);
WaitSecs(2);
KbWait_HID;%�ȴ�ֱ������
conindex=[1,2,3,4,5,6];
conindex=conindex(:,randperm(length(conindex)));
for blockindex=1:block %:block
    trial_control=0;  hit=0;miss=0;wrong=0; highhit=0;
    control_SOA=SOAID(:,randperm(length(SOAID)));

    blocknum=blocknum+1;          
    disp(blocknum);
    %% Rest begin
M=imread('flyrest.jpg');
GIndex=Screen('MakeTexture',w,M);
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('Flip', w);
% WaitSecs(2);
    outp(address, 50);
    WaitSecs(0.004);
    outp(address, 0); 
% fNIRS��
      fwrite(com1,trigger(10,:));                                                    % ####
      WaitSecs(RestTime);                                                     % ####
      fwrite(com1,trigger(10,:)); 
      

  Screen('TextSize', w ,fontsize);
  Screen('TextFont', w, font);
  Screen('FillRect', w, background);
  Screen('DrawText', w, Restend, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
WaitSecs(1);
KbWait_HID;%�ȴ�ֱ������ 

    


%% �۶�У��
    EyelinkDoDriftCorrection(el);
    % Before recording, we place reference graphics on the host display
    % Must be in offline mode to transfer image to Host PC
    Eyelink('StartRecording');    
    
   % marker1
    outp(address, MarkerBlockBegin);
    WaitSecs(0.004);
    outp(address, 0); 

    

%% control image

M=imread(['flycontro',num2str(conindex(blockindex)),'.jpg']);
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('Flip', w);
WaitSecs(2);
KbWait_HID; % 



for ntrial=1:trial/block+length(SOAID)
    Eyelink('command', 'record_status_message "TRIAL%d Block%d"', ntrial,blockindex);
    if ntrial<=length(SOAID)
    mt=conindex(blockindex); 
    trial_control=trial_control+1;
    ms=control_SOA(trial_control);
    control_index=1;
    markerindex=0;
    else
        if ntrial== length(SOAID)+1
            M=imread(['flyformal.jpg']);
            GIndex=Screen('MakeTexture',w,M); 
            GRect=Screen('Rect',GIndex);
            cGRect=CenterRect(GRect,rect);
            Screen('DrawTexture',w,GIndex,GRect,cGRect);
            Screen('Flip', w);
            WaitSecs(2);
            KbWait_HID; 
        end
    trial_main=trial_main+1;
    stiindex=StimIDs(trial_main);
    mt=fix(stiindex/100);   % target index �ٷ�λ fixȡ�� 
    ms=mod(stiindex,100);   % SOA d1index ȡ��mod    
    control_index=0;
    markerindex=1;
    end
    trialnum=trialnum+1;

    Tlineindex=randi([1,2],1,1);% α��� to decide the direction of the line in the target circle  1:hori  2:vert  
    BlockStiT(blockindex,ntrial)=mt;  % Target ���ڵ�λ�ã�1 2 3 4 5 6 7)�е�һ��
    StiT(trialnum)=mt;  % Target ���ڵ�λ�ã�1 2 3 4 5 6)�е�һ��
    tarcolor=[]; 
    stilocation=[];
    
    %��ʼ����clock����ɫ
    for i=1:1:PositionNum   % ��������������meshgrid������ѭ��
        tarcolor(i,:,:,:)=gre; % 10��clock��ʼ��Ϊ��ɫ
    end

    stilocation=ceil(90*randi([1,2],1,10));  % ����clock��line������� 
    % search type  Pd, N2pc, Nt
    switch mt        
        case 1 
            tarloca=1;

        case 2 % cue:red&green  tar midline  _Pd
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
    if tarloca~=7
     tarcolor(tarloca,:,:,:)=yel; % T
    end
     stilocation(tarloca)=Tlineindex*90; % Target��line�������
     stimucolor=tarcolor'; % ����clock��ɫ���Ѿ�ȷ��
     linerect = [];                                                    %To store the coordinates of all the cirles' boders
    


    for clocknumber = 1:PositionNum
        relcenterx = radius * sin(anglestep*clocknumber*pi/180-anglestep/2*pi/180);        %To calculate the coordinates of the center of every circle
        relcentery = -radius * cos(anglestep*clocknumber*pi/180-anglestep/2*pi/180);
        endcoordinate = [relcenterx+Length/2*cos(stilocation(clocknumber)*pi/180), relcentery-Length/2*sin(stilocation(clocknumber)*pi/180);relcenterx-Length/2*cos(stilocation(clocknumber)*pi/180), relcentery+Length/2*sin(stilocation(clocknumber)*pi/180)];     %The boders' coordinates of all the circle
        linerect = [linerect;endcoordinate];
    end
    linerect = linerect';    
    
            switch Tlineindex
        case 1
            rightkey = horikey;
            wrongkey = vertkey;
        case 2
            rightkey = vertkey;
            wrongkey = horikey;
            end
            
    % Fix Before target
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w);                    %���Ʒ�Ӧʱ���Fix������ȷ���Դ˷�Ӧʱ��Ϊ��һ��trial�ĳ�ʼʱ��
   
    % marker
         MarkerSOA=control_SOA(ms);
         fwrite(com1,trigger(mt,:));                                                    % ####
         WaitSecs(nSOA(MarkerSOA));                                                     % ####
         fwrite(com1,trigger(mt,:));  
         
            
    % fly target (load the pciture)
    M=imread(['target',num2str(tarloca),'-s.jpg ']);
    GIndex=Screen('MakeTexture',w,M); 
    GRect=Screen('Rect',GIndex);
    cGRect=CenterRect(GRect,rect);
    Screen('DrawTexture',w,GIndex,GRect,cGRect);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      %draw the fixation
%     Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
%     Screen('FrameOval', w, tarcolor', circlerect, framethick);                      %draw all the stimus
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);                        % �̼����ֵ�ʱ�̵�(���ϸ���Ӧ����Ϊ��ʼ�㣩
    tic
    % marker3
      MarkerTarget=markerindex*(fix(mt/4)+1)*100+ms ;  
      outp(address, MarkerTarget);  % target marker
      WaitSecs(0.002);
      outp(address, 0);
     
    Eyelink('Message', num2str(MarkerTarget));
    
    BlocktSOA(blockindex,ntrial)=nSOA(ms);
    tSOA(trialnum)=nSOA(ms);       %SOA���������ǰ���Ѿ����ɺ���
    BlockSOAIDs(blockindex,ntrial)= ms+100*control_index;
    SOAIDs(trialnum)= ms+100*control_index;

    % Resp Fix
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      
    tRespOnset=Screen('Flip', w,tTargetOnset+stimtime-slack);                        %��Ӧʱ��ע�ӵ�
    BlockTRespOnset(blockindex,ntrial) =tRespOnset;
    
       % marker4
      MarkerTargetPo=80+mt ;  
      outp(address, MarkerTargetPo);  % target marker
      WaitSecs(0.002);
      outp(address, 0);
     
    Eyelink('Message', num2str(MarkerTargetPo));
    
%% Fly response
buffer = toc;
[RT1,RT2,acc,theta,duration,x,y] = joystick2beh(tarloca,30,2,buffer);

    % Marker
    
             if RT1==999
                miss=miss+1;
                
                outp(address, MarkerNoResponse);
                WaitSecs(0.04);
                outp(address, 0);
                Eyelink('Message', num2str(MarkerNoResponse));
            elseif acc==1
                 hit=hit+1;
                 if theta<=5
                 highhit=highhit+1;
                 end
                 MarkerRight=250+acc;
                 outp(address, MarkerRight);
                 WaitSecs(0.04);
                 outp(address, 0);
                 Eyelink('Message', num2str(MarkerRight));
             else
                wrong=wrong+1;
                MarkerWrong=250+acc;
                outp(address, MarkerWrong);
                WaitSecs(0.04);
                outp(address, 0);
                Eyelink('Message',num2str(MarkerWrong));
             end



    
  % Save the Beh data
RTStart(trialnum) = RT1+buffer;
BlockRTStart(blockindex,ntrial)=RT1+buffer;
RTEnd(trialnum) = RT2+buffer;
BlockRespRT(blockindex,ntrial)=RT2+buffer;

ACC(trialnum)=acc; 
BlockACC(blockindex,ntrial)=acc;
Theta(trialnum)=theta;
BlockTheta(blockindex,ntrial)=theta;

Duration(trialnum)=duration;
BlockDuration(blockindex,ntrial)=duration;

X(trialnum)=x; 
BlockX(blockindex,ntrial)=x;

Y(trialnum)=y; 
BlockY(blockindex,ntrial)=y;




% STEP 7.8
        % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
        % Data Viewer. 
        Eyelink('Message', 'TRIAL_RESULT 0');

        
end

Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
%   MarkerBlockEnd
outp(address, MarkerBlockEnd);
    WaitSecs(0.004);
outp(address, 0);  
WaitSecs(2);
%% Feedback
Blockhit(blockindex,:)=hit;
Blockhighhit(blockindex,:)=highhit;
Blockmiss(blockindex,:)=miss;
Blockwrong(blockindex,:)=wrong;


hittext = ['�ɹ����ез�',num2str(hit) ,'��'];
hightext= ['���о�׼����',num2str(highhit) ,'��'];
misstext =  ['©���з�',num2str(miss) ,'��'];
wrongtext =  ['�����ѷ�',num2str(wrong) ,'��'];
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
% Feedback
M=imread('feedback.jpg');
GIndex=Screen('MakeTexture',w,M);
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, hittext, 1105/960*center(1), 590/540*center(2), black, background);
Screen('DrawText', w, hightext, 1105/960*center(1), 695/540*center(2), black, background);
Screen('DrawText', w, misstext, 1105/960*center(1), 800/540*center(2), black, background);
Screen('DrawText', w, wrongtext, 1105/960*center(1), 905/540*center(2), black, background);
Screen('DrawText', w, actiontext, 1700/960*center(1), 1000/540*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
    
KbWait_HID;%�ȴ�ֱ������
end

% Exp End
    outp(address, MarkerExpEnd);
    WaitSecs(0.004);
    outp(address, 0); 
 %% Save data
fidnew.subid=subid;
fidnew.runnumber=runnumber;
fidnew.SampleRate=SampleRate;
fidnew.TimePoint=TimePoint;
fidnew.trial=trial;
fidnew.nSOA=nSOA;
fidnew.RTStart=RTStart;
fidnew.RTEnd=RTEnd;
fidnew.Duration=Duration;
fidnew.ACC=ACC;
fidnew.Theta=Theta;
fidnew.X=X;
fidnew.Y=Y;


fidnew.tSOA=tSOA;
fidnew.SOAIDs=SOAIDs;
fidnew.Blockhit=Blockhit;
fidnew.Blockhighhit=Blockhighhit;
fidnew.Blockmiss=Blockmiss;
fidnew.Blockwrong=Blockwrong;


fidnew.LO=LO;
fidnew.StiT=StiT;  
fidnew.StimIDs=StimIDs;  
fidnew.TFixOnset = TFixOnset;
fidnew.TTargetOnset=TTargetOnset;
fidnew.TRespOnset=TRespOnset;
fidnew.Secs =Secs;

fidnew.BlockRTStart=BlockRTStart;
fidnew.BlockRespRT=BlockRespRT;
fidnew.BlockDuration=BlockDuration;
fidnew.BlockACC=BlockACC;
fidnew.BlockTheta=BlockTheta;
fidnew.BlockX=BlockX;
fidnew.BlockY=BlockY;
% fidnew.BlockButton=BlockButton;
fidnew.BlockLO=BlockLO;
fidnew.BlockStiT=BlockStiT;
fidnew.BlockTFixOnset = BlockTFixOnset;
fidnew.BlockTTargetOnset=BlockTTargetOnset;
fidnew.BlockTRespOnset=BlockTRespOnset;
fidnew.BlockSecs =BlockSecs;
fidnew.BlocktSOA=BlocktSOA;
fidnew.BlockSOAIDs=BlockSOAIDs;

% ShowCursor
Screen('CloseAll');
save([dataPath,'\FlyStim6_','sub',num2str(subid),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

%% finish and receive .edf from Eyelink
% TriggerEyelinkNeuroscan(address,m_end,marker_time);
WaitSecs(0.1);
Eyelink('StopRecording');
% End of Experiment; close the file first
% close graphics window, close data file and shut down tracker
WaitSecs(0.5);
Eyelink('CloseFile');
% This supplies the title at the bottom of the eyetracker display??
sca;
Eyelink('ReceiveFile');
Eyelink('ShutDown');
ListenChar(0);