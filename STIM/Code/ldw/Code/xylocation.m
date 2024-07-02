clear
clc

for sub = 1:30
for i = 1:360
x1 = 1:0.1:3;
x1 = x1(randperm(length(x1)));
x2 = 1:0.1:3;
x2 = x2(randperm(length(x2)));
x3 = 1:0.1:3;
x3 = x3(randperm(length(x3)));
y1 = -3:0.1:0;
y2 = 0;
y3 = 0:0.1:3;
y1 = y1(randperm(length(y1)));
y2 = y2(randperm(length(y2)));
y3 = y3(randperm(length(y3)));
while((((x1(1)-x2(1))^2+(y1(1)-y2(1))^2)<=2.5^2) |...
        (((x1(1)-x3(1))^2+(y1(1)-y3(1))^2)<=2.5^2) |...
        (((x2(1)-x3(2))^2+(y2(1)-y3(1))^2)<=2.5^2) |...
        (((x1(1)-0)^2+(y1(1)-0)^2)<=1.5^2) |...
        (((x2(1)-0)^2+(y2(1)-0)^2)<=1.5^2) |...
        (((x3(1)-0)^2+(y3(1)-0)^2)<=1.5^2))
x1 = x1(randperm(length(x1)));
x2 = x2(randperm(length(x2)));
x3 = x3(randperm(length(x3)));
y1 = y1(randperm(length(y1)));
y2 = y2(randperm(length(y2)));
y3 = y3(randperm(length(y3)));

end
LocX(i,:)=[x1(1),x2(1),x3(1)];
LocY(i,:)=[y1(1),y2(1),y3(1)];
clear x1 x2 x3 y1 y2 y3
end
save(['E:\Song\Song\ldw\Data\sub',num2str(sub),'_triallists.mat'],'LocX','LocY');
clear LocX LocY
end