function drawSomething2()
    %��ע��ô���Ϊ��ʱ������ʾ�����룬��������ȷ��"Flip"ʹ�÷���
    
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    Screen('FillRect', wPtr, [255 0 0],[100 100 500 500]);      %��back buffer�ϻ��ƾ���
    Screen('Flip',wPtr);                                        %����ǰ��buffer
    WaitSecs(5);                                                %�ȴ�5��
    
    Screen('Flip',wPtr);                                        %����ǰ��buffer�������Ļ
    WaitSecs(5);                                                %�ȴ�5��
    
    Screen('FillRect', wPtr, [0 255 0],[200 200 600 600]);      %��back buffer�ϻ��ƾ���
    Screen('Flip',wPtr);                                        %����ǰ��buffer
    WaitSecs(5);                                                %�ȴ�5��
    
    clear Screen;

end
