function mousePursuit

Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
ovalRect = [0 0 100 100]; %设置圆大小
keyIsDown = 0;

while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if strcmp(KbName(find(keyCode)), 'esc' ) %按esc退出
        break;
    end
    
    [x,y] = GetMouse(); %得到鼠标位置
    ovalRect = CenterRectOnPoint(ovalRect,x,y); %将椭圆中心对准鼠标位置
    Screen('FillOval',wPtr,[255 0 0],ovalRect);
    Screen('Flip',wPtr);
end

clear Screen;

end

