%% Use the .raw and .evt files to product the .set file for EGI
%
%
% V1.0 2020/3/7 Edited by Yiqing Hu



clear all
Head=28; % event 前不需要的行数
stm='Sti+';

filename='NAME_TD_MMN3.txt';  % 所需处理的文件名称，列在txt文件中
NN=2;   %被试数


fidid = fopen(filename,'r');   % 打开要读取的文件,返回文件标识符fidID
for i=1:NN
   
    name = fgetl(fidid);      % Read line from file, removing newline characters
    name1=['D:\认知神经\毕设\六院\data_kong\NAME_TD_MMN3_org\',name];    % NAME_TD_MMN3_org中有raw文件
    name2=[name,'_marker'];      % 给name添加后缀marker
    filepath='D:\认知神经\毕设\六院\data_kong\TD_MMN_withmarker\';   % 指定一个事先建好的路径，存放后续生成的set文件
    %Raw2EEG_delete_fx( name1, name2, Head,stm);
    % load a EGI EEG file, output EEGLAB data structure
    EEG = pop_readegi( [name1 '.raw'], [],[],'auto' ); % 读取原始EEG文件
    EEG.setname=name2;  % 设置setname为name2

    N=[];
    for j=1:length(EEG.event)
        % compare strings; || means OR
        if strcmp(EEG.event(j).type,'SESS')||strcmp(EEG.event(j).type,'CELL') %删去SESS、CELL类型事件
            N=[N,j];
        end
    end
 % 删除 SESS、CELL类型事件
EEG.event(N)=[];

M=[];
for j=1:length(EEG.event)
    if ( strcmp(EEG.event(j).type,'epoc')  ) % 去除epoc类型事件
        M=[M,j];
    end
end
Event2=EEG.event(M); % 挑选出epoc类型事件
% 删除epoc事件
EEG.event(M)=[];

% 打开 evt 文件
fid = fopen( [name1, '.evt']);
% '%s' 读取为字符向量元胞数组; '*'跳过；'HeaderLines'跳过开头行
% 提取出marker、反应时等
Event = textscan(fid,'%s%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%*s%d%*s%d%*s%d','Delimiter','\t ','HeaderLines',Head, 'MultipleDelimsAsOne', 1);
fclose(fid);

J1=[];
H=[];
for j=1:length(Event{1})   
    % onvert the contents of a cell array into a single matrix.
    str=string(cell2mat(Event{1}(j)));
    huo1=(strcmp(str,stm))|( strcmp(str,'TRSP'));
    H=[H,huo1];
    if huo1 == 0
        J1=[J1,j];
        %for c=1:5
        %Event{c}(j)=[];  
    end 
end

for c=1:5
    Event{c}(J1,:)=[];    %清空不需要的marker
end

J2=[];
H2=[];
% 去除raw文件中不需要的marker
for j=1:length(EEG.event)
    huo2=(strcmp(EEG.event(j).type,stm))|( strcmp(EEG.event(j).type,'TRSP'));
    H2=[H2,huo2];
    if huo2 == 0
        J2=[J2,j];
    end
end
EEG.event(J2)=[];
        
        
if (length(EEG.event)~=length(Event{1}))
error( '长度不等！');
end

for j=1:length(EEG.event)
    if ( strcmp(EEG.event(j).type,stm) )
        % 替换
    EEG.event(j).type=num2str(Event{2}{j});    
    end
    if (strcmp(EEG.event(j).type,'TRSP')) && (Event{3}(j)==1)
    EEG.event(j).type=num2str(100);
    EEG.event(j).eval=Event{3}(j);
    EEG.event(j).rtim=Event{4}(j);
    EEG.event(j).trial=Event{5}(j);
    
        elseif (strcmp(EEG.event(j).type,'TRSP')) && (Event{3}(j)==0)
        EEG.event(j).type=num2str(99);
        EEG.event(j).eval=Event{3}(j);
        EEG.event(j).rtim=Event{4}(j);
        EEG.event(j).trial=Event{5}(j);
    end
  
end

% 算啥呢
for ll=1:0.5*length(EEG.event)
    l=(ll-1)*2+1;
    sti_char=EEG.event(l).type;
    EEG.event(l).type=[sti_char,'+',EEG.event(l+1).type];
end


EEG = pop_saveset( EEG, 'filename',[name2 '.set'],'filepath',filepath);
EEG = pop_delset( EEG, [1] );
end
