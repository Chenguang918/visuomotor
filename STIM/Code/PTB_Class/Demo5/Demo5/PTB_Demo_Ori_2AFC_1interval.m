function PTB_Demo_Ori_2AFC_1interval()
% ����������Psychtoolbox�����ʾ����
% ͨ��1��interval 2AFC�ķ�������߶γ�����������������
% Coded by Y. Yan @ BNU 2018-04-02

    %% ����ǰ׼������
    clear; %������б����������ϴ����еĲ�������Ӱ�챾������
    clc; %������������֣��Ա㱾���������������ϴεĻ���
    close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
    Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

    %% �������ò���
    % ������Ϣ
    strSubjectName = 'YanY';
    % ��ʾ����
    bSkipSyncTests = 1; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    nMonitorID = max(Screen('Screens')); %��Ļ��ţ�ע��˴�MacOS��Windows��ͬ
    HideCursor(nMonitorID); %����ָ��
    clrBg = [50 50 50]; %ָ��������ɫ
    % ע�ӵ����
    fFpCrossLength = 10; %ע�ӵ�ʮ�ֵĳ���
    fFpCrossWidth = 3; %ע�ӵ�ʮ���ߵĴ�ϸ
    clrFpCross = [0 255 0]; %ָ��ע�ӵ���ɫ
    % �̼�����
    StimXp = -100; %�˴�����Ļ����Ϊ0
    StimYp = -100; %�˴�����Ļ����Ϊ0, ����Ϊ��
    fRefOri = 90; %�仯����Ļ�׼ֵ
    fLineOri = (-3:1:3)+fRefOri; %�仯���߶γ���
    fStimLength = 50; %�̼�����
    fStimWidth = 5; %�̼����
    clrStim = [127 127 127]; %�̼���ɫ
    % ʱ������̿���
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimOnsetDuraion = 0.1; %�̼����ֵ�ʱ��
    tISI = 0.3; % Inter Trial Interval
    StimTrialNum = 50; %ÿ��������trial��

    %% ������ɴ̼�����
    StimNum = numel(fLineOri); %�õ��̼�������
    StimIDs = mod(randperm(StimNum*StimTrialNum)-1,StimNum)+1; %���ɶ���1:StimNum�������

    %% �̼����ֲ���
    % �˴����ڿ�����رմ�ֱͬ������
    Screen('Preference','SkipSyncTests',bSkipSyncTests);

    % ��ʼ����Ļ���õ���Ļ����
    wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %��ָ������ʾ���򿪴̼�����
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
    [xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
    slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��

    % �ȴ�������ʼʵ��
    KbWait();
    
    for iTrial = 1:StimNum*StimTrialNum
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��

        % ���ƴ̼�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %����ע�ӵ�
        Ori = fLineOri(StimIDs(iTrial)); %�õ���ǰtrial������ɵĳ���
        DrawOrientedLine(wPtr, +StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %�����߶�

        %���ִ̼�����ʧ
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %�̼����֣�����ע�ӵ�
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %�̼���ʧ�����ֱ�����ע�ӵ�
        
        %�ȴ�������Ӧ����¼����
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).StimID = StimIDs(iTrial);
        if find(keyCode)==37 %ѡ��
            Data(iTrial).Resp = -1;
        elseif find(keyCode)==39 %ѡ��
            Data(iTrial).Resp = 1;
        elseif find(keyCode)==27 %esc
            break
        else
            Data(iTrial).Resp = nan;
        end
        WaitSecs(tISI);
    end
    
    %% ��������
    tbData = struct2table(Data);
    writetable(tbData, strcat('Data_2AFC_Ori_',strSubjectName));
    
    %% �رմ���
    Screen('CloseAll');
end

%% ���ڻ���ע�ӵ���Ӻ���
function DrawFP(wPtr, x, y, length, width, color)
    ptsCrossLines = [-length length 0 0; 0 0 -length length];
    Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %����Ļ�ϻ�������߶�
end

%% ���ڻ���ָ�������߶ε��Ӻ���
function DrawOrientedLine( wPtr, x, y, ori, length, width, color, center)
    oriRad = ori/180*pi; %���Ƕ�ֵת���ɻ���
    fromH = round(x+cos(oriRad)*length/2); %������ʼ��ĺ�����
    toH = round(x-cos(oriRad)*length/2); %������ֹ��ĺ�����
    fromV = round(y-sin(oriRad)*length/2); %������ʼ��������꣬ע��y������������
    toV = round(y+sin(oriRad)*length/2); %������ֹ��������꣬ע��y������������
    Screen('DrawLines', wPtr, [fromH toH; fromV toV], width, color, center, 2);
end