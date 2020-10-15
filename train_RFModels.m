function [Outputs]=train_RFModels(Features,DataSets,num_trees,thisFeature)

% Assumptions: None

% Inputs:
%   Features: Structered object of features
%   Datasets: Structured object of datasets
%   num_trees Numbers of trees to build in forest
%   thisFeature: String of the name of the current feature to be used
%   Benchmarks: Structured object of benchmarks to be predicted


% Outputs:
%   Outputs    %Structured object of outputs, substructures include:
        % Model: Structure model object
        % Y_TrainingSet: Array of predicted classes for the training dataset
        % Y_ValidationSet: Array of predicted classes for the validation dataset

                        
% Date: Version 1: 3/9/2020
%       Version 2: 3/10/2020
%       Version 3: 3/11/2020

% Authors: Mark Zaydman and Arjun Raman
% ________________________________________

% Define sets of features X_all, X_TrainingSet, X_ValidationSet
if strcmp(thisFeature,'MI_Windows')
    X_TrainingSet=[Features.(thisFeature).Phylogeny(DataSets.TrainingSet.indices),...
        Features.(thisFeature).Functional(DataSets.TrainingSet.indices),...
        Features.(thisFeature).Physical(DataSets.TrainingSet.indices)];
    X_ValidationSet=[Features.(thisFeature).Phylogeny(DataSets.ValidationSet.indices),...
        Features.(thisFeature).Functional(DataSets.ValidationSet.indices),...
        Features.(thisFeature).Physical(DataSets.ValidationSet.indices)]; 
else
    X=Features.(thisFeature);
%     X_All=X(triu(ones(size(X)),1)==1);
    X_TrainingSet=X(DataSets.TrainingSet.indices);
    X_ValidationSet=X(DataSets.ValidationSet.indices);
end


Outputs={};

ForestModel=TreeBagger(num_trees,X_TrainingSet,DataSets.TrainingSet.Labels,'OOBPrediction','On',...
    'Method','classification');

Outputs.Model=ForestModel;
Outputs.Y_TrainingSet = str2num(cell2mat(predict(ForestModel,X_TrainingSet)));
Outputs.Y_ValidationSet = str2num(cell2mat(predict(ForestModel,X_ValidationSet)));





