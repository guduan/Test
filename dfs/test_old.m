clear all;
clc;

global nBpm nxCorr nyCorr nQuad c q b xinit zBpm nCorr

bl1=getline_sxfel('linac',1);
list1=getList(bl1,4);
bl1=EAppend(bl1,list1);
Tmat1 = getTmatEach(bl1);

bl2=getline_sxfel('linac',0.9);
list2=getList(bl2,4);
bl2=EAppend(bl2,list2);
Tmat2 = getTmatEach(bl2);

nBpm=length(list1.bpmid);
nxCorr=length(list1.xcorrid);
nyCorr=length(list1.ycorrid);
nQuad=length(list1.quadid);
zBpm=list1.zBpm;
nCorr=nxCorr;

RespMat1= getRmat(Tmat1,list1,'y');
RespMat2= getRmat(Tmat2,list2,'y');

% xinit=1.0e-3*[0.0399
% -0.1194
% ];
%c=zeros(nCorr,1);
xinit=10*1e-6*randn(2,1);
c=10e-6*randn(nCorr,1);
q=50e-6*randn(nQuad,1);%quad offset
b=10e-6*randn(nBpm,1);%bpm offset

xx=[xinit;c;q;b];
y1=RespMat1*xx;
y2=RespMat2*xx;
delta_y=y2-y1;

y=[y1;delta_y];
Rfull=[RespMat1;RespMat2-RespMat1];
save('R.mat','Rfull','-ASCII');

if zBpm(1)~=0
    temp=zeros(1,nBpm);
    for n=1:nBpm-1
        temp(n+1)=zBpm(n);
    end
    zBpm=temp;
end
figure
plot(zBpm,y1,'r-*');%title('Orbit before correction');
hold on;
% DFS correction
w=ones(2*nBpm,1);
w(1:nBpm)=0.1;          %weight factor
w(nBpm+1:end)=5000;
xfinal=lssvd(Rfull,y,w);

for n=1:2 %correction times
    [xfinal,y]=correct1(xfinal,Rfull);
end
orbit=y(1:length(y)/2);
%figure
plot(zBpm,orbit,'b-o');%title('Orbit after DFS correction');

