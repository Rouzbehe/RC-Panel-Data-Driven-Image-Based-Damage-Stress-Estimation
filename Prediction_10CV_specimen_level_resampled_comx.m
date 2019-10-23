
clear all; close all;clc;

%% Initializing 
% adding the path to matlab2weka codes
addpath([pwd filesep 'matlab2weka']);
% adding Weka Jar file
if strcmp(filesep, '\')% Windows    
    javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
elseif strcmp(filesep, '/')% Mac OS X
    javaaddpath('/Applications/weka-3-6-12/weka.jar')
end
% adding matlab2weka JAR file that converts the matlab matrices (and cells)
% to Weka instances.
javaaddpath([pwd filesep 'matlab2weka' filesep 'matlab2weka.jar']);

%%%%%%%%%the approproate excel sheet should be chosen here %%%%%%%%%%%%  

[Imagess,specimenstxt] = xlsread('Input','All_f_M');  % All_f_M_concrete_ft  All_f_RC   All_f   All_f_M  All_f_M_fiber  All_f_M_fiber_ft
                                          % All_f_M_concrete_ft_all4  ft_all4 all con except PL1 & 4
                                          % ft_all3 all con except PL4 & 6
                                                                        

numsample=10; range=[30 98]; option=2;

crack_features=FeatureExtraction_comx('segmented_f_M',range,option,numsample); %segmented_f_M_fiber  %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC



Specimens_name=[specimenstxt(2:end,1)];
Specimens_name=repmat(Specimens_name,1,numsample)';
Specimens_name=Specimens_name(:);
% to repeat each row of excel data "numsample" times
Imagess=kron(Imagess(:,:), ones(numsample,1));

X=[crack_features(:,:),Imagess(:,3:22)];%3:19 for fiber     3:22 for monotonic-concrete   3:8 for all  

sigma_x=(-X(:,37))/2+(-X(:,37))/2.*cosd(2*X(:,22))+X(:,29).*sind(2*X(:,22));
T_x=-(-X(:,37))/2.*sind(2*X(:,22))+X(:,29).*cosd(2*X(:,22));




X=[X(:,1:28),T_x,X(:,30:36),-sigma_x,X(:,38:39)];
% to modify the new stress state in new rotated resampled blocks
%for fiber
tetha_sigma=90-0.5*atand(abs(2*X(:,24)./X(:,33)));







new_tetha=tetha_sigma+X(:,22);


% random tehta between 0-180
for ii=1:length(new_tetha)
    
   if new_tetha(ii)>180;
        new_tetha(ii)=new_tetha(ii)-180;
   end
end


X=[X,new_tetha];

%%
close all
clear tvp test train actualClass predictedClass actual_tmp predicted_tmp tvp_stregth feat_num
plotfname='all-30-100-opt2--tetha';

% plotfname='uniform-30-100-sample-opt-4-measured theta';

% plotfname='trial9-Uniform-20samples';

% featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
feat=[6,10,20,21,23];            %16: ave cracks angle % 18: scale , 22:randomtheta , 23: ave crack width 38;ft  39:fiber volume (vf)
classifier=4;  % classifier     1=Support Vector Regression 2=Nearest Neighbor Regression 
                             %   3=Gaussian Process Regression 4=SVM (broght it here from other code 'svmRegressioInMatlab.m')
                             %   5=Linear Rgression    6=MultilayerPerceptron    7=REPTree   8=ZeroR
                             
testfeatNo=[27,27];  % 24: shear Stress (Mpa)  25: Shear STrain (10^-3) 27: Filure ratio (Shear Stress) 28: sigma 2/(ft)
              % 29: Shear Stress/sqrt(fc)or ft
              % 30: maximum shear stress 
              % 34: max shear stress/sqrt(ft) or ft 35:sigma 1//sqrt(ft) or ft
              % 36:sigma 2//sqrt(ft) or ft 37:sigma x/sqrt(ft) or ft
              % 40: pribciple stress Theta
              
num_crossVali=10;                                                                    
                                                                    


% fix this later X(;,16) is Nan for some wierd reason
% X(isnan(X))=0;


% feat_num = X(:,feat);
feat_num = zscore(X(:,feat));

featName = arrayfun(@num2str, [1:1:length(feat_num(1,:))], 'unif', 0);    
class_num = X(:,testfeatNo);    

    jj=1;
    
    
[un idx_last idx] = unique(Specimens_name,'stable');
unique_idx = accumarray(idx(:),(1:length(idx))',[],@(x) {sort(x)});
% indices = crossvalind('Kfold',size(X,1),num_crossVali);

Spec_idx=cell2mat(unique_idx);

indices = crossvalind('Kfold',size(unique_idx,1),num_crossVali);
% 
for  k = 1:num_crossVali
    k
   test=[];
    id=find(indices == k);
    for m=1:length(id)
        
        test=[test; unique_idx{id(m)}];
    end
%     train = unique_idx{(k~=indices)};
    train=Spec_idx(~ismember(Spec_idx,test));
%     train = Spec_idx(~(Spec_idx==unique_idx{k}));
    

    
    feature_train = feat_num(train,:);
    class_train = class_num(train,1);
    class_train2 = class_num(train,2);

    feature_test = feat_num(test,:);
    class_test = class_num(test,1);
    class_test2 = class_num(test,2);

    %performing regression
    [actual_tmp, predicted_tmp, stdDev_tmp] = wekaRegression(feature_train, class_train, feature_test, class_test, featName, classifier);
    [actual_tmp2, predicted_tmp2, stdDev_tmp2] = wekaRegression(feature_train, class_train2, feature_test, class_test2, featName, classifier);

    %accumulating the results
    actualClass(ismember(Spec_idx,test),:) = actual_tmp;
    predictedClass(ismember(Spec_idx,test),:) = predicted_tmp;   

    actualClass2(ismember(Spec_idx,test),:) = actual_tmp2;
    predictedClass2(ismember(Spec_idx,test),:) = predicted_tmp2;  
    

    clear feature_train class_train feature_test class_test
    clear actual_tmp predicted_tmp probDistr_tmp 

end
% % 


figure('Position', [100, 100, 1024, 1200]);
% tvp=[mean(actualClass,2), nanmean(predictedClass,2)];
% tvp2=[mean(actualClass2,2), nanmean(predictedClass2,2)];

tvp=[new_tetha,X(:,16)];

%presenting data in %100
% tvp=100*tvp;



% plotCorrelation_histogram3D(tvp,plotfname,tol)

plotCorrelation_CI(tvp,plotfname,41)

% plotCorrelation_CI_doubleparameter(tvp,tvp2,plotfname,testfeatNo)

% plotCorrelation_CI_doubleparameter_ft(tvp,tvp2,plotfname,testfeatNo)

% plotCorrelation_CI_doubleparameter_ft_3d(tvp,tvp2,plotfname,testfeatNo)

% 
% figure
% plot(new_tetha,X(:,16),'.')
% hold on
% plot([min(new_tetha),max(new_tetha)],[min(new_tetha),max(new_tetha)],'k')
% 
% figure
%  tvp_t=[new_tetha,X(:,16)];
%  plotCorrelation_CI(tvp_t,'case4-calculated_tetha',41)

% 
% plotCorrelation_CI_doubleparameter_ft_3d(tvp,tvp,'random thetha distributiontry2',testfeatNo)

% plot(X(:,22),'.')
