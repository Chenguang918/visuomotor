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
%     config_io
%     outp(888, 0);    
%     com1=serial('com1');
%     set(com1,'BaudRate',9600,'StopBits',1,'Parity','none','DataBits',8,'InputBufferSize',255);
%     try 
%         fopen(com1);
%     catch
%         fclose(instrfind);
%         fopen(com1);
%     end        
    %% 参数设置部分
    % ------submessage-------
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Order','run'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','Lee','1','19940501','right','1'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    commandwindow;
    dataPath='E:\Zhaochenguang\NFB\';
    dataPath='C:\Users\15455\Documents\MyWork\NF\Data\';
    %%
    subid_name_file=strcat('sub',subinfo{1},subinfo{2});
    filepath=strcat(dataPath,'\experimentdata\subexpdata\','sub',subinfo{1},subinfo{6},'\');
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
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, [0,0,0], [], 32, 2,[], [],  kPsychNeed32BPCFloat);
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [center(1), center(2)] = WindowCenter(w);                          
    slack = Screen('GetFlipInterval',w)/2;
    ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;  % 根据距屏幕远近，屏幕大小配适刺激大小
    % HideCursor;

                                                    
protocol_order=str2num(subinfo{6});
switch protocol_order
    case 1 % positive first
      protocol=[2 1];  
    case 2 % negative first
      protocol=[1 2]; 
end
    
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
trial=250; % 对于不同刺激类型占比不同
block=2;
RT=999*ones(block,trial);
ACC=999*ones(block,trial);
CueT=999*ones(block,trial); 
ArrT=999*ones(block,trial);
StiT=999*ones(block,trial); % 刺激类型 type1-4
LO=999*ones(block,trial);


%% Introduction
sttext = 'Press SPACE key to start';
breaktext='Take a break and then press SPACE key to start';
endtext = 'End of all';
font = 'Arial';
fontsize = 30;
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background);
Screen('DrawText', w , sttext, 2*center(1)/3, center(2), gra);
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
fixationtime=randi([1200,1600],1,1)/1000; %随机化窗口
responsetime=1;
fixdeg = 0.1;                                                      %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 

%% key
horikey = KbName('1');
vertkey = KbName('2');
EscapeKey = KbName('e'); % 中断程序的键？

%% circle
circledeg = 3.4;                                                    %The visual angle of the circle(deg)
diameter = ceil(circledeg*ppd);                                     %The diameter of the circle(pixel)
framedeg = 0.2;                                                     %The visual of the side thick(deg)
framethick = ceil(framedeg * ppd);                                  %The thick of the side(pixel)

%% target array （stimtime=0.2s）
stimtime = 0.2;                                                      %The display time of the target array
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
circlerect = circlerect'; % 转置
%% Condition List

list=randperm(trial); % 随机化刺激

% 不同刺激条件分配不同比例
% Nt
condition_index(list(1:50))=11;    % 50 T上
condition_index(list(51:100))=21;  % 50 T
% Pd
condition_index(list(101:150))=12; % 50 D上
condition_index(list(151:200))=22; % 50
% Opposite 
condition_index(list(201:212))=13; % 12 T左D右
condition_index(list(213:225))=23; % 13 T右D左
% Samesite
condition_index(list(226:235))=14; % 10 同左
condition_index(list(236:250))=24; % 15 同右
%% cue&target array
dislocindex=[7,8,9;6,8,9;6,7,9;6,7,8]; % 干嘛用？
for blockindex=1:block

Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime);  

for ntrial=1:trial
    stiindex=condition_index(ntrial);
    arrowindex=fix(stiindex/10);   %to decide the direction of colored arrow  1:left 2:right
    ma=mod(stiindex,10);   % 取余 to decide cue type ？; 3/8 type 1 & 3/8 type 2 & 2/8 type 1 
    CueT(blockindex,ntrial)=stiindex;

    Tlineindex=randi([1,2],1,1);% 伪随机 to decide the direction of the line in the target circle  1:hori  2:vert
    
    StiT(blockindex,ntrial)=ma;
    tarcolor=[]; stilocation=[];
    
    %初始所有clock的颜色
    for i=1:1:10   % 可以用生成网格meshgrid来代替循环
        tarcolor(i,:,:,:)=gre; % 10个clock初始都为绿色
    end

    stilocation=ceil(90*randi([1,2],1,10));  % 所有clock中line方向随机 
    % search type  Pd, N2pc, Nt
    switch ma        
        case 1 % cue:yellow & green  dis middleline-Nt
            switch arrowindex
                case 1 % T:left D:up or down
                   tarloca=randi([6,9],1,1);
                   disloca=5*randi([1,2],1,1); 
                case 2 % T:right D:up or down
                   tarloca=randi([1,4],1,1);
                   disloca=5*randi([1,2],1,1); 
            end
        case 2 % cue:red&green  tar midline  _Pd
            switch arrowindex
                case 1 % D:left D:up or down
                   disloca=randi([6,9],1,1);
                   tarloca=5*randi([1,2],1,1); 
                case 2 % D:right D:up or down
                   disloca=randi([1,4],1,1);
                   tarloca=5*randi([1,2],1,1); 
            end
        case 3
            switch arrowindex
                case 1 % T:left D:right
                    tarloca=randi([6,9],1,1);
                    disloca=randi([1,4],1,1);
                case 2 % T:right D:left
                    tarloca=randi([1,4],1,1);
                    disloca=randi([6,9],1,1);
            end
        case 4  % opposite
            switch arrowindex
                case 1 % T:left D:left
                   tarloca=randi([6,9],1,1);
                   posindex=dislocindex(tarloca-5,:,:,:);
                   disloca=posindex(randi([1,3],1,1));
                case 2 % T:right D:right
                   tarloca=randi([1,4],1,1);
                   posindex=dislocindex(tarloca,:,:,:);  
                   disloca=posindex(randi([1,3],1,1))-5; 
            end
    end
     tarcolor(tarloca,:,:,:)=yel; % T
     tarcolor(disloca,:,:,:)=red; % D
     stilocation(tarloca)=Tlineindex*90; % Target中line方向随机
     stimucolor=tarcolor'; % 所有clock颜色都已经确定
     linerect = [];                                                    %To store the coordinates of all the cirles' boders
   
    % Draw lines
     for clocknumber = 1:10
        relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every circle
        relcentery = -radius * cos(anglestep*clocknumber*pi/180);
        endcoordinate = [relcenterx+length/2*cos(stilocation(clocknumber)*pi/180),...
                        relcentery-length/2*sin(stilocation(clocknumber)*pi/180);...
                        relcenterx-length/2*cos(stilocation(clocknumber)*pi/180),...
                        relcentery+length/2*sin(stilocation(clocknumber)*pi/180)];     %The boders' coordinates of all the circle
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
    power=0;
%pre-stimulus (1 s) 
%     while 1
%         %outp(888, 66);
%         WaitSecs(0.004);
%         %outp(888, 0);
%         % tic
%         % power=serial_receive(com1);
%        % toc
%         if power==protocol(blockindex)
%             break
%         end
%     end   
%     tic  
%     Total_time(ntrial)=toc;        
%     Total_time(ntrial)=toc;
%     Total_Power(ntrial)=power;
    %target
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
    Screen('DrawLines', w, linerect, framethick, gra, center, 1);                   %Draw the line
    Screen('FrameOval', w, tarcolor', circlerect, framethick);                       %draw all the stimus
    Screen('Flip', w);   
    tic
    %outp(888, 10*arrowindex+ma);
    WaitSecs(0.004);
    %outp(888, 0);
    WaitSecs(stimtime);
    
    %response
    blanktime=1.5;
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
        %outp(888, 99+ACC(blockindex,ntrial));
        WaitSecs(0.004);
        %outp(888, 0);
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
save([filepath,'beha_data.mat'],'fidnew');

ShowCursor
Screen('CloseAll');

