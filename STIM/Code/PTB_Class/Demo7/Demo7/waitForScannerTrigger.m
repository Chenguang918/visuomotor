function waitForScannerTrigger
WaitSecs(0.5);
triggerCode = KbName('s');
keyIsDown = 0;
%确保没有按键被关闭
DisableKeysForKbCheck([]);
%等待trigger
while 1
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
    if keyIsDown
        if find(keyCode)==triggerCode
            break;
        end
    end
end
triggerTime = pressedSecs; %记录trigger时间
fprintf('Trigger detected\n');
%收到trigger后停止监听trigger按键
DisableKeysForKbCheck([triggerCode]);
%继续记录按键反应
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