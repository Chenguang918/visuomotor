% ����������Psychtoolbox�����ʾ����
% ʹ�ü�ʱ��ʱ����ƺ���
% Coded by Y. Yan @ BNU 2018-03-26

%% ʹ�ü�ʱ����
tStart = GetSecs(); %�õ�����ʼ���е�ʱ��

tic
WaitSecs(2); %�ȴ�2��
toc

tic
WaitSecs('UntilTime',tStart+7); %�ȴ�����tStartʱ��֮���7�루��ʣ5�룩
toc

%% ʹ��KbWait()
fprintf('�밴�����м�ʱ');
tStart = GetSecs(); %�õ�����ʼ���е�ʱ��
[secs, keyCode, deltaT] = KbWait(); %�ȴ�����
tRespLatency = secs - tStart %�õ��������ӳ٣�ע��KbWait�ľ���ֻ��5ms��
