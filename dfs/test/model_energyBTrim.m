function [BDES, iMain, iTrim] = model_energyBTrim(bMain, energy, str)

%   [BDES,Imain,Itrim] = model_energyBXtrim(angl,energy);
%
%   Function to calculate BDES of main supply and its 1 to 4 trims (BXn1,
%   BXn2, BXn3, BXn4) for any bend angle and beam energy.  Since the bends
%   were measured with a straight probe, here we add a BDES reduction
%   factor, sin(theta)/theta, to include the slightly increased path length
%   of the e- arcing through the bends (see "fac").
%
%    INPUTS:    bMain:      The main supply BDES (kG-m) if energy [] otherwise
%                           the abs value of the bend angle per dipole (deg)
%               energy:     The e- beam energy (GeV)
%               str:        The chicane location, 'BXH', 'BX0', 'BX1', 'BX2', 'BX3'
%
%   OUTPUTS:    BDES(1):    The main supply BDES (kG-m) if energy not []
%               BDES(2):    The BXn1 BTRM BDES (in main-coil Amperes)
%               BDES(3):    The BXn3 BTRM BDES (in main-coil Amperes)
%               BDES(4):    The BXn4 BTRM BDES (in main-coil Amperes)
%               Imain:      The required current in the main coils (main-coil Amperes)
%               Itrim(1):   The current required in the BXn1 trim (trim-coil Amperes)
%               Itrim(2):   The current required in the BXn3 trim (trim-coil Amperes)
%               Itrim(3):   The current required in the BXn4 trim (trim-coil Amperes)

% ====================================================================================

if ~isempty(energy)
    angl  = bMain;
    c     = 2.99792458e8;                 % light speed (m/s)
    anglR = angl*pi/180;                  % degress to radians
    fac   = sin(anglR+eps)/(anglR+eps);   % rectangular bend Leff factor, <=1 ("eps" added so fac=1 at anglR=0)
    bMain = 1E10*fac/c*energy*anglR;      % BDES needed, including Leff increase as "1/fac" (kG-m)
    if ismember(str,{'BX0' 'DL1'})
        bMain = energy*angl/17.5;
    end
end

isTrim=logical([1 0 1 1]);
switch str
    case 'BXH'
        p1 = [-1.3000880 2.871939E2 -1.851752E2 6.095439E2 -8.801983E2 4.603718E2];   % BDES to I polynomial for BXH1 (A/kG-m^n)
        p2 = [-0.3783284 2.764696E2 -1.385662E2 5.186152E2 -7.957934E2 4.302896E2];   % BDES to I polynomial for BXH2 (A/kG-m^n)
        p3 = [-0.3702678 2.766265E2 -1.375625E2 5.119401E2 -7.819566E2 4.216546E2];   % BDES to I polynomial for BXH3 (A/kG-m^n)
        p4 = [-0.4765466 2.747545E2 -1.182852E2 4.486741E2 -7.003644E2 3.854325E2];   % BDES to I polynomial for BXH4 (A/kG-m^n) - Sep. 8, '08
        ptrim = 3.00;                                       % BTRM linear polynomial coeff. (N_main/N_trim)
        pMain = p2;
    case {'BX0' 'DL1'}
        p1 = [-0.3185546 1.643291E3 -2.731068E3 4.238484E4 -2.656437E5 6.149535E5];     % BDES to I polynomial for BX01 (A/kG^n)
        p2 = [-0.2668666 1.642822E3 -2.430014E3 3.825926E4 -2.447695E5 5.780101E5];     % BDES to I polynomial for BX02 (A/kG^n)
        p3 = [];
        p4 = [];
        ptrim = 1.0588;                                                                 % BTRM linear polynomial coeff. (N_main/N_trim)
        pMain = p2;
        isTrim = logical([1 0]);
    case {'BX1' 'BC1'}
        p1 = [-1.927670E-1  3.084010E2 -6.47041     5.07454     0 0 0 0 0 0];   % BDES to I polynomial for BX11 (A/kG^n)
        p2 = [-4.004983E-1  3.041257E2  3.190752E1 -1.351165E3  1.178857E4 -4.865154E4  1.094169E5 -1.369621E5  8.930395E4 -2.353094E4];   % BDES to I polynomial for BX12 (A/kG^n) after poles replaced (Nov. 12, 2007)
        p3 = [-3.637365E-1  3.027337E2  1.102520E2 -2.282392E3  1.693391E4 -6.425975E4  1.368579E5 -1.647365E5  1.042660E5 -2.684397E4];   % BDES to I polynomial for BX13 (A/kG^n) after poles replaced (Nov. 12, 2007)
        p4 = [-1.582680E-1  3.076740E2 -3.90914     3.50885     0 0 0 0 0 0];   % BDES to I polynomial for BX14 (A/kG^n)
        ptrim = 28/45;                          % J. Welch, Dec. 9, 2007
        pMain = p2;
        %p2 = [-0.322616 , 307.702 , -4.81872  , 4.25820];   % BDES to I polynomial for BX12 (A/kG^n)
        %p3 = [-0.333022 , 307.866 , -4.07724  , 3.41429];   % BDES to I polynomial for BX13 (A/kG^n)
        %ptrim = 0.63;                           % BTRM linear polynomial coeff. (N_main/N_trim)
    case {'BX2' 'BC2'}
        p1 = [-2.620139E-1  2.323024E1 -3.523976E-1  1.388913E-1 -2.270363E-2  1.345011E-3];   % BDES to I polynomial for BX21 (A/kG^n)
        p2 = [-2.542380E-1  2.317352E1 -3.033643E-1  1.249265E-1 -2.101173E-2  1.271024E-3];   % BDES to I polynomial for BX22 (A/kG^n)
        p3 = [-2.575559E-1  2.333321E1 -3.463651E-1  1.347859E-1 -2.183821E-2  1.289172E-3];   % BDES to I polynomial for BX23 (A/kG^n)
        p4 = [-2.855774E-1  2.319316E1 -4.168129E-1  1.512411E-1 -2.365816E-2  1.369928E-3];   % BDES to I polynomial for BX24 (A/kG^n)
        ptrim = 2.2917;                                       % BTRM linear polynomial coeff. (N_main/N_trim)
        pMain = p2;
    case {'BX3' 'DL2'}
        par=[ 0.000134343891326 -0.005028408091501  0.071497708687392 ...
             -0.451855133746735 17.674019737022437 -1.431271574431690]; % BDES to I polynomial for BYDs
        p1 = [-9.299675E-1 1.712876E+1];      % BDES to I polynomial for BX31 (A/(GeV/c)^n)
        p2 = [-9.746283E-1 1.706508E+1];      % BDES to I polynomial for BX32 (A/(GeV/c)^n)
        p3 = [-9.600769E-1 1.710969E+1];      % BDES to I polynomial for BX35 (A/(GeV/c)^n)
        p4 = [-1.051428    1.713753E+1];      % BDES to I polynomial for BX36 (A/(GeV/c)^n)
        ptrim = 0.6;                          % BX3 BTRM linear polynomial coeff. (N_main/N_trim)
        pMain = fliplr(par);
        isTrim = logical([1 1 1 1]);
end
p=fliplr([p1;p2;p3;p4]); % Make Matlab polynomial order
nTrim=size(p,1);

iMain = polyval(pMain(end:-1:1),bMain); % current needed in BXn2 (A) (no trim on BXn2 - use this for main supply)
iMain = max(0,iMain); % can't have negative main currents (A)

bOff=zeros(nTrim,1);
if iMain == 0 && ~all(isTrim) && strcmp(str,'BX1')
%   BDES(3) = BDES(3)+p2(1);  % if BXn2 remnant is not compensated, add BXn2 remnant to BXn3 (A)
    bOff(3) = bMain + pMain(1)/pMain(2);    % J. Welch, Dec. 9, 2007
end

iBX=zeros(nTrim,1);
for j=find(isTrim)
    iBX(j,1) = polyval(p(j,:),bMain+bOff(j)); % current needed in BXnj (A)
end
iBX(~isTrim)=[];

%iBX(1,1) = polyval(p(1,:),bMain); % current needed in BXn1 (A)
%iBX(2,1) = polyval(p(3,:),bDes3); % current needed in BXn3 (A)
%iBX(3,1) = polyval(p(4,:),bMain); % current needed in BXn4 (A)

BDES = iBX - iMain;   % extra (or less) current needed in BXn1,3,4 (main-coil Amperes)

if iMain == 0 && ~all(isTrim) && ~ismember(str,{'BX1' 'BX0' 'DL1'})
   BDES(2) = BDES(2)+p2(1);  % if BXn2 remnant is not compensated, add BXn2 remnant to BXn3 (A)
end

if strcmp(str,'BX1')
    BDES(1) = 1.16*BDES(1); % (1.16 factor to get BPMS:LI21:278:X at zero - 3/28/09 -PE)
end

iTrim = BDES*ptrim;   % trim current (trim-coil Amperes) to get field in BXn1,3,4 = field in BXn2 (A)

if ~isempty(energy) && ~all(isTrim) % Prepend bMain for chicanes
    BDES=[bMain BDES'];
end
