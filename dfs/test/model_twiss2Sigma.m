function [sig, sigStd, sigCov] = model_twiss2Sigma(twiss, energy)

e0=0.511e-3; % Energy in GeV
if nargin < 2, energy=[];end
if isempty(energy), energy=e0;end
gam=energy(:)'/e0;
sig=twiss*0;sig(4:end,:)=[];sigStd=twiss;sigCov=repmat(shiftdim(sig,-1),3,1);

eps=twiss(1,:)./gam;
b=twiss(2,:);a=twiss(3,:);g=(1+a.^2)./b;
sig(:,:)=[b.*eps;-a.*eps;g.*eps];
