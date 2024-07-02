function get_information()
global udp_handle;
global all_information;
if udp_handle.BytesAvailable>0
    data_rec=fread(udp_handle);
    data_rec=native2unicode(data_rec);
    data_rec=data_rec';
    all_information(3:100)=all_information(1:98);
    %string_rec=string(data_rec);    
    data_rec=strcat('receive   :',data_rec);    
    all_information(1).type=0;
    all_information(1).string=data_rec;
    all_information(2).type=1;
    all_information(2).string='';
    refresh_show();
end
