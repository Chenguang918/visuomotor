function showParagraph()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

    fidDoc = fopen('DemoDoc.txt'); %���ı��ļ�
    myText = fgetl(fidDoc); %��ȡ����
    fclose(fidDoc); %�ر��ļ�
    
    textColor = 20; %���ɫ
    wrapAt = 50; %����ÿ�ж����ַ�

    Screen('TextFont',wPtr,'Arial'); %��������
    Screen('TextSize',wPtr,32); %�����ֺ�
    DrawFormattedText(wPtr, myText,100,100,textColor, wrapAt); %�������� 
%     DrawFormattedText(wPtr, myText,100,100,textColor,wrapAt,[],[],1,1 ); %��ת���ַ���
    Screen('Flip',wPtr); %��ʾ����

    KbWait();
    clear Screen;
end