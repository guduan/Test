function static = model_energyMagProfile(static, region, varargin)
%MODEL_ENERGYMAGPROFILE
% STATIC = MODEL_ENERGYMAGPROFILE(STATIC, REGION, OPTS) Acquires klystron amplitudes
% and phases and computes the fudged energy profile. The flag INIT
% indicates to only obtain static klystron information.

% Features:

% Input arguments:
%    STATIC: Structure, default is [] to get fields from
%            MODEL_ENERGYPROFILE and initialize additional fields
%            MAGNET:
%                    NAME:   Names of magnets in region
%                    Z:      Z-location of magnets
%                    LEFF:   Effective length of magnets
%                    KDES:   Design focusing strength of magnets
%                    BETA:   Geometric mean of x/y beta functions
%                    REGION: String(s) indicating region for data used
%    REGION: Optional parameter for accelerator areas, default full, e.g. 'L2'
%    OPTS:   Options
%            DOPLOT: Default 1, if 1, produce LEM plot
%            FIGURE: Default 4, figure number for plot
%            AXES:   Default {4 1}, subplot pattern for plot or axes handles
%            COLOR:  Default [], if not empty, plot CUD style
%            UPDATE: Default 1, if 1 update EACT PVs
%            GETSCP: Default 0, if 1 real SCP klystron phases
%            INIT:   Default 0, if 1 only obtain static information

% Output arguments:
%    STATIC: Structure same as input argument STATIC with fields from
%            MODEL_ENERGYPROFILE and added fields
%            MAGNET:
%                    BDES: BDES of magnets
%                    EDES: EDES of magnets
%                    EACT: EACT of magnets
%                    KACT: Actual focusing strength of magnets
%                    BMAG: Beta mismatch of magnets

% Compatibility: Version 7 and higher
% Called functions: util_parseOptions, model_energyProfile,model_nameConvert,
%                   model_nameRegion, model_rMatGet, control_magnetGet,
%                   model_k1Get, control_energyNames, lcaPutSmart, util_plotInit

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Set default options.
optsdef=struct( ...
    'doPlot',1, ...
    'figure',4, ...
    'axes',{{4 1}}, ...
    'color',[], ...
    'update',1, ...
    'getSCP',0, ...
    'init',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

if nargin < 1, static=[];end
if nargin < 2, region=[];end
if isempty(region), region={'L0' 'L1' 'L2' 'L3' 'LTU'};end
region=cellstr(region);

static=model_energyProfile(static,opts.init,opts.getSCP);

if ~isfield(static,'magnet') || ~isequal(static.magnet.region,region)

    names=model_nameConvert(model_nameRegion([],region,'LEM',1),'MAD');
    isT=strncmp(model_nameConvert(names),'BTRM',4);

    [z,lEff,k1,k,phix,beta]=deal(zeros(numel(names),1));
    [r,z(~isT),lEff(~isT),twiss]=model_rMatGet(names(~isT),names(~isT),{'POS=BEG' 'POSB=END' 'TYPE=DESIGN'});
    [isB,idB]=ismember(names,strtok(names(isT),'T'));
    idT=find(isT);z(idT(idB(isB)))=z(isB);
    phix(~isT)=acos(squeeze(r(1,1,:)));
    k1=real((phix./lEff).^2);
    k1(~lEff)=0;
    beta(~isT)=sqrt(prod(twiss([3 8],:)));
%    k(~isT)=model_rMatModel(names(~isT),[],[],'K',1,'design',1);
%    disp([names num2cell([k1 k'])]);

    static.magnet=struct( ...
        'name',{names},'z',z,'lEff',lEff,'kDes',k1,'beta',beta,'region',{region});
end

if opts.init, return, end

[d,bDes,d,eDes]=control_magnetGet(static.magnet.name);
eAct=interp1(static.prof.z,static.prof.eAct,static.magnet.z);

%{
%nameQ30=strcat('Q30',{'2';'3';'4';'5';'6';'7';'8'},'01');
nameQ30={};
isQ30=ismember(static.magnet.name,nameQ30);
isQ30T=ismember(static.magnet.name,strcat(nameQ30,'T'));
%}

bDesT=bDes;
%bDesT(isQ30)=control_magnetQtrimGet(static.magnet.name(isQ30),bDes(isQ30),bDes(isQ30T));

kAct=model_k1Get(bDesT,static.magnet.lEff',eAct')';
bMag=1+.5*((kAct-static.magnet.kDes).*static.magnet.lEff.*static.magnet.beta).^2;
% BMAG=1+sqrt((BMAGX-1)*(BMAGY-1));

static.magnet.bDes=bDes;
static.magnet.eDes=eDes;
static.magnet.eAct=eAct;
static.magnet.kAct=kAct;
static.magnet.bMag=bMag;

if opts.update
    name=control_energyNames(static.magnet.name);
    lcaPutSmart(strcat(name,':EACT'),static.magnet.eAct);
end

if opts.doPlot, model_energyMagPlot(static,opts);end


function model_energyMagPlot(static, opts)

col='k';if ~isempty(opts.color), col='w';opts.axes={5 1};end
[hAxes,hFig]=util_plotInit(opts);

names=static.magnet.name;
magZ=static.magnet.z;
eDes=static.magnet.eDes;
eAct=static.magnet.eAct;
bMag=static.magnet.bMag;
isBend=strncmp(model_nameConvert(names),'BEND',4);
isQuad=strncmp(names,'Q',1);
isCorr=strncmp(names,'X',1) | strncmp(names,'Y',1);
opts.units='MeV';opts.lim=magZ;
plotError(magZ(isQuad),eAct(isQuad),eDes(isQuad),hAxes(1),'Quad',opts);
plotError(magZ(isBend),eAct(isBend),eDes(isBend),hAxes(2),'Bend',opts);
plotError(magZ(isCorr),eAct(isCorr),eDes(isCorr),hAxes(3),'Corr',opts);
opts.units='';
plotError(magZ(isQuad),bMag(isQuad)*1e-3,0,hAxes(4),'BMAG',opts);
title(hAxes(1),['Energy Error Profile ' static.magnet.region{:} ' ' datestr(now)],'Color',col);
str=sprintf('Fudge Act   Des\nL0    %6.3f %6.3f\nL1    %6.3f %6.3f\nL2    %6.3f %6.3f\nL3    %6.3f %6.3f\n',[static.klys.fudgeAct static.klys.fudgeDes]');
text(.2,.9,str,'Parent',hAxes(2),'Units','normalized','VerticalAlignment','top','Color',col);
if ~isempty(opts.color)
    opts.units='GeV';
    plotError(static.klys.zEnd',cumsum(static.klys.gainF)*1e-3,0,hAxes(5),'Klys',opts);
    set(hAxes(5),'XLim',get(hAxes(1),'XLim'));
    set(hFig,'Color','k','MenuBar','none');
end
set(hAxes(end),'XTickLabelMode','auto');
util_marginSet(hFig,[.12 .05],[.12 0.03*ones(1,numel(hAxes)-1) .08]);


function plotError(z, eAct, eRef, ax, lab, opts)

col='k';if ~isempty(opts.color), col='w';end
plot(ax,z(~~z),z(~~z)*0,col);
hold(ax,'on');
colList=get(ax,'ColorOrder');
delta=eAct-eRef;
good=abs(delta./eRef) < 5e-3 & z;
bad=~good & z;
if ~strcmp(opts.units,'MeV'), good=z > 0;bad=~good;end
stem(ax,z(good),delta(good)*1e3,'.','Color',colList(2,:),'ShowBaseLine','off');
hold(ax,'on');
h=stem(ax,z(bad),delta(bad)*1e3,'.r','ShowBaseLine','off');
plot(ax,opts.lim,opts.lim*0,col);
set(h,'ShowBaseLine','off');
if isempty(opts.units)
    set(get(h,'BaseLine'),'BaseValue',1);
    plot(ax,opts.lim,opts.lim*0+1,col);
    yLim=get(ax,'YLim');set(ax,'YLim',[1 yLim(2)]);
end
hold(ax,'off');
ylabel(ax,[lab ' (' opts.units ')']);
set(ax,{'XColor' 'YColor'},{col col});
col='w';if ~isempty(opts.color), col='k';end
set(ax,'Color',col,'XTickLabel','');
