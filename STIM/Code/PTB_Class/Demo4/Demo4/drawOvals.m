Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

myRect = [200 200 800 600]; %�������

Screen('FillRect',wPtr,[0 0 255],myRect); %��back buffer���ƾ���
Screen('FillOval',wPtr,[255 0 0],myRect); %��back bufferͬһλ�û�����Բ
Screen('FrameRect',wPtr,[0 255 0],myRect,10); %��back bufferͬһλ�û��ƾ������
                                              %penWidth 10pixel
Screen('Flip',wPtr); %��תbuffer

KbWait(); %�ȴ�����

clear Screen; %�رմ���