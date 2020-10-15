function [MI,h_X_approximated]=empirical_differential_MI(varargin)

% This function computes the empirical differential MI between the
% X and Y given the conditional distributions XgNeg and XgPos

switch nargin
    case 2
        XgNeg=varargin{1};
        XgPos=varargin{2};
        edges=-1:0.01:1;
    case 3
        XgNeg=varargin{1};
        XgPos=varargin{2};
        edges=varargin{3};
end


X=[XgNeg XgPos];

n_samples_XgNeg=length(XgNeg);
n_samples_XgPos=length(XgPos);
n_samples_X=n_samples_XgNeg+n_samples_XgPos;


% [N_X,edges]=histcounts(X,n_bins); %original
[N_X,edges]=histcounts(X,edges);
[N_XgNeg,edges]=histcounts(XgNeg,edges);
[N_XgPos,edges]=histcounts(XgPos,edges);


delta=edges(2)-edges(1);

f_XgNeg=(N_XgNeg+1)/(n_samples_XgNeg*delta);
f_XgPos=(N_XgPos+1)/(n_samples_XgPos*delta);
f_X=(N_X+1)/(n_samples_X*delta);



H_XgNeg=-sum(delta*f_XgNeg.*log2(f_XgNeg))-log2(delta);
h_XgNeg_approximated=H_XgNeg+log2(delta);

H_XgPos=-sum(delta*f_XgPos.*log2(f_XgPos))-log2(delta);
h_XgPos_approximated=H_XgPos+log2(delta);

H_X=-sum(delta*f_X.*log2(f_X))-log2(delta);
h_X_approximated=H_X+log2(delta);


MI=h_X_approximated-n_samples_XgNeg/n_samples_X*h_XgNeg_approximated-n_samples_XgPos/n_samples_X*h_XgPos_approximated;

