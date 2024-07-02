% Free time NeuroFeedback Visual search 
% Coded by ZCG @ BNU 2020-10-29
% clear all;

    %% 运行前准备部分
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
        fclose(instrfind);
        fopen(com1);
    end        
    %% 参数设置部分
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
    
     % ------显示参数------
     bSkipSyncTests = 0; %是否禁用垂直同步测试，正式实验时切勿禁用
     screenNumber = max(Screen('Screens')); %
     distance = 57;         % distance between subject and monitor
     monitorwidth = 41;      % The width of the monitor
%% parameters

    Screen('Preference','SkipSyncTests',bSkipSyncTests);   
    [w, wRect] = PsychImaging('OpenWindow', screenNumber-1, [0,0,0], [], 32, 2,[], [],  kPsychNeed32BPCFloat);
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [center(1), center(2)] = WindowCenter(w);                          
    slack = Screen('GetFlipInterval',w)/2;
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360; 
    HideCursor;

trial = 400;                                                         

     % ------色彩参数------
     background = [0,0,0];                                       %The background color            
     red = [0.79,0.15,0.03]'*255;
     gre = [0.07,0.91,0.15]'*255;
     gra = [192,192,192]';
     yel = [255,215,0]';
     colorindex=[];
     colorindex(1,:,:,:)=yel;
     colorindex(2,:,:,:)=red;
     colorindex(3,:,:,:)=gre;

%% data
block=1;
RT=999*ones(block,trial/block+1);
ACC=999*ones(block,trial/block+1);
CueT=999*ones(block,trial/block+1); 
ArrT=999*ones(block,trial/block+1);
StiT=999*ones(block,trial/block+1);
LO=999*ones(block,trial/block+1);


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

%% line
linedeg = 1.2;                                                      %The visual angel of the line
length = ceil(linedeg*ppd);

%% fixation+
fixrect=[];
fixrect=[fixrect;0,1/2*length;0,-1/2*length];
fixrect=[fixrect;-1/2*length,0;1/2*length,0];
firstfixtime=0.5;
fixationtime=randi([1200,1600],1,1)/1000;
responsetime=1;
fixdeg = 0.1;                                                     %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 

%% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('e');

%% circle
circledeg = 3.4;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.2;                                                     %The visual of the side thick(deg)
framethick = ceil(framedeg * ppd);                                  %The thick of the side(pixel)

%% target array
stimtime = 0.1;                                                       %The display time of the target array
stifromfix = 9.2;                                                   %The visual angle between the fixation and the stimulus
radius = stifromfix * ppd;                                          %The clock radius
anglestep = 36;                                                     %The angle between two closest stimulus
circlerect = [];                                                    %To store the coordinates of all the cirles' boders
for clocknumber = 1:10
    relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every circle
    relcentery = radius * cos(anglestep*clocknumber*pi/180);
    bodercoordinate = [center(1)+relcenterx-diameter/2, center(2)-diameter/2-relcentery, center(1)+relcenterx+diameter/2, center(2)-relcentery+diameter/2];     %The boders' coordinates of all the circle
    circlerect = [circlerect;bodercoordinate];
end
circlerect = circlerect';

%% cue&target array
trialnum=0;blocknum=0;
for blockindex=1%:block
    blocknum=blocknum+1;
    disp(blocknum);

Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime);  

for ntrial=1:trial
    trialnum=trialnum+1;
    arrowindex=randi([1,2],1,1);%to decide the direction of colored arrow  1:left 2:right
    cueindex=randi([1,8],1,1);%to decide cue type; 3/8 type 1&3/8 type 2&2/8 type 1 
    cuenum=randcuenum(cueindex);
    if ntrial>=3
        while cuenum==CueT(blockindex,ntrial-1)&&CueT(blockindex,ntrial-1)==CueT(blockindex,ntrial-2)
            cueindex=randi([1,8],1,1);cuenum=randcuenum(cueindex);
        end   
    end
    CueT(blockindex,ntrial)=cuenum;

    Tlineindex=randi([1,2],1,1);%to decide the direction of the line in the target circle  1:hori  2:vert
    dislocindex=[7,8,9;6,8,9;6,7,9;6,7,8];
    ma=randstima_nocue(cuenum);
    if ntrial>=3
        while ma==StiT(blockindex,ntrial-1)&&StiT(blockindex,ntrial-1)==StiT(blockindex,ntrial-2)
            ma=randstima(cuenum);
        end
    end
    StiT(blockindex,ntrial)=ma;
    tarcolor=[];stilocation=[];
    for i=1:1:10
        tarcolor(i,:,:,:)=gre;
    end
    stilocation=ceil(90*randi([1,2],1,10));   
    % search type  Pd, N2pc, Nt
    switch ma        
        case 12%cue:yellow&green  dis middleline-Nt
            switch arrowindex
                case 1
                   tarloca=randi([6,9],1,1);
                   disloca=5*randi([1,2],1,1); 
                case 2
                   tarloca=randi([1,4],1,1);
                   disloca=5*randi([1,2],1,1); 
            end
        case 22%cue:red&green  tar midline  _Pd
            switch arrowindex
                case 1
                   disloca=randi([6,9],1,1);
                   tarloca=5*randi([1,2],1,1); 
                case 2
                   disloca=randi([1,4],1,1);
                   tarloca=5*randi([1,2],1,1); 
            end
        case 31
            switch arrowindex
                case 1
                    tarloca=randi([6,9],1,1);
                    disloca=randi([1,4],1,1);
                case 2
                    tarloca=randi([1,4],1,1);
                    disloca=randi([6,9],1,1);
            end
    end
     tarcolor(tarloca,:,:,:)=yel;
     tarcolor(disloca,:,:,:)=red;
     stilocation(tarloca)=Tlineindex*90;
     stimucolor=tarcolor';
    linerect = [];                                                    %To store the coordinates of all the cirles' boders
    for clocknumber = 1:10
        relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every circle
        relcentery = -radius * cos(anglestep*clocknumber*pi/180);
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

   
    
    %fixation random
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('Flip', w);
    WaitSecs(fixationtime);
    tic
    power=serial_receive(com1) 
    Total_time(ntrial)=toc;
    Total_Power(ntrial)=power;
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
    Screen('FrameOval', w, tarcolor', circlerect, framethick);                       %draw all the stimus
    Screen('Flip', w);   

    tic;
    WaitSecs(stimtime);
    
    %response
    blanktime=2;
    responindex=0.004;
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('Flip', w);   
    while toc < blanktime
        [touch, secs, keyCode] = KbCheck;
        if touch && (keyCode(rightkey) || keyCode(wrongkey))
            RT(blockindex,ntrial) = toc;
            [touch, secs, keyCode] = KbCheck;
            responindex=1;
            break;
        end
     end
     if keyCode(rightkey)
        ACC(blockindex,ntrial) = 1;
    elseif keyCode(wrongkey)
        ACC(blockindex,ntrial) = 0;
    elseif keyCode(EscapeKey)
        break;
        Screen('CloseAll');
     end

    LO(blockindex,ntrial) = Tlineindex;
    ArrT(blockindex,ntrial) = arrowindex;
end
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
  
KbWait;%等待直到按键
end

fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.CueT=CueT; 
fidnew.LO=LO;
fidnew.ArrT=ArrT;
fidnew.StiT=StiT;


ShowCursor
Screen('CloseAll');

