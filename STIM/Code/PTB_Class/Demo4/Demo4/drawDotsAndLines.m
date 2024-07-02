Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���(�������Ҫ)

[xCenter, yCenter] = WindowCenter(wPtr); %�õ���Ļ����
colors = [255 0 0; 0 255 0; 0 0 255]; %����3�������ɫ
locations = [-100 0 100; 50 0 100]; %����3�����λ��
sizes = [10 15 20]; %����3����Ĵ�С
Screen('DrawDots',wPtr,locations, sizes, colors, [xCenter,yCenter], 2); %����Ļ�ϻ������Բ��

lines = [-100 0 0 100; 50 0 0 100]; %����2���ߵ���ʼ����ֹ��
colors = [255 0 0 0; 0 255 255 0; 0 0 0 255]; %����2���ߵ���ʼ����ֹ����ɫ
Screen('DrawLines',wPtr,lines,5,colors,[xCenter,yCenter],2); %����Ļ�ϻ�������߶�

Screen('Flip',wPtr); %��תbuffer����ʾͼ��

KbWait(); %�ȴ�����

clear Screen; %�رմ���