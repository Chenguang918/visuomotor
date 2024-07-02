function Introduction(w,rect,fontsize,font,background,gra,center)
% Load Introduction Images
%
backgroundtext1 = '����ҹ��ݳ���ѧУȥ�����˹��ʻ���,';
backgroundtext2 = 'ȫ�̴�Լ70���ӣ���6�ο���ͣ����Ϣ��ÿ����Ϣ2���ӡ�';
backgroundtext3 = '�������������';


controltext1='ÿ����+������Χ����һȦ��ɫ��Բʱ��';  
controltext2='����������ִ�Ĵָ����1����';  

targettext1 = 'ÿ����+������Χ����һȦ����ɫ��Բʱ,';
targettext2 = '��Ѹ�ٲ�׼ȷ���жϻ�ɫԲ�������ĳ���';
targettext3 =  '��ֱ������1��; ˮƽ�� ����3��������ֱ��������ִ�Ĵָ���а�����';
% targettext4 = '����ֱ��������ִ�Ĵָ���а�����';
fixtext='�뱣��ע����Ļ���ĵġ�+����';


% % feedback
% subjectname= '����';
% score=2;
% leftscore=12-score;
% fine=30;
% scoretext = [num2str(leftscore) ,'��'];
% finetext =  ['-',num2str(fine) ,'Ԫ'];
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
% KbWait;%�ȴ�ֱ������ 

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
KbWait;%�ȴ�ֱ������ 

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
KbWait;%�ȴ�ֱ������ 


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
KbWait;%�ȴ�ֱ������ 
    
    
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
KbWait;%�ȴ�ֱ������ 



end
