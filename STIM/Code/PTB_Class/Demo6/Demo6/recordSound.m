function audioData = recordSound()
    %��ʼ��PsychSound
    InitializePsychSound;
    duration = 5;

    %ʹ��mode 2����Ƶͨ��
    freq = 48000;
    paPtr = PsychPortAudio('Open',[],2,0,freq,2);
    
    %�������ڻ����������ݵ�buffer
    PsychPortAudio('GetAudioData', paPtr, duration);
    
    %��ʼ¼��
    PsychPortAudio('Start',paPtr, 0, 0, 1);
    
    fprintf('¼����...\n')
    WaitSecs(duration);
    fprintf('¼������\n')

    %ֹͣ¼��
    PsychPortAudio('Stop',paPtr);
    
    %�õ���������
    audioData = PsychPortAudio('GetAudioData', paPtr);
    
    %�ر���Ƶͨ��
    PsychPortAudio('Close', paPtr);
end