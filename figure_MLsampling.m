clear all;clc;close all


figure
plot([10,20,60,80,100],[78 ,82, 84, 84,86],'o-r','LineWidth',1.8);
hold on
plot([10,20,60,80,100],[71  ,74 , 76, 79 ,86 ],'+-b','LineWidth',1.8);
hold on
plot([10,20,60,80,100],[53 ,66 ,75, 80 ,86 ],'*--k','LineWidth',1.8);
hold on
plot([10,20,60,80,100],[ 70,81 ,85,85 ,86],'s-g','LineWidth',1.8);
hold on
plot([10,20,60,80,100],[ 84, 84 ,85 ,85 ,86],'d-m','LineWidth',1.8);

LEG=legend('Train and Test:resampled from (X to 100)% panel size', 'Train:entire pnel, Test:resampled from (X to 100)% panel size','Train:entire pnel, Test:resampled from X% panel size','Train:resampled from X% panel size, Test:entire pnel','Train:resampled from (X-100) % panel size, Test:entire pnel','Location','SouthEast' )
set(LEG,'fontsize',14);
xlabel('Sample block size(%)','fontsize',14);
ylabel('Index of Agreement (%)','fontsize',14);
set(gca,'fontsize',14)
xlim([10 100]);

print('MLsampling_study/1','-dpdf', '-r300');

