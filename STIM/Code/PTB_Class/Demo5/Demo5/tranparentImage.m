function transparentImage()
    Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %��͸���Ȼ�Ϲ���
    
    faceData = imread('Lena.jpg'); %��ȡͼƬ
    faceTexture = Screen('MakeTexture',wPtr,faceData); %��������
    gaborData = imread('Gabor.png'); %��ȡͼƬ
    gaborTexture = Screen('MakeTexture',wPtr,gaborData); %��������
    
    Screen('DrawTexture',wPtr,faceTexture); %����ͼƬ1
    Screen('DrawTexture',wPtr,gaborTexture,[],[],[],[],0.5 ); %���ư�͸��ͼƬ2
    Screen('Flip',wPtr); %��ʾͼƬ
    
    KbWait();
    clear Screen;
end