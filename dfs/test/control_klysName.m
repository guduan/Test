function [nameSLC, nameSLCCAS, isSLC] = control_klysName(name)
%CONTROL_KLYSNAME
%  [NAMESLC, NAMESLCCAS] = KLYSNAME(NAME) returns the SLC name of the klystron related
%  to the MAD name of the structure.

% Input arguments:
%    NAME: Name of structure (MAD or Epics), string or cell string
%          array

% Output arguments:
%    NAMESLC:    SLC name of related klystron
%    NAMESLCCAS: SLCCAS name of related klystron (MICR:PRIM:UNIT)

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Check input arguments

% Get EPICS name.
name=cellstr(name);name=name(:);
[nameSLC,nameSLCCAS]=deal(repmat({''},size(name)));
isSLC=true(size(name));
if ~numel(name), return, end
name=model_nameConvert(name,'EPICS');
nameSLC=model_nameConvert(name,'SLC');

% Map EPICS controlled structures to SLC klystrons.
klysMap={'TCAV0' 'GUN' 'L0A' 'L0B' 'L1S' 'L1X' 'TCAV3'; ...
         '20-5' '20-6' '20-7' '20-8' '21-1' '21-2' '24-8'}';
[is,id]=ismember(name,model_nameConvert(klysMap(:,1)));
nameSLC(is)=model_nameConvert(klysMap(id(is),2),'SLC');

%{
% Get all klystron names.
[klysList,d,isSLCk]=model_nameConvert({'KLYS'},[],'*');
klysList=char(klysList(~isSLCk));
klysListSLC=model_nameConvert(cellstr(klysList),'SLC');
klysList=strjust(klysList);

isMAD=cellfun('isempty',nameSLC) & cellfun('length',name) >= 3;
for j=find(isMAD')
    nameMAD=name{j}(end-2:end);
    nameMAD=strrep(nameMAD,'GN1','GUN'); % Special for Gun
    id=strcmp(nameMAD,cellstr(klysList(:,end-2:end)));
    if ~any(id), continue, end
    nameSLC(j)=klysListSLC(id);
end
%}

n=char(nameSLC);n(:,end+1:11)=' ';
nameSLCCAS=cellstr(n(:,[1:5 6:10 11:end]));

isFlip=strncmp(nameSLC,'KLYS:LI0',8) | strncmp(nameSLC,'KLYS:LI1',8) | ...
    strncmp(nameSLC,'KLYS:DR',7) | strncmp(nameSLC,'KLYS:LI20:9',11) | ...
    ismember(nameSLC,[strcat('KLYS:LI20:',{'21' '31' '41'}) {'KLYS:LI24:71'}]);
nameSLCCAS(isFlip)=cellstr(n(isFlip,[6:10 1:5 11:end]));

% Check Klys control state.
isSLC=~control_klysIOC(nameSLCCAS);
