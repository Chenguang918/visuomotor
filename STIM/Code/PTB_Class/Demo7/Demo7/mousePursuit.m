function mousePursuit

Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������
[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����
ovalRect = [0 0 100 100]; %����Բ��С
keyIsDown = 0;

while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if strcmp(KbName(find(keyCode)), 'esc' ) %��esc�˳�
        break;
    end
    
    [x,y] = GetMouse(); %�õ����λ��
    ovalRect = CenterRectOnPoint(ovalRect,x,y); %����Բ���Ķ�׼���λ��
    Screen('FillOval',wPtr,[255 0 0],ovalRect);
    Screen('Flip',wPtr);
end

clear Screen;

end

