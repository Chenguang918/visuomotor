function refresh_show()
global r_s_listbox;
global all_information;
string=cell(2,100);
string=struct2cell(all_information);
set(r_s_listbox,'string',string(2,1,:));