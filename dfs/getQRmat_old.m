function QR = getQRmat_old(Tmat,List)

corrid=List.corrid;
zCorr=List.zCorr;
bpmid=List.bpmid;
zBpm=List.zBpm;
quadid=List.quadid;
zQuad=List.zQuad;

nBpm=length(bpmid);
nCorr=length(corrid);
nQuad=length(quadid);

for i=1:nQuad
    for j=1:nBpm
        if quadid(i)< bpmid(j)
            QR(:,:,j,i)=getTmatAll(Tmat,quadid(i),bpmid(j))-getTmatAll(Tmat,(quadid(i)-1),bpmid(j));
        else
            QR(:,:,j,i)=zeros(6);%if the bpm is behind quad,then set Rseponse matrix=0;
        end
    end
end

rtemp=QR(1,1,:,:);
QR=reshape(rtemp,nBpm,nQuad);