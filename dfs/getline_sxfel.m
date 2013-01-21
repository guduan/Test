function beamline = getline_sxfel(region,ratio)
%=======================
% get the lattice of Shanghai X-Ray Free-Electron Laser
%
%          2012.3.21 edit ACC modules, get rid of *cosd(phy)
% v0.1  2012.2.28 by guduan add new elements according to v04 elegant lattice
%          2012.2.29 change correctors to XCOR and YCOR
%
% v0.0  2011-06-17 16:43:48 
%======================================================================

%======================================================================
% global  parameters
%
%======================================================================
LHang=5.72/180*pi;
LHL12=0.12;
L1pha=-34.5;
L1volt=54.1642*ratio;
Lxpha=180;
Lxvolt=14.4333;
L2pha=0;
L2volt=54.1642;
L3pha=21; 
L3volt=54.7835 ; 
BC1ang=3.907/180*pi; %RPN biao shi fa
BC1L12=5; 
BC1L12r=1.120 ; 
BC2ang=2.188/180*pi; 
BC2L12=5; 
BC2L12r=1.120; 
%==============================================================
PSTN01=  {'dr' 'PSTN01' 0 []}';
PSTN02= {'dr' 'PSTN02' 0 []}';
PSTN03= {'dr' 'PSTN03' 0 []}';
PSTN04= {'dr' 'PSTN04' 0 []}';
PSTN05= {'dr' 'PSTN05' 0 []}';
PSTN06= {'dr' 'PSTN06' 0 []}';
PSTN07= {'dr' 'PSTN07' 0 []}';
PSTN08= {'dr' 'PSTN08' 0 []}';
PSTN09= {'dr' 'PSTN09' 0 []}';
PSTN10= {'dr' 'PSTN10' 0 []}';
PSTN11= {'dr' 'PSTN11' 0 []}';
PSTN12= {'dr' 'PSTN12' 0 []}';
PSTN13= {'dr' 'PSTN13' 0 []}';
PSTN14= {'dr' 'PSTN14' 0 []}';
PSTN15= {'dr' 'PSTN15' 0 []}';
PSTN16= {'dr' 'PSTN16' 0 []}';
PSTN17= {'dr' 'PSTN17' 0 []}';
PSTN18= {'dr' 'PSTN18' 0 []}';
PSTN19= {'dr' 'PSTN19' 0 []}';
PSTN20= {'dr' 'PSTN20' 0 []}';
		
BACM01= {'dr' '' 0.25 []}';
BACM02= {'dr' '' 0.25 []}';
BACM03= {'dr' '' 0.25 []}';
BACM04= {'dr' '' 0.25 []}';
BACM05= {'dr' '' 0.25 []}';

BLL01= {'dr' '' 0.09 []}';
BLL01csr= {'dr' '' 0.09 []}';
BLL02= {'dr' '' 0.07 []}';
BLL03= {'dr' '' 0.18405 []}';
BLL04= {'dr' '' 0.084142 []}';
%======================================================================
% Beam Position Monitor(BPM)
% ('mo')
%======================================================================
DBPM= {'dr' '' 0.075 []}';
BPM00= {'mo' 'BPM00' 0 []}';

BPM01= [DBPM,BPM00,DBPM];
BPM02= [DBPM,BPM00,DBPM];
BPM03= [DBPM,BPM00,DBPM];
BPM04= [DBPM,BPM00,DBPM];
BPM05= [DBPM,BPM00,DBPM];
BPM06= [DBPM,BPM00,DBPM];
BPM07= [DBPM,BPM00,DBPM];
BPM08= [DBPM,BPM00,DBPM];
BPM09= [DBPM,BPM00,DBPM];
BPM10= [DBPM,BPM00,DBPM];
BPM11= [DBPM,BPM00,DBPM];
BPM12= [DBPM,BPM00,DBPM];
BPM13= [DBPM,BPM00,DBPM];
BPM14= [DBPM,BPM00,DBPM];
BPM15= [DBPM,BPM00,DBPM];
BPM16= [DBPM,BPM00,DBPM];
BPM17= [DBPM,BPM00,DBPM];
BPM18= [DBPM,BPM00,DBPM];
BPM19= [DBPM,BPM00,DBPM];
BPM20= [DBPM,BPM00,DBPM];
BPM21= [DBPM,BPM00,DBPM];
BPM22= [DBPM,BPM00,DBPM];
BPM23= [DBPM,BPM00,DBPM];
BPM24= [DBPM,BPM00,DBPM];
BPM25= [DBPM,BPM00,DBPM];
BPM26= [DBPM,BPM00,DBPM];
BPM27= [DBPM,BPM00,DBPM];
BPM28= [DBPM,BPM00,DBPM];
BPM29= [DBPM,BPM00,DBPM];
BPM30= [DBPM,BPM00,DBPM];
BPM31= [DBPM,BPM00,DBPM];
BPM32= [DBPM,BPM00,DBPM];
BPM33= [DBPM,BPM00,DBPM];
%======================================================================
% Drift
% ('dr')
%======================================================================
DZERO= {'dr' '' 0.0 []}';
D01DL0= {'dr' '' 0.534/2 []}';
D02L0= {'dr' '' 0.1 []}';
D03L0= {'dr' '' 0.1 []}';
D04L0= {'dr' '' 0.1 []}';
D05L0= {'dr' '' LHL12/cos(LHang) []}';
D06L0= {'dr' '' 0.1 []}';
D07L0= {'dr' '' 0.1 []}';
D08L0= {'dr' '' LHL12/cos(LHang) []}';
D09L0= {'dr' '' 0.1 []}';
D10L0= {'dr' '' 0.1 []}';
D11L0= {'dr' '' 0.1 []}';
D12L0= {'dr' '' 0.1 []}';
D13L0= {'dr' '' 0.1 []}';
D14OL0= {'dr' '' 1.6/8 []}';
DLM= {'dr' '' 0.55 []}';
D01L1= {'dr' '' 0.1 []}';
D02L1= {'dr' '' 0.1 []}';
D03L1= {'dr' '' 0.1 []}';
D04L1= {'dr' '' 0.1 []}';
D05L1= {'dr' '' 0.1 []}';
D01BC1= {'dr' '' 0.1 []}';
D02BC1= {'dr' '' 0.2 []}';
D03BC1= {'dr' '' 0.1 []}';
D04BC1= {'dr' '' 0.1 []}';
D05BC1= {'dr' '' 0.1 []}';
D06BC1= {'dr' '' 0.1 []}';
D07BC1= {'dr' '' 0.1 []}';
D08BC1= {'dr' '' 0.1 []}';
D09BC1= {'dr' '' 0.1 []}';
D10DBC1csr= {'dr' '' (BC1L12/cos(BC1ang)-BC1L12r)/10 []}';
D10DBC1lsc= {'dr' '' 0 []}';
D11BC1= {'dr' '' 0.1 []}';
D12BC1= {'dr' '' 0.2 []}';
D13BC1= {'dr' '' 0.1 []}';
D14BC1= {'dr' '' 0.1 []}';
D15BC1= {'dr' '' 0.1 []}';
D16BC1= {'dr' '' 0.1 []}';
D17DBC1csr= {'dr' '' (BC1L12/cos(BC1ang)-BC1L12r)/10 []}';
D17DBC1lsc= {'dr' '' 0 []}';
D18BC1= {'dr' '' 0.1 []}';
D19BC1= {'dr' '' 0.1 []}';
D20BC1= {'dr' '' 0.1 []}';
D21BC1= {'dr' '' 0.1 []}';
D22BC1= {'dr' '' 0.1 []}';
D01BI1= {'dr' '' 0.1 []}';
D02BI1= {'dr' '' 0.2 []}';
D03BI1= {'dr' '' 0.1 []}';
D04BI1= {'dr' '' 0.1 []}';
D05BI1= {'dr' '' 0.8 []}';
D06BI1= {'dr' '' 0.1 []}';
D07BI1= {'dr' '' 0.2 []}';
DFODO1BI1= {'dr' '' 0.1 []}';
DFODO2BI1= {'dr' '' 0.1 []}';
DFODO3BI1= {'dr' '' 0.26 []}';
DFODOBI1lsc= {'dr' '' 0 []}';
D08BI1= {'dr' '' 0.2 []}';
D09BI1= {'dr' '' 0.1 []}';
D10BI1= {'dr' '' 0.1 []}';
D11BI1= {'dr' '' 0.8 []}';
D12BI1= {'dr' '' 0.1 []}';
D13BI1= {'dr' '' 0.2 []}';
D14BI1= {'dr' '' 0.1 []}';
D01L2= {'dr' '' 0.1 []}';
D02L2= {'dr' '' 0.1 []}';
D03L2= {'dr' '' 0.1 []}';
D04L2= {'dr' '' 0.1 []}';
D05L2= {'dr' '' 0.1 []}';
D01BC2= {'dr' '' 0.1 []}';
D02BC2= {'dr' '' 0.2 []}';
D03BC2= {'dr' '' 0.1 []}';
D04BC2= {'dr' '' 0.1 []}';
D05BC2= {'dr' '' 0.1 []}';
D06BC2= {'dr' '' 0.1 []}';
D07BC2= {'dr' '' 0.1 []}';
D08BC2= {'dr' '' 0.1 []}';
D09BC2= {'dr' '' 0.1 []}';
D10DBC2csr= {'dr' '' (BC2L12/cos(BC2ang)-BC2L12r)/10 []}';
D10DBC2lsc= {'dr' '' 0 []}';
D11BC2= {'dr' '' 0.1 []}';
D12BC2= {'dr' '' 0.2 []}';
D13BC2= {'dr' '' 0.1 []}';
D14BC2= {'dr' '' 0.1 []}';
D15BC2= {'dr' '' 0.1 []}';
D16BC2= {'dr' '' 0.1 []}';
D17DBC2csr= {'dr' '' (BC2L12/cos(BC2ang)-BC2L12r)/10 []}';
D17DBC2lsc= {'dr' '' 0 []}';
D18BC2= {'dr' '' 0.1 []}';
D19BC2= {'dr' '' 0.1 []}';
D20BC2= {'dr' '' 0.1 []}';
D21BC2= {'dr' '' 0.1 []}';
D22BC2= {'dr' '' 0.1 []}';
D01BI2= {'dr' '' 0.1 []}';
D02BI2= {'dr' '' 0.2 []}';
D03BI2= {'dr' '' 0.1 []}';
D04BI2= {'dr' '' 0.1 []}';
D05BI2= {'dr' '' 0.1 []}';
D06BI2= {'dr' '' 0.1 []}';
D01L3= {'dr' '' 0.1 []}';
D02L3= {'dr' '' 0.1 []}';
D03L3= {'dr' '' 0.1 []}';
D04L3= {'dr' '' 0.1 []}';
D05L3= {'dr' '' 0.1 []}';
D06L3= {'dr' '' 0.1 []}';
D07L3= {'dr' '' 0.1 []}';
D08L3= {'dr' '' 0.1 []}';
D09L3= {'dr' '' 0.1 []}';
D10L3= {'dr' '' 0.1 []}';
D11L3= {'dr' '' 0.1 []}';
D12L3= {'dr' '' 0.1 []}';
D13L3= {'dr' '' 0.1 []}';
D14L3= {'dr' '' 0.1 []}';
D15L3= {'dr' '' 0.1 []}';
D16L3= {'dr' '' 0.1 []}';
D17L3= {'dr' '' 0.1 []}';
D18L3= {'dr' '' 0.1 []}';
D19L3= {'dr' '' 0.1 []}';
D20L3= {'dr' '' 0.1 []}';
D21L3= {'dr' '' 0.1 []}';
D22L3= {'dr' '' 0.1 []}';
D23L3= {'dr' '' 0.1 []}';
D24L3= {'dr' '' 0.1 []}';
DACL3= {'dr' '' 1.857791 []}';
D01BI3= {'dr' '' 0.1 []}';
D02BI3= {'dr' '' 0.2 []}';
D03BI3= {'dr' '' 0.1 []}';
D04BI3= {'dr' '' 0.1 []}';
D05BI3= {'dr' '' 0.1 []}';
D06BI3= {'dr' '' 0.2 []}';
DFODO1BI3= {'dr' '' 0.1 []}';
DFODO2BI3= {'dr' '' 0.1 []}';
DFODO3BI3= {'dr' '' 1.48 []}';
DFODO4BI3= {'dr' '' 0.1 []}';
DFODOBI3lsc= {'dr' '' 0 []}';
DAWGS= {'dr' '' 0.047934 []}';
DAWGX1= {'dr' '' 0.0765 []}';
DAWGX2= {'dr' '' 0.088047 []}';
DAWGC1= {'dr' '' 0.044075 []}';
DAWGC2= {'dr' '' 0.050231 []}';

PRF01= {'dr' '' 0.2 []}';
PRF02= {'dr' '' 0.2 []}';
PRF03= {'dr' '' 0.2 []}';
PRF04= {'dr' '' 0.2 []}';
PRF05= {'dr' '' 0.2 []}';
PRF06= {'dr' '' 0.2 []}';
PRF07= {'dr' '' 0.2 []}';
PRF08= {'dr' '' 0.2 []}';
PRF09= {'dr' '' 0.2 []}';
PRF10= {'dr' '' 0.2 []}';
PRF11= {'dr' '' 0.2 []}';
PRF12= {'dr' '' 0.2 []}';
PRF13= {'dr' '' 0.2 []}';
PRF14= {'dr' '' 0.2 []}';
PRF15= {'dr' '' 0.2 []}';
PRF16= {'dr' '' 0.2 []}';
PRF17= {'dr' '' 0.2 []}';
PRF18= {'dr' '' 0.2 []}';
PRF19= {'dr' '' 0.2 []}';
PRF20= {'dr' '' 0.2 []}';
PRF21= {'dr' '' 0.2 []}';
PRF22= {'dr' '' 0.2 []}';
PRF23= {'dr' '' 0.2 []}';
PRF24= {'dr' '' 0.2 []}';
PRF25= {'dr' '' 0.2 []}';
PRF26= {'dr' '' 0.2 []}';
PRF27= {'dr' '' 0.2 []}';
PRF28= {'dr' '' 0.2 []}';
PRF29= {'dr' '' 0.2 []}';

SLT01= {'dr' '' 0.2 []}';
SLT02= {'dr' '' 0.2 []}';

TDR01= {'dr' '' 0.2 []}';
TDR02= {'dr' '' 0.2 []}';
TDR03= {'dr' '' 0.2 []}';
TDR04= {'dr' '' 0.2 []}';
TDR05= {'dr' '' 0.2 []}';
%======================================================================
% Deflecting Cavity
%  ('tc')
%======================================================================
TDS00= {'tc' 'TDS00' 0.594826 [0 0]}';
TDS01= {'tc' 'TDS01' 1.005603 [0 0]}';
TDS02= {'tc' 'TDS02' 3.070000 [0 0]}';

VALV= {'dr' '' 0.07 []}';

%======================================================================
% Accelerating Structures(Linac Cavitys)
%  ('lc')
%======================================================================

% global LCAV parameters
SbandF = 2856;    %rf frequency (MHz)
XbandF = 11424;
CbandF = 5712;
%sband=18MV/m, 2pi/3
AS1o10L1= {'lc' 'AS1o10L1' 2.974132/10 [SbandF L1volt/10 (L1pha+90)*pi/180]}';

%xband=24.4MV/m, 5pi/6
AX1o1L1= {'lc' 'AX1o1L1' 0.590453/1 [XbandF Lxvolt/1 (Lxpha+90)*pi/180]}';

%sband=18MV/m, 2pi/3
AS1o5L2_1= {'lc' 'AS1o5L2_1' 2.974132/5 [SbandF L2volt/5 (L2pha+90)*pi/180]}';
AS1o5L2_2= {'lc' 'AS1o5L2_2' 2.974132/5 [SbandF L2volt/5 (L2pha+90)*pi/180]}';

%cband=30.5MV/m, 4pi/5
AC1o6L3_1= {'lc' 'AC1o6L3_1' 1.763485/6 [CbandF L3volt/6 (L3pha+90)*pi/180]}';
AC1o6L3_2= {'lc' 'AC1o6L3_2' 1.763485/6 [CbandF L3volt/6 (L3pha+90)*pi/180]}';
AC1o6L3_3= {'lc' 'AC1o6L3_3' 1.763485/6 [CbandF L3volt/6 (L3pha+90)*pi/180]}';
AC1o6L3_4= {'lc' 'AC1o6L3_4' 1.763485/6 [CbandF L3volt/6 (L3pha+90)*pi/180]}';
%======================================================================
% Bend
% ('be')
%======================================================================
B1L0= {'be' 'B1L0' 0.2*LHang/sin(LHang) [LHang  1.5e-02 0      LHang  0.5 0.5 0]}';
B2L0= {'be' 'B2L0' 0.2*LHang/sin(LHang) [-LHang 1.5e-02 -LHang 0      0.5 0.5 0]}';
B3L0= {'be' 'B3L0' 0.2*LHang/sin(LHang) [-LHang 1.5e-02 0      -LHang 0.5 0.5 0]}';
B4L0= {'be' 'B4L0' 0.2*LHang/sin(LHang) [LHang  1.5e-02 LHang  0      0.5 0.5 0]}';

B1BC1= {'be' 'B1BC1' 0.2*BC1ang/sin(BC1ang) [BC1ang  1.5e-02 0       BC1ang  0.5 0.5 0]}';
B2BC1= {'be' 'B2BC1' 0.2*BC1ang/sin(BC1ang) [-BC1ang 1.5e-02 -BC1ang 0       0.5 0.5 0]}';
B3BC1= {'be' 'B3BC1' 0.2*BC1ang/sin(BC1ang) [-BC1ang 1.5e-02 0       -BC1ang 0.5 0.5 0]}';
B4BC1= {'be' 'B4BC1' 0.2*BC1ang/sin(BC1ang) [BC1ang  1.5e-02 BC1ang  0       0.5 0.5 0]}';

B1BC2= {'be' 'B1BC1' 0.2*BC2ang/sin(BC2ang) [BC2ang  1.5e-02 0       BC2ang  0.5 0.5 0]}';
B2BC2= {'be' 'B2BC1' 0.2*BC2ang/sin(BC2ang) [-BC2ang 1.5e-02 -BC2ang 0       0.5 0.5 0]}';
B3BC2= {'be' 'B3BC1' 0.2*BC2ang/sin(BC2ang) [-BC2ang 1.5e-02 0       -BC2ang 0.5 0.5 0]}';
B4BC2= {'be' 'B4BC1' 0.2*BC2ang/sin(BC2ang) [BC2ang  1.5e-02 BC2ang  0       0.5 0.5 0]}';
%======================================================================
% Corrector
% ('cr')
%======================================================================
% modify CRR -> XC & YC 
DCRR= {'dr' '' 0.05 []}';
XCRR00= {'xcr' 'XCRR00' 0 []}';
YCRR00= {'ycr' 'YCRR00' 0 []}'; % monitor as 'cr'!!!

CRR01=[DCRR,XCRR00,YCRR00,DCRR];
CRR02=[DCRR,XCRR00,YCRR00,DCRR];
CRR03=[DCRR,XCRR00,YCRR00,DCRR];
CRR04=[DCRR,XCRR00,YCRR00,DCRR];
CRR05=[DCRR,XCRR00,YCRR00,DCRR];
CRR06=[DCRR,XCRR00,YCRR00,DCRR];
CRR07=[DCRR,XCRR00,YCRR00,DCRR];
CRR08=[DCRR,XCRR00,YCRR00,DCRR];
CRR09=[DCRR,XCRR00,YCRR00,DCRR];
CRR10=[DCRR,XCRR00,YCRR00,DCRR];
CRR11=[DCRR,XCRR00,YCRR00,DCRR];
CRR12=[DCRR,XCRR00,YCRR00,DCRR];
CRR13=[DCRR,XCRR00,YCRR00,DCRR];
CRR14=[DCRR,XCRR00,YCRR00,DCRR];
CRR15=[DCRR,XCRR00,YCRR00,DCRR];
CRR16=[DCRR,XCRR00,YCRR00,DCRR];
CRR17=[DCRR,XCRR00,YCRR00,DCRR];
CRR18=[DCRR,XCRR00,YCRR00,DCRR];
CRR19=[DCRR,XCRR00,YCRR00,DCRR];
CRR20=[DCRR,XCRR00,YCRR00,DCRR];
CRR21=[DCRR,XCRR00,YCRR00,DCRR];
CRR22=[DCRR,XCRR00,YCRR00,DCRR];
CRR23=[DCRR,XCRR00,YCRR00,DCRR];
CRR24=[DCRR,XCRR00,YCRR00,DCRR];
CRR25=[DCRR,XCRR00,YCRR00,DCRR];
CRR26=[DCRR,XCRR00,YCRR00,DCRR];
CRR27=[DCRR,XCRR00,YCRR00,DCRR];
CRR28=[DCRR,XCRR00,YCRR00,DCRR];
CRR29=[DCRR,XCRR00,YCRR00,DCRR];
CRR30=[DCRR,XCRR00,YCRR00,DCRR];
CRR31=[DCRR,XCRR00,YCRR00,DCRR];
CRR32=[DCRR,XCRR00,YCRR00,DCRR];
CRR33=[DCRR,XCRR00,YCRR00,DCRR];

LM={'un' 'LM' 0.55 [2.2566e-05 0.055]}';

%======================================================================
% Quadrupoles
% ('qu')
%======================================================================
Q01L0= {'qu' 'Q01L0' 0.1 2.6}';
Q02L0= {'qu' 'Q02L0' 0.2 -2.4}';
Q03L0= {'qu' 'Q03L0' 0.1 2.6}';
Q04L0= {'qu' 'Q04L0' 0.1 -2}';
Q05L0= {'qu' 'Q05L0' 0.2 2.25}';
Q06L0= {'qu' 'Q06L0' 0.1 -2}';
Q01L1= {'qu' 'Q01L1' 0.1 -8.0278015137}';
Q02L1= {'qu' 'Q02L1' 0.2 7.8568606377}';
Q03L1= {'qu' 'Q03L1' 0.1 -8.0278015137}';
Q01BC1= {'qu' 'Q01BC1' 0.2 -4.7364783287}';
Q02BC1= {'qu' 'Q02BC1' 0.2, 4.4386968613}';
Q03BC1= {'qu' 'Q03BC1' 0.1, 0}';
Q04BC1= {'qu' 'Q04BC1' 0.1, 0}';%TILT="pi 4 /"
Q05BC1= {'qu' 'Q05BC1' 0.1, 0}';
QFBI1H= {'qu' 'QFBI1H' 0.10, 6.2518954277}';
QDBI1H= {'qu' 'QDBI1H' 0.10, -6.2518954277}';
Q01BI1= {'qu' 'Q01BI1' 0.2, -4.8090782166}';
Q02BI1= {'qu' 'Q02BI1' 0.2, 4.9037213326}';
Q03BI1= {'qu' 'Q03BI1' 0.2, 5.4486203194}';
Q04BI1= {'qu' 'Q04BI1' 0.2, -8.3669786453}';
Q05BI1= {'qu' 'Q05BI1' 0.2, -1.1683081388}';
Q06BI1= {'qu' 'Q06BI1' 0.2, 2.9265615940}';
Q07BI1= {'qu' 'Q07BI1' 0.2, -6.7883639336}';
Q08BI1= {'qu' 'Q08BI1' 0.2, 5.3712091446}';
Q01L2H= {'qu' 'Q01L2H' 0.1, -0.7782335877}';
Q01BC2= {'qu' 'Q01BC2' 0.2, -2.1178367138}';
Q02BC2= {'qu' 'Q02BC2' 0.2, 2.3826847076}';
Q03BC2= {'qu' 'Q03BC2' 0.1, 0}';
Q04BC2= {'qu' 'Q04BC2' 0.1, 0}'; %TILT="pi 4 /"
Q05BC2= {'qu' 'Q05BC2' 0.1, 0}';
Q01BI2= {'qu' 'Q01BI2' 0.2, -1.9506291151}';
Q02BI2= {'qu' 'Q02BI2' 0.2, 1.8196567297}';
Q03BI2= {'qu' 'Q03BI2' 0.2, 1.5680580139}';
Q01L3H= {'qu' 'Q01L3H' 0.1, -1.8779240847}';
Q02L3H= {'qu' 'Q02L3H' 0.1, 1.00}';
Q03L3H= {'qu' 'Q03L3H' 0.1, -1.00}';
Q04L3H= {'qu' 'Q04L3H' 0.1, 1.00}';
Q05L3H= {'qu' 'Q05L3H' 0.1, -1.00}';
Q06L3H= {'qu' 'Q06L3H' 0.1, 1.00}';
Q07L3H= {'qu' 'Q07L3H' 0.1, -1.00}';
Q08L3H= {'qu' 'Q08L3H' 0.1, 1.00}';
Q01BI3= {'qu' 'Q01BI3' 0.40, -1.5733615160}';
Q02BI3= {'qu' 'Q02BI3' 0.40, 1.5084425211}';
Q03BI3= {'qu' 'Q03BI3' 0.40, 1.5334891081}';
Q04BI3= {'qu' 'Q04BI3' 0.40, -1.9473972321}';
QFBI3H= {'qu' 'QFBI3H' 0.10, 2.6862392426}';
QDBI3H= {'qu' 'QDBI3H' 0.10, -2.6862392426}';
%======================================================================
%  L0
%======================================================================
L0=[DZERO, repmat(D01DL0,1,2), Q01L0, D02L0, Q02L0, D03L0,...
          Q03L0, D04L0, B1L0, D05L0, B2L0, D06L0, LM, D07L0,...
          B3L0, D08L0, B4L0, D09L0, Q04L0, D10L0, Q05L0, D11L0,...
          Q06L0, D12L0, TDS00, D13L0, repmat(D14OL0,1,8)];
%======================================================================
%  L1
%
%======================================================================
ASL1=[DAWGS,repmat(AS1o10L1,1,10),DAWGS];
AXL1=[DAWGX1,AX1o1L1,DAWGX2];
L1=[DZERO,DZERO,D01L1,Q01L1,D02L1,Q02L1,D03L1,...
   Q03L1,D04L1,BLL01,BPM01,CRR01,D05L1,...
   PRF01,VALV,BLL02,ASL1,BLL03,ASL1,BLL02,...
   VALV,BLL01,AXL1,BLL01,VALV,PSTN01];
%======================================================================
% BC1
%
%======================================================================		  
D10BC1=[D10DBC1csr,D10DBC1lsc];
D17BC1=[D17DBC1csr,D17DBC1lsc];

BC1=[DZERO,D01BC1,Q01BC1,D02BC1,...
    Q02BC1,D03BC1,BLL01,BPM02,...
    CRR02,D04BC1,BACM01,TDR01,PRF02,BLL01,...
    D05BC1,B1BC1,D06BC1,BLL01csr,D07BC1,Q03BC1,...
    D08BC1,BPM03,CRR03,D09BC1,BLL01csr,repmat(D10BC1,1,10),...
    BLL01csr,D11BC1,B2BC1,D12BC1,Q04BC1,D13BC1,...
    BLL01csr,BPM04,CRR04,D14BC1,SLT01,PRF03,BLL01csr,...
    D15BC1,B3BC1,D16BC1,BLL01csr,repmat(D17BC1,1,10),BLL01csr,...
    D18BC1,Q05BC1,D19BC1,BPM05,CRR05,D20BC1,BLL01csr,...
    D21BC1,B4BC1,PSTN02,D22BC1];
%======================================================================
%BI1
%
%======================================================================
M1BI1=[DZERO,D01BI1,Q01BI1,D02BI1,Q02BI1,...
             D03BI1, BLL01, BPM06, CRR06, D04BI1, VALV, ...
             BLL02, TDS01, BLL02, VALV, D05BI1, BLL01, ...
             BACM02, TDR02, PRF04, BLL01, D06BI1, Q03BI1, ...
             D07BI1, Q04BI1, DFODO1BI1, BPM07, CRR07, ...
			 DFODO2BI1, PRF05, BLL01, DFODO3BI1, DFODOBI1lsc];
H1BI1=[QFBI1H, DFODO1BI1, BPM08, CRR08, DFODO2BI1, PRF06,...
             BLL01, DFODO3BI1, DFODOBI1lsc, QDBI1H];
H2BI1=[QDBI1H, DFODO1BI1, BPM09, CRR09, DFODO2BI1, PRF07,... 
             BLL01, DFODO3BI1, DFODOBI1lsc, QFBI1H];
H3BI1=[QFBI1H, DFODO1BI1, BPM10, CRR10, DFODO2BI1, PRF08,... 
             BLL01, DFODO3BI1, DFODOBI1lsc, QDBI1H];
FODOBI1=[DZERO, H1BI1, PSTN03, H2BI1, H3BI1];
M2BI1=[DZERO, DFODO1BI1, BPM11, CRR11, DFODO2BI1, PRF09, ...
             BLL01, DFODO3BI1, DFODOBI1lsc, Q05BI1, D08BI1, Q06BI1,... 
             D09BI1, BLL01, BPM12, CRR12, D10BI1, PRF10, BLL01, ...
             D11BI1, BLL01, D12BI1, Q07BI1, D13BI1, Q08BI1, D14BI1];
BI1=[DZERO, M1BI1, QFBI1H, PSTN04, FODOBI1, QDBI1H, M2BI1, PSTN05];

%======================================================================
% L2
%
%======================================================================
ASL2_1=[DAWGS, repmat(AS1o5L2_1,1,5), DAWGS];
ASL2_2=[DAWGS, repmat(AS1o5L2_2,1,5), DAWGS];
L2=[DZERO, BLL01, BPM13, CRR13, D01L2, PRF11, VALV, BLL02, ...
          ASL2_1, BLL03, ASL2_1, BLL02, VALV, D02L2, Q01L2H, PSTN06,  ...
	  Q01L2H, D03L2, BLL01, BPM14, CRR14, D04L2, PRF12, VALV, ...
          BLL02, ASL2_2, BLL03, ASL2_2, BLL02, VALV, PSTN07];
%======================================================================
% BI2
%
%======================================================================
D10BC2=[D10DBC2csr, D10DBC2lsc];
D17BC2=[D17DBC2csr, D17DBC2lsc];
BC2=[DZERO, D01BC2, Q01BC2, D02BC2, ...
           Q02BC2, D03BC2, BLL01, BPM15, ...
           CRR15, D04BC2, BACM03, TDR03, PRF13, BLL01, ...
           D05BC2, B1BC2, D06BC2, BLL01csr, D07BC2, Q03BC2, ...
           D08BC2, BPM16, CRR16, D09BC2, BLL01csr, repmat(D10BC2,1,10), ...
           BLL01csr, D11BC2, B2BC2, D12BC2, Q04BC2, D13BC2, ...
           BLL01csr, BPM17, CRR17, D14BC2, SLT02, PRF14, BLL01csr, ...
           D15BC2, B3BC2, D16BC2, BLL01csr, repmat(D17BC2,1,10), BLL01csr, ...
           D18BC2, Q05BC2, D19BC2, BPM18, CRR18, D20BC2, BLL01csr, ...
           D21BC2, B4BC2, PSTN08, D22BC2];

BI2=[DZERO, D01BI2, Q01BI2, D02BI2, Q02BI2, D03BI2, ...
          BLL01, BPM19, CRR19, D04BI2, BACM04, TDR04, PRF15, BLL01, ...
          D05BI2, Q03BI2, D06BI2];
%======================================================================
% L3
%
%======================================================================
ACL3_1=[DAWGC1, repmat(AC1o6L3_1,1,6), DAWGC2];
ACL3_2=[DAWGC1, repmat(AC1o6L3_2,1,6), DAWGC2];
ACL3_3=[DAWGC1, repmat(AC1o6L3_3,1,6), DAWGC2];
ACL3_4=[DAWGC1, repmat(AC1o6L3_4,1,6), DAWGC2];
H01L3=[DZERO, D01L3, Q01L3H, PSTN10, Q01L3H, D02L3, ...
             BLL01, BPM20, CRR20, D03L3, PRF16, VALV, BLL01, ...
             ACL3_1, BLL04, ACL3_1, BLL01, VALV];
H02L3=[DZERO, D04L3, Q02L3H, PSTN11, Q02L3H, D05L3, ...
             BLL01, BPM21, CRR21, D06L3, PRF17, VALV, BLL01,... 
             ACL3_2, BLL04, ACL3_2, BLL01, VALV];
H03L3=[DZERO, D07L3, Q03L3H, PSTN12, Q03L3H, D08L3, ...
             BLL01, BPM22, CRR22, D09L3, PRF18, VALV, BLL01, ...
             ACL3_3, BLL04, ACL3_3, BLL01, VALV];
H04L3=[DZERO, D10L3, Q04L3H, PSTN13, Q04L3H, D11L3, ...
             BLL01, BPM23, CRR23, D12L3, PRF19, VALV, BLL01, ...
             ACL3_4, BLL04, ACL3_4, BLL01, VALV];
H05L3=[DZERO, D13L3, Q05L3H, PSTN14, Q05L3H, D14L3, ...
             BLL01, BPM24, CRR24, D15L3, PRF20, VALV, BLL01, ...
             DACL3, BLL04, DACL3, BLL01, VALV];
H06L3=[DZERO, D16L3, Q06L3H, PSTN15, Q06L3H, D17L3, ...
             BLL01, BPM25, CRR25, D18L3, PRF21, VALV, BLL01, ...
             DACL3, BLL04, DACL3, BLL01, VALV];
H07L3=[DZERO, D19L3, Q07L3H, PSTN16, Q07L3H, D20L3, ...
             BLL01, BPM26, CRR26, D21L3, PRF22, VALV, BLL01, ...
             DACL3, BLL04, DACL3, BLL01, VALV];
H08L3=[DZERO, D22L3, Q08L3H, PSTN17, Q08L3H, D23L3, ...
             BLL01, BPM27, CRR27, D24L3, PRF23, VALV, BLL01, ...
             DACL3, BLL04, DACL3, BLL01, VALV];
L3=[DZERO, H01L3, H02L3, H03L3, H04L3, H05L3, H06L3,H07L3, H08L3];
%======================================================================
% BI3
%
%======================================================================
M1BI3=[DZERO, D01BI3, Q01BI3, D02BI3, Q02BI3, ...
             D03BI3, BLL01, BPM28, CRR28, D04BI3, VALV, ...
             BLL02, TDS02, BLL02, VALV, BACM05, TDR05, PRF24, ...
             BLL01, D05BI3, Q03BI3, D06BI3, Q04BI3, ...
             DFODO1BI3, BLL01, BPM29, CRR29, DFODO2BI3, PRF25, ...
             BLL01, DFODO3BI3, BLL01, DFODO4BI3, DFODOBI3lsc];
H1BI3=[QFBI3H, DFODO1BI3, BLL01, BPM30, CRR30, DFODO2BI3, PRF26, ...
             BLL01, DFODO3BI3, BLL01, DFODO4BI3, DFODOBI3lsc, QDBI3H];
H2BI3=[QDBI3H, DFODO1BI3, BLL01, BPM31, CRR31, DFODO2BI3, PRF27, ...
             BLL01, DFODO3BI3, BLL01, DFODO4BI3, DFODOBI3lsc, QFBI3H];
H3BI3=[QFBI3H, DFODO1BI3, BLL01, BPM32, CRR32, DFODO2BI3, PRF28, ...
             BLL01, DFODO3BI3, BLL01, DFODO4BI3, DFODOBI3lsc, QDBI3H];
FODOBI3=[DZERO, H1BI3, PSTN18, H2BI3, H3BI3];
BI3= [DZERO, M1BI3, QFBI3H, PSTN19, FODOBI3, QDBI3H, ...
           DFODO1BI3, BLL01, BPM33, CRR33, DFODO2BI3, PRF29, ...
		   BLL01, DFODO3BI3, BLL01, DFODO4BI3, DFODOBI3lsc];
%======================================================================
% SXFEL full lattice
%
%======================================================================
lineAll=[L0,L1,BC1,BI1,L2,BC2,BI2,L3,BI3];

switch region
    case 'linac'
        beamline = lineAll;
    case 'L0'
        beamline =L0 ;
    case 'L1'
        beamline =L1 ;
    case 'L2'
        beamline =L2 ;
    case 'L3'
        beamline =L3 ;
    otherwise beamline = [];disp('Please choose beamline%');
end




