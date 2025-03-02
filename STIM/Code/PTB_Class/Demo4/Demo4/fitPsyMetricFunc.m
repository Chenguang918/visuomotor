StimLevels = [0.01 0.03 0.05 0.07 0.09 0.11]; %设置刺激条件
numCorrectTrial = [45 55 72 85 91 100]; %正确的trial数
numStimTrial = [100 100 100 100 100 100]; %总trial数
PsyMetrFunc = @PAL_Logistic; %得到函数句柄
paramsValues = [0.05 50 .5 0]; %拟合使用的起始值
paramsFree = [1 1 0 0]; %拟合中可以随意变化的参数
[paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels, numCorrectTrial, numStimTrial, paramsValues, paramsFree, PsyMetrFunc)

CorrectRate = numCorrectTrial./numStimTrial; %得到行为正确率
StimLevelsFine = [min(StimLevels):(max(StimLevels)-min(StimLevels))./1000:max(StimLevels)]; %获得高精度的x值
FitData = PsyMetrFunc(paramsValues,StimLevelsFine); %得到拟合曲线
plot(StimLevels, CorrectRate, 'k.', 'markersize', 40); %绘制原始数据
axis([0 0.12 0.4 1]); %调整坐标范围
hold on; %关闭覆盖模式
plot(StimLevelsFine, FitData, 'g-', 'LineWidth', 3); %绘制拟合曲线
