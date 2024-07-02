function getKeypress2

WaitSecs(0.5);
startTime = GetSecs();
keyIsDown = 0;

%打开显示窗口并设置初试的背景颜色
Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
bgColor = 255;
Screen('FillRect',wPtr,bgColor);
Screen('Flip',wPtr);
increment = -1;

while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    
    %改变背景颜色
    bgColor = bgColor + increment;
    if bgColor<= 0 || bgColor>=255
        increment = -increment;
    end
    Screen('FillRect',wPtr,bgColor);
    Screen('Flip',wPtr);
end
clear Screen;

pressedKey = KbName(find(keyCode));
reactionTime = pressedSecs - startTime;
fprintf('\nKey %s was pressed at %.4f seconds\n\n',pressedKey,reactionTime);

end