function getKeypress5
%����һ���̼������ڴ̼����ֵ�ʱ�䷶Χ�ںʹ̼���ʧ���¼��Ӧʱ

WaitSecs(0.5);
keyIsDown = 0;
stimDuration = 3;
responseDuration = 6;
%����ʾ����
Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
slack = Screen('GetFlipInterval',wPtr)/2; %�õ�ÿһ֡ʱ���һ��
%��ȡͼƬ��������������
imData = imread('Lena.jpg');
imTexture = Screen('MakeTexture',wPtr,imData);
Screen('DrawTexture',wPtr,imTexture);
%�������в���ʼ��Ӧ
ListenChar(0);%�ر�GetChar�ļ��������ͻ
KbQueueCreate();
KbQueueStart();
%��ʾͼƬ
stimTime = Screen('Flip', wPtr);
bFlipped = 0; %��¼�Ƿ�ת��
while GetSecs() <= stimTime + responseDuration;
    if (GetSecs - stimTime >= stimDuration-slack) && ~bFlipped %�˴���ֻ֤��תһ��
        Screen('Flip',wPtr);
        bFlipped = 1;
    end
end
KbQueueStop();%ֹͣ��Ӧ
[ pressed, firstPress]=KbQueueCheck();%�õ�������Ϣ
KbQueueRelease();%ɾ������
if pressed
    responseTime = firstPress(find(firstPress))-stimTime;
    responseKey = KbName(min(find(firstPress)));
end
fprintf('\nKey %s was pressed at %.4f seconds\n\n',responseKey,responseTime);
clear Screen;

end