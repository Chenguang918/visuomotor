% 心理物理与Psychtoolbox编程演示程序
% 对比矩阵运算和for循环的速度
% Coded by Y. Yan @ BNU 2018-03-11

%% 矩阵运算
fprintf('矩阵运算：'); %在命令行窗户输出字符
clear; %清空工作区
tic %开始计时
x = 0.001:0.001:10; %生成x值
y = log10(x); %计算y值
toc %停止计时

%% for循环
fprintf('for循环：'); %在命令行窗户输出字符
clear %清空工作区
tic %开始计时
x = 0.001; %x的初始值
for k = 1:10000 %循环10000次
   y(k) = log10(x); %根据x计算每个y,此时向量y的长度在循环内部不断增长
   x = x + 0.001; %改变x,为下一次循环做准备
end
toc %停止计时

%% for循环（通过提前声明变量来提高程序运行效率）
fprintf('for循环优化版：'); %在命令行窗户输出字符
clear %清空工作区
tic %开始计时
x = 0.001; %x的初始值
y = zeros(1,10000); %在进入循环之前提前给变量y赋值, 避免y的长度在循环内增加
for k = 1:10000 %循环10000次
   y(k) = log10(x); %根据x计算每个y
   x = x + 0.001; %改变x,为下一次循环做准备
end
toc %停止计时