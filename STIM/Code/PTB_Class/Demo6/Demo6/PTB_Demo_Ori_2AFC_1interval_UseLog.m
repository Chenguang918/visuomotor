function PTB_Demo_Ori_2AFC_1interval_UseLog()
% ����������Psychtoolbox�����ʾ����
% ͨ��1��interval 2AFC�ķ�������߶γ�����������������
% Coded by Y. Yan @ BNU 2018-04-09

    %% ����ǰ׼������
    clear; %������б����������ϴ����еĲ�������Ӱ�챾������
    clc; %������������֣��Ա㱾���������������ϴεĻ���
    close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
    Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

    %% �������ò���
    % ʵ����Ϣ
    tTimeStamp = now; %��¼ʵ�鿪ʼ��ʱ��
    strStartTime = datestr(tTimeStamp); %��ʱ��ת���ɱ�׼�ַ���
    strSubjectName = 'YanYin';
    % ��ʾ����
    bSkipSyncTests = 1; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
    nMonitorID = max(Screen('Screens')); %��Ļ��ţ�ע��˴�MacOS��Windows��ͬ
    HideCursor(nMonitorID); %����ָ��
    clrBg = [50 50 50]; %ָ��������ɫ
    % ע�ӵ����
    fFpCrossLength = 10; %ע�ӵ�ʮ�ֵĳ���
    fFpCrossWidth = 3; %ע�ӵ�ʮ���ߵĴ�ϸ
    clrFpCross = [0 255 0]; %ָ��ע�ӵ���ɫ
    % ��ȡ�̼�����
    tbStimParams = readtable('Parameters.xlsx');
    % ʱ������̿���
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimOnsetDuraion = 0.1; %�̼����ֵ�ʱ��
    tITI = 0.3; % Inter Trial Interval
    StimTrialNum = 50; %ÿ��������trial��

    %% ������ɴ̼�����
    StimNum = size(tbStimParams,1); %�õ��̼�������
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
    
    iFinishedTrialCount = 0; %Ϊ��ȷ�ϳ����Ƿ�˳��ִ����ϣ���¼ʵ�����е�trial��
    for iTrial = 1:StimNum*StimTrialNum
        % �õ���ǰtrial�Ĵ̼�����
        StimXp = tbStimParams.StimXp(StimIDs(iTrial)); %�˴�����Ļ����Ϊ0
        StimYp = tbStimParams.StimYp(StimIDs(iTrial)); %�˴�����Ļ����Ϊ0, ����Ϊ��
        Ori = tbStimParams.LineOri(StimIDs(iTrial)); %�߶εĳ���
        fStimLength = tbStimParams.StimLength(StimIDs(iTrial)); %�̼�����
        fStimWidth = tbStimParams.StimWidth(StimIDs(iTrial)); %�̼����
        clrStim = tbStimParams.StimColor(StimIDs(iTrial)); %�̼���ɫ
        
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��

        % ���ƴ̼�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %����ע�ӵ�
        DrawOrientedLine(wPtr, +StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %�����߶�

        %���ִ̼�����ʧ
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %�̼����֣�����ע�ӵ�
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %�̼���ʧ�����ֱ�����ע�ӵ�
        
        %�ȴ�������Ӧ����¼����
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).StimID = StimIDs(iTrial);
        if find(keyCode)==37 %ѡ��
            Data(iTrial).Resp = -1;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        elseif find(keyCode)==39 %ѡ��
            Data(iTrial).Resp = 1;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        elseif find(keyCode)==27 %ESC
            fprintf('ʵ����Ϊ��ֹ');
            Screen('CloseAll');
            break;
        else
            Data(iTrial).Resp = nan;
            iFinishedTrialCount = iFinishedTrialCount + 1;
        end
        WaitSecs(tITI);
    end
    
    %% �رմ���
    Screen('CloseAll');  
    tEnd = now;
    %% ��������
    tbData = struct2table(Data);
    writetable(tbData, sprintf('Data_2AFC_Ori_%s_%.0f',strSubjectName,tTimeStamp*24*3600));
    
    %% ����Log
    fpLog = fopen(sprintf('Data_2AFC_Ori_%s_%.0f.log',strSubjectName,tTimeStamp*24*3600),'w');
    
    fprintf(fpLog, '##### Global parameters #####\r\n');
    fprintf(fpLog, 'Start time: %s\r\n',strStartTime);
    fprintf(fpLog, 'Test duration: %.2f seconds\r\n',(tEnd - tTimeStamp)*24*3600);
    fprintf(fpLog, 'Subject Name: %s\r\n',strSubjectName);
    fprintf(fpLog, 'Total finished trial: %d\r\n',iFinishedTrialCount);
    fprintf(fpLog, 'Trial Number per Stim: %d\r\n',StimTrialNum);
    fprintf(fpLog, 'Skip Sync Test: %d\r\n',bSkipSyncTests);
    fprintf(fpLog, 'Background Color: %d %d %d\r\n',clrBg);
    fprintf(fpLog, 'Fp Cross Length: %.2f\r\n',fFpCrossLength);
    fprintf(fpLog, 'Fp Cross Width: %.2f\r\n',fFpCrossWidth);
    fprintf(fpLog, 'Background Color: %d %d %d\r\n',clrFpCross);
    
    fprintf(fpLog, '##### Timing parameters #####\r\n');
    fprintf(fpLog, 'Pre-stimlus blank time: %.2f\r\n',tPreFix);
    fprintf(fpLog, 'Stimlus onset duration: %.2f\r\n',tStimOnsetDuraion);
    fprintf(fpLog, 'Inter trial interval: %.2f\r\n',tITI);

    fprintf(fpLog, '##### Stimuli parameters #####\r\n');
    ParamNum = size(tbStimParams,2);
    ParamNames = tbStimParams.Properties.VariableNames;
    for iParam = 1:ParamNum
        fprintf(fpLog, '%s: ',ParamNames{iParam});
        for iStim = 1:StimNum
            fprintf(fpLog, '%.4f;',tbStimParams{iStim,iParam});
        end
        fprintf(fpLog, '\r\n');
    end
    
    fclose(fpLog);
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