function getKeypress2

WaitSecs(0.5);
startTime = GetSecs();
keyIsDown = 0;

%����ʾ���ڲ����ó��Եı�����ɫ
Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
bgColor = 255;
Screen('FillRect',wPtr,bgColor);
Screen('Flip',wPtr);
increment = -1;

while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    
    %�ı䱳����ɫ
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