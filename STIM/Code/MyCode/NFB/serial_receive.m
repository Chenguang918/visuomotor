function [receive]=serial_receive(com)
while(1)
    if com.BytesAvailable>0
       com.BytesAvailable;
       receive=fread(com,1);
       break
    end
end
end
