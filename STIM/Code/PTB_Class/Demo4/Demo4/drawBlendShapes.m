Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���

color1 = [0 255 0 255]; %���������͸���ȵ���ɫ1
color2 = [0 0 255 100]; %���������͸���ȵ���ɫ2

Screen('FillRect',wPtr,color1,[300 300 400 400]); %ʹ��color1���ƾ���1
Screen('FillRect',wPtr,color2,[350 350 450 450]); %ʹ��color2���ƾ���2
Screen('Flip',wPtr); %��תbuffer����ʾͼ��

KbWait(); %�ȴ�����

clear Screen; %�رմ���