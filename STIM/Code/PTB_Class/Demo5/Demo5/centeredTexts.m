Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
screenCenterX = rect(3)/2;
screenCenterY = rect(4)/2;

myText = double('Hello world, ��Һ�'); %Ϊ�˽��������ʾ�ļ��������⣬�˴�ת��Ϊdouble

Screen('TextFont',wPtr,'Simhei'); %�������壬ע���ʱ���Ҫ��ʾ������ʹ����������
Screen('TextSize',wPtr,48); %�����ֺ�
textRect = Screen('TextBounds',wPtr,myText); %�õ����ִ�С����
textWidth = textRect(3);
textHeight = textRect(4);
textX = screenCenterX - textWidth/2; %�������ϽǺ�����
textY = screenCenterY - textHeight/2; %�������Ͻ�������

Screen('DrawText',wPtr,myText,textX,textY,0); %��������
Screen('Flip',wPtr); %��ʾ����

KbWait();
clear Screen; 