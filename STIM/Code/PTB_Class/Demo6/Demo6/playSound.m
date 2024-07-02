function playSound()
    %��ʼ��PsychSound
    InitializePsychSound;
    
    %��ȡ�����ļ�
    strWaveFileName = 'funk.wav';
    [soundData, freq] = audioread(strWaveFileName);
    
    %���������ݱ����������������
    soundData = soundData';
    soundData = [soundData; soundData];
    numChannels = 2; %������
    
    %����Ƶ��������
    paPtr = PsychPortAudio('Open',[],[],0,freq,numChannels);
    
    %����Ƶ�������벥��buffer
    PsychPortAudio('FillBuffer', paPtr, soundData);
    
    %��ʱ����ʼ����
    tStart = GetSecs();%�õ�����ǰʱ��
    tWait = 1;
    tPlayStart = PsychPortAudio('Start',paPtr,[],tStart+tWait,1);
    fprintf('�����ӳ�%.4f��\n',tPlayStart-tStart-tWait);
    KbWait();
    PsychPortAudio('Close', paPtr);
end