function drawSomething2()
    %请注意该代码为计时函数的示例代码，并不是正确的"Flip"使用方法
    
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    
    Screen('FillRect', wPtr, [255 0 0],[100 100 500 500]);      %在back buffer上绘制矩形
    Screen('Flip',wPtr);                                        %交换前后buffer
    WaitSecs(5);                                                %等待5秒
    
    Screen('Flip',wPtr);                                        %交换前后buffer，清空屏幕
    WaitSecs(5);                                                %等待5秒
    
    Screen('FillRect', wPtr, [0 255 0],[200 200 600 600]);      %在back buffer上绘制矩形
    Screen('Flip',wPtr);                                        %交换前后buffer
    WaitSecs(5);                                                %等待5秒
    
    clear Screen;

end
