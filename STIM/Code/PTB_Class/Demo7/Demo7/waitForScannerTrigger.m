function waitForScannerTrigger
WaitSecs(0.5);
triggerCode = KbName('s');
keyIsDown = 0;
%ȷ��û�а������ر�
DisableKeysForKbCheck([]);
%�ȴ�trigger
while 1
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        if find(keyCode)==triggerCode
            break;
        end
    end
end
triggerTime = pressedSecs; %��¼triggerʱ��
fprintf('Trigger detected\n');
%�յ�trigger��ֹͣ����trigger����
DisableKeysForKbCheck([triggerCode]);
%������¼������Ӧ
WaitSecs(0.5);
fprintf('Waiting for response...\n');
keyIsDown = 0;
while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
end
pressedKey = KbName(find(keyCode));
reactionTime = pressedSecs - triggerTime;
fprintf('\nKey %s was pressed at %.4f seconds\n\n',pressedKey,reactionTime);
end