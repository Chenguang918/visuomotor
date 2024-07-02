function getKeypress3
%����һ���̼������ڴ̼����ֵ�ʱ�䷶Χ�ڼ�¼��Ӧʱ

WaitSecs(0.5);
keyIsDown = 0;
stimDuration = 5;

%����ʾ����
Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

%��ȡͼƬ��������������
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

%����5�룬��ʱ���ټ�¼��Ӧ
Screen('Flip',wPtr);
WaitSecs(5);

fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen;

end