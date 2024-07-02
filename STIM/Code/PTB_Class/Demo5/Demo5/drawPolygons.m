 Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

polygonConvex = [100 300 450 300 100;...
                 100 100 200 300 300]; %定义凸多边形
polygonConcave = [100 300 150 300 100;...
                  600 600 700 800 800]; %定义凹多边形

fprintf('绘制凸多边形');
tic
Screen('FillPoly',wPtr,[255 0 0],polygonConvex',1);
toc
fprintf('绘制凹多边形');
tic
Screen('FillPoly',wPtr,[0 255 0],polygonConcave',0);
% Screen('FillPoly',wPtr,[0 255 0],polygonConcave',1); %凹多边形用凸模式绘制异常
toc
Screen('Flip',wPtr); %翻转buffer

KbWait(); %等待按键

clear Screen; %关闭窗口