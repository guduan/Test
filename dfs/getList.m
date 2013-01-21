function List = getList(beamline,e0)
% e0 in MeV
line=beamline;
n=size(line,2);
zPos=zeros(1,n);
lEff=zeros(1,n);
energy=ones(1,n)*e0;

List.bpmid=[];
List.zBpm=[];
List.corrid=[];
List.zCorr=[];
List.quadid=[];
List.zQuad=[];
List.lcid=[];
List.zLc=[];

for a=1:n
	lEff(a)=line{3,a};
	zPos(a+1)=zPos(a)+lEff(a);
    
	switch line{1,a} 
        case 'cr'
            List.corrid(a)=a;
            List.zCorr(a)=zPos(a+1);
            energy(a+1)=energy(a);
        case 'qu'
            List.quadid(a)=a;
            List.zQuad(a)=zPos(a+1);
            energy(a+1)=energy(a);
        case 'mo'
            List.bpmid(a)=a;
            List.zBpm(a)=zPos(a+1);
            energy(a+1)=energy(a);
        case 'lc'
            List.lcid(a)=a;
            List.zLc(a)=zPos(a+1);
            par=line{4,a};
            energy(a+1)=energy(a)+abs(par(2)*cos(par(3)));% MeV
        otherwise
            energy(a+1)=energy(a);
    end
end


List.bpmid(List.bpmid == 0)=[];
List.zBpm(List.zBpm == 0)=[];
% List.xcorrid(List.xcorrid == 0)=[];
% List.ycorrid(List.ycorrid == 0)=[];
List.corrid(List.corrid == 0)=[];
List.zCorr(List.zCorr == 0)=[];
% List.zxCorr(List.zxCorr == 0)=[];
% List.zyCorr(List.zyCorr == 0)=[];
List.quadid(List.quadid == 0)=[];
List.zQuad(List.zQuad == 0)=[];
List.lcid(List.lcid == 0)=[];
List.zLc(List.zLc == 0)=[];


List.bpmid=unique(List.bpmid);
List.zBpm=unique(List.zBpm);
List.corrid=unique(List.corrid);
List.zCorr=unique(List.zCorr);
List.quadid=unique(List.quadid);
List.zQuad=unique(List.zQuad);
List.lcid=unique(List.lcid);
List.zLc=unique(List.zLc);
energy(end)=[];
List.energy=energy;
List.ztotal=sum(cell2mat(line(3,:)));
List.endenergy=List.energy(end);
List;















