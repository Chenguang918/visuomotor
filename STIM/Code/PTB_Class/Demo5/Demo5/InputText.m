clear; clc;

Screen('Preference','SkipSyncTests',1);
nMonitorID = max(Screen('Screens'));
wPtr  = Screen('OpenWindow',nMonitorID);
Screen('TextFont', wPtr, 'Simsun');
WaitSecs(2);
str = GetEchoString(wPtr,double('�����û�����'),200,400,0,255);
str
Screen('CloseAll');