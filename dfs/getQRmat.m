function QR = getQRmat(Tmat,List)

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
            a=getTmatAll(Tmat,quadid(i),bpmid(j));
            QR(j,i)=(1-Tmat(1,1,quadid(i)))*a(1,1)-Tmat(2,1,quadid(i))*a(1,2);
        else
            QR(j,i)=0;
        end
    end
end
