function scaleImage()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    
    faceData = imread('Lena.jpg'); %��ȡͼƬ
    faceTexture = Screen('MakeTexture',wPtr,faceData); %��������
    
    %�õ�ͼƬ��С,ע���ʱ�����������ͼƬ�ĸ߶�
    [imageHeight, imageWidth, colorChannels] = size(faceData);
    imageRect = [0 0 imageWidth imageHeight]; %����ͼƬ����
    destinationRect = CenterRect(imageRect,rect); %���ж���
    Screen('DrawTexture',wPtr,faceTexture,[],destinationRect); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
    
    KbWait();
    
    %��ͼƬ��Сһ��
    imageRect = imageRect./2;
    destinationRect = CenterRect(imageRect,rect); %���ж���
    
    Screen('DrawTexture',wPtr,faceTexture,[],destinationRect); %��ͼƬ���������back buffer��
    Screen('Flip',wPtr); %��ʾͼƬ
    
    WaitSecs(1);
    KbWait();
    clear Screen;
end