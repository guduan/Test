function R = getCRmat(Tmat,List)

corrid=List.corrid;
zCorr=List.zCorr;
bpmid=List.bpmid;
zBpm=List.zBpm;
quadid=List.quadid;
zQuad=List.zQuad;

nBpm=length(bpmid);
nCorr=length(corrid);
nQuad=length(quadid);

for i=1:nCorr
    for j=1:nBpm
        if corrid(i)< bpmid(j)
            Rcorr(:,:,j,i)=getTmatAll(Tmat,corrid(i),bpmid(j));
        else
            Rcorr(:,:,j,i)=zeros(6);
        end
    end
end
rcorr=Rcorr(1,2,:,:);%corr R12
rcorr=reshape(rcorr,nBpm,nCorr);
R=rcorr;