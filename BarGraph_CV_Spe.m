clear all,clc
close all
% data set 1
data = 100*[ 0.16 , 0.17   , 0.18  ,0.21    ;  0.79 ,  0.77 , 0.82  , 0.77 ;0.88   ,0.87    ,  0.89  , 0.87   ;  0.62  , 0.59   , 0.66   ,  0.56  ];

% data = 100*[ 0.15  , 0.14  ,0.16  , 0.15  ; 0.82  , 0.85  , 0.80  , 0.83 ; 0.91  , 0.92 , 0.89 ,  0.91 ; 0.67  ,  0.71 ,  0.63 , 0.69  ];


fH = gcf; colormap(jet(4));
Labels = {'RMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('Image level-Failure Ratio-Aspec ratio,homogeneity, crack length, I_{p}, No cracks','Specimen level-Failure Ratio-Aspec ratio,homogeneity, crack length, I_{p}, No cracks','Image level-\tau/\surd{f_t}-homogeneity-crack length, I_{p}, No cracks, ave crack distance','Specimen level-\tau/\surd{f_t}-homogeneity-crack length, I_{p}, No cracks, ave crack distance','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))


% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_All','-dpng', '-r1000');

%% Data set 2
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
data = 100*[ 0.31  ,0.32   ,0.32   , 0.33   ;  0.84  , 0.83 ,  0.82 , 0.82  ; 0.91  ,  0.9  ,0.89  ,  0.89  ; 0.7   , 0.69  ,0.67    ,   0.67 ];

% data = 100*[   ,   ,   ,    ;   ,    ,   ,   ;   ,   ,  ,    ;    ,   ,    ,    ];
% 

fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('Image level-entire panel-Aspect ratio,homogeneity,length, ave crack distance','Specimen level-entire panel-Aspect ratio,homogeneity,length, ave crack distance','Image level-50% subsampled-Aspect ratio,homogeneity,length, ave crack distance','Image level-30% subsampled-Aspect ratio,homogeneity,length, ave crack distance','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_maxshear-ft','-dpng', '-r1000');

%% paper figure 3

clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
data = 100*[ 0.18  , 0.19  , 0.43  ,  0.39  ; 0.85  ,  0.82  , 0.83  , 0.86  ; 0.92  ,0.9  , 0.91 , 0.92   ; 0.72   , 0.68  ,  0.69  , 0.74   ];



fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('Image level-\tau/\surd{f_t}-homogeneity-crack length, I_{p}, No cracks, ave crack distance','Specimen level-\tau/\surd{f_t}-homogeneity-crack length, I_{p}, No cracks, ave crack distance','Image level-\sigma_{2}/\surd{f_t}-Aspect ratio-homogeneity-crack length, ave crack distance','Specimen level-\sigma_{2}/\surd{f_t}-Aspect ratio-homogeneity-crack length, ave crack distance','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_monotonic-sigma2-shear-ft','-dpng', '-r1000');

%% Data set 2
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
data = 100*[ 0.16  ,  0.17  , 0.17   , 0.18    ; 0.77   , 0.72  ,  0.72  , 0.7 ; 0.86   , 0.84    , 0.84 , 0.82   ; .59   ,  0.48  ,0.50     ,  0.48   ];
% data = 100*[    ,    ,    ,     ;    ,   ,    ,  ;    ,     ,  ,    ;    ,    ,     ,     ];

% data = 100*[   ,   ,   ,    ;   ,    ,   ,   ;   ,   ,  ,    ;    ,   ,    ,    ];
% 

fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('No sampling-Entire panel','10 resampling-Training and test from 80-100 % resampled blocks','10 resampling-Training and test from 60-100 % resampled blocks','10 resampling-Training and test from 20-100 % resampled blocks','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_sampling','-dpng', '-r1000');

%% Data set 2
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
% data = 100*[ 0.16  ,  0.17  , 0.17   , 0.18    ; 0.77   , 0.72  ,  0.72  , 0.7 ; 0.86   , 0.84    , 0.84 , 0.82   ; .59   ,  0.48  ,0.50     ,  0.48   ];
data = 100*[ 0.16   , 0.21   ,0.2    ,   0.17  ; 0.77   ,  0.56 ,  0.62  , 0.7 ;   0.86 ,   0.71  ,0.74  ,   0.8 ; 0.59   , 0.29   ,  0.37   ,  0.48   ];

% data = 100*[   ,   ,   ,    ;   ,    ,   ,   ;   ,   ,  ,    ;    ,   ,    ,    ];
% 

fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('No sampling-Entire panel','Training from entire panel-Test from 30 % resampled blocks','Training from entire panel-Test from 50 % resampled blocks','Training from entire panel-Test from 80 % resampled blocks','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_sampling2','-dpng', '-r1000');


%% Data set 2
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
% data = 100*[ 0.16  ,  0.17  , 0.17   , 0.18    ; 0.77   , 0.72  ,  0.72  , 0.7 ; 0.86   , 0.84    , 0.84 , 0.82   ; .59   ,  0.48  ,0.50     ,  0.48   ];
data = 100*[ 0.16   ,  0.21  , 0.19   , 0.18   ; 0.77   ,0.55  , 0.64   , .68 ;   0.86 , 0.71   , .76 , .79  ; 0.59   ,0.27  , .4   ,  .45   ];

% data = 100*[   ,   ,   ,    ;   ,    ,   ,   ;   ,   ,  ,    ;    ,   ,    ,    ];
% 

fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('No sampling-Entire panel','Training from entire panel-Test from 10-100 % resampled blocks','Training from entire panel-Test from 60-100 % resampled blocks','Training from entire panel-Test from 80-100 % resampled blocks','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_sampling3','-dpng', '-r1000');
%% Data set 2
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
% data = 100*[ 0.16  ,  0.17  , 0.17   , 0.18    ; 0.77   , 0.72  ,  0.72  , 0.7 ; 0.86   , 0.84    , 0.84 , 0.82   ; .59   ,  0.48  ,0.50     ,  0.48   ];
% data = 100*[ 0.16   ,  0.21  , 0.19   , 0.18   ; 0.77   ,0.55  , 0.64   , .68 ;   0.86 , 0.71   , .76 , .79  ; 0.59   ,0.27  , .4   ,  .45   ];

data = 100*[ 0.16  , 0.26  , 0.21  ,  0.19  ;  0.77 , 0.27   ,  0.64 , 0.7  ; 0.86  , 0.53  ,0.7 ,0.81    ;  0.59  , 0.0  ,  0.4  , 0.49   ];
% 

fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('(Case 0) Training: entire panel-Test: entire panel','(Case III) Training: entire panel-Test: 10-100 % resampled blocks','(Case IV) Training: 10 % resampled blocks-Test: entire panel','(Case IV) Training: 20 % resampled blocks-Test: entire panel','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//cc', 0, [0 1 0 1], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('Performance_sampling4','-dpng', '-r1000');

%%
clear all,clc
close all
% data set 1

% data2 = 100*[ 0.33, 0.37, 0.39,0.36 ,0.45  ,0.28 , 0.29,0.28 , 0.32, 0.35;0.9 ,0.86 ,0.86 ,0.9 , 0.87 ,0.91 ,0.9 ,0.91 ,0.9 ,0.88 ;0.94 ,0.92 ,0.92 ,0.94 ,0.92  ,0.95 , 0.94,0.95 ,0.94 ,0.93 ; 0.81,0.72 , 0.72,0.77 ,0.66  ,0.83 ,0.81 ,0.82 , 0.8,0.77];
data = 100*[ 0.32  , 0.19  ,0.39  ; 0.83 , 0.82  , 0.86  ; 0.9 ,0.9   , 0.92   ; 0.69, 0.68  , 0.74   ];



fH = gcf; colormap(jet(4));
Labels = {'NRMSE (error)', '(R)', 'IA','Explained variance Score'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
h=bar(data);
ylabel('Performance of models (%)')
ybuff=1;

for i=1:length(h)
    XDATA=get(get(h(i),'Children'),'XData');
    YDATA=get(get(h(i),'Children'),'YData');
    for j=1:size(XDATA,2)
        x=XDATA(1,j)+(XDATA(3,j)-XDATA(1,j))/2;
        y=YDATA(2,j)+ybuff;
        t=[num2str(YDATA(2,j),3), '%' ];
        text(x,y,t,'Color','k','HorizontalAlignment','left','Rotation',90)
    end
end
legend('\tau_{max}/\surd{f_t}-aspect ratio, homogeneity, L_{c}, ave crack distance','\tau/\surd{f_t}-homogeneity-L_{c}, I_{p}, N_{c}, ave crack distance','\sigma_{2}/\surd{f_t}-aspect ratio, homogeneity-L_{c}, ave crack distance','Location','NorthOutside')
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);

ylim([0 110])
applyhatch_pluscolor(fH,'//c', 0, [0 1 0], jet(4))

% applyhatch_pluscolor(gcf,'|-.+\',0,[1 1 0 1 0 ],cool(5),200,3,2)
% legend('baseline','SVM using Wavelet feat','SVM using Geometrical feat','J48 using Geometrical feat','SVM+J48 Geometrical feat','Position','bestoutside')
print('performance_mix','-dpng', '-r1000');
