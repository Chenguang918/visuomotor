Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

Screen('TextFont',wPtr,'TimesNewRoman'); %设置字体
Screen('TextSize',wPtr,48); %设置字号
Screen('TextStyle',wPtr,1+2); %设置风格，但对中文字体支持不好
Screen('DrawText',wPtr,'Hello world!',100,100,[200 0 0]); %绘制文字

Screen('TextFont',wPtr,'Simhei'); %设置字体，注意此时如果要显示中文需使用中文字体
Screen('TextSize',wPtr,48); %设置字号
Screen('DrawText',wPtr,double('大家好!'),100,200,[0 200 0]); %绘制文字，为了解决中文显示的兼容性问题，此处将文字转换成double

DrawFormattedText(wPtr, 'Hello PTB! ','right',100,[0 0 200]);
 
Screen('Flip',wPtr); %显示文字

KbWait();
clear Screen;  