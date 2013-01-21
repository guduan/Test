function [xMeas, x0] = bba_bpmDataGet(static, R, appMode, handles, varargin)

% Real positions of quads, BPMs, undulators, and beam
global quadOff undOff bpmOff corrB xInit strayB

optsdef=struct( ...
    'useBPMNoise',0, ...
    'useBeamJitt',0, ...
    'bpmNoise',1, ... % um
    'beamJitt',10, ... % um
    'beamEnerJitt',0, ... % 10^-4
    'beamAngle',1, ... % urad
    'eDefNum',0, ...
    'corrNoise',1, ... % kGm 10^6
    'useCorrNoise',0, ...
    'eDefOn',1, ...
    'init',1);

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

% BPM PVs
[pvList,d,isSLC]=model_nameConvert(static.bpmList,'EPICS');
pv=[strcat(pvList(:),':X') strcat(pvList(:),':Y')]';
isSLC=[isSLC(:) isSLC(:)]';isSLC=isSLC(:);
pvT=strrep(strrep(pv,':X',':TMIT'),':Y',':TMIT');
pvStat=strrep(strrep(pv,':X',':ACCESS'),':Y',':ACCESS');

nVal=handles;
if isstruct(handles)
    nVal=handles.dataSample.nVal;
    if isfield(handles,'eDefNumber')
        opts.eDefNum=handles.eDefNumber;
    end
end

% Production mode
if appMode && ~ispc
    if opts.eDefOn
        eDefParams(opts.eDefNum,1,nVal+1);
        eDefOn(opts.eDefNum);
    end
    xBPM=zeros(numel(pv),nVal);
    stat=zeros(numel(pv),1);
    if any(isSLC)
        for j=1:nVal
            xBPM(isSLC,j)=lcaGet(pv(isSLC))*1e-3;
            pause(2.);
        end
        tmit(isSLC,1)=lcaGet(pvT(isSLC));
    end
%    set(handles.status_txt,'String',sprintf('Waiting for eDef completion'));
%    drawnow;
    nTry=300;
    while nTry && ~eDefDone(opts.eDefNum), nTry=nTry-1;pause(.2);end
%    set(handles.status_txt,'String',sprintf('eDef completed'));
%    drawnow;
%    handles=guidata(hObject);

    hst=['HST' num2str(opts.eDefNum)];
    pvHst=strcat(pv(:),hst);
    pvTHst=strcat(pvT(:),hst);
    xBPM(~isSLC,:)=lcaGetSmart(pvHst(~isSLC),nVal)*1e-3;
    tmit(~isSLC,1)=lcaGetSmart(pvTHst(~isSLC),1);
    stat(~isSLC)=lcaGetSmart(pvStat(~isSLC),0,'double');
    xBPM(tmit < 1e7 | stat,:)=NaN;
    xMeas=reshape(xBPM,2,[],nVal);
    return
end

% Simulation mode

% Initial launch.
beamJitt=opts.beamJitt*1e-6;
beamAngle=opts.beamAngle*1e-6;
beamEnerJitt=opts.beamEnerJitt*1e-4;
xInit0=[eye(2,3);eye(2,3);[0 0 1]]*[beamJitt;beamAngle;beamEnerJitt]*opts.useBeamJitt;

% Get corrector strengths and stray fields.
nCorr=length(static.corrList);
bDes=bba_corrGet(static,appMode);
bDes=bDes(:)+strayB(:);bDes(isnan(bDes))=0;
corrNoise0=opts.corrNoise(:)*1e-6*opts.useCorrNoise;
corrNoise0(1:2*nCorr,1)=corrNoise0(1:end);

% BPM noise.
nBPM=length(static.bpmList);
bpmNoise0=opts.bpmNoise(:)*1e-6*opts.useBPMNoise;
bpmNoise0(1:2*nBPM,1)=bpmNoise0(1:end);

% Get initial launch.
nInit=4+mod(size(R,2),2);
xInit(end+1:nInit)=0;
x0=repmat(xInit,1,nVal)+randn(nInit,nVal).*repmat(xInit0(1:nInit),1,nVal);

% Get BPM noise.
bpmNoise=randn(2*nBPM,nVal).*repmat(bpmNoise0,1,nVal);

% Get Corr noise.
corrNoise=randn(2*nCorr,nVal).*repmat(corrNoise0,1,nVal);
corr0=repmat(bDes,1,nVal)+corrNoise;

% Initial conditions and offsets vector.
uPos=control_magnetGet(static.undList,'TMXPOSC')';
uOff=undOff+1e-5*[15;-5;-7;10]*((uPos > 0 & uPos < 70).*(80-uPos)/30); % [kG-m^2 kG-m]
xPar=[x0;repmat([quadOff(:);bpmOff(:);uOff(:)],1,nVal);corr0];

% Calculate orbit.
x=R*xPar+bpmNoise;

if ispc
%    pvOff=[strcat(pvList(:),':XAOFF') strcat(pvList(:),':YAOFF')]';
%    off=lcaGet(strcat(pvOff(:)));
%    lcaPut(pvOff(:),xMeas(:)*1e3+off);
    lcaPut(pv(:),x(:,end)*1e3);
end
xMeas=reshape(x,2,[],nVal);
