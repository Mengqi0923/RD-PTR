%% ��Ԫ������ѡ��
%����Chrom��           ��Ⱥ
%����dist��            �������
%���Selch��           ��Ԫ������ѡ����ĸ���
function [Selch, newv]=BinaryTourment_Select(Chrom,v,FitnV,NIND)

Selch=Chrom;                    %��ʼ����Ԫ������ѡ����ĸ���
newv = v;
for i=1:NIND
    R=randperm(NIND);                   %����һ��1~NIND���������
    index1=R(1);                        %��һ���Ƚϵĸ������
    index2=R(2);                        %�ڶ����Ƚϵĸ������
    fit1=FitnV(index1);               %��һ���Ƚϵĸ������Ӧ��ֵ����Ӧ��ֵԽ��˵����������Խ�ߣ�
    fit2=FitnV(index2);               %�ڶ����Ƚϵĸ������Ӧ��ֵ
    %�������1����Ӧ��ֵ ���ڵ��� ����2����Ӧ��ֵ���򽫸���1��Ϊ��iѡ����ĸ���
    if fit1>=fit2
        Selch(i,:)=Chrom(index1,:);
        newv(i,:)=v(index1,:);
    else
        %�������1����Ӧ��ֵ С�� ����2����Ӧ��ֵ���򽫸���2��Ϊ��iѡ����ĸ���
        Selch(i,:)=Chrom(index2,:);
        newv(i,:)=v(index2,:);
    end
end
end