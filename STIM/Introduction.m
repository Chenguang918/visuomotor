function Introduction(w,rect,fontsize,font,background,gra,center)
% Load Introduction Images
%
backgroundtext1 = '你在夜晚驾车从学校去往大兴国际机场,';
backgroundtext2 = '全程大约70分钟，有6次可以停靠休息，每次休息2分钟。';
backgroundtext3 = '按任意键继续。';


controltext1='每当‘+’号周围出现一圈绿色的圆时。';  
controltext2='请快速用左手大拇指按‘1’。';  

targettext1 = '每当‘+’号周围出现一圈有颜色的圆时,';
targettext2 = '请迅速并准确地判断黄色圆中线条的朝向：';
targettext3 =  '竖直，按‘1’; 水平， 按‘3’。（请分别用左右手大拇指进行按键）';
% targettext4 = '（请分别用左右手大拇指进行按键）';
fixtext='请保持注视屏幕中心的‘+’号';


% % feedback
% subjectname= '老王';
% score=2;
% leftscore=12-score;
% fine=30;
% scoretext = [num2str(leftscore) ,'分'];
% finetext =  ['-',num2str(fine) ,'元'];
% Screen('TextSize', w ,fontsize);
% Screen('TextFont', w, font);
% M=imread('license.jpg ');
% GIndex=Screen('MakeTexture',w,M); 
% GRect=Screen('Rect',GIndex);
% cGRect=CenterRect(GRect,rect);
% Screen('DrawTexture',w,GIndex,GRect,cGRect);
% Screen('DrawText', w, subjectname, 6/4*center(1), 3/8*center(2), gra, background);
% Screen('DrawText', w, finetext, 6/4*center(1), 5/8*center(2), gra, background);
% Screen('DrawText', w, scoretext, 6/4*center(1), 7/8*center(2), gra, background);
% Screen('Flip', w);
% WaitSecs(2);
% KbWait;%等待直到按键 

% introduction
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background); 
% load background image 
M=imread('background.jpg');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, backgroundtext1, 2*center(1)/3, 2/8*center(2), gra);
Screen('DrawText', w, backgroundtext2, 2*center(1)/3, 3/8*center(2), gra);
Screen('DrawText', w, backgroundtext3, 2*center(1)/3, 4/8*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait;%等待直到按键 

Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background); 
% load background image
M=imread('Fix.jpg ');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, fixtext, 2*center(1)/3, 2/8*center(2), gra);
Screen('Flip', w);
WaitSecs(2);
KbWait;%等待直到按键 


Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background); 
% load background image
M=imread('Control.jpg ');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, controltext1, 2*center(1)/3, 1/8*center(2), gra);
Screen('DrawText', w, controltext2, 2*center(1)/3, 2/8*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait;%等待直到按键 
    
    
Screen('TextSize', w ,fontsize);
Screen('TextFont', w, font);
Screen('FillRect', w, background); 
% load background image
M=imread('Target.jpg ');
GIndex=Screen('MakeTexture',w,M); 
GRect=Screen('Rect',GIndex);
cGRect=CenterRect(GRect,rect);
Screen('DrawTexture',w,GIndex,GRect,cGRect);
Screen('DrawText', w, targettext1, 2*center(1)/3, 1/8*center(2), gra);
Screen('DrawText', w, targettext2, 2*center(1)/3, 2/8*center(2), gra);
Screen('DrawText', w, targettext3, 2*center(1)/3, 3/8*center(2), gra);
% Screen('DrawText', w, targettext4, 2*center(1)/3, 4/8*center(2), gra);

Screen('Flip', w);
WaitSecs(2);
KbWait;%等待直到按键 



end
