function [bAct, bDes, bMax, eDes] = control_magnetGet(name, secn)
%CONTROL_MAGNETGET
%  CONTROL_MAGNETGET(NAME) get magnet NAME:BACT and NAME:BDES.

% Features:

% Input arguments:
%    NAME: Base name of magnet PV.

% Output arguments:
%    BACT: Magnet BACT  actual B ?
%    BDES: Magnet BDES  design B ?
%    BMAX: Magnet BMAX

% Compatibility: Version 7 and higher
% Called functions: lca*

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

name=cellstr(name);name=name(:);
[name,d,isSLC]=model_nameConvert(name,'EPICS');
[bAct,bDes,bMax,eDes]=deal(zeros(size(name)));
if isempty(name), return, end

% Get magnet B or undulator K or Collimator V
str=repmat({'B'},numel(name),1);
isUnd=strncmp(name,'USEG',4);
str(isUnd)={'K'};
nn=char(name);
nn(:,1:min(5,end))=[];
isStep=strncmp(cellstr(nn),'STEP',4);str(isStep)={'V'};

% Do BNDS/QUAS stuff.
[nameLGPS,is]=control_magnetNameLGPS(name,isSLC);

if nargin < 2
    secn=strcat(str,'ACT');
else
    secn=cellstr(secn);secn=secn(:);secn(end+1:numel(name),1)=secn(end);
end

% Read back BACT.
isBDES=strcmp(secn,'BDES');
nameBACT=name;nameBACT(is.Str & isBDES)=nameLGPS(isBDES(is.Str));
bAct=lcaGetSmart(strcat(nameBACT,':',secn));

if nargout > 1
    nameBDES=name;nameBDES(is.Str)=nameLGPS;
    bDes=lcaGetSmart(strcat(nameBDES,':',str,'DES'));
end

if nargout > 2
    nameBMAX=name;nameBMAX(is.Str)=nameLGPS;
    bMax=lcaGetSmart(strcat(nameBMAX,':',str,'MAX'));
end

if nargout > 3
    nameEDES=control_energyNames(name);
    eDes=NaN(size(name));
    if any(~is.Str), eDes(~is.Str)=lcaGetSmart(strcat(nameEDES(~is.Str),':EDES'));end
    if any(is.QUAS), eDes(is.QUAS)=lcaGetSmart(strcat(name(is.QUAS),':EMOD'));end
end
