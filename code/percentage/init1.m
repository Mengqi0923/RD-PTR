function Chrom1 = init1(pop_size, num_order, minValue, maxValue, t_perenfence)
%init3 个体第三部分，即每个订单上车时间的偏移量
%   编码中每值表示订单上车时间的偏移量，负值为提前，正值为延后
Chrom1 = zeros(pop_size,num_order);
for i=1:size(Chrom1,1)
    if rand<0.8
        n = ceil(num_order/2);
        x = randi(n,1,1);
        or = randperm(num_order,x);
        for j=1:x
            Chrom1(i,or(j)) = (maxValue - minValue) * rand + minValue;
        end
    end
    Chrom1(i,:) = Chrom1(i,:) .* t_perenfence;
end

end