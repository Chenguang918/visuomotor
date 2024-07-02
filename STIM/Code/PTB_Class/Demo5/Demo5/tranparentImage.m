function transparentImage()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能
    
    faceData = imread('Lena.jpg'); %读取图片
    faceTexture = Screen('MakeTexture',wPtr,faceData); %生成纹理
    gaborData = imread('Gabor.png'); %读取图片
    gaborTexture = Screen('MakeTexture',wPtr,gaborData); %生成纹理
    
    Screen('DrawTexture',wPtr,faceTexture); %绘制图片1
    Screen('DrawTexture',wPtr,gaborTexture,[],[],[],[],0.5 ); %绘制半透明图片2
    Screen('Flip',wPtr); %显示图片
    
    KbWait();
    clear Screen;
end