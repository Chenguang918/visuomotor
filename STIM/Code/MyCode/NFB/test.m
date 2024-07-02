clc 
clear all

% filename=['E:\Zhaochenguang\NFB\experimentdata\subexpdata\sub41','\beha_data']
filename=['C:\Users\15455\Documents\Data\NFB\NF_Zhao\20201107行为\行为\sub42','\beha_data'];
load(filename);  % 下载文件 

%% ACC
RightIndex = fidnew.ACC == 1; %ACC=1的index，以防漏按的情况
ACC = mean(RightIndex,2); %求正确率

%% Hit
% 除去没有反应的,或反应过慢的（标记为999，MisHit）
HitIndex = 0 < fidnew.RT & fidnew.RT < 999 ;  % valid hit response
MisIndex = fidnew.RT == 999;


% 计算Hit数及Hit Rate()
Hitnum = sum(HitIndex,2); 
TrialSize = size(HitIndex);
HitRate = Hitnum./ TrialSize(2);
MisRate = 1- HitRate;

%% RT
RTIndex = ( RightIndex & HitIndex );   %只算正确反应的反应时
RTnum= sum(RTIndex,2); % sum the num of right hit

RTnewtrial=[]; % 预赋值防止迭代
RTNewIndex=[];
RTtrails=[];
block=2; % two protocol positive & negative
 for nblock=1:block  
   %% RT 
    % 1.5s反应时以上如何定其标准？都看作是2s？
    %？？如何使用Index提取数据
    RTtrails(nblock,:) = fidnew.RT(nblock,:) .* RTIndex(nblock,:); %找出所有有效反应时 
    % 平均反应时
    RT(nblock,:) = sum(RTtrails(nblock,:),2)./RTnum(nblock); 
    
    %% RTsd 
    % 使用无偏估计,MisHit全部替换成2.0s,错误反应不计入
    % 如何除去错位反应，显示反应时为0
    MisTime=2.0 ;%没有反应就认为RT=2s 
    RTnewtrial(nblock,:) = RTtrails(nblock,:) + MisTime .* MisIndex(nblock,:);  % MisHit全部替换成2.0s
    RTNewIndex=find(RTnewtrial(nblock,:)~=0);
    
    RTnew = RTnewtrial(nblock,RTNewIndex);  % 去除错误反应
    RTsd(nblock,:) = std(RTnew,0,2);
   %% RTmid
    RTmid(nblock,:) = median(RTnew);
 end
 %% 画图
 subplot(1,3,1)
 bar(ACC,'b','EdgeColor','b')
 hold on
 plot(ACC,'lineWidth',2,'Color','k')
 ylabel({'ACC'});
 xlabel({'protocol'});
 
 subplot(1,3,2) 
 bar(RT,'b','EdgeColor','b')
 hold on
 plot(RT,'lineWidth',2,'Color','k')
 ylabel({'RT/s'});
 xlabel({'protocol'});
 
 subplot(1,3,3)
 plot(RTsd)
 hold on
 plot(RTmid)
 ylabel({'RTsd,RTmid'});
 xlabel({'protocol'});
