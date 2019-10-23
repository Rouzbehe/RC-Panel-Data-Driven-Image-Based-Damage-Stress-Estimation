function [predicted, probDistr, numClusters] = wekaClustering(featData, featName, numClusters, clusterer)
% Perform unsupervised clustering 
%
% featData      - A NUMERIC matrix of features (Ntr x M)
%
% featName    - The CELL vector of string representing the label of each 
%                 features, (1 x M) cell
%
% numClusters   - An integer representing the number of clusters. If not
%                 known, the value shall be -1.
%
% clusterer    - 1 = Expectation Maximization
%               - 2 = K-Mean Clustering
%
% Written by Sunghoon Ivan Lee
% http://www.sunghoonivanlee.com


% Converting to WEKA data  
import matlab2weka.*;

display('    Converting Data into WEKA format...');
convert2wekaObj = convert2weka('training', featName, featData', [], false); 
ft_train_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;
display('    Converting Completed!');

display('    Clustering...');
if (clusterer == 1)
    import weka.clusterers.EM.*;

    trainModel = weka.clusterers.EM();
    %maxDepth 0, numFeatures 0, numTrees 10, seed 1
    trainModel.setMaxIterations(200); %Set maximum iteration
    trainModel.setMinStdDev(1.0e-6); %Set the number of features to use in random selection.
    trainModel.setNumClusters(numClusters); %Set the value of numTrees.
    trainModel.setSeed(100);
    trainModel.buildClusterer(ft_train_weka);   
    %trainModel.toString()
else (clusterer == 2)
    import weka.clusterers.SimpleKMeans.*;
    import weka.core.EuclideanDistance.*;
    
    trainModel = weka.clusterers.SimpleKMeans();
    trainModel.setMaxIterations(100); %Set maximum iteration
    trainModel.setNumClusters(numClusters); %Set the value of numTrees.
    trainModel.setPreserveInstancesOrder(true)
    trainModel.setSeed(100);
        distFunc = weka.core.EuclideanDistance(); %defining distance func
    trainModel.setDistanceFunction(distFunc);        
    trainModel.buildClusterer(ft_train_weka);   
end

numClusters = trainModel.numberOfClusters();
predicted = zeros(ft_train_weka.numInstances(), 1);
probDistr = zeros(ft_train_weka.numInstances(), numClusters);
for z = 1:ft_train_weka.numInstances()
    predicted(z,1) = trainModel.clusterInstance(ft_train_weka.instance(z-1));
    probDistr(z,:) = (trainModel.distributionForInstance(ft_train_weka.instance(z-1)))';
end   

display('    Clustering Completed!');