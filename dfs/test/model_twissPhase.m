function [psi, pMat] = model_twissPhase(twiss, rMat)

if size(twiss,2) == 1
    t2=model_twissTrans(twiss,rMat);
    pMat=inv(getB(t2))*rMat(1:2,1:2)*getB(twiss);
    psi=atan2(pMat(1,2),pMat(1,1));
elseif size(twiss,3) == 1
    psi(1,1)=model_twissPhase(twiss(:,1),rMat(1:2,1:2));
    psi(2,1)=model_twissPhase(twiss(:,2),rMat(3:4,3:4));
else
    psi=zeros(2,size(twiss,3));
    for j=1:size(twiss,3)
        psi(:,j)=model_twissPhase(twiss(:,:,j),rMat(:,:,j));
    end
end


function B = getB(twiss)

beta=twiss(end-1,:);
alpha=twiss(end,:);
B=[beta 0;-alpha 1]/sqrt(beta);
