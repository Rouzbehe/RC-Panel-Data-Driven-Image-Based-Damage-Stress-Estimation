function [selectedAttr] = wekaFeatureSelection(featTrain, featTest, classTrain, classTest, featName, selector)
% Perform attribute selection in the WEKA package
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
% selector    	- 1 = CfsSubsetEval
%
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

%% Perform Attribute Selection
display('    Selected Features...');
if (selector == 1)
    import weka.attributeSelection.AttributeSelection.*
    import weka.attributeSelection.CfsSubsetEval.*
    import weka.attributeSelection.BestFirst.*
    import weka.attributeSelection.GreedyStepwise.*

	%create an java object
    attrSelector = weka.attributeSelection.AttributeSelection();        
        %Eval#1. Evaluates the worth of a subset of attributes by considering the individual predictive ability of each feature along with the degree of redundancy between them.
        subsetEval = weka.attributeSelection.CfsSubsetEval();        
        %Search#1: Best First Search
%         searchMethod = weka.attributeSelection.BestFirst();
        %Search#2: Greedy Stepwise
                searchMethod = weka.attributeSelection.GreedyStepwise;
                searchOpts(1) = java.lang.String('-N');
                searchOpts(1) = java.lang.String('-1');
                searchOpts(1) = java.lang.String('-T');
                searchOpts(1) = java.lang.String('-1.7976931348623157E308');
                searchMethod.setOptions(searchOpts);        
    attrSelector.setEvaluator(subsetEval);
    attrSelector.setSearch(searchMethod);
    %attrSelector.setXval(1); performing cross valuation?
    %Performing attribute selection
    attrSelector.SelectAttributes(ft_train_weka);
    %attrSelector.toResultsString() %printing summary
    tmpSelectedAttr = attrSelector.selectedAttributes(); %selected attributes
    selectedAttr = (tmpSelectedAttr(1:size(tmpSelectedAttr,1)-1,:) + 1)';

elseif (selector == 2)
    import weka.attributeSelection.RankedOutputSearch.*
    import weka.attributeSelection.Ranker.*
%     import weka.attributeSelection.BestFirst.*
%     import weka.attributeSelection.CfsSubsetEval.*
%     import weka.attributeSelection.CorrelationAttributeEval.*
%     import weka.attributeSelection.AttributeSelection.*
%create an java object
    attrSelector = weka.attributeSelection.AttributeSelection();        

    ranker = weka.attributeSelection.Ranker();
%     attrSelector = weka.attributeSelection.RankedOutputSearch();       

%     attrSelector.setEvaluator(CfsSubsetEval);
    attrSelector.setSearch(ranker);
    
    attrSelector.SelectAttributes(ft_train_weka);

    %attrSelector.toResultsString() %printing summary
    tmpSelectedAttr = attrSelector.selectedAttributes(); %selected attributes
    selectedAttr = (tmpSelectedAttr(1:size(tmpSelectedAttr,1)-1,:) + 1)';

      
    clear tmpSelectedAttr;

    % Reducting the features for both TRAIN and TEST set
    %ft_train_weka = matlab2weka('train',[featName(:,selectedAttr), 'class'], horzcat(num2cell(featTrain(:,selectedAttr)), classTrain) );
    %ft_test_weka = matlab2weka('test',[featName(:,selectedAttr), 'class'], horzcat(num2cell(featTest(:,selectedAttr)), classTest) );

    clear attrSelector subsetEval searchMethod; 
    clear base;
end
display('    Feature Selection Completed!');