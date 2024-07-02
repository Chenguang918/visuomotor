function colorloop()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    %设定颜色初始值
    r = 0;
    g = 0;
    b = 0;
    
    %设定显示矩形的位置
    square = [100 100 400 400];
    
    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    
    tStart = GetSecs(); %记录初始的时间
    while GetSecs() < tStart + 10
        Screen('FillRect', wPtr, [r g b], square); %在back buffer上绘制矩形
        Screen('Flip',wPtr); %显示矩形
        
        %更改刺激参数
        r = r + 1; %不断变红
        if r > 255
            r = 0;
        end
        square = square+1; %向右下移动
        if max(square) > 700
            square = [100 100 400 400];
        end
    end
    clear Screen;
end
