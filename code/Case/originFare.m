function [original_fare, original_distances] = originFare(sets, distances, num_order, cF, min_fare, min_distance)
%originFare 计算原价
%   原价为初始上下车点之间的距离(km) * 单位里程费用
original_fare = zeros(num_order,1);
original_distances = zeros(num_order,1);
for i=1:num_order
    original_distances(i) = distances(sets{i}(1), sets{i+num_order}(1))/1000;    % 计算原距离
    if original_distances(i)>min_distance
        original_fare(i) = (original_distances(i) - min_distance) * cF + min_fare;                               % 计算原价
    else
        original_fare(i) = min_fare;
    end
end

end