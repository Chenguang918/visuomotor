Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

myText = 'Hello world!';

DrawFormattedText(wPtr, myText,'center','center',0);
Screen('Flip',wPtr);

KbWait();
clear Screen;