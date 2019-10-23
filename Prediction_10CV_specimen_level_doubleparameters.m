
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
% Images_72 = xlsread('Input','All_f_2');

[Imagess,specimenstxt] = xlsread('Input','All_f_M_concrete_ft_all4');  % All_f_RC   All_f   All_f_M All_f_M_fiber



% Performing num_crossVali fold Cross Validation

%%%%%%%%%the approproate function should be chosen here for All, Recerse cylic and monotonic%%%%%%%%%%%%


 [OUTPUT_Training]=FeatureExtraction('segmented_f_M_con_all4'); %segmented_f_all_190 segmented_f_M  segmented_f_M_con  segmented_f_M_fiber segmented_f_RC
                                                                    % percent50_sampled_segm_f_M_con
                                                                    % percent50_sampled_segm_f_M_fiber

for i=1:size(OUTPUT_Training,1);
crack_features(i,:)=OUTPUT_Training{i,1};
end

X=[crack_features(:,:),Imagess(1:end,3:17)];%3:19 for monotonic-all and fiber     3:17 for monotonic-concrete   3:8 for all  

Specimens_name=[specimenstxt(2:end,1)];

% for i=1:size(OUTPUT_test,1);
% Purdue_crack(i,:)=OUTPUT_test{i,1};
% end
% 
% for i=1:size(OUTPUT_PCA,1);
% PCA_crack(i,:)=OUTPUT_PCA{i,1};
% end


%% Assigning features to model  
clear tvp test train actualClass predictedClass actual_tmp predicted_tmp tvp_stregth feat_num
plotfname='Concrete-con_all3-Mon-Spec_Shear Stress_double_sigma x-sqrt(fc)_Gaussian_Feat-1T23';

% featName = {'Compactness','Aspect Ratio', 'ThreshOut','Entropy', 'Contrast','Correlation','Energy','Homegenity','Variance','Area' ,'Perimeter','EulerNumber','Standard Deviation'};
feat=[1:23];            %16: ave cracks angle % 23: ave crack width 38;ft  39:fiber volume (vf)
classifier=3;  % classifier     1=Support Vector Regression 2=Nearest Neighbor Regression 
                             %   3=Gaussian Process Regression 4=SVM (broght it here from other code 'svmRegressioInMatlab.m')
                             %   5=Linear Rgression    6=MultilayerPerceptron    7=REPTree   8=ZeroR
                             
testfeatNo=[27,27];  % 24: shear Stress (Mpa)  25: Shear STrain (10^-3) 27: Filure ratio (Shear Stress) 28: failre strain ratio 
              % 29: Shear Stress/sqrt(fc)
              % 30: maximum shear stress 
              % 34: max shear stress/sqrt(ft) 35:sigma 1//sqrt(ft)
              % 36:sigma 2//sqrt(ft) 37:sigma x//sqrt(ft)
              
num_crossVali=10;                                                                    
                                                                    





feat_num = X(:,feat);
featName = arrayfun(@num2str, [1:1:length(feat_num(1,:))], 'unif', 0);    
class_num = X(:,testfeatNo);    

    jj=1;
    
    
[un idx_last idx] = unique(Specimens_name,'stable');
unique_idx = accumarray(idx(:),(1:length(idx))',[],@(x) {sort(x)});
% indices = crossvalind('Kfold',size(X,1),num_crossVali);

Spec_idx=cell2mat(unique_idx);

indices = crossvalind('Kfold',size(unique_idx,1),num_crossVali);

for  k = 1:num_crossVali
   test=[];
    id=find(indices == k);
    for m=1:length(id)
        
        test=[test; unique_idx{id(m)}]
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



figure('Position', [100, 100, 1024, 1200]);
tvp=[mean(actualClass,2), nanmean(predictedClass,2)];
tvp2=[mean(actualClass2,2), nanmean(predictedClass2,2)];

%presenting data in %100
% tvp=100*tvp;



% plotCorrelation_histogram3D(tvp,plotfname,tol)

% plotCorrelation_all(tvp,plotfname,testfeatNo)

plotCorrelation_CI_doubleparameter_ft(tvp,tvp2,plotfname,testfeatNo)

