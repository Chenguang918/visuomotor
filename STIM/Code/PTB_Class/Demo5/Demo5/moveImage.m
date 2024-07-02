function moveImage()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    faceData = imread('Lena.jpg'); %��ȡͼƬ
    faceTexture = Screen('MakeTexture',wPtr,faceData); %��������
    
    %�õ�ͼƬ��С,ע���ʱ�����������ͼƬ�ĸ߶�
    [imageHeight, imageWidth, colorChannels] = size(faceData);
    imageRect = [0 0 imageWidth imageHeight]; %����ͼƬ����
    
    Screen('DrawTexture',wPtr,faceTexture,[],imageRect); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
    
    KbWait();
    
    %�����µ�ͼƬλ��
    xOffset = 50;
    yOffset = 100;
    imageRect = [xOffset yOffset xOffset+imageWidth yOffset+imageHeight];
    
    Screen('DrawTexture',wPtr,faceTexture,[],imageRect); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
     
    WaitSecs(1);
    KbWait();
    clear Screen;
end