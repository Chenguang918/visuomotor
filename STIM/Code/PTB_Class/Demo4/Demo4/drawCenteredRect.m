Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

screenWidth = rect(3); %��Ļ���
screenHeight = rect(4); %��Ļ�߶�
screenCenterX = screenWidth/2; %X�������������Ļ��ȵ�һ��
screenCenterY = screenHeight/2; %Y�������������Ļ�߶ȵ�һ��
% �����ľ��Ч����ͬ������һ�䣺
% [screenCenterX, screenCenterY] = WindowCenter(wPtr);

myRectWidth = 100;
myRectHeight = 100;

myRectLeft = screenCenterX - myRectWidth/2; %�������Ͻǵ�X����
myRectTop = screenCenterY - myRectHeight/2; %�������Ͻǵ�Y����
myRectRight = myRectLeft + myRectWidth; %�������½ǵ�X����
myRectBottom = myRectTop + myRectHeight; %�������½ǵ�Y����
myRect = [myRectLeft, myRectTop, myRectRight, myRectBottom]; %������ƴ��rect����
% ��������Ч����ͬ������һ�䣺
% myRect = CenterRectOnPoint([0 0 myRectWidth myRectHeight],screenCenterX,screenCenterY);

Screen('FillRect',wPtr,[0 0 255],myRect); %��back buffer�������ɵľ���
Screen('Flip',wPtr); %��תbuffer

KbWait(); %�ȴ�����

clear Screen; %�رմ���