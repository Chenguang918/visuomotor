clear
clc
close all
%% Hardware Connection Configration
% 此处用于开启或关闭垂直同步测试
bSkipSyncTests =0; %是否禁用垂直同步测试，正式实验时切勿禁用（1=禁用；0=不禁用）
Screen('Preference','SkipSyncTests',bSkipSyncTests);

config_io 
% address = hex2dec('3EFC');
address = hex2dec('0378');
Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)


% Setting the path of the fNIRs files
com1 = serial('com1','BaudRate',9600,'DataBits',8,'Parity','none','StopBits',1);
try
    fopen(com1)
catch
    fclose(instrfind)
    fopen(com1)
end
%% ------submessage-------
prompt={'被试编号(请询问主试)','姓名','学号','性别','出身年月','试次','双眼视力','精神状态[1很精神2精神3中立4有点困5很困','饥饿状态[1很饿 2有点饿 3正好 4有点撑]',...
    '其他需要说明的?如:昨晚喝酒'}; %
dlg_title='被试信息';
num_lines=1;
defaultanswer={'0','孙悟空','2020211111','男','199807','1','5.0','1','1','balabala'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
subid = str2double(subinfo{1,1});
runnumber = str2double(subinfo{6,1});
subjectname=subinfo{2,1};
dataPath=['E:\Attention_Slow\'];

%% Definite File-Saved Path
subid_name_file=strcat('sub',subinfo{1,1},'_',subinfo{6,1});
filepath=strcat(pwd,'\Beh_data\','sub',subinfo{1,1},'_',subinfo{6,1},'\');
edffilename = strcat('sub',subinfo{1,1},'_',subinfo{6,1});
if ~exist(filepath,'dir')
    mkdir(filepath);
end



%% Experiment related Parameters Setup
stimtime = 0.2;  
PositionNum= 6; 
SampleRate = 5; %Hz
SOADuration= 6.2 ; %s
MinSOA= 1; %s
MaxSOA= MinSOA+SOADuration;
TimePoint= SampleRate*SOADuration+1; 
nSOA = MinSOA+(0:TimePoint-1)*1/SampleRate;
block=6;
trial = TimePoint*PositionNum*4 ;                                           
% ppd
distance = 57; %锛?                                                        %The distance between subject and monitor(cm)
monitorwidth = 57.5;                                                       %The width of the monitor(cm)
screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SkipSyncTests', 1);
[w, rect] = Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
winWidth = rect(3);
winHeight = rect(4);
HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center寰楀埌涓績鐨勫潗鏍?
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;  
slack = Screen('GetFlipInterval',w)/2;   %得到每一帧时间的一半

% color
background = [0,0,0];                                                      %The background color 
red = [0.79,0.15,0.03]'*255;
gre = [0.07,0.91,0.15]'*255;
gra = [192,192,192]';
yel = [255,215,0]';                                                        %Target color
colorindex(1,:,:,:)=yel;
colorindex(2,:,:,:)=red;
colorindex(3,:,:,:)=gre;
% line
linedeg = 1.2;                                                       %The visual angel of the line
length = ceil(linedeg*ppd);
% fixation+
fixrect=[];
fixrect=[fixrect;0,1/2*length;0,-1/2*length];
fixrect=[fixrect;-1/2*length,0;1/2*length,0];
firstfixtime=0.5;
fixationtime=randi([1200,1600],1,1)/1000;
responsetime=2;
fixdeg = 0.1;                                                     %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 
% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('9');
% circle
circledeg = 3.4;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.2;                                                     %The visual of the side thick(deg)
framethick = ceil(framedeg * ppd);                                  %The thick of the side(pixel)

%% Triger
% EEG Triger
MarkerBlockBegin = 254;
MarkerBlockEnd = 255 ;
MarkerCorrectResponse = 251;
MarkerWrongResponse = 250;
MarkerNoResponse = 249;
% fNIRS Triger
trigger1 = sprintf('A \r\n');                %SOA begin
trigger2 = sprintf('B \r\n'); 
trigger3 = sprintf('C \r\n'); 
trigger4 = sprintf('D \r\n'); 
trigger5 = sprintf('E \r\n'); 
trigger6 = sprintf('F \r\n'); 
trigger7 = sprintf('G \r\n'); 
trigger8 = sprintf('H \r\n'); 
trigger9 = sprintf('I \r\n'); 
trigger10 = sprintf('J \r\n'); 
% Eyelink Triger
EyelinkSetup

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


%% Produce the loaction of target on the timeline
SOAID= 1:TimePoint;

StimID1=100+SOAID; % target at position 1
StimID2=200+SOAID; % target at position 2
StimID3=300+SOAID; % target at position 3
StimID4=400+SOAID; % target at position 4
StimID5=500+SOAID; % target at position 5
StimID6=600+SOAID; % target at position 6
StimID=[StimID1,StimID2,StimID3,StimID4,StimID5,StimID6];

StimIDs =repmat(StimID,1,4); % repeat 4 times
StimIDs=StimIDs(:,randperm(trial)); % random
StimIDs(trial+1)=255; % add end trigger


%% Produce the loaction of target on the display                                                   
%The display time of the target array
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

%% Initial Beh_data
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
KbWait;%

%% Block Loop
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
    tFixOnset = Screen('Flip', w);   %目标前的呈现注视点，记录第一个fix呈现时刻
%     mod(StimIDs(1),100)
         MarkerSOA=mod(StimIDs(1),100);
         outp(address,  MarkerSOA);
         WaitSecs(0.002);
         outp(address, 0);
         
         fwrite(com1,trigger1);                                                    % ####
         WaitSecs(nSOA(MarkerSOA));                                                     % ####
         fwrite(com1,trigger1);  
         
         Eyelink('Message', num2str(MarkerSOA));
%% Trial Loop
for ntrial=1:trial/block
    trialnum=trialnum+1;

    stiindex=StimIDs(trialnum);
    ma=fix(stiindex/100);   % target index 百分位 fix取整 
    ms=mod(stiindex,100);    % SOA d1index 取余mod 
    Tlineindex=randi([1,2],1,1);% 伪随机 to decide the direction of the line in the target circle  1:hori  2:vert  
    BlockStiT(blockindex,ntrial)=ma; % Target 所在的位置（1 2 3 4 5 6)中的一个
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
     stimucolor=tarcolor';% 所有clock颜色都已经确定
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
    tTargetOnset=Screen('Flip', w,tFixOnset+nSOA(ms)-slack);                   % 刺激出现的时刻点(以上个反应结束为起始点）
       MarkerTarget=ma*35+ms ;  
      outp(address, MarkerTarget);  % target marker
       WaitSecs(0.002);
       outp(address, 0);
        
       Eyelink('Message', num2str(MarkerTarget));

       
    BlocktSOA(blockindex,ntrial)=nSOA(ms);
    tSOA(trialnum)=nSOA(ms);      %SOA的随机数列前面已经生成好了
    BlockSOAIDs(blockindex,ntrial)= ms;
    SOAIDs(trialnum)= ms;

    
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

     BlockSecs(blockindex,ntrial) =secs;  %按键的时刻
      if    BlockRT(blockindex,ntrial)<=2
            if keyCode(rightkey)
                BlockACC(blockindex,ntrial) = 1;
                RightResp=RightResp+1;
%                 99+BlockACC(blockindex,ntrial)
         MarkerRight=250+BlockACC(blockindex,ntrial);
            outp(address, MarkerRight);
            WaitSecs(responindex);
            outp(address, 0);
            Eyelink('Message', num2str(MarkerRight));

            BlockLO(blockindex,ntrial) = Tlineindex;
            end
            if keyCode(wrongkey)

            BlockACC(blockindex,ntrial) = 0;
%              99+BlockACC(blockindex,ntrial)
          MarkerWrong=250+BlockACC(blockindex,ntrial);
             outp(address, MarkerWrong);
              WaitSecs(responindex);
              outp(address, 0);
              Eyelink('Message',num2str(MarkerWrong));
 
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
            Eyelink('Message', num2str(MarkerNoResponse));

            end
    


    
    ALLACC=RightResp/ntrial;
    fprintf('\n ntrial=%d,ACC=%4.3f,RT= %3.3f',ntrial,ALLACC,BlockRT(blockindex,ntrial))

    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
    tFixOnset = Screen('Flip', w, secs-slack);                   %绘制反应时候的Fix，并且确定以此反应时刻为下一个trial的初始时刻
%      mod(StimIDs(trialnum+1),100)
      

if trialnum<= trial
    MarkerSOA=mod(StimIDs(trialnum+1),100);
    outp(address,MarkerSOA);  
    WaitSecs(0.04);
    outp(address, 0);
              fwrite(com1,trigger1);                                                    % ####
              WaitSecs(nSOA(mod(StimIDs(trialnum+1),100)));                                                     % ####
              fwrite(com1,trigger1);  
              Eyelink('Message', num2str(MarkerSOA));

else 
    break
end

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
%   MarkerBlockEnd
outp(address, MarkerBlockEnd);
    WaitSecs(0.004);
outp(address, 0);    
   WaitSecs(2);
   KbWait;%等待直到按键
end

%% finish and receive .edf from eyelink
% TriggerEyelinkNeuroscan(address,m_end,marker_time);
WaitSecs(0.1);
Eyelink('StopRecording');
Eyelink('Command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');

DrawFormattedText(w,'Finish!Thank you!','center','center',255);
Screen('Flip',w);
WaitSecs(0.5);
RestrictKeysForKbCheck([]);
KbWait;
sca;

Eyelink('ReceiveFile');

Eyelink('ShutDown');
ListenChar(0);


%% Save data
fidnew.subid=subid;
fidnew.runnumber=runnumber;
fidnew.SampleRate=SampleRate;
fidnew.TimePoint=TimePoint;
fidnew.trial=trial;
fidnew.nSOA=nSOA;
fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.tSOA=tSOA;
fidnew.SOAIDs=SOAIDs;
fidnew.LO=LO;
fidnew.StiT=StiT; % 璁板綍target鎵?湪浣嶇疆
fidnew.StimIDs=StimIDs; %璁板綍鍖呮嫭target涔熷寘鎷琒OA鐨勫埡婵?
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

save([dataPath,'\Stim6Samp5_','sub',num2str(subid),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

%% Draw the Behavior data
% Part1 Draw the RT 
RightTrial=find(ACC==1);
RspRT=find(RT~=999); 
NoResRT=find(RT==999); 
RT(1,NoResRT)=2;
for point=1:TimePoint
    PointTrial = find(SOAIDs==point);     % find all the trialnum of the point of SOA
    RightPointTrial=intersect(PointTrial,RightTrial);
    RspPointRTTrial=intersect(PointTrial,RspRT);
    
    MeanRTRight(point)=mean(RT(1,RightPointTrial));  % only the right trial
    MeanRTResp(point)=mean(RT(1,RspPointRTTrial));   % only the responded trial
    MeanRTAll=mean(RT(1,PointTrial));                % all the trial(let the RT of on Responded trial equal to 2s)
    
    PointTrial=[];
    RspPointRTTrial=[];
    RightPointTrial=[];
end
% save th mean RT data
fidnew.MeanRTRight=MeanRTRight; % only the right trial
fidnew.MeanRTResp=MeanRTResp;   % only the responded trial
fidnew.MeanRTAll=MeanRTAll;     % all the trial

% Part2: FFT of the RT data
L= TimePoint;
Fs=SampleRate;
f = Fs*(0:(L/2))/L;
Y_1= fft(MeanRTRight); % only the right trial
P2_1 = abs(Y_1/L);
P1_1 = P2_1(1:L/2+1);
P1_1(2:end-1) = 2*P1_1(2:end-1);

Y_2= fft(MeanRTResp);  % only the responded trial
P2_2 = abs(Y_2/L);
P1_2 = P2_2(1:L/2+1);
P1_2(2:end-1) = 2*P1_2(2:end-1);

Y_3= fft(MeanRTAll);
P2_3 = abs(Y_3/L);  % all the trial
P1_3 = P2_3(1:L/2+1);
P1_3(2:end-1) = 2*P1_3(2:end-1);

% save the mean RT Data
save([dataPath,'\Stim6Samp5_','sub',num2str(subid),'_',num2str(runnumber),'_',subjectname,'_org.mat'],'fidnew');

savepath=['E:\Attention_Slow\Figure\'];

%Draw the data
figure
subplot(3,2,1)
plot(nSOA(1:TimePoint),MeanRTRight);
title([edffilename,' Right RT in every timepiont'])
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

figname=[edffilename,'_beh.fig'];
saveas(gcf,[savepath,figname]);


ShowCursor
Screen('CloseAll');
