clear
t_server=tcpip('0.0.0.0',30000,'NetworkRole','server');%���һ���������ӵĿͻ���������
t_server.InputBuffersize=100000;
fopen(t_server)%�򿪷�����ֱ������TCP���Ӳŷ���
while(1)
    if t_server.BytesAvailable>0
       t_server.BytesAvailable
       break
    end
end
pause(1)
data_recv=fread(t_server,t_server.BytesAvailable/8,'double');
fclose(t_server);