%% Use the .raw and .evt files to product the .set file for EGI
%
%
% V1.0 2020/3/7 Edited by Yiqing Hu



clear all
Head=28; % event ǰ����Ҫ������
stm='Sti+';

filename='NAME_TD_MMN3.txt';  % ���账����ļ����ƣ�����txt�ļ���
NN=2;   %������


fidid = fopen(filename,'r');   % ��Ҫ��ȡ���ļ�,�����ļ���ʶ��fidID
for i=1:NN
   
    name = fgetl(fidid);      % Read line from file, removing newline characters
    name1=['D:\��֪��\����\��Ժ\data_kong\NAME_TD_MMN3_org\',name];    % NAME_TD_MMN3_org����raw�ļ�
    name2=[name,'_marker'];      % ��name��Ӻ�׺marker
    filepath='D:\��֪��\����\��Ժ\data_kong\TD_MMN_withmarker\';   % ָ��һ�����Ƚ��õ�·������ź������ɵ�set�ļ�
    %Raw2EEG_delete_fx( name1, name2, Head,stm);
    % load a EGI EEG file, output EEGLAB data structure
    EEG = pop_readegi( [name1 '.raw'], [],[],'auto' ); % ��ȡԭʼEEG�ļ�
    EEG.setname=name2;  % ����setnameΪname2

    N=[];
    for j=1:length(EEG.event)
        % compare strings; || means OR
        if strcmp(EEG.event(j).type,'SESS')||strcmp(EEG.event(j).type,'CELL') %ɾȥSESS��CELL�����¼�
            N=[N,j];
        end
    end
 % ɾ�� SESS��CELL�����¼�
EEG.event(N)=[];

M=[];
for j=1:length(EEG.event)
    if ( strcmp(EEG.event(j).type,'epoc')  ) % ȥ��epoc�����¼�
        M=[M,j];
    end
end
Event2=EEG.event(M); % ��ѡ��epoc�����¼�
% ɾ��epoc�¼�
EEG.event(M)=[];

% �� evt �ļ�
fid = fopen( [name1, '.evt']);
% '%s' ��ȡΪ�ַ�����Ԫ������; '*'������'HeaderLines'������ͷ��
% ��ȡ��marker����Ӧʱ��
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
    Event{c}(J1,:)=[];    %��ղ���Ҫ��marker
end

J2=[];
H2=[];
% ȥ��raw�ļ��в���Ҫ��marker
for j=1:length(EEG.event)
    huo2=(strcmp(EEG.event(j).type,stm))|( strcmp(EEG.event(j).type,'TRSP'));
    H2=[H2,huo2];
    if huo2 == 0
        J2=[J2,j];
    end
end
EEG.event(J2)=[];
        
        
if (length(EEG.event)~=length(Event{1}))
error( '���Ȳ��ȣ�');
end

for j=1:length(EEG.event)
    if ( strcmp(EEG.event(j).type,stm) )
        % �滻
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

% ��ɶ��
for ll=1:0.5*length(EEG.event)
    l=(ll-1)*2+1;
    sti_char=EEG.event(l).type;
    EEG.event(l).type=[sti_char,'+',EEG.event(l+1).type];
end


EEG = pop_saveset( EEG, 'filename',[name2 '.set'],'filepath',filepath);
EEG = pop_delset( EEG, [1] );
end
