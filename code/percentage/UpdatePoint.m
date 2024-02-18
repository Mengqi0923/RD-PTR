function [newChrom3, IsChange] = UpdatePoint(Chrom3, sets, p3, IsChange, uo_perenfence)
%UpdatePoint 更新集合中选择的点，即Chrom3
%   此处提供详细说明
newChrom3 = Chrom3;
m = size(newChrom3,1);
n = size(newChrom3,2);
for i=1:m
    if rand<p3 && IsChange(i) == 0
        p = randi(n,1,1);   % 随机产生需更新的上下车点的数量
        s = randperm(n,p);  % 随机选择上下车点集合
        s = sort(s);
        for j=1:length(s)
            a = sets{s(j)};
            x = randi(length(a),1,1);
            newChrom3(i,s(j)) = x;
        end
        IsChange(i) = 1;
    end
    newChrom3(i,:) = newChrom3(i,:) .* uo_perenfence;
    a = Chrom3(i,:);
    a(a==0) = 1;
    newChrom3(i,:) = a;
end
end