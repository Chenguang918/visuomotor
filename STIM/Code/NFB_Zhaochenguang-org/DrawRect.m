function DrawRect( wPtr, Locx, Locy, StimLength, color)
    x=20*(rand(1,10)-0.5); %����һ�� -10��10�������
    dif=fix(x(1));         %���������ĵ�һ��ȡ��
    leftbottom=[Locx+dif,Locy+dif];
    righttop=[Locx+dif+StimLength,Locy+dif+StimLength];    
    rect=[leftbottom,righttop]';
    Screen('FillRect', wPtr, color, rect);
end