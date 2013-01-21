function bba_klysOrbitCorrection(name, stat, varargin)

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
nameList=allKlys;
if all(strcmp(name,'all')), name=nameList;end
name(ismember(name,{'21-1' '21-2' '24-7' '24-8'}))=[];

% Get klystron amplitude and total phase.
getSCP=1;
[amp,phase]=model_energyKlys(name,0,getSCP);
isAct=amp ~= 0;

% Get temporary correction values.
[corrAmp,corrPhs,corrOff]=readKlys(name);

% Calculate corrector strength.
corrX=isAct.*(corrAmp(:,1).*cosd(phase-corrPhs(:,1))+corrOff(:,1));
corrY=isAct.*(corrAmp(:,2).*cosd(phase-corrPhs(:,2))+corrOff(:,2));
bOff=-[corrX;corrY];

% Get corrector names.
id=reshape(sscanf(sprintf('%s\n',name{:}),'%d-%d\n'),2,[])';
iSect=id(:,1);
iKlys=id(:,2);
nameX=strrep(strcat('XC',cellstr(num2str(iSect)),cellstr(num2str(iKlys+1)),'02'),'902','900');
nameY=strrep(strcat('YC',cellstr(num2str(iSect)),cellstr(num2str(iKlys+1)),'03'),'903','900');
pv=model_nameConvert([nameX;nameY]);

bDes=control_magnetGet(pv,'BDES');
iOff=control_magnetGet(pv,'POLYCOEF.A');
iSlp=control_magnetGet(pv,'POLYCOEF.B');
bTot=bDes+iOff./iSlp;

switch stat
    case 0 % Turn off, no change in IDES
        bDesNew=bTot;
        iOffNew=iOff*0;
    case 1 % Turn on, no change in IDES
        iOffNew=iSlp.*bOff;
        bDesNew=bTot-bOff;
    case 2 % Update
        bDesNew=bDes;
        iOffNew=iSlp.*bOff;
end

disp([{'Name' 'BDES' 'BTOT' 'IOFF' 'BOFF' 'BDES2' 'IOFF2' 'Amp'}; ...
    [[nameX;nameY] num2cell([bDes bTot iOff bOff bDesNew iOffNew corrAmp(:)])]]);

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


function [corrAmp, corrPhs, corrOff] = readKlys(name)

name=cellstr(name);
id=reshape(sscanf(sprintf('%s\n',name{:}),'%d-%d\n'),2,[])';
iSect=id(:,1);
iKlys=id(:,2);
nPar=6;

id=((iSect-21)*8+iKlys-1)*nPar;

pv='SIOC:SYS0:ML01:FWF02';
arr=lcaGet(pv);

corrAmp=arr([id+1 id+4]);
corrPhs=arr([id+2 id+5]);
corrOff=arr([id+3 id+6]);


function name = allKlys()

[a,b]=meshgrid(21:30,1:8);
name=strcat(num2str(a(:)),{'-'},num2str(b(:)));
