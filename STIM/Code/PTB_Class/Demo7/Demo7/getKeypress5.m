function getKeypress5
%呈现一个刺激，并在刺激呈现的时间范围内和刺激消失后记录反应时

WaitSecs(0.5);
keyIsDown = 0;
stimDuration = 3;
responseDuration = 6;
%打开显示窗口
Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半
%读取图片，创建纹理并绘制
imData = imread('Lena.jpg');
imTexture = Screen('MakeTexture',wPtr,imData);
Screen('DrawTexture',wPtr,imTexture);
%创建队列并开始相应
ListenChar(0);%关闭GetChar的监听避免冲突
KbQueueCreate();
KbQueueStart();
%显示图片
stimTime = Screen('Flip', wPtr);
bFlipped = 0; %记录是否翻转过
while GetSecs() <= stimTime + responseDuration;
    if (GetSecs - stimTime >= stimDuration-slack) && ~bFlipped %此处保证只翻转一次
        Screen('Flip',wPtr);
        bFlipped = 1;
    end
end
KbQueueStop();%停止响应
[ pressed, firstPress]=KbQueueCheck();%得到按键信息
KbQueueRelease();%删除队列
if pressed
    responseTime = firstPress(find(firstPress))-stimTime;
    responseKey = KbName(min(find(firstPress)));
end
fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen;

end