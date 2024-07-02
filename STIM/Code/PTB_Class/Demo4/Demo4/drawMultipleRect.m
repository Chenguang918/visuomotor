Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

rectOne = [100 100 250 400]; %定义矩形1
rectTwo = [250 400 300 450]; %定义矩形2
bothRects = [rectOne', rectTwo'] %将两个矩形拼接成矩阵（每列1个）

Screen('FillRect',wPtr,[0 255 0],bothRects); %在back buffer绘制2个矩形
Screen('Flip',wPtr); %翻转buffer

KbWait(); %等待按键

clear Screen; %关闭窗口