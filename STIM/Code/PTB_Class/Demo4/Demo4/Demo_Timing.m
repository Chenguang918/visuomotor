% 心理物理与Psychtoolbox编程演示程序
% 使用计时和时间控制函数
% Coded by Y. Yan @ BNU 2018-03-26

%% 使用计时函数
tStart = GetSecs(); %得到程序开始运行的时间

tic
WaitSecs(2); %等待2秒
toc

tic
WaitSecs('UntilTime',tStart+7); %等待至从tStart时刻之后的7秒（还剩5秒）
toc

%% 使用KbWait()
fprintf('请按键进行计时');
tStart = GetSecs(); %得到程序开始运行的时间
[secs, keyCode, deltaT] = KbWait(); %等待按键
tRespLatency = secs - tStart %得到按键的延迟（注意KbWait的精度只有5ms）
