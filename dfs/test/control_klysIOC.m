function isIOC = control_klysIOC(name)
%CONTROL_KLYSIOC
%  [NAMESLC, NAMESLCCAS] = CONTROL_KLYSIOC(NAME) returns the control flag
%  of the klystron.

% Input arguments:
%    NAME: Cellstr array of klystron names.

% Output arguments:
%    ISSLC:    SLC name of related klystron
%    isL28: SLCCAS name of related klystron (MICR:PRIM:UNIT)

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Check input arguments

% Get micro.
[prim,micr,unit]=model_nameSplit(name);

% Check Klys control state.
secList={'LI20' 'LI21' 'LI22' 'LI23' 'LI24' 'LI25' 'LI26' 'LI27' 'LI28' 'LI29' 'LI30'}';
secStat=lcaGetSmart(strcat('IOC:',secList,':CV01:SWITCHSTS'),1,'double');
secStat(isnan(secStat))=0;

[is1,id1]=ismember(micr,secList);
[is2,id2]=ismember(prim,secList);
is3=(strcmp(prim,'LI20') | strcmp(micr,'LI20')) & ~ismember(unit,{'51' '61' '71' '81'});
is4=(strcmp(prim,'LI24') | strcmp(micr,'LI24')) & strcmp(unit,'71');
isIOC=(is1 | is2) & ~is3 & ~is4;
id=id1+id2;
isIOC(isIOC)=secStat(id(isIOC));
%isIOC(:)=0; % Comment to enable EPICS control
