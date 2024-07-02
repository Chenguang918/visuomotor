clear all;
clc
clear all

commandwindow;
dataPath = pwd;
% 此处用于�?��或关闭垂直同步测�?
bSkipSyncTests =1; %是否禁用垂直同步测试，正式实验时切勿禁用�?=禁用�?=不禁用）
Screen('Preference','SkipSyncTests',bSkipSyncTests);

% lptwrite(address, 0); %打marker
Priority(1);  %提高代码的优 �?级，使得显示时间和反应时记录更精�?此处MacOS不同)
% config_io 
% address = hex2dec('3EFC');
%% parameters
subjectname = input('Enter the subject name: ');                      %The subject's number
sub = input('Enter the subject number: ');                      %The subject's number
runnumber = input('Enter the run number: ');                        %The run number
stimtime = 0.2;  
PositionNum= 6; 
SampleRate = 5; %Hz
SOADuration= 6.2 ; %s
MinSOA= 1; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;

block=6;
trial = TimePoint*PositionNum*4 ;                                                         % 6block*80 trial*2days
distance = 57; %�?                                                    %The distance between subject and monitor(cm)
monitorwidth = 57.5;                                                 %The width of the monitor(cm)
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
[w, rect] = Screen('OpenWindow', screenNumber-1, 0,[],32,2);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐�?
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   
slack = Screen('GetFlipInterval',w)/2; %得到每一帧时间的�?��

%% data 使用999作为初始值比 NaN 更好
Resp= 999*ones(block,trial/block);
BlockRT=999*ones(block,trial/block);
BlockACC=999*ones(block,trial/block);
BlockStiT=999*ones(block,trial/block);
BlockLO=999*ones(block,trial/block);
BlockTFixOnset =999*ones(block,trial/block);
BlockTTargetOnset=999*ones(block,trial/block);
BlockTRespOnset=999*ones(block,trial/block);
BlockSecs =999*ones(block,trial/block);

RT=999*ones(1,trial);
ACC=999*ones(1,trial);
StiT=999*ones(1,trial);
LO=999*ones(1,trial);
TFixOnset = 999*ones(1,trial);
TTargetOnset=999*ones(1,trial);
TRespOnset=999*ones(1,trial);
Secs =999*ones(1,trial);

SOAIDs=999*ones(1,trial);
tSOA=999*ones(1,trial);

%% line
linedeg = 1.2;                                                       %The visual angel of the line
length = ceil(linedeg*ppd);

%% fixation+
fixrect=[];
fixrect=[fixrect;0,1/2*length;0,-1/2*length];
fixrect=[fixrect;-1/2*length,0;1/2*length,0];
firstfixtime=0.5;
fixationtime=randi([1200,1600],1,1)/1000;
responsetime=2;
fixdeg = 0.1;                                                     %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 

%% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('9');

%% circle
circledeg = 3.4;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.2;                                                     %The visual of the side thick(deg)
framethick = ceil(framedeg * ppd);                                  %The thick of the side(pixel)
%% Marker
MarkerBlockBegin = 254;
MarkerBlockEnd = 255 ;
MarkerCorrectResponse = 251;
MarkerWrongResponse = 250;
MarkerNoResponse = 249;
% MarkerStim = 33;
% MarkerFixation = 77;


%% Introduction
sttext = 'Press SPACE key to start';
breaktext='Take a break and then press SPACE key to start';
endtext = 'End of all';
font = 'Arial';
fontsize = 30;
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background);
Screen('DrawText', w, sttext, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
KbWait;%等待直到按键

%% 生成target�?��位置序列，在每个SOA点都重复出现4�?
SOAID= 1:TimePoint;

StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDs =repmat(StimID,1,4); % 重复4�?
StimIDs=StimIDs(:,randperm(trial)); % 打乱随机�?
StimIDs(trial+1)=255; % 多出�?��trial直接结束


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


%┴┬┴┬／￣＼＿／￣�?
%┬┴┬┴�?   ▏▔▔▔▔＼
%┴┬┴／�? �?           �?
%┬┴�?             �?     �?
%┴┬�?               �?   �?
%┬┴�?                     ▔█
%┴◢██�?             ＼＿＿／
%┬█████�?             �?                                           MAIN PROGRAM IS COMMING !!!
%┴█████████████�?
%◢██████████████▆�?
%◢██████████████▆�?
%█◤◢██◣◥█████████◤＼
%◥◢████ ████████�?     �?
%┴█████  ██████�?          �?
%┬│      │█████�?               �?
%┴│      �?                           �?
%┬∕      �?       ／▔▔▔�?        �?
%*∕＿＿_／﹨      �?          �?   ／＼
%┬┴┬┴┬┴�?    ＼_        ﹨／        �?
%┴┬┴┬┴┬�?＼＿＿＿�?        ﹨／▔＼   ﹨／▔＼
%▲△▲▲╓╥╥╥╥╥╥╥╥＼      �?   ／▔�? ／▔�?

%% cue&target array
trialnum=0;blocknum=0;
for blockindex=1:block %:block
    blocknum=blocknum+1;
    disp(blocknum);
    RightResp=0;
    
outp(address, MarkerBlockBegin);
    WaitSecs(0.004);
outp(address, 0); 
      %% First Fix
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w);    %目标前的呈现注视点，记录第一个fix呈现时刻
%     mod(StimIDs(1),100)
         outp(address,  mod(StimIDs(1),100));
          WaitSecs(0.002);
         outp(address, 0);
for ntrial=1:trial/block
    trialnum=trialnum+1;

    stiindex=StimIDs(trialnum);
    ma=fix(stiindex/100);   % target index 百分�?fix取整 
    ms=mod(stiindex,100);   % SOA d1index 取余mod 
    Tlineindex=randi([1,2],1,1);% 伪随�?to decide the direction of the line in the target circle  1:hori  2:vert  
    BlockStiT(blockindex,ntrial)=ma;  % Target �?��的位置（1 2 3 4 5 6)中的�?��
    StiT(trialnum)=ma;  % Target �?��的位置（1 2 3 4 5 6)中的�?��
    tarcolor=[]; 
    stilocation=[];
    
    %初始�?��clock的颜�?
    for i=1:1:PositionNum   % 可以用生成网格meshgrid来代替循�?
        tarcolor(i,:,:,:)=gre; % 10个clock初始都为绿色
    end

    stilocation=ceil(90*randi([1,2],1,10));  % �?��clock中line方向随机 
    % search type  Pd, N2pc, Nt
    switch ma        
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
                
    end
    
     tarcolor(tarloca,:,:,:)=yel; % T
%      tarcolor(disloca,:,:,:)=red; % D
     stilocation(tarloca)=Tlineindex*90; % Target中line方向随机
     stimucolor=tarcolor'; % �?��clock颜色都已经确�?
     linerect = [];                                                    %To store the coordinates of all the cirles' boders
    


    for clocknumber = 1:PositionNum
        relcenterx = radius * sin(anglestep*clocknumber*pi/180-anglestep/2*pi/180);        %To calculate the coordinates of the center of every circle
        relcentery = -radius * cos(anglestep*clocknumber*pi/180-anglestep/2*pi/180);
        endcoordinate = [relcenterx+length/2*cos(stilocation(clocknumber)*pi/180), relcentery-length/2*sin(stilocation(clocknumber)*pi/180);relcenterx-length/2*cos(stilocation(clocknumber)*pi/180), relcentery+length/2*sin(stilocation(clocknumber)*pi/180)];     %The boders' coordinates of all the circle
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
 

   
    
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      %draw the fixation
    Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
    Screen('FrameOval', w, tarcolor', circlerect, framethick);                      %draw all the stimus
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);                    % 刺激出现的时刻点(以上个反应结束为起始点）
       MarkerTarget=ma*35+ms ;  
      outp(address, MarkerTarget); % target marker
          WaitSecs(0.002);
        outp(address, 0);
    
    BlocktSOA(blockindex,ntrial)=nSOA(ms);
    tSOA(trialnum)=nSOA(ms);       %SOA的随机数列前面已经生成好�?
    BlockSOAIDs(blockindex,ntrial)= ms;
    SOAIDs(trialnum)= ms;

    
    tic
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      
    tRespOnset=Screen('Flip', w,tTargetOnset+stimtime-slack);                        %反应时的注视�?
%          MarkerFixation
%        outp(address, MarkerFixation);
%           WaitSecs(0.002);
%           outp(address, 0);
    
    BlockTRespOnset(blockindex,ntrial) =tRespOnset;
    %% response
    blanktime =2; %�?��反应时间
    responindex=0.004;

   while toc <= blanktime
        [touch, secs, keyCode] = KbCheck;
        if touch && (keyCode(rightkey) || keyCode(wrongkey) || keyCode(EscapeKey))
            BlockRT(blockindex,ntrial) = toc;
            [touch, secs, keyCode] = KbCheck;
%             responindex=1;
            break;
        end
   end
   
   %     while toc <= blanktime
%         [touch, secs, keyCode] = KbCheck;
%         if touch && (keyCode(rightkey) || keyCode(wrongkey) || keyCode(EscapeKey))
%             BlockRT(blockindex,ntrial) = secs-tRespOnset+stimtime;
%             [touch, secs, keyCode] = KbCheck;
%             responindex=1;
%             break;
%         end
%     end

     BlockSecs(blockindex,ntrial) =secs; %按键的时�?
     



      if    BlockRT(blockindex,ntrial)<=2
            if keyCode(rightkey)
                BlockACC(blockindex,ntrial) = 1;
                RightResp=RightResp+1;
%                 99+BlockACC(blockindex,ntrial)
        outp(address, 250+BlockACC(blockindex,ntrial));
            WaitSecs(responindex);
        outp(address, 0);
            BlockLO(blockindex,ntrial) = Tlineindex;
            end
            if keyCode(wrongkey)

            BlockACC(blockindex,ntrial) = 0;
%              99+BlockACC(blockindex,ntrial)
       outp(address, 250+BlockACC(blockindex,ntrial));
              WaitSecs(responindex);
        outp(address, 0);
         BlockLO(blockindex,ntrial) = Tlineindex;
            end
            if keyCode(EscapeKey)
                break;
                Screen('CloseAll');
            end
            
      else 
%                 MarkerNoResponse
      outp(address, MarkerNoResponse);
              WaitSecs(responindex);
        outp(address, 0);
            end
    


    
    ALLACC=RightResp/ntrial;
    fprintf('\n ntrial=%d,ACC=%4.3f,RT= %3.3f',ntrial,ALLACC,BlockRT(blockindex,ntrial))

    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w, secs-slack);                    %绘制反应时�?的Fix，并且确定以此反应时刻为下一个trial的初始时�?
%      mod(StimIDs(trialnum+1),100)
outp(address, mod(StimIDs(trialnum+1),100));  
 WaitSecs(0.04);
outp(address, 0);

  % 存成�?��数据好操�?
RT(trialnum) = BlockRT(blockindex,ntrial);
ACC(trialnum)=BlockACC(blockindex,ntrial);   
LO(trialnum)=BlockLO(blockindex,ntrial);
TFixOnset(trialnum) =tFixOnset;
TTargetOnset(trialnum)= tTargetOnset;
TRespOnset(trialnum)=tRespOnset;
Secs(trialnum) =secs;
  end  






% RT = reshape(fidnew.BlockRT',1,768);
% ACC= reshape(fidnew.ACC',1,768); 
% LO= reshape(fidnew.LO',1,768);
% TFixOnset= reshape(fidnew.TFixOnset',1,768);
% TTargetOnset= reshape(fidnew.TTargetOnset',1,768);
% TRespOnset= reshape(fidnew.TRespOnset',1,768);
% Secs= reshape(fidnew.Secs',1,768);


% �?��block结束
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
%   MarkerBlockEnd
outp(address, MarkerBlockEnd);
    WaitSecs(0.004);
outp(address, 0);    
   WaitSecs(2);
   KbWait;%等待直到按键
end

fidnew.sub=sub;
fidnew.runnum=runnumber;
fidnew.SampleRate=SampleRate;
fidnew.TimePoint=TimePoint;
fidnew.trial=trial;
fidnew.nSOA=nSOA;
fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.tSOA=tSOA;
fidnew.SOAIDs=SOAIDs;
fidnew.LO=LO;
fidnew.StiT=StiT; % 记录target�?��位置
fidnew.StimIDs=StimIDs; %记录包括target也包括SOA的刺�?
fidnew.TFixOnset = TFixOnset;
fidnew.TTargetOnset=TTargetOnset;
fidnew.TRespOnset=TRespOnset;
fidnew.Secs =Secs;

fidnew.BlockRT=BlockRT;
fidnew.BlockACC=BlockACC;
fidnew.BlockLO=BlockLO;
fidnew.BlockStiT=BlockStiT;
fidnew.BlockTFixOnset = BlockTFixOnset;
fidnew.BlockTTargetOnset=BlockTTargetOnset;
fidnew.BlockTRespOnset=BlockTRespOnset;
fidnew.BlockSecs =BlockSecs;
fidnew.BlocktSOA=BlocktSOA;
fidnew.BlockSOAIDs=BlockSOAIDs;

save([dataPath,'\Stim6Samp5_','sub',num2str(sub),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

% Part1：只包含做正确的trial
RightTrial=find(ACC==1);
RspRT=find(RT~=999); 
NoResRT=find(RT==999); 
RT(1,NoResRT)=2;
for point=1:TimePoint
    PointTrial = find(SOAIDs==point);  % 找到每个SOA point的所有Trial
    RightPointTrial=intersect(PointTrial,RightTrial);
    RspPointRTTrial=intersect(PointTrial,RspRT);
    
    MeanRTRight(point)=mean(RT(1,RightPointTrial));  % �?��正确的trial
    MeanRTResp(point)=mean(RT(1,RspPointRTTrial));   % 除去没有反应�?
    MeanRTAll=mean(RT(1,PointTrial));                % 没有反应的RT替换�?s
    
    PointTrial=[];
    RspPointRTTrial=[];
    RightPointTrial=[];
end
% 存上面RT
fidnew.MeanRTRight=MeanRTRight; % 只保持做对的meanPointRT
fidnew.MeanRTResp=MeanRTResp;   % 除去没有反应�?
fidnew.MeanRTAll=MeanRTAll;     % 没有反应的RT替换�?s

% FFT分析(还有另一种方法可以用啊？�?
L= TimePoint;
Fs=SampleRate;
f = Fs*(0:(L/2))/L;
Y_1= fft(MeanRTRight);
P2_1 = abs(Y_1/L);
P1_1 = P2_1(1:L/2+1);
P1_1(2:end-1) = 2*P1_1(2:end-1);

Y_2= fft(MeanRTResp);
P2_2 = abs(Y_2/L);
P1_2 = P2_2(1:L/2+1);
P1_2(2:end-1) = 2*P1_2(2:end-1);

Y_3= fft(MeanRTAll);
P2_3 = abs(Y_3/L);
P1_3 = P2_3(1:L/2+1);
P1_3(2:end-1) = 2*P1_3(2:end-1);

% FFT分析(还有另一种方法可以用啊？�?


save([dataPath,'\Stim6Samp6_','sub',num2str(sub),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

savepath=['D:\songlab\Attention_Slow\'];

%画图直观展示每个被试结果
figure
subplot(3,2,1)
plot(nSOA(1:TimePoint),MeanRTRight);
title('Right RT in every timepiont')
xlabel('SOA')
ylabel('RT')

subplot(3,2,2)
plot(f,P1_1) 
title('FFT of Right RT ')
xlabel('f (Hz)')
ylabel('Power')

subplot(3,2,3)
plot(nSOA(1:TimePoint),MeanRTResp);
title('Resp RT in every timepiont')
xlabel('SOA')
ylabel('RT')

subplot(3,2,4)
plot(f,P1_2) 
title('FFT of Resp RT ')
xlabel('f (Hz)')
ylabel('Power')

subplot(3,2,5)
plot(nSOA(1:TimePoint),MeanRTAll);
title('All RT in every timepiont')
xlabel('SOA')
ylabel('RT')

subplot(3,2,6)
plot(f,P1_1) 
title('FFT of All RT ')
xlabel('f (Hz)')
ylabel('Power')

figname=['sub',num2str(sub),'_beh.fig'];
saveas(gcf,[savepath,figname]);


ShowCursor
Screen('CloseAll');

% %% drafts can be deleted
% fidnew.sub=fidnew1.sub;
% fidnew.runnum=fidnew1.runnum;
% fidnew.SampleRate=fidnew1.SampleRate;
% fidnew.TimePoint=fidnew1.TimePoint;
% fidnew.trial=fidnew1.trial;
% fidnew.nSOA=fidnew1.nSOA;
% fidnew.RT=reshape(fidnew1.BlockRT',1,768);
% fidnew.ACC=reshape(fidnew1.BlockACC',1,768);
% fidnew.tSOA=fidnew1.tSOA;
% fidnew.SOAIDs=fidnew1.SOAIDs;
% fidnew.StiT=fidnew1.StiT; % 记录target�?��位置
% fidnew.StimIDs=fidnew1.StimIDs; %记录包括target也包括SOA的刺�?
% fidnew.LO=reshape(fidnew1.BlockLO',1,768);
% fidnew.TFixOnset =reshape(fidnew1.BlockTFixOnset',1,768);
% fidnew.TTargetOnset=reshape(fidnew1.BlockTTargetOnset',1,768);
% fidnew.TRespOnset=reshape(fidnew1.BlockTRespOnset',1,768);
% fidnew.Secs =reshape(fidnew1.BlockSecs',1,768);
% 
% fidnew.BlockRT=fidnew1.BlockRT;
% fidnew.BlockACC=fidnew1.BlockACC;
% fidnew.BlockLO=fidnew1.BlockLO;
% fidnew.BlockStiT=fidnew1.BlockStiT;
% fidnew.BlockTFixOnset = fidnew1.BlockTFixOnset;
% fidnew.BlockTTargetOnset=fidnew1.BlockTTargetOnset;
% fidnew.BlockTRespOnset=fidnew1.BlockTRespOnset;
% fidnew.BlockSecs =fidnew1.BlockSecs;
% fidnew.BlocktSOA=fidnew1.BlocktSOA;
% fidnew.BlockSOAIDs=fidnew1.BlockSOAIDs;
% 
% save([['D:\songlab\Attention_Slow'],'\Stim6Samp6_','sub',num2str(3),'_',num2str(1),'.mat'],'fidnew');
% %% Drafts
% % Part1：只包含做正确的trial
% RightTrial=find(fidnew.ACC==1);
% RspRT=find(fidnew.RT~=999); 
% NoResRT=find(fidnew.RT==999); 
% RT=fidnew.RT;
% RT(1,NoResRT)=2;
% for point=1:32
%     PointTrial = find(fidnew.SOAIDs==point);  % 找到每个SOA point的所有Trial
%     RightPointTrial=intersect(PointTrial,RightTrial);
%     RspPointRTTrial=intersect(PointTrial,RspRT);
%     
%     MeanRTRight(point)=mean(RT(1,RightPointTrial));  % �?��正确的trial
%     MeanRTResp(point)=mean(RT(1,RspPointRTTrial));   % 除去没有反应�?
%     MeanRTAll(point)=mean(RT(1,PointTrial));                % 没有反应的RT替换�?s
%     
%     PointTrial=[];
%     RspPointRTTrial=[];
%     RightPointTrial=[];
% end
% % 存上面RT
% fidnew.MeanRTRight=MeanRTRight; % 只保持做对的meanPointRT
% fidnew.MeanRTResp=MeanRTResp;   % 除去没有反应�?
% fidnew.MeanRTAll=MeanRTAll;     % 没有反应的RT替换�?s
% 
% % FFT分析(还有另一种方法可以用啊？�?
% L= fidnew.TimePoint;
% Fs=fidnew.SampleRate;
% f = Fs*(0:(L/2))/L;
% Y_1= fft(MeanRTRight);
% P2_1 = abs(Y_1/L);
% P1_1 = P2_1(1:L/2+1);
% P1_1(2:end-1) = 2*P1_1(2:end-1);
% 
% Y_2= fft(MeanRTResp);
% P2_2 = abs(Y_2/L);
% P1_2 = P2_2(1:L/2+1);
% P1_2(2:end-1) = 2*P1_2(2:end-1);
% 
% Y_3= fft(MeanRTAll);
% P2_3 = abs(Y_3/L);
% P1_3 = P2_3(1:L/2+1);
% P1_3(2:end-1) = 2*P1_3(2:end-1);
% 
% % FFT分析(还有另一种方法可以用啊？�?
% 
% datapath=['D:\songlab\Attention_Slow'];
% % save([dataPath,'\Stim6Samp6_','sub',num2str(sub),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');
% 
% savepath=['D:\songlab\Attention_Slow\'];
% 
% %画图直观展示每个被试结果
% TimePoint=32;
% nSOA=fidnew.nSOA;
% figure
% subplot(3,2,1)
% plot(nSOA(1:TimePoint),MeanRTRight);
% title('Right RT in every timepiont')
% xlabel('SOA')
% ylabel('RT')
% 
% subplot(3,2,2)
% plot(f,P1_1) 
% title('FFT of Right RT ')
% xlabel('f (Hz)')
% ylabel('Power')
% 
% subplot(3,2,3)
% plot(nSOA(1:TimePoint),MeanRTResp);
% title('Rsp RT in every timepiont')
% xlabel('SOA')
% ylabel('RT')
% 
% subplot(3,2,4)
% plot(f,P1_2) 
% title('FFT of Resp RT ')
% xlabel('f (Hz)')
% ylabel('Power')
% 
% subplot(3,2,5)
% plot(nSOA(1:TimePoint),MeanRTAll);
% title('All RT in every timepiont')
% xlabel('SOA')
% ylabel('RT')
% 
% subplot(3,2,6)
% plot(f,P1_3) 
% title('FFT of All RT ')
% xlabel('f (Hz)')
% ylabel('Power')
% 
% figname=['sub3_beh.fig'];
% saveas(gcf,[savepath,figname]);
% 
