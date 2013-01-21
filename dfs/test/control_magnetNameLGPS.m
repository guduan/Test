function [nameLGPS, is] = control_magnetNameLGPS(name, isSLC)
%CONTROL_MAGNETNAMELGPS
%  [NAMELGPS, IS] = CONTROL_MAGNETNAMELGPS(NAME, ISSLC) get name for LGPS
%  of magnet NAME if ISSLC.

% Features:

% Input arguments:
%    NAME: Base name or cellstring array of magnet PVs.
%    ISSLC: Logical array if device is SLC controlled, searches if omitted.

% Output arguments:
%    NAMELGPS: Name of LGPS for magnets
%    IS: QUAS, BNDS, STR: Logical arrays if device is QUAS or BNDS or
%    either

% Compatibility: Version 7 and higher
% Called functions: lcaGet, model_nameConvert

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

name=cellstr(name);name=name(:);
if nargin < 2, [name,d,isSLC]=model_nameConvert(name);end

nameLGPS=cell(0,1);
[is.QUAS,is.BNDS,is.Str]=deal(false(numel(name),1));
if any(isSLC)
    [m,p]=model_nameSplit(name(isSLC));
    is.QUAS(isSLC)=strcmp(p,'QUAS');
    is.BNDS(isSLC)=strcmp(p,'BNDS');
    is.Str=is.QUAS | is.BNDS;
    if any(is.Str)
        unit=lcaGet(strcat(name(is.Str),':PSCP'));
        nameLGPS=strcat(m(is.Str(isSLC)),':LGPS:',num2str(unit,'%0d'));
    end
end
