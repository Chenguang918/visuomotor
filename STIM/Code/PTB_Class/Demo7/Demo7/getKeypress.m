function getKeypress

WaitSecs(0.5);
startTime = GetSecs();
keyIsDown = 0;

while ~keyIsDown
    [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1);
end

pressedKey = KbName(find(keyCode));
reactionTime = pressedSecs - startTime;

fprintf('\nKey %s was pressed at %.4f seconds\n\n',pressedKey,reactionTime);

end