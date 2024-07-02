%% parameters setup
%% ------submessage-------
prompt={'subid','session','condition','startblock','endblock','name','gender','birthday',...
'LeftEyesight','RightEyesight','TwoEyesight','glasses','other'}; %2018/01/11 add 'condition','TwoEyesight'
dlg_title='submessage';
num_lines=1;
defaultanswer={'0','1','all','0','11','zhang','1','19981101','5.0','5.0','5.0','1','nothing'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
subinfo = cell2struct (subinfo,prompt);

%% --------condition parameter-----------
switch subinfo.condition %2018/01/11 add
    case {'All','all','ALL'}
        ConditionStr = 'All';%2017/12/14 add
        ConditionArray = [1,2,3,4];
    case {'1','SA','sa','Sa'} %SA
        ConditionStr = 'SA';%2018/01/11 add
        ConditionArray = [1];
    case {'2','SB','sb','Sb'} %SB
        ConditionStr = 'SB';%2018/01/11 add
        ConditionArray = [2];
    case {'3','CA','ca','Ca'} %CA
        ConditionStr = 'CA';%2018/01/11 add2
        ConditionArray = [3];
    case {'4','CB','cb','Cb'} %CB
        ConditionStr = 'CB';%2018/01/11 add
        ConditionArray = [4];
    case {'SASBCA','sasbca'}
        ConditionStr = 'SASBCA';
        ConditionArray = [1,2,3];
    case {'SASBCB','sasbcb'}
        ConditionStr = 'SASBCB';
        ConditionArray = [1,2,4];
    case {'SASB','sasb'}
        ConditionStr = 'SASB';
        ConditionArray = [1,2];
    case {'CACB','cacb'}
        ConditionStr = 'CACB';
        ConditionArray = [3,4];
    case {'SACA'}
        ConditionStr = 'SACA';
        ConditionArray = [1,3];
    case {'SBCB'}
        ConditionStr = 'SBCB';
        ConditionArray = [2,4];
end

subid_name_file=setfilename(strcat('sub',subinfo.subid,'_',subinfo.session,'_',ConditionStr,'_'));
filepath=strcat(pwd,'\experimentdata\subexpdata\','sub',subinfo.subid,subinfo.name,'\');
if ~exist(filepath,'dir')
    mkdir(filepath);
end
filename=strcat(filepath,'\',subid_name_file);
edffilename=strcat(subinfo.subid,'_',subinfo.session,ConditionStr);
matname=strcat(filename,'.mat');
%% show time
fixation_time=0.5;%second
%fixation_randtime=0.2;%second
fixating_time=0.4;%fix at fixation point
fixating_randtime=1;
%stimulus_time=1;%second
response_intervaltime=2;%second
relax_time=10;%second
feedback_time=0.3;%second
remind_recordingtime=1;%second
remind_fixationtime=0.3;%second
marker_time=0.005;
blockAddTime = 5;
%% Kb setup
KbName('UnifyKeyNames');
leftkey=KbName('4');
rightkey=KbName('+');
% leftkey=KbName('LeftArrow');
% rightkey=KbName('RightArrow');
rightarrow=KbName('RightArrow');
stopkey=KbName('ESCAPE');
nextkey=KbName('F5');
keyRestrict=0;
recalibrationkey = KbName('F1');%20181213
%% trigger
m_start=210;
m_block=211;
m_relax=212;
m_end=213;
m_remindersound=214;
m_wrongsound=215;
m_correctsound=216;

m_starttrial=200;
m_endtrial=206;
m_fiximage=201;
m_resp=202;
m_button=203;
m_correct=204;
m_wrong=205;

m_exceed100=220;
m_exceed150=221;
m_exceed200=222;

%% display setup
DisplaySetup431room;
% p.rect = [0,0,1024,768];
% p.ScreenDistance = 65; % cm
% p.ScreenHeight = 25; % cm
% p.ScreenWidth = 45; % cm
% p.ppd =  pi/180* p.ScreenDistance / p.ScreenHeight * p.rect(4);%pixels per degree 
%% stim parameters
p.stimRows = 11;
p.stimColumns=19;
p.itemSize = [1,0.1];% in visual angle
p.fixationPointSize = 0.4;% in visual angle
p.fixationThreshold = [2,3,4];% in visual angle
p.jitter = 0.2;%0.4;%before20180907 in visual angle
stimulusLength = round(p.itemSize(1)*p.ppd);%pixel
if mod(stimulusLength,2)~=0
    stimulusLength = stimulusLength+1;
end
p.stimulusLength = stimulusLength;
stimulusWidth= round(p.itemSize(2)*p.ppd);%pixel
if mod(stimulusWidth,2)~=0
    stimulusWidth = stimulusWidth+1;
end
p.stimulusWidth = stimulusWidth;
fixationPointR = round(p.fixationPointSize*p.ppd);%pixel
if mod(stimulusWidth,2)~=0
    fixationPointR = fixationPointR+1;
end
p.fixationPointR = fixationPointR;
perturbation = round(p.jitter*p.ppd);%pixel
p.perturbation = perturbation;
fixationCriteria = round(p.fixationThreshold.*p.ppd);%pixel
p.fixationCriteria = fixationCriteria;
cubeSize = floor([p.rect(3)/p.stimColumns,p.rect(4)/p.stimRows]);%pixel

%% eyelink threshold
hor_threshold= fixationCriteria(1);
vert_threshold= fixationCriteria(1);
hor_threshold2= fixationCriteria(2);
vert_threshold2= fixationCriteria(2);
hor_threshold3 = fixationCriteria(3);
vert_threshold3 = fixationCriteria(3);
%% item
PREstimulusLightness=0.05;%明度
a=zeros(stimulusLength);
a(:,(stimulusLength-stimulusWidth)/2+1:(stimulusLength+stimulusWidth)/2)=PREstimulusLightness;
% a=zeros(Vd/2+length,Hd/2+length);
% a(Vd/4:Vd/4+length-1,Hd/4:Hd/4+length-1)=b;
vertical=a;
horizontal=imrotate(a,90);
%fixation=vertical+horizontal;%collect(n,1).object(iindex,jindex)=0
FixationSize = fixationPointR;
x = -FixationSize:FixationSize;
xx = ones(2*FixationSize+1, 1)*x;
y = -FixationSize:FixationSize;
yy = y'*ones(1, 2*FixationSize+1);
r = sqrt(xx.^2 + yy.^2);
%--- draw the  circle
fixation  = (r< FixationSize/2);

method='bilinear';
left45=imrotate(a,45,method,'crop');%collect(n,1).object(iindex,jindex)=1;%每个位置是什么形状的索引
right45=imrotate(a,135,method,'crop');%collect(n,1).object(iindex,jindex)=2;
left20=imrotate(a,20,method,'crop');%collect(n,1).object(iindex,jindex)=3;%从竖直位置左倾20度
right20=imrotate(a,160,method,'crop');%collect(n,1).object(iindex,jindex)=4;
left20H=imrotate(a,70,method,'crop');%collect(n,1).object(iindex,jindex)=5;%从水平位置左倾20度
right20H=imrotate(a,110,method,'crop');%collect(n,1).object(iindex,jindex)=6;%从竖直位置右倾20度

left45andv=left45+vertical;%collect(n,1).object(iindex,jindex)=7;
right45andv=right45+vertical;%collect(n,1).object(iindex,jindex)=8;
left45andh=left45+horizontal;%collect(n,1).object(iindex,jindex)=9;
right45andh=right45+horizontal;%collect(n,1).object(iindex,jindex)=10;

left20andv=left20+vertical;%collect(n,1).object(iindex,jindex)=11;
right20andv=right20+vertical;%collect(n,1).object(iindex,jindex)=12;
left20Handh=left20H+horizontal;%collect(n,1).object(iindex,jindex)=13;%从水平位置左倾20度加竖直线
right20Handh=right20H+horizontal;%collect(n,1).object(iindex,jindex)=14;

%mask=vertical+imrotate(a,23,'crop')+imrotate(a,23*2,'crop')+imrotate(a,23*3,'crop')+imrotate(a,23*4,'crop')+imrotate(a,23*5,'crop')+imrotate(a,23*6,'crop')+imrotate(a,23*7,'crop');
distractors={{right45 right45} {left45 left45};
    {right45 right45} {left45 left45};
    {right45andv right45andh} {left45andv left45andh} ;
    {right45andv right45andh} {left45andv left45andh} };
targets={{left45 left45} {right45 right45};
    {left20 left20H} {right20 right20H} ;
    {left45andv left45andh} {right45andv right45andh};
    {left20andv left20Handh} {right20andv right20Handh} };
distractorsIndex={{2 2} {1 1};%bias=1时干扰右倾
    {2 2}  {1 1};
    {8 10} {7 9} ;
    {8 10}  {7 9} };
targetsIndex={{1 1} {2 2};%bias=1时目标左倾
    {3 5} {4 6} ;
    {7 9} {8 10} ;
    {11 13} {12 14}};
p.distractors = distractors;
p.targets = targets;
p.distractorsIndex = distractorsIndex;
p.targetsIndex = targetsIndex;
%% TargetPositions
TargetPositions = [2,2;...
                    3,1;...
                    2,3;...
                    3,4];%20180907
%% random array
practicetrial = 48;
p.eachTreatmeatsTrialInBlock = 2;
p.StimDuration = [0.3,0.5,1];%secs
p.ConditionArray = ConditionArray;
p.TargetDistance = [1,2];
p.leftOrRight = [-1,1];
factors = [length(p.StimDuration),length(p.ConditionArray),length(p.TargetDistance),length(p.leftOrRight)];
treatments = CombineFactors(factors);
TrialArrayInBlock = repmat(treatments,p.eachTreatmeatsTrialInBlock,1);
%RandTrialArrayInBlock = TrialArrayInBlock(randperm(length(TrialArrayInBlock)),:);
%% trial num
% totaltrials=length(randnumber_array);
% practice_trials=4*length(ConditionArray);
% block_trials= str2double(subinfo.EachConditionTrialsInBlock)*length(ConditionArray);
% if length(ConditionArray) == 1
%     practice_trials = 16;
%     block_trials = 64;
% end
% start_block=str2double(subinfo.startblock);
% end_block=str2double(subinfo.endblock);
% if start_block>1
%     start_trial=1+practice_trials+(start_block-2)*block_trials;
% else
%     start_trial=1;
% end
% if end_block==1
%     end_trial=practice_trials;
% else
%     end_trial=practice_trials+(end_block-1)*block_trials;
% end


%% ---------load stimulus parameter---------------

%%'backgroundLightness','stimulusLength','stimulusWidth','stimulusLightness','figureRows','stimulusRows_start','stimulusRows','stimulusRows_end','stimulusColumns','HorizontalDistance','VerticalDistance','perturbation',...
%%'xy','fixation','distractors','targets','distractorsIndex','targetsIndex','deviceResolution','centeri','centerj','figureSeries','figureMessage_struct',...
%%'figureSeries':'figureNumber'/'cue' 'block' 'condition' 'rightORleft' 'location' 'number'  'bias' 'firstVorH' 'figureName' 'object' 'randmove'


%% load instruct image
figurepath = strcat(pwd,'\cuefigure\');
backgroundLightness = black;
deviceResolution = p.rect([3,4]);
im=zeros(deviceResolution(2),deviceResolution(1));%image空白黑屏
im(round(size(im,1)/2-size(fixation,1)/2):round(size(im,1)/2+size(fixation,1)/2)-1,round(size(im,2)/2-size(fixation,2)/2):round(size(im,2)/2+size(fixation,2)/2-1))=fixation;
im(im~=backgroundLightness)=white;
fixation_image=im;
fixation_index=Screen('MakeTexture',wptr,fixation_image);
% imwrite(im,strcat(figurepath,'fixation','.png'),'png');
% pos_practice_feedback_image=rgb2gray(imread([figurepath,'pos_practice_feedback.png']));
% neg_practice_feedback_image=rgb2gray(imread([figurepath,'neg_practice_feedback.png']));
% relaxstart_image=rgb2gray(imread([figurepath,'reminder_relaxstart.png']));
% relaxfinish_image=rgb2gray(imread([figurepath,'reminder_relaxfinish.png']));
% eye_image=rgb2gray(imread([figurepath,'reminder_fixation.png']));
% record_image=rgb2gray(imread([figurepath,'reminder_record.png']));
% %% prepare instruct image
% pos_practice_index=Screen('MakeTexture',wptr,pos_practice_feedback_image);
% neg_practice_index=Screen('MakeTexture',wptr,neg_practice_feedback_image);
% relaxstart_index=Screen('MakeTexture',wptr,relaxstart_image);
% relaxfinish_index=Screen('MakeTexture',wptr,relaxfinish_image);
% eye_index=Screen('MakeTexture',wptr,eye_image);
% record_index=Screen('MakeTexture',wptr,record_image);

