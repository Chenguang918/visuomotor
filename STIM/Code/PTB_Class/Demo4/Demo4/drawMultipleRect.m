Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

rectOne = [100 100 250 400]; %�������1
rectTwo = [250 400 300 450]; %�������2
bothRects = [rectOne', rectTwo'] %����������ƴ�ӳɾ���ÿ��1����

Screen('FillRect',wPtr,[0 255 0],bothRects); %��back buffer����2������
Screen('Flip',wPtr); %��תbuffer

KbWait(); %�ȴ�����

clear Screen; %�رմ���