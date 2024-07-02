function moveImage()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    
    faceData = imread('Lena.jpg'); %读取图片
    faceTexture = Screen('MakeTexture',wPtr,faceData); %生成纹理
    
    %得到图片大小,注意此时矩阵的行数是图片的高度
    [imageHeight, imageWidth, colorChannels] = size(faceData);
    imageRect = [0 0 imageWidth imageHeight]; %定义图片矩形
    
    Screen('DrawTexture',wPtr,faceTexture,[],imageRect); %将图片纹理绘制在back buffer上
    Screen('Flip',wPtr); %显示图片
    
    KbWait();
    
    %设置新的图片位置
    xOffset = 50;
    yOffset = 100;
    imageRect = [xOffset yOffset xOffset+imageWidth yOffset+imageHeight];
    
    Screen('DrawTexture',wPtr,faceTexture,[],imageRect); %将图片纹理绘制在back buffer上
    Screen('Flip',wPtr); %显示图片
     
    WaitSecs(1);
    KbWait();
    clear Screen;
end