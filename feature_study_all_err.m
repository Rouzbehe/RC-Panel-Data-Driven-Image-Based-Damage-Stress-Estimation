clc; close all; clear all;

numsample=10; option=3;
feat_range=[];feat_range_dis=[];
for range=10:5:98
    
crack_features=FeatureExtraction_comx('segmented_f_M_fiber',range,option,numsample); %segmented_f_M_con_all4 %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber
                                                                    % segmented_f_M_concrete_angle 
 feat=[21];                                                                    
 feat_num=crack_features(:,feat);  feat_dis=crack_features(:,23);

     % featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
           %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
% feat=[2,8,10,20,23];  

% feat_num = X(:,feat);
feat_range=[feat_range,feat_num];
feat_range_dis=[feat_range_dis,feat_dis];


end

feat_range2=[];feat_range_dis2=[];
for range=10:5:98
    
  range  
crack_features2=FeatureExtraction_comx('segmented_f_M_con',range,option,numsample); %segmented_f_M_con_all4 %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber
                                                                    % segmented_f_M_concrete_angle 
 feat_num2=crack_features2(:,feat); feat_dis2=crack_features2(:,23);
     % featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
           %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
% feat=[2,8,10,20,23];  

% feat_num = X(:,feat);
feat_range2=[feat_range2,feat_num2];
feat_range_dis2=[feat_range_dis2,feat_dis2];

end



%%

C = bsxfun(@minus, feat_range(:,1:end),  feat_range(:,end));
error = 100*abs(bsxfun(@rdivide, C, feat_range(:,end)));
ave_error=nanmean(error);


C2 = bsxfun(@minus, feat_range2(:,1:end),  feat_range2(:,end));
error2 = 100*abs(bsxfun(@rdivide, C2, feat_range2(:,end)));
ave_error2=nanmean(error2);

%caluclate feature error vs block size relative to ave distance
% panel size 600*600
for ii=1:size(feat_range_dis,2)
    dis_block_ratio(:,ii)=((ii*5+5)/100*600)./feat_range_dis(:,ii);
    dis_block_ratio2(:,ii)=((ii*5+5)/100*600)./feat_range_dis2(:,ii);
end

block_error=[dis_block_ratio(:),error(:)];
[~,idx]=sort(block_error(:,1));
sorted_block_error=block_error(idx,:);
edges=0:1:max(sorted_block_error(:,1));
% remove NAN stuff
% sorted_block_error(find(isnan(sorted_block_error(:,1))),:) = []; 
[~,binindices]=histc((sorted_block_error(:,1)),edges);
ave_err_bin=arrayfun(@(bin) mean(sorted_block_error(binindices == bin,2)),1:length(edges));
yy1 = smooth(edges,ave_err_bin,0.5,'loess');


block_error2=[dis_block_ratio2(:),error2(:)];
[~,idx2]=sort(block_error2(:,1));
sorted_block_error2=block_error2(idx2,:);
edges2=0:0.5:max(sorted_block_error2(:,1));
% remove NAN stuff
% sorted_block_error(find(isnan(sorted_block_error(:,1))),:) = []; 
[~,binindices2]=histc((sorted_block_error2(:,1)),edges2);
ave_err_bin2=arrayfun(@(bin2) mean(sorted_block_error(binindices2 == bin2,2)),1:length(edges2));
yy2 = smooth(edges2,ave_err_bin2,0.5,'loess');


figure
plot(edges,ave_err_bin,'r*',edges2,ave_err_bin2,'bo','markers',6)
hold on
h1=plot(edges,yy1,'r-',edges2,yy2,'b-','LineWidth',2.);
LEG=legend(h1,'Steel fiber reinforced concrete(SRFC)', 'Reinforced concrete(RC)')
set(LEG,'fontsize',17);
xlabel('Block size to average distance between crakcs ratio','fontsize',14);
ylabel('Average error (%)','fontsize',14);
set(gca,'fontsize',14)
ylim([0 max(max(ave_err_bin),max(ave_err_bin))]);

print('feature_study/both_error_block_Nc','-dpdf', '-r300');


% % combined fiber and concrete



block_error_both=[block_error;block_error2];
[~,idx_both]=sort(block_error_both(:,1));
sorted_block_errorboth=block_error_both(idx_both,:);
edgesboth=0:0.10:max(sorted_block_errorboth(:,1));
% remove NAN stuff
% sorted_block_error(find(isnan(sorted_block_error(:,1))),:) = []; 
[~,binindicesboth]=histc((sorted_block_errorboth(:,1)),edgesboth);
ave_err_bin_both=arrayfun(@(bins) mean(sorted_block_errorboth(binindicesboth == bins,2)),1:length(edgesboth));
yy_both = smooth(edgesboth,ave_err_bin_both,0.2,'loess');


figure
plot(edgesboth,ave_err_bin_both,'k*','markers',5)
hold on
plot(edgesboth,yy_both,'r-','LineWidth',2.6);
LEG=legend('Combined SFRC and RC data', 'Error trend')
% set(LEG,'fontsize',17);
xlabel('Block size to average crack distance ratio','fontsize',14);
ylabel('Average error (%)','fontsize',14);
set(gca,'fontsize',14)
ylim([0 max(max(ave_err_bin),max(ave_err_bin))]);
print('feature_study/combined_block_Ratio_Nc','-dpdf', '-r300');





% figure
% plot([dis_block_ratio(:);dis_block_ratio2(:)],[error(:);error2(:)],'*');
% 
% xlabel('Block size to average distance between crakcs ratio','fontsize',14);
% ylabel('Error (%)','fontsize',14);
% print('feature_study/combined_error_block_AspectRatio_alldata','-dpdf', '-r300');









% figure
% plot(ave_error','r','LineWidth',2.2);
% hold on
% plot(ave_error2','--b','LineWidth',2.2);
% LEG=legend('Steel fiber reinforced concrete(SRFC)', 'Reinforced concrete(RC)')
% set(LEG,'fontsize',17);
% xlabel('Sample block size (%)','fontsize',14);
% ylabel('NMAE (%)','fontsize',14);
% xt = get(gca, 'XTick');
% set(gca, 'XTick', xt, 'XTickLabel', xt*5+10,'fontsize',14);
% print('feature_study/both_error_AspectR','-dpdf', '-r300');


