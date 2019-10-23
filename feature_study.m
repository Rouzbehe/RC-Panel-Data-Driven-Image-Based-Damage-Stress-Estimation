clc; close all; clear all;





numsample=10; option=3;
nn=8;
feat_range=[];
for range=10:5:97
    
  %range %
crack_features=FeatureExtraction_comx('fiber_sample',range,option,numsample); %segmented_f_M_con_all4 %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber
                                                                    % segmented_f_M_concrete_angle 
                                                                    
 X=[crack_features(:,:)];
     % featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
feat=[8];            %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
% feat=[2,8,10,20,23];  

feat_num = X(:,feat);
feat_range=[feat_range,feat_num];
end

%%

figure
plot(feat_range','-')
xlabel('Sample block size (%)','fontsize',14);
ylabel('Average distance between cracks','fontsize',14);
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', xt*5+10,'fontsize',14);
print('feature_study/Homegenity_a','-dpdf', '-r300');

