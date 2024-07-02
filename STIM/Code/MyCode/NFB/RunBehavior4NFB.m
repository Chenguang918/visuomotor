function [ACC,RT,RTsd,RTmid]=RunBehavior4NFB(filename)
% Calculate behavior results for neurofeeback (NFB) exp including ACC,RT RTsd,RTmid
% Coded by YQ.Hu @ BNU 2020-11-25

load(filename);  % �����ļ� 

%% ACC
RightIndex = fidnew.ACC == 1; %ACC=1��index���Է�©�������
ACC = mean(RightIndex,2); %����ȷ��

%% Hit
% ��ȥû�з�Ӧ��,��Ӧ�����ģ����Ϊ999��MisHit��
HitIndex = 0 < fidnew.RT & fidnew.RT < 999 ;  % valid hit response
MisIndex = fidnew.RT == 999;


% ����Hit����Hit Rate()
Hitnum = sum(HitIndex,2); 
TrialSize = size(HitIndex);
HitRate = Hitnum./ TrialSize(2);
MisRate = 1- HitRate;

%% RT
RTIndex = ( RightIndex & HitIndex );   %ֻ����ȷ��Ӧ�ķ�Ӧʱ
RTnum= sum(RTIndex,2); % sum the num of right hit

RTnewtrial=[]; % Ԥ��ֵ��ֹ����
RTNewIndex=[];
RTtrails=[];
block=2; % two protocol positive & negative
 for nblock=1:block  
   %% RT 
    % 1.5s��Ӧʱ������ζ����׼����������2s��
    %�������ʹ��Index��ȡ����
    RTtrails(nblock,:) = fidnew.RT(nblock,:) .* RTIndex(nblock,:); %�ҳ�������Ч��Ӧʱ 
    % ƽ����Ӧʱ
    RT(nblock,:) = sum(RTtrails(nblock,:),2)./RTnum(nblock); 
    
    %% RTsd 
    % ʹ����ƫ����,MisHitȫ���滻��2.0s,����Ӧ������
    % ��γ�ȥ��λ��Ӧ����ʾ��ӦʱΪ0
    MisTime=2.0 ;%û�з�Ӧ����ΪRT=2s 
    RTnewtrial(nblock,:) = RTtrails(nblock,:) + MisTime .* MisIndex(nblock,:);  % MisHitȫ���滻��2.0s
    RTNewIndex=find(RTnewtrial(nblock,:)~=0);
    
    RTnew = RTnewtrial(nblock,RTNewIndex);  % ȥ������Ӧ
    RTsd(nblock,:) = std(RTnew,0,2);
   %% RTmid
    RTmid(nblock,:) = median(RTnew);
 end
   %% ��ͼ
   
   
   
   
end
 
