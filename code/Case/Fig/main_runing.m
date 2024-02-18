clc
data = importdata('runingdata.txt');
initfare = data(:,1);
bestfare = data(:,2);
initprofit = data(:,3);
bestprofit = data(:,4);

figure(1)
plot(initfare, LineWidth=1.5)
hold on
plot(bestfare, LineWidth=1.5)
set(gca,'FontName','Times','FontSize',12);
ylim([160 230])
xlabel('Times of run');
ylabel("Travel expense")
legend('Initial value', 'Optimal value')


figure(2)
plot(initprofit, LineWidth=1.5)
hold on
plot(bestprofit, LineWidth=1.5)
set(gca,'FontName','Times','FontSize',12);
ylim([1 4])
xlabel('Times of run');
ylabel("Profit per kilometer")
legend('Initial value', 'Optimal value')

var(bestprofit)