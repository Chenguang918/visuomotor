clc;clear;close all;

x= 1:1:1920;
y= 1:1:1080;
mu=[60,540];

XX = normpdf(x,mu(1),100);
YY = normpdf(y,mu(2),100);
ZZ = (XX')*YY;
imagesc(ZZ');
axis equal;



[X,Y]=meshgrid(x,y); % 产生网格数据并处理
p=mvnpdf([X(:),Y(:)],mu,[2000,1000]);
P=reshape(p,size(X)); % 求取联合概率密度
imagesc(P); colorbar;
