function Chrom2 = init2_1(Chrom1, Chrom3, length_code1, pop_size, num_taxi, num_order, max_capacity, pick_up_time, distances,v_taxi,sets, max_detour, original_distances)
%init2 个体第二部分，即订单分配和接送顺序编码
%   编码中每个非零元素表示订单的编号，上车为i，下车为i+n
Chrom2 = zeros(pop_size,length_code1);
newtime = pick_up_time + Chrom1;
sub_num_taxi = ceil(num_taxi/2);
for i = 1:pop_size
    routes = cell(num_taxi,1);
%     routes = random_partition(1:num_order, num_taxi, max_capacity);  % 把订单随机分配给出租车
    routes(1:sub_num_taxi) = random_partition(1:num_order, sub_num_taxi, max_capacity);  % 把订单随机分配给出租车
    taxi_matrix = zeros(num_taxi, max_capacity * 2);
    other_order = [];
    for j = 1:num_taxi
        routes{j} = priority_sort(routes{j}, newtime(i,:));  % 按照时间对订单重新排序
        sub_route = routes{j};
%         lr = length(routes{j})   % sub_route的长度随着迭代改变
        if length(sub_route)>1
            k1 = 2;
            while true
                actualtime = newtime(i,sub_route(k1-1)) + distances(sets{sub_route(k1-1)}(Chrom3(i,sub_route(k1-1))), sets{sub_route(k1)}(Chrom3(i,sub_route(k1)))) / v_taxi;
                if actualtime>newtime(i,sub_route(k1))   % 若车辆到达k1出发点的时间晚于其上车时间，则将其在该路径中删除
                    other_order = [other_order, sub_route(k1)];
                    sub_route = sub_route(sub_route ~= sub_route(k1));
                else
                    k1 = k1 + 1;
                end
                if k1>length(sub_route)
                    break;
                end
            end
          
        end
        routes{j} = sub_route;
    end
    if ~isempty(other_order)   % 存在违反时间约束的订单
        for j=1:length(routes)   % 选出空车 
            if isempty(routes{j}) && ~isempty(other_order)
                k = randi(length(other_order));
                routes{j} = other_order(k);
                other_order = other_order(other_order ~= other_order(k));
            end
        end
    end
    for j=1:num_taxi
        if rand<=1   % 乘客拼车
            route = [routes{j}, routes{j} + num_order];
            len_r = length(route);
            if len_r>2   % 若符合约束，将下车点的位置调到前面
                for k=2:len_r
                    if route(k)>num_order
                        pickup_k = find(route==route(k)-num_order);   % 记录其上车点的下标
                        for kk=pickup_k+1:k-1
                            if route(kk)<=num_order
                                a1 = route(kk);
                                a2 = route(k);
                                r1 = [route(1:kk-1),a2];
                                actual_t = CaculateTime(r1,num_order,newtime(i,:),distances,v_taxi,sets,Chrom3(i,:));
                                if actual_t + distances(sets{route(kk-1)}(Chrom3(i,route(kk-1))), sets{a2}(Chrom3(i,a2))) / v_taxi <= newtime(i,a1) && rand < 0.5
                                    if k<len_r
                                        route = [r1, route(kk:k-1),route(k+1:end)];
                                    else
                                        route = [r1, route(kk:k-1)];
                                    end
                                    break;
                                end
                            end
                        end
                    end
                end
                % 调整违反绕道率约束的订单
                for k=1:length(route)
                    if route(k) <= num_order
                        kk = find(route == route(k) + num_order);
                        if kk > k + 1
                            dist = 0;
                            for ll=k:kk-1
                                dist = dist + distances(sets{route(ll)}(Chrom3(i,route(ll))), sets{route(ll+1)}(Chrom3(i,route(ll+1))));
                            end
                            if (dist/1000-original_distances(route(k)))/original_distances(route(k)) > max_detour
                                % 若违反了绕道率约束，则将下车点的位置提前
                                [route(kk), route(k+1)] = swap(route(kk), route(k+1));
                                % 调整下车点在上车点之前的订单
                                if route(kk) <= num_order
                                    k1 = find(route == route(kk) + num_order);
                                    if k1 < kk
                                        [route(kk), route(k1)] = swap(route(kk), route(k1));
                                    end
                                else
                                    k1 = find(route == route(kk) - num_order);
                                    if k1 > kk
                                        [route(kk), route(k1)] = swap(route(kk), route(k1));
                                    end
                                end
                            end
                        end

                    end
                end
            end
        else   % 部分乘客不拼车
            route = zeros(1,length(routes{j}) * 2);
            for k=1:length(routes{j})
                route(2 * k - 1) = routes{j}(k);
                route(2 * k) = routes{j}(k) + num_order;
            end
            % 若一个订单的上车点之前是一个下车点，不符合时间约束，则上车点前移
            if length(route)>2
                for k=2:length(route)
                    if route(k)<=num_order
                        actual_t = CaculateTime(route(1:k-1),num_order,newtime(i,:),distances,v_taxi,sets,Chrom3(i,:));
                        temp_r = route;
                        kk = k;
                        while actual_t + distances(sets{temp_r(kk-1)}(Chrom3(i,temp_r(kk-1))),sets{temp_r(kk)}(Chrom3(i,temp_r(kk))))...
                                / v_taxi > newtime(i,route(k)) && temp_r(kk-1)>num_order
                            [temp_r(kk-1), temp_r(kk)] = swap(temp_r(kk-1), temp_r(kk));
                            kk = kk - 1;
                            if kk == 1
                                break;
                            end
                            actual_t = CaculateTime(temp_r(1:kk-1),num_order,newtime(i,:),distances,v_taxi,sets,Chrom3(i,:));
                        end
                        route = temp_r;
                    end
                end
                % 删除违反时间约束的订单
                k = 2;
                while k<length(route)
                    if route(k)<=num_order
                        actual_t = CaculateTime(route(1:k-1),num_order,newtime(i,:),distances,v_taxi,sets,Chrom3(i,:));    
                        % 若违反时间约束
                        if actual_t + distances(sets{route(k-1)}(Chrom3(i,route(k-1))),sets{route(k)}(Chrom3(i,route(k)))) / v_taxi > newtime(i,route(k))
                            rk = route(k);
                            route = route(route ~= rk);
                            route = route(route ~= rk + num_order);
                            index_l = [];   % 选出空车
                            for l=1:length(routes)
                                if isempty(routes{l})
                                    index_l = [index_l, l];   % 记录空车的下标
                                end
                            end
                            rand_taxi = randi(length(index_l),1,1);
                            routes{j} = routes{j}(routes{j} ~= rk);
                            routes{rand_taxi} = [rk, rk + num_order];
                        end
                    end
                    k = k + 1;
                end
            end
        end
        Chrom2(i, (j-1)*max_capacity*2+1 : (j-1)*max_capacity*2+length(route)) = route;  % 将第j辆车的路线加入个体中
    end

end
end

function sorted_routes = priority_sort(routes, pick_up_time)
[~, idx] = sort(pick_up_time(routes));
sorted_routes = routes(idx);
end

function [a, b] = swap(x, y)
    a = y;
    b = x;
end
