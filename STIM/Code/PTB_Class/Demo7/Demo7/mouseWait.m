function mouseWait

buttons = 0;

while ~buttons
    [x,y,buttons] = GetMouse();
end

fprintf('You clicked button %d\n',find(buttons));

end

