function [k1, z, lEff, k1y, k12, k1y2] = design_k1Get(name, opts)

if nargin < 2, opts='TYPE=DESIGN';end
modelSource=model_init;
if strcmp(modelSource,'SLC')
    [rBeg,z,lEff]=model_rMatGet(name,[],{'POS=BEG' opts});
    rEnd=model_rMatGet(name,[],{'POS=END' opts});
    n=size(rBeg,3);
    r=zeros(6,6,n);
    for j=1:n
        r(:,:,j)=rEnd(:,:,j)*inv(rBeg(:,:,j));
    end
else
    [r,z,lEff]=model_rMatGet(name,name,{'POS=BEG' 'POSB=END' opts});
end

r11=squeeze(r(1,1,:))';
phix=acos(r11);
k1=real((phix./lEff).^2);

k1y=real((acos(squeeze(r(3,3,:))')./lEff).^2);

r12=squeeze(r(1,2,:))';
r21=squeeze(r(2,1,:))';
phix=asin(sqrt(-r12.*r21));
k12=real((phix./lEff).^2);

k1y2=real((asin(sqrt(-squeeze(r(3,4,:))'.*squeeze(r(4,3,:))'))./lEff).^2);
