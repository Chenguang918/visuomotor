function getKeypress3
%呈现一个刺激，并在刺激呈现的时间范围内记录反应时

WaitSecs(0.5);
keyIsDown = 0;
stimDuration = 5;

%打开显示窗口
Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口

%读取图片，创建纹理并绘制
imData = imread('Lena.jpg');
imTexture = Screen('MakeTexture',wPtr,imData);
Screen('DrawTexture',wPtr,imTexture);
stimTime = Screen('Flip', wPtr);

while GetSecs() <= stimTime + stimDuration;
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        responseKey = KbName(find(keyCode));
        responseTime = pressedSecs-stimTime;
    end
end

%空屏5秒，此时不再记录反应
Screen('Flip',wPtr);
WaitSecs(5);

fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen;

end