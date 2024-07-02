function rotateImage()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %打开显示窗口
    
    faceData = imread('Lena.jpg'); %读取图片
    faceTexture = Screen('MakeTexture',wPtr,faceData); %生成纹理
    
    Screen('DrawTexture',wPtr,faceTexture); %将图片纹理绘制在back buffer上
    Screen('Flip',wPtr); %显示图片
    
    KbWait();
    
    %旋转图片
    angle = 0; %初始角度
    tStart = GetSecs(); %得到开始呈现的时间
    while GetSecs < tStart + 10;
        Screen('DrawTexture',wPtr,faceTexture,[],[],angle); %将图片纹理绘制在back buffer上
        Screen('Flip',wPtr); %显示图片
        angle = angle + 1; %每一个frame将角度增加1度
    end
    clear Screen;
end