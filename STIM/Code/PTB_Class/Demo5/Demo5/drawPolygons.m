 Screen('Preference','SkipSyncTests',1); %���Գ����ʱ����Թرմ�ֱͬ������

[wPtr, rect] = Screen('OpenWindow',max(Screen('Screens'))); %����ʾ����

polygonConvex = [100 300 450 300 100;...
                 100 100 200 300 300]; %����͹�����
polygonConcave = [100 300 150 300 100;...
                  600 600 700 800 800]; %���尼�����

fprintf('����͹�����');
tic
Screen('FillPoly',wPtr,[255 0 0],polygonConvex',1);
toc
fprintf('���ư������');
tic
Screen('FillPoly',wPtr,[0 255 0],polygonConcave',0);
% Screen('FillPoly',wPtr,[0 255 0],polygonConcave',1); %���������͹ģʽ�����쳣
toc
Screen('Flip',wPtr); %��תbuffer

KbWait(); %�ȴ�����

clear Screen; %�رմ���