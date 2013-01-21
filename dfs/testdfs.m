clc;clear all;
elegant_file_root='E:\gitHub\Test\Test\';
matlab_file_root='E:\gitHub\Test\dfs\';

cd (elegant_file_root);
aa=['C:\cygwin\bin\mintty.exe ',[elegant_file_root 'iteration1.txt']];
dos(aa);
checkfile('test11.orbit');
disp('load orbit DONE!');
cd (matlab_file_root);


beamline1=getline_test(1);
elemlist1=getList(beamline1,1000);
%beamline1=EAppend(beamline1,elemlist1);

beamline2=getline_test(0.8);
elemlist2=getList(beamline2,800);
%beamline2=EAppend(beamline2,elemlist2);

beamline3=getline_test(0.6);
elemlist3=getList(beamline3,600);
%beamline3=EAppend(beamline3,elemlist3);

nBpm=length(elemlist1.bpmid);
nCorr=length(elemlist1.corrid);
nQuad=length(elemlist1.quadid);
nElement=length(beamline1);
zBpm=elemlist1.zBpm;
zQuad=elemlist1.zQuad;
% derive Transport Matrice form ELEGANT
%----------------------------------------------------
a1=importdata([elegant_file_root 'test.mat1']);
a2=importdata([elegant_file_root 'test1.mat1']);
a3=importdata([elegant_file_root 'test11.mat1']);
b1=a1.data;
b2=a2.data;
b3=a3.data;

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
  
    for i=1:nElement
     for j=1:6
         for k=1:6
             Tmat3(j,k,i)=b2(i+1,(j-1)*6+k);
         end
     end
  end
%----------------------------------------------------

QRmat1=getQRmat(Tmat1,elemlist1);
QRmat2=getQRmat(Tmat2,elemlist2);
QRmat3=getQRmat(Tmat3,elemlist3);

orbit1=importdata([elegant_file_root 'test.orbit']);
orbit2=importdata([elegant_file_root 'test1.orbit']);
orbit3=importdata([elegant_file_root 'test11.orbit']);

use_noise=0;
bpm_noise1=2e-6*randn(nBpm,1)*use_noise;
bpm_noise2=2e-6*randn(nBpm,1)*use_noise;
bpm_noise3=2e-6*randn(nBpm,1)*use_noise;

orbit_real1=orbit1.data;
orbit_real2=orbit2.data;
orbit_real3=orbit3.data;

qoffsetdata=importdata([elegant_file_root 'test.realquadoffset']);
qoffset_real=qoffsetdata.data;

bpmoffsetdata=importdata([elegant_file_root 'test.realbpmoffset']);
bpmoffset_real=bpmoffsetdata.data;

RQLin=[ones(1,nQuad),zeros(1,nBpm);zQuad,zeros(1,nBpm)];
xQLin=0*RQLin(:,1);
RQMin=[eye(nQuad),zeros(nQuad,nBpm)];
xQMin=0*RQMin(:,1);

RBLin=[zeros(1,nQuad),ones(1,nBpm);zeros(1,nQuad),zBpm];
xBLin=0*RBLin(:,1);
RBMin=[zeros(nBpm,nQuad),eye(nBpm)];
xBMin=0*RBMin(:,1);

RBPM=-eye(nBpm);


RALL=[QRmat1,RBPM;QRmat2,RBPM;QRmat3,RBPM];
xMeas=[orbit_real1+bpm_noise1;orbit_real2+bpm_noise2;orbit_real3+bpm_noise3];
% RALL=[QRmat1,RBPM;QRmat1,RBPM;QRmat1,RBPM];
% xMeas=[orbit_real1+bpm_noise1;orbit_real1+bpm_noise2;orbit_real1+bpm_noise3];
xMeasStd=xMeas*0+.1e-6;


%RLagr=[RQLin,RQLin*0;RQMin,RQMin*0;RBLin*0,RBLin;RBMin*0,RBMin];
% use Quad Min Fit, BPM Min Fit
RLagr=[RQLin;RQMin;RBLin;RBMin];
xLagr=[xQLin;xQMin;xBLin;xBMin];
xLagrStd=ones(size(xLagr))*mean(xMeasStd(1));

% R=[RALL;RLagr];
% x=[xMeas;xLagr];
% weight_factor=1e0;
% w=[weight_factor*ones(size(xMeas));ones(size(xLagr))];
R=[RALL];
x=[xMeas];
weight_factor=1e0;
w=[weight_factor*ones(size(xMeas))];
[offset_calculated,std_offset_calculated]=lscov(R,x,w);

qoffset_calculated=offset_calculated(1:nQuad);
bpmoffset_calculated=offset_calculated(nQuad+1:end);
std_qoffset_calculated=std_offset_calculated(1:nQuad);
std_bpmoffset_calculated=std_offset_calculated(nQuad+1:end);

tt1=cell2mat({qoffset_calculated,qoffset_real});
figure;subplot(2,1,1);
bar(tt1);title('Quad-Offset comparison after 1st correction');
%axis([0 22 -4e-4  4e-4]);
hold on;
tt2=cell2mat({bpmoffset_calculated,bpmoffset_real});
subplot(2,1,2);bar(tt2);
%axis([0 22 -2e-4  4e-4]);
title('BPM-Offset comparison after 1st correction');

qoffset_new=[qoffset_real-qoffset_calculated]';
csvwrite('qoffset_new.dat',qoffset_new);

bpmoffset_new=[bpmoffset_real-bpmoffset_calculated]';
csvwrite('bpmoffset_new.dat',bpmoffset_new);

fid=fopen('qoffset_new.dat','r');
temp=fgets(fid);
fclose(fid);
aa=['sddsmakedataset -ascii ', [elegant_file_root  'qoffset_new1.sdds'], ' -column=ParameterValue,type=double -data=',temp];
dos(aa);

fid=fopen('bpmoffset_new.dat','r');
temp=fgets(fid);
fclose(fid);
aa=['sddsmakedataset  -ascii ', [elegant_file_root 'bpmoffset_new1.sdds'], ' -column=ParameterValue,type=double -data=',temp];
dos(aa);
cd (elegant_file_root);
aa=['C:\cygwin\bin\bash.exe ',[elegant_file_root 'after_iteration1.txt >log1.dat,exit']];
dos(aa);
checkfile('qoffset_new_after_1st.sdds');
disp('1st Corrcetion is DONE!');
cd (matlab_file_root);
