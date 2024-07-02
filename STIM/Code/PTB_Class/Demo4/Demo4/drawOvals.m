Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

myRect = [200 200 800 600]; %定义矩形

Screen('FillRect',wPtr,[0 0 255],myRect); %在back buffer绘制矩形
Screen('FillOval',wPtr,[255 0 0],myRect); %在back buffer同一位置绘制椭圆
Screen('FrameRect',wPtr,[0 255 0],myRect,10); %在back buffer同一位置绘制矩形外框
                                              %penWidth 10pixel
Screen('Flip',wPtr); %翻转buffer

KbWait(); %等待按键

clear Screen; %关闭窗口