function [gainF, fudgeAct, ampF, phaseF] = model_energyFudge(amp, phase, is, method)
%MODEL_ENERGYFUDGE
% [GAINF, FUDGEACT, AMPF, PHASEF] = MODEL_ENERGYFUDGE(AMP, PHASE, IS, METHOD)
% calculates fudge factors FUDGEACT and related GAINF, AMPF, and PHASEF for
% the actual klystron amplitudes and phases AMP and PHASE. The structure IS
% contains fields L0, L1, L2, L3 which are logical arrays of the same size
% as AMP indicating if the klystron belongs to the respective region. IS is
% returned by MODEL_ENERGYKLYS.

% Features:

% Input arguments:
%    AMP:    Vector of klystron amplitudes in MeV
%    PHASE:  Vector of klystron phases in degrees
%    IS:     Structure with fields L0, L1, L2, L3
%            L0: Logical vector indicating if klystron is in L0
%            L1: Logical vector indicating if klystron is in L1
%            L2: Logical vector indicating if klystron is in L2
%            L3: Logical vector indicating if klystron is in L3
%    METHOD: Fudge method

% Output arguments:
%    GAINF:    Fudged energy gain of klystrons
%    FUDGEACT: Four element vector of fudge factors for L0 - L3
%    AMPF:     Fudged amplitudes in MeV
%    PHASEF:   Fudged phases in degrees

% Compatibility: Version 7 and higher
% Called functions: model_energySetPoints

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------

if nargin < 4, method=2;end

% Get desired energy set points.
energyDef=model_energySetPoints;
gainDef=diff(energyDef);

% Calculate fudge factors.
useList=[is.L0(:) is.L1(:) is.L2(:) is.L3(:)];
nReg=size(useList,2);

amp=amp*1e-3; % MeV to GeV
ampF=amp;phaseF=phase;gainF=amp.*cosd(phase); % Phase in degree
fudgeAct=ones(nReg,1);
for j=1:nReg
    use=useList(:,j);
    [gainF(use),fudgeAct(j),ampF(use),phaseF(use)]=scale(amp(use),gainDef(j),phase(use),method);
end
ampF=ampF*1e3; % GeV to MeV


function [gainF, fudge, ampF, phaseF] = scale(amp, gainDef, phase, type)

gain=amp.*cosd(phase);
gainMeas=sum(gain);
wake=0.52e-3*12*ones(size(gain));
wakeLoss=sum(wake);
if sum(abs(gain))
    dFudge=(gainDef-gainMeas)/sum(abs(gain));
else
    dFudge=0;
end

if sum(amp)
    dFudge2=(gainDef-gainMeas)/sum(amp);
    dFudge3=(gainDef-gainMeas+wakeLoss)/sum(amp);
else
    dFudge2=0;
    dFudge3=(gainDef+wakeLoss)/sum(wake);
    wake=wake*(1-dFudge3);
end
dFudge4=(gainDef-gainMeas+wakeLoss)/sum(amp+wake);

eAcc=sum(gain(gain > 0));
eDec=sum(gain(gain < 0));

inc=sqrt(gainDef^2-4*eAcc*eDec);
if eAcc
    f=(gainDef+inc*[1 -1])/2/eAcc;
elseif eDec
    f=2*eDec./(gainDef-inc*[1 -1]);
else
    f=[1 1];
end
d=abs(f-1);f(find(d == max(d),1))=[];

% Which fudge TYPE to use, 0: 1+sgn(G)*dF, 1: f^sgn(G), 2: E+df V
gainC=amp.*exp(i*phase*pi/180);
switch type
    case 0
        fudge=1+dFudge;
        gainF=gainC.*(1+sign(gain)*dFudge);
    case 1
        fudge=f;
        gainF=gainC.*fudge.^sign(gain);
    case 2
        fudge=1+dFudge2;
        gainF=gainC+amp*dFudge2;
    case 3
        fudge=1+dFudge3;
        gainF=gainC+amp*dFudge3-wake;
    case 4
        fudge=1+dFudge4;
        gainF=gainC-wake+(amp+wake)*dFudge4;
end
ampF=abs(gainF);phaseF=angle(gainF)*180/pi;gainF=real(gainF);
