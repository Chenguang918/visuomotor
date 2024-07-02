clear all;
clc
close all

commandwindow;
dataPath = pwd;
Screen('Preference', 'SkipSyncTests', 1);%The path of the data files
% lptwrite(888, 0);%打marker

%% parameters
subjectname = input('Enter the subject name: ');                      %The subject's number
subject = input('Enter the subject number: ');                      %The subject's number
runnumber = input('Enter the run number: ');                        %The run number
stimtime = 0.1;  
PositionNum= 6; 
SampleRate = 6; %Hz
SOADuration= 5 ; %s
MinSOA= 0.5 ; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;

block=3;
trial = TimePoint*PositionNum*4 ;                                                         % 6block*80 trial*2days
distance = 57; %？                                                     %The distance between subject and monitor(cm)
monitorwidth = 65;                                                 %The width of the monitor(cm)
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
HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐标
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   
slack = Screen('GetFlipInterval',w)/2; %得到每一帧时间的一半

%% data
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
linedeg = 0.2;                                                       %The visual angel of the line
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

%% 生成target所在位置序列，在每个SOA点都重复出现4次
SOAID= 1:TimePoint;

StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDs =repmat(StimID,1,4); % 重复4次
StimIDs=StimIDs(:,randperm(trial)); % 打乱随机化


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

%% cue&target array
trialnum=0;blocknum=0;
for blockindex=1:block %:block
    blocknum=blocknum+1;
    disp(blocknum);
    RightResp=0;
    % Fix 初始化
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w);    %目标前的呈现注视点，记录第一个fix呈现时刻

for ntrial=1:trial/block
    trialnum=trialnum+1;
        %% First Fix
         %outp(888, MarkerFixation);
          WaitSecs(0.002);
         %outp(888, 0);
    stiindex=StimIDs(trialnum);
    ma=fix(stiindex/100);   % target index 百分位 fix取整 
    ms=mod(stiindex,100);   % SOA d1index 取余mod 
    Tlineindex=randi([1,2],1,1);% 伪随机 to decide the direction of the line in the target circle  1:hori  2:vert  
    BlockStiT(blockindex,ntrial)=ma;  % Target 所在的位置（1 2 3 4 5 6)中的一个
    StiT(trialnum)=ma;  % Target 所在的位置（1 2 3 4 5 6)中的一个
    tarcolor=[]; 
    stilocation=[];
    
    %初始所有clock的颜色
    for i=1:1:PositionNum   % 可以用生成网格meshgrid来代替循环
        tarcolor(i,:,:,:)=gre; % 10个clock初始都为绿色
    end

    stilocation=ceil(90*randi([1,2],1,10));  % 所有clock中line方向随机 
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
     stimucolor=tarcolor'; % 所有clock颜色都已经确定
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
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);      % 刺激出现的时刻点(以上个反应结束为起始点）
        
%     img=Screen('GetImage',w); % save the image
%     imwrite(img,'targetIndex.jpg');
    BlocktSOA(blockindex,ntrial)=nSOA(ms);
    tSOA(trialnum)=nSOA(ms);       %SOA的随机数列前面已经生成好了
    BlockSOAIDs(blockindex,ntrial)= ms;
    SOAIDs(trialnum)= ms;
    %     lptwrite(888, ma);
    WaitSecs(0.004);
%     lptwrite(888, 0);

    
    tic
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                      
    tRespOnset=Screen('Flip', w,tTargetOnset+stimtime-slack);                        %反应时的注视点
    BlockTRespOnset(blockindex,ntrial) =tRespOnset;

    %% response
    blanktime =2; %最长反应时间
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

     BlockSecs(blockindex,ntrial) =secs; %按键的时刻
    
    if keyCode(rightkey)
        BlockACC(blockindex,ntrial) = 1;
        RightResp=RightResp+1;

    elseif keyCode(wrongkey)
        BlockACC(blockindex,ntrial) = 0;
    elseif keyCode(EscapeKey)
%         break;
        Screen('CloseAll');
    end

     %     lptwrite(888, 99+BlockACC(ntrial));
%     WaitSecs(responindex);
%     lptwrite(888, 0);
    BlockLO(blockindex,ntrial) = Tlineindex;
    
    ALLACC=RightResp/ntrial;
    fprintf('\n ntrial=%d,ACC=%4.3f,RT= %3.3f',ntrial,ALLACC,BlockRT(blockindex,ntrial))

    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w, secs-slack);                    %绘制反应时候的Fix，并且确定以此反应时刻为下一个trial的初始时刻

  % 存成一行数据好操作  
RT(trialnum) = BlockRT(blockindex,ntrial);
ACC(trialnum)=BlockACC(blockindex,ntrial);   
LO(trialnum)=BlockLO(blockindex,ntrial);
TFixOnset(trialnum) =tFixOnset;
TTargetOnset(trialnum)= tTargetOnset;
TRespOnset(trialnum)=tRespOnset;
Secs(trialnum) =secs;
    
    
end
% 一个block结束
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
%     lptwrite(888, 116);
    WaitSecs(0.004);
%     lptwrite(888, 0);    
   WaitSecs(2);
   KbWait;%等待直到按键
end

fidnew.sub=subject;
fidnew.runnum=runnumber;
fidnew.BlockRT=BlockRT;
fidnew.RT=RT;
fidnew.BlockACC=BlockACC;
fidnew.ACC=ACC;
fidnew.BlockLO=BlockLO;
fidnew.LO=LO;
fidnew.BlockStiT=BlockStiT;
fidnew.StiT=StiT; % 记录target所在位置
fidnew.StimIDs=StimIDs; %记录包括target也包括SOA的刺激
fidnew.BlockTFixOnset = BlockTFixOnset;
fidnew.TFixOnset = TFixOnset;
fidnew.BlockTTargetOnset=BlockTTargetOnset;
fidnew.TTargetOnset=TTargetOnset;
fidnew.BlockTRespOnset=BlockTRespOnset;
fidnew.TRespOnset=TRespOnset;
fidnew.nSOA=nSOA;
fidnew.BlockSecs =BlockSecs;
fidnew.Secs =Secs;
fidnew.tSOA=tSOA;
fidnew.BlocktSOA=BlocktSOA;
fidnew.BlockSOAIDs=BlockSOAIDs;
fidnew.SOAIDs=SOAIDs;
fidnew.SampleRate=SampleRate;
fidnew.trial=trial;
fidnew.TimePiont=TimePoint;

save([dataPath,'\Stim6Samp6_','sub',num2str(subject),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

RightTrial=find(ACC==1);
for point=1:TimePoint
    pointtrial(point,:) = find(SOAIDs==point); % 找到对应point的trial
    RightPointtrial=intersect(pointtrial(point,:),RightTrial);
    PointRT(point,:)=RT(1,pointtrial(point,:));  % 对所有寻找到的trial的RT做平均
    RightmeanPointRT(point)=mean(RT(1,RightPointtrial));
    RightPointtrial=[];
end

meanPointRT = nanmean(PointRT,2);  %每个点所有trial做平均，去掉未反应的点
fidnew.PointRT=PointRT;   
fidnew.meanPointRT=meanPointRT; % 去除没做反应的PointRT
fidnew.RightmeanPointRT=RightmeanPointRT; % 只保持做对的meanPointRT


save([dataPath,'\Stim6Samp6_','sub',num2str(subject),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

savepath='C:\Users\15455\Documents\MATLAB\Code\NFB_Design\';

%画图直观展示每个被试结果
figure
plot(nSOA(1:TimePoint),RightmeanPointRT);
title('Mean RT in every timepiont')
xlabel('SOA')
ylabel('RT')
figname=['sub',num2str(subject),'_',subjectname,'_RT.fig'];

saveas(gcf,[savepath,figname]);


figure
L= TimePoint;
Fs=SampleRate;
Y= fft(RightmeanPointRT);


P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('FFT of RT in every timepiont')
xlabel('f (Hz)')
ylabel('Power')
figname=['sub',num2str(subject),'_',subjectname,'_FFT.fig'];

saveas(gcf,[savepath,figname]);


ShowCursor
Screen('CloseAll');

