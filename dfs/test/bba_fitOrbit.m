function [result, opts] = bba_fitOrbit(static, RAll, xMeas, xMeasStd, varargin)

% Set defaults.
optsdef=struct( ...
    'use',struct('init',1,'quad',1,'BPM',1,'corr',0,'und',0), ...
    'iQuad',[], ...
    'iBPM',[], ...
    'iUnd',[], ...
    'iCorr',[], ...
    'iInit',[], ...
    'fitSVDRatio',0, ...
    'fitScale',1, ...
    'fitBPMLin',0, ...
    'fitBPMMin',0, ...
    'fitQuadLin',0, ...
    'fitQuadMin',0, ...
    'fitQuadAbs',0, ...
    'fitCorrMin',0, ...
    'fitCorrAbs',0, ...
    'corrB',[] ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);
if ~isfield(opts.use,'und'), opts.use.und=0;end

% Check for measurement std.
if nargin < 4, xMeasStd=[];end
if isempty(xMeasStd) || ~all(xMeasStd(:)) || any(isnan(xMeasStd(:)))
    xMeasStd=xMeas*0+.1e-6;
end

% Parameter vector is x = [xInit(2) xQuad(2) xBPM(2) xUnd(4) xCorr(2)]'
% Measurement vector is y = [yBPM]'
% Response matrix is y = R * x

% Get number of parameters.
nQuad=length(static.quadList);
nBPM=length(static.bpmList);
nUnd=length(static.undList);
nCorr=length(static.corrList);
nMeas=numel(xMeas);
RAll=reshape(RAll,nMeas,[]);
nPar=size(RAll,2);
nEn=nMeas/nBPM/2;
nInit=(nPar-2*(nQuad+nBPM+2*nUnd+nCorr))/nEn;

% Get index range for parameters
iMax=0;
iInit=reshape(iMax+(1:nEn*nInit),nInit,[]);iMax=max([iMax iInit(:)']);
iQuad=reshape(iMax+(1:2*nQuad),2,[]);iMax=max([iMax iQuad(:)']);
iBPM=reshape(iMax+(1:2*nBPM),2,[]);iMax=max([iMax iBPM(:)']);
iUnd=reshape(iMax+(1:4*nUnd),4,[]);iMax=max([iMax iUnd(:)']);
iCorr=reshape(iMax+(1:2*nCorr),2,[]);

% Check correctors.
if isempty(opts.corrB)
    opts.corrB=zeros(2,length(static.corrList),nEn);
end

% Set nonexisting corrs to NaN.
useX=strncmp(static.corrList,'X',1);
useY=strncmp(static.corrList,'Y',1);
opts.corrB(1,~useX,:)=NaN;
if any(useY), opts.corrB(2,~useY,:)=NaN;end
corrB=reshape(opts.corrB(:,:,1),[],1);
badCorr=isnan(corrB);

% Subtract orbit from non-zero correctors.
if nEn > 1 && nCorr
    RC=num2cell(reshape(RAll(:,iCorr(:))',[],2*nBPM,nEn),[1 2]);
    RC=blkdiag([],RC{:})';
    opts.corrB(isnan(opts.corrB))=0;
    xCorr=RC*opts.corrB(:);
else
    xCorr=0;
end
xMeas(:)=xMeas(:)-xCorr;

% Set up used measurements.
useMeas=false(size(xMeas));useMeas(:,1:nBPM,:)=true;
useMeas=useMeas & ~isnan(xMeas);
useMeas=find(useMeas);

% Constraints
sigBPM=nQuad*opts.fitScale;
sigCorr=nCorr*opts.fitScale;
[RBLin,RBMin,RQLin,RQMin,RCMin]=deal(zeros(0,nPar));
[xBLin,xBMin,xQLin,xQMin,xCMin]=deal(zeros(0,1));

% Linear BPM Constraint
if opts.fitBPMLin
    RBLin(1:4,iBPM)=kron([ones(1,nBPM);static.zBPM],eye(2));
    xBLin=RBLin(:,1)*0;
end

% Min BPM Constraint
if opts.fitBPMMin
    RBMin(1:2*nBPM,iBPM)=eye(2*nBPM)/sigBPM;
    xBMin=RBMin(:,1)*0;
end

% Linear Quad Constraint
if opts.fitQuadLin
    RQLin(1:4,iQuad)=kron([ones(1,nQuad);static.zQuad],eye(2));
    xQLin=RQLin(:,1)*0;
end

% Min Quad Constraint
if opts.fitQuadMin || opts.fitQuadAbs
    RQMin(1:2*nQuad,iQuad)=eye(2*nQuad)/sigBPM;
    xQMin=RQMin(:,1)*0;
    if opts.fitQuadAbs, xQMin=[1 -.5 0 .1]'*1e-3/sigBPM;end
end

% Min corr Constraint
if opts.fitCorrMin || opts.fitCorrAbs
    RCMin(1:2*nCorr,iCorr)=eye(2*nCorr)/sigCorr;
    RCMin(badCorr,:)=[];
    xCMin=RCMin(:,1)*0;
    if opts.fitCorrAbs, xCMin=corrB(~badCorr)/sigCorr;end
end

% Assemble constraint matrix and vector
RLagr=[RBLin;RBMin;RQLin;RQMin;RCMin];
xLagr=[xBLin;xBMin;xQLin;xQMin;xCMin];
xLagrStd=ones(size(xLagr))*mean(xMeasStd(useMeas));

% Set up used parameters.
xParF=zeros(nPar,1);
xParFStd=zeros(nPar,1);
r.xMeasF=xMeas*0;
if isempty(opts.iInit), opts.iInit=1:nInit;end
if isempty(opts.iQuad), opts.iQuad=1:nQuad;end
if isempty(opts.iBPM), opts.iBPM=1:nBPM;end
if isempty(opts.iCorr), opts.iCorr=1:nCorr;end
if isempty(opts.iUnd), opts.iUnd=1:nUnd;end
usePar=[reshape(iInit(opts.iInit,:),1,[])*opts.use.init ...
        reshape(iQuad(:,opts.iQuad),1,[])*opts.use.quad ...
        reshape(iBPM(:,opts.iBPM),1,[])*opts.use.BPM ...
        reshape(iCorr(:,opts.iCorr),1,[])*opts.use.corr ...
        reshape(iUnd(:,opts.iUnd),1,[])*opts.use.und];
usePar(~usePar)=[];
usePar=setdiff(usePar,iCorr(badCorr));

% Fit initial conditions and offsets.
RF=RAll(useMeas,usePar);
R=[RF;RLagr(:,usePar)];
x=[xMeas(useMeas);xLagr];
w=1./[xMeasStd(useMeas);xLagrStd].^2;
if opts.fitSVDRatio || isempty(R)
    [xParF(usePar),xParFStd(usePar)]=util_lssvd(R,x,w,opts.fitSVDRatio);
elseif ~isempty(R)
    [xParF(usePar),xParFStd(usePar)]=lscov(R,x,w);
end

% Put results into individual parameter vectors.
r.xMeasF(useMeas)=RAll(useMeas,usePar)*xParF(usePar);
%r.xMeasF(:)=RAll(:,usePar)*xParF(usePar);
r.xInit=xParF(iInit);
r.xInitStd=xParFStd(iInit);
r.quadOff=xParF(iQuad);
r.quadOffStd=xParFStd(iQuad);
r.bpmOff=xParF(iBPM);
r.bpmOffStd=xParFStd(iBPM);
r.corrOff=xParF(iCorr);
r.corrOffStd=xParFStd(iCorr);
r.undOff=xParF(iUnd);
r.undOffStd=xParFStd(iUnd);
r.xMeasF(:)=r.xMeasF(:)+xCorr;
result=r;
