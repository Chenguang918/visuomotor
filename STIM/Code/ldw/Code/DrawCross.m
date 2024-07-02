%% 用于绘制注视点的子函数
function DrawCross(wPtr, x, y, length, width, color)
    ptsCrossLines = [-length length 0 0; 0 0 -length length];
    Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %在屏幕上画反锯齿线段
end

