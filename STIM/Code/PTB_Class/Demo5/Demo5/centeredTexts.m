Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
screenCenterX = rect(3)/2;
screenCenterY = rect(4)/2;

myText = double('Hello world, 大家好'); %为了解决中文显示的兼容性问题，此处转换为double

Screen('TextFont',wPtr,'Simhei'); %设置字体，注意此时如果要显示中文需使用中文字体
Screen('TextSize',wPtr,48); %设置字号
textRect = Screen('TextBounds',wPtr,myText); %得到文字大小矩阵
textWidth = textRect(3);
textHeight = textRect(4);
textX = screenCenterX - textWidth/2; %计算左上角横坐标
textY = screenCenterY - textHeight/2; %计算左上角纵坐标

Screen('DrawText',wPtr,myText,textX,textY,0); %绘制文字
Screen('Flip',wPtr); %显示文字

KbWait();
clear Screen; 