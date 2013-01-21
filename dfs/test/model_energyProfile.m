function static = model_energyProfile(static, init, getSCP)
%MODEL_ENERGYPROFILE
% STATIC = MODEL_ENERGYPROFILE(STATIC, INIT, GETSCP) Acquires klystron
% amplitudes and phases and computes the fudged energy profile. The flag
% INIT indicates to only obtain static klystron information. If GETSCP is
% set then SCP phases will be acquired or otherwise assumed to be zero.

% Features:

% Input arguments:
%    STATIC: Structure, default is [] to initialize the subsequent fields
%            PROF:
%                  Z:      Z-location of klystron segments
%                  ENERGY: Design energy of klystron segments
%            KLYS:
%                  NAME: List of klystron names
%                  ZEND: Z-position of structure end
%                  ZBEG: Z-position of structure begin
%    INIT  : Initialize only, don't acquire klystron actual data
%    GETSCP: Acquire klystron SCP phases, otherwise assume zero

% Output arguments:
%    STATIC: Structure same as input argument STATIC with added fields
%            PROF:
%                  EACT: Actual energy profile along klystron segments
%            KLYS:
%                  GAIN:     Klystron gain from ENLD and phase
%                  GAINF:    Fudged klystron gains
%                  FUDGEDES: Previously used fudge factors
%                  FUDGEACT: Newly calculated fudge factors

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert, model_rMatGet,
%                   model_energyKlys, model_energyFudge,
%                   model_energySetPoints

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Get static data.
if nargin < 1 || isempty(static)
    
    % Get list of klystron names.
    klysList=model_nameConvert({'ACCL' 'KLYS'},'MAD',{'IN20' 'LI21' 'LI22' 'LI23' 'LI24' 'LI25' 'LI26' 'LI27' 'LI28' 'LI29' 'LI30'});
    klysList=setdiff(klysList,{'21-1' '21-2' '24-7' '24-8' '29-0' '30-0'})';
    pvKlys=model_nameXAL(klysList);

    % Get design klystron energy profile.
    model_init('source','EPICS','online',1);
    [pv,z,d,d,energy]=model_rMatGet('*',[],'TYPE=DESIGN');
    use=[1;find(ismember(pv,pvKlys));numel(z)];
    [static.prof.z,id]=unique(z(use)');
    static.prof.energy=energy(use(id))';

    % Find begin and end position of klystrons.
    [d,id]=ismember(pvKlys,pv);
    [id,id2]=sort(id);
    static.klys.name=klysList(id2);
    static.klys.zEnd=z(id);
    [d,id]=ismember(pvKlys,flipud(pv));
    static.klys.zBeg=z(sort(end+1-id));
end

if nargin > 1 && init, return, end

% Get actual klystron status, amplitude, & phase.
if nargin < 3, getSCP=0;end
[enld,totalPh,is]=model_energyKlys(static.klys.name,0,getSCP);

% Calculate fudge factors.
[gainF,fudgeAct]=model_energyFudge(enld,totalPh,is);

% Get fudge PVs.
fudgePV=strcat('SIOC:SYS0:ML00:AO40',{'1' '2' '3' '4'}');

static.klys.gain=enld*1e-3.*cosd(totalPh);
static.klys.gainF=gainF;
static.klys.fudgeDes=lcaGet(fudgePV);
static.klys.fudgeAct=fudgeAct;

% Calculate actual energy profile.
z=static.prof.z;%eAct=static.prof.energy;
energyDef=model_energySetPoints;
%eAct(:)=energyDef(1);
deAct=[energyDef(1);diff(static.prof.energy)];
for j=1:numel(static.klys.name)
%    use=z >= static.klys.zBeg(j) & z <= static.klys.zEnd(j);
%    en=static.prof.energy(use);
%    eAct(use)=(en-en(1))/(en(end)-en(1))*static.klys.gainF(j)+eAct(end);
%    eAct(find(use,1,'last'):end)=eAct(find(use,1,'last'));

    use=z > static.klys.zBeg(j) & z <= static.klys.zEnd(j);
    deAct(use)=deAct(use)/sum(deAct(use))*static.klys.gainF(j);
end
%static.prof.eAct=eAct;
static.prof.eAct=cumsum(deAct);
