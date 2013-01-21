function act = control_klysStatSet(name, stat)
%KLYSSTATSET
%  ACT = KLYSSTATSET(NAME, STAT) Activate or deactivate klystrons in list
%  NAME. Returns new activation status.

% Features:

% Input arguments:
%    NAME: String or cell string array for base name of klystron or MAD alias.
%    STAT: Desired activation status value or list
%          1: Activated
%          0: Deactivated

% Output arguments:
%    ACT: Actual klystron activation status after setting

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert, aidaget, DaObject, lcaPut

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

global da
if ~ispc
    aidainit;
    if isempty(da), da=DaObject;end
end

name=cellstr(name);name=name(:);stat=stat(:);
act=control_klysStatGet(name);

% Find klystrons to change.
isSet=~bitget(act,3) & (bitget(act,2) == stat);

% Check for TCAV.
[nameKlys,nameEpics,isSLC]=control_klysName(name);
isTCAV=ismember(nameKlys,{'KLYS:LI20:51' 'KLYS:LI24:81'});

if ispc
%    nameKlys=model_nameConvert(name,'EPICS');
    statj=stat(min(find(isSet),end));
%    lcaPut(strcat(nameKlys,'_S_AV'),stat);
%    lcaPut(strcat(nameKlys,'_ADES'),stat);
    lcaPut(strcat(nameEpics,':TACT'),stat);
%    act=control_klysStatGet(nameKlys);
    if ~any(isSet), return, end
    disp(char(strcat({'Trying '},nameKlys(isSet),{' to set to '},num2str(statj))));
    return
end

% Return if nothing to set.
if ~any(isSet | isTCAV), return, end

% Try EPICS controls.
if any(~isSLC & isSet)
    statj=stat(min(find(~isSLC | isSet),end));
    lcaPut(strcat(nameEpics(~isSLC | isSet),':BEAMCODE','1','_TCTL'),statj);
end

% Activate/deactivate klystrons.
da.reset;
da.setParam('BEAM','1');
da.setParam('DGRP','LIN_KLYS');
for j=find(isSet & isSLC)'
    statj=stat(min(j,end));
    in=DaValue(java.lang.Short(statj));
    disp(['Trying ' nameKlys{j} ' to set to ' num2str(statj)]);
    try
        out=da.setDaValue([nameKlys{j} '//TACT'],in);
    catch
        disp(['Failed to set ' nameKlys{j} ' to activation ' num2str(statj)]);
    end
end
%import java.util.Vector;
for j=find(isTCAV)'
    statj=stat(min(j,end));
    str={'N' 'Y'};
    strT='T_CAV';if strcmp(nameKlys{j},'KLYS:LI24:81'), strT='T_CAV3';end
    SetBgrpVariable('LCLS',strT,str{statj+1});
%    da.reset;
%    da.setParam('VARNAME',strT);
%    inData=DaValue(java.lang.String(str{statj+1}));
%    da.setDaValue('BGRP//VAL',inData);
end
act(isSet)=control_klysStatGet(nameKlys(isSet));
