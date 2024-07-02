% clear all;
commandwindow;
dataPath = fileparts(which('datapath.m'));
Screen('Preference', 'SkipSyncTests', 1);%The path of the data files
% lptwrite(888, 0);%打marker

%% parameters
subject = input('Enter the subject number: ');                      %The subject's number
runnumber = input('Enter the run number: ');                        %The run number
trial = 40;                                                         % 6block*80 trial*2days
block=1;
distance = 57;%？                                                     %The distance between subject and monitor(cm)
monitorwidth = 41;                                                 %The width of the monitor(cm)
background = [0,0,0];                                       %The background color                                                         %The trial number
% red = [0.79,0.15,0.03]'*255;
% gre = [0.07,0.91,0.15]'*255;
% gra = [0.33,0.61,0.53]'*255;
% yel = [0.67,0.95,0.14]'*255;

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
% HideCursor;
[center(1), center(2)] = RectCenter(rect);                          %coordinates of the center得到中心的坐标
ppd = pi * rect(3)/atan(monitorwidth/distance/2)/360;   

%% data
RT=999*ones(block,trial/block+1);
ACC=999*ones(block,trial/block+1);
CueT=999*ones(block,trial/block+1); 
ArrT=999*ones(block,trial/block+1);
StiT=999*ones(block,trial/block+1);
LO=999*ones(block,trial/block+1);

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

%% cue
cuepos1=[center(1)-125,center(2);center(1)-100,center(2)-30;center(1)-100,center(2)-15;center(1)-50,center(2)-15;center(1)-50,center(2)+15;center(1)-100,center(2)+15;center(1)-100,center(2)+30 ];
cuepos2=[center(1)+125,center(2);center(1)+100,center(2)-30;center(1)+100,center(2)-15;center(1)+50,center(2)-15;center(1)+50,center(2)+15;center(1)+100,center(2)+15;center(1)+100,center(2)+30 ];
cuetime=0.2;
%% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('e');

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


%% target array
stimtime = 0.2;                                                       %The display time of the target array
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
    disp(blocknum); % 显示变量的值
%     lptwrite(888, 200+blockindex);
    %first fixation
Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime);  
for ntrial=1:trial
    trialnum=trialnum+1;
    arrowindex=randi([1,2],1,1);%to decide the direction of colored arrow  1:left 2:right
    cueindex=randi([1,8],1,1);  %to decide cue type; 3/8 type 1&3/8 type 2&2/8 type 1 
    cuenum=randcuenum(cueindex);
    if ntrial>=3
        while cuenum==CueT(blockindex,ntrial-1)&&CueT(blockindex,ntrial-1)==CueT(blockindex,ntrial-2)
            cueindex=randi([1,8],1,1);cuenum=randcuenum(cueindex);
        end   
    end
    CueT(blockindex,ntrial)=cuenum;
    switch cuenum
        case 1
        switch arrowindex
            case 1
                cue1color=colorindex(1,:,:,:);
                cue2color=colorindex(3,:,:,:);
            case 2
                cue1color=colorindex(3,:,:,:);
                cue2color=colorindex(1,:,:,:);
        end
        case 2
            switch arrowindex
            case 1
                cue1color=colorindex(2,:,:,:);
                cue2color=colorindex(3,:,:,:);
            case 2
                cue1color=colorindex(3,:,:,:);
                cue2color=colorindex(2,:,:,:);
            end
        case 3
        switch arrowindex
            case 1
                cue1color=colorindex(1,:,:,:);
                cue2color=colorindex(2,:,:,:);
            case 2
                cue1color=colorindex(2,:,:,:);
                cue2color=colorindex(1,:,:,:);
        end
    end
    Tlineindex=randi([1,2],1,1);%to decide the direction of the line in the target circle  1:hori  2:vert
    dislocindex=[7,8,9;6,8,9;6,7,9;6,7,8];
    ma=randstima(cuenum);
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
    switch ma
        case 11%cue:yellow&green   tar&dis con
            switch arrowindex
                case 1
                    tarloca=randi([6,9],1,1);
                    disloca=randi([1,4],1,1);
                case 2
                    tarloca=randi([1,4],1,1);
                    disloca=randi([6,9],1,1);
            end
        case 12%cue:yellow&green  dis middleline-Nt
            switch arrowindex
                case 1
                   tarloca=randi([6,9],1,1);
                   disloca=5*randi([1,2],1,1); 
                case 2
                   tarloca=randi([1,4],1,1);
                   disloca=5*randi([1,2],1,1); 
            end
        case 13%cue:yellow&green  tar&dis ips
            switch arrowindex
                case 1
                   tarloca=randi([6,9],1,1);
                   posindex=dislocindex(tarloca-5,:,:,:);
                   disloca=posindex(randi([1,3],1,1));
                case 2
                   tarloca=randi([1,4],1,1);
                   posindex=dislocindex(tarloca,:,:,:);  
                   disloca=posindex(randi([1,3],1,1))-5; 
            end
        case 21%cue:red&green  dis&tar con
            switch arrowindex
                case 1
                    disloca=randi([6,9],1,1);
                    tarloca=randi([1,4],1,1);
                case 2
                    disloca=randi([1,4],1,1);
                    tarloca=randi([6,9],1,1);
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
        case 23
            switch arrowindex
                case 1
                   disloca=randi([6,9],1,1);
                   posindex=dislocindex(disloca-5,:,:,:);
                   tarloca=posindex(randi([1,3],1,1));
                case 2
                   disloca=randi([1,4],1,1);
                   posindex=dislocindex(disloca,:,:,:);
                   tarloca=posindex(randi([1,3],1,1))-5; 
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
    
    
    %cue
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('FillPoly', w, cue1color,cuepos1,1); 
    Screen('FillPoly', w, cue2color,cuepos2,1); 
    Screen('Flip', w);
    WaitSecs(cuetime); 
    
    %fixation random
    Screen('FillRect', w, background);
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);
    Screen('Flip', w);
    WaitSecs(fixationtime);
    
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
    Screen('FrameOval', w, tarcolor', circlerect, framethick);                       %draw all the stimus
    Screen('Flip', w);   
%     lptwrite(888, ma);
    WaitSecs(0.004);
%     lptwrite(888, 0);
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
        if touch && (keyCode(rightkey) || keyCode(wrongkey) || keyCode(Escapekey))
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
     %     lptwrite(888, 99+ACC(ntrial));
    WaitSecs(responindex);
%     lptwrite(888, 0);
    LO(blockindex,ntrial) = Tlineindex;
    ArrT(blockindex,ntrial) = arrowindex;
end
Screen('DrawText', w, breaktext, 7*center(1)/10, center(2), gra, background);
Screen('Flip', w);
%     lptwrite(888, 116);
    WaitSecs(0.004);
%     lptwrite(888, 0);    
KbWait;%等待直到按键
end
% record = [RT, ACC,CueT,ConT,StiT,LO];
% record
fidnew.sub=subject;
fidnew.runnum=runnumber;
fidnew.RT=RT;
fidnew.ACC=ACC;
fidnew.CueT=CueT; 
fidnew.LO=LO;
fidnew.ArrT=ArrT;
fidnew.StiT=StiT;
save([dataPath,'\sub',num2str(subject),'_',num2str(runnumber),'.mat'],'fidnew');


ShowCursor
Screen('CloseAll');

