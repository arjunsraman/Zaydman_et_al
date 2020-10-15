function [Neg_bs,Pos_bs]=make_bootstrap(varargin)
%Mark Zaydman 1/3/2020

%This function will take in a benchmark and output indices of a random
%resampling to create and equal number of pos and negatives. If a statistic
%is also passed as a second input the output will be the distrubtions for
%the pos and negative samples.


switch nargin
    case 1
        benchmark=varargin{1};
        Unique_set=0;
    case 2
        benchmark=varargin{1};
        Z=varargin{2};
        Unique_set=0;
    case 3
        benchmark=varargin{1};
        Unique_set=varargin{2};
        GeneByFeatureMatrix=varargin{3};
        NonOverlapping=~(GeneByFeatureMatrix*GeneByFeatureMatrix');

    case 4
        benchmark=varargin{1};
        Z=varargin{2};
        Unique_set=varargin{3};
        GeneByFeatureMatrix=varargin{4};
        NonOverlapping=~(GeneByFeatureMatrix*GeneByFeatureMatrix');
end

%% Find pos and negative values
if Unique_set
    i_Pos=find(triu(benchmark.*NonOverlapping,1)~=0);
    i_Neg=find(triu(~benchmark.*NonOverlapping,1)~=0);
else
    i_Pos=find(triu(benchmark,1)~=0);
    i_Neg=find(triu(~benchmark,1)~=0);
end

%% Find smaller dimension
N_samples=min(length(i_Pos),length(i_Neg));

%% Resample pos and negative values
switch nargin
    case 1
        Pos_bs=i_Pos(randsample(length(i_Pos),N_samples,true));
        Neg_bs=i_Neg(randsample(length(i_Neg),N_samples,true));
    case 2
        Pos_bs=Z(i_Pos(randsample(length(i_Pos),N_samples,true)));
        Neg_bs=Z(i_Neg(randsample(length(i_Neg),N_samples,true)));
    case 3
        Pos_bs=i_Pos(randsample(length(i_Pos),N_samples,true));
        Neg_bs=i_Neg(randsample(length(i_Neg),N_samples,true));
    case 4
        Pos_bs=Z(i_Pos(randsample(length(i_Pos),N_samples,true)));
        Neg_bs=Z(i_Neg(randsample(length(i_Neg),N_samples,true)));
end