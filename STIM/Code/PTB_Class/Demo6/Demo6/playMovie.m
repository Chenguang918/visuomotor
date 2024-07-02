function playMovie()
    Screen('Preference','SkipSyncTests',1); %调试程序的时候可以关闭垂直同步测试

    [wPtr, rect] = Screen('OpenWindow',max(Screen('Screens')),0); %打开显示窗口，将背景设为黑色

    strMoviePath = 'c:\demo.mp4'; %必须使用绝对路径，路径中不能有中文
    soundVolume = 1; %音量大小，0-1可调
    
    movie = Screen('OpenMovie', wPtr, strMoviePath); %打开视频文件
    Screen('PlayMovie', movie,1,0,soundVolume); %播放视频
    
    t = GetSecs();
    toTime = t+20;
    while t < toTime
        texture = Screen('GetMovieImage',wPtr,movie); 
        if texture <=0	
            break;
        end
        Screen('DrawTexture', wPtr, texture); %将纹理绘制在back buffer上
%         if toTime-t < 10 %播放10秒后显示一行字
%             Screen('DrawText',wPtr,'Insert some text',600,400,[0 200 0]); 
%         end
        t = Screen('Flip',wPtr); %显示图片
        Screen('Close',texture); %清除纹理，释放资源
    end
    Screen('PlayMovie',movie,0);
    clear Screen;
end