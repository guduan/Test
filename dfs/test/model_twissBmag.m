function [twiss, twissstd] = model_twissBmag(twiss, twiss0, twisscov)

bet=twiss(end-1,:);alp=twiss(end,:);gam=(1+alp.^2)./bet;
bet0=twiss0(end-1,:);alp0=twiss0(end,:);gam0=(1+alp0.^2)./bet0;

xi=(bet0.*gam-2*alp0.*alp+gam0.*bet)/2;
twiss(end+1,:)=xi;
twissstd=twiss*0;

if nargin < 3, return, end

for j=1:numel(xi)
    dxi=[0 gam0(j)*bet(j)-bet0(j)*gam(j) 2*bet0(j)*alp(j)-2*bet(j)*alp0(j)]/bet(j)/2;
    twissstd(1:3,j)=sqrt(diag(twisscov(:,:,j)));
    twissstd(4,j)=sqrt(dxi*twisscov(:,:,j)*dxi');
end
