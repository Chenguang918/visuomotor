% ����������Psychtoolbox�����ʾ����
% ����ʮ��ע�ӵ㲢��ȷ���Ƴ���ʱ��
% Coded by Y. Yan @ BNU 2018-03-26

%% ����ǰ׼������
clear; %������б����������ϴ����еĲ�������Ӱ�챾������
clc; %������������֣��Ա㱾���������������ϴεĻ���
close all; %�ر�����figure��ͬ��Ϊ�������н�����ϴλ���
Priority(1); %��ߴ�������ȼ���ʹ����ʾʱ��ͷ�Ӧʱ��¼����ȷ(�˴�MacOS��ͬ)

%% �������ò���
% ��������Ҫ�õ��Ĳ���Ԥ�ȶ���ã������ڳ����ڲ��������ֳ���
bSkipSyncTests = 1; %�Ƿ���ô�ֱͬ�����ԣ���ʽʵ��ʱ�������
nMonitorID = max(Screen('Screens')); %��Ļ��ţ�ע��˴�MacOS��Windows��ͬ
    %��ʹ�ö���ʾ��ʱ���޸Ĵ˴���ֵ���Կ��ƴ̼����ֵ���ʾ����
    %ֻ������ʾ��ֱ������������ʱ��Ч����ʾ�����ó���չ����ģʽ����
    %ͨ����Ƶ�����ӵĶ���ʾ������Ϊ��ͬһ����ʾ��
clrBg = [50 50 50]; %ָ��������ɫ
fFpCrossLength = 10; %ע�ӵ�ʮ�ֵĳ���
fFpCrossWidth = 3; %ע�ӵ�ʮ���ߵĴ�ϸ
clrFpCross = [0 255 0]; %ָ��ע�ӵ���ɫ
tFpDuration = 1.5; %ע�ӵ���ֵ�ʱ��
tBlankDuration = 0.5; %�������ֵ�ʱ��

%% �̼����ֲ���
% �˴����ڿ�����رմ�ֱͬ������
Screen('Preference','SkipSyncTests',bSkipSyncTests);

% ��ʼ����Ļ���õ���Ļ����
wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %��ָ������ʾ���򿪴̼�����
Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)
[xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��

% ����ע�ӵ�ʮ�ֺ��ߺ����ߵ���ʼ�ͽ���λ��
ptsCrossLines = [-fFpCrossLength fFpCrossLength 0 0; 0 0 -fFpCrossLength fFpCrossLength];
Screen('DrawLines', wPtr, ptsCrossLines, fFpCrossWidth, clrFpCross,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�

% �ȴ�������ʼ����ע�ӵ�
KbWait(); 
tFpOnset = Screen('Flip', wPtr); %����ע�ӵ㣬��¼����ʱ��
tFpOffset = Screen('Flip', wPtr, tFpOnset + tFpDuration - slack);
tRealDuration = tFpOffset - tFpOnset
Screen('Flip', wPtr, tFpOffset + tBlankDuration - slack);
Screen('CloseAll');