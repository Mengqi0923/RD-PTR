function Chrom3 = init3(sets, pop_size, num_order)
%init2 个体第二部分，即集合中上下车点的下标编码
%   编码中每个非零元素表示订单的编号，上车为i，下车为i+n
length_code2 = num_order * 2;
Chrom3 = ones(pop_size, length_code2);
for i=1:pop_size
    for j=1:length_code2
        if rand<0.5
            Chrom3(i,j) = randi(length(sets{j}));
        end
    end
end

end