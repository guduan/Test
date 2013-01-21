clc;clear all;
beamline1=getline_test(1);
elemlist1=getList(beamline1,449.68);

beamline2=getline_test(0.9);
elemlist2=getList(beamline2,449.68);

nBpm=length(elemlist1.bpmid);
nCorr=length(elemlist1.corrid);
nQuad=length(elemlist1.quadid);
zBpm=elemlist1.zBpm;


a1=importdata('E:\test121130\test.mat1');
b1=a1.data;
 for i=1:120
     for j=1:6
         for k=1:6
             Tmat1(j,k,i)=b1(i+2,(j-1)*6+k);
         end
     end
 end

RMat1=getRmat(Tmat1,elemlist1);

realcorvalue=importdata('E:\test121130\test.cor1');
realorbit=importdata('E:\test121130\test.realorbit');

corr_value=realcorvalue.data;
orbit_value=realorbit.data;

Q_inv=pinv(RMat1);

corr__caculated=-Q_inv*orbit_value;
tt=cell2mat({corr_value,corr__caculated});
figure;bar(tt);
