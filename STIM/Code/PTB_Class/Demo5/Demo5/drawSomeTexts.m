Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

Screen('TextFont',wPtr,'TimesNewRoman'); %��������
Screen('TextSize',wPtr,48); %�����ֺ�
Screen('TextStyle',wPtr,1+2); %���÷�񣬵�����������֧�ֲ���
Screen('DrawText',wPtr,'Hello world!',100,100,[200 0 0]); %��������

Screen('TextFont',wPtr,'Simhei'); %�������壬ע���ʱ���Ҫ��ʾ������ʹ����������
Screen('TextSize',wPtr,48); %�����ֺ�
Screen('DrawText',wPtr,double('��Һ�!'),100,200,[0 200 0]); %�������֣�Ϊ�˽��������ʾ�ļ��������⣬�˴�������ת����double

DrawFormattedText(wPtr, 'Hello PTB! ','right',100,[0 0 200]);
 
Screen('Flip',wPtr); %��ʾ����

KbWait();
clear Screen;  