clear; clc;

Screen('Preference','SkipSyncTests',1);
nMonitorID = max(Screen('Screens'));
wPtr  = Screen('OpenWindow',nMonitorID);
Screen('TextFont', wPtr, 'Simhei');
WaitSecs(1);
ListenChar(2);
reply=Ask(wPtr,double('«Î ‰»Î–’√˚:'),[255 0 0],[],'GetChar',[100 100 400 300],'left');
ListenChar(0);
reply
Screen('CloseAll');