function [name, bTot] = bba_staticOrbitCorrection(name, stat, varargin)

% --------------------------------------------------------------------
% Set default options.
optsdef=struct( ...
    'noSet',0 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

if nargin < 2, stat=1;end
if nargin < 1, name='all';end
if isempty(name), return, end

name=cellstr(name);
nameList=allCorr;
if all(strcmp(name,'all')), name=nameList;end
pv=model_nameConvert(name);

bDes=control_magnetGet(name,'BDES');
iOff=control_magnetGet(name,'POLYCOEF.A');
iSlp=control_magnetGet(name,'POLYCOEF.B');
bTot=bDes+iOff./iSlp;

bOff=iOff*0;
if stat, bOff=readCorr(name,nameList);end
iOffNew=iSlp.*bOff;
bDesNew=bTot-bOff;

disp([{'Name' 'BDES' 'BTOT' 'IOFF' 'BOFF' 'BDES2' 'IOFF2'}; ...
    [name num2cell([bDes bTot iOff bOff bDesNew iOffNew])]]);

if opts.noSet, return, end

% Turn off Feedback
fb=control_fbNames;
val=lcaGetSmart(fb,0,'double');
lcaPutSmart(fb,0);pause(1.);

% Apply corrections.
lcaPutSmart(strcat(pv,':POLYCOEF.A'),iOffNew);
lcaPutSmart(strcat(pv,':BDES'),bDesNew);
lcaPutSmart(strcat(pv,':CTRL'),'PERTURB');pause(1.);

% Restore Feedback
lcaPutSmart(fb,val);


function bOff = readCorr(name, nameList)

name=cellstr(name);
[d,id]=ismember(name,nameList);
nPar=1;

id=(id-1)*nPar;

pv='SIOC:SYS0:ML01:FWF03';
arr=lcaGet(pv);

bOff=arr(id+1)';


function name = allCorr()

static=bba_init('sector',{'BSY' 'LTU0' 'LTU1'});
name=static.corrList;
