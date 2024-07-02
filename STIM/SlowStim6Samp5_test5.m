% Include Control Condition; 4 blocks and Each has all SOA conditions;
% SampleRate=14Hz; Duration=3s;
% Include feedback
% Edit by 21/12/03
clear all;
clc
clear all

bSkipSyncTests =0; %是否禁用垂直同步测试，正式实验时切勿禁用（1=禁用；0=不禁用）
Screen('Preference','SkipSyncTests',bSkipSyncTests);
commandwindow;
dataPath = pwd;
% Screen('Preference', 'SkipSyncTests', 1);%The path of the data files
% config_io 
% % address = hex2dec('3EFC');
% address = hex2dec('0378');
% Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)
% 
% % Setting the path of the fNIRs files
% com1 = serial('com1','BaudRate',9600,'DataBits',8,'Parity','none','StopBits',1);
% try
%     fopen(com1)
% catch
%     fclose(instrfind)
%     fopen(com1)
% end

%% ------submessage-------
prompt={'被试编号(请询问主试)','姓名',' 学号','性别','出身年月','试次','双眼视力','精神状态[1很精神2精神3中立4有点困5很困','饥饿状态[1很饿 2有点饿 3正好 4有点撑]',...
    '其他需要说明的?如:昨晚喝酒'}; %
dlg_title='被试信息'; 
num_lines=1;
defaultanswer={'0','孙悟空','2020211111','男','199807','1','5.0','1','1','balabala'};
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
SOADuration= 3-0.2; %s 42个点
MinSOA= 1.8 ; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;



block=6;
trial = TimePoint*PositionNum*repeat ;                                                         % 6block*80 trial*2days
distance = 57; %？                                                     %The distance between subject and monitor(cm)
Estimated_time = ((MinSOA+MaxSOA)*0.5+1)*trial/60*4/3;
monitorwidth = 53;                                                 %The width of the monitor(cm)
background = [0,0,0];                                       %The background color                                                         %The trial number




red = [0.79,0.15,0.03]'*255;
gre = [0.07,0.91,0.15]'*255;
gra = [192,192,192]';
yel = [255,215,0]';
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
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐标
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   
slack = Screen('GetFlipInterval',w)/2; %得到每一帧时间的一半

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



%% 生成target所在位置序列，在每个SOA点都重复出现4次
SOAID= 1:TimePoint;

StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID7=700+SOAID; % target at position 6
StimIDs=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDRepeat1=StimIDs(:,randperm(length(StimIDs)));     % 一个重复
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
trigger(8,:) = sprintf('H \r\n');      % 反应正确
trigger(9,:) = sprintf('I \r\n');      % 反应错误
trigger(10,:) = sprintf('J \r\n');     % 静息开始吉结束
% Eyelink Triger9
EyelinkSetup
% Eyelink('StartRecording');
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


    
    
%% Introduction


sttext = '请闭眼休息两分钟';
% breaktext='Take a break and then press SPACE key to start';
breaktext='本组实验结束';
Restend='Rest End';
endtext = 'End of all';
font = 'Arial';
fontsize = 30;
Introduction(w,rect,fontsize,font,background,gra,center)

%% cue&target array
trialnum=0;blocknum=0;trial_main=0;trial_control=0;    score=0;
RestTime=10; %s
el.window=w;

    %outp(address, MarkerExpBegin);
    WaitSecs(0.004);
    %outp(address, 0); 
    commandwindow;
for blockindex=1:block %:block
     blocknum=blocknum+1;          
    disp(blocknum);
%% Rest begin

Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background);
Screen('DrawText', w, sttext, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
WaitSecs(3);
% fNIRS　
      %fwrite(com1,trigger(10,:));                                                    % ####
      WaitSecs(RestTime);                                                     % ####
      %fwrite(com1,trigger(10,:)); 
  Screen('TextSize', w ,fontsize);
  Screen('TextFont', w, font);
  Screen('FillRect', w, background);
  Screen('DrawText', w, Restend, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
WaitSecs(1);
KbWait;%等待直到按键 

    %% 眼动校正
    EyelinkDoDriftCorrection(el);
    Eyelink('Message', 'TRIALID %d', i);
    % Before recording, we place reference graphics on the host display
    % Must be in offline mode to transfer image to Host PC
     Eyelink('Command', 'set_idle_mode');
    Eyelink('StartRecording');
    
   % marker1
    %outp(address, MarkerBlockBegin);
    WaitSecs(0.004);
    %outp(address, 0); 
%     %% Fix 初始化
%     Screen('FillRect', w, background);
%     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
%     tFixOnset = Screen('Flip', w);    %目标前的呈现注视点，记录第一个fix呈现时刻
    
    control_SOA=SOAID(:,randperm(length(SOAID)));
    trial_control=0;

    RightResp=0;
    
    
    
    
    


for ntrial=1:trial/block+length(SOAID)

    if ntrial<=length(SOAID)
    mt=7; 
    trial_control=trial_control+1;
    ms=control_SOA(trial_control);
    control_index=1;
    markerindex=0;
    else
    trial_main=trial_main+1;
    stiindex=StimIDs(trial_main);
    mt=fix(stiindex/100);   % target index 百分位 fix取整 
    ms=mod(stiindex,100);   % SOA d1index 取余mod    
    control_index=0;
    markerindex=1;
    end
    trialnum=trialnum+1;

    Tlineindex=randi([1,2],1,1);% 伪随机 to decide the direction of the line in the target circle  1:hori  2:vert  
    BlockStiT(blockindex,ntrial)=mt;  % Target 所在的位置（1 2 3 4 5 6 7)中的一个
    StiT(trialnum)=mt;  % Target 所在的位置（1 2 3 4 5 6)中的一个
    tarcolor=[]; 
    stilocation=[];
    
    %初始所有clock的颜色
    for i=1:1:PositionNum   % 可以用生成网格meshgrid来代替循环
        tarcolor(i,:,:,:)=gre; % 10个clock初始都为绿色
    end

    stilocation=ceil(90*randi([1,2],1,10));  % 所有clock中line方向随机 
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
     stilocation(tarloca)=Tlineindex*90; % Target中line方向随机
     stimucolor=tarcolor'; % 所有clock颜色都已经确定
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
            
    % Fix SOA
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w);                    %绘制反应时候的Fix，并且确定以此反应时刻为下一个trial的初始时刻
   
    % marker
         MarkerSOA=control_SOA(ms);
         %fwrite(com1,trigger(mt,:));                                                    % ####
         WaitSecs(nSOA(MarkerSOA));                                                     % ####
         %fwrite(com1,trigger(mt,:));  
         
            
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      %draw the fixation
    Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
    Screen('FrameOval', w, tarcolor', circlerect, framethick);                      %draw all the stimus
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);                        % 刺激出现的时刻点(以上个反应结束为起始点）
   % marker3
      MarkerTarget=markerindex*(fix(mt/4)+1)*100+ms ;  
      %outp(address, MarkerTarget);  % target marker
      WaitSecs(0.002);
      %outp(address, 0);
     
    Eyelink('Message', num2str(MarkerTarget));
    
    BlocktSOA(blockindex,ntrial)=nSOA(ms);
    tSOA(trialnum)=nSOA(ms);       %SOA的随机数列前面已经生成好了
    BlockSOAIDs(blockindex,ntrial)= ms+100*control_index;
    SOAIDs(trialnum)= ms+100*control_index;

    
    tic
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      
    tRespOnset=Screen('Flip', w,tTargetOnset+stimtime-slack);                        %反应时的注视点
    BlockTRespOnset(blockindex,ntrial) =tRespOnset;
    
       % marker4
      MarkerTargetPo=80+mt ;  
      %outp(address, MarkerTargetPo);  % target marker
      WaitSecs(0.002);
      %outp(address, 0);
     
    Eyelink('Message', num2str(MarkerTargetPo));
    
%% response
    blanktime =2; %最长反应时间
    responindex=0.004;
    while toc <= blanktime % 有问题吧，还能记录RT>2s的trial？
        [touch, secs, keyCode] = KbCheck;
        BlockanyRT(blockindex,ntrial) = secs-tRespOnset+stimtime;  % record all the RT
        if touch && (keyCode(rightkey) || keyCode(wrongkey) || keyCode(EscapeKey))
            BlockRT(blockindex,ntrial) = secs-tRespOnset+stimtime; % RT>2s BlockRT=999;
            [touch, secs, keyCode] = KbCheck;

            break;
        end
    end
    
   

     BlockSecs(blockindex,ntrial) =secs; %按键的时刻
if    ntrial<=length(SOAID) & BlockRT(blockindex,ntrial)<=2
         BlockACC(blockindex,ntrial) = 1;
         RightResp=RightResp+1;
       if keyCode(EscapeKey)
%         break;
        Eyelink('StopRecording');
        Screen('CloseAll');
       end
         
elseif  ntrial<=length(SOAID) & BlockRT(blockindex,ntrial)>2 %包括没反应或反应大于2s的
         BlockACC(blockindex,ntrial) = 0;
         if ntrial>2 & BlockACC(blockindex,ntrial)==BlockACC(blockindex,ntrial-1)
               score=score+1;
         end
  
  
elseif ntrial>length(SOAID) & BlockRT(blockindex,ntrial)<=2
        if keyCode(rightkey)
             BlockACC(blockindex,ntrial) = 1;
             RightResp=RightResp+1;
             % marker4
             MarkerRight=250+BlockACC(blockindex,ntrial);
             %outp(address, MarkerRight);
             WaitSecs(responindex);
             %outp(address, 0);
             Eyelink('Message', num2str(MarkerRight));

      elseif keyCode(wrongkey)
              %marker5
              BlockACC(blockindex,ntrial) = 0;
              MarkerWrong=250+BlockACC(blockindex,ntrial);
              %outp(address, MarkerWrong);
              WaitSecs(responindex);
              %outp(address, 0);
              Eyelink('Message',num2str(MarkerWrong));
              if ntrial>2 & BlockACC(blockindex,ntrial)==BlockACC(blockindex,ntrial-1)
                  score=score+1;
              end
                  
       elseif keyCode(EscapeKey)
%         break;
        Eyelink('StopRecording');
        Screen('CloseAll');
       end
else  % noRespone,
     BlockACC(blockindex,ntrial) = 0;
         if ntrial>2 & BlockACC(blockindex,ntrial)==BlockACC(blockindex,ntrial-1)
               score=score+1;
         end
      % marker6
        %outp(address, MarkerNoResponse);
         WaitSecs(responindex);
        %outp(address, 0);
       Eyelink('Message', num2str(MarkerNoResponse));
            
end
%     lptwrite(888, 99+BlockACC(ntrial));
%     WaitSecs(responindex);
%     lptwrite(888, 0);
    BlockLO(blockindex,ntrial) = Tlineindex;

    ALLACC=RightResp/ntrial;
    fprintf('\n ntrial=%d,ACC=%4.3f,RT= %3.3f',ntrial,ALLACC,BlockanyRT(blockindex,ntrial))

%     Screen('FillRect', w, background);
%     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
%     
%     tFixOnset = Screen('Flip', w, secs-slack);                    %绘制反应时候的Fix，并且确定以此反应时刻为下一个trial的初始时刻
% 
%  if  ntrial < trial/block+length(SOAID)
%      
%       %fwrite(com1,trigger(mt,:));                                             % ####
%       WaitSecs(nSOA(ms));                                                     % ####
%       %fwrite(com1,trigger(mt,:));       
%       
% else
%     break
% end
%   
    
    
    
  % 存成一行数据好操作  
RT(trialnum) = BlockRT(blockindex,ntrial);
% Button(trialnum)=BlockButton(blockindex,ntrial);
RTany(trialnum) = BlockanyRT(blockindex,ntrial);
ACC(trialnum)=BlockACC(blockindex,ntrial);   
LO(trialnum)=BlockLO(blockindex,ntrial);
TFixOnset(trialnum) =tFixOnset;
TTargetOnset(trialnum)= tTargetOnset;
TRespOnset(trialnum)=tRespOnset;
Secs(trialnum) =secs;    

% STEP 7.8
        % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
        % Data Viewer. This is different than the end of recording message
        % END that is logged when the trial recording ends. The viewer will
        % not parse any messages, events, or samples that exist in the data
        % file after this message.
        Eyelink('Message', 'TRIAL_RESULT 0');
end
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
%   MarkerBlockEnd
%outp(address, MarkerBlockEnd);
    WaitSecs(0.004);
%outp(address, 0);  
WaitSecs(2);
% Prefromance Feedback 错一个扣5元，连续错两个扣1分，连续错三个扣2分
fine=length(find(BlockACC(blockindex,:)==0))*5;
Fine(blockindex,:)=fine;
Score(blockindex,:)=score;
Leftscore=12-score;
scoretext = [num2str(Leftscore) ,'分'];
finetext =  ['-',num2str(fine) ,'元'];
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);

% license
M=imread('license.jpg');
GIndex=Screen('MakeTexture',w,M);
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, subjectname, 23/16*center(1), 210/540*center(2), gra, background);
Screen('DrawText', w, finetext, 23/16*center(1), 315/540*center(2), gra, background);
Screen('DrawText', w, scoretext, 23/16*center(1), 420/540*center(2), gra, background);
Screen('Flip', w);
WaitSecs(2);
      
   KbWait;%等待直到按键
end

% Exp End
    %outp(address, MarkerExpEnd);
    WaitSecs(0.004);
    %outp(address, 0); 
 %% Save data
fidnew.subid=subid;
fidnew.runnumber=runnumber;
fidnew.SampleRate=SampleRate;
fidnew.TimePoint=TimePoint;
fidnew.trial=trial;
fidnew.nSOA=nSOA;
fidnew.RTany=RTany;
% fidnew.Button=Button;
fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.tSOA=tSOA;
fidnew.SOAIDs=SOAIDs;
fidnew.Score=Score;
fidnew.Fine=Fine;
fidnew.LO=LO;
fidnew.StiT=StiT;  
fidnew.StimIDs=StimIDs;  
fidnew.TFixOnset = TFixOnset;
fidnew.TTargetOnset=TTargetOnset;
fidnew.TRespOnset=TRespOnset;
fidnew.Secs =Secs;

fidnew.BlockRT=BlockRT;
fidnew.BlockanyRT=BlockanyRT;
fidnew.BlockACC=BlockACC;
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
save([dataPath,'\Stim6Samp5_','sub',num2str(subid),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

%% finish and receive .edf from eyelink
% TriggerEyelinkNeuroscan(address,m_end,marker_time);
WaitSecs(0.1);
Eyelink('StopRecording');
% End of Experiment; close the file first
% close graphics window, close data file and shut down tracker
Eyelink('Command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');


% This supplies the title at the bottom of the eyetracker display??
Eyelink('command', 'record_status_message "TRIAL %d/%d %s"', i,6, char(type(i)));
sca;

Eyelink('ReceiveFile');

Eyelink('ShutDown');
ListenChar(0);