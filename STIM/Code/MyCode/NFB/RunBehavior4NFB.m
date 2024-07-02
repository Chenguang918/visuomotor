function [ACC,RT,RTsd,RTmid]=RunBehavior4NFB(filename)
% Calculate behavior results for neurofeeback (NFB) exp including ACC,RT RTsd,RTmid
% Coded by YQ.Hu @ BNU 2020-11-25

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
   
   
   
   
end
 
