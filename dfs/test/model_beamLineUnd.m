function [beamLineUN, beamLine52, beamLineBSY] = model_beamLineUnd(region)
%MODEL_BEAMLINEUND
% [BEAMLINEUN, BEAMLINE52] = MODEL_BEAMLINEUND(REGION) Returns beam line
% description list for undulator and 52 line.

% Features:

% Input arguments:
%    REGION: Optional argument for region, default BSY_DMP, also 52-Line

% Output arguments:
%    BEAMLINEUN: Cell array of beam line information for BSY-DMP
%    BEAMLINE52: Cell array of beam line information for BSY-52

% Compatibility: Version 7 and higher
% Called functions: none

% Author: Henrik Loos, SLAC

% --------------------------------------------------------------------
% Set default options.
if nargin < 1, region='BSY_DMP';end

% Global definitions
Ef     = 13.640;   % final beam energy (GeV)
mc2    = 510.99906E-6;  % e- rest mass [GeV]
clight = 2.99792458e8;  % speed of light [m/s]
Cb      =1.0E10/clight; %energy to magnetic rigidity

% Undulator definitions
gamf   =  Ef/mc2;                                  % Lorentz energy factor in undulator [ ]
Kund   =   3.500;                                  % Undulator parameter (rms) [ ]
lamu   =   0.030;                                  % Undulator period [m]
GQF    =  38.461538;                               % Undulator F-quad gradient [T/m] (3 T integrated gradient)
GQD    = -38.461538;                               % Undulator D-quad gradient [T/m] (3 T integrated gradient)
LQu    =   0.078;                                  % Undulator quadrupole effective length [m]
Lseg   =   3.400;                                  % Undulator segment length [m]
Lue    =   0.035;                                  % Undulator termination length (approx) [m]
Lund   =   Lseg - 2*Lue;                           % Undulator segment length without terminations [m]
Lundh  =   Lund/2;
shrt   =   0.470;                                  % Standard short break length [m]
long   =   0.898;                                  % Standard long break length [m]
LRFBu  =   0;                                      % undulator RF-BPM only implemented as zero length monitor
Lbr1   =   6.889E-2;                               % und-seg to quad [m]
Lbr3   =   9.111E-2;                               % quad to BPM [m]
Lbr4   =   5.8577E-2;                              % Radiation monitor to segment [m]
Lbrwm  =   7.1683E-2;                              % BFW to radiation monitor [m]
Lbrs   =   shrt-LRFBu-LQu-Lbr1-Lbr3-Lbr4-Lbrwm;    % Standard short break length (BPM-to-quad distance) [m]
Lbrl   =   long-LRFBu-LQu-Lbr1-Lbr3-Lbr4-Lbrwm;    % Standard long break length (BPM-to-quad distance) [m]
LBUVV2 =   0.2;                                    % drift length after inline vaccum valve
LBUVV1 =   Lbrl - LBUVV2;                          % drift length before inline vaccum valve

kqund  = (Kund*2*pi/lamu/sqrt(2)/gamf)^2;          % natural undulator focusing "k" in y-plane [m^-2]
kQF    = 1E-9*GQF*clight/Ef;                       % QF undulator quadrupole focusing "k" [m^-2]
kQD    = 1E-9*GQD*clight/Ef;                       % QD undulator quadrupole focusing "k" [m^-2]
kQ=[kQF kQD];

UNDSTART={'mo' 'UNDSTART'        0           []}';
UNDTERM ={'mo' 'UNDTERM'         0           []}';
DF0     ={'dr' ''                LQu-0.04241 []}';
DB0     ={'dr' ''                0.5653-Lbr1-LQu-Lbr3-LRFBu   []}';
DB1     ={'dr' ''                Lbr1        []}';
DB3     ={'dr' ''                Lbr3        []}';
DB4     ={'dr' ''                Lbr4        []}';
DBWM    ={'dr' ''                Lbrwm       []}';
DBRS    ={'dr' ''                Lbrs        []}';
DBRL    ={'dr' ''                Lbrl        []}';
DT      ={'dr' ''                Lue         []}';
MUQ     ={'mo' 'MUQ'             0           []}';
DBUVV1  ={'dr' ''                LBUVV1      []}';
DBUVV2  ={'dr' ''                LBUVV2      []}';
VVU10   ={'mo' 'VVU10'           0           []}';
VVU25   ={'mo' 'VVU25'           0           []}';
RFBU00  ={'mo' 'RFBU00'          0           []}';

nGird=33;
GIRDs=repmat(DBWM,[1,15,nGird]);
for j=1:nGird
    QUj={
        'qu' num2str(j,'QU%02d')   LQu/2    kQ(mod(j,2)+1)}';
    XCUj={
        'mo' num2str(j,'XCU%02d')  0        []}';
    YCUj={
        'mo' num2str(j,'YCU%02d')  0        []}';
    RFBUj={
        'mo' num2str(j,'RFBU%02d') 0        []}';
    BFWj={
        'mo' num2str(j,'BFW%02d')  0        []}';
    USj={
        'un' num2str(j,'US%02d')   Lundh    [kqund lamu]}';
    USTBKj=[DT,USj,USj,DT];
    QBLKsj=[QUj,XCUj,MUQ,YCUj,QUj];
    GIRDs(:,:,j)=[BFWj,DBWM,DB4,USTBKj,DB1,QBLKsj,DB3,RFBUj];
end

DBRL10=[DBUVV1,VVU10,DBUVV2];
DBRL25=[DBUVV1,VVU25,DBUVV2];

UNDCL=[DBRS,  GIRDs(:,:,01),DBRS,GIRDs(:,:,02),DBRS,GIRDs(:,:,03), ...
       DBRL,  GIRDs(:,:,04),DBRS,GIRDs(:,:,05),DBRS,GIRDs(:,:,06), ...
       DBRL,  GIRDs(:,:,07),DBRS,GIRDs(:,:,08),DBRS,GIRDs(:,:,09), ...
       DBRL10,GIRDs(:,:,10),DBRS,GIRDs(:,:,11),DBRS,GIRDs(:,:,12), ...
       DBRL,  GIRDs(:,:,13),DBRS,GIRDs(:,:,14),DBRS,GIRDs(:,:,15), ...
       DBRL,  GIRDs(:,:,16),DBRS,GIRDs(:,:,17),DBRS,GIRDs(:,:,18), ...
       DBRL,  GIRDs(:,:,19),DBRS,GIRDs(:,:,20),DBRS,GIRDs(:,:,21), ...
       DBRL,  GIRDs(:,:,22),DBRS,GIRDs(:,:,23),DBRS,GIRDs(:,:,24), ...
       DBRL25,GIRDs(:,:,25),DBRS,GIRDs(:,:,26),DBRS,GIRDs(:,:,27), ...
       DBRL,  GIRDs(:,:,28),DBRS,GIRDs(:,:,29),DBRS,GIRDs(:,:,30), ...
       DBRL,  GIRDs(:,:,31),DBRS,GIRDs(:,:,32),DBRS,GIRDs(:,:,33)];

UND=[UNDSTART,DF0,DB3,RFBU00,UNDCL,DB0,UNDTERM];


% Beam Switch Yard

LQx=0.1080;         %Everson-Tesla (ET) quads "1.259Q3.5" effective length (m)
LQF=0.46092;        %FFTB (0.91Q17.72) effective length (m)
LQA= 0.31600;        %Q150kG effective length [not known yet] (m)
dLQA2=(0.46092 - LQA)/2;        %used to adjust LQA adjacent drifts (m)

%K50Q   =  0.252164058501; % Original BSY optics
%KQ50Q1 = -K50Q;
%KQ50Q2 =  K50Q;
%KQ50Q3 = -K50Q;
%KQSM1  =  0;
%KQ5    = -0.159291446684;
%KQ6    =  0.234194141524;
%KQA0   = -0.201473658651;

K50Q   =  0.19306444469; % New BSY optics
KQ50Q1 = -K50Q;
KQ50Q2 =  K50Q;
KQ50Q3 = -K50Q;
KQSM1  =  0;
KQ5    = -0.176167766822;
KQ6    =  0.245795750992;
KQA0   = -0.238695691511;

Q50Q1={'qu' 'Q50Q1' 0.093671 KQ50Q1}';
Q50Q2={'qu' 'Q50Q2' 0.162151 KQ50Q2}';
Q50Q3={'qu' 'Q50Q3' 0.143254 KQ50Q3}';
QSM1={'qu' 'QSM1' 0.101 KQSM1}'; % , TILT
Q5={'qu' 'Q5' LQF/2 KQ5}';
Q6={'qu' 'Q6' LQF/2 KQ6}';
QA0={'qu' 'QA0' LQF/2 KQA0}';

%XC460009T={'mo' 'XC460009T'  0                     []}';
%XC460026T={'mo' 'XC460026T'  0                     []}';
%XC460034T={'mo' 'XC460034T'  0                     []}';  %do not use to steer ... bad results in Elegant
%XC460036T={'mo' 'XC460036T'  0                     []}';  %do not use to steer ... bad results in Elegant
%XC920020T={'mo' 'XC920020T'  0                     []}';
%XC921010T={'mo' 'XC921010T'  0                     []}';  %do not use to steer ... bad results in Elegant
XCBSY09={'mo' 'XCBSY09'  0                     []}'; % names changed from above to these (Sep. 2008)
XCBSY26={'mo' 'XCBSY26'  0                     []}';
XCBSY34={'mo' 'XCBSY34'  0                     []}'; %do not use to steer ... bad results in Elegant
XCBSY36={'mo' 'XCBSY36'  0                     []}'; %do not use to steer ... bad results in Elegant
XCBSY60={'mo' 'XCBSY60'  0                     []}';
XCBSY81={'mo' 'XCBSY81'  0                     []}'; %do not use to steer ... bad results in Elegant

%YC460010T={'mo' 'YC460010T'  0                     []}';
%YC460027T={'mo' 'YC460027T'  0                     []}';  %do not use to steer ... bad results in Elegant
%YC460035T={'mo' 'YC460035T'  0                     []}';  %do not use to steer ... bad results in Elegant
%YC460037T={'mo' 'YC460037T'  0                     []}';
%YC920020T={'mo' 'YC920020T'  0                     []}';
%YC921010T={'mo' 'YC921010T'  0                     []}';  %do not use to steer ... bad results in Elegant
YCBSY10={'mo' 'YCBSY10'  0                     []}'; % names changed from above to these (Sep. 2008)
YCBSY27={'mo' 'YCBSY27'  0                     []}'; %do not use to steer ... bad results in Elegant
YCBSY35={'mo' 'YCBSY35'  0                     []}'; %do not use to steer ... bad results in Elegant
YCBSY37={'mo' 'YCBSY37'  0                     []}';
YCBSY62={'mo' 'YCBSY62'  0                     []}';
YCBSY82={'mo' 'YCBSY82'  0                     []}'; %do not use to steer ... bad results in Elegant
%={'mo' ''  0                     []}';

YC5={'mo' 'YC5'  0                     []}';
YCA0={'mo' 'YCA0'  0                     []}';
XC6={'mo' 'XC6'  0                     []}';
XCA0={'mo' 'XCA0'  0                     []}';

BPMBSY1={'mo' 'BPMBSY1'  0                     []}';
%BPM460029T={'mo' 'BPM460029T'  0                     []}';
%BPM460039T={'mo' 'BPM460039T'  0                     []}';
%BPM460051T={'mo' 'BPM460051T'  0                     []}';
BPMBSY29={'mo' 'BPMBSY29'  0                     []}';
BPMBSY39={'mo' 'BPMBSY39'  0                     []}';
BPMBSY51={'mo' 'BPMBSY51'  0                     []}';
%BPM920020T={'mo' 'BPM920020T'  0                     []}';
%BPM920030T={'mo' 'BPM920030T'  0                     []}';
%BPM920050T={'mo' 'BPM920050T'  0                     []}';
%BPM921010T={'mo' 'BPM921010T'  0                     []}';
%BPM921020T={'mo' 'BPM921020T'  0                     []}';
%BPM921030T={'mo' 'BPM921030T'  0                     []}';
BPMBSY61={'mo' 'BPMBSY61'  0                     []}'; % rename these 6 BSY BPMs on Aug. 8, 2008
BPMBSY63={'mo' 'BPMBSY63'  0                     []}';
BPMBSY83={'mo' 'BPMBSY83'  0                     []}';
BPMBSY85={'mo' 'BPMBSY85'  0                     []}';
BPMBSY88={'mo' 'BPMBSY88'  0                     []}';
BPMBSY92={'mo' 'BPMBSY92'  0                     []}';
%={'mo' ''  0                     []}';

DRIF0105={'dr' ''     0.134786                  []}';
DRIF0106={'dr' ''     0.140208                  []}';
DRIF0107={'dr' ''     1.605264                  []}';
DRIF0108={'dr' ''     0.0184                  []}';
DRIF0109={'dr' ''     2.688336                  []}';
DRIF0110={'dr' ''     0.35052                  []}';
DRIF0111={'dr' ''     2.93                  []}';
DRIF0112={'dr' ''     0.5411                  []}';
DRIF0113={'dr' ''     2.0764                  []}';
DRIF0114={'dr' ''     4.843132                  []}';
DRIF0115={'dr' ''     0.382923                  []}';
DRIF0116={'dr' ''     0.128016                  []}';
DRIF0117={'dr' ''     0.950976                  []}';
DRIF0118={'dr' ''     0.192024                  []}';
DRIF0119={'dr' ''     0.466344                  []}';
DRIF0120={'dr' ''     0.331248                  []}';
DRIF0121={'dr' ''     0.566                  []}';
DRIF0122={'dr' ''     0.247                  []}';
DRIF0123={'dr' ''     0.459                  []}';
DRIF0124={'dr' ''     0.487899                  []}';
DRIF0125={'dr' ''     0.204216                  []}';
DRIF0126={'dr' ''     0.377343                  []}';
D50B1={'dr' ''        1.132027               []}';
DR19={'dr' ''         0.76197              []}';
DR20={'dr' ''         17.808583              []}';
DR21={'dr' ''         9.09461              []}';
DR22={'dr' ''         0.578              []}';
DR23={'dr' ''         0.1524              []}';
A4DXL={'dr' ''        0.08335               []}';
DR23A={'dr' ''        0.0233               []}';
DR23B={'dr' ''        0.134               []}';
A4DYL={'dr' ''        0.08335               []}';
DR24={'dr' ''         0.0684              []}';
PMV={'dr' ''          0.3429             []}';
DR25={'dr' ''         0.2032              []}';
DR25A={'dr' ''        0.255               []}';
FPM1={'dr' ''         0.83085              []}';
PM1={'dr' ''          0.600075             []}';
DR26={'dr' ''         2.708228              []}';
DR27={'dr' ''         4.901982              []}';
DR28={'dr' ''         65.897951              []}';
D10D={'dr' ''         4.29893              []}';
DMB01={'dr' ''        3.687288               []}';
DMB02={'dr' ''        0.27604               []}';
H1DL={'dr' ''         0.08335              []}';
DM03={'dr' ''         0.110211              []}';
V1DL={'dr' ''         0.08335              []}';
DM04={'dr' ''         0.49955              []}';
DM05={'dr' ''         0.660502              []}';
DM08={'dr' ''         0.686013              []}';
DM09={'dr' ''         0.550794              []}';
DM10B={'dr' ''        0.423278               []}';
DQSM1={'dr' ''        0.23738               []}';
DYC5={'dr' ''         0.307342              []}';
I4A={'dr' ''          0.32385-0.205742             []}';
I4B={'dr' ''          0.32385             []}';
I5={'dr' ''           0.32385            []}';
DM12A={'dr' ''        0.044958               []}';
I6={'dr' ''           0.32385            []}';
DM12B={'dr' ''        0.459314               []}';
DM12C={'dr' ''        0.31               []}';
DXC6={'dr' ''         0.68              []}';
DM2={'dr' ''          0.561408             []}';
D2L={'dr' ''          0.6096             []}';
DM3={'dr' ''          0.1524             []}';
ST60L={'dr' ''        0.6096               []}';
DM4={'dr' ''          8.622041             []}';
DXCA0={'dr' ''        0.31               []}';
DYCA0={'dr' ''        0.356220-0.076799               []}';
ST61L={'dr' ''        0.6096               []}';
DM5={'dr' ''          0.561379             []}';
DM6={'dr' ''          0.567588             []}';
DMONI={'dr' ''        0.009525               []}';
WALL={'dr' ''         16.764              []}';
%={'dr' ''                       []}';

FFTBORGN={'mo' 'FFTBORGN'  0                     []}';
S100={'mo' 'S100'          0             []}';
C50PC20={'mo' 'C50PC20'    0                   []}';
I40IW1={'mo' 'I40IW1'      0                 []}';
M40B1={'mo' 'M40B1'        0               []}';
P460031T={'mo' 'P460031T'  0                     []}';
P460032T={'mo' 'P460032T'  0                     []}';
C50PC30={'mo' 'C50PC30'    0                   []}';
%I50I1A={'mo' 'I50I1A'     0                  []}';
IMBSY34={'mo' 'IMBSY34'    0                   []}';
W460042T={'mo' 'W460042T'  0                     []}';
P460045T={'mo' 'P460045T'  0                     []}';
PM3={'mo' 'PM3'            0           []}';
B2={'mo' 'B2'              0         []}';
D10B={'mo' 'D10B'          0             []}';
PC90={'mo' 'PC90'          0             []}';
I3={'mo' 'I3'              0         []}';
P950020T={'mo' 'P950020T'  0                     []}';
IV4={'mo' 'IV4'        0               []}';
D2={'mo' 'D2'          0             []}';
ST60={'mo' 'ST60'      0                 []}';
ST61={'mo' 'ST61'      0                 []}';
%={'mo' ''                       []}';

ZLIN15={'mo' 'ZLIN15'  0                     []}'; % station-100 (or "S100")      : Z=3048.000000  (Z' =   0.000000 m, X'= 0.000000 m, Y'= 0.000000 m)
BSYend={'mo' 'BSYEND'  0                     []}'; % FFTB side of muon plug wall  : Z=3224.022426  (Z' = 176.020508 m, X'= 0.000000 m, Y'=-0.821761 m)
RWWAKEss={'mo' 'RWWAKEss'  0                     []}'; %will be resistive wall wake of stainless steel in ELEGANT
BSYbeg={'mo' 'BSYBEG'  0                     []}';

DBMARK14={'mo' 'DBMARK14' 0                      []}'; %(50B1BEND) entrance of 50B1
DBMARK99={'mo' 'DBMARK99' 0                      []}'; %(52-SL2  ) 52 SL2

% 52 Line

  B50B1A  ={'be' 'B50B1' 1.1320272 [-0.86939816E-02 0 0 0 0.5 0 0]}';
  B50B1B  ={'be' 'B50B1' 1.1320272 [-0.86939816E-02 0 0 0 0 0.5 0]}';
  B52AGFA ={'be' 'B52AGF' 0.40010029 [-0.14360109E-02 0 0 0 0.5 0 0]}';
%                  K1=0.43265282
  B52AGFB ={'be' 'B52AGF' 0.40010029 [-0.14360109E-02 0 0 0 0 0.5 0]}';
%                  K1=0.43265282
  B52WIG1A={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0.5 0 pi/2]}';
  B52WIG1B={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0.5 pi/2]}';
  B52WIG2A={'be' 'B52WIG1' 0.23368102   [ 0.23818974E-02   0 0 0 0.5 0 pi/2]}';
  B52WIG2B={'be' 'B52WIG1' 0.23368102   [ 0.23818974E-02   0 0 0 0 0.5 pi/2]}';
  B52WIG3A={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0.5 0 pi/2]}';
  B52WIG3B={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0.5 pi/2]}';
  Q52Q2   ={'qu' 'Q52Q2' 0.37224614 -0.38544745}';
  XC69    ={'mo' 'XC69' 0 []}';
  YC54T   ={'mo' 'YC54T' 0 []}';
  YC59    ={'mo' 'YC59' 0 []}';
  BPM52   ={'mo' 'BPM52' 0 []}';
  BPM56   ={'mo' 'BPM56' 0 []}';
  BPM64   ={'mo' 'BPM64' 0 []}';
  BPM68   ={'mo' 'BPM68' 0 []}';
  IM61    ={'mo' 'IM61' 0 []}';
  PR45    ={'mo' 'PR45' 0 []}';
  PR55    ={'mo' 'PR55' 0 []}';
  PR60    ={'mo' 'PR60' 0 []}';
  WS62    ={'mo' 'WS62' 0 []}';
  DRI14001={'dr' '' 0.7620000 []}';
  DRI14002={'dr' '' 2.9725315 []}';
  DRI14003={'dr' '' 0.91440000E-01 []}';
  DRI14004={'dr' '' 0.2092970 []}';
  DRI14005={'dr' '' 0.1737360 []}';
  DRI14006={'dr' '' 0.1139068 []}';
  DRI14007={'dr' '' 0.2255520 []}';
  DRI14008={'dr' '' 0.1280160 []}';
  DRI14009={'dr' '' 0.1219200 []}';
  DRI14010={'dr' '' 0.1916339 []}';
%  T460061T={'dr' '' 0 []}';
  DRI14011={'dr' '' 0.1981200 []}';
  DRI14012={'dr' '' 0.3230880 []}';
  DRI14013={'dr' '' 0.4252539 []}';
  SL1X    ={'dr' '' 0 []}';
  DRI14014={'dr' '' 0.7909590 []}';
  SL1Y    ={'dr' '' 0 []}';
  DRI14015={'dr' '' 1.0088270 []}';
  DRI14016={'dr' '' 0.3139440 []}';
  DRI14017={'dr' '' 2.2764689 []}';
  SL2     ={'dr' '' 0 []}';

B12WAL=[D50B1     ,D50B1     , ...
        DR19      ,P460045T  ,DR20      ,BPMBSY51  ,DR21      , ...
        DR22      ,DR23      ,A4DXL     ,XCBSY60   ,A4DXL     , ...
        DR23A     ,BPMBSY61  ,DR23B     ,A4DYL     ,YCBSY62   , ...
        A4DYL     ,DR24      ,PMV       ,PMV       ,DR25      , ...
        DR25A     ,BPMBSY63  ,FPM1      ,PM1       ,PM1       , ...
        DR26      ,PM3       ,DR27      ,B2        ,DR28      , ...
        D10D      ,D10B      ,DMB01     ,PC90      ,DMB02     , ...
        H1DL      ,XCBSY81   ,H1DL      ,DM03      ,V1DL      , ...
        YCBSY82   ,V1DL      ,DM04      ,I3        ,DM05      , ...
        P950020T  ,DM08      ,IV4       ,DM09      ,BPMBSY83  , ...
        DM10B     ,QSM1      ,QSM1      ,DQSM1     ,Q5        , ...
        BPMBSY85  ,Q5        ,DYC5      ,I4A       ,I4B       , ...
        I5        ,I5        ,DM12A     ,I6        ,I6        , ...
        DM12B     ,YC5       ,DM12C     ,XC6       ,DXC6      , ...
        Q6        , ...
        BPMBSY88  ,Q6        ,DM2       ,D2L       ,D2        , ...
        D2L       ,DM3       ,ST60L     ,ST60      ,ST60L     , ...
        DM4       ,XCA0      ,DXCA0     ,YCA0      ,DYCA0     , ...
        ST61L     ,ST61      ,ST61L     ,DM5       ,QA0       , ...
        BPMBSY92  ,QA0       ,DM6       ,DMONI     , ...
        DMONI     ,WALL      ,BSYend  ];

B52LIN=[B50B1A    ,B50B1B    ,DRI14001  ,PR45      ,DRI14002  , ...
        BPM52     ,DRI14003  ,B52AGFA   ,B52AGFB   ,DRI14004  , ...
        B52WIG1A  ,B52WIG1B  ,DRI14005  ,B52WIG2A  ,YC54T     , ...
        B52WIG2B  ,DRI14005  ,B52WIG3A  ,B52WIG3B  ,DRI14006  , ...
        PR55      ,DRI14007  ,BPM56     ,DRI14008  ,Q52Q2     , ...
        Q52Q2     ,DRI14009  ,PR60      ,DRI14010  ,IM61      , ...
        DRI14011  ,WS62      ,DRI14012  ,YC59      ,DRI14013  , ...
        SL1X      ,BPM64     ,DRI14014  ,SL1Y      ,DRI14015  , ...
        BPM68     ,DRI14016  ,XC69      ,DRI14017  ,SL2       , ...
        DBMARK99];

BSY=[BSYbeg  , ...
     DRIF0105,Q50Q1   ,Q50Q1   ,DRIF0106,BPMBSY1, ...
     DRIF0107,FFTBORGN,DRIF0108,S100    ,ZLIN15  ,DRIF0109, ...
     XCBSY09,DRIF0110,YCBSY10,DRIF0111,C50PC20 , ...
     DRIF0112,I40IW1  ,DRIF0113,M40B1   ,DRIF0114, ...
     XCBSY26,DRIF0110,YCBSY27,DRIF0115,Q50Q2   , ...
     Q50Q2   ,DRIF0116,BPMBSY29,DRIF0117,P460031T, ...
     DRIF0118,P460032T,DRIF0119,C50PC30 ,DRIF0120, ...
     IMBSY34,DRIF0121,XCBSY34,DRIF0122,YCBSY35, ...
     DRIF0123,XCBSY36,DRIF0110,YCBSY37,DRIF0124, ...
     Q50Q3   ,Q50Q3   ,DRIF0125,BPMBSY39,DRIF0125, ...
     W460042T,DRIF0126,DBMARK14];


% (L)inac (T)o (U)ndulator

% Parameters below are used to set LTU Y-bends so that beam is level w.r.t. gravity at center of FEL-undulator, including 30-m extension
S100_PITCH  = -4.760000E-3;                           % pitch-down angle of linac at station-100 [rad] (0.27272791 deg)
S100_HEIGHT = 77.643680;                              % station-100 height above local sea level, from Catherine LeCocq, Jan. 22, 2004 [m]
Z_S100_UNDH = 583.000000;                             % undulator center is defined as 583 m from sta-100 meas. along und. Z-axis (~1/2 und+xtns)
R_Earth     = 6.372508025E6;                          % total radius of Earth (gaussain sphere) from Catherine LeCocq, Jan. 2004 [m]

LB3 = 2.623;      %4D102.36T effective length (m)
GB3 = 0.023;      %4D102.36T gap height (m)
LVB = 1.025;      %3D39 vertical bend effective length (m)
GVB = 0.034925;   %vertical bend gap width (m)

AVB = (S100_PITCH + asin(Z_S100_UNDH/(R_Earth+S100_HEIGHT)))/2; %bend up twice this angle so e- is level in cnt. of und., incl. 30-m ext.

BY1A={'be' 'BY1'  LVB/2 [AVB/2 GVB/2 AVB/2     0 0.5 0.0 pi/2]}';
BY1B={'be' 'BY1'  LVB/2 [AVB/2 GVB/2     0 AVB/2 0.0 0.5 pi/2]}';
BY2A={'be' 'BY2'  LVB/2 [AVB/2 GVB/2 AVB/2     0 0.5 0.0 pi/2]}';
BY2B={'be' 'BY2'  LVB/2 [AVB/2 GVB/2     0 AVB/2 0.0 0.5 pi/2]}';

AB3P   = 0.5*pi/180*(+1);
AB3M   = 0.5*pi/180*(-1);
LeffB3 = LB3*AB3P/(2*sin(AB3P/2)); %full bend eff. path length (m)

BX31A={'be' 'BX31'  LeffB3/2 [AB3P/2 GB3/2 AB3P/2      0 0.5 0.0 0]}';
BX31B={'be' 'BX31'  LeffB3/2 [AB3P/2 GB3/2      0 AB3P/2 0.0 0.5 0]}';
BX32A={'be' 'BX32'  LeffB3/2 [AB3P/2 GB3/2 AB3P/2      0 0.5 0.0 0]}';
BX32B={'be' 'BX32'  LeffB3/2 [AB3P/2 GB3/2      0 AB3P/2 0.0 0.5 0]}';

DX33A={'dr' ''  LB3/2                     []}';     %optional bend for branch point
DX33B={'dr' ''  LB3/2                     []}';
DX34A={'dr' ''  LB3/2                     []}';
DX34B={'dr' ''  LB3/2                     []}';

BX35A={'be' 'BX35'  LeffB3/2 [AB3M/2 GB3/2 AB3M/2      0 0.5 0.0 0]}';
BX35B={'be' 'BX35'  LeffB3/2 [AB3M/2 GB3/2      0 AB3M/2 0.0 0.5 0]}';
BX36A={'be' 'BX36'  LeffB3/2 [AB3M/2 GB3/2 AB3M/2      0 0.5 0.0 0]}';
BX36B={'be' 'BX36'  LeffB3/2 [AB3M/2 GB3/2      0 AB3M/2 0.0 0.5 0]}';

DX37A={'dr' ''  LB3/2                     []}';     %optional bend for branch point
DX37B={'dr' ''  LB3/2                     []}';
DX38A={'dr' ''  LB3/2                     []}';
DX38B={'dr' ''  LB3/2                     []}';

% Single beam dumper vertical kicker:
% ----------------------------------
LKIK    = 1.0601;              % kicker coil length per magnet (m) [41.737 in from SA-380-330-02, rev. 0]

BYKIK1A={'be' 'BYKIK1'  LKIK/2 [1E-12/2 25.4E-3 0 0 0.5 0.0 pi/2]}';
BYKIK1B={'be' 'BYKIK1'  LKIK/2 [1E-12/2 25.4E-3 0 0 0.0 0.5 pi/2]}';
BYKIK2A={'be' 'BYKIK2'  LKIK/2 [1E-12/2 25.4E-3 0 0 0.5 0.0 pi/2]}';
BYKIK2B={'be' 'BYKIK2'  LKIK/2 [1E-12/2 25.4E-3 0 0 0.0 0.5 pi/2]}';

TDKIK={'dr' 'TDKIK'  0.6096                    []}'; %SBD vertical off-axis kicker dump
SPOILER={'mo' 'SPOILER'  0                     []}'; %SBD dump spoiler

% X-ray stripe 'wiggler' vertical 3-dipole chicane (from SLC BSY)

LBxw  = 0.233681;            %"Z" length (m)
%GBxw  = 1.05*in2m;           %gap height - SLC wiggler gap not known yet - used 1.05 inches for now - 7/6/05 -PE (m)
Brhox = Cb*Ef;               %beam rigidity in LTU (kG-m)
BBxw  = -6.0;                %X-ray chicane bend field (kG) - (eta matching in DL2 not fixed yet: small error - PE)
RBxw  = Brhox/BBxw;          %X-ray chicane bend radius (m)
ABxw  = asin(LBxw/RBxw);     %full X-ray chicane bend angle (rad)

DBYw1A={'dr' ''  LBxw/2                     []}';
DBYw1B={'dr' ''  LBxw/2                     []}';
DBYw2A={'dr' ''  LBxw                     []}';
DBYw2B={'dr' ''  LBxw                     []}';
DBYw3A={'dr' ''  LBxw/2                     []}';
DBYw3B={'dr' ''  LBxw/2                     []}';

LDw1o = 0.173736;
SDw1o = LDw1o/cos(ABxw);
Dw1o={'dr' ''  SDw1o                     []}';

%KQVM1 = -0.978990884832; % Original BSY optics
%KQVM2 =  0.666842383965;
%KQVM3 =  0.757009388096;
%KQVM4 = -0.735502720623;
%KQVB  = -0.42223036711;

KQVM1 = -0.685292956771; % New BSY optics
KQVM2 =  0.605930850174;
KQVM3 =  0.769308749867;
KQVM4 = -0.774280712935;
KQVB  = -0.42223036711;

KQDL   = 0.44267670105;
KCQ31  = 0;
KCQ32  = 0;
KQT1   =-0.420937827343;
KQT2   = 0.839614778043;

QVM1={'qu' 'QVM1' LQF/2  KQVM1}';
QVM2={'qu' 'QVM2' LQF/2  KQVM2}';
QVB1={'qu' 'QVB1' LQF/2  KQVB}';
QVB2={'qu' 'QVB2' LQF/2 -KQVB}';
QVB3={'qu' 'QVB3' LQF/2  KQVB}';
QVM3={'qu' 'QVM3' LQF/2  KQVM3}';
QVM4={'qu' 'QVM4' LQF/2  KQVM4}';
QDL31={'qu' 'QDL31' LQA/2 KQDL}';
QDL32={'qu' 'QDL32' LQA/2 KQDL}';
QDL33={'qu' 'QDL33' LQA/2 KQDL}';
QDL34={'qu' 'QDL34' LQA/2 KQDL}';
CQ31={'qu' 'CQ31'  LQx/2 KCQ31}';
CQ32={'qu' 'CQ32'  LQx/2 KCQ32}';
%CQ31={'dr' 'CQ31'  LQx/2 []}';
%CQ32={'dr' 'CQ32'  LQx/2 []}';
QT11={'qu' 'QT11' LQF/2 KQT1}';
QT12={'qu' 'QT12' LQF/2 KQT2}';
QT13={'qu' 'QT13' LQF/2 KQT1}';
QT21={'qu' 'QT21' LQF/2 KQT1}';
QT22={'qu' 'QT22' LQF/2 KQT2}';
QT23={'qu' 'QT23' LQF/2 KQT1}';
QT31={'qu' 'QT31' LQF/2 KQT1}';
QT32={'qu' 'QT32' LQF/2 KQT2}';
QT33={'qu' 'QT33' LQF/2 KQT1}';
QT41={'qu' 'QT41' LQF/2 KQT1}';
QT42={'qu' 'QT42' LQF/2 KQT2}';
QT43={'qu' 'QT43' LQF/2 KQT1}';

%dz_adjust = 47.825;
%={'dr' ''  0                     []}';
%D10cm={'dr' ''  0.10                     []}';
%D10cma={'dr' ''  0.127                     []}';
%DC10cm={'dr' ''  0.10                     []}';
%D21cm={'dr' ''  0.21                     []}';
D25cm={'dr' ''  0.25                     []}';
D29cma={'dr' ''  0.29+0.023878+0.1000244+0.1704396     []}';
D30cm={'dr' ''  0.30                     []}';
%D32cm={'dr' ''  0.32                     []}';
D32cmb={'dr' ''  0.32-0.056221+0.4000244                     []}';
D32cmd={'dr' ''  0.32-0.056221+0.4000244+0.2404381           []}';
%D40cm={'dr' ''  0.40                     []}';
D40cmC={'dr' ''  0.4                     []}';
D40cmd={'dr' ''  0.40+0.090013-0.000473  []}';
D40cme={'dr' ''  0.40+0.090013+0.010447  []}';
D40cmf={'dr' ''  0.40+0.090013-0.065013  []}';
%D50cm={'dr' ''  0.50                     []}';
%D34cm={'dr' ''  0.34                     []}';
D31A={'dr' ''  0.40+dLQA2+0.090005                     []}';
D31B={'dr' ''  0.40+dLQA2+0.4900025-0.4000244                     []}';
D32A={'dr' ''  0.40+dLQA2                     []}';
D32B={'dr' ''  0.40+dLQA2                     []}';
D33A={'dr' ''  0.21+dLQA2+0.380004-0.1000244-0.1704396       []}';
D33B={'dr' ''  0.40+dLQA2+0.4900025-0.4000244-0.2404381      []}';
D34A={'dr' ''  0.40+dLQA2+0.09-0.00046               []}';
D34B={'dr' ''  0.25+dLQA2+0.2399776-0.2404376        []}';
%  DEM1A  : DRIF, L=0.40+dLQA2
%  DEM1B  : DRIF, L=4.00+dLQA2*2
%  DEM2B  : DRIF, L=0.40+dLQA2
%  DEM3A  : DRIF, L=0.40+dLQA2
%  DEM3B  : DRIF, L=0.30+dLQA2+0.402839
%  DEM4A  : DRIF, L=0.40+dLQA2-0.402839+(0.402839)
%  D32cmc : DRIF, L=0.32-0.0254
%  DUM1A  : DRIF, L=0.40+dLQA2+0.0254
%  DUM1B  : DRIF, L=0.40+dLQA2
%  D32cma : DRIF, L=0.32+0.0253999
%  DUM2A  : DRIF, L=0.40+dLQA2-0.0253999
%  DUM2B  : DRIF, L=0.40+dLQA2
%  DUM3A  : DRIF, L=0.40+dLQA2+0.125
%  DUM3B  : DRIF, L=0.40+dLQA2
%  DUM4A  : DRIF, L=0.40+dLQA2+0.0254
%  DUM4B  : DRIF, L=0.40+dLQA2+0.127
DYCVM1={'dr' ''  0.40                     []}';
DQVM1={'dr' ''  0.34                     []}';
DVB25cm={'dr' ''  0.5-0.25                     []}';
DVB25cmc={'dr' ''  0.5-0.25                     []}';
DQVM2={'dr' ''  0.5                     []}';
DXCVM2={'dr' ''  0.25                     []}';
DVB1={'dr' ''  8.0-2*0.3125                     []}';
DVB1m40cm={'dr' ''  8.0-0.4-2*0.3125                     []}';
DVB2={'dr' ''  4.0                     []}';
DVB2m80cm={'dr' ''  4.0-0.4-0.4                     []}';
%DVBe={'dr' ''  0.5                     []}';
DVBem25cm={'dr' ''  0.5-0.25                     []}';
DVBem15cm={'dr' ''  0.150+0.00381+0.018803                     []}';
D10cmb={'dr' ''  0.1064869                     []}';
D25cma={'dr' ''  0.25-0.00381-0.018803-0.0064869                     []}';
%DDL10={'dr' ''  12.86072                     []}';
DDL10m70cm={'dr' ''  12.86072-0.4-0.3-0.09+0.00046        []}';
%DDL10u={'dr' ''  0.5                     []}';
DDL10um25cm={'dr' ''  0.5-0.25-0.2399776+0.2404376        []}';
DDL10v={'dr' ''  12.86072-0.5                     []}';
%={'dr' ''                       []}';
DDL1a={'dr' ''  5.820626-LKIK/2                     []}';
DDL1c={'dr' ''  0.609226-LKIK/2                     []}';
DDL1b={'dr' ''  5.421642-LKIK/2                     []}';
DSPLR={'dr' ''  0.43036                     []}';
D30cma={'dr' ''  0.257426                     []}';
DPC1={'dr' ''  0.266697                     []}';
DPC2={'dr' ''  0.266697                     []}';
DPC3={'dr' ''  0.266697                     []}';
DPC4={'dr' ''  0.266697+0.339613-0.8128/2                     []}';
DDL1dm30cm={'dr' ''  0.379160-0.262228                     []}'; % allow possible new spontaneous undulator here
DDL1cm40cm={'dr' ''  6.03036-0.43036-0.6096/2       []}';
LSPONT = 1.5;                           % length of possible spontaneous undulator (<=5 m now that TDKIK is also there)
SPONTUA={'dr' 'SPONTU'  LSPONT/2                     []}';
SPONTUB={'dr' 'SPONTU'  LSPONT/2                     []}';
DDL20={'dr' ''  0.5                     []}';
%DDL30={'dr' ''  1.0                     []}';
%DDL30m40cm={'dr' ''  1.0-0.4                     []}';
DDL10w={'dr' ''  12.86072-2*LDw1o-3*(LBxw)-1.1                     []}';
DDL10x={'dr' ''  0.250000-0.033681-0.090005                     []}';
%DDL10e={'dr' ''  12.86072                     []}';
%DDL10em50cm={'dr' ''  12.86072-0.25-0.25-0.090002-0.313878                     []}';
DDL10em80cm={'dr' ''  12.86072-0.4-0.4-0.433783                     []}';
DCQ31a={'dr' ''  6.037182             []}';
DCQ31b={'dr' ''  5.811658             []}';
DCQ32a={'dr' ''  5.4817585             []}';
DCQ32b={'dr' ''  6.0371785             []}';
DDL20e={'dr' ''  0.5                     []}';
%DDL30e={'dr' ''  1.0                     []}';
DDL30em40cm={'dr' ''  1.0-0.4-0.090013                     []}';
DDL30em40cma={'dr' ''  1.0-0.4-0.090013+0.000473       []}';
DDL30em40cmb={'dr' ''  1.0-0.4-0.090013-0.010447       []}';
DDL30em40cmc={'dr' ''  1.0-0.4-0.090013+0.065013       []}';
D40cmb={'dr' ''  0.40+0.090013                     []}';
%D25cmb={'dr' ''  0.25+0.0127                     []}';
%D25cmc={'dr' ''  0.25-0.0127                     []}';
%D40cma={'dr' ''  0.4+1.407939                     []}';
DWSDL31a={'dr' ''  0.096237                     []}'; %0.096779-0.000542
DWSDL31b={'dr' ''  0.153763                     []}'; %0.153221+0.000542

OTR30={'mo' 'OTR30'  0                     []}'; %LTU slice energy spread (90 deg from TCAV3)
WSDL31={'mo' 'WSDL31'  0                     []}';

VBin={'mo' 'VBIN'  0                     []}'; % start of vert. bend system   : Z=3226.684266  (Z' = 178.682319 m, X'= 0.000000 m, Y'=-0.834188 m)
VBout={'mo' 'VBOUT'  0                     []}'; % end of vert. bend system     : Z=3252.866954  (Z' = 204.865007 m, X'= 0.000000 m, Y'=-0.895305 m)
SS1={'mo' 'SS1'  0                     []}';
SS3={'mo' 'SS3'  0                     []}';
MM1={'mo' 'MM1'  0                     []}';
MM2={'mo' 'MM2'  0                     []}';
CNTV={'mo' 'CNTV'  0                     []}'; %ELEGANT will correct the orbit here for CSR-steering
CNTw={'mo' 'CNTW'  0                     []}'; %ELEGANT will correct the orbit here for CSR-steering
CNT3a={'mo' 'CNT3A'  0                     []}'; %ELEGANT will correct the orbit here for CSR-steering
CNT3b={'mo' 'CNT3B'  0                     []}'; %ELEGANT will correct the orbit here for CSR-steering
IM31={'mo' 'IM31'    0                     []}';
IMBCS1={'mo' 'IMBCS1'        0                     []}';
IMBCS2={'mo' 'IMBCS2'        0                     []}';
DBMARK34={'mo' 'DBMARK34'  0                     []}';
CEDL1={'dr' 'CEDL1'  0.08                     []}'; % XSIZE (or YSIZE) is the collimator half-gap (Tungsten body with Nitanium-Nitrite surface?)
CEDL3={'dr' 'CEDL3'  0.08                     []}';
LPCTDKIK= 0.8128;                                            % length of each if 4 muon protection collimator after TDKIK (0.875" ID w/pipe)
PCTDKIK1={'dr' 'PCTDKIK1'  LPCTDKIK                     []}'; % muon collimator after SBD TDKIK in-line dump
PCTDKIK2={'dr' 'PCTDKIK2'  LPCTDKIK                     []}'; % muon collimator after SBD TDKIK in-line dump
PCTDKIK3={'dr' 'PCTDKIK3'  LPCTDKIK                     []}'; % muon collimator after SBD TDKIK in-line dump
PCTDKIK4={'dr' 'PCTDKIK4'  LPCTDKIK                     []}'; % muon collimator after SBD TDKIK in-line dump
%={'mo' ''  0                     []}';

%={'qu' ''  }';
%={'qu' ''  }';

XCVB2={'mo' 'XCVB2'  0                     []}';
XCVM2={'mo' 'XCVM2'  0                     []}';      % calibrated to <1%
XCVM3={'mo' 'XCVM3'  0                     []}';
XCDL1={'mo' 'XCDL1'  0                     []}';
XCDL2={'mo' 'XCDL2'  0                     []}';
XCDL3={'mo' 'XCDL3'  0                     []}';
XCDL4={'mo' 'XCDL4'  0                     []}';     % fast-feedback (loop-4)
XCQT12={'mo' 'XCQT12'  0                     []}';
XCQT22={'mo' 'XCQT22'  0                     []}';
XCQT32={'mo' 'XCQT32'  0                     []}';      % fast-feedback (loop-4)
XCQT42={'mo' 'XCQT42'  0                     []}';
%={'mo' ''  0                     []}';
%={'mo' ''  0                     []}';

YCVB1={'mo' 'YCVB1'  0                     []}';
YCVB3={'mo' 'YCVB3'  0                     []}';
YCVM1={'mo' 'YCVM1'  0                     []}';        % calibrated to <1%
YCVM4={'mo' 'YCVM4'  0                     []}';
YCDL1={'mo' 'YCDL1'  0                     []}';
YCDL2={'mo' 'YCDL2'  0                     []}';
YCDL3={'mo' 'YCDL3'  0                     []}';
YCDL4={'mo' 'YCDL4'  0                     []}';
YCQT12={'mo' 'YCQT12'  0                     []}';
YCQT22={'mo' 'YCQT22'  0                     []}';
YCQT32={'mo' 'YCQT32'  0                     []}';        % fast-feedback (loop-4)
YCQT42={'mo' 'YCQT42'  0                     []}';        % fast-feedback (loop-4)

BPMVM1={'mo' 'BPMVM1'  0                     []}';
BPMVM2={'mo' 'BPMVM2'  0                     []}';
BPMVB1={'mo' 'BPMVB1'  0                     []}';
BPMVB2={'mo' 'BPMVB2'  0                     []}';
BPMVB3={'mo' 'BPMVB3'  0                     []}';
%BPMVB4={'mo' 'BPMVB4'  0                     []}'; % not existent?
BPMVM3={'mo' 'BPMVM3'  0                     []}';
BPMVM4={'mo' 'BPMVM4'  0                     []}';
BPMDL1={'mo' 'BPMDL1'  0                     []}';
BPMDL2={'mo' 'BPMDL2'  0                     []}';
BPMDL3={'mo' 'BPMDL3'  0                     []}';
BPMDL4={'mo' 'BPMDL4'  0                     []}';
BPMT12={'mo' 'BPMT12'  0                     []}';
BPMT22={'mo' 'BPMT22'  0                     []}';
BPMT32={'mo' 'BPMT32'  0                     []}';
BPMT42={'mo' 'BPMT42'  0                     []}';

%ECELL=[QE31,DQEC,DQEC,QE32,QE32,DQEC,DQEC,QE31];

VBEND=[VBin, ...
       BY1A,BY1B,DVB1,QVB1,BPMVB1,QVB1,D40cmC,YCVB1,  ...
       DVB2m80cm,XCVB2,D40cmC,QVB2,BPMVB2,QVB2,DVB2,  ...
       QVB3,BPMVB3,QVB3,D40cmC,YCVB3,DVB1m40cm,BY2A,BY2B,CNTV,  ...
       VBout];

VBSYS=[DYCVM1, ...
       YCVM1,DQVM1,QVM1,BPMVM1,QVM1,DQVM2, ...
       QVM2,BPMVM2,QVM2,DXCVM2,XCVM2,DVB25cm, ...
       VBEND,DVB25cmc, ...
       XCVM3,D25cm,QVM3,BPMVM3,QVM3,DVBem25cm, ...
       YCVM4,D25cm,QVM4,BPMVM4,QVM4,DVBem15cm,IM31,D10cmb,IMBCS1, ...
       D25cma];

EWIG=[DBYw1A,DBYw1B,Dw1o,DBYw2A,DBYw2B,Dw1o,DBYw3A,DBYw3B, ...
      CNTw];

DL21=[DBMARK34,BX31A,BX31B,DDL10w,EWIG, ...
      DWSDL31a,WSDL31,DWSDL31b,DDL10x, ...
      XCDL1,D31A,QDL31,BPMDL1,QDL31,D31B,YCDL1,D32cmb,CEDL1, ...
      DDL10em80cm,BX32A,BX32B,CNT3a];

DL22=[DX33A,DX33B,DDL1a,BYKIK1A,BYKIK1B,DDL1c,DDL1c, ...
      BYKIK2A,BYKIK2B,DDL1b,XCDL2,D32A,QDL32,BPMDL2, ...
      QDL32,D32B,YCDL2,DSPLR,SPOILER,DDL1cm40cm,TDKIK,D30cma, ...
      PCTDKIK1,DPC1,PCTDKIK2,DPC2,PCTDKIK3,DPC3,PCTDKIK4,DPC4, ...
      SPONTUA,SPONTUB,DDL1dm30cm,DX34A,DX34B];

DL23=[BX35A,BX35B,DCQ31a,CQ31,CQ31,DCQ31b,OTR30,D29cma,XCDL3, ...
      D33A,QDL33,BPMDL3,QDL33,D33B,YCDL3,D32cmd,CEDL3, ...
      DCQ32a,CQ32,CQ32,DCQ32b,BX36A,BX36B,CNT3b];

DL24=[DX37A,DX37B,D30cm,IMBCS2,DDL10m70cm,XCDL4,D34A,QDL34, ...
      BPMDL4,QDL34,D34B,YCDL4,DDL10um25cm,DDL10v,DX38A,DX38B];

TRIP1=[DDL20e,QT11,QT11,DDL30em40cm,XCQT12,D40cmb,QT12, ...
       BPMT12,QT12,D40cmb,YCQT12,DDL30em40cm,QT13,QT13,DDL20e];

TRIP2=[DDL20,QT21,QT21,DDL30em40cm,XCQT22,D40cmb,QT22, ...
       BPMT22,QT22,D40cmb,YCQT22,DDL30em40cm,QT23,QT23,DDL20];

TRIP3=[DDL20e,QT31,QT31,DDL30em40cma,XCQT32,D40cmd,QT32, ...
       BPMT32,QT32,D40cme,YCQT32,DDL30em40cmb,QT33,QT33,DDL20e];

TRIP4=[DDL20,QT41,QT41,DDL30em40cmc,XCQT42,D40cmf,QT42, ...
       BPMT42,QT42,D40cmb,YCQT42,DDL30em40cm,QT43,QT43,DDL20];

DOGLG2A=[DL21,TRIP1,SS1,DL22,TRIP2];

DOGLG2B=[DL23,TRIP3,SS3,DL24,TRIP4];


% (E)mittance (D)iagnostic matching

LQx=0.1080;         %Everson-Tesla (ET) quads "1.259Q3.5" effective length (m)
KQEM1=-0.3948193191;
KQEM2= 0.437029374266;
KQEM3=-0.601204901993;
KQEM4= 0.425609607536;
otr33=0;
if otr33
    KQEM1  = 0.52306699115;        % set KQED2=0 and match QEM1-4 for slice-y-emit on OTR33: BETX,Y=20.6 m, ALFX,Y=0 (20.6=12*DE3[L]/5)
    KQEM2  =-0.353726691931;
    KQEM3  = 0.476261672082;   % use to quad scan slice-y-emit on OTR33 (+-3%)
    KQEM4  =-0.277924519959;
end

D25cmb={'dr' ''          0.25+0.0127     []}';
D25cmc={'dr' ''          0.25-0.0127     []}';
DMM1m90cm={'dr' ''          2.0-0.25-0.25-0.4+0.10046     []}';
DMM3m80cm={'dr' ''          10.0-0.4-0.4+2.0+0.07092     []}';
DMM4m90cm={'dr' ''          3.6-0.30-LQx-(0.402839)-0.02954     []}';
DMM5={'dr' ''          2.0+dLQA2     []}';

DEM1A={'dr' ''           0.40+dLQA2-0.10046        []}';
DEM1B={'dr' ''           4.00+dLQA2*2        []}';
DEM2B={'dr' ''           0.40+dLQA2+0.02954        []}';
DEM3A={'dr' ''           0.40+dLQA2-0.10046        []}';
DEM3B={'dr' ''           0.30+dLQA2+0.402839        []}';
DEM4A={'dr' ''           0.40+dLQA2-0.402839+(0.402839)+0.02954        []}';

D40cm    ={'dr' ''          0.40                  []}';

YCEM1 ={'mo' 'YCEM1'   0                     []}';
XCEM2 ={'mo' 'XCEM2'   0                     []}';
YCEM3 ={'mo' 'YCEM3'   0                     []}';
XCEM4 ={'mo' 'XCEM4'   0                     []}';
IM36  ={'mo' 'IM36'    0                     []}';
BPMEM1={'mo' 'BPMEM1'  0                     []}';
BPMEM2={'mo' 'BPMEM2'  0                     []}';
BPMEM3={'mo' 'BPMEM3'  0                     []}';
BPMEM4={'mo' 'BPMEM4'  0                     []}';
QEM1={'qu' 'QEM1'           LQA/2                 KQEM1}';
QEM2={'qu' 'QEM2'           LQA/2                 KQEM2}';
QEM3={'qu' 'QEM3'           LQA/2                 KQEM3}';
QEM3V={'qu' 'QEM3V'         LQx/2                     0}';
QEM4={'qu' 'QEM4'           LQA/2                 KQEM4}';

EDMCH=[D25cmb,IM36,D25cmc,DMM1m90cm,YCEM1, ...
       DEM1A,QEM1,BPMEM1,QEM1,DEM1B,QEM2,BPMEM2,QEM2,DEM2B, ...
       XCEM2,DMM3m80cm,YCEM3,DEM3A,QEM3,BPMEM3,QEM3, ...
       DEM3B,QEM3V,QEM3V,DMM4m90cm,XCEM4,DEM4A,QEM4,BPMEM4, ...
       QEM4,DMM5];

% (E)mittance (D)iagnistc system
dz_adjust=47.825;
KQED2=0.402753198232*1;      %ED2 FODO quad strength (set =0 for slice-emit on OTR33)

if otr33
    KQED2=0.402753198232*0;      %ED2 FODO quad strength (set =0 for slice-emit on OTR33)
end

DQEA={'dr' ''            0.40+(LQF-LQx)/2-0.15046       []}';
DQEAa={'dr' ''            0.40+(LQF-LQx)/2-0.14046       []}';
DQEAb={'dr' ''            0.40+(LQF-LQx)/2-0.12046       []}';
DQEAc={'dr' ''            0.40+(LQF-LQx)/2+0.02954       []}';
DQEBx={'dr' ''            0.32+(LQF-LQx)/2+0.33655-0.0768665+0.04       []}';
DQEBy={'dr' ''            0.32+(LQF-LQx)/2+0.33655-0.0768665+0.04       []}';
DQEC={'dr' ''            4.6+dz_adjust/12+(LQF-LQx)/2       []}';
DE3={'dr' ''            4.6+dz_adjust/12+0.15046       []}';
DE3a={'dr' ''            4.6+dz_adjust/12+0.14046       []}';
DE3m40cm={'dr' ''            4.6-0.4+dz_adjust/12+0.15046       []}';
DE3m80cm={'dr' ''            4.6-0.4-0.4+dz_adjust/12-0.02954       []}';
DE3m80cma={'dr' ''            4.6-0.4-0.4+dz_adjust/12+0.15046       []}';
DE3m80cmb={'dr' ''            4.6-0.4-0.4+dz_adjust/12+0.12046       []}';
DQEBx2={'dr' ''            4.6-0.4-0.4+dz_adjust/12-0.33655+0.0768665-0.04       []}';
DQEBy2={'dr' ''            4.6-0.4+dz_adjust/12-0.33655+0.0768665-0.04       []}';

CX31={'dr' 'CX31'            0.08       []}'; % 2.2 mm half-gap in X and Y here (beta_max=67 m) keeps worst case radius: r = sqrt(x^2+y^2) < 2 mm in undulator (beta_max=35 m)
CY32={'dr' 'CY32'            0.08       []}';
CX35={'dr' 'CX35'            0.08       []}';
CY36={'dr' 'CY36'            0.08       []}';
DCX37={'dr' ''          0.08                  []}'; %CX37
DCY38={'dr' ''          0.08                  []}'; %CY38

DBMARK36={'mo' 'DBMARK36'   0                 []}'; %(WS31    ) center of WS31
XCE31 ={'mo' 'XCE31'   0                     []}';
YCE32 ={'mo' 'YCE32'   0                     []}';
XCE33 ={'mo' 'XCE33'   0                     []}';
YCE34 ={'mo' 'YCE34'   0                     []}';
XCE35 ={'mo' 'XCE35'   0                     []}';
YCE36 ={'mo' 'YCE36'   0                     []}';
WS31={'mo' 'WS31'    0                     []}';
WS32={'mo' 'WS32'    0                     []}';
WS33={'mo' 'WS33'    0                     []}';
WS34={'mo' 'WS34'    0                     []}';
OTR33={'mo' 'OTR33'  0                     []}';
BPME31={'mo' 'BPME31'  0                     []}';
BPME32={'mo' 'BPME32'  0                     []}';
BPME33={'mo' 'BPME33'  0                     []}';
BPME34={'mo' 'BPME34'  0                     []}';
BPME35={'mo' 'BPME35'  0                     []}';
BPME36={'mo' 'BPME36'  0                     []}';
QE31={'qu' 'QE31'           LQx/2                +KQED2}';
QE32={'qu' 'QE32'           LQx/2                -KQED2}';
QE33={'qu' 'QE33'           LQx/2                +KQED2}';
QE34={'qu' 'QE34'           LQx/2                -KQED2}';
QE35={'qu' 'QE35'           LQx/2                +KQED2}';
QE36={'qu' 'QE36'           LQx/2                -KQED2}';

EDSYS=[DBMARK36,WS31,D40cm,DE3m80cma, ...
       XCE31,DQEA,QE31,BPME31,QE31,DQEBx,CX31,DQEBx2, ...
       DE3a,YCE32,DQEAa,QE32,BPME32,QE32,DQEBy,CY32, ...
       DQEBy2,WS32,D40cm,DE3m80cmb,XCE33,DQEAb, ...
       QE33,BPME33,QE33,DQEC,OTR33,DE3m40cm,YCE34,DQEA,QE34, ...
       BPME34,QE34,DQEC,WS33,D40cm,DE3m80cm,XCE35, ...
       DQEAc,QE35,BPME35,QE35,DQEBx,CX35,DQEBx2,DE3, ...
       YCE36,DQEA,QE36,BPME36,QE36,DQEBy,CY36,DQEBy2, ...
       WS34,D40cm];

% Undulator match section
KQUM1= 0.438152708498;         %for <beta>=30 m undulator
KQUM2=-0.387122017170;         %for <beta>=30 m undulator
KQUM3= 0.092751923581;         %for <beta>=30 m undulator
KQUM4= 0.340037095214;         %for <beta>=30 m undulator

QUM1     ={'qu' 'QUM1'      LQA/2                 KQUM1}';
QUM2     ={'qu' 'QUM2'      LQA/2                 KQUM2}';
QUM3     ={'qu' 'QUM3'      LQA/2                 KQUM3}';
QUM4     ={'qu' 'QUM4'      LQA/2                 KQUM4}';

DUM1A={'dr' ''          0.40+dLQA2+0.0254-0.00586     []}';
DUM1B={'dr' ''          0.40+dLQA2     []}';
DUM2A={'dr' ''          0.40+dLQA2-0.0253999-0.0750601     []}';
DUM2B={'dr' ''          0.40+dLQA2     []}';
DUM3A={'dr' ''          0.40+dLQA2+0.125-0.21546     []}';
DUM3B={'dr' ''          0.40+dLQA2     []}';
DUM4A={'dr' ''          0.40+dLQA2+0.0254+0.00414     []}';
DUM4B={'dr' ''          0.40+dLQA2+0.127     []}';
DU1m80cm={'dr' ''          4.550 []}';
DU2m120cm={'dr' ''          4.730 []}';
DU3m80cm={'dr' ''          8.0-0.4-0.4-0.125+0.21546 []}';
DU4m120cm={'dr' ''          2.800-1.407939-0.0254-0.00414 []}';
DU5m80cm={'dr' ''          0.5 []}';
DMUON2={'dr' ''          1.406800 []}';
DMUON1={'dr' ''          0.154859 []}';
DMUON3={'dr' ''          0.310592 []}';

D40cma   ={'dr' ''          0.4+1.407939          []}';
DVV35    ={'dr' ''          1.780-0.254-1.087896+0.003189 []}'; % drift after pre-undulator vacuum valve
D32cm    ={'dr' ''          0.32                  []}';
D32cmc   ={'dr' ''          0.32-0.0254+0.00586           []}';
D32cma   ={'dr' ''          0.32+0.0253999+0.0750601        []}';
DTDUND1  ={'dr' ''          0.5+0.127+1.087896-0.003189        []}'; % drift before pre-undulator tune-up dump
DTDUND2  ={'dr' ''          0.37935               []}'; % drift after pre-undulator tune-up dump
PCMUON   ={'dr' 'PCMUON'    1.1684                []}'; % muon scattering collimator after pre-undulator tune-up dump (ID from Rago: 7/18/08)

XCUM1    ={'mo' 'XCUM1'     0                     []}';
YCUM2    ={'mo' 'YCUM2'     0                     []}';
YCUM3    ={'mo' 'YCUM3'     0                     []}';
XCUM4    ={'mo' 'XCUM4'     0                     []}';

IMUNDI   ={'mo' 'IMUNDI'    0                     []}';
EOBLM    ={'mo' 'EOBLM'     0                     []}';
RWWAKEAl ={'mo' 'RWWAKEAl'  0                     []}';
TDUND    ={'mo' 'TDUND'     0                     []}';
VV999    ={'mo' 'VV999'     0                     []}';
MM3      ={'mo' 'MM3'       0                     []}';
PFILT1   ={'mo' 'PFILT1'    0                     []}';
DBMARK37 ={'mo' 'DBMARK37'  0                     []}';

BPMUM1   ={'mo' 'BPMUM1'    0                     []}';
BPMUM2   ={'mo' 'BPMUM2'    0                     []}';
BPMUM3   ={'mo' 'BPMUM3'    0                     []}';
BPMUM4   ={'mo' 'BPMUM4'    0                     []}';
RFB07    ={'mo' 'RFB07'     0                     []}';
RFB08    ={'mo' 'RFB08'     0                     []}';

UNMCH=[DU1m80cm,DCX37,D32cmc,XCUM1,DUM1A,QUM1,BPMUM1,QUM1,DUM1B, ...
       D32cm,DU2m120cm,DCY38,D32cma,YCUM2,DUM2A,QUM2, ...
       BPMUM2,QUM2,DUM2B,DU3m80cm,YCUM3,DUM3A, ...
       QUM3,BPMUM3,QUM3,DUM3B,D40cma,EOBLM,DU4m120cm, ...
       XCUM4,DUM4A,QUM4,BPMUM4,QUM4,DUM4B,RFB07,DU5m80cm, ...
       IMUNDI,D40cm,RWWAKEAl,DMUON2,DVV35,RFB08,DTDUND1, ...
       TDUND,DTDUND2,PCMUON,DMUON1,VV999,DMUON3,MM3,PFILT1, ...
       DBMARK37];

% Undulator exit section
LQD=0.550;          %FFTB dump quad (3.25Q20) effective length (m)
KQUE1= 0.104402672527;    % [<beta>=30 m]
KQUE2=-0.034721612961;    % [<beta>=30 m]

DUE1a={'dr' ''               10.720575-8.930036      []}';
DUE1d={'dr' ''               8.930036+0.411634      []}';
DUE1b={'dr' ''               0.5-0.411634+0.038094      []}';
DUE1c={'dr' ''               0.455460-0.038094      []}';
DUE2a={'dr' ''               0.455460+0.139704+0.129836      []}';
DUE2b={'dr' ''               10.609500-0.17858      []}';
DUE2c={'dr' ''               0.455460+0.050796+0.048744      []}';
DUE3a={'dr' ''               0.455460-0.139956      []}';
DUE3b={'dr' ''               0.144120      []}';
DUE3c={'dr' ''               5.0429295      []}'; %11.919836
DUE3d={'dr' ''               6.8769065      []}';
DUE4={'dr' ''                0.5      []}';
DUE5A={'dr' ''               1.020814-0.0762-0.009011      []}';
DUE5C={'dr' ''               0.33362-0.00362      []}';
DUE5D={'dr' ''               0.145566+0.0762+0.012631      []}';

QUE1 ={'qu' 'QUE1'           LQD/2                 KQUE1}';
QUE2 ={'qu' 'QUE2'           LQD/2                 KQUE2}';

UEbeg={'mo' 'UEbeg'          0                     []}';
TRUE1={'mo' 'TRUE1'          0                     {}}'; %Be foil inserter (THz)
UEend={'mo' 'UEend'          0                     []}';
BPMUE1={'mo' 'BPMUE1'        0                     []}';
BPMUE2={'mo' 'BPMUE2'        0                     []}';
BPMUE3={'mo' 'BPMUE3'        0                     []}';
VV36={'mo' 'VV36'            0                     []}';
VV37={'mo' 'VV37'            0                     []}';
IMUNDO={'mo' 'IMUNDO'        0                     []}';
XCUE1={'mo' 'XCUE1'          0                     []}';
YCUE2={'mo' 'YCUE2'          0                     []}';
XCD3={'mo' 'XCD3'            0                     []}';
YCD3={'mo' 'YCD3'            0                     []}';
LPCPM=0.076;
PCPM0={'dr' 'PCPM0'          LPCPM                 []}';
BTM0={'mo' 'BTM0'            0                     []}';
DLstart={'mo' 'DLSTART'      0                     []}';
DSB0a ={'dr' ''              0.111120              []}';
DSB0b ={'dr' ''              0.21491               []}';
DSB0c ={'dr' ''              0.235534+0.031167     []}';
DSB0d ={'dr' ''              0.278039-0.031167     []}';
IMBCS3={'mo' 'IMBCS3'        0                     []}';

UNDEXIT=[UEbeg,DUE1a,VV36,DUE1d,IMUNDO,DUE1b,BPMUE1,DUE1c, ...
         QUE1,QUE1,DUE2a,XCUE1,DUE2b,YCUE2,DUE2c,QUE2,QUE2, ...
         DUE3a,BPMUE2,DUE3b,PCPM0,BTM0,DUE3c,TRUE1,DUE3d,DUE4, ...
         DUE5A,YCD3,DUE5C,XCD3,DUE5D,UEend,DLstart, ...
         DSB0a,VV37,DSB0b,BPMUE3,DSB0c,IMBCS3,DSB0d];

% Dumpline

LBdm   = 1.452;          %!effective vertical bend length of main dump bends - from J. Tanabe (m)
GBdm   = 0.043;          %full gap (m) - this is a full gap 'width' for these vert. dipoles
ABdm0  = (5.0*pi/180)/3;

LeffBdm = LBdm*ABdm0/(2*sin(ABdm0/2)); %full bend path length (m)

BYD1A={'be' 'BYD1'  LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0.0  pi/2]}';
BYD1B={'be' 'BYD1'  LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0.0  0.57 pi/2]}';
BYD2A={'be' 'BYD2'  LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0.0  pi/2]}';
BYD2B={'be' 'BYD2'  LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0.0  0.57 pi/2]}';
BYD3A={'be' 'BYD3'  LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0.0  pi/2]}';
BYD3B={'be' 'BYD3'  LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0.0  0.57 pi/2]}';

KQDmp  = -0.112488747732;   % [<beta>=30 m]
QDmp1={'qu' 'QDMP1' LQD/2 KQDmp}';
QDmp2={'qu' 'QDMP2' LQD/2 KQDmp}';
Ddmpv  = -0.73352263654;
LDS    = 0.300-0.026027*2;
LDSC   = 0.499225-0.026027+0.1124278-0.008032;

DS={'dr' ''         LDS        []}';
DSc={'dr' ''         LDSC        []}';
DD1a={'dr' ''         2.6512616        []}';
DD1b={'dr' ''         6.8896877-LQD/2-Ddmpv+0.017094407653        []}';
DD1f={'dr' ''         0.266645-0.017094407653        []}';
DD1c={'dr' ''         0.4+0.2920945-0.266645-2*0.0381452        []}';
DD1d={'dr' ''         0.25-0.0079372        []}';
DD1e={'dr' ''         0.25+0.0079372        []}';
DD2a={'dr' ''         0.4+0.0634916+0.0115084        []}';
DD2b={'dr' ''         8.425460-LQD/2+Ddmpv-0.15-0.0634916-0.049684-0.0115084        []}';
DD3a={'dr' ''         0.3+0.049684+0.001583        []}';
DD3b={'dr' ''         0.3-0.001583-0.1447026        []}';
%DD3c={'dr' ''         2.580+0.1447026-0.2441932        []}';
DD3d={'dr' ''         0.2441932        []}';
DD3e={'dr' ''         0.2857474-0.2441932        []}';

DWSDUMPa={'dr' ''         0.44156         []}';%0.5-0.058217-0.000222-0.000001
DWSDUMPb={'dr' ''         2.038949         []}';%1.980509+0.058217+0.000222+0.000001

DMPend  ={'mo' 'DMPend'        0                []}';
OTRDMP  ={'mo' 'OTRDMP'        0                []}'; %Dump screen
WSDUMP  ={'mo' 'WSDUMP'        0                []}';
BTM1L   ={'mo' 'BTM1L'         0                []}'; % Burn-Through-Monitor behind PCPM1L
BTM2L   ={'mo' 'BTM2L'         0                []}'; % Burn-Through-Monitor behind PCPM2L
IMBCS4  ={'mo' 'IMBCS4'        0                []}'; %in dump line, after Y-bends, with >48-mm ID stay-clear (comparator with IMBCS3)
IMDUMP  ={'mo' 'IMDUMP'        0                []}'; %in dump line after Y-bends and quad (comparator with IMUNDO)
YCDD    ={'mo' 'YCDD'          0                []}';
XCDD    ={'mo' 'XCDD'          0                []}';
DBMARK38={'mo' 'DBMARK38'      0                []}'; %(UND_DUMP) final undulator dump
DUMPFACE={'mo' 'DUMPFACE'      0                []}'; % entrance face of main e- dump (same as EOL)
BTMDUMP ={'mo' 'BTMDUMP'       0                []}'; % Burn-Through-Monitor of main e- dump
BPMQD   ={'mo' 'BPMQD'         0                []}';
BPMDD   ={'mo' 'BPMDD'         0                []}';
EOL     ={'mo' 'EOL'           0                []}'; % near entrance face of dump   : Z=3763.781501  (Z' = 715.774454 m, X'=-1.250000 m, Y'=-3.180529 m)

LPCPM   = 0.076;
PCPM1L={'dr' 'PCPM1L'       LPCPM/cos(3*ABdm0)            []}';
PCPM2L={'dr' 'PCPM2L'       LPCPM/cos(3*ABdm0)            []}';

DUMPLINE=[BYD1A,BYD1B,DS,BYD2A,BYD2B,DS, ...
          BYD3A,BYD3B,DSc,PCPM1L,BTM1L,DD1a,IMDUMP,DD1b,YCDD, ...
          DD1f,PCPM2L,BTM2L,DD1c,QDmp1,QDmp1,DD1d,BPMQD,DD1e, ...
          QDmp2,QDmp2,DD2a,XCDD,DD2b,IMBCS4,DD3a,BPMDD,DD3b, ...
          OTRDMP,DWSDUMPa,WSDUMP,DWSDUMPb, ...
          DUMPFACE,DMPend,DD3d,EOL,DD3e,BTMDUMP, ...
          DBMARK38];

% BSY to End
LTU=[MM1,DOGLG2A,DOGLG2B,MM2,EDMCH,EDSYS,UNMCH];
BSYLTU=[RWWAKEss,BSY,B12WAL,VBSYS,LTU,UND,UNDEXIT,DUMPLINE];

beamLineUN=BSYLTU';
beamLine52=[RWWAKEss,BSY,B52LIN]';
beamLineBSY=BSY';
if strcmp(region,'52-Line'), beamLineUN=beamLine52;end
