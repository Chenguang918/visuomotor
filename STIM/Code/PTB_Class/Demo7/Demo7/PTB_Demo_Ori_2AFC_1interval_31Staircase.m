function PTB_Demo_Ori_2AFC_1interval_31Staircase()
% ����������Psychtoolbox�����ʾ����
% ͨ��1��interval 2AFC�ķ�������߶γ�����������������
% Coded by Y. Yan @ BNU 2018-04-15

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
    fStartSize = 10; %��ʼ���
    fStepSize = 0.5; %�Զ�����С�Ĳ�����ÿһ�εĴ̼���𶼳���fStepSize
    fStimLength = 50; %�̼�����
    fStimWidth = 5; %�̼����
    clrStim = [127 127 127]; %�̼���ɫ
    % ʱ������̿���
    tPreFix = 1.0; %�̼�����ǰע�ӵ���ֵ�ʱ��
    tStimOnsetDuraion = 0.1; %�̼����ֵ�ʱ��
    tISI = 0.3; % Inter Trial Interval
    TotalReversalNum = 10; %��ɶ��ٸ�reversal����

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
    ConsecutiveCorrect = 0; %��¼�������ԵĴ���
    AdjustDirection = 0; %��¼��ǰ���������Ѷȵķ���,1��ʾ�ڱ��ѣ�-1��ʾ�ڱ�򵥣�0��ʾδ֪
    iReversalTime = 0; %��¼������ת�Ĵ���
    DeltaOri = fStartSize; %�̼����봹ֱ����Ĳ���ʼ����Ϊ��ʼֵ
    iTrial = 0;
    while iReversalTime < TotalReversalNum
        iTrial = iTrial + 1;
        % ���ƴ̼�����ǰ��ע�ӵ�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross);
        tFpOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��

        % ���ƴ̼�
        DrawFP(wPtr, xCenter, yCenter, fFpCrossLength, fFpCrossWidth, clrFpCross); %����ע�ӵ�
        LorR = (rand>0.5)*2-1; %����һ��1��-1�ģ�1��ʾ�̼�ƫ��-1��ʾƫ��
        Ori = fRefOri+DeltaOri*LorR; %�õ���ǰtrial������ɵĳ���
        DrawOrientedLine(wPtr, StimXp, -StimYp, Ori, fStimLength, fStimWidth, clrStim, [xCenter, yCenter]); %�����߶�

        %���ִ̼�����ʧ
        tStimOnsetTime = Screen('Flip', wPtr, tFpOnset + tPreFix - slack, 2); %�̼����֣�����ע�ӵ�
        tStimOffsetTime = Screen('Flip', wPtr, tStimOnsetTime + tStimOnsetDuraion - slack); %�̼���ʧ�����ֱ�����ע�ӵ�
        
        %�ȴ�������Ӧ����¼����
        [secs, keyCode, deltaSecs] = KbWait();
        Data(iTrial).DeltaOri = DeltaOri;
        Data(iTrial).LorR = LorR;
        Data(iTrial).Keypress = find(keyCode);
        if (find(keyCode)==37 && LorR==1) || (find(keyCode)==39 && LorR==-1) %���Ե�trial
            ConsecutiveCorrect = ConsecutiveCorrect+1; %�����������Ե�trial��
            if ConsecutiveCorrect == 3 %�����������3�ξ������Ѷ�
                DeltaOri = DeltaOri*fStepSize;
                ConsecutiveCorrect = 0;
                if AdjustDirection < 0 %�����û�з�����ת����������˼�¼��ת����
                    iReversalTime = iReversalTime+1;
                    Reversal(iReversalTime).DeltaOri = DeltaOri;
                    Reversal(iReversalTime).AdjustDirection = AdjustDirection;
                end
                AdjustDirection = 1;
            end
        elseif (find(keyCode)==37 && LorR==-1) || (find(keyCode)==39 && LorR==1) %�����trial
            ConsecutiveCorrect = 0;
            DeltaOri = DeltaOri/fStepSize; %�����Ѷ�
            DeltaOri = min([DeltaOri 45]); %��Ҫ��DeltaOri����45��
            if AdjustDirection > 0 %�����û�з�����ת����������˼�¼��ת����
                iReversalTime = iReversalTime+1;
                Reversal(iReversalTime).DeltaOri = DeltaOri;
                Reversal(iReversalTime).AdjustDirection = AdjustDirection;
            end
            AdjustDirection = -1;
        elseif find(keyCode)==27 %ESC
            fprintf('ʵ����Ϊ��ֹ');
            Screen('CloseAll');
            break;
        else %����������
            %����������ʲôҲ����
        end
        WaitSecs(tISI);
    end
    
    %% ��������
    tbData = struct2table(Data);
    writetable(tbData, strcat('Data_2AFC_Ori_',strSubjectName));
    tbReversal = struct2table(Reversal);
    writetable(tbReversal, strcat('Reversal_2AFC_Ori_',strSubjectName));
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