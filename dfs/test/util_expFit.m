function [par, yFit, parstd, yFitStd, mse, pcov, rfe] = util_expFit(x, y, bgord, yStd, xFit)
%EXPFIT
%  EXPFIT(X, Y, BGORD) fits an exponetial decay distribution with linear
%  background using Levenberg-Marquardt algorithm. BGORD set the number of
%  parameters for the background polynomial. The default is 0 for no
%  background. BGORD set to 1 uses a constant background. BGORD set to 2
%  uses a linear one.

% Input arguments:
%    X: x-value
%    Y: y-value
%    BGORD: 0: zero offset (default), 1: constant offset, 2: linear offset

% Output arguments:
%    PAR: fitted parameters [AMP, XM, SIG, BG, BGS]
%         Y=AMP EXP(-(X-XM)^2/2/SIG^2) + BG + X BGS
%         for TWOSIDE = 1, [AMP, XM, MEAN(SIG), ASYM, BG, BGS],
%         ASYM = (SIG_H-SIG_L)/SUM(SIG)
%         for SUPER = 1, [AMP, XM, SIG, N, BG, BGS],
%         Y=AMP EXP(-ABS((X-XM)/SQRT(2)/SIG)^N) + BG + X BGS
%         RMS^2 = 2 SIG^2 GAMMA(3/N)/GAMMA(1/N)
%         The length of PAR depends on BGORD
%    YFIT: fitted function
%    PARSTD: error of fit parameters
%    YFITSTD: error of fitted function
%    MSE: mean standard error, chi^2/NDF
%    PCOV: covariance matrix
%    RFE: rms fit error

% Compatibility: Version 7 and higher
% Called functions: marquardt, processFit

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Parse input parameters.
if nargin < 3, bgord=0;end
if nargin < 4, yStd=[];end
if nargin < 5, xFit=[];end

[x,y,yStd,xFit]=util_fitInit(x,y,yStd,xFit);

% Determine starting parameters for non-linear fit.
xm=mean(x);len=length(y);
ind=[1:ceil(len/10) max(1,ceil(len-len/10)):len];
ilen=length(unique(ind));par=[];
if ilen > 0, par=polyfit(x(ind)-xm,y(ind),min(ilen-1,1));end
bg=par(end:-1:end-min(ilen,bgord)+1);bgf=polyval(fliplr(bg),x-xm);

% Find peak value and peak position.
yy=y(:);
[amp,indx]=max(yy);amp=amp-bgf(indx);x0=x(indx);
if isempty(x0), x0=0;end

% Find width from peak value and area.
y1=y-bgf;y1(y1 < amp/3)=0;
if isempty(amp) || amp == 0 , amp=1;end
sig=abs(sum(y1)*mean(diff(x))/amp/sqrt(2*pi));
if sig == 0 || isnan(sig), sig=1;end

% Initialize fit parameters.
sig=sig*4;
par=[1 x0 1/sig bg/amp];mar_par=[1 1e-9 1e-9 50];

fcn=@stepExp;
%par=fminsearch(@(p) sum(fcn(p,[x y/amp]).^2),par);
[par,info]=util_marquardt(fcn,[x y/amp],par,mar_par);
par([1 4:end])=par([1 4:end])*amp;par0=par;

% Get fitted function values.
[parstd,mse,xFit,yFit,yFitStd,pcov,rfe]=util_processFit(fcn,par0,x,y,yStd,xFit);


function [f,J] = stepExp(x, fpar)
%STEPEXP Fit function for Levenberg-Marquardt algorithm.
%  Step exponential

xval=fpar(:,1);
yval=fpar(:,2);
amp=abs(x(1));
x0=x(2);xx=xval-x0;
sigma=x(3)+1e-20;
f0=amp*exp(-xx*sigma).*(xx > 0);
J(:,1)=f0/amp;
J(:,2)=f0*sigma*1-amp*exp(-xx*sigma).*exp(-xx.^2/2/(1/sigma/10)^2)/(1/sigma/10);
J(:,3)=-f0.*xx;
if max(size(x)) > 3
   bg=x(4);
   J(:,4)=xval*0+1;
else
   bg=0;
end
if max(size(x)) > 4
   bgs=x(5);
   J(:,5)=xval;
else
   bgs=0;
end
f=f0-yval+bg+xval*bgs;

if any(yval)
%    disp(x);
%    plot(xval,yval,xval,f+yval,'r');drawnow;pause(.1);
end

yvalstd=yval*0+1;
if size(fpar,2) == 3, yvalstd=fpar(:,3);end
f=f./yvalstd;
J=J./repmat(yvalstd,1,size(J,2));
