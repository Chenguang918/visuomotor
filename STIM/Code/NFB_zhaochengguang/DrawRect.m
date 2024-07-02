function DrawRect( wPtr, Locx, Locy, StimLength, color)
    x=20*(rand(1,10)-0.5); %生成一列 -10到10的随机数
    dif=fix(x(1));         %对这列数的第一个取整
    leftbottom=[Locx+dif,Locy+dif];
    righttop=[Locx+dif+StimLength,Locy+dif+StimLength];    
    rect=[leftbottom,righttop]';
    Screen('FillRect', wPtr, color, rect);
end