Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

screenWidth = rect(3); %屏幕宽度
screenHeight = rect(4); %屏幕高度
screenCenterX = screenWidth/2; %X方向的中心是屏幕宽度的一半
screenCenterY = screenHeight/2; %Y方向的中心是屏幕高度的一半
% 以上四句的效果等同于下面一句：
% [screenCenterX, screenCenterY] = WindowCenter(wPtr);

myRectWidth = 100;
myRectHeight = 100;

myRectLeft = screenCenterX - myRectWidth/2; %计算左上角的X坐标
myRectTop = screenCenterY - myRectHeight/2; %计算左上角的Y坐标
myRectRight = myRectLeft + myRectWidth; %计算右下角的X坐标
myRectBottom = myRectTop + myRectHeight; %计算右下角的Y坐标
myRect = [myRectLeft, myRectTop, myRectRight, myRectBottom]; %将坐标拼成rect向量
% 以上五句的效果等同于下面一句：
% myRect = CenterRectOnPoint([0 0 myRectWidth myRectHeight],screenCenterX,screenCenterY);

Screen('FillRect',wPtr,[0 0 255],myRect); %在back buffer绘制生成的矩形
Screen('Flip',wPtr); %翻转buffer

KbWait(); %等待按键

clear Screen; %关闭窗口