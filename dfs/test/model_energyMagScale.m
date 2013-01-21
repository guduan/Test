function [m, k] = model_energyMagScale(magnet, klys, varargin)
%ENERGYMAGSCALE
% [M, K] = ENERGYMAGSCALE(MAGNET, KLYS, OPTS) calculates new BDES for
% magnets in structure MAGNET by scaling from EDES to EACT. Also calculates
% proper current for bend trims present in the device list.

% Features:

% Input arguments:
%    MAGNET: Structure as returned from MODEL_ENERGYMAGPROFILE
%    KLYS:   Optional, default []. Then MAGNET & KLYS are the sub-structures
%    OPTS:   Options
%            UNDMATCH:  Default 0, calculate undulator matching quad BDES
%            DESIGN:    Default 0, set non-matching quads to design
%            DESIGNALL: Default 0, set all quads to design
%            DISPLAY:   Default 0, print list of names and values

% Output arguments:
%    M: Updated structure MAGNET
%    K: Updated structure KLYS

% Compatibility: Version 7 and higher
% Called functions: util_parseOptions, model_energyUndMatch,
%                   model_energyBTrim,
%                   (obsolete) control_magnetQtrimGet, control_magnetQtrimSet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Set default options.
optsdef=struct( ...
    'undMatch',0, ...
    'design',0, ...
    'designAll',0, ...
    'display',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);
if nargin < 2, klys=[];end

m=magnet;k=klys;
if isfield(magnet,'magnet'), [m,k]=deal(m.magnet,m.klys);end
if ~isfield(m,'bDes'), return, end

bDes=m.bDes;

%nameQ30=strcat('Q30',{'2';'3';'4';'5';'6';'7';'8'},'01');
nameQ30={};
isQUM=ismember(m.name,strcat('QUM',{'1';'2';'3';'4'}));
isQ30=ismember(m.name,nameQ30);
isT.Q30=ismember(m.name,strcat(nameQ30,'T'));
isT.BXH=ismember(m.name,strcat('BXH',{'1';'3';'4'},'T'));
isT.BX0=ismember(m.name,strcat('BX0',{'1'},'T'));
isT.BX1=ismember(m.name,strcat('BX1',{'1';'3';'4'},'T'));
isT.BX2=ismember(m.name,strcat('BX2',{'1';'3';'4'},'T'));
isT.BX3=ismember(m.name,strcat('BX3',{'1';'2';'5';'6'},'T'));
isTrim=isT.Q30 | isT.BXH | isT.BX1 | isT.BX2 | isT.BX3;
m.eAct(isTrim)=0;

% Unused code for LI30 quad trims.
bDes(isQ30)=control_magnetQtrimGet(m.name(isQ30),bDes(isQ30),bDes(isT.Q30));

bDesOld=bDes;
bDes=m.eAct./m.eDes.*bDes;

if opts.design || opts.designAll
    nameMatch=[{'QA01' 'QA02' 'QE01' 'QE02' 'QE03' 'QE04' 'QM01' 'QM02' ...
        'QB' 'QM03' 'QM04' 'Q21201' 'Q21301' 'QM11' 'QM12' 'QM13'} ...
        strcat('Q26',{'2' '3' '4' '5' '6' '7' '8' '9'},'01') ...
        {'QSM1' 'QEM1' 'QEM2' 'QEM3' 'QEM4' 'QEM3V' 'QUM1' 'QUM2' 'QUM3' 'QUM4'}];
    if opts.designAll, nameMatch={};end
    isDesign=strncmp(m.name,'Q',1) & ~ismember(m.name,nameMatch);
    bp=m.eAct/299.792458*1e4; % kG m
    bDesign=m.kDes.*bp.*m.lEff; % 1/m^2
    bDes(isDesign)=bDesign(isDesign);
end

bDesNew=bDes;

if sum(isQUM) == 4 && opts.undMatch
    bDes(isQUM)=model_energyUndMatch(m.eAct(find(isQUM,1)));
end
for tag={'BXH' 'BX0' 'BX1' 'BX2' 'BX3'}
    isTag=isT.(tag{:});
    if any(isTag)
        % Get desired main BDES from second magnet BXn2
        bDes(isTag)=model_energyBTrim(bDes(strcmp(m.name,[tag{:} '2'])),[],tag{:});
    end
end
%{
if sum(isT.BX3) == 4
    bDes(isT.BX3)=model_energyBTrim(bDes(strcmp(m.name,'BX32')),[],'BX3');
%    bDes(isT.BX3)=model_energyBX3trim(bDes(strcmp(m.name,'BYD1')));
end
%}
[bDes(isQ30),bDes(isT.Q30)]=control_magnetQtrimSet(m.name(isQ30),bDes(isQ30));
bDesNew(isTrim)=bDes(isTrim);

% Display results.
if opts.display
    [z,id]=sort(m.z);
    disp([m.name(id) num2cell([(m.eAct(id)-m.eDes(id))*1e3 bDesOld(id) bDesNew(id)])]);
end

% Update magnet structure.
m.bDes=bDes;
m.eDes=m.eAct;

% Update klys structure.
if ~isempty(klys), k.fudgeDes=k.fudgeAct;end

if isfield(magnet,'magnet'), m=struct('magnet',m,'klys',k);end
