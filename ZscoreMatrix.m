function [Xij]=ZscoreMatrix(Raw)
%
% Assumptions: None
%
% Inputs:
%   Dij    %raw domain counts matrix
%
% Outputs:
%   Xij    %centered and standardized domain count matrix

%
% Date: 12/4/2019
% Authors: Mark Zaydman and Arjun Raman
% ________________________________________


% Subtract column mean
Centered=Raw-mean(Raw);

% Standardize
Xij=Centered./repmat(std(Centered),length(Raw(:,1)),1);