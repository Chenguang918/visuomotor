% Bechavior calculation for NFB 
% Coded by YQ.Hu @ BNU 2020-11-10

%% Calculate ACC RT RTsd
clear
clc 
clear all

% sub11,sub32,sub41,sub42
sub=[11,32,41,42]; % ������Ϊ�����ļ��б��
subN=4 ; % ��������

for subi=1:subN
name = ['C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\����\20201107��Ϊ\��Ϊ\sub',num2str(sub(subi)),'\beha_data.mat']; %�ļ���·��+�ļ���
load(name);      
RightIn = fidnew.ACC == 1; %ACC=1��index
ACC(:,subi) = mean(RightIn,2); %����ȷ��

% ��ȥû�з�Ӧ��,��Ӧ�����ģ����Ϊ999��MisHit��
RTIn = 0 < fidnew.RT & fidnew.RT < 999 ; 
RTMisIn = fidnew.RT == 999;

% 1.5s��Ӧʱ������ζ����׼����������2s��

% ����Hit����Hit Rate()
Hit(:,subi) = sum(RTIn,2); 
TrialSize(subi,:) = size(RTIn);
HitR(:,subi) = Hit(:,subi)./ TrialSize(subi,2);
MisR = 1- HitR;

RTIn2 = ( RightIn & RTIn );   %ֻ����ȷ��Ӧ�ķ�Ӧʱ
RightHit= sum(RTIn2,2);

RTnew=[]; % Ԥ��ֵ��ֹ����
NewIn=[];
RTrail=[];
 for j=1:2 %����Э�飬positive & negative
   
    %�������ʹ��Index��ȡ����
    RTrail(j,:) = fidnew.RT(j,:) .* RTIn2(j,:); %�ҳ�������Ч��Ӧʱ 
    % ƽ����Ӧʱ
    RTav(j,subi) = sum(RTrail(j,:),2)./RightHit(j); 
    
    %% ��Ӧʱ������RTsd
    % ʹ����ƫ����,MisHitȫ���滻��2.0s,����Ӧ������
    % ��γ�ȥ��λ��Ӧ����ʾ��ӦʱΪ0
    RT4Mis=2.0 ;%û�з�Ӧ����ΪRT=2s 
    RTnew(j,:) = RTrail(j,:) + RT4Mis .* RTMisIn(j,:);  % MisHitȫ���滻��2.0s
    NewIn=find(RTnew(j,:)~=0);
    RTnew2 = RTnew(j,NewIn);  % ȥ������Ӧ
 
    RTsd(j,subi) = std(RTnew2,0,2);
   %% RTmid
    RTmid(j,subi) = median(RTnew2);
 end
end
% save('C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\����\20201107��Ϊ\��Ϊ\Result.mat', 'ACC','RTav','MisR','RTsd')
save('C:\Users\15455\Documents\MATLAB\Result\Behavior4NFB', 'ACC','RTav','MisR','RTsd','RTmid')
% ������ν�.mat�ļ�����excel
% load Behavior4NFB.mat ACC RTav  MisR RTsd RTmid %%aaaΪ������
% xlswrite('Behavior4NFB.xlsx', 'ACC','RTav','MisR','RTsd','RTmid') %%%YYYΪ�����excel�ļ�
%   
%% �� Remove some trial 
%sub11
clc

sub=[11,32,41,42];

subi=1;  %ѡ��һ������
DelTrialN=20; %ȥ���˱��Ե�ǰ��N��trial
name = ['C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\����\20201107��Ϊ\��Ϊ\sub',num2str(sub(subi)),'\beha_data.mat'];%�ļ���·��+�ļ���
load(name); 
[m,n] = size(fidnew.ACC);
Index(2,DelTrialN) = 0;
Index(:,DelTrialN+1:n) = 1;
ACC_re=fidnew.ACC.* Index;
RightIn = ACC_re == 1; %ACC=1��index
ACC(:,subi) = sum(RightIn,2)/(n-DelTrialN); %����ȷ��
RTIn = fidnew.RT <999 ;   % ��ȥû�з�Ӧ��
RTIn2 = ( RightIn & RTIn );   %ֻ����ȷ��Ӧ�ķ�Ӧʱ
RightHit= sum(RTIn2,2);

 for j=1:2
   
    %�������ʹ��Index��ȡ����
    RTrail = fidnew.RT .* RTIn2(j,:); %�ҳ�������Ч��Ӧʱ 
    RTrail(j,subi) = sum(RTrail(j,:),2)./RightHit(j); %��ƽ��
 end
% �����ļ�
 save('C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\����\20201107��Ϊ\��Ϊ\Result_re.mat', 'ACC','RT')




