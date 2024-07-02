StimLevels = [0.01 0.03 0.05 0.07 0.09 0.11]; %���ô̼�����
numCorrectTrial = [45 55 72 85 91 100]; %��ȷ��trial��
numStimTrial = [100 100 100 100 100 100]; %��trial��
PsyMetrFunc = @PAL_Logistic; %�õ��������
paramsValues = [0.05 50 .5 0]; %���ʹ�õ���ʼֵ
paramsFree = [1 1 0 0]; %����п�������仯�Ĳ���
B = 1000; %����bootstrapping 1000��

%% ��������������
[paramsValues LL exitflag] = PAL_PFML_Fit(StimLevels, numCorrectTrial, numStimTrial, paramsValues, paramsFree, PsyMetrFunc)

%% ���Ƶõ����������
% ʹ�ò���������
[SDparam paramsSim LLSim converged] = PAL_PFML_BootstrapParametric(StimLevels, numStimTrial, paramsValues, paramsFree, B, PsyMetrFunc);
SDparam % ����������ʾSD��ֵ
% ʹ�÷ǲ�������
[SDnonparam paramsSim LLSim converged] = PAL_PFML_BootstrapNonParametric(StimLevels, numCorrectTrial, numStimTrial, paramsValues, paramsFree, B, PsyMetrFunc);
SDnonparam % ����������ʾSD��ֵ

%% ������ϵĺû��̶�
[Dev pDev DevSim converged] = PAL_PFML_GoodnessOfFit(StimLevels, numCorrectTrial, numStimTrial, paramsValues, paramsFree, B, PsyMetrFunc);
pDev % ����������ʾpDev��ֵ

CorrectRate = numCorrectTrial./numStimTrial; %�õ���Ϊ��ȷ��
StimLevelsFine = [min(StimLevels):(max(StimLevels)-min(StimLevels))./1000:max(StimLevels)]; %��ø߾��ȵ�xֵ
FitData = PsyMetrFunc(paramsValues,StimLevelsFine); %�õ��������
plot(StimLevels, CorrectRate, 'k.', 'markersize', 40); %����ԭʼ����
axis([0 0.12 0.4 1]); %�������귶Χ
hold on; %�رո���ģʽ
plot(StimLevelsFine, FitData, 'g-', 'LineWidth', 3); %�����������
