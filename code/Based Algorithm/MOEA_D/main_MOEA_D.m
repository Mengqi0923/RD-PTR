clc
clear all
close all

tic
%% 模型数据
points = importdata("points_10min_80.txt");   % 所有集合中的坐标点，包括了原上下车点
% sets_index = importdata("merged_set_index.txt");
distances = importdata("distances_10min_80.txt");   % 距离矩阵
distances_km = distances/1000;

% 读取txt文件
filename = 'merged_set_index_10min_80.txt';
fileID = fopen(filename, 'r');
sets = {};   % 集合中点的下标，每行表示一个集合，每个集合中第一个点是原上下车点

line = fgetl(fileID);
row = 1;
while ischar(line)
    elements = str2double(strsplit(line));
    validElements = elements(~isnan(elements));
    sets{row} = validElements;
    line = fgetl(fileID);
    row = row + 1;
end
fclose(fileID);

% 原上车时间
pick_up_time = importdata("pickup_time_10min_80.txt")'; % 上车时间

% put = pick_up_time(1:4);
% pick_up_time = put;

%%  问题参数设置
num_taxi = length(pick_up_time);                  % 出租车数量
num_order = length(pick_up_time);                 % 订单数量
max_capacity = 2;               % 出租车最大容量
min_time = -10;                 % 最大提前时间偏移
max_time = 10;                  % 最大延后时间偏移
max_detour = 2;                 % 最大绕道率
max_walk = 300;                 % 最大总步行距离300米
v_taxi = 500;                   % 出租车速度 30km/h
v_walk = 100;                   % 步行速度 6km/h

cF = 2;                         % 单位里程价格
cE = 0.5;                       % 单位里程成本
min_fare = 10;                  % 起步价
min_distance = 3;               % 起步价的最大里程（km）
alpha = 0.1;                    % 绕道折扣系数0.1
bata = 0.2;                     % 步行折扣系数
lambd = 0.2;                    % 时间折扣系数

%%  算法参数设置
pop_size = 200;                 % 种群规模
maxG = 2000;                    % 最大迭代次数
w = 0.8;                        % 惯性权重  
c1 = 0.5;                       % 自我学习因子  
c2 = 0.5;                       % 群体学习因子
min_v = -2;                     % 最小速度
max_v = 2;                      % 最大速度

%% 种群初始化

length_code1 = num_taxi * max_capacity * 2;
% 计算原价
[original_fare, original_distances] = originFare(sets,distances,num_order,cF, min_fare, min_distance);

Chrom1 = init1(pop_size, num_order, min_time, max_time);  % 上车时间种群
Chrom3 = init3(sets, pop_size, num_order);  % 上下车点种群
Chrom2 = init2_1(Chrom1, Chrom3, length_code1, pop_size, num_taxi, num_order, max_capacity, pick_up_time, distances,v_taxi,sets, max_detour, original_distances);  % 出租车订单匹配种群

now_time = zeros(pop_size,num_taxi);   % 记录时间

%% 计算初始目标函数

% 计算两个目标值
[total_fare, unit_profit] = ObjectiveFunction(Chrom1, Chrom2, Chrom3, alpha, bata, lambd, sets, num_order, num_taxi, max_capacity, original_fare, original_distances, distances_km ,cE, max_walk, max_detour);
initfare = total_fare;
initprofit = unit_profit;

%% 目标值归一化
normValue= mapminmax([-initfare, initprofit]', 0, 1)';
norm_initfare = normValue(:,1); 
norm_initprofit = normValue(:,2); 

%% 计算适应度
fitness = 0.5 * norm_initfare + 0.5 * norm_initprofit;
[FM,FI] = max(fitness);
gbest = Chrom1(FI,:);
v = (max_v - min_v) * rand(size(Chrom1)) + min_v;   % 初始速度
p1 = 0.3;
p2 = 0.8;
p3 = 0.4;
min_fare = inf(maxG,1);
max_profit = zeros(maxG,1);
Chrom = [Chrom1, Chrom2, Chrom3];
max_fit = zeros(maxG,1); 


% figure(1)  
%% 群体更新  
iter = 1;
while iter <= maxG
    IsChange = zeros(pop_size,1); 
    [newChrom1, newv, IsChange] = UpdateTime_1(Chrom1, Chrom2, num_taxi, max_capacity, min_time, max_time, gbest, v, w, c1, min_v, max_v, p1, IsChange);   % 更新种群1   
    [newChrom3, IsChange] = UpdatePoint(Chrom3, sets, p3, IsChange);                                                         % 更新种群3
    [newChrom2, IsChange] = UpdateRoute_3(Chrom1, Chrom2, newChrom1, newChrom3, pick_up_time, num_order, num_taxi, max_capacity, p2, distances, v_taxi, sets, IsChange);     % 更新种群2
    % 修正函数
    [newChrom1, newChrom2, newChrom3] = correction_1(newChrom1, newChrom2, newChrom3, distances_km, sets, num_taxi, max_capacity, max_detour, original_distances, min_time, max_time, pick_up_time, v_taxi);
    % 计算目标函数值
    [new_total_fare, new_unit_profit] = ObjectiveFunction(newChrom1, newChrom2, newChrom3, alpha, bata, lambd, sets, num_order, num_taxi, max_capacity, original_fare, original_distances, distances_km ,cE, max_walk, max_detour);
    newChrom = [newChrom1, newChrom2, newChrom3];
    % 归一化
    normValue= mapminmax([new_total_fare, new_unit_profit]', 0, 1)';
    norm_fare = normValue(:,1); 
    norm_profit = normValue(:,2); 
    % 计算适应度
    fitness = 0.5 * norm_fare + 0.5 * norm_profit;
    [newChrom, newv] = RouletteWheelSelection(newChrom, newv, fitness, pop_size);
    
    Chrom1 = Chrom(:,1:num_order);
    Chrom2 = Chrom(:,num_order+1:num_order+num_taxi*max_capacity*2);
    Chrom3 = Chrom(:,num_order+num_taxi*max_capacity*2+1:end);
    v = newv;
    
    [total_fare, unit_profit] = ObjectiveFunction(Chrom1, Chrom2, Chrom3, alpha, bata, lambd, sets, num_order, num_taxi, max_capacity, original_fare, original_distances, distances_km ,cE, max_walk, max_detour);

%     min_fare(iter) = min(total_fare);
%     max_profit(iter) = max(unit_profit);
    [FM,FI] = max(fitness);
    max_fit(iter) = FM;
    gbest = Chrom1(FI,:);
    p1 = 0.3 * (1-iter/maxG);   
    p2 = 0.8 * (1-iter/maxG);
    p3 = 0.4 * (1-iter/maxG);
    iter = iter+1;  
end
toc



output = [cF-unit_profit, total_fare];
front = [output(:,1), output(:,2)];
ref = [-1.1, 725];
hv = hypervolume(front, ref);

% [walkdistance,delta,newputime,newDistance, newFare] = Order(Chrom1, Chrom2, Chrom3, pick_up_time, sets, original_distances, distances_km, alpha, bata, lambd,  original_fare, max_detour, max_walk);

