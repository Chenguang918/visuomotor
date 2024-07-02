function [RT1,RT2,ACC,theta,duration,x,y,degree]=joystick2beh(TargetNum,ACCstandard,Maxresponse,buffer)
% TargetNum = index of targtet location
% ACCstandard = 30°defult value 
% Maxresponse = 2 defult value
% Copyright by Chenguang Zhao 2021.12.03
%% initial data

RT1=999;RT2=999;ACC=2;theta=999;duration=999;x=32767;y=32767;
condition={'����','����','��©'};
%%
if TargetNum==7
   ACCstandard=180;
end
numberOfDevices = PsychHID('NumDevices');
devices = PsychHID('Devices',numberOfDevices);   % check information
centre = [32767,32767];  % depend on USB-HID devices
standard_theta=[pi/6,pi/2,2*pi/3,-2*pi/3, -pi/2, -pi/6, 0];  % upper y asix == 0°
OA=[sin(standard_theta(TargetNum)),-cos(standard_theta(TargetNum))];
tic;
 % fist caculate time
while toc<=Maxresponse
[x, y] = WinJoystickMex(0);   %  2 ms<t<10 ms
degree=norm([x-centre(1) y-centre(2)],2);
%% oupt RT1,RT2,duration
if  degree > 500
RT1=toc; % 第一次计时结�?
    while 1
    [keyIsDown] = PsychHID('KbCheck',2);    %  2 ms<t<10 ms
%% oupt theta
    if keyIsDown
       RT2=toc; % resp Finsih time
       duration=RT2-RT1;
       [x, y] = WinJoystickMex(0); 
       X=x-centre(1);
       Y=y-centre(2);
       OB=[X,Y];
       sigma = acos(dot(OA,OB)/(norm(OA)*norm(OB)));%弧度�?
       theta=sigma/pi*180;% change to degree?
       
%% oupt ACC
       if theta<=ACCstandard
          ACC=1;
       else
          ACC=0;
       end
     sprintf('ƫ�ƽǶ�%.2f\n������Ӧʱ%.2f\n��ɷ�Ӧʱ%.2f\nĿ��%s\n',theta,RT1+buffer,RT2+buffer,condition{ACC+1})
     return
    end
    end
else
    RT2=toc;

end
end
end