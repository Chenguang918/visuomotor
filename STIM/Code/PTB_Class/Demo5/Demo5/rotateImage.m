function rotateImage()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    faceData = imread('Lena.jpg'); %��ȡͼƬ
    faceTexture = Screen('MakeTexture',wPtr,faceData); %��������
    
    Screen('DrawTexture',wPtr,faceTexture); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
    
    KbWait();
    
    %��תͼƬ
    angle = 0; %��ʼ�Ƕ�
    tStart = GetSecs(); %�õ���ʼ���ֵ�ʱ��
    while GetSecs < tStart + 10;
        Screen('DrawTexture',wPtr,faceTexture,[],[],angle); %��ͼƬ���������back buffer��
        Screen('Flip',wPtr); %��ʾͼƬ
        angle = angle + 1; %ÿһ��frame���Ƕ�����1��
    end
    clear Screen;
end