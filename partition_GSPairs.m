function [DataSets]=partition_GSPairs(GS_Pairs,Percent_training,Oversample_negatives)

DataSets={};

%Find indices of filtered 'gold standard' pairs
i_Physical=find(GS_Pairs.Physical.Matrix~=0);
i_Functional=find(GS_Pairs.Functional.Matrix~=0);
i_Negative=find(GS_Pairs.Negative.Matrix~=0);


p=randperm(length(i_Physical));
GS_Pairs.Physical.TrainingSet=i_Physical(p(1:floor(Percent_training*length(i_Physical))));
GS_Pairs.Physical.ValidationSet=i_Physical(p(floor(Percent_training*length(i_Physical))+1:end));

%Functional pairs
p=randperm(length(i_Functional));
GS_Pairs.Functional.TrainingSet=i_Functional(p(1:floor(Percent_training*length(i_Functional))));
GS_Pairs.Functional.ValidationSet=i_Functional(p(floor(Percent_training*length(i_Functional))+1:end));

%Noninteracting pairs
p=randperm(length(i_Negative));
GS_Pairs.Negative.TrainingSet=i_Negative(p(1:floor(Oversample_negatives*length(GS_Pairs.Physical.TrainingSet))));
GS_Pairs.Negative.ValidationSet=i_Negative(p(floor(Oversample_negatives*length(GS_Pairs.Physical.TrainingSet))+1:Oversample_negatives*(length(GS_Pairs.Physical.TrainingSet)+length(GS_Pairs.Physical.ValidationSet))));


%Build training set
% disp('Building datasets');
DataSets.TrainingSet.indices=[GS_Pairs.Physical.TrainingSet;...
    GS_Pairs.Functional.TrainingSet;...
    GS_Pairs.Negative.TrainingSet];
DataSets.TrainingSet.Labels=[2*ones(length(GS_Pairs.Physical.TrainingSet),1);...
    ones(length(GS_Pairs.Functional.TrainingSet),1);...
    zeros(length(GS_Pairs.Negative.TrainingSet),1)];

%Build validation set
DataSets.ValidationSet.indices=[GS_Pairs.Physical.ValidationSet;...
    GS_Pairs.Functional.ValidationSet;...
    GS_Pairs.Negative.ValidationSet];
DataSets.ValidationSet.Labels=[2*ones(length(GS_Pairs.Physical.ValidationSet),1);...
    ones(length(GS_Pairs.Functional.ValidationSet),1);...
    zeros(length(GS_Pairs.Negative.ValidationSet),1)];