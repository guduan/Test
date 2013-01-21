function [act, stat, swrd, hdsc, dsta, enld] = control_klysStatGet(name, beamCode)
%KLYSSTATGET
%  [ACT, STAT, SWRD, HDSC, DSTA, ENLD] = KLYSSTATGET(NAME, BEAMCODE)
%  returns the status of the klystrons in string or cellarray NAME.

% Input arguments:
%    NAME:     Name of klystron (MAD, Epics, or SLC), string or cell string
%              array
%    BEAMCODE: Beam code(s) for klystrons, default 1

% Output arguments:
%    ACT:  Activation state of klystrons NAME on beam code 1
%          0: Deactivated
%          1: Activated
%          NaN: Unknown status or NAME or AIDA error
%    STAT: Operation state of klystrons NAME as short
%    SWRD: PIOP status of klystrons NAME as short
%    HDSC: Hardware descriptor of klystrons NAME as short
%    DSTA: Digital status of klystrons NAME as short
%    ENLD: Energy gain

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert, aidaget, lcaGet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Check input arguments
if nargin < 2, beamCode=1;end

% Get EPICS name.
name=cellstr(name);name=name(:);nName=numel(name);
act=zeros(nName,size(beamCode,2));
[stat,swrd,hdsc,enld]=deal(zeros(size(name)));
dsta=zeros(numel(name),2);
if ~nName, return, end
useAida=1;
beamCode(end+1:nName,:)=repmat(beamCode(end,:),nName-size(beamCode,1),1);
[name,nameEpics,isSLC]=control_klysName(name);

use=~cellfun('isempty',strfind(name,':'));
if ~all(use), disp(char(strcat({'KlysStatGet: Invalid name(s): '},name(~use))));end
if ~any(use), return, end

if ispc
%    name=model_nameConvert(name,'EPICS');
%    act=lcaGet(strcat(name,'_S_AV'));
    act=lcaGet(strcat(nameEpics,':TACT'));
    act=2.^~act;
    enld=enld+220;
    return
end

try
    stat(use)=lcaGet(strcat(nameEpics(use),':STAT'));
    swrd(use)=bitand(lcaGet(strcat(nameEpics(use),':SWRD'))+2^16,2^16-1);
    hdsc(use)=lcaGet(strcat(nameEpics(use),':HDSC'));
    dsta(use,1:2)=lcaGet(strcat(nameEpics(use),':DSTA'),0,'long');
    enld(use)=lcaGet(strcat(nameEpics(use),':ENLD'));
catch
end

% Get TACT
dgrpMatch = { ...
    'KLYS:LI00:97' 'INJECTOR'; ...
    'KLYS:LI00:98' 'INJECTOR'; ...
    'KLYS:LI00:99' 'INJECTOR'; ...
    'KLYS:DR13:1'  'NDRFACET'; ...
    'KLYS:DR01:1'  'INJ_POSI'; ...
    'KLYS:DR01:1'  'SDRFACET'; ...
    'KLYS:DR03:1'  'SDRFACET'; ...
    'KLYS:LI20:93' 'POS_KLYS'; ...
    'KLYS:LI20:94' 'POS_KLYS'; ...
   };

% Try EPICS controls.
if any(~isSLC & use)
    for k=1:size(beamCode,2)
        bc=beamCode(:,k);
        u=~isSLC & use;
        u(isnan(bc) | bc < 0)=0;
        act(u,k)=lcaGet(strcat(nameEpics(u),':BEAMCODE',cellstr(num2str(bc(u))),'_STAT'));
    end
    act(isnan(act))=0;
    use=use & isSLC;
end

if ~useAida
    % ACT status bits   STAT equivalent
    % 1: ACCEL          ~No Accel Rate & ~Maintenance & ~Offline
    % 2: STANDBY        No Accel Rate & ~Maintenance & ~Offline
    % 3: BAD            Maintenance | Offline
    act=bitset(act,3,bitget(stat,2) | bitget(stat,3));
    act=bitset(act,2,bitget(swrd,16) & ~bitget(act,3));
    act=bitset(act,1,~bitget(swrd,16) & ~bitget(act,3));
    act=act.*(stat ~= 0); % Invalid ACT if invalid STAT
else
    for j=find(use')
        matchIndx = strcmp(name{j},dgrpMatch(:,1));
        if ~any(matchIndx), dgrpStr='LIN_KLYS';else dgrpStr=dgrpMatch{matchIndx,2};end
        for k=1:size(beamCode,2)
            bc=beamCode(j,k);
            if isnan(bc) || bc < 0, continue, end
            bcStr=num2str(bc,'BEAM=%d');
            try
                act(j,k)=aidaget([name{j} '//TACT'],'short',{bcStr ['DGRP=' dgrpStr]});
%            stat(j)=aidaget([name{j} '//STAT'],'short');
%            swrd(j)=aidaget([name{j} '//SWRD'],'short');
            catch
            end
        end
    end
end
