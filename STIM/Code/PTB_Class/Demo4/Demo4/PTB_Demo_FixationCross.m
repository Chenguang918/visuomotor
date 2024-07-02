% 心理物理与Psychtoolbox编程演示程序
% 绘制十字注视点并精确控制呈现时间
% Coded by Y. Yan @ BNU 2018-03-26

%% 运行前准备部分
clear; %清除所有变量，避免上次运行的残留数据影响本次运行
clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
close all; %关闭所有figure，同样为避免运行结果和上次混淆
Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)

%% 参数设置部分
% 程序中需要用到的参数预先定义好，避免在程序内部出现数字常量
bSkipSyncTests = 1; %是否禁用垂直同步测试，正式实验时切勿禁用
nMonitorID = max(Screen('Screens')); %屏幕编号，注意此处MacOS和Windows不同
    %在使用多显示器时，修改此处数值可以控制刺激呈现的显示器。
    %只有在显示器直接连在主机上时有效（显示器设置成扩展桌面模式）。
    %通过分频器连接的多显示器被认为是同一个显示器
clrBg = [50 50 50]; %指定背景颜色
fFpCrossLength = 10; %注视点十字的长度
fFpCrossWidth = 3; %注视点十字线的粗细
clrFpCross = [0 255 0]; %指定注视点颜色
tFpDuration = 1.5; %注视点呈现的时间
tBlankDuration = 0.5; %空屏呈现的时间

%% 刺激呈现部分
% 此处用于开启或关闭垂直同步测试
Screen('Preference','SkipSyncTests',bSkipSyncTests);

% 初始化屏幕并得到屏幕参数
wPtr  = Screen('OpenWindow',nMonitorID, clrBg); %在指定的显示器打开刺激窗口
Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
[xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半

% 计算注视点十字横线和竖线的起始和结束位置
ptsCrossLines = [-fFpCrossLength fFpCrossLength 0 0; 0 0 -fFpCrossLength fFpCrossLength];
Screen('DrawLines', wPtr, ptsCrossLines, fFpCrossWidth, clrFpCross,[xCenter,yCenter],2); %在屏幕上画反锯齿线段

% 等待按键开始呈现注视点
KbWait(); 
tFpOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
tFpOffset = Screen('Flip', wPtr, tFpOnset + tFpDuration - slack);
tRealDuration = tFpOffset - tFpOnset
Screen('Flip', wPtr, tFpOffset + tBlankDuration - slack);
Screen('CloseAll');