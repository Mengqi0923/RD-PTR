%% 二元锦标赛选择
%输入Chrom：           种群
%输入dist：            距离矩阵
%输出Selch：           二元锦标赛选择出的个体
function [Selch, newv]=BinaryTourment_Select(Chrom,v,FitnV,NIND)

Selch=Chrom;                    %初始化二元锦标赛选择出的个体
newv = v;
for i=1:NIND
    R=randperm(NIND);                   %生成一个1~NIND的随机排列
    index1=R(1);                        %第一个比较的个体序号
    index2=R(2);                        %第二个比较的个体序号
    fit1=FitnV(index1);               %第一个比较的个体的适应度值（适应度值越大，说明个体质量越高）
    fit2=FitnV(index2);               %第二个比较的个体的适应度值
    %如果个体1的适应度值 大于等于 个体2的适应度值，则将个体1作为第i选择出的个体
    if fit1>=fit2
        Selch(i,:)=Chrom(index1,:);
        newv(i,:)=v(index1,:);
    else
        %如果个体1的适应度值 小于 个体2的适应度值，则将个体2作为第i选择出的个体
        Selch(i,:)=Chrom(index2,:);
        newv(i,:)=v(index2,:);
    end
end
end