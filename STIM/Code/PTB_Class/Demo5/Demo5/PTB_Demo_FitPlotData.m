% 心理物理与Psychtoolbox编程作业范例
% 本范例需要调用资源Data_2AFC_Ori_YanYin.txt
% Coded by Y. Yan @ BNU 2018-04-02

%% 运行前准备
clear; %清空工作区
clc; %清空命令行
close all; %关闭所有figure

%% 参数设定
strDataPath = 'Data_2AFC_Ori_YanYin.txt'; %将文件路径保存成变量

%% 读取数据
tbData = readtable(strDataPath);

%% 计算选左的概率
maxStimID = max(tbData.StimID); %得到最大的StimID
for iStim = 1:maxStimID %此处假设了StimID从1开始
    RightTrialNum(iStim) = sum(tbData.Resp(tbData.StimID==iStim)<0); %计算选右的trial数
    StimTrialNum(iStim) = sum(tbData.StimID==iStim); %计算每个刺激条件的总trial数
end

%% 拟合心理测量曲线
StimLevels = (-3:1:3)+90; %设置刺激条件
PsyMetrFunc = @PAL_Logistic; %得到函数句柄
paramsValues = [90 1 0 0]; %拟合使用的起始值
paramsFree = [1 1 0 0]; %拟合中可以随意变化的参数
B = 1000; %设置bootstrapping 1000次
[paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels, RightTrialNum, StimTrialNum, paramsValues, paramsFree, PsyMetrFunc)
[SD paramsSim LLSim converged] = PAL_PFML_BootstrapParametric(StimLevels, StimTrialNum, paramsValues, paramsFree, B, PsyMetrFunc);
SD % 在命令行显示SD的值
[Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, RightTrialNum, StimTrialNum, paramsValues, paramsFree, B, PsyMetrFunc);
pDev % 在命令行显示pDev的值

%% 绘图
RightRate = RightTrialNum./StimTrialNum; %得到选右的概率
StimLevelsFine = [min(StimLevels):(max(StimLevels)-min(StimLevels))./1000:max(StimLevels)]; %获得高精度的x值
FitData = PsyMetrFunc(paramsValues,StimLevelsFine); %得到拟合曲线
plot(StimLevels, RightRate, 'k.', 'markersize', 30); %绘制原始数据
axis([86.5 93.5 0 1]); %调整坐标范围
hold on; %关闭覆盖模式
plot(StimLevelsFine, FitData, 'g-', 'LineWidth', 3); %绘制拟合曲线
xlabel('Line orientation (deg)');
ylabel('Probability of choosing "right"');