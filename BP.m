   %% 清空环境变量
clc
clear

%% 训练数据预测数据提取及归一化
%导入数据
A=xlsread('GFSJy.xlsx','原始数据','B13887:N14606');
A(find(A(:,1)==0),:)=[];
B=A(:,2:end);
C=A(:,1)';
%随机排序
k=rand(1,450);
[m,n]=sort(k);

%找出训练数据和预测数据
input_train=B(n(1:450),:)';
output_train=C(n(1:450));
input_test=B((451:466),:)';
output_test=C(:,(451:466));

%选连样本输入输出数据归一化
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%% BP网络训练
% %初始化网络结构
net=newff(inputn,outputn,11);

net.trainParam.epochs=50;  %训练次数为100次
net.trainParam.lr=0.01;  %学习速率为0.1
net.trainParam.goal=0.01;  %训练目标最小误差，设置为0.01

%网络训练
net=train(net,inputn,outputn);

%% BP网络预测
%预测数据归一化
inputn_test=mapminmax('apply',input_test,inputps);
 
%网络预测输出
an=sim(net,inputn_test);
 
%网络输出反归一化
BPoutput=mapminmax('reverse',an,outputps);

%% 结果分析

figure(1)
plot(BPoutput)
hold on
plot(output_test);
legend('预测值','真实值')
title('BP网络预测输出','fontsize',12)
ylabel('功率数值','fontsize',12)
xlabel('样本','fontsize',12)
%预测误差
error=BPoutput-output_test;


figure(2)
plot(error)
title('BP网络预测误差','fontsize',12)
ylabel('误差','fontsize',12)
xlabel('样本','fontsize',12)

figure(3)
plot((output_test-BPoutput)./BPoutput);
title('BP网络预测误差百分比')

errorsum=sum(abs(error))
mse = sum((BPoutput-output_test).^2)./16
mae = sum(abs(BPoutput-output_test))/16