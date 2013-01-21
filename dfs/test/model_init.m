function [mSource, mOnline, mSimul, mUseBDES] = model_init(varargin)
%MODEL_INIT
% [MSOURCE, MONLINE, MSIMUL, MUSEBDES] = MODEL_INIT(opts)
% initializes global variables for model queries.

% Features:

% Input arguments:

% Output arguments:
%    SOURCE:  String for source of model data, 'EPICS' (default), 'SLC',
%             'MATLAB' (Matlab online calculation), 'XAL' alias for 'EPICS'
%    ONLINE:  Acts like MODELSOURCE is 'MAD' when 1 (obsolete)
%    SIMUL:   State for simulating machine parameters for model
%             calculations
%    USEBDES: Use BDES instead of BACT for model calculations

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

global modelSource modelOnline modelSimul modelUseBDES

%[sys,accelerator]=getSystem;
sys='ispc';
accelerator='SXFEL';

% Set defaults.
if isempty(modelOnline)
    if strcmp(accelerator,'SXFEL')
        modelOnline=0;
    else
        modelOnline=~ispc;
    end
end

if isempty(modelSource)
    modelSource='EPICS';
    if ~modelOnline, modelSource='MATLAB';end
end

if isempty(modelSimul)
    modelSimul=0;
end

if isempty(modelUseBDES)
    modelUseBDES=0;
end

% Set default options.
optsdef=struct( ...
    'source',modelSource, ...
    'online',modelOnline, ...
    'simul',modelSimul, ...
    'useBDES',modelUseBDES ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

modelSource=opts.source;
modelOnline=opts.online;
modelSimul=opts.simul;
modelUseBDES=opts.useBDES;

mSource=modelSource;
mOnline=modelOnline;
mSimul=modelSimul;
mUseBDES=modelUseBDES;
