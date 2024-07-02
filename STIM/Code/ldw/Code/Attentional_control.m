 clear all;
commandwindow;
dataPath = 'D:\lidongwei\vWM_Precision\data\';
Screen('Preference', 'SkipSyncTests', 0);%The path of the data files
%stimulus mark
%% parameters
subject = input('Enter the subject number: ');                      %The subject's number
runnumber = input('Enter the run number: ');                        %The run number                                                        % 6block*80 trial*2days
subname = input('Enter the subject name: '); 
expdate = input('Enter the experiment date (e.g. 20190426): '); 
block = 4;
trial = 50*block; 
trial4block=30;
distance = 40;%                                                    %The distance between subject and monitor(cm)
monitorwidth = 47.3;                                                 %The width of the monitor(cm)
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
screenNumber = max(screens)+1;
[w, rect] = Screen('OpenWindow', screenNumber-1, 0,[],32,2);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐标
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   

%% data
RT=999*ones(block,trial/block);
ACC=999*ones(block,trial/block); 
ArrT=999*ones(block,trial/block);
StiT=999*ones(block,trial/block);
LineO=999*ones(block,trial/block);
TarLoca=999*ones(block,trial/block);
DisLoca=999*ones(block,trial/block);

%% line
linedeg = 1.2;                                                      %The visual angel of the line
lengthh = ceil(linedeg*ppd);

%% fixation+
fixrect=[];
fixrect=[fixrect;0,1/2*lengthh;0,-1/2*lengthh];
fixrect=[fixrect;-1/2*lengthh,0;1/2*lengthh,0];
firstfixtime=0.5;
fixationtime=1;
responsetime=2;
fixdeg = 0.1;                                                     %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 

%% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('e');

%% circle
circledeg = 5;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.25;                                                     %The visual of the side thick(deg)
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

%% target array
stimtime = 0.2;                                                       %The display time of the target array
stifromfix = 12;                                                   %The visual angle between the fixation and the stimulus
radius = stifromfix * ppd;                                          %The clock radius
anglestep = 36;                                                     %The angle between two closest stimulus
                                                   %To store the coordinates of all the cirles' boders
%% cue&target array
trialnum=0;blocknum=0;
for blockindex=1:block
    blocknum=blocknum+1;
    disp(blocknum);
Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime);  
for ntrial=1:(trial/block)
    trialnum=trialnum+1;
    arrowindex=norepeat(1,2,blockindex,ntrial,ArrT);
    Tlineindex=norepeat(1,2,blockindex,ntrial,LineO);
    tarcolor=[];stilocation=[];
    for i=1:1:10
        tarcolor(i,:,:,:)=red;
    end
    stilocation=ceil(90*randi([1,2],1,10));
while 1
    tarloca=norepeat(1,10,blockindex,ntrial,TarLoca);
    disloca=norepeat(1,10,blockindex,ntrial,DisLoca);
    if   tarloca~=disloca
        break
    end
end
    circlerect = []; 
    for clocknumber = 1:10
    relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every circle
    relcentery = radius * cos(anglestep*clocknumber*pi/180);
    bodercoordinate = [center(1)+relcenterx-diameter/2, center(2)-diameter/2-relcentery, center(1)+relcenterx+diameter/2, center(2)-relcentery+diameter/2];     %The boders' coordinates of all the circle
    circlerect = [circlerect;bodercoordinate];
    end
     circlerect = circlerect';
     switch arrowindex
         case 1
     tarcolor(disloca,:)=gre;
         case 2
     tarcolor(disloca,:)=red;
     end
     tarcolor(tarloca,:)=[];
     stilocation(tarloca)=Tlineindex*90;
     stimucolor=tarcolor';
    linerect = [];                                                    %To store the coordinates of all the cirles' boders
    for clocknumber = 1:10
        relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every circle
        relcentery = -radius * cos(anglestep*clocknumber*pi/180);
        endcoordinate = [relcenterx+lengthh/2*cos(stilocation(clocknumber)*pi/180), relcentery-lengthh/2*sin(stilocation(clocknumber)*pi/180);relcenterx-lengthh/2*cos(stilocation(clocknumber)*pi/180), relcentery+lengthh/2*sin(stilocation(clocknumber)*pi/180)];     %The boders' coordinates of all the circle
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
    if tarloca>=1&&tarloca<=4
            hemiindex=200;
    else if tarloca>=6&&tarloca<=9
            hemiindex=100;
        end
    end
    rectloca=circlerect(:,tarloca);
    circlerect(:,tarloca)=[];
    
    %ITI
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('Flip', w);
    WaitSecs(0.004);
    WaitSecs(fixationtime-0.5);
    
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('Flip', w);
    WaitSecs(0.5);
    
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('DrawLines', w, linerect, 6.9, gra, center, 1);   
    Screen('FrameOval', w, stimucolor, circlerect, framethick);                       %draw all the stimus
    Screen('FrameRect',w,red,rectloca, framethick);
    Screen('Flip', w);   
    WaitSecs(0.004);
    tic;
    WaitSecs(stimtime);
    %response
    blanktime=1.5;
    responindex=0.004;  
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('Flip', w); 
    WaitSecs(0.004);
    while toc < (blanktime+0.5)
        [touch, secs, keyCode] = KbCheck;
        if touch && (keyCode(rightkey) || keyCode(wrongkey))% || keyCode(Escapekey))
            RT(blockindex,ntrial) = toc;
            [touch, secs, keyCode] = KbCheck;
            responindex=0.5;
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
    WaitSecs(responindex);
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('Flip', w);
    WaitSecs(0.1); 
    LineO(blockindex,ntrial) = Tlineindex;
    ArrT(blockindex,ntrial) = arrowindex;
    TarLoca(blockindex,ntrial) = tarloca;
    DisLoca(blockindex,ntrial) = disloca;
end
blockacc=fix((size(find(ACC(blockindex,:)==1),2)/(trial/block))*100);
Screen('DrawText', w, ['ACC=',num2str(blockacc),'%'], center(1), center(2), gra, background);
Screen('Flip', w);
WaitSecs(4);
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
    WaitSecs(0.004);
KbWait;%等待直到按键
end
fidnew.sub=subject;
fidnew.runnum=runnumber;
fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.LO=LineO;
fidnew.ArrT=ArrT;
for blockindex=1:block
Condition1=find(fidnew.ArrT(blockindex,:)==1);
Condition2=find(fidnew.ArrT(blockindex,:)==2);
RT_loc1=find(fidnew.RT(blockindex,Condition1)~=999);
RT_loc2=find(fidnew.RT(blockindex,Condition2)~=999);
ACC_loc1=find(fidnew.ACC(blockindex,Condition1)==1);
ACC_loc2=find(fidnew.ACC(blockindex,Condition2)==1);
fidnew.ACC_rate1(blockindex)=length(ACC_loc1)/(length(Condition1));
fidnew.ACC_rate2(blockindex)=length(ACC_loc2)/(length(Condition2));
fidnew.RT_mean1(blockindex)=mean(fidnew.RT(blockindex,RT_loc1));
fidnew.RT_mean2(blockindex)=mean(fidnew.RT(blockindex,RT_loc2));
end
fidnew.cost_acc=mean(fidnew.ACC_rate1-fidnew.ACC_rate2);
fidnew.cost_rt=mean(fidnew.RT_mean1-fidnew.RT_mean2);
fprintf([' Cost-ACC is ',num2str(fidnew.cost_acc),'%/n']);
fprintf([' Cost-RT is ',num2str(fidnew.cost_rt),'%/n']);
save([dataPath,'sub',num2str(subject),'_',subname,'_',num2str(expdate),'_AttentionalControl.mat'],'fidnew');


ShowCursor
Screen('CloseAll');

