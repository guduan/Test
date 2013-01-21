function bAct = control_magnetSet(name, val, varargin)
%CONTROL_MAGNETSET
%  CONTROL_MAGNETSET(NAME, VAL, OPTS) set magnet NAME:BDES to VAL and
%  perturbes. Returns the new BACT as VAL. Depending on OPTS, the magnet
%  can also be trimmed.

% Features:

% Input arguments:
%    NAME: Base name of magnet PV.
%    VAL: New BDES value, not set if VAL is empty
%    OPTS: Options struct
%          ACTION: Control action for magnet, PERTURB or TRIM with default
%                  perturb
%          WAIT:   Additional wait time after magnet function completed,
%                  default 3s

% Output arguments:
%    BACT: New magnet BACT

% Compatibility: Version 7 and higher
% Called functions: lca*

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Set default options.
optsdef=struct( ...
    'action','PERTURB', ...
    'wait',3 ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);
opts.action=upper(opts.action);

[name,d,isSLC]=model_nameConvert(cellstr(name),'EPICS');
name=name(:);val=val(:);bAct=zeros(size(name));
if ~isempty(val), val(end+1:numel(name),1)=val(end);end

% Do BNDS/QUAS stuff.
[nameLGPS,is]=control_magnetNameLGPS(name,isSLC);

% Set BACT if simulation.
if ispc
    if strcmp(opts.action,'BCON_TO_BDES')
        val=lcaGet(strcat(name,':BCON'));
    end
    if ~isempty(val)
        lcaPut(strcat(name,':BACT'),val);
        lcaPut(strcat(name,':BDES'),val);
        lcaPut(strcat(name,':BCTRL'),val);
        if any(is.Str), lcaPut(strcat(nameLGPS,':BDES'),val(is.Str));end
    end
    if strcmp(opts.action,'SAVE_BDES')
        val=lcaGet(strcat(name,':BDES'));
        lcaPut(strcat(name,':BCON'),val);
    end
    bAct=lcaGet(strcat(name,':BACT'));
    return
end

% Get started with EPICS magnets.
if any(~isSLC)
    % Perturb or trim magnet.
    %lcaSetMonitor([name ':RAMPSTATE'],0,'double');
    %while ~lcaNewMonitorValue([name ':RAMPSTATE'],'double');end
    %state=lcaGet([name ':RAMPSTATE'],0,'double');
    %disp(state);

    % Set BDES if VAL is not empty.
    if ~isempty(val)
        lcaPut(strcat(name(~isSLC),':BDES'),val(~isSLC));
    end
    % Trim or perturb magnets.
    nameCTRL=strcat(name(~isSLC),':CTRL');

    % Don't use magnets in No or Feedback Control.
    nameOnline=strcat(name(~isSLC),':STATMSG');
    use=~ismember(lcaGet(nameOnline,0,'double'),[15 7]);

    % Do BCON to BDES action.
    if strcmp(opts.action,'BCON_TO_BDES') && any(use)
        lcaPut(nameCTRL(use),'BCON_TO_BDES');
        opts.action='TRIM';
    end

    if ismember(opts.action,{'PERTURB' 'TRIM' 'STDZ'}) && any(use)
        lcaPut(nameCTRL(use),opts.action);
    end
    disp('Set EPICS magnet BDES');
    pause(.1);
end

% Do SLC magnets in the mean time.
if any(isSLC)
    nameSLC=model_nameConvert(name(isSLC),'SLC');
    isColl=strncmp(nameSLC,'STEP',4);
    if isempty(val)
        [d,bDes]=control_magnetGet(name(isSLC));
    else
        bDes=val(isSLC);
    end
    if any(is.Str)
        [m,p,u]=model_nameSplit(nameLGPS);
        nameLGPS=strcat(p,':',m,':',u);
        nameSLC(is.Str(isSLC))=nameLGPS;
    end
    func='TRIM'; %do always trim, perturb sucks!
    %if strcmp(opts.action,'PERTURB'), func='PTRB';end
    disp('Wait for SLC magnet trim ...');
    bActSLC(~isColl)=magnetSet(nameSLC(~isColl),bDes(~isColl),'BDES',func);
    bActSLC(isColl)=magnetSet(nameSLC(isColl),bDes(isColl),'VDES',func);
    if strcmp(func,'PTRB')
        pause(15.);bActSLC=NaN;
    end
    if any(isnan(bActSLC)), bActSLC=control_magnetGet(name(isSLC));end
    bAct(isSLC)=bActSLC;
end

% Return if all SLC magnets.
if all(isSLC), return, end

% Finish EPICS magnets.
disp(['Wait for EPICS ' opts.action ' ...']);
switch opts.action
    case 'PERTURB'
        % Wait for RAMPSTATE to turn ON
%        while ~lcaNewMonitorValue([name ':RAMPSTATE'],'double');end
%        state=lcaGet([name ':RAMPSTATE'],0,'double');
%        disp(state);
    case 'TRIM'
        nTry=600;
        magnetWait(nameCTRL(use),nTry,.2);
%        while ~lcaNewMonitorValue([name ':RAMPSTATE'],'double');end
%        state=lcaGet([name ':RAMPSTATE'],0,'double');
%        disp(state);
    case 'STDZ'
        nTry=600;
        magnetWait(nameCTRL(use),nTry,1);
    otherwise
        disp('Unknown action for magnet');
end

nTry=0;
while nTry
    state=lcaGetStatus(strcat(name(~isSLC),':BACT')) > 1;
    nTry=nTry-1;
    if ~any(state), break, end
    pause(.1);
end
if any(use), pause(opts.wait);end

% Wait for RAMPSTATE to turn OFF
%if state
%    while ~lcaNewMonitorValue([name ':RAMPSTATE'],'double');end
%    state=lcaGet([name ':RAMPSTATE'],0,'double');
%    disp(state);
%end
%lcaClear([name ':RAMPSTATE']);

% Read back BACT.
disp('Magnet set done.');
bAct(~isSLC)=lcaGet(strcat(name(~isSLC),':BACT'));


% --------------------------------------------------------------------
function val = magnetWait(nameCTRL, nTry, wait)

if isempty(nameCTRL), return, end
while nTry
    state=lcaGet(nameCTRL,0,'double') > 0;
    nTry=nTry-1;
    if ~any(state), break, end
    pause(wait);
end
val=nTry > 0;


% --------------------------------------------------------------------
function val = magnetSet(name, val, secn, func)

% Initialize aida
global da

aidainit;
if isempty(da), da=DaObject;end

if isempty(name), val=[];return, end
in=DaValue;
in.type=0;
in.addElement(DaValue(name));
in.addElement(DaValue(val));
da.reset;
da.setParam('MAGFUNC',func);
da.setParam('LIMITCHECK','SOME');
try
    out=da.setDaValue(['MAGNETSET//' secn],in);
    val=getAsDoubles(out.get(1));
catch
    disp(sprintf('Aida error trimming %s ... %s',name{unique([1 end])}));
    val=nan(size(name));
end
