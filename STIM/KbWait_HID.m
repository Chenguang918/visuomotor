% keep touch trigger
% devices = PsychHID('Devices',numberOfDevices);   % check information
while 1
    [keyIsDown] = PsychHID('KbCheck',2); 
    if keyIsDown
        break
    end
end