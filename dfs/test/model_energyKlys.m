function [amp, phase, is] = model_energyKlys(name, check, getSCP)
%MODEL_ENERGYKLYS
% [AMP, PHASE, IS] = MODEL_ENERGYKLYS(NAME, CHECK, GETSCP) Gets for list of
% klystron names NAME the crest gain AMP, PHASE and a structure IS with
% fields L0, L1, L2, L3 which indicate if the klystron is in the respective
% region. The SCP controlled klystron phases are assumed to be 0 unless
% GETSCP is set to one. The epics controlled global phases for L2, L3,
% S-29, and S-30 are added to the respective klystrons.

% Features:

% Input arguments:
%    NAME:   Cellstring array of klystron MAD names (e.g. L0B or 26-2)
%    CHECK:  Flag to only return IS as first output
%    GETSCP: Flag to get SCP klystron phases

% Output arguments:
%    AMP:   Vector of klystron amplitudes in MeV
%    PHASE: Vector of klystron phases in degrees
%    IS:    Structure with fields L0, L1, L2, L3
%           L0: Logical vector indicating if klystron is in L0
%           L1: Logical vector indicating if klystron is in L1
%           L2: Logical vector indicating if klystron is in L2
%           L3: Logical vector indicating if klystron is in L3

% Compatibility: Version 7 and higher
% Called functions: control_klysStatGet, control_phaseGet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% NAME is MAD name.
name=reshape(cellstr(name),[],1);
nameC=char(name);
klysSect=cell(size(name));
klysSect(:)=cellstr(nameC(:,1:min(2,end)));
isEP=strncmp(name,'L',1);
is24=ismember(name,{'24-1' '24-2' '24-3'});
isL0=ismember(name,{'L0A' 'L0B'});
isL1=ismember(name,{'L1S' 'L1X'});
isL2=ismember(klysSect,{'21' '22' '23' '24'}) & ~is24;
isL3=ismember(klysSect,{'25' '26' '27' '28'});
is29=ismember(klysSect,{'29'});
is30=ismember(klysSect,{'30'});

% Collect linac sections.
is.L0=isL0;
is.L1=isL1;
is.L2=isL2 | is24;
is.L3=isL3 | is29 | is30;

% Return IS when CHECK
if nargin > 1 && check, amp=is;return, end

% Get klystron trigger.
[act,d,d,d,d,amp]=control_klysStatGet(name); % AMP in MeV
isAct=bitand(act,1) > 0;

% Get klystron phase.
phase=zeros(size(name,1),1);
phase(is24)=control_phaseGet(name(is24));
[d,phase(isEP),d,amp(isEP)]=control_phaseGet(name(isEP));

% Get SCP phases when GETSCP
if nargin > 2 && getSCP
    phase(~isEP & ~is24)=control_phaseGet(name(~isEP & ~is24),'PDES');    
end

phase(isnan(phase))=0;
amp=amp.*isAct;

% Add global phases for L2, L3, S-29, S-30.
globPh=control_phaseGet({'L2' 'L3' '29-0' '30-0'});
phase(isL2)=phase(isL2)+globPh(1);
phase(isL3)=phase(isL3)+globPh(2);
phase(is29)=phase(is29)+globPh(3);
phase(is30)=phase(is30)+globPh(4);
