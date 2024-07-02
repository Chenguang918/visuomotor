% 心理物理与Psychtoolbox编程作业范例
% 本范例需要调用资源DemoData.txt
% Coded by Y. Yan @ BNU 2018-03-19

%% 运行前准备
clear; %清空工作区
clc; %清空命令行
close all; %关闭所有figure

%% 参数设定
strDataPath = 'DemoData.txt'; %将文件路径保存成变量

%% 读取数据
fidDataFile = fopen(strDataPath); %以读取方式打开数据文件
assert(fidDataFile>=3, 'Can not open data file!'); %检查文件是否正确打开
colTitle = textscan(fidDataFile,'%s',2); %读取标题行
Data = textscan(fidDataFile,'%f %f'); %读取数据，尽量使用浮点数，避免整型运算自动取整
fclose(fidDataFile);

%% 整理数据(可选)
maxStimID = max(Data{1}); %得到最大的StimID
for iStim = 1:maxStimID %此处假设了StimID从1开始
    TrialNum(iStim) = sum(Data{1}==iStim); %计算每个条件的trial数
end
GroupedData = nan(max(TrialNum),maxStimID); %假如此处用zeros代替nan会有什么问题？
for iStim = 1:maxStimID %此处假设了StimID从1开始
    GroupedData(1:TrialNum(iStim),iStim) = Data{2}(Data{1}==iStim)>0; %计算每个条件的trial数
end

%% 计算正确率
CorrectRate = nanmean(GroupedData); %计算去除nan后的平均值
% CorrectRate = mean(GroupedData); %这种写法会使含有nan的列保持nan

%% 绘图
% plot(CorrectRate); %只用这一句的话是最简化版本的数据展示
plot(1:7,CorrectRate,'b--o','Linewidth',2); %设置曲线为蓝色虚线，数据点用圈，粗细2
box off; %去掉方框
axis([0.8 maxStimID+0.2 -0.05 1.05]); %设置坐标轴x和y的范围，为了美观四周留空
title('Correct rate vs stimulus ID'); %在图标上方显示标题
xlabel('Stim ID'); %设置x轴标注
ylabel('Correct rate'); %设置y轴标注