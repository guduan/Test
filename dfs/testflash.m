clc;clear all;
elegant_file_root='E:\flashgu\';
matlab_file_root='E:\flashgu_matlab\';
beamline1=getline_flash(1);
elemlist1=getList(beamline1,56.64);
%beamline1=EAppend(beamline1,elemlist1);

beamline2=getline_flash(0.9);
elemlist2=getList(beamline2,56.64);
%beamline2=EAppend(beamline2,elemlist2);

% %transport matrix calculated from MATALB:
% Tmat01 = getTmatEach(beamline1);
% Tmat02 = getTmatEach(beamline2);

nBpm=length(elemlist1.bpmid);
nCorr=length(elemlist1.corrid);
nQuad=length(elemlist1.quadid);
nElement=length(beamline1);
zBpm=elemlist1.zBpm;
zQuad=elemlist1.zQuad;
% derive Transport Matrice form ELEGANT
%----------------------------------------------------
a1=importdata([elegant_file_root 'flash_dfs.mat1']);
a2=importdata([elegant_file_root 'flash_dfs1.mat1']);
b1=a1.data;
b2=a2.data;

 for i=1:nElement
     for j=1:6
         for k=1:6
             Tmat1(j,k,i)=b1(i+1,(j-1)*6+k);
         end
     end
 end

  for i=1:nElement
     for j=1:6
         for k=1:6
             Tmat2(j,k,i)=b2(i+1,(j-1)*6+k);
         end
     end
  end
%----------------------------------------------------

QRmat1=getQmat(Tmat1,elemlist1);
QRmat2=getQmat(Tmat2,elemlist2);
diff_QR=QRmat1-QRmat2;

orbit1=importdata([elegant_file_root 'flash_dfs.orbit']);
orbit2=importdata([elegant_file_root 'flash_dfs1.orbit']);

bpm_noise1=2e-6*randn(nBpm,1);
bpm_noise2=2e-6*randn(nBpm,1);

orbit_real1=orbit1.data;
orbit_real2=orbit2.data;
diff_orbit_without_noise=orbit_real1-orbit_real2;
diff_orbit_with_noise=orbit_real1-orbit_real2+bpm_noise2;
qoffsetdata=importdata([elegant_file_root 'flash_dfs.erl1']);
qoffset_real=qoffsetdata.data;

RQLin=[ones(1,nQuad);zQuad];
xQLin=RQLin(:,1)*0;
RQMin=zeros(1,nQuad);
xQMin=RQMin(:,1)*0;

RALL=[QRmat1;diff_QR];
xMeas=[orbit_real1+bpm_noise1;orbit_real1-orbit_real2+bpm_noise2];
xMeasStd=xMeas*0+.1e-6;

RLagr=[RQLin;RQMin];
xLagr=[xQLin;xQMin];
xLagrStd=ones(size(xLagr))*mean(xMeasStd(1));

R=[RALL;RLagr];
x=[xMeas;xLagr];
%w=1./[xMeasStd;xLagrStd].^2;
w=
[qoffset_calculated,std_qoffset_calculated]=lscov(R,x,w);

tt1=cell2mat({qoffset_calculated,qoffset_real});
figure;bar(tt1);title('Result with bpm noise');
hold on;
qoffset_new=[qoffset_real-qoffset_calculated]';
csvwrite('qoffset_new.dat',qoffset_new);

fid=fopen('qoffset_new.dat','r');
temp=fgets(fid);
fclose(fid);

aa=['sddsmakedataset  -ascii ', [elegant_file_root 'qoffset_new.sdds'], ' -column=ParameterValue,type=double -data=',temp];
dos(aa);

cd (elegant_file_root);
aa=['C:\cygwin\bin\mintty.exe ',[elegant_file_root 'afterbba.txt']];
dos(aa);
cd (matlab_file_root);