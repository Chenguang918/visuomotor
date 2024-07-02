function drawSomething()
%     Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    Screen('FillRect', wPtr, [255 0 0],[100 100 500 500]);      %在back buffer上绘制矩形
    Screen('Flip',wPtr);                                        %交换前后buffer
    KbWait();                                                   %等待按键
    
    clear Screen;

end
