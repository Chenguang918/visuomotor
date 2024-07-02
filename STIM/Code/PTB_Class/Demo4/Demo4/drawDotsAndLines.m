Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)

[xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
colors = [255 0 0; 0 255 0; 0 0 255]; %定义3个点的颜色
locations = [-100 0 100; 50 0 100]; %定义3个点的位置
sizes = [10 15 20]; %定义3个点的大小
Screen('DrawDots',wPtr,locations, sizes, colors, [xCenter,yCenter], 2); %在屏幕上画反锯齿圆点

lines = [-100 0 0 100; 50 0 0 100]; %定义2条线的起始和终止点
colors = [255 0 0 0; 0 255 255 0; 0 0 0 255]; %定义2条线的起始和终止点颜色
Screen('DrawLines',wPtr,lines,5,colors,[xCenter,yCenter],2); %在屏幕上画反锯齿线段

Screen('Flip',wPtr); %翻转buffer，显示图形

KbWait(); %等待按键

clear Screen; %关闭窗口