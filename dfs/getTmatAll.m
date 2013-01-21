function R = getTmatAll(Tmat,idbeg,idend)
% just the matrices BETWEEN idbeg and idend
% NOT include matrix of idbeg and edend

R=eye(6);
R1=eye(6);
for n=(idbeg+1):(idend-1)
    R1=Tmat(:,:,n)*R;
    R=R1;
end








