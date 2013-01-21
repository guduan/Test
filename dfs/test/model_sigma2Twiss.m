function [twiss, twissStd, twissCov] = model_sigma2Twiss(sig, sigCov, energy)

e0=0.511e-3; % Energy in GeV
if nargin < 3, energy=[];end
if nargin < 2, sigCov=[];end
if isempty(energy), energy=e0;end
gam=energy(:)'/e0;
twiss=sig*0;twissStd=twiss;twissCov=repmat(shiftdim(twiss,-1),3,1);

eps=sqrt(sig(1,:).*sig(3,:)-sig(2,:).^2);
twiss(:,:)=[eps.*gam;sig(1,:)./eps;-sig(2,:)./eps];
twissI=twiss;twiss=real(twiss);

if isempty(sigCov), return, end

for j=1:numel(eps)
    deps=[sig(3,j) -2*sig(2,j) sig(1,j)]/2/eps(j);
    dtwiss=(diag([1 -1 -1])*twissI(:,j)*deps+diag([1 -1],-1))/eps(j);
    twissCov(:,:,j)=dtwiss*sigCov(:,:,j)*dtwiss';
    twissStd(:,j)=sqrt(diag(twissCov(:,:,j)));
end
