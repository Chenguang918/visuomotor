% ����������Psychtoolbox�����ҵ����
% ��������Ҫ������ԴData_2AFC_Ori_YanYin.txt
% Coded by Y. Yan @ BNU 2018-04-02

%% ����ǰ׼��
clear; %��չ�����
clc; %���������
close all; %�ر�����figure

%% �����趨
strDataPath = 'Data_2AFC_Ori_YanYin.txt'; %���ļ�·������ɱ���

%% ��ȡ����
tbData = readtable(strDataPath);

%% ����ѡ��ĸ���
maxStimID = max(tbData.StimID); %�õ�����StimID
for iStim = 1:maxStimID %�˴�������StimID��1��ʼ
    RightTrialNum(iStim) = sum(tbData.Resp(tbData.StimID==iStim)<0); %����ѡ�ҵ�trial��
    StimTrialNum(iStim) = sum(tbData.StimID==iStim); %����ÿ���̼���������trial��
end

%% ��������������
StimLevels = (-3:1:3)+90; %���ô̼�����
PsyMetrFunc = @PAL_Logistic; %�õ��������
paramsValues = [90 1 0 0]; %���ʹ�õ���ʼֵ
paramsFree = [1 1 0 0]; %����п�������仯�Ĳ���
B = 1000; %����bootstrapping 1000��
[paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels, RightTrialNum, StimTrialNum, paramsValues, paramsFree, PsyMetrFunc)
[SD paramsSim LLSim converged] = PAL_PFML_BootstrapParametric(StimLevels, StimTrialNum, paramsValues, paramsFree, B, PsyMetrFunc);
SD % ����������ʾSD��ֵ
[Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, RightTrialNum, StimTrialNum, paramsValues, paramsFree, B, PsyMetrFunc);
pDev % ����������ʾpDev��ֵ

%% ��ͼ
RightRate = RightTrialNum./StimTrialNum; %�õ�ѡ�ҵĸ���
StimLevelsFine = [min(StimLevels):(max(StimLevels)-min(StimLevels))./1000:max(StimLevels)]; %��ø߾��ȵ�xֵ
FitData = PsyMetrFunc(paramsValues,StimLevelsFine); %�õ��������
plot(StimLevels, RightRate, 'k.', 'markersize', 30); %����ԭʼ����
axis([86.5 93.5 0 1]); %�������귶Χ
hold on; %�رո���ģʽ
plot(StimLevelsFine, FitData, 'g-', 'LineWidth', 3); %�����������
xlabel('Line orientation (deg)');
ylabel('Probability of choosing "right"');