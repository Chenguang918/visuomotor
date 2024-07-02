clc 
clear all

% filename=['E:\Zhaochenguang\NFB\experimentdata\subexpdata\sub41','\beha_data']
filename=['C:\Users\15455\Documents\Data\NFB\NF_Zhao\20201107��Ϊ\��Ϊ\sub42','\beha_data'];
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
