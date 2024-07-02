function IntroductionFly(w,rect,fontsize,font,background,center,gra)
% Load Introduction Images
%
actiontext='�밴ȷ�ϼ�������һ��';



% introduction
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background); 

% load background image 
M=imread('flyintro1.jpg');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, actiontext, 1500/960*center(1), 1000/540*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait_HID;%等待直到按键 

M=imread('flyintro2.jpg');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, actiontext, 1500/960*center(1), 1000/540*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait_HID;%等待直到按键 

M=imread('flyintro3.jpg');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, actiontext, 1500/960*center(1), 1000/540*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait_HID;%等待直到按键 




end


