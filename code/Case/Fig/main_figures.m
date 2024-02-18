data1 = importdata("min_max.txt");
data2 = importdata("init_new.txt");

min_fare = data1(:,1);
max_profit = data1(:,2);

initprofit = data2(:,1);
initfare = data2(:,2);
new_Pareto = data2(:,3:4);

C = [2.510372126, 215.815180414946];
Cp = [3.0734, 196.6526];
cF = 2;
maxG = 2000;


%% 结果展示
figure(1)
plot(1:maxG,min_fare,LineWidth=0.8)
set(gca,'FontName','Times','FontSize',12);
xlabel("Iteration count")
ylabel("Travel expense")


figure(2)
plot(1:maxG,max_profit,LineWidth=0.8)
set(gca,'FontName','Times','FontSize',12);
xlabel("Iteration count")
ylabel("Profit per kilometer")



figure(3)
s1 = scatter(initprofit, initfare, 'b', 'MarkerFaceAlpha',.4,'MarkerEdgeAlpha',.9);
s1.MarkerFaceColor = 'b';
% s1.MarkerEdgeColor = "none";
hold on;
p = plot(C(:,1), C(:,2), 'ko', 'MarkerSize', 8);
p.MarkerFaceColor = [0.9290 0.6940 0.1250];
hold on;
s = scatter(cF-new_Pareto(:,2), new_Pareto(:,1));
s.MarkerEdgeColor = 'r';
s.MarkerFaceAlpha = 0.5;
s.Marker = "o";
hold on;
plot(Cp(1), Cp(2), 'kp', 'MarkerFaceColor','y', 'MarkerSize', 12);
set(gca,'XDir','reverse');   % x轴反向
set(gca,'FontName','Times','FontSize',12);
hold off;
xlabel("Profit per kilometer")
ylabel("Travel expense")
legend('Initial population', 'Center of mass', 'Pareto front','Median of Pareto front')
