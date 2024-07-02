function [data_recv]=TCPinput(t_server)
while(1)
    if t_server.BytesAvailable>0
       t_server.BytesAvailable;
       break
    end
end
pause(0.5)
data_recv=fread(t_server,t_server.BytesAvailable/8,'double');
end