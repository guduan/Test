clc;clear all;
beamline1=getline_test(1);
elemlist1=getList(beamline1,449.68);
Tmat1 = getTmatEach(beamline1);

beamline2=getline_test(0.9);
elemlist2=getList(beamline2,449.68);
Tmat2 = getTmatEach(beamline2);

nBpm=length(elemlist1.bpmid);
nCorr=length(elemlist1.corrid);
nQuad=length(elemlist1.quadid);
zBpm=elemlist1.zBpm;

QMat1=getQmat(Tmat1,elemlist1);
QMat2=getQmat(Tmat2,elemlist2);

quadid1=elemlist1.quadid;
for i=1:nQuad
    KL1(i)= beamline1{3,quadid1(i)}* beamline1{4,quadid1(i)};
end

quadid2=elemlist2.quadid;
for i=1:nQuad
    KL2(i)= beamline2{3,quadid2(i)}* beamline2{4,quadid2(i)};
end

KL1=repmat(KL1,nBpm,1);
KL2=repmat(KL2,nBpm,1);
Q1=QMat1.*KL1;
Q2=QMat2.*KL2;
% Q1=QMat1;
% Q2=QMat2;


Q_inv=pinv(RMat1);

corr__caculated=-Q_inv*orbit_value;
tt=cell2mat({corr_value,corr__caculated});
figure;bar(tt);