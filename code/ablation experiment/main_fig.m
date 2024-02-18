clc
f1 = [445.16 	425.45 	377.60 	372.88
    920.03 	809.19 	780.54 	770.90
    1175.40 	1136.07 	1011.52 	993.07
    1120.77 	1088.05 	970.22 	954.21
    ];
f2 = [3.62 	3.62 	3.67 	3.69
    3.12 	3.26 	3.20 	3.27
    2.50 	2.52 	2.54 	2.58
    2.30 	2.29 	2.29 	2.30
    ];
x = [1 2 3 4];
figure(1);
bar(x,f1)

xlabel('\fontname{Times New Roman}No.')
ylabel('\fontname{Times New Roman}Travel expense')
legend({'\fontname{Times New Roman}RD-NR','\fontname{Times New Roman}RD-TR','\fontname{Times New Roman}RD-PR','\fontname{Times New Roman}RD-TPR'},'FontSize',12);


axis([0.5 4.5 0.0 1300]);
set(gca,'xticklabel',{'1','2','3','4'});
% set(gcf,'Position',[500 500 400 200]);

figure(2);
bar(x,f2)

xlabel('\fontname{Times New Roman}No.')
ylabel('\fontname{Times New Roman}Profit per kilometer')
% legend({'\fontname{Times New Roman}RDR','\fontname{Times New Roman}RDBR','\fontname{Times New Roman}RDPR','\fontname{Times New Roman}RDBPR'},'FontSize',12);
legend({'\fontname{Times New Roman}RD-NR','\fontname{Times New Roman}RD-TR','\fontname{Times New Roman}RD-PR','\fontname{Times New Roman}RD-TPR'},'FontSize',12);

axis([0.5 4.5 0.0 4.5]);
set(gca,'xticklabel',{'1','2','3','4'});