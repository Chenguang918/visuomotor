% ����������Psychtoolbox�����ҵ����
% ��������Ҫ������ԴDemoData.txt
% Coded by Y. Yan @ BNU 2018-03-19

%% ����ǰ׼��
clear; %��չ�����
clc; %���������
close all; %�ر�����figure

%% �����趨
strDataPath = 'DemoData.txt'; %���ļ�·������ɱ���

%% ��ȡ����
fidDataFile = fopen(strDataPath); %�Զ�ȡ��ʽ�������ļ�
assert(fidDataFile>=3, 'Can not open data file!'); %����ļ��Ƿ���ȷ��
colTitle = textscan(fidDataFile,'%s',2); %��ȡ������
Data = textscan(fidDataFile,'%f %f'); %��ȡ���ݣ�����ʹ�ø��������������������Զ�ȡ��
fclose(fidDataFile);

%% ��������(��ѡ)
maxStimID = max(Data{1}); %�õ�����StimID
for iStim = 1:maxStimID %�˴�������StimID��1��ʼ
    GroupedData{iStim} = Data{2}(Data{1}==iStim)>0; %��-1,1ת����0,1
end

%% ������ȷ��
CorrectRate = cellfun(@mean, GroupedData); %ʹ��cellfun��cell�����ÿ��Ԫ������mean����

%% ��ͼ
% plot(CorrectRate); %ֻ����һ��Ļ�����򻯰汾������չʾ
plot(1:7,CorrectRate,'b--o','Linewidth',2); %��������Ϊ��ɫ���ߣ����ݵ���Ȧ����ϸ2
box off; %ȥ������
axis([0.8 maxStimID+0.2 -0.05 1.05]); %����������x��y�ķ�Χ��Ϊ��������������
title('Correct rate vs stimulus ID'); %��ͼ���Ϸ���ʾ����
xlabel('Stim ID'); %����x���ע
ylabel('Correct rate'); %����y���ע