function send_information()
global udp_handle;
global send_edit;
global all_information;
string=get(send_edit,'String');
if(string)
    string=unicode2native(string);
    fwrite(udp_handle,string);
    string=native2unicode(string);
    string=strcat('send   :',string);
    all_information(3:100)=all_information(1:98);
    all_information(1).type=1;
    all_information(1).string=string;
    all_information(2).type=1;
    all_information(2).string='';
    set(send_edit,'String',"");
    refresh_show();
end