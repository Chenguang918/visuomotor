function playMovie()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),0); %����ʾ���ڣ���������Ϊ��ɫ

    strMoviePath = 'c:\demo.mp4'; %����ʹ�þ���·����·���в���������
    soundVolume = 1; %������С��0-1�ɵ�
    
    movie = Screen('OpenMovie', wPtr, strMoviePath); %����Ƶ�ļ�
    Screen('PlayMovie', movie,1,0,soundVolume); %������Ƶ
    
    t = GetSecs();
    toTime = t+20;
    while t < toTime
        texture = Screen('GetMovieImage',wPtr,movie); 
        if texture <=0	
            break;
        end
        Screen('DrawTexture', wPtr, texture); %�����������back buffer��
%         if toTime-t < 10 %����10�����ʾһ����
%             Screen('DrawText',wPtr,'Insert some text',600,400,[0 200 0]); 
%         end
        t = Screen('Flip',wPtr); %��ʾͼƬ
        Screen('Close',texture); %��������ͷ���Դ
    end
    Screen('PlayMovie',movie,0);
    clear Screen;
end