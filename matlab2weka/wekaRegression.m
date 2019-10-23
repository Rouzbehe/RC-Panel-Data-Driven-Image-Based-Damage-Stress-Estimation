function [actual, predicted, stdDev] = wekaRegression(featTrain, classTrain, featTest, classTest, featName, classifier)
% Perform regression algorithms in the WEKA package
%
% featTrain      - A NUMERIC matrix of training features (Ntr x M)
%
% classTrain     - A NUMERIC vector representing the values of the
%                  dependent variable of the training data (Ntr x 1)
%
% featTest      - A NUMERIC matrix of testing features (Nts x M)
%
% classTest     - A NUMERIC vector representing the values of the
%                  dependent variable of the testing data (Nts x 1)
%
% featName    - The CELL vector of string representing the label of each 
%                 features, (1 x M) cell
%
% classifier    - 1 = Support Vector Regression
%               - 2 = Nearest Neighbor Regression
%               - 3 = Gaussian Process Regression
%               - 4 = SOM regression (broght it here from other code 'svmRegressioInMatlab.m')
%               - 5 = Linar Rgression
%               - 6 = MultilayerPerceptron
%               - 7 = REPTree
%               - 8 = ZeroR
% Written by Sunghoon Ivan Lee, All copy rights reserved, 2/20/2015 
% http://www.sunghoonivanlee.com

import matlab2weka.*;

%% Converting to WEKA data  
display('    Converting Data into WEKA format...');
%convert the training data to an Weka object
convert2wekaObj = convert2weka('test',featName, featTest', classTest, true); 
ft_test_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;

%convert the testing data to an Weka object
convert2wekaObj = convert2weka('training', featName, featTrain', classTrain, true); 
ft_train_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;
display('    Converting Completed!');

%% Training the regression model
display('    Classifying...');
if(classifier == 1)
    import weka.classifiers.functions.SMOreg.*;
    import weka.classifiers.functions.supportVector.RBFKernel.*;
    import weka.classifiers.functions.supportVector.PolyKernel.*;
	%create an java object
    trainModel = weka.classifiers.functions.SMOreg();
	%defining parameters
    trainModel.setC(1.0);
        trainKernel = weka.classifiers.functions.supportVector.RBFKernel();
        trainKernel.setGamma(0.01);
        trainKernel.buildKernel(ft_train_weka);        
%         trainKernel = weka.classifiers.functions.supportVector.PolyKernel(); %<x,y>^p
%         trainKernel.setExponent(1);
%         trainKernel.buildKernel(ft_train_weka);
    trainModel.setKernel(trainKernel);
        trainOptimizer = weka.classifiers.functions.supportVector.RegSMOImproved();
%         trainOptimizer.setEpsilon(1.0E-12);
%         trainOptimizer.setEpsilonParameter(0.001);
%         trainOptimizer.setSeed(1);
%         trainOptimizer.setTolerance(1);
%         trainOptimizer.setUseVariant1(true);
    trainModel.setRegOptimizer(trainOptimizer);
	%train the regression model
    trainModel.buildClassifier(ft_train_weka);      
elseif(classifier == 2)
    import weka.classifiers.lazy.IBk.*;
    import weka.core.neighboursearch.*;
    import weka.core.EuclideanDistance.*;   
	%create an java object    
    NNBestFeat = floor(ft_train_weka.numInstances()/10); %nearest neighbor
    
    %KNN Regression model
    trainModel = weka.classifiers.lazy.IBk(); 
	%defining parameters
        % setting the search function for KNNReg
        NNSearch = weka.core.neighboursearch.LinearNNSearch();
            % setting the distance measure for NNSearch
            distFunc = weka.core.EuclideanDistance();
            distFunc.setDontNormalize(false);
            distFunc.setInvertSelection(false);
            distFunc.setAttributeIndices('first-last');
        NNSearch.setDistanceFunction(distFunc);
        NNSearch.setMeasurePerformance(false);
        NNSearch.setSkipIdentical(false);
    trainModel.setNearestNeighbourSearchAlgorithm(NNSearch);
    trainModel.setKNN(NNBestFeat);
    trainModel.setCrossValidate(false);
	%train the regression model
    trainModel.buildClassifier(ft_train_weka);
elseif(classifier == 3)
    import weka.classifiers.functions.GaussianProcesses.*;
    import weka.classifiers.functions.supportVector.RBFKernel.*;
    import weka.classifiers.functions.supportVector.PolyKernel.*;
    import weka.classifiers.functions.supportVector.Puk.*;
	%create an java object    
    trainModel = weka.classifiers.functions.GaussianProcesses();
	%defining parameters
    trainKernel = weka.classifiers.functions.supportVector.RBFKernel(); % work best with Gamma 1
%     trainKernel.setGamma(1.0);
%     trainKernel.setCacheSize(250007);  
    trainKernel.setGamma(1.0);
    trainKernel.setCacheSize(250007);     
    
        %trainKernel =weka.classifiers.functions.supportVector.PolyKernel(); %<x,y>^p
        %work worst
        %trainKernel.setExponent(1);
    %trainKernel = weka.classifiers.functions.supportVector.Puk();

    trainKernel.buildKernel(ft_train_weka);
    trainModel.setNoise(0.1); %0.25/0.3 works best for stress FR /0.1 work best for others
    trainModel.setKernel(trainKernel);
	%train the regression model
    trainModel.buildClassifier(ft_train_weka);      
    
elseif(classifier == 4)    
    import weka.classifiers.functions.supportVector.*
    import weka.core.converters.ConverterUtils$DataSource.*
    
% SELECT THE SVM REGRESSION TOOL
% svmReg.getOptions() will tell you what the default values are
% methods(svmReg) will tell you what functions are available
    trainModel = weka.classifiers.functions.SMOreg();     
    trainModel.setC(1.0);
  
% SELECT THE OPTIMIZER
r = weka.classifiers.functions.supportVector.RegSMOImproved();
    % -L epsilon. default = 1.0e-3 (work best)
    % -W rand seed. default = 1
    % -P precision. default = 1.0e-12
    % -T tolerance. default = 0.0010
    % -V variant. true=1 else 2
    % CAN USE THE setOptions METHOD OR SPECIFIC FUNCTIONS LIKE setSeed and
    % setEpsilon. Use "methods(r)" to see what they are
    w(1) = java.lang.String('-W');
    w(2) = java.lang.String(sprintf('%I',1));
%     w(2) = java.lang.String(sprintf('%f',0.00001));
    ropts = cat(1,w(1:end));
    r.setOptions(ropts);
    r.setUseVariant1(true);
    trainModel.setRegOptimizer(r);    

% SELECT THE PUK KERNEL
    trainKernel = weka.classifiers.functions.supportVector.Puk();
    trainKernel.setOmega(1.0);
    trainKernel.setSigma(1.0);
    trainModel.setKernel(trainKernel);  

% NOW BUILD THE SVM
    trainModel.buildClassifier(ft_train_weka);
    
elseif(classifier == 5)   
    import weka.classifiers.functions.LinearRegression.*
    
    trainModel = weka.classifiers.functions.LinearRegression();
    
%     w(1) = java.lang.String('-F');
%     w(2) = java.lang.String(sprintf('%f',1));
%     ropts = cat(1,w(1:end));
%     trainModel.setOptions(ropts);
    
    trainModel.buildClassifier(ft_train_weka);
    
elseif(classifier == 6)   
    import weka.classifiers.functions.weka.classifiers.functions.MultilayerPerceptron.*
    
    trainModel = weka.classifiers.functions.MultilayerPerceptron();    
    trainModel.buildClassifier(ft_train_weka);

    
elseif(classifier == 7)   
    import weka.classifiers.trees.REPTree.*
    
    trainModel = weka.classifiers.trees.REPTree();  
    
% Define number of folds to be 10    
    w(1) = java.lang.String('-N');
    w(2) = java.lang.String(sprintf('%I',15));
    ropts = cat(1,w(1:end));
    trainModel.setOptions(ropts);
    
    trainModel.buildClassifier(ft_train_weka);    

elseif(classifier == 8)   
    import weka.classifiers.rules.ZeroR.*
    
    trainModel = weka.classifiers.rules.ZeroR();    
    trainModel.buildClassifier(ft_train_weka);      
end

%% Making Predictions
actual = zeros(ft_test_weka.numInstances(), 1); %actual labels
predicted = zeros(ft_test_weka.numInstances(), 1); %predicted labels
stdDev = zeros(ft_test_weka.numInstances(), ft_train_weka.numClasses()); %standard deviation of the predictions (e.g., Gaussian Regression)
%the following loop is very slow. We may consider implementing the
%following in JAVA
for z = 1:ft_test_weka.numInstances()
    actual(z,1) = ft_test_weka.instance(z-1).classValue();
    predicted(z,1) = trainModel.classifyInstance(ft_test_weka.instance(z-1));
end    
display('    Classification Completed!');