function showPic()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    faceData = imread('Lena.jpg'); %��ȡͼƬ
    faceTexture = Screen('MakeTexture',wPtr,faceData); %��������
    Screen('DrawTexture',wPtr,faceTexture); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
    
    KbWait();
    clear Screen;
end