function [k1, bAct, lEff] = model_k1Get(name, lEff, energy)
%MODEL_K1GET
% [K1, BACT, LEFF] = MODEL_K1GET(NAME, [LEFF, ENERGY]) returns focusing
% strength for magnet(s) NAME. It uses BACT unless the global variable
% modeUseBDES is set to 1, then BDES is used. If effective length LEFF and
% energy ENERGY are not provided, they are obtained from model_rMatGet.
% BACT and LEFF are also returned.

% Features:

% Input arguments:
%    NAME:   Char or cellstr (array) of device names in MAD, EPICS, or SLC
%    LEFF:   List of effective lengths of magnets (optional)
%    ENERGY: List of magnet energies (optional)

% Output arguments:
%    K1:   List of K1 values for magnets in NAME
%    BACT: List of BACT (or BDES) of magnets
%    LEFF: Effective length of element(s) in NAME

% Compatibility: Version 7 and higher
% Called functions: model_init, control_magnetGet, model_rMatGet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
[d,d,d,modelUseBDES]=model_init;

if isnumeric(name)
    [bAct,bDes]=deal(name);
else
    [bAct,bDes]=control_magnetGet(name); % kG
end
if modelUseBDES, bAct=bDes;end
if nargin < 2
    [lEff,energy]=model_rMatGet(name,[],[],{'LEFF' 'EN'});
end
bp=energy/299.792458*1e4; % kG m
k1=bAct(:)'./lEff(:)'./bp(:)'; % 1/m^2
