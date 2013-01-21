function [fint, xmean, xstd, xvar, skew, kurt, muRaw, mu] = util_moments(x, f, dim)
%MOMENTS
%  MOMENTS(X, F, DIM) returns sum, mean, std, and var of distribution F(X)
%  binned by X. The moments are evaluated over the longest dimension if X
%  is an array, or over dimension DIM if specified.

% Input arguments:
%    X: Coordinates of distribution
%    F: Distribution F(X)
%    DIM: Dimension over which to take the moments, defaults to dimension
%         with largest size

% Output arguments:
%    FINT: Sum of F
%    XMEAN, XSTD, XVAR: mean, std, and variance of F(X)

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Check input arguments
if nargin < 3
    [dummy,dim]=max(size(f)); % Find vector orientation
end
if numel(f) == numel(x)
    x=reshape(x,size(f));
else
    len=[1 1 1];len(dim)=length(x);
    x=reshape(x,len);
    x=repmat(x,size(f)./size(x));
end

fint=sum(f,dim);
[x1,x2,x3,x4,skew,kurt]=deal(fint*0);
good=fint ~= 0;
%if ~all(good)
%    xmean=mean(x,dim);%xmean(:)=NaN;
%    xstd=std(x,0,dim);%xstd(:)=NaN;
%    xvar=xstd.^2;
%end
x1sum=sum(x.*f,dim);x1(good)=x1sum(good)./fint(good);
x2sum=sum(x.^2.*f,dim);x2(good)=x2sum(good)./fint(good);
xmean=x1;
xvar=x2-xmean.^2;
xstd=real(sqrt(xvar));
if nargout > 4
    x3sum=sum(x.^3.*f,dim);x3(good)=x3sum(good)./fint(good);
    x4sum=sum(x.^4.*f,dim);x4(good)=x4sum(good)./fint(good);
    m3=x3-3*xmean.*x2+2*xmean.^3;
    m4=x4-4*xmean.*x3+6*xmean.^2.*x2-3*xmean.^4;
    skew(good)=m3(good)./xstd(good).^3;
    kurt(good)=m4(good)./xstd(good).^4-3;
    muRaw=cat(dim,x1,x2,x3,x4);
    mu=cat(dim,zeros(size(x1)),xvar,m3,m4);
end
