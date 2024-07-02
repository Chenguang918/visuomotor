function showParagraph()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

    fidDoc = fopen('DemoDoc.txt'); %打开文本文件
    myText = fgetl(fidDoc); %读取内容
    fclose(fidDoc); %关闭文件
    
    textColor = 20; %深灰色
    wrapAt = 50; %定义每行多少字符

    Screen('TextFont',wPtr,'Arial'); %设置字体
    Screen('TextSize',wPtr,32); %设置字号
    DrawFormattedText(wPtr, myText,100,100,textColor, wrapAt); %绘制文字 
%     DrawFormattedText(wPtr, myText,100,100,textColor,wrapAt,[],[],1,1 ); %翻转文字方向
    Screen('Flip',wPtr); %显示文字

    KbWait();
    clear Screen;
end