%% ���ڻ���ע�ӵ���Ӻ���
function DrawCross(wPtr, x, y, length, width, color)
    ptsCrossLines = [-length length 0 0; 0 0 -length length];
    Screen('DrawLines', wPtr, ptsCrossLines, width, color,[x,y],2); %����Ļ�ϻ�������߶�
end

