function [pAct, pDes, gold] = control_phaseGold(name, val, pAct, ds)
%PHASEGOLD
%  [PACT, PDES, GOLD] = PHASEGOLD(NAME, VAL, PACT, DS) sets RF PDES to VAL
%  without changing any actual phase by adjusting phase offsets
%  accordingly. Uses present PDES and PACT (EPICS PAD devices) or if
%  provided PACT as reference.

% Features:

% Input arguments:
%    NAME: String or cell string array for base name of RF PV or MAD alias.
%    VAL : New PDES values.
%    PACT: Present PACT values for EPICS PAD devices, optional.
%    DS  : Data Slot for PAU, default empty, i.e. set global parameters

% Output arguments:
%    PACT: List of RF devices actual phase, NaN if read failure
%    PDES: List of RF devices set phase, NaN if read failure
%    GOLD: List of RF devices new phase offsets, NaN if read failure

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert, lcaGet

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Get EPICS name.
if nargin < 4, ds=[];end
if nargin < 3, pAct=[];end
[name,is,d,nPdes,d,d,d,d,fdbk,send] = control_phaseNames(name);
[pAct0,pDes,gold0]=control_phaseGet(name,{'PHAS' 'PDES' 'GOLD'},ds);
if isempty(pAct), pAct=pAct0;end
if isempty(name), return, end
val=val(:);val(end+1:numel(name),1)=val(end);
%badPh=pAct == -10000;
%if any(badPh), disp(char(strcat({'Bad '},name(badPh))));end
%pAct(badPh)=pDes;

% Calculate new GOLD values.
isGold=is.SLC | is.L23 | is.PAC | is.PAD | is.KLY;
dPhi=val-pDes;
%good=pAct ~= -10000;
%dPhi(is.SLC & good)=val(is.SLC & good)-pAct(is.SLC & good);
dPhi(is.PAD)=-(val(is.PAD)-pAct(is.PAD));
% L1X PAD PACTs are wrong by 2*GOLD added, so have to subtract it.
%dPhi(is.L1X)=val(is.L1X)-(pAct(is.L1X)-2*gold0(is.L1X));
gold=gold0-dPhi;
gold(is.L1X)=-gold(is.L1X);% X-band offsets work differently AGAIN! (July 31, 2008 - PE)
gold=util_phaseBranch(gold);

% Find single PDES for multiple PADs
[d,id]=unique(nPdes);isUn=false(size(isGold));isUn(id)=isGold(id);

% Display.
disp(char(strcat({'Original '},nPdes(isUn),{' = '},num2str(pDes(isUn),'%8.3f deg'))));
disp(char(strcat({'Original '},name(isGold),{' phase offset = '},num2str(gold0(isGold),'%8.3f deg'))));
%disp(char(strcat({'New '},name(isGold),{' phase offset = '},num2str(gold(isGold),'%8.3f deg'))));

% Set new PDES and GOLD.
if any(is.FBK)
    lcaPut(fdbk(is.FBK),0); % turn OFF feedback temporarily
    lcaPut(send(is.FBK),1); % disable feedback temporarily
end
control_phaseSet(name(isUn),val(isUn),0,0,[],ds); % No trim
control_phaseSet(name(isGold),gold(isGold),0,0,'GOLD');
if any(is.FBK)
    lcaPut(send(is.FBK),0); % re-enable feedback
    lcaPut(fdbk(is.FBK),1); % switch ON feedback
end

% Set new Klystron GOLD if SBST golded.
if any(is.SBS)
    klys=repmat(strrep(strrep(name(is.SBS)','SBST','KLYS'),':1',':'),8,1);
    klys=reshape(strcat(klys(:),repmat(num2str((11:10:81)'),numel(find(is.SBS)),1)),8,[]);
    [d,d,d,d,d,gold]=control_phaseGet(klys);
    klysVal=gold-reshape(repmat(val(is.SBS)'-pDes(is.SBS)',8,1),[],1);
    control_phaseSet(klys,klysVal,0,0,'GOLD');
end

%for j=find(is.SBS)
%    klys=strrep(name{j},'SBST','KLYS');
%    klys=strcat(klys(1:end-1),num2str((11:10:81)'));
%    [d,d,d,d,d,gold]=control_phaseGet(klys);
%    control_phaseSet(klys,gold-val(j)+pDes(j),0,0,'GOLD');
%end

[pAct,pDes,gold]=control_phaseGet(name,{'PHAS' 'PDES' 'GOLD'},ds);
