function [cmaps]=Nonstandard_Colormaps(grad)
% This function will define a set of nonstandard colormaps to be used in
% plotting of the figure
%
% Assumptions: None
%
% Inputs (overloaded function call)
%   grad   %integer number of gradations in the color schemes
%
% Outputs:
%   cmaps    %Structured object of colormaps

%
% Date: 12/11/2019
% Authors: Mark Zaydman and Arjun Raman
% ________________________________________


    cmaps.redmap=ones(grad,3);
    cmaps.redmap(:,2)=1:-1/grad:0+1/grad;
    cmaps.redmap(:,3)=1:-1/grad:0+1/grad;

    cmaps.graymap=ones(grad,3);
    cmaps.graymap(:,1)=1:-1/grad:0+1/grad;
    cmaps.graymap(:,2)=1:-1/grad:0+1/grad;
    cmaps.graymap(:,3)=1:-1/grad:0+1/grad;

    cmaps.bluemap=ones(grad,3);
    cmaps.bluemap(:,1)=0:1/grad:1-1/grad;
    cmaps.bluemap(:,2)=0:1/grad:1-1/grad;

    cmaps.rbmap=[cmaps.bluemap; [1 1 1];cmaps.redmap];
    
    
