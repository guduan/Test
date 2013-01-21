function energy = model_energySetPoints()
%MODEL_ENERGYSETPOINTS
% ENERGY = MODEL_ENERGYSETPOINTS() returns list of energy set points at the
% GUN, DL1, BC1, BC2, and DL2 used for LEM. If MODEL_SIMUL is on, setpoints
% from the model simulation PVs are used instead.

% Features:

% Input arguments: none

% Output arguments:
%    ENERGY: List of energy set points

% Compatibility: Version 7 and higher
% Called functions: model_init

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Get model simulation status.
[d,d,modelSimul]=model_init;
%[sys, accelerator] = getSystem();
sys='ispc';
accelerator='SXFEL';
if strcmp(accelerator, 'SXFEL')
    energy=[0.06;0.12];
    return
end
% Define desired energy set point source.
if modelSimul
    enPV=strcat('SIOC:SYS0:ML00:AO87',{'1' '2' '3' '4' '5'}');
else
    enPV=strcat('SIOC:SYS0:ML00:AO40',{'5' '6' '7' '8' '9'}');
end

% Get desired energy set points.
energy=lcaGet(enPV); % in GeV
