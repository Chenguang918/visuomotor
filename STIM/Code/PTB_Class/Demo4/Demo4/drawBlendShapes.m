Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能

color1 = [0 255 0 255]; %定义包含不透明度的颜色1
color2 = [0 0 255 100]; %定义包含不透明度的颜色2

Screen('FillRect',wPtr,color1,[300 300 400 400]); %使用color1绘制矩形1
Screen('FillRect',wPtr,color2,[350 350 450 450]); %使用color2绘制矩形2
Screen('Flip',wPtr); %翻转buffer，显示图形

KbWait(); %等待按键

clear Screen; %关闭窗口