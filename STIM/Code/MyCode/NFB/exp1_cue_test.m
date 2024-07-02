% Exp1 with pre-cue for ERP class
% Coded by YQ.Hu @ BNU 2020-11-25
    %% 运行前准备部分
    clear; %
    clc; %
    close all; %
%     Priority(1); %
    rand('state',sum(100*clock));  
    
    % ---Connection Config---
%     config_io
%     outp(888, 0);  

    % ------Submessage-----
    prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Hand','run'};
    dlg_title='submessage';
    num_lines=1;
    defaultanswer={'1','hu','1','19940501','right','1'};
    subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    commandwindow;
%     dataPath='E:\Huyiqing\Exp1_Cue\';
    dataPath='C:\Users\15455\Documents\MyWork\Data\Exp1_Cue\';
    dataname='beha_data.mat';
    filename=strcat(dataPath,dataname);
    
    % --------Store------
    subid_name_file=strcat('sub',subinfo{1});
    filepath=strcat(dataPath,'\experimentdata\subexpdata\','sub',subinfo{1},'\');
    if ~exist(filepath,'dir')
         mkdir(filepath);
    end
    
     % ------显示参数------
     screenNumber = max(Screen('Screens')); %
     distance = 57;         % distance between subject and monitor
     monitorwidth = 41;      % The width of the monitor
     
     % ---PTB Parameters---
     % 此处用于开启或关闭垂直同步测试
     bSkipSyncTests = 0; %是否禁用垂直同步测试，正式实验时切勿禁用
     Screen('Preference','SkipSyncTests',bSkipSyncTests);   
     [w, wRect] = PsychImaging('OpenWindow', screenNumber, [0,0,0], [], 32, 2,[], [],  kPsychNeed32BPCFloat);
     Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  %打开透明度混合功能(反锯齿需要)
     [center(1), center(2)] = WindowCenter(w);                          
     slack = Screen('GetFlipInterval',w)/2;
     ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;  % 根据距屏幕远近，屏幕大小配适刺激大小
%      HideCursor;

%% MAIN PROGRAM
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


%% 参数设置
     % -----色彩参数------
     background = [0,0,0];                                       %The background color            
     gra = [128,128,128];                                        %The sti color
     colorindex=[];
     
     % ------线索参数------
    CenterLeftArrowxyLists = [-36,0;-20,12;-20,4;20,4;20,-4;-20,-4;-20,-12];    %左箭头坐标
    CenterRightArrowxyLists = [36,0;20,12;20,4;-20,4;-20,-4;20,-4;20,-12];    %右箭头坐标
    CenterNeuralArrowxyLists = [-36,0;-20,12;-20,4;20,4;20,12;36,0;20,-12;20,-4;-20,-4;-20,-12];    %右箭头坐标

    % ----时间和流程控制----
    tPreFix = 0.2;          %刺激出现前注视点呈现的时间
    tCueOnsetDuraion = 0.2; %线索出现的时间
    tCrossDalyDuraion = 1;  %线索出现后注视点呈现时间
    tStimDuraion = 0.2;     % 刺激呈现时间
    tITI = 0.5 * rand;      % Inter Trial Interval
    response_interval = 2;  %按键最长时间 
    
    % ------按键参数------
    KbName('UnifyKeyNames');
    upkey = KbName('2'); 
    downkey = KbName('1');
    EscapeKey = KbName('ESCAPE'); % 中断程序按‘Esc’

    % ----block & trial----
    trial=4; % 对于不同刺激类型占比不同
    block=2;

    % trial=80; % 对于不同刺激类型占比不同
    % block=6;


%% -----Introduction-----
sttext = 'Welcome! Press SPACE key to start';
breaktext='Take a break and then press SPACE key to start';
endtext = 'Congratulations! The exp has been finished!';
font = 'Arial';
fontsize = 30;
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background);
Screen('DrawText', w , sttext, 2*center(1)/3, center(2), gra);
Screen('Flip', w);
KbWait;%等待直到按键 

%% ----Condition List----
list=randperm(trial); % 随机化刺激

condition_index(list(1))=21;         %  up left
condition_index(list(2))=22;         %  up right
condition_index(list(3))=13;         %  down left
condition_index(list(4))=14;         %  down right

%  Target can be at 4 positions 
% condition_index(list(1:20))=21;    %  up left
% condition_index(list(21:40))=22;   %  up right
% condition_index(list(41:60))=13;   %  down left
% condition_index(list(61:80))=14;   %  down right

%% --- fixation+ ---
linedeg = 1;                                                      %The visual angel of the line
length = ceil(linedeg*ppd);

fixrect=[];
fixrect=[fixrect;0,1/2*length;0,-1/2*length];
fixrect=[fixrect;-1/2*length,0;1/2*length,0];
firstfixtime=1;                                                  % 每个block开始前fix持续的时间
fixationtime=randi([1000,1200],1,1)/1000;                        %随机化窗口
responsetime=1;
fixdeg = 0.14;                                                    %The visual of the side thick(deg)
fixthick = ceil(fixdeg * ppd); 
%% ----- Sti -----
 % diamonds
diamonddeg =3.0;                                                   %The visual angle of the diamond(deg)
diamondiameter = ceil(diamonddeg*ppd);                             %The diameter of the diamond(pixel)
 % round
rounddeg = 2.7;                                                    %The visual angle of the circle(deg)
rounddiameter = ceil(rounddeg*ppd);                                %The diameter of the circle(pixel)      

 % Sti array 
stifromfix = 9.2;                                                   %The visual angle between the fixation and the stimulus
radius = stifromfix * ppd;                                          %The clock radius
stinum=12;
anglestep = 360/stinum;                                             %The angle between two closest stimulus
circlerect = [];                                                    %To store the coordinates of all the stis' boders
relcenterx = [];
relcentery = [];
relcenterxAll = [];
relcenteryAll = [];


%% --- draw round ---
for clocknumber = 1:12
    relcenterx = radius * sin(anglestep*clocknumber*pi/180);        %To calculate the coordinates of the center of every sti
    relcentery = radius * cos(anglestep*clocknumber*pi/180);
    bodercoordinate = [center(1)+relcenterx-rounddiameter/2, center(2)-rounddiameter/2-relcentery, center(1)+relcenterx+rounddiameter/2, center(2)-relcentery+rounddiameter/2];     %The boders' coordinates of all the circle
    circlerect = [circlerect;bodercoordinate];
    relcenterxAll = [relcenterxAll,relcenterx] ;
    relcenteryAll = [relcenteryAll,relcentery];
end

circlerect = circlerect'; % 转置

%% -- cue target array--
Screen('FillRect', w, background);
Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  
Screen('Flip', w);                                                              %display
WaitSecs(firstfixtime); 

for blockindex=1:block
for ntrial=1:trial
   %% Sti Type
    totaltrialnum = ntrial+(blockindex-1)*trial;
    stiindex = condition_index(ntrial);
    Targetlocindex = fix(stiindex/10);        %to decide the direction of the round  1:down 2:up
    StiType =mod(stiindex,10);                % 取余 to decide sti type 1 2 3 4,圆所在的四个位置
    TargetDirect = mod(StiType,2);            % 判断圆在做还是在右 1:left 0:right
    diamonterx = relcenterxAll;
    diamontery = relcenteryAll;
    
    %% 绘制cue呈现前的注视点
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1); 
    tCrossOnset = Screen('Flip', w);          %呈现注视点，记录呈现时刻
    
    %% draw cue 
     Neural_or_not = (rand > 0.5);            % 1为Neural,0为单向          
     
    if Neural_or_not == 1
        Screen('FillPoly',w, gra, CenterNeuralArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
    else 
         if TargetDirect == 1
        Screen('FillPoly',w, gra, CenterLeftArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
        else
        Screen('FillPoly',w, gra, CenterRightArrowxyLists + [center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2);center(1), center(2)]);
        end
    end
 
     tCueOnset = Screen('Flip', w, tCrossOnset + tPreFix - slack); %呈现cue，记录呈现时刻 
%      oupt(888,(Change_or_not+1)*100+mb*10+ma); % 百分位：2中性cue,1单侧cue 十分位：1T左0T右 个位：sti类型
     WaitSecs(0.004);
%      oupt(888, 0); 

     %% cue后呈现注视点
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);  % 绘制注视点
     tCrossDelayTime = Screen('Flip', w, tCueOnset + tCueOnsetDuraion - slack); %刺激呈现，保留注视点
     
      %% 决定Sti位置
    switch StiType        
        case 1 % cue:yellow & green  dis middleline-Nt
                   tarloca=10;
                   tarloca2=8;
        case 2 % cue:red&green  tar midline  _Pd
                   tarloca=2;
                   tarloca2=4;
        case 3
                   tarloca=8;
                   tarloca2=10;
        case 4  % opposite
                   tarloca=4;
                   tarloca2=2;
    end
    
    roundlocal(:,1)= circlerect(:,tarloca); % T
    diamonterx(tarloca2) = [];
    diamontery(tarloca2) = [];
    
    
      %% 按键
        switch Targetlocindex
        case 2
            rightkey = upkey;
            wrongkey = downkey;
        case 1
            rightkey = downkey;
            wrongkey = upkey;
        end
        
      %% 绘制Sti屏
    Screen('FillRect', w, background);                                              %draw the background
    Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation

 for clocknumber2 = 1:11
%     diamonterx(clocknumber2) = radius * sin(anglestep*clocknumber2*pi/180);        %To calculate the coordinates of the center of every sti
%     diamontery(clocknumber2) = radius * cos(anglestep*clocknumber2*pi/180);
      bodercoordinate2 = [center(1)+diamonterx(clocknumber2), center(2)+diamontery(clocknumber2)+diamondiameter/2;
                          center(1)+diamonterx(clocknumber2)+diamondiameter/2, center(2)+diamontery(clocknumber2);
                          center(1)+diamonterx(clocknumber2), center(2)+diamontery(clocknumber2)-diamondiameter/2;
                          center(1)+diamonterx(clocknumber2)-diamondiameter/2, center(2)+diamontery(clocknumber2);];     %The boders' coordinates of all the circle
%     circlerect2(clocknumber2,:,:) = bodercoordinate2;
    Screen('FillPoly', w, gra, bodercoordinate2);  
 end 
    Screen('FillOval', w, gra, roundlocal);                                          %画round   
    tStimOnsetTime = Screen('Flip', w, tCrossDelayTime + tCrossDalyDuraion - slack); %呈现注视点，记录呈现时刻
    
%     outp(888, stiindex);
    WaitSecs(0.004);
%     outp(888, 0);
    
    %% 绘制刺激呈现后的注视点,记录反应
     Screen('FillRect', w, background);                                              %draw the background
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
     tCrossRespTime = Screen('Flip', w, tStimOnsetTime + tStimDuraion - slack); %呈现注视点，记录呈现时刻
     
    %% 等待按键反应
    while GetSecs - tStimOnsetTime <= response_interval
         [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
         Data(totaltrialnum).RTs = secs - tStimOnsetTime;   
            if find(keyCode)== rightkey     %选对
              Data(totaltrialnum).ACC = 1;
              Data(totaltrialnum).response = str2num(KbName(rightkey));
              res_trg=100; 
              break
            elseif find(keyCode)== wrongkey  %选错
              Data(totaltrialnum).ACC = 0;
              Data(totaltrialnum).response = str2num(KbName(wrongkey)); 
              res_trg=99; 
              break
            elseif  find(keyCode) == EscapeKey
              Data(totaltrialnum).RTs = nan;
              Screen('CloseAll'); 
              break
            else
              Data(totaltrialnum).RTs = nan;
              Data(totaltrialnum).ACC = nan;
              Data(totaltrialnum).response = nan;
              res_trg=99;  
            end
    end
     Screen('FillRect', w, background);                                              %draw the background
     Screen('DrawLines', w, fixrect',fixthick, gra, center, 1);                    %draw the fixation
     Screen('Flip', w);           %呈现注视点  
%    outp(888, res_trg); 
     WaitSecs(0.004);
%    outp(888, 0);
     WaitSecs(tITI);
    
 %% 记录数据
       Data(totaltrialnum).StiType = stiindex;
       Data(totaltrialnum).CResp = Targetlocindex;
       Data(totaltrialnum).CueType=(Neural_or_not+1)*100+TargetDirect*10+StiType; % % 百分位：2中性cue,1单侧cue 十分位：1T左0T右 个位：sti类型
       Data(totaltrialnum).TrialNum = totaltrialnum;

end
% 一个block结束
Screen('DrawText', w, breaktext, 5*center(1)/10, center(2), gra, background);
Screen('Flip', w);
KbWait;%等待直到按键

end
% 实验结束
Screen('FillRect', w, background);
Screen('DrawText', w , endtext, 3.2*center(1)/5, center(2), gra);
Screen('Flip', w);
WaitSecs(2);

 %% 保存数据
behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_Exp1_Cue_',subinfo{6},'.mat');
save([filepath,behaviordataname],'Data');

ShowCursor
Screen('CloseAll');
