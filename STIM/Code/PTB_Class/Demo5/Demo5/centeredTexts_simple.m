Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

myText = 'Hello world!';

DrawFormattedText(wPtr, myText,'center','center',0);
Screen('Flip',wPtr);

KbWait();
clear Screen;