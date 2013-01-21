function [name, is, PACT, PDES, GOLD, KPHR, AACT, ADES, FDBK, SEND, POFF] = ...
    control_phaseNames(name, ds)
%PHASENAMES
%  PHASENAMES(NAME) Creates epics PV names for different RF parameters from
%  MAD or EPICS input NAME. NAME can have suffixes for PAD number ('_n') in
%  either form.

% Features:

% Input arguments:
%    NAME: String or cell string array for name(s) of RF PV or MAD alias(es).
%    DS  : Data Slot for PAU, default empty, i.e. set global parameters

% Output arguments:
%    NAME : String or cell string array for name of RF PV or MAD alias.
%    IS   : Struct containing logical arrays indicating type of device
%    PACT : Names for actual phase (PDES if N/A)
%    PDES : Names for desired phase
%    GOLD : Names for phase offset (NAME if N/A)
%    KPHR : Names for fox phase shifter (NAME if N/A)
%    AACT : Names for actual amplitude (ADES if N/A)
%    ADES : Names for desired amplitude
%    FDBK : Names for phase FB status
%    SEND : Names for send to PAC
%    POFF : Names for PAU offsets

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Get EPICS name.
if nargin < 2, ds=[];end
name=cellstr(name);
[name,PAD]=strtok(name(:),'_'); % Find EPICS PAD extensions '_N'
name=model_nameConvert(name,{'EPICS' 'SLC'});
nameSLC=name(:,2);name=name(:,1);
namePAD=strcat(name,PAD);if isempty(name), namePAD=name;end
[PACT,PDES,KPHR,GOLD,AACT,ADES,FDBK,SEND,POFF]=deal(repmat({''},size(name)));

% Determine device type.
[d,micro]=strtok(name,':');                   % micro + unit
isSLC=strncmp(name,'LI',2) | ...
      strncmp(name,'DR',2) | ...
      strncmp(name,'TA',2);                   % SLC klystrons & sub-boosters
isL23=strncmp(name,'SIOC',4);                 % L2/3 from Joe's 6x6 feedback
isPAC=strncmp(name,'ACCL:LI24',9) | ...
      strncmp(name,'ACCL:LI29',9) | ...
      strncmp(name,'ACCL:LI30',9) | ...       % PAC only devices 24-1,2,3 & 29/30-0
      strncmp(name,'LLRF:IN20:RH:C',14) | ... % Clock
      strncmp(name,'LLRF:IN20:RH:L',14) | ... % L2 reference
      strncmp(name,'LLRF:LI24:0',11);         % Sector 24 reference
isLSR=strncmp(name,'LASR',4);                 % Laser RF
isPCV=strncmp(name,'PCAV',4);                 % Phase cavity
isFBK=~isSLC & ~isPAC & ~isL23;               % EPICS RF with (feedback) PAD
isPAD=~strcmp(PAD,'');                        % EPICS RF names for specific PAD
isL1S=strncmp(name,'ACCL:LI21:1:',12);        % L1S
isL1X=strncmp(name,'ACCL:LI21:180',13);       % L1X
isTCV=strncmp(name,'TCAV',4);                 % TCAV0,3
isSBS=strncmp(micro,':SBST',5);               % Sub-booster
isREF=strncmp(name,'LLRF:IN20',9) | ...
      strncmp(name,'LLRF:LI24',9);            % Reference
isL2 =strcmp(name,'SIOC:SYS0:ML00:AO061');    % L2 control
isL3 =strcmp(name,'SIOC:SYS0:ML00:AO064');    % L3 control
isRE1=isREF & strcmp(PAD,'_1');               % REF_1 has no PAC
isPAU=strncmp(name,'LLRF:IN20:RH:L',14) | ... % L2 reference
      (isFBK & ~isPCV & ~isLSR | isPAC | ...
      isL23) & ~isREF;                        % (P)attern (A)ware (U)nits
isKLY=control_klysIOC(name) & isSLC;          % EPICS controlled klystron
name(isKLY)=nameSLC(isKLY);namePAD(isKLY)=nameSLC(isKLY);
isNLC=strncmp(name,'TA',2);                   % NLCTA klys

% Use AIDA EPICS PVs for SLC devices.
PACT(isSLC)=strcat(name(isSLC),':PHAS');
PDES(isSLC)=strcat(name(isSLC),':PDES');
AACT(isSLC)=strcat(name(isSLC),':AMPL');
ADES(isSLC)=strcat(name(isSLC),':ADES');
KPHR(isSLC)=strcat(name(isSLC),':KPHR');
GOLD(isSLC)=strcat(name(isSLC),':GOLD');

% Do NLCTA case.
PACT(isNLC)=strcat(name(isNLC),':PDES');
AACT(isNLC)=strcat(name(isNLC),':ENLD');
ADES(isNLC)=strcat(name(isNLC),':ENLD');

% Defaults for EPICS DES.
PDES(~isSLC)=strcat(name(~isSLC),'_PDES');
ADES(~isSLC)=strcat(name(~isSLC),'_ADES');
PDES(isLSR)=strcat(name(isLSR),'_PDES2856'); % PDES for 2856 MHz
PDES(isREF)=strcat(namePAD(isREF),'_PDES'); % PDES for Reference
ADES(isREF)=strcat(namePAD(isREF),'_ADES'); % ADES for Reference

% Use Joe's PVs for L2/3 global phase.
PDES(isL23)=name(isL23);
ADES(isL23)=strrep(strrep(name(isL23),'61','59'),'64','75');

% Defaults for EPICS ACT & GOLD.
PACT(~isSLC)=PDES(~isSLC);
AACT(~isSLC)=ADES(~isSLC);
%GOLD(~isSLC)=PDES(~isSLC);

% Act names for EPICS FB devices.
%PACT(isFBK)=strcat(name(isFBK),'_S_PV');
%AACT(isFBK)=strcat(name(isFBK),'_S_AV');
PACT(isFBK)=strcat(name(isFBK),'_PAVG');
AACT(isFBK)=strcat(name(isFBK),'_AAVG');
PACT(isLSR)=strcat(strrep(name(isLSR),'LSR',''),'PBR'); % LASR has no :LSR_PAVG
AACT(isLSR)=strcat(strrep(name(isLSR),'LSR',''),'ABR'); % LASR has no :LSR_AAVG
nameB=strrep(strrep(strrep(strrep(name(isPCV),'PH1',''),'PH2',''),'PH3',''),'PH4','');
PACT(isPCV)=strcat(nameB,'PBR'); % PCAV has no :PH1_PAVG
AACT(isPCV)=strcat(nameB,'ABR'); % PCAV has no :PH1_AAVG

% Get EPICS PAD specific names.
PACT(isPAD)=strcat(namePAD(isPAD),'_S_PA');
AACT(isPAD)=strcat(namePAD(isPAD),'_S_AA');
PDES(isPCV | isRE1)=PACT(isPCV | isRE1);
ADES(isPCV | isRE1)=AACT(isPCV | isRE1);

% Get GOLD names.
GOLD(isL23)=strrep(strrep(name(isL23),'61','62'),'64','65');
GOLD(isPAD | isPAC)=strcat(namePAD(isPAD | isPAC),'_POC');

% Get Feedback enable names.
FDBK(isFBK & ~isREF)=strcat(name(isFBK & ~isREF),'_PHAS_FB'); % REF does not have enable
FDBK(isLSR)=strcat(name(isLSR),'_P_FB_PND');
SEND(isFBK | isPAC)=strcat(name(isFBK | isPAC),'_SEND');
SEND(isREF)=strcat(namePAD(isREF),'_SEND'); % Send for Reference

% Get PAU names if DS is given.
if ~isempty(ds)
    ds=num2str(ds);
    PDES(isL2)={'ACCL:LI22:1:PDES'};
    PDES(isL3)={'ACCL:LI25:1:PDES'};
    ADES(isL2)={'ACCL:LI22:1:ADES'};
    ADES(isL3)={'ACCL:LI25:1:ADES'};
    POFF(isPAU)=strcat(PDES(isPAU),':OFFSET_',ds);
    noPAD=isPAU & (isPAC | isL23);
    noPAC=isPAU & ~(isPAC | isL23);
    PACT(noPAC)=strcat(name(noPAC),'_PACT_DS',ds);
    AACT(noPAC)=strcat(name(noPAC),'_AACT_DS',ds);
    PDES(noPAC)=strcat(PDES(noPAC),'_DS',ds);
    ADES(noPAC)=strcat(ADES(noPAC),'_DS',ds);
    PDES(noPAD)=strcat(PDES(noPAD),':SETDATA_',ds);
    ADES(noPAD)=strcat(ADES(noPAD),':SETDATA_',ds);
    PACT(noPAD)=PDES(noPAD);
    AACT(noPAD)=ADES(noPAD);
end

isSLC(isKLY)=0;

% Put all logicals into struct.
is.SLC=isSLC;
is.PAD=isPAD;
is.L23=isL23;
is.FBK=isFBK;
is.PAC=isPAC;
is.LSR=isLSR;
is.L1S=isL1S;
is.L1X=isL1X;
is.TCV=isTCV;
is.SBS=isSBS;
is.L2 =isL2 ;
is.L3 =isL3 ;
is.PAU=isPAU;
is.KLY=isKLY;

%is.REF=isREF;
%is.PCV=isPCV;

name=namePAD;
