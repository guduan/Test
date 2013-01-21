function [R, en] = bba_responseMatGet(static,e0)

% Calculate response matrix for energy EN.
% xMeas = R * [xInit; xQuadOff; xBPMOff; undOff; BCorr]
% 
% if nargin < 2, appMode=0;end
% if nargin < 3, enOnly=0;end

% en=lcaGet('SIOC:SYS0:ML00:AO875');
en=e0;

% if enOnly, R=[];return, end

name=control_energyNames(static.corrList);
if appMode && ~any(strncmp(name,'XCOR:UND1',9)) && ~isempty(name)
%if any(isSLC)
    enList=lcaGet(strcat(name,':EDES'));
else
%    enList=en;
    enList=model_energy(static.corrList)';
end
enList=kron(enList,[1;1]);
bp=enList/299.792458*1e4; % kG m

bpmList=static.bpmList;
quadList=static.quadList;
undList=static.undList;
corrList=static.corrList;
nQuad=length(static.quadList);
nUnd=length(static.undList);
nBPM=length(static.bpmList);
nCorr=length(static.corrList);
zQuad=static.zQuad;
zUnd=static.zUnd;
zBPM=static.zBPM;
zCorr=static.zCorr;
lUnd=static.lUnd;

if strcmp(model_init,'SLC')
    opts=[repmat({'POS=BEG'},nQuad+nUnd,1);repmat({'POS=END'},nQuad+nUnd+nBPM+nCorr,1)];
    rList=model_rMatGet([quadList;undList;quadList;undList;bpmList;corrList],[],opts);
    r0=rList(:,:,2*nQuad+2*nUnd+1);
    for j=1:size(rList,3)
        rList(:,:,j)=rList(:,:,j)*inv(r0);
    end
else
    opts=[repmat({'POSB=BEG'},nQuad+nUnd,1);repmat({'POSB=END'},nQuad+nUnd+nBPM+nCorr,1)];
    rList=model_rMatGet(bpmList{1},[quadList;undList;quadList;undList;bpmList;corrList],opts);
end

rQuadB=rList(:,:,1:nQuad);
rUndB=rList(:,:,nQuad+(1:nUnd));
rQuadE=rList(:,:,nQuad+nUnd+(1:nQuad));
rUndE=rList(:,:,2*nQuad+nUnd+(1:nUnd));
rBPM=rList(:,:,2*nQuad+2*nUnd+(1:nBPM));
rCorrE=rList(:,:,2*nQuad+2*nUnd+nBPM+(1:nCorr));

%RQuad=kickMat(rQuadB,rQuadE,zQuad,zBPM,0,[1 3]);
%RUnd=kickMat(rUndB,rUndE,zUnd,zBPM,lUnd,1:4);
%RCorr=kickMat(0,rCorrE,zCorr,zBPM,0,[2 4]);

iInit=[1:4 6];nInit=numel(iInit);
[RQuad,RUnd,RCorr]=deal(zeros(nBPM*nInit,0));
for j=1:nQuad
    use=zQuad(j) < zBPM(:);
    rQuad=(inv(rQuadE(1:4,1:4,j))-inv(rQuadB(1:4,1:4,j)))*[1 0;0 0;0 1;0 0];
    RQuad=[RQuad kron(use,[rQuad;zeros(nInit-4,2)])];
end
for j=1:nUnd
    use=zUnd(j) < zBPM(:);
%    dUnd=kron(eye(2),[1 lUnd(j);0 1]);
%    rUnd=(inv(rUndE(1:4,1:4,j))*dUnd-inv(rUndB(1:4,1:4,j)));
    rUnd=inv(rUndE(1:4,1:4,j))*eye(4);
    RUnd=[RUnd kron(use,[rUnd;zeros(nInit-4,4)])];
end
for j=1:nCorr
    use=zCorr(j) < zBPM(:);
    rCorr=inv(rCorrE(1:4,1:4,j))*[0 0;1 0;0 0;0 1];
    RCorr=[RCorr kron(use,[rCorr;zeros(nInit-4,2)])];
end

rBPMCell=num2cell(rBPM([1 3],iInit,:),[1 2]);
RBPM=blkdiag(rBPMCell{:});
RInit=repmat(eye(nInit),nBPM,1);
RBPMOff=-eye(2*nBPM);
R=[RBPM*[RInit RQuad] RBPMOff RBPM*[RUnd*diag(1./kron(bp(1:2*nUnd),[1;1])) RCorr*diag(1./bp)]];


%function R = kickMat(rB, rE, z, zBPM, l, id)

%p=eye(4);nId=numel(id);
%R=[];R=zeros(4*numel(zBPM),nId*numel(z));
%for j=1:numel(z)
%    use=z(j) < zBPM(:);
%    rBinv=0;if numel(rB) > 1, rBinv=inv(rB(1:4,1:4,j));end
%    rD=kron(eye(2),[1 l(min(j,end));0 1]);
%    r=(inv(rE(1:4,1:4,j))*rD-rBinv)*p(:,id);
% %   R=[R kron(use,r)];
%    R(:,(1:nId)+(j-1)*nId)=kron(use,r);
%end
