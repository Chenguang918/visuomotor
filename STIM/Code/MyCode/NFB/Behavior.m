% Bechavior calculation for NFB 
% Coded by YQ.Hu @ BNU 2020-11-10

%% Calculate ACC RT RTsd
clear
clc 
clear all

% sub11,sub32,sub41,sub42
sub=[11,32,41,42]; % 被试行为数据文件夹编号
subN=4 ; % 被试数量

for subi=1:subN
name = ['C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\数据\20201107行为\行为\sub',num2str(sub(subi)),'\beha_data.mat']; %文件夹路径+文件名
load(name);      
RightIn = fidnew.ACC == 1; %ACC=1的index
ACC(:,subi) = mean(RightIn,2); %求正确率

% 除去没有反应的,或反应过慢的（标记为999，MisHit）
RTIn = 0 < fidnew.RT & fidnew.RT < 999 ; 
RTMisIn = fidnew.RT == 999;

% 1.5s反应时以上如何定其标准？都看作是2s？

% 计算Hit数及Hit Rate()
Hit(:,subi) = sum(RTIn,2); 
TrialSize(subi,:) = size(RTIn);
HitR(:,subi) = Hit(:,subi)./ TrialSize(subi,2);
MisR = 1- HitR;

RTIn2 = ( RightIn & RTIn );   %只算正确反应的反应时
RightHit= sum(RTIn2,2);

RTnew=[]; % 预赋值防止迭代
NewIn=[];
RTrail=[];
 for j=1:2 %两个协议，positive & negative
   
    %？？如何使用Index提取数据
    RTrail(j,:) = fidnew.RT(j,:) .* RTIn2(j,:); %找出所有有效反应时 
    % 平均反应时
    RTav(j,subi) = sum(RTrail(j,:),2)./RightHit(j); 
    
    %% 反应时变异性RTsd
    % 使用无偏估计,MisHit全部替换成2.0s,错误反应不计入
    % 如何除去错位反应，显示反应时为0
    RT4Mis=2.0 ;%没有反应就认为RT=2s 
    RTnew(j,:) = RTrail(j,:) + RT4Mis .* RTMisIn(j,:);  % MisHit全部替换成2.0s
    NewIn=find(RTnew(j,:)~=0);
    RTnew2 = RTnew(j,NewIn);  % 去除错误反应
 
    RTsd(j,subi) = std(RTnew2,0,2);
   %% RTmid
    RTmid(j,subi) = median(RTnew2);
 end
end
% save('C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\数据\20201107行为\行为\Result.mat', 'ACC','RTav','MisR','RTsd')
save('C:\Users\15455\Documents\MATLAB\Result\Behavior4NFB', 'ACC','RTav','MisR','RTsd','RTmid')
% ？？如何将.mat文件导入excel
% load Behavior4NFB.mat ACC RTav  MisR RTsd RTmid %%aaa为变量名
% xlswrite('Behavior4NFB.xlsx', 'ACC','RTav','MisR','RTsd','RTmid') %%%YYY为输出的excel文件
%   
%% → Remove some trial 
%sub11
clc

sub=[11,32,41,42];

subi=1;  %选择一个被试
DelTrialN=20; %去掉此被试的前面N个trial
name = ['C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\数据\20201107行为\行为\sub',num2str(sub(subi)),'\beha_data.mat'];%文件夹路径+文件名
load(name); 
[m,n] = size(fidnew.ACC);
Index(2,DelTrialN) = 0;
Index(:,DelTrialN+1:n) = 1;
ACC_re=fidnew.ACC.* Index;
RightIn = ACC_re == 1; %ACC=1的index
ACC(:,subi) = sum(RightIn,2)/(n-DelTrialN); %求正确率
RTIn = fidnew.RT <999 ;   % 除去没有反应的
RTIn2 = ( RightIn & RTIn );   %只算正确反应的反应时
RightHit= sum(RTIn2,2);

 for j=1:2
   
    %？？如何使用Index提取数据
    RTrail = fidnew.RT .* RTIn2(j,:); %找出所有有效反应时 
    RTrail(j,subi) = sum(RTrail(j,:),2)./RightHit(j); %做平均
 end
% 保存文件
 save('C:\Users\15455\Documents\Tencent Files\1545598574\FileRecv\0HolleWork\NF\数据\20201107行为\行为\Result_re.mat', 'ACC','RT')




