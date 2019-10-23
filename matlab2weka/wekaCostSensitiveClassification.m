function [actual, predicted, probDistr] = wekaCostSensitiveClassification(featTrain, classTrain, featTest, classTest, featName, costMatrix, classifier)
% Perform cost sensitive classifier in the WEKA package
% 
% ///////////// INPUTS ////////////////
% featTrain      - A NUMERIC matrix of training features (Ntr x M)
%
% classTrain     - A CELL vector representing the values of the
%                  dependent variable of the training data (Ntr x 1)
%
% featTest      - A NUMERIC matrix of testing features (Nts x M)
%
% classTest     - A CELL vector representing the values of the
%                  dependent variable of the testing data (Nts x 1)
%
% featName    - The CELL vector of string representing the label of each 
%                 features, (1 x M) cell
%
% costMatrix    - A NUMERIC matrix (C x C) representing the cost matrix. 
%				- For an example of a cost matrix [0, C12; C21, 0], 
%				  C12 represents the cost for misclassifying 'class_1' to 'class_2', and
%				  C21 represents the cost for misclassifying 'class_2' to 'class_1'.
%
% classifier    - 1 = Random Forest
%               - 2 = J48 Decision Tree
%               - 3 = SVM
%               - 4 = Logistic Regression
%
% ///////////// OUTPUTS ////////////////
% actual        - A CELL vector representing the values of the actual label 
%                 of the test dataset. It implies that this vector should  
%                 be equal to "classTest" input. 
%
% predicted     - A CELL vector representing the values of the predicted 
%                 class of the test dataset. 
%
% probDistr     - A NUMERIC vector that represents the class probability of
%                 the predictions. Each column represents the probability
%                 of an instance (row) belonging to that specific class. 
%
% Written by Sunghoon Ivan Lee, All copy rights reserved, 2/20/2015 
% http://www.sunghoonivanlee.com

import matlab2weka.*;
import weka.classifiers.meta.CostSensitiveClassifier.*;
import weka.classifiers.CostMatrix.*;

%% Converting to WEKA data  
display('    Converting Data into WEKA format...');
numExtraClass = 0;
if (classifier == 1 && length(unique(classTest)) ~= length(unique(classTrain)))
    % Weka algorithms creates an error (e.g., Random Forest) when 
	% the number of classes in the training set does not match the
	% number of classes in the testing set. Thus, here we add a 
	% dummy data points at the end of the "testing dataset" to match 
	% the number of classes. These dummy data points are not included
	% in the results

    % First take the list of test classes
    uTestClasses = unique(classTest);
    
    % Then, we forcefully add the classes that is not in the test class 
    % to the testing data.    
    tmp_idx = 1;        
    uTrainClasses = unique(classTrain);
    for iclass = 1:length(uTrainClasses)
        if (sum(ismember(uTestClasses, uTrainClasses{iclass})) == 0)
            featTest = vertcat(featTest, featTest(end,:));
            classTest = vertcat(classTest, uTrainClasses{iclass});
            tmp_idx = tmp_idx + 1;
        end
    end
    numExtraClass = tmp_idx - 1;
end

%convert the training data to an Weka object
convert2wekaObj = convert2weka('test',featName, featTest', classTest, true); 
ft_test_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;

%convert the testing data to an Weka object
convert2wekaObj = convert2weka('training', featName, featTrain', classTrain, true); 
ft_train_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;
display('    Converting Completed!');

%% Choosing the Classifier
display('    Classifying...');
if (classifier == 1)
    import weka.classifiers.trees.RandomForest.*;
    import weka.classifiers.meta.Bagging.*;
	%create an java object
    trainModel = weka.classifiers.trees.RandomForest();
	%defining parameters
    trainModel.setMaxDepth(0); %Set the maximum depth of the tree, 0 for unlimited.
    trainModel.setNumFeatures(0); %Set the number of features to use in random selection.
    trainModel.setNumTrees(100); %Set the value of numTrees.
    trainModel.setSeed(1);
	%train the classifier
    trainModel.buildClassifier(ft_train_weka);   
    %trainModel.toString()  
elseif(classifier == 2)
    import weka.classifiers.trees.J48.*;   
	%create an java object
    trainModel = weka.classifiers.trees.J48();
	%defining parameters
    trainModel.setConfidenceFactor(0.25); %Set the value of CF.
    trainModel.setMinNumObj(2); %Set the value of minNumObj.
    trainModel.setNumFolds(3);
    trainModel.setSeed(1);
	%train the classifier
    trainModel.buildClassifier(ft_train_weka);   
elseif(classifier == 3)
    import weka.classifiers.functions.SMO.*;
    import weka.classifiers.functions.supportVector.RBFKernel.*;
    import weka.classifiers.functions.supportVector.PolyKernel.*;
    import weka.classifiers.functions.supportVector.Puk.*;
	%create an java object
    trainModel = weka.classifiers.functions.SMO();
	%defining parameters
    trainModel.setC(1.0);
    trainModel.setEpsilon(1.0E-12);
    trainModel.setNumFolds(-1);
    trainModel.setRandomSeed(1);
    trainModel.setToleranceParameter(0.001);
%         trainKernel = weka.classifiers.functions.supportVector.RBFKernel();
%         trainKernel.setGamma(0.01);     
%         trainKernel = weka.classifiers.functions.supportVector.PolyKernel(); %<x,y>^p
%         trainKernel.setExponent(1);
        trainKernel = weka.classifiers.functions.supportVector.Puk();

        trainKernel.buildKernel(ft_train_weka);
    trainModel.setKernel(trainKernel);
	%train the classifier
    trainModel.buildClassifier(ft_train_weka);        
elseif(classifier == 4)
    import weka.classifiers.functions.Logistic.*;
	%create an java object
    trainModel = weka.classifiers.functions.Logistic();
	%defining parameters
    trainModel.setMaxIts(-1); %Set the value of MaxIts.
    trainModel.setRidge(1.0E-8);
	%train the classifier
    trainModel.buildClassifier(ft_train_weka);        
end

%% initializing the meta (cost sensitive) classifier

%creating a cost function
if (ft_train_weka.numClasses() ~= size(costMatrix,1))
    warning('The size of the cost matrix does not match the number of classes in the training data');
    return;
end
costMatrix_weka = weka.classifiers.CostMatrix(size(costMatrix,1));
for irow = 1:size(costMatrix,1)
    for icol = 1:size(costMatrix,2)
        costMatrix_weka.setElement(irow-1, icol-1, costMatrix(irow,icol));
    end
end

% initializing the meta (cost sensitive) classifier
metaClassifier = weka.classifiers.meta.CostSensitiveClassifier();
metaClassifier.setMinimizeExpectedCost(false);
metaClassifier.setCostMatrix(costMatrix_weka);
metaClassifier.setClassifier(trainModel);
metaClassifier.buildClassifier(ft_train_weka);

%% Making Predictions
actual = cell(ft_test_weka.numInstances()-numExtraClass, 1); %actual labels
predicted = cell(ft_test_weka.numInstances()-numExtraClass, 1); %predicted labels
probDistr = zeros(ft_test_weka.numInstances()-numExtraClass, ft_test_weka.numClasses()); %probability distribution of the predictions
%the following loop is very slow. We may consider implementing the
%following in JAVA
for z = 1:ft_test_weka.numInstances()-numExtraClass
%     actual(z,1) = ft_test_weka.instance(z-1).classValue();
%     predicted(z,1) = metaClassifier.classifyInstance(ft_test_weka.instance(z-1));
    actual{z,1} = ft_test_weka.instance(z-1).classAttribute.value(ft_test_weka.instance(z-1).classValue()).char();% Modified by GM
    predicted{z,1} = ft_test_weka.instance(z-1).classAttribute.value(metaClassifier.classifyInstance(ft_test_weka.instance(z-1))).char();% Modified by GM
    probDistr(z,:) = (metaClassifier.distributionForInstance(ft_test_weka.instance(z-1)))';
end     
display('    Classification Completed!');