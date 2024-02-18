clc
clear all
close all

data = importdata("percentage_data.txt");
UO = data(1:5,:);
time = data(6:10,:);

x = [0, 25, 50, 75, 100];

figure(1)
plot(x,UO(:,1)','-ob',LineWidth=1,MarkerSize=7,MarkerFaceColor='auto');
axis([-10,110,900,1100])
set(gca,'XTick', [0:25:100])
xtickformat('percentage')
xlabel('Percentage of orders that accept recommendations','FontName','Times New Roman','FontSize',12)
ylabel('Travel expense','FontName','Times New Roman','FontSize',12)

figure(2)
plot(x,UO(:,2)','-*r',LineWidth=1,MarkerSize=7);
axis([-10,110,2,3])
set(gca,'XTick', [0:25:100])
xtickformat('percentage')
xlabel('Percentage of orders that accept recommendations','FontName','Times New Roman','FontSize',12)
ylabel('Profit per kilometer','FontName','Times New Roman','FontSize',12)

figure(3)
plot(x,time(:,1)','-ob',LineWidth=1,MarkerSize=7,MarkerFaceColor='auto');
axis([-10,110,900,1100])
set(gca,'XTick', [0:25:100])
xtickformat('percentage')
xlabel('Percentage of orders that accept recommendations','FontName','Times New Roman','FontSize',12)
ylabel('Travel expense','FontName','Times New Roman','FontSize',12)

figure(4)
plot(x,time(:,2)','-*r',LineWidth=1,MarkerSize=7);
axis([-10,110,2,3])
set(gca,'XTick', [0:25:100])
xtickformat('percentage')
xlabel('Percentage of orders that accept recommendations','FontName','Times New Roman','FontSize',12)
ylabel('Profit per kilometer','FontName','Times New Roman','FontSize',12)