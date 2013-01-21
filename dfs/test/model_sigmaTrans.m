function [sigma] = model_sigmaTrans(sigma, rMat)

nSigma=size(sigma,1);
if nSigma ~= 3 || size(sigma,2) == 1
    if nSigma == 3
        sigma=reshape(sigma([1 2;2 3],:),2,2,[]);
    end

    sigma=rMat*sigma*rMat';

    if nSigma == 3
        sigma=sigma([1 2 4]');
    end
else
    for j=1:size(sigma,3)
        sigma(:,1,j)=model_sigmaTrans(sigma(:,1,j),rMat(1:2,1:2,j));
        sigma(:,2,j)=model_sigmaTrans(sigma(:,2,j),rMat(3:4,3:4,j));
    end
end
