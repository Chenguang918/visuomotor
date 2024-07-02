function playSound()
    %初始化PsychSound
    InitializePsychSound;
    
    %读取声音文件
    strWaveFileName = 'funk.wav';
    [soundData, freq] = audioread(strWaveFileName);
    
    %将声音数据变成列向量和立体声
    soundData = soundData';
    soundData = [soundData; soundData];
    numChannels = 2; %两声道
    
    %打开音频播放驱动
    paPtr = PsychPortAudio('Open',[],[],0,freq,numChannels);
    
    %将音频数据送入播放buffer
    PsychPortAudio('FillBuffer', paPtr, soundData);
    
    %计时并开始播放
    tStart = GetSecs();%得到运行前时间
    tWait = 1;
    tPlayStart = PsychPortAudio('Start',paPtr,[],tStart+tWait,1);
    fprintf('播放延迟%.4f秒\n',tPlayStart-tStart-tWait);
    KbWait();
    PsychPortAudio('Close', paPtr);
end