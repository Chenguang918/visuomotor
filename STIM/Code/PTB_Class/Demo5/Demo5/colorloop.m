function colorloop()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    %�趨��ɫ��ʼֵ
    r = 0;
    g = 0;
    b = 0;
    
    %�趨��ʾ���ε�λ��
    square = [100 100 400 400];
    
    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    tStart = GetSecs(); %��¼��ʼ��ʱ��
    while GetSecs() < tStart + 10
        Screen('FillRect', wPtr, [r g b], square); %��back buffer�ϻ��ƾ���
        Screen('Flip',wPtr); %��ʾ����
        
        %���Ĵ̼�����
        r = r + 1; %���ϱ��
        if r > 255
            r = 0;
        end
        square = square+1; %�������ƶ�
        if max(square) > 700
            square = [100 100 400 400];
        end
    end
    clear Screen;
end
