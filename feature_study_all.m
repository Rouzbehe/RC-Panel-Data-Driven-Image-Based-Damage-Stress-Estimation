clc; close all; clear all;

numsample=10; option=3;
feat_range=[];
for range=10:5:98
    
crack_features=FeatureExtraction_comx('segmented_f_M_fiber',range,option,numsample); %segmented_f_M_con_all4 %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber
                                                                    % segmented_f_M_concrete_angle 
 feat=[21];                                                                    
 feat_num=crack_features(:,feat);
     % featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
           %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
% feat=[2,8,10,20,23];  

% feat_num = X(:,feat);
feat_range=[feat_range,feat_num];
end

feat_range2=[];
for range=10:5:98
    
  range  
crack_features2=FeatureExtraction_comx('segmented_f_M_con',range,option,numsample); %segmented_f_M_con_all4 %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber
                                                                    % segmented_f_M_concrete_angle 
 feat_num2=crack_features2(:,feat);
     % featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
           %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
% feat=[2,8,10,20,23];  

% feat_num = X(:,feat);
feat_range2=[feat_range2,feat_num2];
end



%%

C = bsxfun(@minus, feat_range(:,1:end),  feat_range(:,end));
error = abs(bsxfun(@rdivide, C, feat_range(:,end)));
ave_error=nanmean(error)*100;

C2 = bsxfun(@minus, feat_range2(:,1:end),  feat_range2(:,end));
error2 = abs(bsxfun(@rdivide, C2, feat_range2(:,end)));
ave_error2=nanmean(error2)*100;

figure
plot(ave_error','r','LineWidth',2.2);
hold on
plot(ave_error2','--b','LineWidth',2.2);
LEG=legend('Steel fiber reinforced concrete(SRFC)', 'Reinforced concrete(RC)')
set(LEG,'fontsize',17);
xlabel('Sample block size (%)','fontsize',14);
ylabel('NMAE (%)','fontsize',14);
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', xt*5+10,'fontsize',14);
print('feature_study/both_error_Ncc','-dpdf', '-r300');


