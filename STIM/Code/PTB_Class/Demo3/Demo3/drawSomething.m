function drawSomething()
%     Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    Screen('FillRect', wPtr, [255 0 0],[100 100 500 500]);      %��back buffer�ϻ��ƾ���
    Screen('Flip',wPtr);                                        %����ǰ��buffer
    KbWait();                                                   %�ȴ�����
    
    clear Screen;

end
