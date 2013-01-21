function [xfinal0,y0]=correct1(xfinal0,R0)

global nBpm nCorr nQuad c q b zBpm  xinit
%apply correction
%lanch_x=xfinal(1:2);
corr_xoffset=xfinal0(3:2+nCorr);
quad_xoffset=xfinal0(3+nCorr:2+nCorr+nQuad);
bpm_xoffset=xfinal0(3+nCorr+nQuad:2+nCorr+nQuad+nBpm);
%上面四个都是解出来的需要校正的值
xinit=xinit-xfinal0(1:2);
c=c-corr_xoffset;
q=q-0.8*quad_xoffset;
b=b-bpm_xoffset;
%消去误差值，形成一组新的误差向量
xx=[xinit;c;q;b];
y0=R0*xx;

%give the orbit and plot the orbit
%plot(zBpm,y,'color','black');
%hold on
%计算新误差向量下，进一步校正所需要的各种校正值
xfinal0=lssvd(R0,y0);


