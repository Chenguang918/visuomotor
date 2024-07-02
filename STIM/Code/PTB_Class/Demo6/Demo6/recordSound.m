function audioData = recordSound()
    %初始化PsychSound
    InitializePsychSound;
    duration = 5;

    %使用mode 2打开音频通道
    freq = 48000;
    paPtr = PsychPortAudio('Open',[],2,0,freq,2);
    
    %设置用于缓存声音数据的buffer
    PsychPortAudio('GetAudioData', paPtr, duration);
    
    %开始录音
    PsychPortAudio('Start',paPtr, 0, 0, 1);
    
    fprintf('录音中...\n')
    WaitSecs(duration);
    fprintf('录音结束\n')

    %停止录音
    PsychPortAudio('Stop',paPtr);
    
    %得到声音数据
    audioData = PsychPortAudio('GetAudioData', paPtr);
    
    %关闭音频通道
    PsychPortAudio('Close', paPtr);
end