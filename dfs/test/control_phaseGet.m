function [pAct, pDes, aAct, aDes, kPhr, gold] = control_phaseGet(name, type, ds)
%PHASEGET
%  PHASEGET(NAME, TYPE, DS) get RF phase NAME_S_PV for EPICS devices and
%  NAME:PHAS for SLC devices (NAME//PHAS). For 24-1,2,3, it takes
%  NAME_PDES. If TYPE is specified, the output arguments will be determined
%  by the secondaries listed in TYPE.

% Features:

% Input arguments:
%    NAME: String or cell string array for base name of RF PV or MAD alias.

% Output arguments:
%    PACT: List of RF devices actual phase, NaN if read failure
%    PDES: List of RF devices set phase, NaN if read failure
%    DS  : Data Slot for PAU, default empty, i.e. set global parameters

% Compatibility: Version 7 and higher
% Called functions: model_nameConvert, aidaget, lcaGet
%                   phaseNames

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

% Defaults
typeDef={'PHAS' 'PDES' 'AMPL' 'ADES' 'KPHR' 'GOLD'};
if nargin < 3, ds=[];end
if nargin < 2, type=[];end
if isempty(type), type=typeDef;end
type=strrep(strrep(strrep(cellstr(type),'PACT','PHAS'),'AACT','AMPL'),'POC','GOLD');
[d,id1]=ismember(type,typeDef);
[d,id2]=setdiff(typeDef,type);id=[id1 sort(id2)];
type=typeDef(id(1:max(1,nargout)));

% Get EPICS name.
if ispc, ds=[];end
[name,is,namePACT,namePDES,nameGOLD,nameKPHR,nameAACT,nameADES] = control_phaseNames(name,ds);
[pAct,pDes,aAct,aDes,kPhr,gold]=deal(nan(size(name)));

% Do simulation case.
if ispc
    pDes=lcaGet(namePDES);
    pAct=pDes;
    aDes=lcaGet(nameADES);
    aAct=aDes;
    kPhr(is.SLC)=lcaGet(nameKPHR(is.SLC));
    gold(is.SLC | is.L23 | is.PAC | is.PAD)=lcaGet(nameGOLD(is.SLC | is.L23 | is.PAC | is.PAD));
    pAct(is.SLC)=kPhr(is.SLC)-gold(is.SLC);
    val={pAct,pDes,aAct,aDes,kPhr,gold};
    [pAct,pDes,aAct,aDes,kPhr,gold]=deal(val{id});
    return
end

% Use AIDA for SLC devices.
nameSLC=model_nameConvert(name,'SLC');
for j=find(is.SLC)'
    try
        if ismember('PHAS',type)
%            pAct(j)=aidaget([nameSLC{j} '//PHAS'],'double');
            pAct(j)=aidaget([nameSLC{j} '//' namePACT{j}(end-3:end)],'double');
        end
        if ismember('PDES',type)
            pDes(j)=aidaget([nameSLC{j} '//PDES'],'double');
        end
        if ismember('AMPL',type)
%            aAct(j)=aidaget([nameSLC{j} '//AMPL'],'double');
            aAct(j)=aidaget([nameSLC{j} '//' nameAACT{j}(end-3:end)],'double');
        end
        if ismember('ADES',type)
%            aDes(j)=aidaget([nameSLC{j} '//ADES'],'double');
            aDes(j)=aidaget([nameSLC{j} '//' nameADES{j}(end-3:end)],'double');
        end
        if ismember('KPHR',type)
            kPhr(j)=aidaget([nameSLC{j} '//KPHR'],'double');
        end
        if ismember('GOLD',type)
            gold(j)=aidaget([nameSLC{j} '//GOLD'],'double');
        end
    catch
        disp(['AIDA Error: No phases available for ' nameSLC{j}]);
    end
end
if all(is.SLC)
    val={pAct,pDes,aAct,aDes,kPhr,gold};
    [pAct,pDes,aAct,aDes,kPhr,gold]=deal(val{id});
    return
end

% Get EPICS phases.
if any(ismember({'PHAS' 'PDES'},type))
    pAct(~is.SLC)=lcaGetSmart(namePACT(~is.SLC));
    pDes(~is.SLC)=lcaGetSmart(namePDES(~is.SLC));
end
if any(ismember({'AMPL' 'ADES'},type))
    aAct(~is.SLC)=lcaGetSmart(nameAACT(~is.SLC));
    aDes(~is.SLC)=lcaGetSmart(nameADES(~is.SLC));
end
if ismember({'GOLD'},type)
    isGold=is.L23 | is.PAC | is.PAD | is.KLY;
    gold(isGold)=lcaGetSmart(nameGOLD(isGold));
end
if ismember({'KPHR'},type)
    kPhr(is.KLY)=lcaGetSmart(nameKPHR(is.KLY));
end

% Set pAct branch point 180 deg away from pDes.
pAct(~is.SLC & ~is.KLY)=util_phaseBranch(pAct(~is.SLC & ~is.KLY),pDes(~is.SLC & ~is.KLY));

% Assemble list of requested output values.
val={pAct,pDes,aAct,aDes,kPhr,gold};
[pAct,pDes,aAct,aDes,kPhr,gold]=deal(val{id});
