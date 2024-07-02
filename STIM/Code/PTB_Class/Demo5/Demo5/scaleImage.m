function scaleImage()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    
    faceData = imread('Lena.jpg'); %读取图片
    faceTexture = Screen('MakeTexture',wPtr,faceData); %生成纹理
    
    %得到图片大小,注意此时矩阵的行数是图片的高度
    [imageHeight, imageWidth, colorChannels] = size(faceData);
    imageRect = [0 0 imageWidth imageHeight]; %定义图片矩形
    destinationRect = CenterRect(imageRect,rect); %居中对齐
    Screen('DrawTexture',wPtr,faceTexture,[],destinationRect); %将图片纹理绘制在back buffer上
    Screen('Flip',wPtr); %显示图片
    
    KbWait();
    
    %将图片缩小一半
    imageRect = imageRect./2;
    destinationRect = CenterRect(imageRect,rect); %居中对齐
    
    Screen('DrawTexture',wPtr,faceTexture,[],destinationRect); %将图片纹理绘制在back buffer上
    Screen('Flip',wPtr); %显示图片
    
    WaitSecs(1);
    KbWait();
    clear Screen;
end