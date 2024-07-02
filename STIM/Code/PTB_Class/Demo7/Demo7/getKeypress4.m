function getKeypress4
%����һ���̼������ڴ̼����ֵ�ʱ�䷶Χ�ںʹ̼���ʧ���¼��Ӧʱ

WaitSecs(0.5);
keyIsDown = 0;
stimDuration = 5;
responseDuration = 10;

%����ʾ����
Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

%��ȡͼƬ��������������
imData = imread('Lena.jpg');
imTexture = Screen('MakeTexture',wPtr,imData);
Screen('DrawTexture',wPtr,imTexture);
stimTime = Screen('Flip', wPtr);
bFlipped = 0; %��¼�Ƿ�ת��
while GetSecs() <= stimTime + responseDuration;
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        responseKey = KbName(find(keyCode));
        responseTime = pressedSecs-stimTime;
    end
    if (GetSecs - stimTime >= stimDuration) && ~bFlipped %�˴���ֻ֤��תһ��
        Screen('Flip',wPtr);
        bFlipped = 1;
    end
end

fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen;

end