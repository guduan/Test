function [prim, micro, unit, secn] = model_nameSplit(name)
%NAMESPLIT
%  [PRIM, MICRO, UNIT, SECN] = NAMESPLIT(NAME) splits EPICS or SLC name
%  or list of names into primary, micro (IOC), unit string and secondary.
%  If name doesn't have all parts, emplty strings are returrned for them.

% Input arguments:
%    NAME: Name or cell string array of EPICS or SLC names to be split

% Output arguments:
%    PRIM:  Primary name or list
%    MIRCO: Micro or IOC name or list
%    UNIT:  Unit number as string or list
%    SECN:  Secondary name or list

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

name=cellstr(name);name=name(:);
parts=regexp(name,':','split');
num=cellfun('length',parts);

list=repmat({''},numel(name),4);
for j=unique(min(num,4))'
    list(num == j,1:j)=vertcat(parts{num == j});
end

prim=list(:,1);
micro=list(:,2);
unit=list(:,3);
secn=list(:,4);
