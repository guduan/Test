function beamLine = model_beamLineLCLSII()

CLIGHT = 2.99792458e8;  % speed of light [m/s]
TWOPI  = 2*pi;
RADDEG  =pi/180;

% *** OPTICS=LCLSII24APR11 ***

%  ASSIGN, PRINT="LCLSII.print"

% ==============================================================================
% Modification History (LCLSII_MAIN.mad8)
% ------------------------------------------------------------------------------
% 29-APR-2011, M. Woodley
%    Name changes to avoid conflicts with LCLSI: QT4n -> QT4nB (n=1,2,3),
%    BPMT42 -> BPMT42B
% 24-APR-2011, P. Emma, J. Welch
%    Shift SXR upbeam ~0.1 m to line up HSSSTART with SSSSTART in local z-coordinate.
%    Move EOLH and EOLS to just pass the dump BTM.  Add X & Y steering coils
%    to SXR and HXR self-seeding sections (only at quads).  Add reference points 
%    fit in BYKIKB, SPOILERB, TDKIKB, D2B, ST60B, and ST61B.  Also set
%    Z''=1000.000000 m (local-un coord's) at HSSSTART and SSSSTART (near start of
%    und tunnel).
% 21-APR-2011, Y. Nosochkov
%    Move HXR undulator to Z=574 and SXR undulator to Z=620 in BSY coordinates.
%    Use 32 HXR and 18 SXR undulator segments.
%    Insert undulator-like cells between Z=515 and HXR/SXR undulators for
%    future self-seeding section, but for now without undulators and with
%    only 4 HXR quads and 6 SXR quads for matching. Insert a drift after
%    SXR undulator for future polarization section. Set upstream face
%    of dump bend at Z=727 and the dump face at Z=756 in BSY coordinates.
% 28-MAR-2011, Y. Nosochkov
%    Turn off quad QDL0S and add two quads QT53A, QT54A at end of triplets
%    TRIP3S, TRIP4S in LTUS. These now have 4 quads each. Wires are added 
%    at inner ends of TRIP3S, TRIP4S and at center of the QDL0S. 
%    The quad positions and strengths are matched to 120 degree between 
%    the outer wires. The collimator positions are adjusted for 
%    90 degree separation. LTUS matching quads for undulator are rematched.
% 23-MAR-2011, P. Emma
%    Remove QG02,3, XCG1,2, YCG2, BPMG1, and OTRS1 (not needed based on LCLS-I).
%    Also make consistent case usage for Henrik (e.g., CLIGHT, not clight).
%    Add CEBD energy collimator to bypass-line dog-leg and CX53,CY53,CX54,CY54
%    betatron collimators to angled LTUS branch line (gaps not right yet).
% 22-FEB-2011, P. Emma
%    Add correctors and BPMs in new sections (e.g., bypass-DL and LTUS) - 
%    see "2/22/11".  Rename many LTU components (e.g., BX6n -> BX4n).
% 19-FEB-2011, M. Woodley
%    Name changes to avoid conflicts with LCLSI: BPMDLn -> BPMDLnS (n=3,4,5)
% 17-FEB-2011, M. Woodley & P. Emma
%    Name changes to avoid conflicts with LCLSI:
%    - CEDL3 -> CEDL2, L0A___n -> L0AB__n, L0B___n -> L0BB__n,
%      L1X___n -> L1XB__n, WS42 -> WS42B;
%    fix BSY coordinates; add some plots; cleanup
% 14-FEB-2011, M. Woodley
%    Add beamlines: gun spectrometer, 135 MeV spectrometer, HXR dump line, HXR
%    safety dump line, SXR dump line, SXR safety dump line; remove DBMARKs;
%    turn laser heater bends ON
% 26-JAN-2011, P. Emma
%    Adjust some names, add plots, add energy collimators, locate undulators
%    near correct location, fix LTUH emit. diag. fitting error, create two
%    print files (LCLSIIH.print and LCLSIIS.print), add cathode beta fitting, etc.
% 21-JAN-2011, M. Woodley
%    Consolidate multiple files; set L1 phase = -20 deg; set BC1 R56 = 46 mm;
%    rematch
% 15-DEC-2010, Y. Nosochkov
%    Increase length of bypass dog-leg to 78.35 m and reduce bending angle 
%    to 11.7 mrad.
% 08-DEC-2010, P. Emma
%    Add LTUS SXR branch line.
% 07-DEC-2010, P. Emma
%    Remove several injector components based on non-use at LCLS-I (WS01b,
%    WS03b, SOL2b, XC03b/YC03b, CR01b, AM01b, WS04b, YAG01b, FC01b)
% 01-DEC-2010, Y. Nosochkov
%    Reduce beta and W-functions in bypass dogleg.
% 08-NOV-2010, P. Emma
%    Add LCLSII_UND.xsif file.
% 02-NOV-2010, P. Emma
%    Add many plots of machine sections; add WS02B/OTR2B matching; add new
%    LCLSII_L1e.xsif file for Elegant; remove "COUPLE" from TWISS command;
%    add matching at WS02B/OTR2B location; turn HTR UND OFF tempoarily for
%    MAD2LTE (but may be on now - see MATR)
% 29-OCT-2010, M. Woodley
%    LCLSII
% ==============================================================================
% ==============================================================================
% Element naming conventions with the first 1-3 characters meaning:
% ------------------------------------------------------------------------------
% SOL.. = SOLenoid (not fully modeled in this file - zero-length, etc)
% Q.... = Quadrupole (normal quad, and always split in half)
% SQ... = Skew-Quadrupole (skew quad, always split in half)
% CQ... = Correction Quadrupole (nominally zero strength, always split in half)
% BX... = Horizontal Bend (always split in two with suffixes "a" and "b")
% BY... = Vertical Bend (always split in two with suffixes "a" and "b")
% BR... = Rolled Bend (always split in two with suffixes "a" and "b")
% WS... = Wire Scanner transverse beam profile monitor
% PR... = screen-type Profile Monitor (transverse beam profile)
% YAG.. = YAG screen profile monitor (transverse beam profile)
% BPM.. = Beam Position Monitor (various resolutions, see TYPE=...)
% RFB.. = RF Beam position monitor (<1 micron rms resolution)
% OTR.. = Optical Transition Radiation transverse beam profile monitor
% XC... = X-Corrector steering dipole
% YC... = Y-Corrector steering dipole
% SC... = Steering Coil package (X- and Y-Corrector dipole set)
% BL... = Bunch Length monitor (various types)
% IM... = Bunch charge (I=current) Monitor (e.g. toroid)
% TD... = Tune-up Dump (insertable copper block to stop beam)
% CE... = Collimator for Energy cuts (adjustable)
% CX... = Collimator for X position cuts (adjustable)
% CY... = Collimator for Y position cuts (adjustable)
% PC... = Protection Collimator (fixed aperture)
% VV... = Vacuum Valve (not all valves are in deck)
% FC... = Faraday Cup (measure charge)
% CR... = Cerenkov radiator
% AM... = Alignment Mirror
% PH... = Beam phase detector
% RST.. = Radiation STopper
% BFW.. = Beam Finder Wire in FEL undulator for segment alignment
% BTM.. = Burn-Through Monitor BCS device
% ==============================================================================
% ==============================================================================
% CONSTANTs
% ==============================================================================
Cb=1.0E10/CLIGHT;%energy (GeV) to magnetic rigidity (kG-m)
GeV2MeV=1000;%GeV to MeV
in2m=0.0254;%inches to meters
inch2m=0.0254;%inches to meters
mc2=510.99906E-6;%e- rest mass [GeV]
SbandF=2856;%S-band rf frequency (MHz)
XbandF=11424;%X-band rf frequency (MHz)
DLWL10=3.0441;%"10 ft" structure length (m)
DLWL9=2.8692;%"9.4 ft" structure length (m)
DLWL7=2.1694;%"7 ft" structure length (m)
DLWLX=0.5948;%Xband structure length (m)
P25=1;%25% power factor
P50=sqrt(2);%50% power factor
% ==============================================================================
% FIXED REFERENCE POINTS ALONG BEAMLINES:
%    X,Y,Z: linac-coordinates;  X',Y',Z': LCLS-coordinates &;  X'',Y'',Z'': local-und-coordinates.
%    Linac-coord's in:   LCLS2H.print,     LCLS2S.print (with betas);
%    LCLS-coord's in:    BSY-LCLS2H.print, BSY-LCLS2S.print (no betas);
%    Local-und-coor's in UND-LCLS2H.print, UND-LCLS2S.print (no betas);
% ==============================================================================
% LINAC:
% - CATHODEB : Z=1001.911482 m (cathode), X=10.448935 m, Y=0, THETA=-0.610865 rad
% - ZLIN201  : Z=1017.862332 m (exit end of BX02 bend - start of main linac), X=Y=0
% - BC1MRKB  : Z=1028.167430 m (start of BC1)
% - BC2MRKB  : Z=1370.009600 m (start of BC2)
% - L3ENDB   : Z=1979.777600 m (end of L3 & start of bypass line dog-leg)
% - WALL20BE : Z=2022.632500 m (approx. start of sec-20 wall)
% - S100B    : Z=3048.000000 m (station-100, but off axis in X & Y), X=-0.650494 m, Y=0.649478 m
% - MUWALL   : Z=3207.258426 m (approx. upstr. face of muon plug wall), X=-0.650494 m, Y=0.649478 m
% LTU:
% - LTUSPLIT : Z=3354.229908 (Z'=306.232098, X'= -2.242107, Y'=-0.245834) (LTUH/S split point)
% HXR:
% - HSSSTART : Z=3562.995535 (Z'=515.000000, X'=-10.992075, Y'=-0.245834) [Z''=1000.000000] m
% - HXRSTART : Z=3621.994892 (Z'=574.000000, X'=-13.464907, Y'=-0.245834) [Z''=1059.051799] m
% - HXRTERM  : Z=3763.045219 (Z'=715.051865, X'=-19.376732, Y'=-0.245834) [Z''=1200.227499] m
% - EOLH     : Z=3804.288295 (Z'=756.284410, X'=-21.104888, Y'=-2.597748) [Z''=1241.496244] m
% SXR:
% - SSSSTART : Z=3562.890846 (Z'=514.895310, X'=-13.489882, Y'=-0.245834) [Z''=1000.000000] m
% - SXRSTART : Z=3667.889701 (Z'=619.895310, X'=-17.890686, Y'=-0.245834) [Z''=1105.092183] m
% - SXRTERM  : Z=3747.394734 (Z'=699.401209, X'=-21.222970, Y'=-0.245834) [Z''=1184.667883] m
% - EOLS     : Z=3804.183606 (Z'=756.179720, X'=-23.602695, Y'=-2.597748) [Z''=1241.496244] m
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% energy profile
% ------------------------------------------------------------------------------
E00      = 0.006 ;%beam energy after gun (GeV)
E0i      = 0.064 ;%beam energy between L0a and L0b sections (GeV)
Ei       = 0.135 ;%linac injection beam energy (GeV)
EBC1     = 0.25  ;%BC1 energy (GeV)
EBC2     = 4.20  ;%BC2 energy (GeV)
Ef       = 13.5  ;%final beam energy (GeV)
L0phase  = -2.5                ;%L0B S-band rf phase (deg)
dEL0A    = GeV2MeV*(E0i-E00)   ;%total L0A energy gain (MeV)
dEL0B    = GeV2MeV*(Ei-E0i)    ;%total L0B energy gain (MeV)
PhiL0    = L0phase/360         ;%radians/2pi
gfac0    = 3.095244            ;%L0B flange-to-flange length (121.86")
gradL0a  = dEL0A/(gfac0*cos(PhiL0*TWOPI));
gradL0b  = dEL0B/(gfac0*cos(PhiL0*TWOPI));
L1phase  = -20.0               ;%L1 S-band rf phase (deg)
L1Xphase =-160.0               ;%L1 X-band rf phase (deg)
dEL1     = GeV2MeV*(EBC1-Ei)   ;%total L1 energy gain (MeV)
dEL1X    = 19.0                ;%L1 X-band amplitude (MV)
PhiL1    = L1phase/360         ;%radians/2pi
PhiL1X   = L1Xphase/360        ;%radians/2pi
gfac1    = P50*DLWL9+P25*DLWL9+P25*DLWL10;
gradL1   = (dEL1-dEL1X*cos(PhiL1X*TWOPI))/(gfac1*cos(PhiL1*TWOPI));
L2phase  = -31.4               ;%L2 rf phase (deg)
dEL2     = GeV2MeV*(EBC2-EBC1) ;%total L2 energy gain (MeV)
PhiL2    = L2phase/360         ;%radians/2pi
gfac2    = 90*P25*DLWL10+1*P50*DLWL10+4*P25*DLWL9+8*P25*DLWL7;
gradL2   = dEL2/(gfac2*cos(PhiL2*TWOPI));
L3phase  = 0.0                 ;%L3 rf phase (deg)
dEL3     = GeV2MeV*(Ef-EBC2)   ;%total L3 energy gain (MeV)
PhiL3    = L3phase/360         ;%radians/2pi
gfac3    = 172*P25*DLWL10+3*P50*DLWL10+2*P25*DLWL7;
gradL3   = dEL3/(gfac3*cos(PhiL3*TWOPI));
%VALUE, gradL0a,gradL0b,gradL1,gradL2,gradL3
% ------------------------------------------------------------------------------
% linac layout
% ------------------------------------------------------------------------------
LDAQ1  = 0.0342;
LDAQ2  = 0.027;
LDAQ3  = 0.3533;
LDAQ4  = 2.5527;
LDAA7  = DLWL10-DLWL7;
LDAA9  = DLWL10-DLWL9;
DAQ1={'dr' '' LDAQ1 []}';
DAQ2={'dr' '' LDAQ2 []}';
DAQ3={'dr' '' LDAQ3 []}';
DAQ4={'dr' '' LDAQ4 []}';
DAA7={'dr' '' LDAA7 []}';
DAA9={'dr' '' LDAA9 []}';
D10={'dr' '' DLWL10 []}';
D9={'dr' '' DLWL9 []}';
% ------------------------------------------------------------------------------
% magnets
% ------------------------------------------------------------------------------
% SBEN: LB* is Z-length (m); GB* is full gap height (m)
LBh = 0.1244   ;%5D3.9
GBh = 30E-3;
LBS = 0.5435   ;%measured effective length
GBS = 34E-3;
LB0 = 0.2032   ;%5D7.1
GB0 = 30E-3;
LB1 = 0.2032   ;%5D7.1
GB1 = 43.28E-3;
LB2 = 0.5490   ;%1D19.7
GB2 = 33.35E-3;
% QUAD: LQ* is effective length (m); rQ* is pole-tip radius (m)
DQG = 0.076          ;%was once the QG quadrupole (now a drift)
LQx = 0.108          ;%Everson-Tesla (ET) quadrupole 1.259Q3.5
rQx = 0.016;
LQE = 0.1068         ;%QE quadrupole
rQE = (1.085*in2m)/2;
LQc = 0.108          ;%Everson-Tesla big-bore (ETB) quadrupole [GLmax=2.5 kG]
rQc = 0.03;
LQs = 0.16           ;%Bertsche skew quadrupole
rQs = 0.06;
LQF = 0.46092        ;%FFTB 0.91Q17.72 quadrupole
rQF = 0.023/2;
LQH = 0.316          ;%Q150kG quadrupole
rQH = 0.016;
LQM = 0.1244         ;%PEPII injection 2Q4 quadrupole
rQM = 0.025;
LQu = 0.12           ;%undulator quadrupole
LQD = 0.55           ;%FFTB dump quad (3.25Q20)
rQD = (3.25*in2m)/2;
% --------------------------------------------------------------------------------------------
% initial Twiss at L0a_exit (64 MeV)
% NOTE: if you change these values, use MGUN fit routine to determine consistent
%       Twiss at the cathode (TWSSC ... see below)
% --------------------------------------------------------------------------------------------
% CASE #1: LCLS-I beta's at L0a-exit - 64 MeV - from Cecile's 19 MV/m L0a and
%          24 MV/m L0b (Oct. 6, 2003)
%BX0 := 17.143
%AX0 := -3.280
%BY0 := 17.074
%AY0 := -3.263
% CASE #2: LCLS-I beta's at L0a-exit - 64 MeV - back-tracked from matched OTR2
%          through post Aug. 11, 2008 QA01-QE04 real BDES
%BX0 := 1.405
%AX0 := -2.598
%BY0 := 6.669
%AY0 := 0.500
% CASE #3: Feng Zhou input beam at L0a-exit - 64 MeV
%          ('LCLSii_250pC_600um_11JAN11_FZ.sdds')
%BX0 := 24.3904
%AX0 := -5.8283
%BY0 := 24.1953
%AY0 := -5.7789
% CASE #4: from the LCLS-I control system on Feb. 13, 2011
%          ('LCLSii_250pC_600um_11JAN11_FZ.sdds')
BX0 = 7.084;
AX0 = -2.332;
BY0 = 5.457;
AY0 = -1.807;

% ----------------------------------------------------------------------------------
% initial Twiss at cathode (6 MeV)
% NOTE: if you change these values, use TWISS command to determine the proper
%       Twiss at L0a_exit (TWSS0 ... see above)
% ----------------------------------------------------------------------------------
% CASE #1: consistent with CASE #1 TWSS0 above
%BXC := 3.829585540902
%AXC := 3.527654136168
%BYC := 3.809745516673
%AYC := 3.511314970917
% CASE #2: consistent with CASE #2 TWSS0 above
%BXC := 15.474625065749
%AXC := -3.059650434356  
%BYC := 0.393377784891   
%AYC := 0.696754619399E-2
% CASE #3: consistent with CASE #3 TWSS0 above
%BXC := 7.205869285191
%AXC := 5.522522357939
%BYC := 7.145116745074
%AYC := 5.476733946793
% CASE #4: consistent with CASE #4 TWSS0 above
BXC = 3.661161685118;
AXC = 1.645438867265;
BYC = 3.031222969461;
AYC = 1.195981434528;

% ------------------------------------------------------------------------------
% matching
% ------------------------------------------------------------------------------
BX1m = 47.80188576701  ;%BC1->L2 (@BPM11801)
AX1m = 0.06519394427;
BY1m = 21.806334869637;
AY1m = -0.032135473825;
BX2m = 5.0            ;%L2->BC2 (@BX24Bb)
AX2m = -0.5;
BY2m = 8.018730403021 ;%L2->BC2 (@BC2beg)
AY2m = 1.055983483166;
BX3m = 36.644637370628    ;%BC2->L3 (@BPM15701)
AX3m = -0.236638143848E-3;
BY3m = 62.104139793278;
AY3m = 0.102757078493E-3;
BX4m = 49.456167220818 ;%start of LTU horizontal bend system
AX4m = 3.260460969378;
BY4m = 96.058552372136;
AY4m = 3.701877245272;
BX5m = 46.225914318019 ;%start of LTU emittance diagnostic system
AX5m = -1.084608326468;
BY5m = 46.225914318019;
AY5m = 1.084608326468;
% ==============================================================================
% LCAV
% ==============================================================================
% ------------------------------------------------------------------------------
% L0
% ------------------------------------------------------------------------------
L0AB__1={'lc' 'L0AB' 0.0586460 [SbandF gradL0a*0.0586460 PhiL0*TWOPI]}';
L0AB__2={'lc' 'L0AB' 0.1993540 [SbandF gradL0a*0.1993540 PhiL0*TWOPI]}';
L0AB__3={'lc' 'L0AB' 0.6493198 [SbandF gradL0a*0.6493198 PhiL0*TWOPI]}';
L0AB__4={'lc' 'L0AB' 0.6403022 [SbandF gradL0a*0.6403022 PhiL0*TWOPI]}';
L0AB__5={'lc' 'L0AB' 1.1518464 [SbandF gradL0a*1.1518464 PhiL0*TWOPI]}';
L0AB__6={'lc' 'L0AB' 0.3348566 [SbandF gradL0a*0.3348566 PhiL0*TWOPI]}';
L0AB__7={'lc' 'L0AB' 0.0609190 [SbandF gradL0a*0.0609190 PhiL0*TWOPI]}';
L0BB__1={'lc' 'L0BB' 0.0586460 [SbandF gradL0b*0.0586460 PhiL0*TWOPI]}';
L0BB__2={'lc' 'L0BB' 0.3371281 [SbandF gradL0b*0.3371281 PhiL0*TWOPI]}';
L0BB__3={'lc' 'L0BB' 1.1518479 [SbandF gradL0b*1.1518479 PhiL0*TWOPI]}';
L0BB__4={'lc' 'L0BB' 1.1515630 [SbandF gradL0b*1.1515630 PhiL0*TWOPI]}';
L0BB__5={'lc' 'L0BB' 0.3351400 [SbandF gradL0b*0.3351400 PhiL0*TWOPI]}';
L0BB__6={'lc' 'L0BB' 0.0609190 [SbandF gradL0b*0.0609190 PhiL0*TWOPI]}';
% ------------------------------------------------------------------------------
% L1X
% ------------------------------------------------------------------------------
L1XB__1={'lc' 'L1XB' DLWLX/2 [XbandF dEL1X/2 PhiL1X*TWOPI]}';
L1XB__2={'lc' 'L1XB' DLWLX/2 [XbandF dEL1X/2 PhiL1X*TWOPI]}';
% ------------------------------------------------------------------------------
% transverse deflecting structures
% ------------------------------------------------------------------------------
%  TCAV0B : LCAV, TYPE="TRANS_DEFL", L=0.6680236/2 
TCAV0B={'dr' '' 0.6680236/2 []}';%flange-to-flange/2
% ==============================================================================
% SBEN
% ==============================================================================
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
% - DXG0  = drift, w/BXGB off, from BXGB entrance face to its z-projected
%           center
% - DXGBa = 1st-half of bend (set to ~zero length and strength, with
%           longitudinal position as bend's center)
% - DXGBb = 2nd-half of bend (set to ~zero length and strength, with
%           longitudinal position as bend's center)
% ------------------------------------------------------------------------------
RBXG = 0.1963       ;%BXGB bend radius (measured) [m]
ABXG = 85.0*RADDEG  ;%BXGB bend angle [rad]
EBXG = 24.25*RADDEG ;%BXGB pole-face rotation angle [rad]
GBXG = 0.043        ;%BXGB full gap height [m]
LBXG = RBXG*ABXG    ;%BXGB effective length [m]
BXGBa={'be' 'BXGB' LBXG/2 [ABXG/2 GBXG/2 EBXG 0 0.492 0 0]}';
BXGBb={'be' 'BXGB' LBXG/2 [ABXG/2 GBXG/2 0 EBXG 0 0.492 0]}';
DXG0={'dr' '' RBXG*sin(ABXG/2) []}';
DXGBa={'be' 'DXGB' 1E-9/2 [0/2 0 0 0 0 0 0]}';
DXGBb={'be' 'DXGB' 1E-9/2 [0/2 0 0 0 0 0 0]}';
% ------------------------------------------------------------------------------
% laser heater
% ------------------------------------------------------------------------------
Brhoh = Cb*Ei              ;%beam rigidity at heater (kG-m)
BBh1  = -4.751481741801    ;%heater-chicane bend field for 35-mm etaX_pk (kG)
RBh1  = Brhoh/BBh1         ;%heater-chicane bend radius (m)
ABh1  = asin(LBh/RBh1)     ;%heater-chicane bend angle (rad)
ABh1S = asin((LBh/2)/RBh1) ;%"short" half heater-chicane bend angle (rad)
LBh1S = RBh1*ABh1S         ;%"short" half heater-chicane bend path length (m)
ABh1L = ABh1-ABh1S         ;%"long" half heater-chicane bend angle (rad)
LBh1L = RBh1*ABh1L         ;%"long" half heater-chicane bend path length (m)
BXh1Ba={'be' 'BXh1B' LBh1S [+ABh1S GBh/2 0 0 0.400 0 0]}';
BXh1Bb={'be' 'BXh1B' LBh1L [+ABh1L GBh/2 0 +ABh1 0 0.400 0]}';
BXh2Ba={'be' 'BXh2B' LBh1L [-ABh1L GBh/2 -ABh1 0 0.400 0 0]}';
BXh2Bb={'be' 'BXh2B' LBh1S [-ABh1S GBh/2 0 0 0 0.400 0]}';
BXh3Ba={'be' 'BXh3B' LBh1S [-ABh1S GBh/2 0 0 0.400 0 0]}';
BXh3Bb={'be' 'BXh3B' LBh1L [-ABh1L GBh/2 0 -ABh1 0 0.400 0]}';
BXh4Ba={'be' 'BXh4B' LBh1L [+ABh1L GBh/2 +ABh1 0 0.400 0 0]}';
BXh4Bb={'be' 'BXh4B' LBh1S [+ABh1S GBh/2 0 0 0 0.400 0]}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
ABS   = -35.0*RADDEG;
BXSEj = -7.29*RADDEG;
BXSBa={'be' 'BXSB' LBS/2 [ABS/2 GBS/2 BXSEj 0 0.391 0 0]}';
BXSBb={'be' 'BXSB' LBS/2 [ABS/2 GBS/2 0 BXSEj 0 0.391 0]}';
% ------------------------------------------------------------------------------
% linac injection
% ------------------------------------------------------------------------------
% - DX01Ba = 1st half of BX01 magnet switched off
% - DX01Bb = 2nd half of BX01 magnet switched off
% ------------------------------------------------------------------------------
ADL1   = -35.0*RADDEG           ;%injection line angle (rad)
AB0    = ADL1/2                 ;%full bend angle (rad)
LeffB0 = LB0*AB0/(2*sin(AB0/2)) ;%full bend path length (m)
AEB0   = AB0/2                  ;%edge angles
BX01Ba={'be' 'BX01B' LeffB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX01Bb={'be' 'BX01B' LeffB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
BX02Ba={'be' 'BX02B' LeffB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX02Bb={'be' 'BX02B' LeffB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
DX01Ba={'be' 'DX01B' LB0/2 [1E-9 0 0 0 0 0 0]}';
DX01Bb={'be' 'DX01B' LB0/2 [1E-9 0 0 0 0 0 0]}';
% ------------------------------------------------------------------------------
% BC1
% - BX11 gets an offset of 2.2 mm (theta*L/8) towards the wall
% - BX12 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% - BX13 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% - BX14 gets an offset of 2.2 mm (theta*L/8) towards the wall
% ------------------------------------------------------------------------------
Brho1 = Cb*EBC1            ;%beam rigidity at BC1 (kG-m)
BB11  = -3.855716427851    ;%chicane-1 bend field (kG) [R56=0.046]
RB11  = Brho1/BB11         ;%chicane-1 bend radius (m)
AB11  = asin(LB1/RB11)     ;%full chicane bend angle (rad)
AB11S = asin((LB1/2)/RB11) ;%"short" half chicane bend angle (rad)
LB11S = RB11*AB11S         ;%"short" half chicane bend path length (m)
AB11L = AB11-AB11S         ;%"long" half chicane bend angle (rad)
LB11L = RB11*AB11L         ;%"long" half chicane bend path length (m)
BX11Ba={'be' 'BX11B' LB11S [+AB11S GB1/2 0 0 0.387 0 0]}';
BX11Bb={'be' 'BX11B' LB11L [+AB11L GB1/2 0 +AB11 0 0.387 0]}';
BX12Ba={'be' 'BX12B' LB11L [-AB11L GB1/2 -AB11 0 0.387 0 0]}';
BX12Bb={'be' 'BX12B' LB11S [-AB11S GB1/2 0 0 0 0.387 0]}';
BX13Ba={'be' 'BX13B' LB11S [-AB11S GB1/2 0 0 0.387 0 0]}';
BX13Bb={'be' 'BX13B' LB11L [-AB11L GB1/2 0 -AB11 0 0.387 0]}';
BX14Ba={'be' 'BX14B' LB11L [+AB11L GB1/2 +AB11 0 0.387 0 0]}';
BX14Bb={'be' 'BX14B' LB11S [+AB11S GB1/2 0 0 0 0.387 0]}';
% ------------------------------------------------------------------------------
% BC2
% - BX21 gets an offset of ~2.3 mm (theta*L/8) towards the wall
% - BX22 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% - BX23 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% - BX24 gets an offset of ~2.3 mm (theta*L/8) towards the wall
% ------------------------------------------------------------------------------
Brho2 = Cb*EBC2            ;%beam rigidity at BC2 (kG-m)
BB21  = -9.598998975907    ;%chicane bend field (kG) [R56=0.029]
RB21  = Brho2/BB21         ;%chicane bend radius (m)
AB21  = asin(LB2/RB21)     ;%full chicane bend angle (rad)
AB21S = asin((LB2/2)/RB21) ;%"short" half chicane bend angle (rad)
LB21S = RB21*AB21S         ;%"short" half chicane bend path length (m)
AB21L = AB21-AB21S         ;%"long" half chicane bend angle (rad)
LB21L = RB21*AB21L         ;%"long" half chicane bend path length (m)
BX21Ba={'be' 'BX21B' LB21S [+AB21S GB2/2 0 0 0.633 0 0]}';
BX21Bb={'be' 'BX21B' LB21L [+AB21L GB2/2 0 +AB21 0 0.633 0]}';
BX22Ba={'be' 'BX22B' LB21L [-AB21L GB2/2 -AB21 0 0.633 0 0]}';
BX22Bb={'be' 'BX22B' LB21S [-AB21S GB2/2 0 0 0 0.633 0]}';
BX23Ba={'be' 'BX23B' LB21S [-AB21S GB2/2 0 0 0.633 0 0]}';
BX23Bb={'be' 'BX23B' LB21L [-AB21L GB2/2 0 -AB21 0 0.633 0]}';
BX24Ba={'be' 'BX24B' LB21L [+AB21L GB2/2 +AB21 0 0.633 0 0]}';
BX24Bb={'be' 'BX24B' LB21S [+AB21S GB2/2 0 0 0 0.633 0]}';
% ------------------------------------------------------------------------------
% sector 20 vertical dogleg to bypass line
% ------------------------------------------------------------------------------
% - XOFF  = x-offset of bypass line (old PEP-II 9-GeV) w.r.t. linac axis
%           (<0 is south)
% - YOFF  = y-offset of bypass line (old PEP-II 9-GeV) w.r.t. linac axis
%           (>0 is up)
% - ROLLA = roll angle of sec-20 bends to get XOFF and YOFF bypass offsets
% ------------------------------------------------------------------------------
LB    = 1.000             ;%effective length [m]
ANGA  = 0.0117327534      ;%only sets bend field & dog-leg length
XOFF  = -25.610*in2m;
YOFF  =  25.570*in2m;
ROLLA = atan2(-YOFF,-XOFF);
BRB1a={'be' 'BRB1' LB/2 [ANGA/2 0 ANGA/2 0 0.5 0 ROLLA]}';
BRB1b={'be' 'BRB1' LB/2 [ANGA/2 0 0 ANGA/2 0 0.5 ROLLA]}';
BRB2a={'be' 'BRB2' LB/2 [-ANGA/2 0 -ANGA/2 0 0.5 0 ROLLA]}';
BRB2b={'be' 'BRB2' LB/2 [-ANGA/2 0 0 -ANGA/2 0 0.5 ROLLA]}';
% ------------------------------------------------------------------------------
% vertical bend system
% ------------------------------------------------------------------------------
% - S100_PITCH  = pitch-down angle of linac at Station 100 (0.27272791 deg)
% - S100_HEIGHT = Station 100 height above local sea level
%                 (from Catherine LeCocq, Jan. 22, 2004)
% - Z_S100_UNDH = undulator center is defined as 583 m from Station 100
%                 measured along undulator Z-axis (~1/2 und)
% - R_Earth     = total radius of earth (gaussian sphere)
%                 (from Catherine LeCocq, Jan. 2004)
% - AVB         = bend UP twice this angle to make e- beam level at center of
%                 undulator (including 30 m extension)
% ------------------------------------------------------------------------------
S100B={'mo' '' 0 []}';% Station-100B is same Z as Station-100, but off axis in X & Y
LVB0        = 1.025         ;%3D39 vertical bend effective length (m)
GVB         = 0.034925      ;%vertical bend gap width (m)
S100_PITCH  = -4.760000E-3  ;%rad
S100_HEIGHT = 77.643680     ;%m
Z_S100_UNDH = 583.000000    ;%m
R_Earth     = 6.372508025E6 ;%m
AVB         = (S100_PITCH+asin(Z_S100_UNDH/(R_Earth+S100_HEIGHT)))/2  ;%bend up twice this angle so e- is level in ~cnt. of und.
BY3a={'be' 'BY3' LVB0/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY3b={'be' 'BY3' LVB0/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
BY4a={'be' 'BY4' LVB0/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY4b={'be' 'BY4' LVB0/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
% ------------------------------------------------------------------------------
% horizontal bend system
% ------------------------------------------------------------------------------
AB4P   = 0.6*RADDEG               ;%bend angle of each FFTB dipole (rad)
LB4    = 2.623                    ;%4D102.36T effective length (m)
GB4    = 0.023                    ;%4D102.36T gap height (m)
LeffB4 = LB4*AB4P/(2*sin(AB4P/2)) ;%full bend effective path length (m)
BX41a={'be' 'BX41' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX41b={'be' 'BX41' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
BX42a={'be' 'BX42' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX42b={'be' 'BX42' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
BX43a={'be' 'BX43' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX43b={'be' 'BX43' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
BX44a={'be' 'BX44' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX44b={'be' 'BX44' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
DX51a={'be' 'DX51' LB4/2 [1E-12 0 0 0 0 0 0]}';
DX51b={'be' 'DX51' LB4/2 [1E-12 0 0 0 0 0 0]}';
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
LBdm   = 1.452          ;%effective length [m] (from J. Tanabe)
GBdm   = 0.043          ;%full gap [m]
ABdm0  = (5.0*RADDEG)/3;
LeffBdm = LBdm*ABdm0/(2*sin(ABdm0/2)) ;%full bend path length (m)
BYD1Ha={'be' 'BYD1H' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD1Hb={'be' 'BYD1H' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
BYD2Ha={'be' 'BYD2H' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD2Hb={'be' 'BYD2H' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
BYD3Ha={'be' 'BYD3H' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD3Hb={'be' 'BYD3H' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
% ------------------------------------------------------------------------------
% HXR safety dump line
% ------------------------------------------------------------------------------
% permanent magnets
LBpm  = 0.944             ;%effective length [m]
GBpm0 = 0.0381            ;%original gap height (FFTB 2005) [m]
Bpm0  = 4.3               ;%original magnetic field [kG]
GBpm  = 0.052             ;%modified gap height [m]
Bpm   = Bpm0*(GBpm0/GBpm) ;%modified magnetic field after opening gaps [kG]
Brhox = Cb*Ef             ;%beam rigidity [kG-m]
ABpm  = LBpm*Bpm/Brhox;
BXPM1Ha={'be' 'BXPM1H' LBpm/2 [ABpm/2 GBpm/2 0 0 0.5 0 0]}';
BXPM1Hb={'be' 'BXPM1H' LBpm/2 [ABpm/2 GBpm/2 0 1*ABpm 0 0.5 0]}';
BXPM2Ha={'be' 'BXPM2H' LBpm/2 [ABpm/2 GBpm/2 1*ABpm 0 0.5 0 0]}';
BXPM2Hb={'be' 'BXPM2H' LBpm/2 [ABpm/2 GBpm/2 0 2*ABpm 0 0.5 0]}';
BXPM3Ha={'be' 'BXPM3H' LBpm/2 [ABpm/2 GBpm/2 2*ABpm 0 0.5 0 0]}';
BXPM3Hb={'be' 'BXPM3H' LBpm/2 [ABpm/2 GBpm/2 0 3*ABpm 0 0.5 0]}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system
% ------------------------------------------------------------------------------
BX51a={'be' 'BX51' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX51b={'be' 'BX51' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
BX52a={'be' 'BX52' LeffB4/2 [AB4P/2 GB4/2 AB4P/2 0 0.5 0 0]}';
BX52b={'be' 'BX52' LeffB4/2 [AB4P/2 GB4/2 0 AB4P/2 0 0.5 0]}';
BX53a={'be' 'BX53' LeffB4/2 [-AB4P/2 GB4/2 -AB4P/2 0 0.5 0 0]}';
BX53b={'be' 'BX53' LeffB4/2 [-AB4P/2 GB4/2 0 -AB4P/2 0 0.5 0]}';
BX54a={'be' 'BX54' LeffB4/2 [-AB4P/2 GB4/2 -AB4P/2 0 0.5 0 0]}';
BX54b={'be' 'BX54' LeffB4/2 [-AB4P/2 GB4/2 0 -AB4P/2 0 0.5 0]}';
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
BYD1Sa={'be' 'BYD1S' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD1Sb={'be' 'BYD1S' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
BYD2Sa={'be' 'BYD2S' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD2Sb={'be' 'BYD2S' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
BYD3Sa={'be' 'BYD3S' LeffBdm/2 [ABdm0/2 GBdm/2 ABdm0/2 0 0.57 0 pi/2]}';
BYD3Sb={'be' 'BYD3S' LeffBdm/2 [ABdm0/2 GBdm/2 0 ABdm0/2 0 0.57 pi/2]}';
% ------------------------------------------------------------------------------
% SXR safety dump line
% ------------------------------------------------------------------------------
% permanent magnets
BXPM1Sa={'be' 'BXPM1S' LBpm/2 [ABpm/2 GBpm/2 0 0 0.5 0 0]}';
BXPM1Sb={'be' 'BXPM1S' LBpm/2 [ABpm/2 GBpm/2 0 1*ABpm 0 0.5 0]}';
BXPM2Sa={'be' 'BXPM2S' LBpm/2 [ABpm/2 GBpm/2 1*ABpm 0 0.5 0 0]}';
BXPM2Sb={'be' 'BXPM2S' LBpm/2 [ABpm/2 GBpm/2 0 2*ABpm 0 0.5 0]}';
BXPM3Sa={'be' 'BXPM3S' LBpm/2 [ABpm/2 GBpm/2 2*ABpm 0 0.5 0 0]}';
BXPM3Sb={'be' 'BXPM3S' LBpm/2 [ABpm/2 GBpm/2 0 3*ABpm 0 0.5 0]}';
% ==============================================================================
% QUAD
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
% CQ01B = correction quad in 1st solenoid at gun (nominally set to 0) (set to
%         ~zero length, with longitudinal position as the actual quad's center)
% SQ01B = correction skew-quad in 1st solenoid at gun (nominally set to 0) (set
%         to ~zero length, with longitudinal position as the actual quad's
%         center)
% ------------------------------------------------------------------------------
CQ01B={'qu' 'CQ01B' 1E-9/2 0}';
SQ01B={'qu' 'SQ01B' 1E-9/2 0}';
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
DG02B={'dr' '' DQG/2 []}';
DG03B={'dr' '' DQG/2 []}';
% ------------------------------------------------------------------------------
% injector
% - new design with laser-heater chicane and undulator ON
% ------------------------------------------------------------------------------
%KQA01 := -7.42426012281      
%KQA02 := 8.140080403872     
%KQE01 := 0.068922791711   
%KQE02 := -4.759986828314   
%KQE03 := 12.709357642005    
%KQE04 := -17.390556954907 
%KQA01 := -6.656104660774     
%KQA02 := 11.545017585069  
%KQE01 :=  1.631132175559   
%KQE02 := -4.484666429796  
%KQE03 := 13.083748027495  
%KQE04 :=-17.854095234787 
% CASE #4: Heater undulator ON & heater chicane ON (LCLS-I beam at L0a-exit)
KQA01 = -11.05938242283  ;%-11.0664 
KQA02 =  13.425478754905 ;% 13.4288     
KQE01 =  -7.437610576386 ;%-7.4287   
KQE02 =   9.726225590027 ;% 9.7156   
KQE03 =   7.636806929443 ;% 7.6523    
KQE04 =  -6.773218372814 ;%-6.7996
KQM01 =  15.072053882204;
KQM02 = -11.974604636345;
KQB   =  22.169701529353;
KQM03 =  -8.255421303054;
KQM04 =  13.306105246908;
QA01B={'qu' 'QA01B' LQx/2 KQA01}';
QA02B={'qu' 'QA02B' LQx/2 KQA02}';
QE01B={'qu' 'QE01B' LQx/2 KQE01}';
QE02B={'qu' 'QE02B' LQx/2 KQE02}';
QE03B={'qu' 'QE03B' LQx/2 KQE03}';
QE04B={'qu' 'QE04B' LQx/2 KQE04}';
QM01B={'qu' 'QM01B' LQx/2 KQM01}';
QM02B={'qu' 'QM02B' LQx/2 KQM02}';
QBB={'qu' 'QBB' LQE/2 KQB}';
QM03B={'qu' 'QM03B' LQx/2 KQM03}';
QM04B={'qu' 'QM04B' LQx/2 KQM04}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
KQS01 =  9.682244191676;
KQS02 = -5.648980372134;
QS01B={'qu' 'QS01B' LQx/2 KQS01}';
QS02B={'qu' 'QS02B' LQx/2 KQS02}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
KQ11201 = -9.373008884788;
KQM11   =  7.96302075362;
KQM12   = -8.30213876316;
KQM13   =  9.836883761893;
KCQ11   =  0;
KSQ13   =  0;
KCQ12   =  0;
KQ11301 = -0.1347         ;%measured remnant field Gdl=0.12 kG
KQM14   =  6.927725106482 ;%matched to 45 degree L2 FODO
KQM15   = -6.628368582818 ;%matched to 45 degree L2 FODO
Q11201={'qu' 'Q11201' LQE/2 KQ11201}';
QM11B={'qu' 'QM11B' LQx/2 KQM11}';
CQ11B={'qu' 'CQ11B' LQc/2 KCQ11}';
SQ13B={'qu' 'SQ13B' LQs/2 KSQ13}';
CQ12B={'qu' 'CQ12B' LQc/2 KCQ12}';
QM12B={'qu' 'QM12B' LQx/2 KQM12}';
QM13B={'qu' 'QM13B' LQx/2 KQM13}';
Q11301={'qu' 'Q11301' LQE/2 KQ11301}';
QM14B={'qu' 'QM14B' LQx/2 KQM14}';
QM15B={'qu' 'QM15B' LQx/2 KQM15}';
% ------------------------------------------------------------------------------
% BC2
% ------------------------------------------------------------------------------
KQ14501 = -1.1105048995   ;%matched from 45 degree L2 FODO
KQM21   =  0.469442245185 ;%matched from 45 degree L2 FODO
KCQ21   =  0;
KCQ22   =  0;
KQM22   = -0.579053555861 ;%matched to 30 degree L3 FODO
KQ14701 =  1.035659667529 ;%matched to 30 degree L3 FODO
Q14501a={'qu' 'Q14501a' LQE/2 KQ14501}';
Q14501b={'qu' 'Q14501b' LQE/2 KQ14501}';
QM21B={'qu' 'QM21B' LQF/2 KQM21}';
CQ21B={'qu' 'CQ21B' LQc/2 KCQ21}';
CQ22B={'qu' 'CQ22B' LQc/2 KCQ22}';
QM22B={'qu' 'QM22B' LQF/2 KQM22}';
Q14701a={'qu' 'Q14701a' LQE/2 KQ14701}';
Q14701b={'qu' 'Q14701b' LQE/2 KQ14701}';
% ------------------------------------------------------------------------------
% sector 20 vertical dogleg to bypass line
% ------------------------------------------------------------------------------
KQA = 0.461972124142;
QFA={'qu' 'QFA' LQH/2 KQA}';
QDA={'qu' 'QDA' LQH/2 -KQA}';
QBD1={'qu' 'QBD1' LQH/2 KQA}';
QBD2={'qu' 'QBD2' LQH/2 -KQA}';
QBD3={'qu' 'QBD3' LQH/2 KQA}';
QBD4={'qu' 'QBD4' LQH/2 -KQA}';
QBD5={'qu' 'QBD5' LQH/2 KQA}';
QBD6={'qu' 'QBD6' LQH/2 -KQA}';
QBD7={'qu' 'QBD7' LQH/2 KQA}';
QBD8={'qu' 'QBD8' LQH/2 -KQA}';
% ------------------------------------------------------------------------------
% bypass line
% ------------------------------------------------------------------------------
KQY = 0.060580505638 ;%45 degree bypass FODO
QFY={'qu' 'QFY' LQM/2 KQY}';%dummy magnet
QDY={'qu' 'QDY' LQM/2 -KQY}';%dummy magnet
KQL1P  =  0.329520365406;
KQL2P  = -0.184408480048;
KQL3P  =  0.11923165597;
KQL4P  = -0.117922442799;
KQBP31 =  0.086959848908  ;
KQBP32 = -0.141489785429;
KQBP33 =  0.199743671076  ;
KQBP34 = -0.063410125832;
QL1P={'qu' 'QL1P' LQH/2 KQL1P}';
QL2P={'qu' 'QL2P' LQH/2 KQL2P}';
QL3P={'qu' 'QL3P' LQH/2 KQL3P}';
QL4P={'qu' 'QL4P' LQM/2 KQL4P}';
QBP23={'qu' 'QBP23' LQM/2 KQY}';
QBP24={'qu' 'QBP24' LQM/2 -KQY}';
QBP25={'qu' 'QBP25' LQM/2 KQY}';
QBP26={'qu' 'QBP26' LQM/2 -KQY}';
QBP27={'qu' 'QBP27' LQM/2 KQY}';
QBP28={'qu' 'QBP28' LQM/2 -KQY}';
QBP29={'qu' 'QBP29' LQM/2 KQY}';
QBP30={'qu' 'QBP30' LQM/2 -KQY}';
QBP31={'qu' 'QBP31' LQM/2 KQBP31}';
QBP32={'qu' 'QBP32' LQM/2 KQBP32}';
QBP33={'qu' 'QBP33' LQM/2 KQBP33}';
QBP34={'qu' 'QBP34' LQM/2 KQBP34}';
% ------------------------------------------------------------------------------
% vertical and horizontal bend systems
% ------------------------------------------------------------------------------
BPMVB4={'mo' 'BPMVB4' 0 []}';% 2/22/11
BPMVB5={'mo' 'BPMVB5' 0 []}';% 2/22/11
BPMVB6={'mo' 'BPMVB6' 0 []}';% 2/22/11
BPMH1={'mo' 'BPMH1' 0 []}';% 2/22/11
BPMH2={'mo' 'BPMH2' 0 []}';% 2/22/11
BPMH3={'mo' 'BPMH3' 0 []}';% 2/22/11
BPMH4={'mo' 'BPMH4' 0 []}';% 2/22/11
BPMDL41={'mo' 'BPMDL41' 0 []}';% 2/22/11
BPMDL42={'mo' 'BPMDL42' 0 []}';% 2/22/11
BPMDL43={'mo' 'BPMDL43' 0 []}';% 2/22/11
BPMT42B={'mo' 'BPMT42B' 0 []}';% 2/22/11
BPMT45={'mo' 'BPMT45' 0 []}';% 2/22/11
BPMT48={'mo' 'BPMT48' 0 []}';% 2/22/11
XCVB5={'mo' 'XCVB5' 0 []}';% 2/22/11
XCHM2={'mo' 'XCHM2' 0 []}';% 2/22/11
XCHM3={'mo' 'XCHM3' 0 []}';% 2/22/11
XCDL41={'mo' 'XCDL41' 0 []}';% 2/22/11
XCDL42={'mo' 'XCDL42' 0 []}';% 2/22/11
XCDL43={'mo' 'XCDL43' 0 []}';% 2/22/11
XCT42={'mo' 'XCT42' 0 []}';% 2/22/11
XCT45={'mo' 'XCT45' 0 []}';% 2/22/11
XCT48={'mo' 'XCT48' 0 []}';% 2/22/11
YCVB4={'mo' 'YCVB4' 0 []}';% 2/22/11
YCVB6={'mo' 'YCVB6' 0 []}';% 2/22/11
YCHM1={'mo' 'YCHM1' 0 []}';% 2/22/11
YCHM4={'mo' 'YCHM4' 0 []}';% 2/22/11
YCDL41={'mo' 'YCDL41' 0 []}';% 2/22/11
YCDL42={'mo' 'YCDL42' 0 []}';% 2/22/11
YCDL43={'mo' 'YCDL43' 0 []}';% 2/22/11
YCT42={'mo' 'YCT42' 0 []}';% 2/22/11
YCT45={'mo' 'YCT45' 0 []}';% 2/22/11
YCT48={'mo' 'YCT48' 0 []}';% 2/22/11
XC={'mo' 'XC' 0 []}';% 2/22/11
YC={'mo' 'YC' 0 []}';% 2/22/11
KQVB  = -0.611046737843;
KQHM1 = -0.835144344169;
KQHM2 =  0.691689926046  ;
KQHM3 =  0.736567149774  ;
KQHM4 = -0.822960507567;
KQDL  =  0.456208400107;
KQT1  = -0.421722526382;
KQT2  =  0.837685882457;
KQT3  = -0.426422452621;
KQT4  =  0.849586112545;
QVB4={'qu' 'QVB4' LQH/2 KQVB}';
QVB5={'qu' 'QVB5' LQH/2 -KQVB}';
QVB6={'qu' 'QVB6' LQH/2 KQVB}';
QHM1={'qu' 'QHM1' LQH/2 KQHM1}';
QHM2={'qu' 'QHM2' LQH/2 KQHM2}';
QHM3={'qu' 'QHM3' LQH/2 KQHM3}';
QHM4={'qu' 'QHM4' LQH/2 KQHM4}';
QDL41={'qu' 'QDL41' LQH/2 KQDL}';
QT41B={'qu' 'QT41B' LQF/2 KQT1}';
QT42B={'qu' 'QT42B' LQF/2 KQT2}';
QT43B={'qu' 'QT43B' LQF/2 KQT1}';
QDL42={'qu' 'QDL42' LQH/2 KQDL}';
QT44={'qu' 'QT44' LQF/2 KQT3}';
QT45={'qu' 'QT45' LQF/2 KQT4}';
QT46={'qu' 'QT46' LQF/2 KQT3}';
QDL43={'qu' 'QDL43' LQH/2 KQDL}';
QT47={'qu' 'QT47' LQF/2 KQT3}';
QT48={'qu' 'QT48' LQF/2 KQT4}';
QT49={'qu' 'QT49' LQF/2 KQT3}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
KQEM1H = -0.314700091244;
KQEM2H =  0.187405674006 ;
KQEM3H = -0.540863834687;
KQEM4H =  0.210367223739 ;
KQED2 =  0.402753197988  ;%set to zero for slice-emit on OTR43
KQUM1H =  0.108265422627 ;
KQUM2H = -0.085008248589;
KQUM3H =  0.209716443022 ;
KQUM4H = -0.155222541806;
QEM1H={'qu' 'QEM1H' LQH/2 KQEM1H}';
QEM2H={'qu' 'QEM2H' LQH/2 KQEM2H}';
QEM3H={'qu' 'QEM3H' LQH/2 KQEM3H}';
DEM3VH={'dr' '' LQx/2 []}';
QEM4H={'qu' 'QEM4H' LQH/2 KQEM4H}';
QE41={'qu' 'QE41' LQx/2 KQED2}';
QE42={'qu' 'QE42' LQx/2 -KQED2}';
QE43={'qu' 'QE43' LQx/2 KQED2}';
QE44={'qu' 'QE44' LQx/2 -KQED2}';
QE45={'qu' 'QE45' LQx/2 KQED2}';
QE46={'qu' 'QE46' LQx/2 -KQED2}';
QUM1H={'qu' 'QUM1H' LQH/2 KQUM1H}';
QUM2H={'qu' 'QUM2H' LQH/2 KQUM2H}';
QUM3H={'qu' 'QUM3H' LQH/2 KQUM3H}';
QUM4H={'qu' 'QUM4H' LQH/2 KQUM4H}';
% ------------------------------------------------------------------------------
% place holder for hard X-ray self-seeding
% ------------------------------------------------------------------------------
KQHSS05 = -0.544064688424;
KQHSS06 =  0.720787270695;
KQHSS09 = -0.263590020071;
KQHSS12 =  0.329793074286;
QHSS05={'qu' 'QHSS05' LQu/2 KQHSS05}';
QHSS06={'qu' 'QHSS06' LQu/2 KQHSS06}';
QHSS09={'qu' 'QHSS09' LQu/2 KQHSS09}';
QHSS12={'qu' 'QHSS12' LQu/2 KQHSS12}';
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% - gamf   = Lorentz energy factor in undulator
% - IntgHX = integrated quadrupole gradient (nominal: 60 kG, maximum 80 kG)
% - GQFHX  = QF and QD gradients can be made different to compensate for
%            undulator focussing ...
% - GQDHX  = ... but since undulator focussing depends on gamma^2, compensation
%            will only work for one energy
% - kQFHX  = QF undulator quadrupole focusing "k"
% - kQDHX  = QD undulator quadrupole focusing "k"
% ------------------------------------------------------------------------------
gamf   = Ef/mc2;
IntgHX = 23.00                      ;%kG
GQFHX  =  IntgHX/LQu/10*1.00        ;%T/m 
GQDHX  = -IntgHX/LQu/10*0.96        ;%T/m 
kQFHX  = 1E-9*GQFHX*CLIGHT/gamf/mc2 ;%m^-2
kQDHX  = 1E-9*GQDHX*CLIGHT/gamf/mc2 ;%m^-2
% even numbered quads are QF's, odd numbered quads are QD's
QHX01={'qu' 'QHX01' LQu/2 kQDHX}';
QHX02={'qu' 'QHX02' LQu/2 kQFHX}';
QHX03={'qu' 'QHX03' LQu/2 kQDHX}';
QHX04={'qu' 'QHX04' LQu/2 kQFHX}';
QHX05={'qu' 'QHX05' LQu/2 kQDHX}';
QHX06={'qu' 'QHX06' LQu/2 kQFHX}';
QHX07={'qu' 'QHX07' LQu/2 kQDHX}';
QHX08={'qu' 'QHX08' LQu/2 kQFHX}';
QHX09={'qu' 'QHX09' LQu/2 kQDHX}';
QHX10={'qu' 'QHX10' LQu/2 kQFHX}';
QHX11={'qu' 'QHX11' LQu/2 kQDHX}';
QHX12={'qu' 'QHX12' LQu/2 kQFHX}';
QHX13={'qu' 'QHX13' LQu/2 kQDHX}';
QHX14={'qu' 'QHX14' LQu/2 kQFHX}';
QHX15={'qu' 'QHX15' LQu/2 kQDHX}';
QHX16={'qu' 'QHX16' LQu/2 kQFHX}';
QHX17={'qu' 'QHX17' LQu/2 kQDHX}';
QHX18={'qu' 'QHX18' LQu/2 kQFHX}';
QHX19={'qu' 'QHX19' LQu/2 kQDHX}';
QHX20={'qu' 'QHX20' LQu/2 kQFHX}';
QHX21={'qu' 'QHX21' LQu/2 kQDHX}';
QHX22={'qu' 'QHX22' LQu/2 kQFHX}';
QHX23={'qu' 'QHX23' LQu/2 kQDHX}';
QHX24={'qu' 'QHX24' LQu/2 kQFHX}';
QHX25={'qu' 'QHX25' LQu/2 kQDHX}';
QHX26={'qu' 'QHX26' LQu/2 kQFHX}';
QHX27={'qu' 'QHX27' LQu/2 kQDHX}';
QHX28={'qu' 'QHX28' LQu/2 kQFHX}';
QHX29={'qu' 'QHX29' LQu/2 kQDHX}';
QHX30={'qu' 'QHX30' LQu/2 kQFHX}';
QHX31={'qu' 'QHX31' LQu/2 kQDHX}';
QHX32={'qu' 'QHX32' LQu/2 kQFHX}';
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
KQUE1H =  0.043480627706  ;%<beta>=37 m
KQUE2H = -0.040742307816  ;%<beta>=37 m
KQDMPH = -0.119981165240  ;%<beta>=37 m
QUE1H={'qu' 'QUE1H' LQD/2 KQUE1H}';
QUE2H={'qu' 'QUE2H' LQD/2 KQUE2H}';
QDMP1H={'qu' 'QDMP1H' LQD/2 KQDMPH}';
QDMP2H={'qu' 'QDMP2H' LQD/2 KQDMPH}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
BPMT52={'mo' 'BPMT52' 0 []}';% 2/22/11
BPMT55={'mo' 'BPMT55' 0 []}';% 2/22/11
BPMT58={'mo' 'BPMT58' 0 []}';% 2/22/11
XCDL51={'mo' 'XCDL51' 0 []}';% 2/22/11
XCDL52={'mo' 'XCDL52' 0 []}';% 2/22/11
XCDL53={'mo' 'XCDL53' 0 []}';% 2/22/11
XCT52={'mo' 'XCT52' 0 []}';% 2/22/11
XCT55={'mo' 'XCT55' 0 []}';% 2/22/11
XCT58={'mo' 'XCT58' 0 []}';% 2/22/11
YCDL51={'mo' 'YCDL51' 0 []}';% 2/22/11
YCDL52={'mo' 'YCDL52' 0 []}';% 2/22/11
YCDL53={'mo' 'YCDL53' 0 []}';% 2/22/11
YCT52={'mo' 'YCT52' 0 []}';% 2/22/11
YCT55={'mo' 'YCT55' 0 []}';% 2/22/11
YCT58={'mo' 'YCT58' 0 []}';% 2/22/11
KQDLS  =  0.44267687113;
KQT1S  = -0.168942142535;
KQT2S  = -0.060724509758;
KQT3S  =  0.556353227066;
KQT4S  = -0.352020268977;
KQDL0S =  0.0;
KQUM1S =  0.176762637699 ;
KQUM2S = -0.09256564967 ;
KQUM3S =  0.291709526259 ;
KQUM4S = -0.171324016394;
QDL51={'qu' 'QDL51' LQH/2 KQDLS}';
QT51={'qu' 'QT51' LQF/2 KQT1S}';
QT52={'qu' 'QT52' LQF/2 KQT2S}';
QT53={'qu' 'QT53' LQF/2 KQT3S}';
QT53A={'qu' 'QT53A' LQF/2 KQT4S}';
QDL52={'qu' 'QDL52' LQH/2 KQDL0S}';
QT54A={'qu' 'QT54A' LQF/2 KQT4S}';
QT54={'qu' 'QT54' LQF/2 KQT3S}';
QT55={'qu' 'QT55' LQF/2 KQT2S}';
QT56={'qu' 'QT56' LQF/2 KQT1S}';
QDL53={'qu' 'QDL53' LQH/2 KQDLS}';
QT57={'qu' 'QT57' LQF/2 KQT1}';
QT58={'qu' 'QT58' LQF/2 KQT2}';
QT59={'qu' 'QT59' LQF/2 KQT1}';
QUM1S={'qu' 'QUM1S' LQH/2 KQUM1S}';
QUM2S={'qu' 'QUM2S' LQH/2 KQUM2S}';
QUM3S={'qu' 'QUM3S' LQH/2 KQUM3S}';
QUM4S={'qu' 'QUM4S' LQH/2 KQUM4S}';
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
KQUE1S =  0.155723014542 ;%<beta>=19 m
KQUE2S = -0.112254958343 ;%<beta>=19 m
KQDMPS = -0.122703596444 ;%<beta>=19 m
QUE1S={'qu' 'QUE1S' LQD/2 KQUE1S}';
QUE2S={'qu' 'QUE2S' LQD/2 KQUE2S}';
QDMP1S={'qu' 'QDMP1S' LQD/2 KQDMPS}';
QDMP2S={'qu' 'QDMP2S' LQD/2 KQDMPS}';
% ------------------------------------------------------------------------------
% place holder for soft X-ray self-seeding
% ------------------------------------------------------------------------------
KQSSS02 =  0.20;
KQSSS08 = -KQSSS02;
KQSSS14 =  0.670164459271 ;
KQSSS15 = -0.665637712987;
KQSSS19 =  0.279767465764 ;
KQSSS22 = -0.446319370509;
QSSS02={'qu' 'QSSS02' LQu/2 KQSSS02}';
QSSS08={'qu' 'QSSS08' LQu/2 KQSSS08}';
QSSS14={'qu' 'QSSS14' LQu/2 KQSSS14}';
QSSS15={'qu' 'QSSS15' LQu/2 KQSSS15}';
QSSS19={'qu' 'QSSS19' LQu/2 KQSSS19}';
QSSS22={'qu' 'QSSS22' LQu/2 KQSSS22}';
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% - IntgSX = integrated quadrupole gradient (nominal: 60 kG, maximum 80 kG)
% - GQFSX  = QF and QD gradients can be made different to compensate for
%            undulator focussing ...
% - GQDSX  = ... but since undulator focussing depends on gamma^2, compensation
%            will only work for one energy
% - kQFSX  = QF undulator quadrupole focusing "k"
% - kQDSX  = QD undulator quadrupole focusing "k"
% ------------------------------------------------------------------------------
IntgSX = 45.00                      ;%kG
GQFSX  =  IntgSX/LQu/10*1.00        ;%T/m 
GQDSX  = -IntgSX/LQu/10*1.00        ;%T/m 
kQFSX  = 1E-9*GQFSX*CLIGHT/gamf/mc2 ;%m^-2
kQDSX  = 1E-9*GQDSX*CLIGHT/gamf/mc2 ;%m^-2
% even numbered quads are QD's, odd numbered quads are QF's
QSX01={'qu' 'QSX01' LQu/2 kQFSX}';
QSX02={'qu' 'QSX02' LQu/2 kQDSX}';
QSX03={'qu' 'QSX03' LQu/2 kQFSX}';
QSX04={'qu' 'QSX04' LQu/2 kQDSX}';
QSX05={'qu' 'QSX05' LQu/2 kQFSX}';
QSX06={'qu' 'QSX06' LQu/2 kQDSX}';
QSX07={'qu' 'QSX07' LQu/2 kQFSX}';
QSX08={'qu' 'QSX08' LQu/2 kQDSX}';
QSX09={'qu' 'QSX09' LQu/2 kQFSX}';
QSX10={'qu' 'QSX10' LQu/2 kQDSX}';
QSX11={'qu' 'QSX11' LQu/2 kQFSX}';
QSX12={'qu' 'QSX12' LQu/2 kQDSX}';
QSX13={'qu' 'QSX13' LQu/2 kQFSX}';
QSX14={'qu' 'QSX14' LQu/2 kQDSX}';
QSX15={'qu' 'QSX15' LQu/2 kQFSX}';
QSX16={'qu' 'QSX16' LQu/2 kQDSX}';
QSX17={'qu' 'QSX17' LQu/2 kQFSX}';
QSX18={'qu' 'QSX18' LQu/2 kQDSX}';
% ==============================================================================
% SOLE
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
% - SOL1BKB = gun bucking-solenoid (set to ~zero length and strength, with
%             longitudinal unknown for now)
% - SOL1B   = gun solenoid (set to zero strength)
% ------------------------------------------------------------------------------
LSOL1 = 0.2;
SOL1BKB={'dr' 'SOL1BKB' 1E-9 []}';
SOL1B={'dr' 'SOL1B' LSOL1/2 []}';
% ==============================================================================
% MATR
% ==============================================================================
% ------------------------------------------------------------------------------
% laser heater undulator
% - use DRIF for Elegant with all MATR commented out (& refit at WS02b/OTR2b)
% ------------------------------------------------------------------------------
lam   = 0.054                           ;%undulator period [m]
lamr  = 758E-9                          ;%heater laser wavelength [m]
gami  = Ei/mc2                          ;%Lorentz energy factor
K_und = sqrt(2*(lamr*2*gami^2/lam-1))   ;%undulator K
Lhun  = 0.506263                        ;%undulator length
kqlh  = (K_und*2*pi/lam/sqrt(2)/gami)^2 ;%natural focusing "k" [m^-2]
LH_UNDB={'un' 'LH_UNDB' Lhun/2 [kqlh lam]}';% 
%LH_UNDB : DRIF, L=Lhun/2
% ------------------------------------------------------------------------------
% hard X-ray undulator
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited December 9, 2010
% - 6.8 mm miminum Undulator Gap; only constant break length each
% - include natural vertical focusing over all but edge terminations
% ------------------------------------------------------------------------------
% Initial beta functions @ HXRSTART
% Energy    betx     alfx     bety     alfy
% [GeV]     [m]       []      [m]       []
%   4.2    17.2784  +1.1413   7.3843  -0.7564
%   5.5    20.2586  +1.2662  10.7967  -0.6705
%   6.7    23.0850  +1.1851  14.0477  -0.7176
%   9.0    28.4482  +1.0880  20.5601  -0.7835
%  11.0    32.9744  +1.0321  26.5406  -0.8284
%  12.5    36.2729  +0.9993  31.2357  -0.8584
%  13.5    38.4260  +0.9803  24.4730  -0.8774
% ------------------------------------------------------------------------------
% - LHXUSB = HXR Undulator segment length
% - LHXUe  = HXR Undulator termination length (approx)
% - LHXUCR = HXR Undulator segment length without terminations
% - KHXU   = HXR Undulator parameter (rms)
% - luHXU  = HXR Undulator period
% - kQHX   = natural HXR undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LHXUSB = 3.400                            ;%m
LHXUe  = 0.0410                           ;%m
LHXUCR = LHXUSB-2*LHXUe                   ;%m
LHXUh  = LHXUCR/2;
KHXU   = 3.500;
luHXU  = 0.030                            ;%m
kQHX   = (KHXU*2*pi/luHXU/sqrt(2)/gamf)^2 ;%m^-2
HXSEGH={'un' 'HXSEGH' LHXUh [kQHX luHXU]}';
HXS01=HXSEGH;HXS01{2}='HXS01';
HXS02=HXSEGH;HXS02{2}='HXS02';
HXS03=HXSEGH;HXS03{2}='HXS03';
HXS04=HXSEGH;HXS04{2}='HXS04';
HXS05=HXSEGH;HXS05{2}='HXS05';
HXS06=HXSEGH;HXS06{2}='HXS06';
HXS07=HXSEGH;HXS07{2}='HXS07';
HXS08=HXSEGH;HXS08{2}='HXS08';
HXS09=HXSEGH;HXS09{2}='HXS09';
HXS10=HXSEGH;HXS10{2}='HXS10';
HXS11=HXSEGH;HXS11{2}='HXS11';
HXS12=HXSEGH;HXS12{2}='HXS12';
HXS13=HXSEGH;HXS13{2}='HXS13';
HXS14=HXSEGH;HXS14{2}='HXS14';
HXS15=HXSEGH;HXS15{2}='HXS15';
HXS16=HXSEGH;HXS16{2}='HXS16';
HXS17=HXSEGH;HXS17{2}='HXS17';
HXS18=HXSEGH;HXS18{2}='HXS18';
HXS19=HXSEGH;HXS19{2}='HXS19';
HXS20=HXSEGH;HXS20{2}='HXS20';
HXS21=HXSEGH;HXS21{2}='HXS21';
HXS22=HXSEGH;HXS22{2}='HXS22';
HXS23=HXSEGH;HXS23{2}='HXS23';
HXS24=HXSEGH;HXS24{2}='HXS24';
HXS25=HXSEGH;HXS25{2}='HXS25';
HXS26=HXSEGH;HXS26{2}='HXS26';
HXS27=HXSEGH;HXS27{2}='HXS27';
HXS28=HXSEGH;HXS28{2}='HXS28';
HXS29=HXSEGH;HXS29{2}='HXS29';
HXS30=HXSEGH;HXS30{2}='HXS30';
HXS31=HXSEGH;HXS31{2}='HXS31';
HXS32=HXSEGH;HXS32{2}='HXS32';
% ------------------------------------------------------------------------------
% soft X-ray undulator
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited November 12, 2010
% - 6.8 mm miminum Undulator Gap; only constant break length each
% - include natural vertical focusing over all but edge terminations
% ------------------------------------------------------------------------------
% Initial beta functions @ SXRSTART
% Energy    betx     alfx     bety     alfy
% [GeV]     [m]       []      [m]       []
%   4.2     3.7217  -0.4250  13.6268  +2.2248
%   5.5     4.5430  -0.5571  12.8144  +1.5921
%   6.7     6.2664  -0.6317  13.5889  +1.3830
%   9.0     9.5944  -0.7203  15.8828  +1.2003
%  11.0    13.9290  -0.7687  18.1501  +1.1207
%  12.5    14.7157  -0.7953  19.9158  +1.0813
%  13.5    16.1866  -0.8100  21.1108  +1.0608
% ------------------------------------------------------------------------------
% - LSXUSB = SXR Undulator segment length
% - LSXUe  = SXR Undulator termination length (approx)
% - LSXUCR = SXR Undulator segment length without terminations
% - KSXU   = SXR Undulator parameter (rms)
% - luSXU  = SXR Undulator period
% - kQSX   = natural SXR undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LSXUSB = 3.400                            ;%m
LSXUe  = 0.0350                           ;%m
LSXUCR = LSXUSB-2*LSXUe                   ;%m
LSXUh  = LSXUCR/2;
KSXU   = 13.200;
luSXU  = 0.060                            ;%m
kQSX   = (KSXU*2*pi/luSXU/sqrt(2)/gamf)^2 ;%m^-2
SXSEGH={'un' 'SXSEGH' LSXUh [kQSX luSXU]}';
SXS01=SXSEGH;SXS01{2}='SXS01';
SXS02=SXSEGH;SXS02{2}='SXS02';
SXS03=SXSEGH;SXS03{2}='SXS03';
SXS04=SXSEGH;SXS04{2}='SXS04';
SXS05=SXSEGH;SXS05{2}='SXS05';
SXS06=SXSEGH;SXS06{2}='SXS06';
SXS07=SXSEGH;SXS07{2}='SXS07';
SXS08=SXSEGH;SXS08{2}='SXS08';
SXS09=SXSEGH;SXS09{2}='SXS09';
SXS10=SXSEGH;SXS10{2}='SXS10';
SXS11=SXSEGH;SXS11{2}='SXS11';
SXS12=SXSEGH;SXS12{2}='SXS12';
SXS13=SXSEGH;SXS13{2}='SXS13';
SXS14=SXSEGH;SXS14{2}='SXS14';
SXS15=SXSEGH;SXS15{2}='SXS15';
SXS16=SXSEGH;SXS16{2}='SXS16';
SXS17=SXSEGH;SXS17{2}='SXS17';
SXS18=SXSEGH;SXS18{2}='SXS18';
% ==============================================================================
% DRIF
% ==============================================================================
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
DGS1={'dr' '' 0.1900-DQG/2-20E-6-0.0155757 []}';
DGS2={'dr' '' (0.2300-DQG)/2+20E-6 []}';
DGS3={'dr' '' (0.2300-DQG)/2-20E-6 []}';
DGS4={'dr' '' 0.1680-DQG/2-0.00283 []}';
DGS5={'dr' '' 0.0300-0.02271 []}';
DGS6={'dr' '' 0.0240-0.00402 []}';
DGS7={'dr' '' 0.05 []}';
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
LGGUN    = 7.51*0.3048;
LWS01_03 = 3.827458           ;%distance from WS01B to WS03B
BMIN0    = LWS01_03/sqrt(3)/2 ;%betaX=betaY between OTR2B & WS02B
LOADLOCK={'dr' '' LGGUN-1.42 []}';
DL00={'dr' '' -LOADLOCK{3} []}';%from cathode back to u/s end of loadlock
DL01a={'dr' '' 0.19601-LSOL1/2 []}';
DL01a1={'dr' '' 0.07851 []}';
DL01a2={'dr' '' 0.11609 []}';
DL01a3={'dr' '' 0.10461 []}';
DAM01B={'dr' '' 0 []}';%AM01B removed
DL01a4={'dr' '' 0.0184 []}';
DYAG01B={'dr' '' 0 []}';%YAG01B removed
DL01a5={'dr' '' 0.01097 []}';
DFC01B={'dr' '' 0 []}';%FC01B removed
DL01b={'dr' '' 0.0825 []}';
DL01c={'dr' '' 0.127295 []}';
DL01h={'dr' '' 0.0581886 []}';
DL01d={'dr' '' 0.0852707 []}';
DL01e={'dr' '' 0.2388157-DXG0{3} []}';
DL01f={'dr' '' 0.14238 []}';
DCR01B={'dr' '' 0 []}';%CR01B removed
DL01f2={'dr' '' 0.02937 []}';
DL01g={'dr' '' 0.07059 []}';
DSOL2B={'dr' '' 0 []}';%SOL2B removed
DSC3={'dr' '' 0 []}';%SC3 removed
DL02a1={'dr' '' 0.0602946 []}';
DL02a2={'dr' '' 0.112785 []}';
DL02a3={'dr' '' 0.12761-LQx/2 []}';
DL02b1={'dr' '' 0.148484-LQx/2 []}';
DL02b2={'dr' '' 0.179892-LQx/2 []}';
DL02c={'dr' '' 0.119888-LQx/2 []}';
DE00={'dr' '' 0.024994 []}';
DE00a={'dr' '' 0.070613-LQx/2 []}';
DE01a={'dr' '' 0.130373-LQx/2 []}';
DE01b={'dr' '' 0.176359-LQx/2 []}';
DE01c={'dr' '' 0.094781 []}';
Dh00={'dr' '' 0.12733045 []}';
Dh01={'dr' '' 0.1406/cos(ABh1) []}';
Dh02a={'dr' '' 0.0599702 []}';
Dh03a={'dr' '' 0.09290825 []}';
Dh03b={'dr' '' 0.0840183 []}';
Dh02b={'dr' '' 0.0878302 []}';
Dh06={'dr' '' 0.1229007 []}';
DE02={'dr' '' 0.0897395-LQx/2 []}';
DE03a={'dr' '' 0.16832-LQx/2 []}';
DE03b={'dr' '' 0.047581 []}';
DE03c={'dr' '' 0.190499-LQx/2 []}';
DE04={'dr' '' 0.197688-LQx/2 []}';
DWS01B={'dr' '' 0 []}';%WS01B removed
DE05={'dr' '' 0.151968 []}';
DE05c={'dr' '' 0.10447 []}';
DE06b={'dr' '' 0.2478024 []}';
DE06a={'dr' '' LWS01_03/2-DE05{3}-DE05c{3}-DE06b{3} []}';
DE05a={'dr' '' DE05{3}/2 []}';
DE06d={'dr' '' 0.1638307 []}';
DE06e={'dr' '' LWS01_03/2-DE05{3}-DE06d{3} []}';
DWS03B={'dr' '' 0 []}';%WS03B removed
DE07={'dr' '' 0.2048057-LQx/2 []}';
DE08={'dr' '' 0.2018721-LQx/2 []}';
DE08a={'dr' '' 0.18333 []}';
DE08b={'dr' '' 0.17062-LQx/2 []}';
DE09={'dr' '' 0.27745-LQx/2 []}';
DB00a={'dr' '' 0.3997 []}';
DB00b={'dr' '' 0.161 []}';
DB00c={'dr' '' 0.2191-LQE/2 []}';
DB00d={'dr' '' 0.342-LQE/2 []}';
DWS04B={'dr' '' 0 []}';%WS04B removed
DB00e={'dr' '' 0.4378 []}';
DM00={'dr' '' 0.2213 []}';
DM00a={'dr' '' 0.194683-LQx/2 []}';
DM01={'dr' '' 0.142367-LQx/2 []}';
DM01a={'dr' '' 0.2628-LQx/2 []}';
DM02={'dr' '' 0.1942-LQx/2 []}';
DM02a={'dr' '' 0.157448 []}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
DS0={'dr' '' 0.5583996 []}';
DS0a={'dr' '' 0.1691504 []}';
DS0b={'dr' '' 0.4615/2 []}';
DS1a={'dr' '' 0.0890085 []}';
DS1b={'dr' '' 0.1451215 []}';
DS1c={'dr' '' 0.171796 []}';
DS1d={'dr' '' 0.251824 []}';
DS2={'dr' '' 0.478250 []}';
DS3a={'dr' '' 0.199626 []}';
DS3b={'dr' '' 0.200374 []}';
DS4={'dr' '' 0.287275 []}';
DS6a={'dr' '' 0.2575952 []}';
DS6b={'dr' '' 0.2273298-0.008205 []}';
DS7={'dr' '' 0.3801874+0.008205-0.02 []}';
DS8={'dr' '' 0.1976126+0.02 []}';
DS9={'dr' '' 0.3378194 []}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
LD11   = 2.4349                   ;%outer bend-to-bend "Z" distance (m)
LD11o  = LD11/cos(AB11)           ;%outer bend-to-bend path length (m)
LD11a  = 0.261301                 ;%"Z" distance upstream of SQ13B (m)
LD11b  = LD11-LD11a-LQs*cos(AB11) ;%"Z" distance downstream of SQ13B (m)
LD11oa = LD11a/cos(AB11)          ;%path length upstream of SQ13B
LD11ob = LD11b/cos(AB11)          ;%path length downstream of SQ13B
LWW1   = 1.656196                 ;%WS11B-12 drift length (~ beam size)
DL1Xa={'dr' '' 0.093369 []}';
DL1Xb={'dr' '' 0.2 []}';
DM10a={'dr' '' 0.205078 []}';
DM10c={'dr' '' 0.119932 []}';
DM10x={'dr' '' 0.086007 []}';
DM11={'dr' '' 0.278883 []}';
DM12={'dr' '' 0.127801 []}';
DBQ1={'dr' '' (0.400381-LB1/2-LQc/2)/cos(AB11) []}';
D11o={'dr' '' LD11o-(DBQ1{3}+LQc)-2E-7 []}';
DDG11={'dr' '' 0.24864 []}';
DDG12={'dr' '' 0.16446 []}';
DDG13={'dr' '' 0.182606 []}';
DDG14={'dr' '' 0.234494 []}';
D11oa={'dr' '' LD11oa []}';
D11ob={'dr' '' LD11ob-(DBQ1{3}+LQc)-2E-7 []}';
DM13a={'dr' '' 0.323450/2 []}';
DM13b={'dr' '' 0.323450/2 []}';
DM14a={'dr' '' 0.17385 []}';
DM14b={'dr' '' 0.20713875 []}';
DM14c={'dr' '' 0.18178875 []}';
DM15a={'dr' '' 0.100472 []}';
DM15b={'dr' '' 0.201074 []}';
DM15c={'dr' '' 0.235 []}';
DWW1a={'dr' '' LWW1 []}';
DWW1b={'dr' '' 0.295 []}';
DWW1c1={'dr' '' 0.41533 []}';
DWW1c2={'dr' '' LWW1-1.353795 []}';
DWW1d={'dr' '' 0.346099 []}';
DWW1e={'dr' '' 0.297366 []}';
DM16={'dr' '' 0.25573 []}';
DM17a={'dr' '' 0.2601041 []}';
DM17b={'dr' '' 0.4008829 []}';
DM17c={'dr' '' 0.387587 []}';
DM18a={'dr' '' 0.22613 []}';
DM18b={'dr' '' 0.23068 []}';
DM19={'dr' '' 0.096921 []}';%0.09692
% ------------------------------------------------------------------------------
% BC2
% ------------------------------------------------------------------------------
LD1  = 1.9555            ;%outer bend-to-bend "Z" distance (m)
LDo1 = LD1/cos(AB21)     ;%outer bend-to-bend path length (m)
LD2  = 7.9047            ;%outer bend-to-bend "Z" distance (m)
LDo2 = LD2/cos(AB21)-LQc ;%outer bend-to-bend path length (m)
LD3  = 7.9047            ;%outer bend-to-bend "Z" distance (m)
LDo3 = LD3/cos(AB21)-LQc ;%outer bend-to-bend path length (m)
LD4  = 1.9555            ;%outer bend-to-bend "Z" distance (m)
LDo4 = LD4/cos(AB21)     ;%outer bend-to-bend path length (m)
DM20={'dr' '' 0.0342 []}';
D10cma={'dr' '' 0.127 []}';
DM21Z={'dr' '' 0.0558006 []}';
DM21A={'dr' '' 0.3199994 []}';
DM21H={'dr' '' 0.193 []}';
DM21B={'dr' '' 0.6340002 []}';
DM21C={'dr' '' 0.3202404 []}';
DM21D={'dr' '' 0.139536 []}';
DM21E={'dr' '' 0.1951034 []}';
DBQ2a={'dr' '' LDo1 []}';
D21oa={'dr' '' LDo2 []}';
DDG0={'dr' '' 0.131185 []}';
DDG21={'dr' '' 0.24864 []}';
DDG22={'dr' '' 0.16446 []}';
DDG23={'dr' '' 0.182606 []}';
DDG24={'dr' '' 0.234494 []}';
DDGA={'dr' '' 0.131215 []}';
D21ob={'dr' '' LDo3 []}';
DBQ2b={'dr' '' LDo4 []}';
D21w={'dr' '' 0.3065 []}';
D21x={'dr' '' 0.2087 []}';
D21y={'dr' '' 0.114235 []}';
DM23B={'dr' '' 0.050405 []}';
DM24A={'dr' '' 0.12944 []}';
DM24B={'dr' '' 0.178 []}';
DM24D={'dr' '' 0.0707 []}';
DM24C={'dr' '' 0.1063 []}';
DM25={'dr' '' 0.3597 []}';%0.1604
% ------------------------------------------------------------------------------
% sector 20 vertical dogleg to bypass line
% ------------------------------------------------------------------------------
% - LTOTA    = length of 1st dogleg, from bend-1-center to bend-2-center
% - Z20WALL1 = linac Z at entrance of S20 wall 
% - Z20WALL2 = linac Z at exit of S20 wall 
% - L20WALL  = path length through the wall
% ------------------------------------------------------------------------------
LTOTA    = sqrt(XOFF^2+YOFF^2)/sin(ANGA) ;%m
LCA      = (LTOTA-8*LQH)/16 ;%8 quads in dogleg
LD02     = LCA-0.5*LB;
LD02B    = 0.3;
LD02A    = 2*LD02-LD02B;
LCA1     = 0.3;
Z20WALL1 = 2022.6325 ;%from ID-257-500-20 (was 2021.39362)
Z20WALL2 = 2023.2425 ;%from ID-257-500-20 (was 2025.38142)
L20WALL  = (Z20WALL2-Z20WALL1)/cos(ANGA);
LCAWa    = LCA-0.5*L20WALL-0.450051;
LCAWb    = LCA-0.5*L20WALL+0.450051;
D02A={'dr' '' LD02A []}';
DCA={'dr' '' LCA []}';
DCAa={'dr' '' LCA-LCA1 []}';
DCAb={'dr' '' LCA1 []}';
DCAc={'dr' '' LCA-LCA1-0.08 []}';
DCAWa={'dr' '' LCAWa []}';
D20WALL={'dr' '' L20WALL []}';
DCAWb={'dr' '' LCAWb []}';
D02B={'dr' '' LD02B []}';
% ------------------------------------------------------------------------------
% bypass line
% ------------------------------------------------------------------------------
% - DCY  = 1/2 dist. between bypass quads - from PEP-II deck
% - DCYa = drift just prior to collimator
% - DCYb = drift just after collimator
% - dLWL = places upstr. face of "WALL" at proper z-location
% ------------------------------------------------------------------------------
LL1  = 17.0;
LL2  = LL1;
LL3  = 32.0;
LL4  = 109.748649-3*LQH-LL1-LL2-LL3 ;%for using PEP2 quad
LL5  = 50.7377998                   ;%for using PEP2 quad
LCY  = 0.5;
LCM1 = 58.22939075;
LCM2 = 44.22939075;
LCM3 = 20.22939075;
dLWL = 0.80355;
LCM4 = 20.22939075;
D2bL={'dr' '' 0.6096 []}';% new D2b dump
D2b={'mo' '' 0 []}';% center of D2b
ST60b={'mo' '' 0 []}';% new D2b 1st backup stopper
ST61b={'mo' '' 0 []}';% new D2b 2nd backup stopper
LKIKY   = 1.0601              ;% kicker coil length per magnet (m) [41.737 in from SA-380-330-02, rev. 0]
BYKIK1bA={'be' 'BYKIK1b' LKIKY/2 [1E-12/2 25.4E-3 0 0 0.5 0 pi/2]}';
BYKIK1bB={'be' 'BYKIK1b' LKIKY/2 [1E-12/2 25.4E-3 0 0 0 0.5 pi/2]}';
BYKIK2bA={'be' 'BYKIK2b' LKIKY/2 [1E-12/2 25.4E-3 0 0 0.5 0 pi/2]}';
BYKIK2bB={'be' 'BYKIK2b' LKIKY/2 [1E-12/2 25.4E-3 0 0 0 0.5 pi/2]}';
TDKIKb={'mo' 'TDKIKb' 0 []}';%SBD vertical off-axis kicker dump (24 in long - 9/8/08)
DDL1c={'dr' '' 0.609226-LKIKY/2 []}';
SPOILERb={'mo' 'SPOILERb' 0 []}';%SBD dump spoiler
DL1P={'dr' '' LL1 []}';
DL2P={'dr' '' LL2 []}';
DL3P={'dr' '' LL3 []}';
DL4P={'dr' '' LL4 []}';
DL5P={'dr' '' LL5 []}';
DCY={'dr' '' (101.6-LQM)/2 []}';
DCY1={'dr' '' (101.6-LQM)/2-35.269103 []}';
DCY2={'dr' '' 35.269103 []}';
DCYa={'dr' '' LCY []}';
DCYb={'dr' '' (101.6-LQM)/2-LCY-0.08 []}';
DCM1={'dr' '' LCM1 []}';
DCM2a={'dr' '' 35.752706 []}';% separates QBP32 area from BYKIK
DCM2b={'dr' '' 7.0832385 []}';% separates BYKIK from QBP33 area (QP33-center should be equidistant from BYKIKb center and TDKIKb center)
DCM3a={'dr' '' 1.0 []}';% separates QBP33 area from spoiler
DCM3b={'dr' '' 6.612914 []}';% separates spoiler area from TDKIKb
DCM3c={'dr' '' 5.279362 []}';% separates TDKIK exit from D2b center
DCM3d={'dr' '' 1.5 []}';% separates D2b center from ST60b center
DCM3e={'dr' '' 1.5 []}';% separates ST60b center from ST61b center
DCM3f={'dr' '' 2.842409 []}';% separates ST61b center from next components
DCWL={'dr' '' dLWL []}';
WALL={'dr' '' 16.764 []}';
DCM5={'dr' '' LCM4-dLWL-16.764 []}';
% ------------------------------------------------------------------------------
% vertical and horizontal bend systems
% ------------------------------------------------------------------------------
LH1   = 0.5;
LH2   = 1;
LH3   = 20+5.5;
LH4   = 1;
LH5   = 0.5;
DVB1={'dr' '' 7.3750+(0.46092-LQH)/2 []}';
DVB2={'dr' '' 4.0+(0.46092-LQH) []}';
DH1={'dr' '' LH1 []}';
DH2={'dr' '' LH2 []}';
DH3={'dr' '' LH3 []}';
DH4={'dr' '' LH4 []}';
DH5={'dr' '' LH5 []}';
DHB1={'dr' '' (26.18236-LQH)/2 []}';
DHB1A={'dr' '' 1.226242 []}';
DHB1B={'dr' '' (26.18236-LQH)/2 - 1.226242 - 0.08 []}';
DDL5={'dr' '' 0.5+(0.46092-LQF)/2 []}';
DDL1={'dr' '' 1.0+(0.46092-LQF) []}';
DX52a={'dr' '' LB4/2 []}';
DX52b={'dr' '' LB4/2 []}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
% - DVV35   = drift after pre-undulator vacuum valve
% - DTDUND1 = drift before pre-undulator tune-up dump
% - DTDUND2 = drift after pre-undulator tune-up dump
% ------------------------------------------------------------------------------
dz_adjust = 47.825;
dLQH2     = (0.46092-LQH)/2 ;%used to adjust LQH adjacent drifts (m)
D25cmb={'dr' '' 0.2627 []}';
D25cmc={'dr' '' 0.2373 []}';
DMM1m90cm={'dr' '' 1.200460 []}';
DEM1A={'dr' '' 0.40+dLQH2-0.10046 []}';
DEM1B={'dr' '' 4.00+dLQH2*2 []}';
DEM2B={'dr' '' 0.40+dLQH2+0.02954 []}';
DMM3m80cm={'dr' '' 10.0-0.4-0.4+2.0+0.07092 []}';
DEM3A={'dr' '' 0.40+dLQH2-0.10046 []}';
DEM3B={'dr' '' 0.30+dLQH2+0.402839 []}';
DMM4m90cm={'dr' '' 3.6-0.30-LQx-(0.402839)-0.02954 []}';
DEM4A={'dr' '' 0.40+dLQH2-0.402839+(0.402839)+0.02954 []}';
DMM5a={'dr' '' 0.300001 []}';
DXS1={'dr' '' 1.0 []}';
DMM5b={'dr' '' 2.0+dLQH2-1.000000-0.300001 []}';
D40cm={'dr' '' 0.40 []}';
DE3m80cma={'dr' '' 4.6-0.4-0.4+dz_adjust/12+0.15046 []}';
DQEA={'dr' '' 0.40+(LQF-LQx)/2-0.15046 []}';
DQEBx={'dr' '' 0.32+(LQF-LQx)/2+0.33655-0.0768665+0.04 []}';
DQEBx2={'dr' '' 4.6-0.4-0.4+dz_adjust/12-0.33655+0.0768665-0.04 []}';
DE3a={'dr' '' 4.6+dz_adjust/12+0.14046 []}';
DQEAa={'dr' '' 0.40+(LQF-LQx)/2-0.14046 []}';
DQEBy={'dr' '' 0.32+(LQF-LQx)/2+0.33655-0.0768665+0.04 []}';
DQEBy2={'dr' '' 4.6-0.4+dz_adjust/12-0.33655+0.0768665-0.04 []}';
DE3m80cmb={'dr' '' 4.6-0.4-0.4+dz_adjust/12+0.12046 []}';
DQEAb={'dr' '' 0.40+(LQF-LQx)/2-0.12046 []}';
DQEC={'dr' '' 4.6+dz_adjust/12+(LQF-LQx)/2 []}';
DE3m40cm={'dr' '' 4.6-0.4+dz_adjust/12+0.15046 []}';
DE3m80cm={'dr' '' 4.6-0.4-0.4+dz_adjust/12-0.02954 []}';
DQEAc={'dr' '' 0.40+(LQF-LQx)/2+0.02954 []}';
DE3={'dr' '' 4.6+dz_adjust/12+0.15046 []}';
DU1m80cm={'dr' '' 4.550 []}';
DCX37={'dr' '' 0.08 []}';%de-scoped in 2007 until ?
D32cmc={'dr' '' 0.32-0.0254+0.00586 []}';
DUM1A={'dr' '' 0.40+dLQH2+0.0254-0.00586     + 1.082370 []}';
DUM1B={'dr' '' 0.40+dLQH2                    + 1.082370 []}';
D32cm={'dr' '' 0.32 []}';
DU2m120cm={'dr' '' 4.730 []}';
DCY38={'dr' '' 0.08 []}';%de-scoped in 2007 until ?
D32cma={'dr' '' 0.32+0.0253999+0.0750601 []}';
DUM2A={'dr' '' 0.40+dLQH2-0.0253999-0.0750601+ 1.082370 []}';
DUM2B={'dr' '' 0.40+dLQH2                    + 1.082370 []}';
DU3m80cm={'dr' '' 8.0-0.4-0.4-0.125+0.21546 []}';
DUM3A={'dr' '' 0.40+dLQH2+0.125-0.21546      + 1.082370 []}';
DUM3B={'dr' '' 0.40+dLQH2                    + 1.082370 []}';
D40cma={'dr' '' 0.40+1.407939 []}';
DU4m120cm={'dr' '' 2.800-1.407939-0.0254-0.00414 []}';
DUM4A={'dr' '' 0.40+dLQH2+0.0254+0.00414     + 1.082370 []}';
DUM4B={'dr' '' 0.40+dLQH2+0.127              + 1.082370 + 0.003819 []}';
DU5m80cm={'dr' '' 0.5 []}';
DMUON2={'dr' '' 1.406800 []}';
DVV35={'dr' '' 1.780-0.254-1.087896+0.003189 []}';
DTDUND1={'dr' '' 0.5+0.127+1.087896-0.003189 []}';
DTDUND2={'dr' '' 0.37935 []}';
DMUON1={'dr' '' 0.154859 []}';
DMUON3={'dr' '' 0.310592 - 0.0005926 []}';% to make Z=515.0
% ------------------------------------------------------------------------------
% place holder for hard X-ray self-seeding
% ------------------------------------------------------------------------------
DHSS01={'dr' '' LQu/2 []}';
DHSS02={'dr' '' LQu/2 []}';
DHSS03={'dr' '' LQu/2 []}';
DHSS04={'dr' '' LQu/2 []}';
DHSS07={'dr' '' LQu/2 []}';
DHSS08={'dr' '' LQu/2 []}';
DHSS10={'dr' '' LQu/2 []}';
DHSS11={'dr' '' LQu/2 []}';
DHSS13={'dr' '' LQu/2 []}';
DB5={'dr' '' 1.992968414 []}';
DB6={'dr' '' LPHS+Lbrwm+Lbr4+2*LHXUe+2*LHXUh+Lbr1 []}';
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% - Lbr3  = quad to BPM
% - break = break length
% - LRFBu = undulator RF-BPM only implemented as zero length monitor
% - Lbr1  = und-seg to quad
% - Lbr4  = radiation monitor to segment
% - Lbrwm = PHS to radiation monitor
% - LPHS  = length of phase shifter
% - Lbrk  = standard break length
% - LHXUe = HXR Undulator termination length (approx)
% - DF0   = no quad + correction to maintain symmetry
% - DB3   = drift from quad to BPM
% - DBRK  = standard short undulator drift from BPM to segment
% - DBWM  = PHS to radiation monitor drift
% - DB4   = radiation monitor to segment drift
% - DTHXU = SXU undulator segment small terminations modeled as drift
% - DB1   = drift from segment to quad
% - DB0   = sets UNDSTOP to Jim Welch's Z' value
% ------------------------------------------------------------------------------
Lbr3  = 0.09117  ;%m
Break = 1.000    ;%m
LRFBu = 0.05     ;%m
Lbr1  = 0.0696   ;%m
Lbr4  = 0.058577 ;%m
Lbrwm = 0.036881 ;%m
LPHS  = 0.260    ;%m
Lbrk  = Break-LRFBu-LQu-Lbr1-Lbr3-Lbr4-Lbrwm-LPHS;
%LHXUe := 0.0410   
DF0={'dr' '' LQu-0.0417 []}';
DB3={'dr' '' Lbr3 []}';
DBRK={'dr' '' Lbrk []}';
DBWM={'dr' '' Lbrwm []}';
DB4={'dr' '' Lbr4 []}';
DTHXU={'dr' '' LHXUe []}';
DB1={'dr' '' Lbr1 []}';
DB0={'dr' '' 0.5653-Lbr1-LQu-Lbr3-LRFBu []}';
% phase shifters
PHSHX01={'dr' '' LPHS []}';
PHSHX02={'dr' '' LPHS []}';
PHSHX03={'dr' '' LPHS []}';
PHSHX04={'dr' '' LPHS []}';
PHSHX05={'dr' '' LPHS []}';
PHSHX06={'dr' '' LPHS []}';
PHSHX07={'dr' '' LPHS []}';
PHSHX08={'dr' '' LPHS []}';
PHSHX09={'dr' '' LPHS []}';
PHSHX10={'dr' '' LPHS []}';
PHSHX11={'dr' '' LPHS []}';
PHSHX12={'dr' '' LPHS []}';
PHSHX13={'dr' '' LPHS []}';
PHSHX14={'dr' '' LPHS []}';
PHSHX15={'dr' '' LPHS []}';
PHSHX16={'dr' '' LPHS []}';
PHSHX17={'dr' '' LPHS []}';
PHSHX18={'dr' '' LPHS []}';
PHSHX19={'dr' '' LPHS []}';
PHSHX20={'dr' '' LPHS []}';
PHSHX21={'dr' '' LPHS []}';
PHSHX22={'dr' '' LPHS []}';
PHSHX23={'dr' '' LPHS []}';
PHSHX24={'dr' '' LPHS []}';
PHSHX25={'dr' '' LPHS []}';
PHSHX26={'dr' '' LPHS []}';
PHSHX27={'dr' '' LPHS []}';
PHSHX28={'dr' '' LPHS []}';
PHSHX29={'dr' '' LPHS []}';
PHSHX30={'dr' '' LPHS []}';
PHSHX31={'dr' '' LPHS []}';
PHSHX32={'dr' '' LPHS []}';
% ------------------------------------------------------------------------------
% HXR/SXR dump lines
% ------------------------------------------------------------------------------
LDS   = 0.300-0.026027*2;
LDSC  = 0.499225-0.026027+0.1124278-0.008032;
Ddmpv = -0.73352263654;
DUE1a={'dr' '' 10.720575-8.930036 []}';
DUE1d={'dr' '' 8.930036+0.411634             -8.037034143 []}';% =1.304635857
DUE1b={'dr' '' 0.5-0.411634+0.038094 []}';
DUE1c={'dr' '' 0.455460-0.038094 []}';
DUE2a={'dr' '' 0.455460+0.139704+0.129836 []}';
DUE2b={'dr' '' 10.609500-0.17858             -7.43092 []}';% =3.0
DUE2c={'dr' '' 0.455460+0.050796+0.048744 []}';
DUE3a={'dr' '' 0.455460-0.139956 []}';
DUE3b={'dr' '' 0.144120 []}';
DUE3c={'dr' '' 5.0429295                     -4.5429295 []}';% =0.5 
DUE3d={'dr' '' 6.8769065 -1.423393158        -5.453513342 []}';% =0.0
DUE4={'dr' '' 0.5 []}';
DUE5A={'dr' '' 1.020814-0.0762-0.009011      -0.935603 []}';% =0.0
DUE5C={'dr' '' 0.33362-0.00362 []}';
DUE5D={'dr' '' 0.145566+0.0762+0.012631 []}';
DSB0a={'dr' '' 0.111120 []}';
DSB0b={'dr' '' 0.21491 []}';
DSB0c={'dr' '' 0.235534+0.031167 []}';
DSB0d={'dr' '' 0.278039-0.031167 []}';
DS={'dr' '' LDS []}';
DSc={'dr' '' LDSC []}';
DD1a={'dr' '' 2.6512616 []}';
DD1b={'dr' '' 6.8896877-LQD/2-Ddmpv+0.017094407653 []}';
DD1f={'dr' '' 0.266645-0.017094407653 []}';
DD1c={'dr' '' 0.4+0.2920945-0.266645-2*0.0381452 []}';
DD1d={'dr' '' 0.25-0.0079372 []}';
DD1e={'dr' '' 0.25+0.0079372 []}';
DD2a={'dr' '' 0.4+0.0634916+0.0115084 []}';
DD2b={'dr' '' 8.425460-LQD/2+Ddmpv-0.15-0.0634916-0.049684-0.0115084 []}';
DD3a={'dr' '' 0.3+0.049684+0.001583 []}';
DD3b={'dr' '' 0.3-0.001583-0.1447026 []}';
DWSDUMPa={'dr' '' 0.44156 []}';%0.5-0.058217-0.000222-0.000001
DWSDUMPb={'dr' '' 2.038949+0.723633351 []}';%1.980509+0.058217+0.000222+0.000001
DD3d={'dr' '' 0.2441932 []}';
DD3e={'dr' '' 0.2857474-0.2441932 []}';
% ------------------------------------------------------------------------------
% HXR/SXR safety dump lines
% ------------------------------------------------------------------------------
LSTPR  = 0.3046;
DYD1={'dr' '' LBdm*cos(1*ABdm0/2) []}';
DSS1={'dr' '' LDS*cos(1*ABdm0) []}';
DYD2={'dr' '' LBdm*cos(3*ABdm0/2) []}';
DSS2={'dr' '' LDS*cos(2*ABdm0) []}';
DYD3={'dr' '' LBdm*cos(5*ABdm0/2) []}';
DScS1={'dr' '' LDSC*cos(3*ABdm0)/2+0.188398+0.004 []}';
DScS2={'dr' '' LDSC*cos(3*ABdm0)/2-0.188398-0.004 []}';
DPM1b={'dr' '' 1.820699-LSTPR/2+0.163401-0.1174 []}';
ST0={'dr' '' LSTPR []}';%Empty can of uninstalled X-ray insertable stopper (was "ST1" in ~2007)
DST0={'dr' '' 0.1112 []}';
BTMST0={'dr' '' 0 []}';% Non-existent Burn-Through-Monitor behind empty ST0 can
DMUSPL={'dr' '' 3*0.3048+2.893089-LSTPR-3.288089+0.1174-0.1112-0.1174 []}';
DST1={'dr' '' 0.1112 []}';
DPM1c={'dr' '' 4.7074-LSTPR/2+3.4214+0.1174-0.1112 []}';
DPM1d={'dr' '' 0.50+0.112-0.296712+0.008013 []}';
DPM1={'dr' '' 0.30/cos(ABpm) []}';
DPM2={'dr' '' 0.30/cos(2*ABpm) []}';
DSFT={'dr' '' 11.934976 []}';
DPM2e={'dr' '' 0.076213 []}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
% - dLQH2   = used to adjust LQH adjacent drifts
% - DVV35   = drift after pre-undulator vacuum valve
% - DTDUND1 = drift before pre-undulator tune-up dump
% - DTDUND2 = drift after pre-undulator tune-up dump
% ------------------------------------------------------------------------------
%dLQH2 := (0.46092-LQH)/2 
DHB1S={'dr' '' (26.18236-LQH)/2 []}';
DHB1SA={'dr' '' 1.226242 []}';
DHB1SB={'dr' '' (26.18236-LQH)/2 - 1.226242 - 0.08 []}';
DDL5S={'dr' '' 0.5+(0.46092-LQF)/2 []}';
DDL5Sa={'dr' '' 0.3 []}';
DDL5Sb={'dr' '' 0.5+(0.46092-LQF)/2-0.3 []}';
DDL1S={'dr' '' 1.0+(0.46092-LQF) []}';
DDL2S={'dr' '' 2.0 []}';
D50D={'dr' '' LeffB4 []}';
LDDLCa     = 0.3+15.0470025 ;% adjusted for 90 deg between collimators
DDLCa={'dr' '' LDDLCa []}';
DDLCb={'dr' '' 0.3 []}';
DHB0S={'dr' '' 2.846067*(26.18236-LQH)/2-2.0-LQF-2*0.08-0.3-LDDLCa []}';
DU1m80cmS={'dr' '' 4.550 []}';
DCX37S={'dr' '' 0.08 []}';%de-scoped in 2007 until ?
D32cmcS={'dr' '' 0.32-0.0254+0.00586 []}';
DUM1AS={'dr' '' 0.40+dLQH2+0.0254-0.00586      + 2.6795205*1 []}';
DUM1BS={'dr' '' 0.40+dLQH2                     + 2.6795205*1 []}';
D32cmS={'dr' '' 0.32 []}';
DU2m120cmS={'dr' '' 4.730 []}';
DCY38S={'dr' '' 0.08 []}';%de-scoped in 2007 until ?
D32cmaS={'dr' '' 0.32+0.0253999+0.0750601 []}';
DUM2AS={'dr' '' 0.40+dLQH2-0.0253999-0.0750601 + 2.6795205*0.5 []}';
DUM2BS={'dr' '' 0.40+dLQH2                     + 2.6795205*0.5 []}';
DU3m80cmS={'dr' '' 8.0-0.4-0.4-0.125+0.21546 []}';
DUM3AS={'dr' '' 0.40+dLQH2+0.125-0.21546       + 2.6795205*0.5 []}';
DUM3BS={'dr' '' 0.40+dLQH2                     + 2.6795205*0.5 []}';
D40cmaS={'dr' '' 0.40+1.407939 []}';
DU4m120cmS={'dr' '' 2.800-1.407939-0.0254-0.00414 []}';
DUM4AS={'dr' '' 0.40+dLQH2+0.0254+0.00414      + 2.6795205*2 []}';
DUM4BS={'dr' '' 0.40+dLQH2+0.127               + 2.6795205*2 - 0.089605 []}';
DU5m80cmS={'dr' '' 0.5 []}';
D40cmS={'dr' '' 0.40 []}';
DMUON2S={'dr' '' 1.406800 []}';
DVV35S={'dr' '' 1.780-0.254-1.087896+0.003189 []}';
DTDUND1S={'dr' '' 0.5+0.127+1.087896-0.003189 []}';
DTDUND2S={'dr' '' 0.37935 []}';
DMUON1S={'dr' '' 0.154859 []}';
DMUON3S={'dr' '' 0.309998991 []}';% to make SSSSTART at Z=515.0
% ------------------------------------------------------------------------------
% place holder for soft X-ray self-seeding
% ------------------------------------------------------------------------------
DSSS01={'dr' '' LQu/2 []}';
DSSS03={'dr' '' LQu/2 []}';
DSSS04={'dr' '' LQu/2 []}';
DSSS05={'dr' '' LQu/2 []}';
DSSS06={'dr' '' LQu/2 []}';
DSSS07={'dr' '' LQu/2 []}';
DSSS09={'dr' '' LQu/2 []}';
DSSS10={'dr' '' LQu/2 []}';
DSSS11={'dr' '' LQu/2 []}';
DSSS12={'dr' '' LQu/2 []}';
DSSS13={'dr' '' LQu/2 []}';
DSSS16={'dr' '' LQu/2 []}';
DSSS17={'dr' '' LQu/2 []}';
DSSS18={'dr' '' LQu/2 []}';
DSSS20={'dr' '' LQu/2 []}';
DSSS21={'dr' '' LQu/2 []}';
DSSS22={'dr' '' LQu/2 []}';
DSSS23={'dr' '' LQu/2 []}';
DB7={'dr' '' 4.033353667 []}';
DB8={'dr' '' LPHS+Lbrwm+Lbr4+2*LSXUe+2*LSXUh+Lbr1 []}';
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% - LSXUe  = SXR undulator termination length (approx)
% - LBUVV2 = drift length after inline vaccum valve
% - LBUVV1 = drift length before inline vaccum valve
% - DTSXU  = SXU undulator segment small terminations modeled as drift
% - DBUVV1 = drift before inline vaccum valve
% - DBUVV2 = drift after inline vaccum valve
% ------------------------------------------------------------------------------
%LSXUe  := 0.0350      
LBUVV2 = 0.2         ;%m
LBUVV1 = Lbrk-LBUVV2 ;%m
DTSXU={'dr' '' LSXUe []}';
DBUVV1={'dr' '' LBUVV1 []}';
DBUVV2={'dr' '' LBUVV2 []}';
% phase shifters
PHSSX01={'dr' '' LPHS []}';
PHSSX02={'dr' '' LPHS []}';
PHSSX03={'dr' '' LPHS []}';
PHSSX04={'dr' '' LPHS []}';
PHSSX05={'dr' '' LPHS []}';
PHSSX06={'dr' '' LPHS []}';
PHSSX07={'dr' '' LPHS []}';
PHSSX08={'dr' '' LPHS []}';
PHSSX09={'dr' '' LPHS []}';
PHSSX10={'dr' '' LPHS []}';
PHSSX11={'dr' '' LPHS []}';
PHSSX12={'dr' '' LPHS []}';
PHSSX13={'dr' '' LPHS []}';
PHSSX14={'dr' '' LPHS []}';
PHSSX15={'dr' '' LPHS []}';
PHSSX16={'dr' '' LPHS []}';
PHSSX17={'dr' '' LPHS []}';
PHSSX18={'dr' '' LPHS []}';
% ------------------------------------------------------------------------------
% place holder for SXR polarization
% ------------------------------------------------------------------------------
DPOLS={'dr' '' 15.55961473 []}';
% ==============================================================================
% HKIC
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
XC00B={'mo' 'XC00B' 0 []}';
XC01B={'mo' 'XC01B' 0 []}';
XC02B={'mo' 'XC02B' 0 []}';
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
XC04B={'mo' 'XC04B' 0 []}';%fast-feedback (loop-1)
XC05B={'mo' 'XC05B' 0 []}';%calibrated to <1%
XC06B={'mo' 'XC06B' 0 []}';
XC07B={'mo' 'XC07B' 0 []}';%fast-feedback (loop-1)
XC08B={'mo' 'XC08B' 0 []}';
XC09B={'mo' 'XC09B' 0 []}';
XC10B={'mo' 'XC10B' 0 []}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
XCS1B={'mo' 'XCS1B' 0 []}';
XCS2B={'mo' 'XCS2B' 0 []}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
XCM11B={'mo' 'XCM11B' 0 []}';
XCM13B={'mo' 'XCM13B' 0 []}';
XC11302={'mo' 'XC11302' 0 []}';
XCM14B={'mo' 'XCM14B' 0 []}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
XCEM2H={'mo' 'XCEM2H' 0 []}';
XCEM4H={'mo' 'XCEM4H' 0 []}';
XCE41={'mo' 'XCE41' 0 []}';
XCE43={'mo' 'XCE43' 0 []}';
XCE45={'mo' 'XCE45' 0 []}';
XCUM1H={'mo' 'XCUM1H' 0 []}';%fast-feedback (loop-5)
XCUM4H={'mo' 'XCUM4H' 0 []}';%fast-feedback (loop-5)
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% HXR self-seeding section X-steering coils in quads
XCHSS05={'mo' 'XCHSS05' 0 []}';
XCHSS06={'mo' 'XCHSS06' 0 []}';
XCHSS09={'mo' 'XCHSS09' 0 []}';
XCHSS12={'mo' 'XCHSS12' 0 []}';
% undulator X-steering coils in quads
XCHX01={'mo' 'XCHX01' 0 []}';
XCHX02={'mo' 'XCHX02' 0 []}';
XCHX03={'mo' 'XCHX03' 0 []}';
XCHX04={'mo' 'XCHX04' 0 []}';
XCHX05={'mo' 'XCHX05' 0 []}';
XCHX06={'mo' 'XCHX06' 0 []}';
XCHX07={'mo' 'XCHX07' 0 []}';
XCHX08={'mo' 'XCHX08' 0 []}';
XCHX09={'mo' 'XCHX09' 0 []}';
XCHX10={'mo' 'XCHX10' 0 []}';
XCHX11={'mo' 'XCHX11' 0 []}';
XCHX12={'mo' 'XCHX12' 0 []}';
XCHX13={'mo' 'XCHX13' 0 []}';
XCHX14={'mo' 'XCHX14' 0 []}';
XCHX15={'mo' 'XCHX15' 0 []}';
XCHX16={'mo' 'XCHX16' 0 []}';
XCHX17={'mo' 'XCHX17' 0 []}';
XCHX18={'mo' 'XCHX18' 0 []}';
XCHX19={'mo' 'XCHX19' 0 []}';
XCHX20={'mo' 'XCHX20' 0 []}';
XCHX21={'mo' 'XCHX21' 0 []}';
XCHX22={'mo' 'XCHX22' 0 []}';
XCHX23={'mo' 'XCHX23' 0 []}';
XCHX24={'mo' 'XCHX24' 0 []}';
XCHX25={'mo' 'XCHX25' 0 []}';
XCHX26={'mo' 'XCHX26' 0 []}';
XCHX27={'mo' 'XCHX27' 0 []}';
XCHX28={'mo' 'XCHX28' 0 []}';
XCHX29={'mo' 'XCHX29' 0 []}';
XCHX30={'mo' 'XCHX30' 0 []}';
XCHX31={'mo' 'XCHX31' 0 []}';
XCHX32={'mo' 'XCHX32' 0 []}';
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
XCUE1H={'mo' 'XCUE1H' 0 []}';
XCD3H={'mo' 'XCD3H' 0 []}';
XCDDH={'mo' 'XCDDH' 0 []}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
XCUM1S={'mo' 'XCUM1S' 0 []}';%fast-feedback (loop-5)
XCUM4S={'mo' 'XCUM4S' 0 []}';%fast-feedback (loop-5)
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% SXR self-seeding section X-steering coils in quads
XCSSS02={'mo' 'XCSSS02' 0 []}';
XCSSS08={'mo' 'XCSSS08' 0 []}';
XCSSS14={'mo' 'XCSSS14' 0 []}';
XCSSS15={'mo' 'XCSSS15' 0 []}';
XCSSS19={'mo' 'XCSSS19' 0 []}';
XCSSS22={'mo' 'XCSSS22' 0 []}';
% undulator X-steering coils in quads
XCSX01={'mo' 'XCSX01' 0 []}';
XCSX02={'mo' 'XCSX02' 0 []}';
XCSX03={'mo' 'XCSX03' 0 []}';
XCSX04={'mo' 'XCSX04' 0 []}';
XCSX05={'mo' 'XCSX05' 0 []}';
XCSX06={'mo' 'XCSX06' 0 []}';
XCSX07={'mo' 'XCSX07' 0 []}';
XCSX08={'mo' 'XCSX08' 0 []}';
XCSX09={'mo' 'XCSX09' 0 []}';
XCSX10={'mo' 'XCSX10' 0 []}';
XCSX11={'mo' 'XCSX11' 0 []}';
XCSX12={'mo' 'XCSX12' 0 []}';
XCSX13={'mo' 'XCSX13' 0 []}';
XCSX14={'mo' 'XCSX14' 0 []}';
XCSX15={'mo' 'XCSX15' 0 []}';
XCSX16={'mo' 'XCSX16' 0 []}';
XCSX17={'mo' 'XCSX17' 0 []}';
XCSX18={'mo' 'XCSX18' 0 []}';
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
XCUE1S={'mo' 'XCUE1S' 0 []}';
XCD3S={'mo' 'XCD3S' 0 []}';
XCDDS={'mo' 'XCDDS' 0 []}';
% ==============================================================================
% VKIC
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
YC00B={'mo' 'YC00B' 0 []}';
YC01B={'mo' 'YC01B' 0 []}';
YC02B={'mo' 'YC02B' 0 []}';
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
YCG1B={'mo' 'YCG1B' 0 []}';
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
YC04B={'mo' 'YC04B' 0 []}';%fast-feedback (loop-1)
YC05B={'mo' 'YC05B' 0 []}';%calibrated to <1%
YC06B={'mo' 'YC06B' 0 []}';
YC07B={'mo' 'YC07B' 0 []}';%fast-feedback (loop-1)
YC08B={'mo' 'YC08B' 0 []}';
YC09B={'mo' 'YC09B' 0 []}';
YC10B={'mo' 'YC10B' 0 []}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
YCS1B={'mo' 'YCS1B' 0 []}';
YCS2B={'mo' 'YCS2B' 0 []}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
YCM11B={'mo' 'YCM11B' 0 []}';
YCM12B={'mo' 'YCM12B' 0 []}';
YC11303={'mo' 'YC11303' 0 []}';
YCM15B={'mo' 'YCM15B' 0 []}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
YCEM1H={'mo' 'YCEM1H' 0 []}';
YCEM3H={'mo' 'YCEM3H' 0 []}';
YCE42={'mo' 'YCE42' 0 []}';
YCE44={'mo' 'YCE44' 0 []}';
YCE46={'mo' 'YCE46' 0 []}';
YCUM2H={'mo' 'YCUM2H' 0 []}';%fast-feedback (loop-5)
YCUM3H={'mo' 'YCUM3H' 0 []}';%fast-feedback (loop-5)
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% HXR self-seeding section Y-steering coils in quads
YCHSS05={'mo' 'YCHSS05' 0 []}';
YCHSS06={'mo' 'YCHSS06' 0 []}';
YCHSS09={'mo' 'YCHSS09' 0 []}';
YCHSS12={'mo' 'YCHSS12' 0 []}';
% SXR self-seeding section Y-steering coils in quads
YCSSS02={'mo' 'YCSSS02' 0 []}';
YCSSS08={'mo' 'YCSSS08' 0 []}';
YCSSS14={'mo' 'YCSSS14' 0 []}';
YCSSS15={'mo' 'YCSSS15' 0 []}';
YCSSS19={'mo' 'YCSSS19' 0 []}';
YCSSS22={'mo' 'YCSSS22' 0 []}';
% undulator Y-steering coils in quads
YCHX01={'mo' 'YCHX01' 0 []}';
YCHX02={'mo' 'YCHX02' 0 []}';
YCHX03={'mo' 'YCHX03' 0 []}';
YCHX04={'mo' 'YCHX04' 0 []}';
YCHX05={'mo' 'YCHX05' 0 []}';
YCHX06={'mo' 'YCHX06' 0 []}';
YCHX07={'mo' 'YCHX07' 0 []}';
YCHX08={'mo' 'YCHX08' 0 []}';
YCHX09={'mo' 'YCHX09' 0 []}';
YCHX10={'mo' 'YCHX10' 0 []}';
YCHX11={'mo' 'YCHX11' 0 []}';
YCHX12={'mo' 'YCHX12' 0 []}';
YCHX13={'mo' 'YCHX13' 0 []}';
YCHX14={'mo' 'YCHX14' 0 []}';
YCHX15={'mo' 'YCHX15' 0 []}';
YCHX16={'mo' 'YCHX16' 0 []}';
YCHX17={'mo' 'YCHX17' 0 []}';
YCHX18={'mo' 'YCHX18' 0 []}';
YCHX19={'mo' 'YCHX19' 0 []}';
YCHX20={'mo' 'YCHX20' 0 []}';
YCHX21={'mo' 'YCHX21' 0 []}';
YCHX22={'mo' 'YCHX22' 0 []}';
YCHX23={'mo' 'YCHX23' 0 []}';
YCHX24={'mo' 'YCHX24' 0 []}';
YCHX25={'mo' 'YCHX25' 0 []}';
YCHX26={'mo' 'YCHX26' 0 []}';
YCHX27={'mo' 'YCHX27' 0 []}';
YCHX28={'mo' 'YCHX28' 0 []}';
YCHX29={'mo' 'YCHX29' 0 []}';
YCHX30={'mo' 'YCHX30' 0 []}';
YCHX31={'mo' 'YCHX31' 0 []}';
YCHX32={'mo' 'YCHX32' 0 []}';
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
YCUE2H={'mo' 'YCUE2H' 0 []}';
YCD3H={'mo' 'YCD3H' 0 []}';
YCDDH={'mo' 'YCDDH' 0 []}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
YCUM2S={'mo' 'YCUM2S' 0 []}';%fast-feedback (loop-5)
YCUM3S={'mo' 'YCUM3S' 0 []}';%fast-feedback (loop-5)
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% undulator Y-steering coils in quads
YCSX01={'mo' 'YCSX01' 0 []}';
YCSX02={'mo' 'YCSX02' 0 []}';
YCSX03={'mo' 'YCSX03' 0 []}';
YCSX04={'mo' 'YCSX04' 0 []}';
YCSX05={'mo' 'YCSX05' 0 []}';
YCSX06={'mo' 'YCSX06' 0 []}';
YCSX07={'mo' 'YCSX07' 0 []}';
YCSX08={'mo' 'YCSX08' 0 []}';
YCSX09={'mo' 'YCSX09' 0 []}';
YCSX10={'mo' 'YCSX10' 0 []}';
YCSX11={'mo' 'YCSX11' 0 []}';
YCSX12={'mo' 'YCSX12' 0 []}';
YCSX13={'mo' 'YCSX13' 0 []}';
YCSX14={'mo' 'YCSX14' 0 []}';
YCSX15={'mo' 'YCSX15' 0 []}';
YCSX16={'mo' 'YCSX16' 0 []}';
YCSX17={'mo' 'YCSX17' 0 []}';
YCSX18={'mo' 'YCSX18' 0 []}';
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
YCUE2S={'mo' 'YCUE2S' 0 []}';
YCD3S={'mo' 'YCD3S' 0 []}';
YCDDS={'mo' 'YCDDS' 0 []}';
% ==============================================================================
% MONI
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
BPM2B={'mo' 'BPM2B' 0 []}';
BPM3B={'mo' 'BPM3B' 0 []}';
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
BPM5B={'mo' 'BPM5B' 0 []}';
BPM6B={'mo' 'BPM6B' 0 []}';
BPM8B={'mo' 'BPM8B' 0 []}';
BPM9B={'mo' 'BPM9B' 0 []}';
BPM10B={'mo' 'BPM10B' 0 []}';
BPM11B={'mo' 'BPM11B' 0 []}';
BPM12B={'mo' 'BPM12B' 0 []}';
BPM13B={'mo' 'BPM13B' 0 []}';
BPM14B={'mo' 'BPM14B' 0 []}';
BPM15B={'mo' 'BPM15B' 0 []}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
BPMS1B={'mo' 'BPMS1B' 0 []}';
BPMS2B={'mo' 'BPMS2B' 0 []}';
BPMS3B={'mo' 'BPMS3B' 0 []}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
BPM11201={'mo' 'BPM11201' 0 []}';
BPMS11B={'mo' 'BPMS11B' 0 []}';
BPMM12B={'mo' 'BPMM12B' 0 []}';
BPM11301={'mo' 'BPM11301' 0 []}';
BPMM14B={'mo' 'BPMM14B' 0 []}';
% ------------------------------------------------------------------------------
% BC2
% ------------------------------------------------------------------------------
BPM14501={'mo' 'BPM14501' 0 []}';
BPMS21B={'mo' 'BPMS21B' 0 []}';
BPM14701={'mo' 'BPM14701' 0 []}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
BPMEM1H={'mo' 'BPMEM1H' 0 []}';
BPMEM2H={'mo' 'BPMEM2H' 0 []}';
BPMEM3H={'mo' 'BPMEM3H' 0 []}';
BPMEM4H={'mo' 'BPMEM4H' 0 []}';
BPME41={'mo' 'BPME41' 0 []}';
BPME42={'mo' 'BPME42' 0 []}';
BPME43={'mo' 'BPME43' 0 []}';
BPME44={'mo' 'BPME44' 0 []}';
BPME45={'mo' 'BPME45' 0 []}';
BPME46={'mo' 'BPME46' 0 []}';
BPMUM1H={'mo' 'BPMUM1H' 0 []}';
BPMUM2H={'mo' 'BPMUM2H' 0 []}';
BPMUM3H={'mo' 'BPMUM3H' 0 []}';
BPMUM4H={'mo' 'BPMUM4H' 0 []}';
RFB01H={'mo' 'RFB01H' 0 []}';
RFB02H={'mo' 'RFB02H' 0 []}';
% ------------------------------------------------------------------------------
% HXR self-seeding section BPMs (initially drifts or those with quads are stripline)
% ------------------------------------------------------------------------------
DPMHSS01={'dr' '' LRFBu []}';
DPMHSS02={'dr' '' LRFBu []}';
DPMHSS03={'dr' '' LRFBu []}';
DPMHSS04={'dr' '' LRFBu []}';
BPMHSS05={'mo' 'BPMHSS05' 0 []}';
BPMHSS06={'mo' 'BPMHSS06' 0 []}';
DPMHSS07={'dr' '' LRFBu []}';
DPMHSS08={'dr' '' LRFBu []}';
BPMHSS09={'mo' 'BPMHSS09' 0 []}';
DPMHSS10={'dr' '' LRFBu []}';
DPMHSS11={'dr' '' LRFBu []}';
RFBHSS12={'mo' 'RFBHSS12' 0 []}';% last quad before HXR has an RF BPM
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% undulator BPMs
RFBHX00={'mo' 'RFBHX00' 0 []}';
RFBHX01={'mo' 'RFBHX01' 0 []}';
RFBHX02={'mo' 'RFBHX02' 0 []}';
RFBHX03={'mo' 'RFBHX03' 0 []}';
RFBHX04={'mo' 'RFBHX04' 0 []}';
RFBHX05={'mo' 'RFBHX05' 0 []}';
RFBHX06={'mo' 'RFBHX06' 0 []}';
RFBHX07={'mo' 'RFBHX07' 0 []}';
RFBHX08={'mo' 'RFBHX08' 0 []}';
RFBHX09={'mo' 'RFBHX09' 0 []}';
RFBHX10={'mo' 'RFBHX10' 0 []}';
RFBHX11={'mo' 'RFBHX11' 0 []}';
RFBHX12={'mo' 'RFBHX12' 0 []}';
RFBHX13={'mo' 'RFBHX13' 0 []}';
RFBHX14={'mo' 'RFBHX14' 0 []}';
RFBHX15={'mo' 'RFBHX15' 0 []}';
RFBHX16={'mo' 'RFBHX16' 0 []}';
RFBHX17={'mo' 'RFBHX17' 0 []}';
RFBHX18={'mo' 'RFBHX18' 0 []}';
RFBHX19={'mo' 'RFBHX19' 0 []}';
RFBHX20={'mo' 'RFBHX20' 0 []}';
RFBHX21={'mo' 'RFBHX21' 0 []}';
RFBHX22={'mo' 'RFBHX22' 0 []}';
RFBHX23={'mo' 'RFBHX23' 0 []}';
RFBHX24={'mo' 'RFBHX24' 0 []}';
RFBHX25={'mo' 'RFBHX25' 0 []}';
RFBHX26={'mo' 'RFBHX26' 0 []}';
RFBHX27={'mo' 'RFBHX27' 0 []}';
RFBHX28={'mo' 'RFBHX28' 0 []}';
RFBHX29={'mo' 'RFBHX29' 0 []}';
RFBHX30={'mo' 'RFBHX30' 0 []}';
RFBHX31={'mo' 'RFBHX31' 0 []}';
RFBHX32={'mo' 'RFBHX32' 0 []}';
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
BPMUE1H={'mo' 'BPMUE1H' 0 []}';
BPMUE2H={'mo' 'BPMUE2H' 0 []}';
BPMUE3H={'mo' 'BPMUE3H' 0 []}';
BPMQDH={'mo' 'BPMQDH' 0 []}';
BPMDDH={'mo' 'BPMDDH' 0 []}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
BPMDL51={'mo' 'BPMDL51' 0 []}';
BPMDL52={'mo' 'BPMDL52' 0 []}';
BPMDL53={'mo' 'BPMDL53' 0 []}';
BPMUM1S={'mo' 'BPMUM1S' 0 []}';
BPMUM2S={'mo' 'BPMUM2S' 0 []}';
BPMUM3S={'mo' 'BPMUM3S' 0 []}';
BPMUM4S={'mo' 'BPMUM4S' 0 []}';
RFB01S={'mo' 'RFB01S' 0 []}';
RFB02S={'mo' 'RFB02S' 0 []}';
% ------------------------------------------------------------------------------
% SXR self-seeding section BPMs (initially stripline)
% ------------------------------------------------------------------------------
DPMSSS01={'dr' '' LRFBu []}';
BPMSSS02={'mo' 'BPMSSS02' 0 []}';
DPMSSS03={'dr' '' LRFBu []}';
DPMSSS04={'dr' '' LRFBu []}';
DPMSSS05={'dr' '' LRFBu []}';
DPMSSS06={'dr' '' LRFBu []}';
DPMSSS07={'dr' '' LRFBu []}';
BPMSSS08={'mo' 'BPMSSS08' 0 []}';
DPMSSS09={'dr' '' LRFBu []}';
DPMSSS10={'dr' '' LRFBu []}';
DPMSSS11={'dr' '' LRFBu []}';
DPMSSS12={'dr' '' LRFBu []}';
DPMSSS13={'dr' '' LRFBu []}';
BPMSSS14={'mo' 'BPMSSS14' 0 []}';
BPMSSS15={'mo' 'BPMSSS15' 0 []}';
DPMSSS16={'dr' '' LRFBu []}';
DPMSSS17={'dr' '' LRFBu []}';
DPMSSS18={'dr' '' LRFBu []}';
BPMSSS19={'mo' 'BPMSSS19' 0 []}';
DPMSSS20={'dr' '' LRFBu []}';
DPMSSS21={'dr' '' LRFBu []}';
RFBSSS22={'mo' 'RFBSSS22' 0 []}';% last quad before SXR has an RF BPM
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% undulator BPMs
RFBSX00={'mo' 'RFBSX00' 0 []}';
RFBSX01={'mo' 'RFBSX01' 0 []}';
RFBSX02={'mo' 'RFBSX02' 0 []}';
RFBSX03={'mo' 'RFBSX03' 0 []}';
RFBSX04={'mo' 'RFBSX04' 0 []}';
RFBSX05={'mo' 'RFBSX05' 0 []}';
RFBSX06={'mo' 'RFBSX06' 0 []}';
RFBSX07={'mo' 'RFBSX07' 0 []}';
RFBSX08={'mo' 'RFBSX08' 0 []}';
RFBSX09={'mo' 'RFBSX09' 0 []}';
RFBSX10={'mo' 'RFBSX10' 0 []}';
RFBSX11={'mo' 'RFBSX11' 0 []}';
RFBSX12={'mo' 'RFBSX12' 0 []}';
RFBSX13={'mo' 'RFBSX13' 0 []}';
RFBSX14={'mo' 'RFBSX14' 0 []}';
RFBSX15={'mo' 'RFBSX15' 0 []}';
RFBSX16={'mo' 'RFBSX16' 0 []}';
RFBSX17={'mo' 'RFBSX17' 0 []}';
RFBSX18={'mo' 'RFBSX18' 0 []}';
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
BPMUE1S={'mo' 'BPMUE1S' 0 []}';
BPMUE2S={'mo' 'BPMUE2S' 0 []}';
BPMUE3S={'mo' 'BPMUE3S' 0 []}';
BPMQDS={'mo' 'BPMQDS' 0 []}';
BPMDDS={'mo' 'BPMDDS' 0 []}';
% ==============================================================================
% miscellaneous diagnostics, collimators, MARKERs, etc.
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
SEQ00={'mo' '' 0 []}';%used by RDB generation software
L0begB={'mo' '' 0 []}';
CATHODEB={'mo' 'CATHODEB' 0 []}';
ZLIN200={'mo' '' 0 []}';%gun cathode (Z=1001.911482)
VV01B={'mo' '' 0 []}';%vacuum valve near gun
AM00B={'mo' 'AM00B' 0 []}';%gun laser normal incidence mirror
IM01B={'mo' 'IM01B' 0 []}';%L0 bunch charge monitor (toroid)
SEQ01={'mo' '' 0 []}';%used by RDB generation software
YAG02B={'mo' 'YAG02B' 0 []}';%gun
FLNGA1B={'mo' '' 0 []}';%upstream face of L0a entrance flange
DLFDAB={'mo' '' 0 []}';%dual-feed input coupler location for L0a structure
L0AmidB={'mo' '' 0 []}';
OUTCPAB={'mo' '' 0 []}';%output coupler location for L0a structure
FLNGA2B={'mo' '' 0 []}';%downstream face of L0a exit flange
L0AwakeB={'mo' '' 0 []}';
L0A_exit={'mo' '' 0 []}';%exit of L0a where Parmela output starts
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
GSPECBEG={'mo' '' 0 []}';
YAGG1B={'mo' 'YAGG1B' 0 []}';%spectrometer screen
FCG1B={'mo' 'FCG1B' 0 []}';%Faraday cup w/screen
GSPECEND={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
L0BbegB={'mo' '' 0 []}';
YAG03B={'mo' 'YAG03B' 0 []}';%after L0a (~60 MeV) - center of YAG crystal
PH01B={'mo' 'PH01B' 0 []}';%phase measurement cavity between L0a and L0b
FLNGB1B={'mo' '' 0 []}';%upstream face of L0b entrance flange
DLFDBB={'mo' '' 0 []}';%dual-feed input coupler location for L0b structure
L0BmidB={'mo' '' 0 []}';
OUTCPBB={'mo' '' 0 []}';%output coupler location for L0b structure
FLNGB2B={'mo' '' 0 []}';%downstream face of L0b exit flange
L0endB={'mo' '' 0 []}';
EMATB={'mo' '' 0 []}';%ELEGANT will remove energy error in DL1 bends here
DL1begB={'mo' '' 0 []}';
IM02B={'mo' 'IM02B' 0 []}';%L0 bunch charge monitor (toroid)
VV02B={'mo' '' 0 []}';%vacuum valve in injector
LHbegB={'mo' '' 0 []}';
OTRH1B={'mo' 'OTRH1B' 0 []}';%upstream laser heater OTR screen
HTRUNDB={'mo' 'HTRUNDB' 0 []}';
OTRH2B={'mo' 'OTRH2B' 0 []}';%downstream laser heater OTR screen
LHendB={'mo' '' 0 []}';
OTR1B={'mo' 'OTR1B' 0 []}';%DL1 emittance
VV03B={'mo' '' 0 []}';%vacuum valve in injector
RST1B={'mo' 'RST1B' 0 []}';%radiation stopper near WS02B in injector
WS02B={'mo' 'WS02B' 0 []}';%DL1 emittance
MRK0B={'mo' '' 0 []}';
OTR2B={'mo' 'OTR2B' 0 []}';%DL1 emittance
OTR3B={'mo' 'OTR3B' 0 []}';%DL1 emittance
VV04B={'mo' '' 0 []}';%vacuum valve in injector
SEQ02={'mo' '' 0 []}';%used by RDB generation software
OTR4B={'mo' 'OTR4B' 0 []}';%DL1 slice and projected energy spread
CNT0B={'mo' '' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
SEQ03={'mo' '' 0 []}';%used by RDB generation software
ZLIN201={'mo' '' 0 []}';%linac injection (Z=1017.862332)
IM03B={'mo' 'IM03B' 0 []}';%DL1 bunch charge monitor (toroid)
DL1endB={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
SPECBEG={'mo' '' 0 []}';
VVS1B={'mo' '' 0 []}';%vacuum valve
YAGS1B={'mo' 'YAGS1B' 0 []}';%YAG-screen (center of YAG crystal)
IMS1B={'mo' 'IMS1B' 0 []}';
YAGS2B={'mo' 'YAGS2B' 0 []}';%YAG-screen (center of YAG crystal)
SDMPB={'mo' 'SDMPB' 0 []}';%dump (exact location? - 11/09/05)
SPECEND={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
CE11B={'dr' 'CE11B' 0 []}';%movable BC1 X jaw energy collimator
ZLIN203={'mo' '' 0 []}';%exit of 11-1d (Z=1028.16743)
BC1mrkB={'mo' '' 0 []}';
VVX1B={'mo' '' 0 []}';%vacuum valve
XbegB={'mo' '' 0 []}';
XendB={'mo' '' 0 []}';
VVX2B={'mo' '' 0 []}';%vacuum valve
IMBC1iB={'mo' 'IMBC1iB' 0 []}';%BC1 input toriod (comparator with IMBC1oB)
BC1begB={'mo' '' 0 []}';
OTR11B={'mo' 'OTR11B' 0 []}';%BC1 energy spread
CNT1B={'mo' '' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC1endB={'mo' '' 0 []}';
BL11B={'mo' 'BL11B' 0 []}';%BC1+ (CSR-based relative bunch length monitor)
IMBC1oB={'mo' 'IMBC1oB' 0 []}';%BC1 output toroid (comparator with IMBC1iB)
BL12B={'mo' 'BL12B' 0 []}';%BC1+ (ceramic gap-based relative bunch length monitor)
WS11B={'mo' 'WS11B' 0 []}';%BC1+ emittance
WS12B={'mo' 'WS12B' 0 []}';%BC1+ emittance
OTR12B={'mo' 'OTR12B' 0 []}';%BC1 emittance
PH02B={'mo' 'PH02B' 0 []}';%phase measurement RF cavity after BC1
WS13B={'mo' 'WS13B' 0 []}';%BC1+ emittance
TD11B={'mo' 'TD11B' 0 []}';%BC1+ insertable block
SEQ04={'mo' '' 0 []}';%used by RDB generation software
BC1finB={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% BC2
% ------------------------------------------------------------------------------
CE21B={'dr' 'CE21B' 0 []}';%movable BC2 X jaw energy collimator
ZLIN208={'mo' '' 0 []}';%exit of 14-4d (Z=1370.0096)
BC2mrkB={'mo' '' 0 []}';
DWS24B={'mo' '' 0 []}';%possible wire-scanner location
IMBC2iB={'mo' 'IMBC2iB' 0 []}';%BC2 input toroid (comparator with IMBC2o)
VV21B={'mo' '' 0 []}';%vacuum valve in front of BC2
BC2begB={'mo' '' 0 []}';
OTR21B={'mo' 'OTR21B' 0 []}';%BC2 energy spread
CNT2B={'mo' '' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC2endB={'mo' '' 0 []}';
BL21B={'mo' 'BL21B' 0 []}';%BC2+ (CSR-based relative bunch length monitor)
VV22B={'mo' '' 0 []}';%vacuum valve after BC2
BC2finB={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% sector 20 vertical dogleg to bypass line
% ------------------------------------------------------------------------------
S0={'mo' '' 0 []}';
M20_5={'mo' '' 0 []}';%20-5: Q20501-exit + 27 mm ... Z=1979.777600
SEQ05={'mo' '' 0 []}';%used by RDB generation software
CNT3A={'mo' '' 0 []}';
WSBD={'mo' 'WSBD' 0 []}';
WALL20beg={'mo' '' 0 []}';
WALL20end={'mo' '' 0 []}';
CNT3B={'mo' '' 0 []}';
S1={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% bypass line
% ------------------------------------------------------------------------------
CEBD={'dr' 'CEBD' 0.08 []}';% energy coll in bypass dog-leg (YSIZE is half-gap)
CX23={'dr' 'CX23' 0.08 []}';% 3 mm half-gap in X in bypass-line
CY24={'dr' 'CY24' 0.08 []}';% 3 mm half-gap in Y in bypass-line 
CX27={'dr' 'CX27' 0.08 []}';% 3 mm half-gap in X in bypass-line
CY28={'dr' 'CY28' 0.08 []}';% 3 mm half-gap in Y in bypass-line 
S2={'mo' '' 0 []}';
Q1MRK={'mo' '' 0 []}';%Q285330T FODO quad center ... Z=2270.531303
WSBP1={'mo' 'WSBP1' 0 []}';
WSBP2={'mo' 'WSBP2' 0 []}';
WSBP3={'mo' 'WSBP3' 0 []}';
WSBP4={'mo' 'WSBP4' 0 []}';
SEQ06={'mo' '' 0 []}';%used by RDB generation software
MUWALL={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% vertical and horizontal bend systems
% ------------------------------------------------------------------------------
BSYEND={'mo' '' 0 []}';%FFTB side of muon plug wall ... Z=3224.022426
CNTV={'mo' '' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
S4={'mo' '' 0 []}';
S5={'mo' '' 0 []}';
MM1={'mo' '' 0 []}';%entrance to hor. bend cell
LOBETA={'mo' '' 0 []}';%point where etaX high and betaX is low
CNT6={'mo' '' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
T1={'mo' '' 0 []}';%for fitting
T2={'mo' '' 0 []}';%for fitting
SEQ07={'mo' '' 0 []}';%used by RDB generation software
T3={'mo' '' 0 []}';%for fitting
S6={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
% - CX41    = 2.2 mm half-gap in X and Y here (beta_max=67 m) keeps worst case
%             radius: r = sqrt(x^2+y^2) < 2 mm in undulator (beta_max=35 m)
% - PCMUONH = muon scattering collimator after pre-undulator tune-up dump
%             (ID from Rago: 7/18/08)
% ------------------------------------------------------------------------------
CEDL41={'dr' 'CEDL41' 0.08 []}';% XSIZE (or YSIZE) is the collimator half-gap
CEDL42={'dr' 'CEDL42' 0.08 []}';% XSIZE (or YSIZE) is the collimator half-gap
CX41={'dr' 'CX41' 0.08 []}';
CY42={'dr' 'CY42' 0.08 []}';
CX45={'dr' 'CX45' 0.08 []}';
CY46={'dr' 'CY46' 0.08 []}';
PCMUONH={'dr' 'PCMUONH' 1.1684 []}';
MM2={'mo' '' 0 []}';
IM41={'mo' 'IM41' 0 []}';%LTU: upstr. of BX41 (comparator with IM46)
IM46={'mo' 'IM46' 0 []}';%LTU: dnstr. of BX44 (comparator with IM41)
WS41={'mo' 'WS41' 0 []}';%LTU emittance
WS42={'mo' 'WS42' 0 []}';%LTU emittance
OTR43={'mo' 'OTR43' 0 []}';%LTU slice emittance (~90 deg from TCAV3)
WS43={'mo' 'WS43' 0 []}';%LTU emittance
WS44={'mo' 'WS44' 0 []}';%LTU emittance
IMUNDIH={'mo' 'IMUNDIH' 0 []}';%FEL-undulator input toroid (comparator with IMUNDOH)
RWWAKEAl={'mo' '' 0 []}';%will be resistive wall wake of aluminum in ELEGANT
TDUNDH={'mo' 'TDUNDH' 0 []}';%LTU insertable block at und. extension entrance (w/ screen)
VVUNDH={'mo' '' 0 []}';%new vacuum valve just upbeam of undulator
MM3={'mo' '' 0 []}';
PFILT1b={'mo' '' 0 []}';
S7={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% place holder for hard X-ray self-seeding
% ------------------------------------------------------------------------------
HSSSTART={'mo' '' 0 []}';%start of hard X-ray self-seeding system
HXRSTART={'mo' '' 0 []}';%start of undulator system
MUQH={'mo' '' 0 []}';
HXRTERM={'mo' '' 0 []}';%~end of undulator system
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
LPCPM   = 0.076;
PCPM0H={'dr' 'PCPM0H' LPCPM []}';%added Sep. 13, 2007 per J. Langton
PCPM1LH={'dr' 'PCPM1LH' LPCPM/cos(3*ABdm0) []}';
PCPM2LH={'dr' 'PCPM2LH' LPCPM/cos(3*ABdm0) []}';
UEbegH={'mo' '' 0 []}';
VV36H={'mo' '' 0 []}';%treaty-point vacuum valve just downbeam of undulator
IMUNDOH={'mo' 'IMUNDOH' 0 []}';%FEL-undulator output toroid (comparator with IMUNDIH)
BTM0H={'mo' 'BTM0H' 0 []}';%Burn-Through-Monitor behind PCPM0H
TRUE1H={'mo' 'TRUE1H' 0 []}';%Be foil inserter (THz)
UEendH={'mo' '' 0 []}';
DLSTARTH={'mo' '' 0 []}';%start of dumpline: Z=3734.383707 (Z'=686.387007 m, X'=-1.250000 m, Y'=-0.895305 m)
VV37H={'mo' '' 0 []}';%vac. valve in dumpline
IMBCS3H={'mo' 'IMBCS3H' 0 []}';%pre-dump magnet toroid with >42-mm ID stay-clear (comparator with IMBCS4H)
SEQ08={'mo' '' 0 []}';%used by RDB generation software
BTM1LH={'mo' 'BTM1LH' 0 []}';%Burn-Through-Monitor behind PCPM1LH
IMDUMPH={'mo' 'IMDUMPH' 0 []}';%in dump line after Y-bends and quad (comparator with IMUNDOH)
BTM2LH={'mo' 'BTM2LH' 0 []}';%Burn-Through-Monitor behind PCPM2LH
IMBCS4H={'mo' 'IMBCS4H' 0 []}';%in dump line, after Y-bends, with >48-mm ID stay-clear (comparator with IMBCS3H)
OTRDMPH={'mo' 'OTRDMPH' 0 []}';%Dump screen
WSDUMPH={'mo' 'WSDUMPH' 0 []}';
DUMPFACEH={'mo' 'DUMPFACEH' 0 []}';%entrance face of HXR e- dump
DMPendH={'mo' '' 0 []}';
EOLH={'mo' '' 0 []}';%ref. near BTM after H-dump: Z=? (Z'=? m, X'=? m, Y'=? m)
BTMDUMPH={'mo' 'BTMDUMPH' 0 []}';%Burn-Through-Monitor for HXR e- dump
% ------------------------------------------------------------------------------
% HXR safety dump line
% ------------------------------------------------------------------------------
PCPM1H={'dr' 'PCPM1H' LPCPM []}';
PCPM2H={'dr' 'PCPM2H' LPCPM []}';
SFTBEGH={'mo' '' 0 []}';%start of HXR safety dump (entrance of turned-off BYD1H)
VV38H={'mo' '' 0 []}';%vac. valve in HXR safety-dump line
BTM1H={'mo' 'BTM1H' 0 []}';%Burn-Through-Monitor behind PCPM1H
ST1H={'mo' 'ST1H' 0 []}';%X-ray insertable stopper (was "ST2" in ~2007)
BTMST1H={'mo' 'BTMST1H' 0 []}';%Burn-Through-Monitor behind ST1H
BTM2H={'mo' 'BTM2H' 0 []}';%Burn-Through-Monitor behind PCPM2H
SFTDMPH={'mo' 'SFTDMPH' 0 []}';%safety dump when BYDH's trip: Z=NA (Z'=719.120100 m, X'=-1.517688 m, Y'=-0.895305 m)
BTMSFTH={'mo' 'BTMSFTH' 0 []}';%Burn-Through-Monitor behind HXR saftey-dump
DMPendHS={'mo' '' 0 []}';
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
% - PCMUONS = muon scattering collimator after pre-undulator tune-up dump
%             (ID from Rago: 7/18/08)
% ------------------------------------------------------------------------------
PCMUONS={'dr' 'PCMUONS' 1.1684 []}';
LTUSPLIT={'mo' '' 0 []}';%split point for LTUH and LTUS
SEQ09={'mo' '' 0 []}';%used by RDB generation software
IMUNDIS={'mo' 'IMUNDIS' 0 []}';%FEL-undulator input toroid (comparator with IMUNDOS)
TDUNDS={'mo' 'TDUNDS' 0 []}';%LTU insertable block at und. extension entrance (w/ screen)
VVUNDS={'mo' '' 0 []}';%new vacuum valve just upbeam of undulator
MM3S={'mo' '' 0 []}';
WSLTUS1={'mo' 'WSLTUS1' 0 []}';%LTUS diagnostic wire scanner
WSLTUS2={'mo' 'WSLTUS2' 0 []}';%LTUS diagnostic wire scanner
WSLTUS3={'mo' 'WSLTUS3' 0 []}';%LTUS diagnostic wire scanner
% ------------------------------------------------------------------------------
% place holder for soft X-ray self-seeding
% ------------------------------------------------------------------------------
SSSSTART={'mo' '' 0 []}';%start of soft X-ray self-seeding system
SXRSTART={'mo' '' 0 []}';%start of undulator system
MUQS={'mo' '' 0 []}';
SXRTERM={'mo' '' 0 []}';%~end of undulator system
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
PCPM0S={'dr' 'PCPM0S' LPCPM []}';%added Sep. 13, 2007 per J. Langton
PCPM1LS={'dr' 'PCPM1LS' LPCPM/cos(3*ABdm0) []}';
PCPM2LS={'dr' 'PCPM2LS' LPCPM/cos(3*ABdm0) []}';
UEbegS={'mo' '' 0 []}';
VV36S={'mo' '' 0 []}';%treaty-point vacuum valve just downbeam of undulator
IMUNDOS={'mo' 'IMUNDOS' 0 []}';%FEL-undulator output toroid (comparator with IMUNDIS)
BTM0S={'mo' 'BTM0S' 0 []}';%Burn-Through-Monitor behind PCPM0S
TRUE1S={'mo' 'TRUE1S' 0 []}';%Be foil inserter (THz)
UEendS={'mo' '' 0 []}';
DLSTARTS={'mo' '' 0 []}';%start of dumpline: Z=3734.383707 (Z'=686.387007 m, X'=-1.250000 m, Y'=-0.895305 m)
VV37S={'mo' '' 0 []}';%vac. valve in dumpline
IMBCS3S={'mo' 'IMBCS3S' 0 []}';%pre-dump magnet toroid with >42-mm ID stay-clear (comparator with IMBCS4S)
SEQ10={'mo' '' 0 []}';%used by RDB generation software
BTM1LS={'mo' 'BTM1LS' 0 []}';%Burn-Through-Monitor behind PCPM1LS
IMDUMPS={'mo' 'IMDUMPS' 0 []}';%in dump line after Y-bends and quad (comparator with IMUNDOS)
BTM2LS={'mo' 'BTM2LS' 0 []}';%Burn-Through-Monitor behind PCPM2LS
IMBCS4S={'mo' 'IMBCS4S' 0 []}';%in dump line, after Y-bends, with >48-mm ID stay-clear (comparator with IMBCS3S)
OTRDMPS={'mo' 'OTRDMPS' 0 []}';%Dump screen
WSDUMPS={'mo' 'WSDUMPS' 0 []}';
DUMPFACES={'mo' 'DUMPFACES' 0 []}';%entrance face of SXR e- dump
DMPendS={'mo' '' 0 []}';
EOLS={'mo' '' 0 []}';%ref. near BTM after S-dump: Z=? (Z'=? m, X'=? m, Y'=? m)
BTMDUMPS={'mo' 'BTMDUMPS' 0 []}';%Burn-Through-Monitor for SXR e- dump
% ------------------------------------------------------------------------------
% SXR safety dump line
% ------------------------------------------------------------------------------
PCPM1S={'dr' 'PCPM1S' LPCPM []}';
PCPM2S={'dr' 'PCPM2S' LPCPM []}';
SFTBEGS={'mo' '' 0 []}';%start of SXR safety dump (entrance of turned-off BYD1S)
VV38S={'mo' '' 0 []}';%vac. valve in SXR safety-dump line
BTM1S={'mo' 'BTM1S' 0 []}';%Burn-Through-Monitor behind PCPM1S
ST1S={'mo' 'ST1S' 0 []}';%X-ray insertable stopper (was "ST2" in ~2007)
BTMST1S={'mo' 'BTMST1S' 0 []}';%Burn-Through-Monitor behind ST1S
BTM2S={'mo' 'BTM2S' 0 []}';%Burn-Through-Monitor behind PCPM2S
SFTDMPS={'mo' 'SFTDMPS' 0 []}';%safety dump when BYDS's trip: Z=NA (Z'=719.120100 m, X'=-1.517688 m, Y'=-0.895305 m)
BTMSFTS={'mo' 'BTMSFTS' 0 []}';%Burn-Through-Monitor behind SXR saftey-dump
DMPendSS={'mo' '' 0 []}';
% ==============================================================================
% load linac lattice definition files
% ==============================================================================
% ==============================================================================
% 29-OCT-2010, M. Woodley
%    LCLSII
% ------------------------------------------------------------------------------
% ==============================================================================
% accelerating structures
% ------------------------------------------------------------------------------
% the L1 S-band linac consists of: 1 x 9.4' structure @ 50% power
%                                  1 x 9.4' structure @ 25% power
%                                  1 x  10' structure @ 25% power
% ------------------------------------------------------------------------------
K11_1b1={'lc' 'K11_1b' 0.453432 [SbandF P50*gradL1*0.453432 PhiL1*TWOPI]}';
K11_1b2={'lc' 'K11_1b' 2.415768 [SbandF P50*gradL1*2.415768 PhiL1*TWOPI]}';
K11_1c1={'lc' 'K11_1c' 0.4534458 [SbandF P25*gradL1*0.4534458 PhiL1*TWOPI]}';
K11_1c2={'lc' 'K11_1c' 2.4157542 [SbandF P25*gradL1*2.4157542 PhiL1*TWOPI]}';
K11_1d1={'lc' 'K11_1d' 0.3693348 [SbandF P25*gradL1*0.3693348 PhiL1*TWOPI]}';
K11_1d2={'lc' 'K11_1d' 2.0072382 [SbandF P25*gradL1*2.0072382 PhiL1*TWOPI]}';
K11_1d3={'lc' 'K11_1d' 0.2875716 [SbandF P25*gradL1*0.2875716 PhiL1*TWOPI]}';
K11_1d4={'lc' 'K11_1d' 0.3799554 [SbandF P25*gradL1*0.3799554 PhiL1*TWOPI]}';
% ==============================================================================
% QUADs
% ------------------------------------------------------------------------------
KQL1 = 3.789198342593;
QFL1={'qu' 'QFL1' LQE/2 +KQL1}';
QDL1={'qu' 'QDL1' LQE/2 -KQL1}';
KQA11 = -KQL1;
KQA12 =  1.872642666562;
QA11B={'qu' 'QA11B' LQx/2 KQA11}';
QA12B={'qu' 'QA12B' LQx/2 KQA12}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
LDAQA   = 0.03345;
dz_QA11 = 3.42E-3;
DAQA={'dr' '' LDAQA []}';
DAQA1={'dr' '' LDAQA+dz_QA11 []}';
DAQA2={'dr' '' LDAQA-dz_QA11 []}';
DAQA3={'dr' '' LDAQA []}';
DAQA4={'dr' '' LDAQA []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC11B={'mo' 'XC11B' 0 []}';
XCA11B={'mo' 'XCA11B' 0 []}';
XCA12B={'mo' 'XCA12B' 0 []}';
XC11202={'mo' 'XC11202' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC11B={'mo' 'YC11B' 0 []}';
YCA11B={'mo' 'YCA11B' 0 []}';
YCA12B={'mo' 'YCA12B' 0 []}';
YC11203={'mo' 'YC11203' 0 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMA11B={'mo' 'BPMA11B' 0 []}';
BPMA12B={'mo' 'BPMA12B' 0 []}';
% ==============================================================================
% miscellaneous diagnostics, collimators, MARKERs, etc.
% ------------------------------------------------------------------------------
ZLIN202={'mo' '' 0 []}';%entrance to 11-1b (Z=1019.03513)
L1begB={'mo' '' 0 []}';
L1endB={'mo' '' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
L1c=[D9,DAQA,QFL1,QFL1,DAQA,D9,DAQA,QDL1,QDL1,DAQA];
SC11=[XC11B,YC11B];
SCA11=[XCA11B,YCA11B];
SCA12=[XCA12B,YCA12B];
K11_1b=[K11_1b1,SC11,K11_1b2];
K11_1c=[K11_1c1,SCA11,K11_1c2];
K11_1d=[K11_1d1,SCA12,K11_1d2,YC11203,K11_1d3,XC11202,K11_1d4];
L1=[ZLIN202,L1begB,K11_1b,DAQA1,QA11B,BPMA11B,QA11B,DAQA2,K11_1c,DAQA3,QA12B,BPMA12B,QA12B,DAQA4,K11_1d,L1endB];
% ==============================================================================

%CALL, FILENAME="LCLSII_L1e.xsif" 
% ==============================================================================
% 29-OCT-2010, M. Woodley
%    LCLSII
% ------------------------------------------------------------------------------
% ==============================================================================
% accelerating structures
% ------------------------------------------------------------------------------
% the L2 S-band linac consists of: 90 x  10' structure @ 25% power
%                                   1 x  10' structure @ 50% power
%                                   4 x 9.4' structure @ 25% power
%                                   8 x   7' structure @ 25% power
% ------------------------------------------------------------------------------
K11_3b={'lc' 'K11_3b' 3.0441 [SbandF P50*gradL2*3.0441 PhiL2*TWOPI]}';
K11_3c={'lc' 'K11_3c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_3d={'lc' 'K11_3d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_4a1={'lc' 'K11_4a' 0.3268 [SbandF P25*gradL2*0.3268 PhiL2*TWOPI]}';
K11_4a2={'lc' 'K11_4a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K11_4a3={'lc' 'K11_4a' 1.5926 [SbandF P25*gradL2*1.5926 PhiL2*TWOPI]}';
K11_4b={'lc' 'K11_4b' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K11_4c={'lc' 'K11_4c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_4d={'lc' 'K11_4d' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K11_5a1={'lc' 'K11_5a' 0.6689 [SbandF P25*gradL2*0.6689 PhiL2*TWOPI]}';
K11_5a2={'lc' 'K11_5a' 2.3752 [SbandF P25*gradL2*2.3752 PhiL2*TWOPI]}';
K11_5b={'lc' 'K11_5b' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K11_5c={'lc' 'K11_5c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_5d={'lc' 'K11_5d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_6a1={'lc' 'K11_6a' 0.3280 [SbandF P25*gradL2*0.3280 PhiL2*TWOPI]}';
K11_6a2={'lc' 'K11_6a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K11_6a3={'lc' 'K11_6a' 1.5914 [SbandF P25*gradL2*1.5914 PhiL2*TWOPI]}';
K11_6b={'lc' 'K11_6b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_6c={'lc' 'K11_6c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_6d={'lc' 'K11_6d' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K11_7a1={'lc' 'K11_7a' 0.38633 [SbandF P25*gradL2*0.38633 PhiL2*TWOPI]}';
K11_7a2={'lc' 'K11_7a' 2.65777 [SbandF P25*gradL2*2.65777 PhiL2*TWOPI]}';
K11_7b={'lc' 'K11_7b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_7c={'lc' 'K11_7c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_7d={'lc' 'K11_7d' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K11_8a={'lc' 'K11_8a' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_8b={'lc' 'K11_8b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_8c={'lc' 'K11_8c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K11_8d={'lc' 'K11_8d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_1a={'lc' 'K12_1a' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_1b={'lc' 'K12_1b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_1c={'lc' 'K12_1c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_1d={'lc' 'K12_1d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_2a={'lc' 'K12_2a' 2.1694 [SbandF P25*gradL2*2.1694 PhiL2*TWOPI]}';
K12_2b={'lc' 'K12_2b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_2c={'lc' 'K12_2c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_2d={'lc' 'K12_2d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_3a1={'lc' 'K12_3a' 0.3312 [SbandF P25*gradL2*0.3312 PhiL2*TWOPI]}';
K12_3a2={'lc' 'K12_3a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K12_3a3={'lc' 'K12_3a' 2.4629 [SbandF P25*gradL2*2.4629 PhiL2*TWOPI]}';
K12_3b={'lc' 'K12_3b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_3c={'lc' 'K12_3c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_3d={'lc' 'K12_3d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_4a1={'lc' 'K12_4a' 0.3268 [SbandF P25*gradL2*0.3268 PhiL2*TWOPI]}';
K12_4a2={'lc' 'K12_4a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K12_4a3={'lc' 'K12_4a' 2.4673 [SbandF P25*gradL2*2.4673 PhiL2*TWOPI]}';
K12_4b={'lc' 'K12_4b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_4c={'lc' 'K12_4c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_4d={'lc' 'K12_4d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_5a1={'lc' 'K12_5a' 0.3324 [SbandF P25*gradL2*0.3324 PhiL2*TWOPI]}';
K12_5a2={'lc' 'K12_5a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K12_5a3={'lc' 'K12_5a' 2.4617 [SbandF P25*gradL2*2.4617 PhiL2*TWOPI]}';
K12_5b={'lc' 'K12_5b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_5c={'lc' 'K12_5c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_5d={'lc' 'K12_5d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_6a1={'lc' 'K12_6a' 0.3280 [SbandF P25*gradL2*0.3280 PhiL2*TWOPI]}';
K12_6a2={'lc' 'K12_6a' 0.4330 [SbandF P25*gradL2*0.4330 PhiL2*TWOPI]}';
K12_6a3={'lc' 'K12_6a' 2.2831 [SbandF P25*gradL2*2.2831 PhiL2*TWOPI]}';
K12_6b={'lc' 'K12_6b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_6c={'lc' 'K12_6c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_6d={'lc' 'K12_6d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_7a1={'lc' 'K12_7a' 0.3336 [SbandF P25*gradL2*0.3336 PhiL2*TWOPI]}';
K12_7a2={'lc' 'K12_7a' 0.3575 [SbandF P25*gradL2*0.3575 PhiL2*TWOPI]}';
K12_7a3={'lc' 'K12_7a' 2.3530 [SbandF P25*gradL2*2.3530 PhiL2*TWOPI]}';
K12_7b={'lc' 'K12_7b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_7c={'lc' 'K12_7c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_7d={'lc' 'K12_7d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_8a1={'lc' 'K12_8a' 0.3292 [SbandF P25*gradL2*0.3292 PhiL2*TWOPI]}';
K12_8a2={'lc' 'K12_8a' 0.4032 [SbandF P25*gradL2*0.4032 PhiL2*TWOPI]}';
K12_8a3={'lc' 'K12_8a' 2.3117 [SbandF P25*gradL2*2.3117 PhiL2*TWOPI]}';
K12_8b={'lc' 'K12_8b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_8c={'lc' 'K12_8c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K12_8d1={'lc' 'K12_8d' 2.3869 [SbandF P25*gradL2*2.3869 PhiL2*TWOPI]}';
K12_8d2={'lc' 'K12_8d' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K12_8d3={'lc' 'K12_8d' 0.4072 [SbandF P25*gradL2*0.4072 PhiL2*TWOPI]}';
K13_1a={'lc' 'K13_1a' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_1b={'lc' 'K13_1b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_1c={'lc' 'K13_1c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_1d={'lc' 'K13_1d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_2a1={'lc' 'K13_2a' 0.3256 [SbandF P25*gradL2*0.3256 PhiL2*TWOPI]}';
K13_2a2={'lc' 'K13_2a' 0.3846 [SbandF P25*gradL2*0.3846 PhiL2*TWOPI]}';
K13_2a3={'lc' 'K13_2a' 2.3339 [SbandF P25*gradL2*2.3339 PhiL2*TWOPI]}';
K13_2b={'lc' 'K13_2b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_2c={'lc' 'K13_2c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_2d={'lc' 'K13_2d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_3a1={'lc' 'K13_3a' 0.3312 [SbandF P25*gradL2*0.3312 PhiL2*TWOPI]}';
K13_3a2={'lc' 'K13_3a' 0.3822 [SbandF P25*gradL2*0.3822 PhiL2*TWOPI]}';
K13_3a3={'lc' 'K13_3a' 2.3307 [SbandF P25*gradL2*2.3307 PhiL2*TWOPI]}';
K13_3b={'lc' 'K13_3b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_3c={'lc' 'K13_3c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_3d={'lc' 'K13_3d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_4a1={'lc' 'K13_4a' 0.3268 [SbandF P25*gradL2*0.3268 PhiL2*TWOPI]}';
K13_4a2={'lc' 'K13_4a' 0.4501 [SbandF P25*gradL2*0.4501 PhiL2*TWOPI]}';
K13_4a3={'lc' 'K13_4a' 2.2672 [SbandF P25*gradL2*2.2672 PhiL2*TWOPI]}';
K13_4b={'lc' 'K13_4b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_4c={'lc' 'K13_4c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_4d={'lc' 'K13_4d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_5a1={'lc' 'K13_5a' 0.3324 [SbandF P25*gradL2*0.3324 PhiL2*TWOPI]}';
K13_5a2={'lc' 'K13_5a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K13_5a3={'lc' 'K13_5a' 2.4617 [SbandF P25*gradL2*2.4617 PhiL2*TWOPI]}';
K13_5b={'lc' 'K13_5b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_5c={'lc' 'K13_5c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_5d={'lc' 'K13_5d' 2.8692 [SbandF P25*gradL2*2.8692 PhiL2*TWOPI]}';
K13_6a1={'lc' 'K13_6a' 0.3280 [SbandF P25*gradL2*0.3280 PhiL2*TWOPI]}';
K13_6a2={'lc' 'K13_6a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K13_6a3={'lc' 'K13_6a' 2.4661 [SbandF P25*gradL2*2.4661 PhiL2*TWOPI]}';
K13_6b={'lc' 'K13_6b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_6c={'lc' 'K13_6c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_6d={'lc' 'K13_6d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_7a1={'lc' 'K13_7a' 0.3336 [SbandF P25*gradL2*0.3336 PhiL2*TWOPI]}';
K13_7a2={'lc' 'K13_7a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K13_7a3={'lc' 'K13_7a' 2.4605 [SbandF P25*gradL2*2.4605 PhiL2*TWOPI]}';
K13_7b={'lc' 'K13_7b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_7c={'lc' 'K13_7c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_7d={'lc' 'K13_7d' 2.8692 [SbandF P25*gradL2*2.8692 PhiL2*TWOPI]}';
K13_8a1={'lc' 'K13_8a' 0.3292 [SbandF P25*gradL2*0.3292 PhiL2*TWOPI]}';
K13_8a2={'lc' 'K13_8a' 0.4064 [SbandF P25*gradL2*0.4064 PhiL2*TWOPI]}';
K13_8a3={'lc' 'K13_8a' 2.3085 [SbandF P25*gradL2*2.3085 PhiL2*TWOPI]}';
K13_8b={'lc' 'K13_8b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_8c={'lc' 'K13_8c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K13_8d1={'lc' 'K13_8d' 2.3869 [SbandF P25*gradL2*2.3869 PhiL2*TWOPI]}';
K13_8d2={'lc' 'K13_8d' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K13_8d3={'lc' 'K13_8d' 0.4072 [SbandF P25*gradL2*0.4072 PhiL2*TWOPI]}';
K14_1a={'lc' 'K14_1a' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_1b={'lc' 'K14_1b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_1c={'lc' 'K14_1c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_1d={'lc' 'K14_1d' 2.8692 [SbandF P25*gradL2*2.8692 PhiL2*TWOPI]}';
K14_2a1={'lc' 'K14_2a' 0.3256 [SbandF P25*gradL2*0.3256 PhiL2*TWOPI]}';
K14_2a2={'lc' 'K14_2a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K14_2a3={'lc' 'K14_2a' 2.4685 [SbandF P25*gradL2*2.4685 PhiL2*TWOPI]}';
K14_2b={'lc' 'K14_2b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_2c={'lc' 'K14_2c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_2d={'lc' 'K14_2d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_3a1={'lc' 'K14_3a' 0.3312 [SbandF P25*gradL2*0.3312 PhiL2*TWOPI]}';
K14_3a2={'lc' 'K14_3a' 0.4012 [SbandF P25*gradL2*0.4012 PhiL2*TWOPI]}';
K14_3a3={'lc' 'K14_3a' 2.3117 [SbandF P25*gradL2*2.3117 PhiL2*TWOPI]}';
K14_3b={'lc' 'K14_3b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_3c={'lc' 'K14_3c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_3d={'lc' 'K14_3d' 2.8692 [SbandF P25*gradL2*2.8692 PhiL2*TWOPI]}';
K14_4a1={'lc' 'K14_4a' 0.3268 [SbandF P25*gradL2*0.3268 PhiL2*TWOPI]}';
K14_4a2={'lc' 'K14_4a' 0.2500 [SbandF P25*gradL2*0.2500 PhiL2*TWOPI]}';
K14_4a3={'lc' 'K14_4a' 2.4673 [SbandF P25*gradL2*2.4673 PhiL2*TWOPI]}';
K14_4b={'lc' 'K14_4b' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_4c={'lc' 'K14_4c' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
K14_4d={'lc' 'K14_4d' 3.0441 [SbandF P25*gradL2*3.0441 PhiL2*TWOPI]}';
% ==============================================================================
% QUADs
% ------------------------------------------------------------------------------
KQ11401 =  1.003812128504 ;%matched to 45 degree L2 FODO
KQ11501 = -0.748082795139 ;%matched to 45 degree L2 FODO
KQ11601 =  0.606924213934 ;%matched to 45 degree L2 FODO
KQ11701 = -0.571584318722 ;%matched to 45 degree L2 FODO
KQ11801 =  0.588509197216;
KQ11901 = -0.567074569833;
KQ12201 =  0.573566154981;
KQ12301 = -0.594058132603;
KQ12401 =  0.577103239765;
KQ12501 = -0.577865990398;
KQ12601 =  0.578226206237;
KQ12701 = -0.578655502043;
KQ12801 =  0.600474464484;
KQ12901 = -0.57399744423 ;
KQ13201 =  0.578990855624;
KQ13301 = -0.59917264607 ;
KQ13401 =  0.580586560896;
KQ13501 = -0.580736173524;
KQ13601 =  0.580782790646;
KQ13701 = -0.580862809993;
KQ13801 =  0.602157660749;
KQ13901 = -0.575284252995;
KQ14201 =  0.580254280078;
KQ14301 = -0.608647638571 ;%matched from 45 degree L2 FODO
KQ14401 =  0.268550064096 ;%matched from 45 degree L2 FODO
Q11401={'qu' 'Q11401' LQE/2 KQ11401}';
Q11501={'qu' 'Q11501' LQE/2 KQ11501}';
Q11601={'qu' 'Q11601' LQE/2 KQ11601}';
Q11701={'qu' 'Q11701' LQE/2 KQ11701}';
Q11801={'qu' 'Q11801' LQE/2 KQ11801}';
Q11901={'qu' 'Q11901' LQE/2 KQ11901}';
Q12201={'qu' 'Q12201' LQE/2 KQ12201}';
Q12301={'qu' 'Q12301' LQE/2 KQ12301}';
Q12401={'qu' 'Q12401' LQE/2 KQ12401}';
Q12501={'qu' 'Q12501' LQE/2 KQ12501}';
Q12601={'qu' 'Q12601' LQE/2 KQ12601}';
Q12701={'qu' 'Q12701' LQE/2 KQ12701}';
Q12801={'qu' 'Q12801' LQE/2 KQ12801}';
Q12901={'qu' 'Q12901' LQE/2 KQ12901}';
Q13201={'qu' 'Q13201' LQE/2 KQ13201}';
Q13301={'qu' 'Q13301' LQE/2 KQ13301}';
Q13401={'qu' 'Q13401' LQE/2 KQ13401}';
Q13501={'qu' 'Q13501' LQE/2 KQ13501}';
Q13601={'qu' 'Q13601' LQE/2 KQ13601}';
Q13701={'qu' 'Q13701' LQE/2 KQ13701}';
Q13801={'qu' 'Q13801' LQE/2 KQ13801}';
Q13901={'qu' 'Q13901' LQE/2 KQ13901}';
Q14201={'qu' 'Q14201' LQE/2 KQ14201}';
Q14301={'qu' 'Q14301' LQE/2 KQ14301}';
Q14401={'qu' 'Q14401' LQE/2 KQ14401}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
DAA7a={'dr' '' 0.2511 []}';
DAA7b={'dr' '' 0.4238 []}';
DAA7c={'dr' '' LDAA7-(DAA7a{3}+DAA7b{3}) []}';
DAA7d={'dr' '' 0.36121 []}';
DAA7e={'dr' '' LDAA7-DAA7d{3} []}';
DAA7f={'dr' '' 0.34 []}';
DAA7g={'dr' '' 0.2921 []}';
DAA7h={'dr' '' LDAA7-(DAA7f{3}+DAA7g{3}) []}';
DAQ4a={'dr' '' 0.84513 []}';
DAQ4b={'dr' '' 0.27622 []}';
DAQ4c={'dr' '' LDAQ4-(DAQ4a{3}+DAQ4b{3}) []}';
DAA7i={'dr' '' 0.32195 []}';
DAA7j={'dr' '' 0.2794 []}';
DAA7k={'dr' '' LDAA7-(DAA7i{3}+DAA7j{3}) []}';
DAA9a={'dr' '' LDAA9/2 []}';
DAA9b={'dr' '' LDAA9/2 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC11402={'mo' 'XC11402' 0 []}';
XC11502={'mo' 'XC11502' 0 []}';
XC11602={'mo' 'XC11602' 0 []}';
XC11702={'mo' 'XC11702' 0 []}';
XC11802={'mo' 'XC11802' 0 []}';
XC11900={'mo' 'XC11900' 0 []}';
XC12202={'mo' 'XC12202' 0 []}';
XC12302={'mo' 'XC12302' 0 []}';
XC12402={'mo' 'XC12402' 0 []}';
XC12502={'mo' 'XC12502' 0 []}';
XC12602={'mo' 'XC12602' 0 []}';
XC12702={'mo' 'XC12702' 0 []}';
XC12802={'mo' 'XC12802' 0 []}';
XC12900={'mo' 'XC12900' 0 []}';
XC13202={'mo' 'XC13202' 0 []}';
XC13302={'mo' 'XC13302' 0 []}';
XC13402={'mo' 'XC13402' 0 []}';
XC13502={'mo' 'XC13502' 0 []}';
XC13602={'mo' 'XC13602' 0 []}';
XC13702={'mo' 'XC13702' 0 []}';
XC13802={'mo' 'XC13802' 0 []}';
XC13900={'mo' 'XC13900' 0 []}';
XC14202={'mo' 'XC14202' 0 []}';
XC14302={'mo' 'XC14302' 0 []}';
XC14402={'mo' 'XC14402' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC11403={'mo' 'YC11403' 0 []}';
YC11503={'mo' 'YC11503' 0 []}';
YC11603={'mo' 'YC11603' 0 []}';
YC11703={'mo' 'YC11703' 0 []}';
YC11803={'mo' 'YC11803' 0 []}';
YC11900={'mo' 'YC11900' 0 []}';
YC12203={'mo' 'YC12203' 0 []}';
YC12303={'mo' 'YC12303' 0 []}';
YC12403={'mo' 'YC12403' 0 []}';
YC12503={'mo' 'YC12503' 0 []}';
YC12603={'mo' 'YC12603' 0 []}';
YC12703={'mo' 'YC12703' 0 []}';
YC12803={'mo' 'YC12803' 0 []}';
YC12900={'mo' 'YC12900' 0 []}';
YC13203={'mo' 'YC13203' 0 []}';
YC13303={'mo' 'YC13303' 0 []}';
YC13403={'mo' 'YC13403' 0 []}';
YC13503={'mo' 'YC13503' 0 []}';
YC13603={'mo' 'YC13603' 0 []}';
YC13703={'mo' 'YC13703' 0 []}';
YC13803={'mo' 'YC13803' 0 []}';
YC13900={'mo' 'YC13900' 0 []}';
YC14203={'mo' 'YC14203' 0 []}';
YC14303={'mo' 'YC14303' 0 []}';
YC14403={'mo' 'YC14403' 0 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPM11401={'mo' 'BPM11401' 0 []}';
BPM11501={'mo' 'BPM11501' 0 []}';
BPM11601={'mo' 'BPM11601' 0 []}';
BPM11701={'mo' 'BPM11701' 0 []}';
BPM11801={'mo' 'BPM11801' 0 []}';
BPM11901={'mo' 'BPM11901' 0 []}';
BPM12201={'mo' 'BPM12201' 0 []}';
BPM12301={'mo' 'BPM12301' 0 []}';
BPM12401={'mo' 'BPM12401' 0 []}';
BPM12501={'mo' 'BPM12501' 0 []}';
BPM12601={'mo' 'BPM12601' 0 []}';
BPM12701={'mo' 'BPM12701' 0 []}';
BPM12801={'mo' 'BPM12801' 0 []}';
BPM12901={'mo' 'BPM12901' 0 []}';
BPM13201={'mo' 'BPM13201' 0 []}';
BPM13301={'mo' 'BPM13301' 0 []}';
BPM13401={'mo' 'BPM13401' 0 []}';
BPM13501={'mo' 'BPM13501' 0 []}';
BPM13601={'mo' 'BPM13601' 0 []}';
BPM13701={'mo' 'BPM13701' 0 []}';
BPM13801={'mo' 'BPM13801' 0 []}';
BPM13901={'mo' 'BPM13901' 0 []}';
BPM14201={'mo' 'BPM14201' 0 []}';
BPM14301={'mo' 'BPM14301' 0 []}';
BPM14401={'mo' 'BPM14401' 0 []}';
% ==============================================================================
% miscellaneous diagnostics, collimators, MARKERs, etc.
% ------------------------------------------------------------------------------
L2begB={'mo' '' 0 []}';
ZLIN204={'mo' '' 0 []}';%entrance to 11-3b (Z=1043.7329)
LI11beg={'mo' '' 0 []}';
WS11444={'mo' 'WS11444' 0 []}';%existing
WS11614={'mo' 'WS11614' 0 []}';%existing
WS11644={'mo' 'WS11644' 0 []}';%existing
LI11end={'mo' '' 0 []}';
ZLIN205={'mo' '' 0 []}';%entrance to 12-1a (Z=1117.6000)
LI12beg={'mo' '' 0 []}';
LI12end={'mo' '' 0 []}';
ZLIN206={'mo' '' 0 []}';%entrance to 13-1a (Z=1219.2000)
LI13beg={'mo' '' 0 []}';
WS13544={'mo' 'WS13544' 0 []}';%new compact "Frisch-type"
WS13744={'mo' 'WS13744' 0 []}';%new compact "Frisch-type"
LI13end={'mo' '' 0 []}';
ZLIN207={'mo' '' 0 []}';%entrance to 14-1a (Z=1320.8000)
LI14beg={'mo' '' 0 []}';
WS14144={'mo' 'WS14144' 0 []}';%new compact "Frisch-type"
WS14344={'mo' 'WS14344' 0 []}';%new compact "Frisch-type"
L2endB={'mo' '' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K11_4a=[K11_4a1,XC11402,K11_4a2,YC11403,K11_4a3];
K11_5a=[K11_5a1,YC11503,K11_5a2];
K11_6a=[K11_6a1,XC11602,K11_6a2,YC11603,K11_6a3];
K11_7a=[K11_7a1,XC11702,K11_7a2];
K12_3a=[K12_3a1,XC12302,K12_3a2,YC12303,K12_3a3];
K12_4a=[K12_4a1,XC12402,K12_4a2,YC12403,K12_4a3];
K12_5a=[K12_5a1,XC12502,K12_5a2,YC12503,K12_5a3];
K12_6a=[K12_6a1,XC12602,K12_6a2,YC12603,K12_6a3];
K12_7a=[K12_7a1,XC12702,K12_7a2,YC12703,K12_7a3];
K12_8a=[K12_8a1,XC12802,K12_8a2,YC12803,K12_8a3];
K12_8d=[K12_8d1,XC12900,K12_8d2,YC12900,K12_8d3];
K13_2a=[K13_2a1,XC13202,K13_2a2,YC13203,K13_2a3];
K13_3a=[K13_3a1,XC13302,K13_3a2,YC13303,K13_3a3];
K13_4a=[K13_4a1,XC13402,K13_4a2,YC13403,K13_4a3];
K13_5a=[K13_5a1,XC13502,K13_5a2,YC13503,K13_5a3];
K13_6a=[K13_6a1,XC13602,K13_6a2,YC13603,K13_6a3];
K13_7a=[K13_7a1,XC13702,K13_7a2,YC13703,K13_7a3];
K13_8a=[K13_8a1,XC13802,K13_8a2,YC13803,K13_8a3];
K13_8d=[K13_8d1,XC13900,K13_8d2,YC13900,K13_8d3];
K14_2a=[K14_2a1,XC14202,K14_2a2,YC14203,K14_2a3];
K14_3a=[K14_3a1,XC14302,K14_3a2,YC14303,K14_3a3];
K14_4a=[K14_4a1,XC14402,K14_4a2,YC14403,K14_4a3];
K11_3=[K11_3b,K11_3c,K11_3d];
K11_4=[K11_4a,DAA7,K11_4b,DAA7,K11_4c,K11_4d];
K11_5=[K11_5a,K11_5b,DAA7,K11_5c,K11_5d];
K11_6=[K11_6a,DAA7d,WS11614,DAA7e,K11_6b,K11_6c,K11_6d];
K11_7=[K11_7a,K11_7b,K11_7c,K11_7d];
K11_8=[K11_8a,K11_8b,K11_8c,K11_8d];
K12_1=[K12_1a,K12_1b,K12_1c,K12_1d];
K12_2=[K12_2a,DAA7i,XC12202,DAA7j,YC12203,DAA7k,K12_2b,K12_2c,K12_2d];
K12_3=[K12_3a,K12_3b,K12_3c,K12_3d];
K12_4=[K12_4a,K12_4b,K12_4c,K12_4d];
K12_5=[K12_5a,K12_5b,K12_5c,K12_5d];
K12_6=[K12_6a,K12_6b,K12_6c,K12_6d];
K12_7=[K12_7a,K12_7b,K12_7c,K12_7d];
K12_8=[K12_8a,K12_8b,K12_8c,K12_8d];
K13_1=[K13_1a,K13_1b,K13_1c,K13_1d];
K13_2=[K13_2a,K13_2b,K13_2c,K13_2d];
K13_3=[K13_3a,K13_3b,K13_3c,K13_3d];
K13_4=[K13_4a,K13_4b,K13_4c,K13_4d];
K13_5=[K13_5a,K13_5b,K13_5c,K13_5d];
K13_6=[K13_6a,K13_6b,K13_6c,K13_6d];
K13_7=[K13_7a,K13_7b,K13_7c,K13_7d];
K13_8=[K13_8a,K13_8b,K13_8c,K13_8d];
K14_1=[K14_1a,K14_1b,K14_1c,K14_1d];
K14_2=[K14_2a,K14_2b,K14_2c,K14_2d];
K14_3=[K14_3a,K14_3b,K14_3c,K14_3d];
K14_4=[K14_4a,K14_4b,K14_4c,K14_4d];
LI11=[ZLIN204,LI11beg,K11_3,DAQ1,Q11401,BPM11401,Q11401,DAQ2,K11_4,DAA7a,XC11502,DAA7b,WS11444,DAA7c,DAQ1,Q11501,BPM11501,Q11501,DAQ2,K11_5,DAQ1,Q11601,BPM11601,Q11601,DAQ2,K11_6,DAA7a,YC11703,DAA7b,WS11644,DAA7c,DAQ1,Q11701,BPM11701,Q11701,DAQ2,K11_7,DAA7f,XC11802,DAA7g,YC11803,DAA7h,DAQ1,Q11801,BPM11801,Q11801,DAQ2,K11_8,DAQ3,Q11901,BPM11901,Q11901,DAQ4a,XC11900,DAQ4b,YC11900,DAQ4c,LI11end];
LI12=[ZLIN205,LI12beg,K12_1,DAQ1,Q12201,BPM12201,Q12201,DAQ2,K12_2,DAQ1,Q12301,BPM12301,Q12301,DAQ2,K12_3,DAQ1,Q12401,BPM12401,Q12401,DAQ2,K12_4,DAQ1,Q12501,BPM12501,Q12501,DAQ2,K12_5,DAQ1,Q12601,BPM12601,Q12601,DAQ2,K12_6,DAQ1,Q12701,BPM12701,Q12701,DAQ2,K12_7,DAQ1,Q12801,BPM12801,Q12801,DAQ2,K12_8,DAQ3,Q12901,BPM12901,Q12901,DAQ4,LI12end];
LI13=[ZLIN206,LI13beg,K13_1,DAQ1,Q13201,BPM13201,Q13201,DAQ2,K13_2,DAQ1,Q13301,BPM13301,Q13301,DAQ2,K13_3,DAQ1,Q13401,BPM13401,Q13401,DAQ2,K13_4,DAQ1,Q13501,BPM13501,Q13501,DAQ2,K13_5,DAA9a,WS13544,DAA9b,DAQ1,Q13601,BPM13601,Q13601,DAQ2,K13_6,DAQ1,Q13701,BPM13701,Q13701,DAQ2,K13_7,DAA9a,WS13744,DAA9b,DAQ1,Q13801,BPM13801,Q13801,DAQ2,K13_8,DAQ3,Q13901,BPM13901,Q13901,DAQ4,LI13end];
LI14a=[ZLIN207,LI14beg,K14_1,DAA9a,WS14144,DAA9b,DAQ1,Q14201,BPM14201,Q14201,DAQ2,K14_2,DAQ1,Q14301,BPM14301,Q14301,DAQ2,K14_3,DAA9a,WS14344,DAA9b,DAQ1,Q14401,BPM14401,Q14401,DAQ2,K14_4];
L2=[L2begB,LI11,LI12,LI13,LI14a,L2endB];
% ==============================================================================

%CALL, FILENAME="LCLSII_L2e.xsif" 
% ==============================================================================
% 15-DEC-2010, Y. Nosochkov
%    Adjust strengths of 5 quads upstream of bypass for the longer dog-leg.
% 01-DEC-2010, Y. Nosochkov
%    Adjust strengths of 5 quads upstream of bypass.
% 29-OCT-2010, M. Woodley
%    LCLSII
% ------------------------------------------------------------------------------
% ==============================================================================
% accelerating structures
% ------------------------------------------------------------------------------
% the L3 S-band linac consists of: 172 x 10' structure @ 25% power
%                                    3 x 10' structure @ 50% power
%                                    2 x  7' structure @ 25% power
% ------------------------------------------------------------------------------
K14_7b={'lc' 'K14_7b' 3.0441 [SbandF P50*gradL3*3.0441 PhiL3*TWOPI]}';
K14_7c={'lc' 'K14_7c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K14_7d={'lc' 'K14_7d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K14_8a1={'lc' 'K14_8a' 0.3292 [SbandF P25*gradL3*0.3292 PhiL3*TWOPI]}';
K14_8a2={'lc' 'K14_8a' 0.4000 [SbandF P25*gradL3*0.4000 PhiL3*TWOPI]}';
K14_8a3={'lc' 'K14_8a' 2.3149 [SbandF P25*gradL3*2.3149 PhiL3*TWOPI]}';
K14_8b={'lc' 'K14_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K14_8c1={'lc' 'K14_8c' 2.3869 [SbandF P50*gradL3*2.3869 PhiL3*TWOPI]}';
K14_8c2={'lc' 'K14_8c' 0.2500 [SbandF P50*gradL3*0.2500 PhiL3*TWOPI]}';
K14_8c3={'lc' 'K14_8c' 0.4072 [SbandF P50*gradL3*0.4072 PhiL3*TWOPI]}';
K15_1a={'lc' 'K15_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_1b={'lc' 'K15_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_1c={'lc' 'K15_1c' 3.0441 [SbandF P50*gradL3*3.0441 PhiL3*TWOPI]}';
K15_2a1={'lc' 'K15_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K15_2a2={'lc' 'K15_2a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K15_2a3={'lc' 'K15_2a' 2.4685 [SbandF P25*gradL3*2.4685 PhiL3*TWOPI]}';
K15_2b={'lc' 'K15_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_2c={'lc' 'K15_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_2d={'lc' 'K15_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_3a1={'lc' 'K15_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K15_3a2={'lc' 'K15_3a' 0.4044 [SbandF P25*gradL3*0.4044 PhiL3*TWOPI]}';
K15_3a3={'lc' 'K15_3a' 2.3085 [SbandF P25*gradL3*2.3085 PhiL3*TWOPI]}';
K15_3b={'lc' 'K15_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_3c={'lc' 'K15_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_3d={'lc' 'K15_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_4a1={'lc' 'K15_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K15_4a2={'lc' 'K15_4a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K15_4a3={'lc' 'K15_4a' 2.4673 [SbandF P25*gradL3*2.4673 PhiL3*TWOPI]}';
K15_4b={'lc' 'K15_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_4c={'lc' 'K15_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_4d={'lc' 'K15_4d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_5a1={'lc' 'K15_5a' 0.3324 [SbandF P25*gradL3*0.3324 PhiL3*TWOPI]}';
K15_5a2={'lc' 'K15_5a' 0.3937 [SbandF P25*gradL3*0.3937 PhiL3*TWOPI]}';
K15_5a3={'lc' 'K15_5a' 2.3180 [SbandF P25*gradL3*2.3180 PhiL3*TWOPI]}';
K15_5b={'lc' 'K15_5b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_5c={'lc' 'K15_5c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_5d={'lc' 'K15_5d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_6a1={'lc' 'K15_6a' 0.3280 [SbandF P25*gradL3*0.3280 PhiL3*TWOPI]}';
K15_6a2={'lc' 'K15_6a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K15_6a3={'lc' 'K15_6a' 2.4661 [SbandF P25*gradL3*2.4661 PhiL3*TWOPI]}';
K15_6b={'lc' 'K15_6b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_6c={'lc' 'K15_6c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_6d={'lc' 'K15_6d' 2.1694 [SbandF P25*gradL3*2.1694 PhiL3*TWOPI]}';
K15_7a1={'lc' 'K15_7a' 0.3336 [SbandF P25*gradL3*0.3336 PhiL3*TWOPI]}';
K15_7a2={'lc' 'K15_7a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K15_7a3={'lc' 'K15_7a' 2.4605 [SbandF P25*gradL3*2.4605 PhiL3*TWOPI]}';
K15_7b={'lc' 'K15_7b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_7c={'lc' 'K15_7c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_7d={'lc' 'K15_7d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_8a1={'lc' 'K15_8a' 0.3292 [SbandF P25*gradL3*0.3292 PhiL3*TWOPI]}';
K15_8a2={'lc' 'K15_8a' 0.4413 [SbandF P25*gradL3*0.4413 PhiL3*TWOPI]}';
K15_8a3={'lc' 'K15_8a' 2.2736 [SbandF P25*gradL3*2.2736 PhiL3*TWOPI]}';
K15_8b={'lc' 'K15_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_8c={'lc' 'K15_8c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K15_8d1={'lc' 'K15_8d' 2.3869 [SbandF P25*gradL3*2.3869 PhiL3*TWOPI]}';
K15_8d2={'lc' 'K15_8d' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K15_8d3={'lc' 'K15_8d' 0.4072 [SbandF P25*gradL3*0.4072 PhiL3*TWOPI]}';
K16_1a={'lc' 'K16_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_1b={'lc' 'K16_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_1c={'lc' 'K16_1c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_1d={'lc' 'K16_1d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_2a1={'lc' 'K16_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K16_2a2={'lc' 'K16_2a' 0.3655 [SbandF P25*gradL3*0.3655 PhiL3*TWOPI]}';
K16_2a3={'lc' 'K16_2a' 2.3530 [SbandF P25*gradL3*2.3530 PhiL3*TWOPI]}';
K16_2b={'lc' 'K16_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_2c={'lc' 'K16_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_2d={'lc' 'K16_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_3a1={'lc' 'K16_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K16_3a2={'lc' 'K16_3a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K16_3a3={'lc' 'K16_3a' 2.4629 [SbandF P25*gradL3*2.4629 PhiL3*TWOPI]}';
K16_3b={'lc' 'K16_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_3c={'lc' 'K16_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_3d={'lc' 'K16_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_4a1={'lc' 'K16_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K16_4a2={'lc' 'K16_4a' 0.3675 [SbandF P25*gradL3*0.3675 PhiL3*TWOPI]}';
K16_4a3={'lc' 'K16_4a' 2.3498 [SbandF P25*gradL3*2.3498 PhiL3*TWOPI]}';
K16_4b={'lc' 'K16_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_4c={'lc' 'K16_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_4d={'lc' 'K16_4d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_5a1={'lc' 'K16_5a' 0.3324 [SbandF P25*gradL3*0.3324 PhiL3*TWOPI]}';
K16_5a2={'lc' 'K16_5a' 0.3651 [SbandF P25*gradL3*0.3651 PhiL3*TWOPI]}';
K16_5a3={'lc' 'K16_5a' 2.3466 [SbandF P25*gradL3*2.3466 PhiL3*TWOPI]}';
K16_5b={'lc' 'K16_5b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_5c={'lc' 'K16_5c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_5d={'lc' 'K16_5d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_6a1={'lc' 'K16_6a' 0.3280 [SbandF P25*gradL3*0.3280 PhiL3*TWOPI]}';
K16_6a2={'lc' 'K16_6a' 0.4139 [SbandF P25*gradL3*0.4139 PhiL3*TWOPI]}';
K16_6a3={'lc' 'K16_6a' 2.3022 [SbandF P25*gradL3*2.3022 PhiL3*TWOPI]}';
K16_6b={'lc' 'K16_6b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_6c={'lc' 'K16_6c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_6d={'lc' 'K16_6d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_7a1={'lc' 'K16_7a' 0.3336 [SbandF P25*gradL3*0.3336 PhiL3*TWOPI]}';
K16_7a2={'lc' 'K16_7a' 0.3893 [SbandF P25*gradL3*0.3893 PhiL3*TWOPI]}';
K16_7a3={'lc' 'K16_7a' 2.3212 [SbandF P25*gradL3*2.3212 PhiL3*TWOPI]}';
K16_7b={'lc' 'K16_7b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_7c={'lc' 'K16_7c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_7d={'lc' 'K16_7d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_8a1={'lc' 'K16_8a' 0.3292 [SbandF P25*gradL3*0.3292 PhiL3*TWOPI]}';
K16_8a2={'lc' 'K16_8a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K16_8a3={'lc' 'K16_8a' 2.4649 [SbandF P25*gradL3*2.4649 PhiL3*TWOPI]}';
K16_8b={'lc' 'K16_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_8c={'lc' 'K16_8c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K16_8d1={'lc' 'K16_8d' 2.3869 [SbandF P25*gradL3*2.3869 PhiL3*TWOPI]}';
K16_8d2={'lc' 'K16_8d' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K16_8d3={'lc' 'K16_8d' 0.4072 [SbandF P25*gradL3*0.4072 PhiL3*TWOPI]}';
K17_1a={'lc' 'K17_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_1b={'lc' 'K17_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_1c={'lc' 'K17_1c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_1d={'lc' 'K17_1d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_2a1={'lc' 'K17_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K17_2a2={'lc' 'K17_2a' 0.3814 [SbandF P25*gradL3*0.3814 PhiL3*TWOPI]}';
K17_2a3={'lc' 'K17_2a' 2.3371 [SbandF P25*gradL3*2.3371 PhiL3*TWOPI]}';
K17_2b={'lc' 'K17_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_2c={'lc' 'K17_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_2d={'lc' 'K17_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_3a1={'lc' 'K17_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K17_3a2={'lc' 'K17_3a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K17_3a3={'lc' 'K17_3a' 2.4629 [SbandF P25*gradL3*2.4629 PhiL3*TWOPI]}';
K17_3b={'lc' 'K17_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_3c={'lc' 'K17_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_3d={'lc' 'K17_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_4a1={'lc' 'K17_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K17_4a2={'lc' 'K17_4a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K17_4a3={'lc' 'K17_4a' 2.4673 [SbandF P25*gradL3*2.4673 PhiL3*TWOPI]}';
K17_4b={'lc' 'K17_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_4c={'lc' 'K17_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_4d={'lc' 'K17_4d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_5a1={'lc' 'K17_5a' 0.3324 [SbandF P25*gradL3*0.3324 PhiL3*TWOPI]}';
K17_5a2={'lc' 'K17_5a' 0.3841 [SbandF P25*gradL3*0.3841 PhiL3*TWOPI]}';
K17_5a3={'lc' 'K17_5a' 2.3276 [SbandF P25*gradL3*2.3276 PhiL3*TWOPI]}';
K17_5b={'lc' 'K17_5b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_5c={'lc' 'K17_5c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_5d={'lc' 'K17_5d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_6a1={'lc' 'K17_6a' 0.3280 [SbandF P25*gradL3*0.3280 PhiL3*TWOPI]}';
K17_6a2={'lc' 'K17_6a' 0.3949 [SbandF P25*gradL3*0.3949 PhiL3*TWOPI]}';
K17_6a3={'lc' 'K17_6a' 2.3212 [SbandF P25*gradL3*2.3212 PhiL3*TWOPI]}';
K17_6b={'lc' 'K17_6b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_6c={'lc' 'K17_6c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_6d={'lc' 'K17_6d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_7a1={'lc' 'K17_7a' 0.3336 [SbandF P25*gradL3*0.3336 PhiL3*TWOPI]}';
K17_7a2={'lc' 'K17_7a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K17_7a3={'lc' 'K17_7a' 2.4605 [SbandF P25*gradL3*2.4605 PhiL3*TWOPI]}';
K17_7b={'lc' 'K17_7b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_7c={'lc' 'K17_7c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_7d={'lc' 'K17_7d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_8a1={'lc' 'K17_8a' 0.3292 [SbandF P25*gradL3*0.3292 PhiL3*TWOPI]}';
K17_8a2={'lc' 'K17_8a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K17_8a3={'lc' 'K17_8a' 2.4649 [SbandF P25*gradL3*2.4649 PhiL3*TWOPI]}';
K17_8b={'lc' 'K17_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_8c={'lc' 'K17_8c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K17_8d1={'lc' 'K17_8d' 2.2856 [SbandF P25*gradL3*2.2856 PhiL3*TWOPI]}';
K17_8d2={'lc' 'K17_8d' 0.3513 [SbandF P25*gradL3*0.3513 PhiL3*TWOPI]}';
K17_8d3={'lc' 'K17_8d' 0.4072 [SbandF P25*gradL3*0.4072 PhiL3*TWOPI]}';
K18_1a={'lc' 'K18_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_1b={'lc' 'K18_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_1c={'lc' 'K18_1c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_1d={'lc' 'K18_1d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_2a1={'lc' 'K18_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K18_2a2={'lc' 'K18_2a' 0.3878 [SbandF P25*gradL3*0.3878 PhiL3*TWOPI]}';
K18_2a3={'lc' 'K18_2a' 2.3307 [SbandF P25*gradL3*2.3307 PhiL3*TWOPI]}';
K18_2b={'lc' 'K18_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_2c={'lc' 'K18_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_2d={'lc' 'K18_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_3a1={'lc' 'K18_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K18_3a2={'lc' 'K18_3a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K18_3a3={'lc' 'K18_3a' 2.4629 [SbandF P25*gradL3*2.4629 PhiL3*TWOPI]}';
K18_3b={'lc' 'K18_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_3c={'lc' 'K18_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_3d={'lc' 'K18_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_4a1={'lc' 'K18_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K18_4a2={'lc' 'K18_4a' 0.2500 [SbandF P25*gradL3*0.2500 PhiL3*TWOPI]}';
K18_4a3={'lc' 'K18_4a' 2.4673 [SbandF P25*gradL3*2.4673 PhiL3*TWOPI]}';
K18_4b={'lc' 'K18_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_4c={'lc' 'K18_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_4d={'lc' 'K18_4d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_5a1={'lc' 'K18_5a' 0.3324 [SbandF P25*gradL3*0.3324 PhiL3*TWOPI]}';
K18_5a2={'lc' 'K18_5a' 0.4095 [SbandF P25*gradL3*0.4095 PhiL3*TWOPI]}';
K18_5a3={'lc' 'K18_5a' 2.3022 [SbandF P25*gradL3*2.3022 PhiL3*TWOPI]}';
K18_5b={'lc' 'K18_5b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_5c={'lc' 'K18_5c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_5d={'lc' 'K18_5d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_6a1={'lc' 'K18_6a' 0.3280 [SbandF P25*gradL3*0.3280 PhiL3*TWOPI]}';
K18_6a2={'lc' 'K18_6a' 0.3885 [SbandF P25*gradL3*0.3885 PhiL3*TWOPI]}';
K18_6a3={'lc' 'K18_6a' 2.3276 [SbandF P25*gradL3*2.3276 PhiL3*TWOPI]}';
K18_6b={'lc' 'K18_6b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_6c={'lc' 'K18_6c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_6d={'lc' 'K18_6d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_7a1={'lc' 'K18_7a' 0.3336 [SbandF P25*gradL3*0.3336 PhiL3*TWOPI]}';
K18_7a2={'lc' 'K18_7a' 0.3798 [SbandF P25*gradL3*0.3798 PhiL3*TWOPI]}';
K18_7a3={'lc' 'K18_7a' 2.3307 [SbandF P25*gradL3*2.3307 PhiL3*TWOPI]}';
K18_7b={'lc' 'K18_7b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_7c={'lc' 'K18_7c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_7d={'lc' 'K18_7d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_8a1={'lc' 'K18_8a' 0.3292 [SbandF P25*gradL3*0.3292 PhiL3*TWOPI]}';
K18_8a2={'lc' 'K18_8a' 0.4127 [SbandF P25*gradL3*0.4127 PhiL3*TWOPI]}';
K18_8a3={'lc' 'K18_8a' 2.3022 [SbandF P25*gradL3*2.3022 PhiL3*TWOPI]}';
K18_8b={'lc' 'K18_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_8c={'lc' 'K18_8c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K18_8d1={'lc' 'K18_8d' 2.2729 [SbandF P25*gradL3*2.2729 PhiL3*TWOPI]}';
K18_8d2={'lc' 'K18_8d' 0.3640 [SbandF P25*gradL3*0.3640 PhiL3*TWOPI]}';
K18_8d3={'lc' 'K18_8d' 0.4072 [SbandF P25*gradL3*0.4072 PhiL3*TWOPI]}';
K19_1a={'lc' 'K19_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_1b={'lc' 'K19_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_1c={'lc' 'K19_1c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_1d={'lc' 'K19_1d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_2a1={'lc' 'K19_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K19_2a2={'lc' 'K19_2a' 0.3592 [SbandF P25*gradL3*0.3592 PhiL3*TWOPI]}';
K19_2a3={'lc' 'K19_2a' 2.3593 [SbandF P25*gradL3*2.3593 PhiL3*TWOPI]}';
K19_2b={'lc' 'K19_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_2c={'lc' 'K19_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_2d={'lc' 'K19_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_3a1={'lc' 'K19_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K19_3a2={'lc' 'K19_3a' 0.3695 [SbandF P25*gradL3*0.3695 PhiL3*TWOPI]}';
K19_3a3={'lc' 'K19_3a' 2.3434 [SbandF P25*gradL3*2.3434 PhiL3*TWOPI]}';
K19_3b={'lc' 'K19_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_3c={'lc' 'K19_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_3d={'lc' 'K19_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_4a1={'lc' 'K19_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K19_4a2={'lc' 'K19_4a' 0.3897 [SbandF P25*gradL3*0.3897 PhiL3*TWOPI]}';
K19_4a3={'lc' 'K19_4a' 2.3276 [SbandF P25*gradL3*2.3276 PhiL3*TWOPI]}';
K19_4b={'lc' 'K19_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_4c={'lc' 'K19_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_4d1={'lc' 'K19_4d' 1.5950 [SbandF P25*gradL3*1.5950 PhiL3*TWOPI]}';
K19_4d2={'lc' 'K19_4d' 0.3207 [SbandF P25*gradL3*0.3207 PhiL3*TWOPI]}';
K19_4d3={'lc' 'K19_4d' 0.2537 [SbandF P25*gradL3*0.2537 PhiL3*TWOPI]}';
K19_5a1={'lc' 'K19_5a' 0.3324 [SbandF P25*gradL3*0.3324 PhiL3*TWOPI]}';
K19_5a2={'lc' 'K19_5a' 0.4032 [SbandF P25*gradL3*0.4032 PhiL3*TWOPI]}';
K19_5a3={'lc' 'K19_5a' 2.3085 [SbandF P25*gradL3*2.3085 PhiL3*TWOPI]}';
K19_5b={'lc' 'K19_5b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_5c={'lc' 'K19_5c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_5d={'lc' 'K19_5d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_6a1={'lc' 'K19_6a' 0.3280 [SbandF P25*gradL3*0.3280 PhiL3*TWOPI]}';
K19_6a2={'lc' 'K19_6a' 0.3854 [SbandF P25*gradL3*0.3854 PhiL3*TWOPI]}';
K19_6a3={'lc' 'K19_6a' 2.3307 [SbandF P25*gradL3*2.3307 PhiL3*TWOPI]}';
K19_6b={'lc' 'K19_6b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_6c={'lc' 'K19_6c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_6d1={'lc' 'K19_6d' 0.8425 [SbandF P25*gradL3*0.8425 PhiL3*TWOPI]}';
K19_6d2={'lc' 'K19_6d' 1.4632 [SbandF P25*gradL3*1.4632 PhiL3*TWOPI]}';
K19_6d3={'lc' 'K19_6d' 0.7384 [SbandF P25*gradL3*0.7384 PhiL3*TWOPI]}';
K19_8a1={'lc' 'K19_8a' 0.3895 [SbandF P25*gradL3*0.3895 PhiL3*TWOPI]}';
K19_8a2={'lc' 'K19_8a' 0.2985 [SbandF P25*gradL3*0.2985 PhiL3*TWOPI]}';
K19_8a3={'lc' 'K19_8a' 2.3561 [SbandF P25*gradL3*2.3561 PhiL3*TWOPI]}';
K19_8b={'lc' 'K19_8b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_8c={'lc' 'K19_8c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K19_8d1={'lc' 'K19_8d' 0.8378 [SbandF P25*gradL3*0.8378 PhiL3*TWOPI]}';
K19_8d2={'lc' 'K19_8d' 1.4922 [SbandF P25*gradL3*1.4922 PhiL3*TWOPI]}';
K19_8d3={'lc' 'K19_8d' 0.7141 [SbandF P25*gradL3*0.7141 PhiL3*TWOPI]}';
K20_1a={'lc' 'K20_1a' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_1b={'lc' 'K20_1b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_1c={'lc' 'K20_1c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_1d={'lc' 'K20_1d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_2a1={'lc' 'K20_2a' 0.3256 [SbandF P25*gradL3*0.3256 PhiL3*TWOPI]}';
K20_2a2={'lc' 'K20_2a' 0.3497 [SbandF P25*gradL3*0.3497 PhiL3*TWOPI]}';
K20_2a3={'lc' 'K20_2a' 2.3688 [SbandF P25*gradL3*2.3688 PhiL3*TWOPI]}';
K20_2b={'lc' 'K20_2b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_2c={'lc' 'K20_2c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_2d={'lc' 'K20_2d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_3a1={'lc' 'K20_3a' 0.3312 [SbandF P25*gradL3*0.3312 PhiL3*TWOPI]}';
K20_3a2={'lc' 'K20_3a' 0.4044 [SbandF P25*gradL3*0.4044 PhiL3*TWOPI]}';
K20_3a3={'lc' 'K20_3a' 2.3085 [SbandF P25*gradL3*2.3085 PhiL3*TWOPI]}';
K20_3b={'lc' 'K20_3b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_3c={'lc' 'K20_3c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_3d={'lc' 'K20_3d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_4a1={'lc' 'K20_4a' 0.3268 [SbandF P25*gradL3*0.3268 PhiL3*TWOPI]}';
K20_4a2={'lc' 'K20_4a' 0.3961 [SbandF P25*gradL3*0.3961 PhiL3*TWOPI]}';
K20_4a3={'lc' 'K20_4a' 2.3212 [SbandF P25*gradL3*2.3212 PhiL3*TWOPI]}';
K20_4b={'lc' 'K20_4b' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_4c={'lc' 'K20_4c' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
K20_4d={'lc' 'K20_4d' 3.0441 [SbandF P25*gradL3*3.0441 PhiL3*TWOPI]}';
TCAV3B={'lc' 'TCAV3B' 2.438/2 [0 0 0*TWOPI]}';
% ==============================================================================
% SBENs
% ------------------------------------------------------------------------------
LKIK = 1.0601   ;%kicker coil length (m) [41.737" per SA-380-330-02]
GKIK = 2.0*in2m ;%kicker gap height (m)
AKIK = 1.0E-12  ;%kick angle (rad)
BXKIKBa={'be' 'BXKIKB' LKIK/2 [AKIK GKIK/2 0 0 0.5 0 0]}';
BXKIKBb={'be' 'BXKIKB' LKIK/2 [AKIK GKIK/2 0 2*AKIK 0 0.5 0]}';
% ==============================================================================
% QUADs
% ------------------------------------------------------------------------------
KQ14801 =  0.814349941576 ;%matched to 30 degree L3 FODO
KQ14901 = -0.497827848902 ;%matched to 30 degree L3 FODO
KQ15201 =  0.451779356416 ;%matched to 30 degree L3 FODO
KQ15301 = -0.395494122353 ;%matched to 30 degree L3 FODO
KQ15401 =  0.410666383792 ;%matched to 30 degree L3 FODO
KQ15501 = -0.392535623318;
KQ15601 =  0.392631612988;
KQ15701 = -0.392750652641;
KQ15801 =  0.403253079496;
KQ15901 = -0.387016898169;
KQ16201 =  0.388347309071;
KQ16301 = -0.402958579015;
KQ16401 =  0.393068286463;
KQ16501 = -0.393120241378;
KQ16601 =  0.393123284255;
KQ16701 = -0.393151469322;
KQ16801 =  0.403561109998;
KQ16901 = -0.387287816236;
KQ17201 =  0.388672424135;
KQ17301 = -0.403289429179;
KQ17401 =  0.393316278178;
KQ17501 = -0.393343773058;
KQ17601 =  0.393341395378;
KQ17701 = -0.393356692792;
KQ17801 =  0.403726797494;
KQ17901 = -0.38743411588 ;
KQ18201 =  0.388847098324;
KQ18301 = -0.403467937554;
KQ18401 =  0.393452163178;
KQ18501 = -0.393468500906;
KQ18601 =  0.39346488785 ;
KQ18701 = -0.393474231552;
KQ18801 =  0.403822556359;
KQ18901 = -0.387518959625;
KQ19201 =  0.38894857771 ;
KQ19301 = -0.403573510775;
KQ19401 =  0.393539464493;
KQ19501 = -0.393563749551;
KQ19601 =  0.393582156791;
KQ19701 = -0.393614775635;
KQ19801 =  0.40394450177 ;
KQ19901 = -0.406776159445 ;%matched from 30 degree L3 FODO
KQ20201 =  0.569100740892 ;%matched from 30 degree L3 FODO
KQ20301 = -0.696746991379 ;%matched from 30 degree L3 FODO
KQ20401 =  0.855119615891 ;%matched from 30 degree L3 FODO
KQ20501 = -0.97870912395  ;%matched from 30 degree L3 FODO
Q14801={'qu' 'Q14801' LQE/2 KQ14801}';
Q14901={'qu' 'Q14901' LQE/2 KQ14901}';
Q15201={'qu' 'Q15201' LQE/2 KQ15201}';
Q15301={'qu' 'Q15301' LQE/2 KQ15301}';
Q15401={'qu' 'Q15401' LQE/2 KQ15401}';
Q15501={'qu' 'Q15501' LQE/2 KQ15501}';
Q15601={'qu' 'Q15601' LQE/2 KQ15601}';
Q15701={'qu' 'Q15701' LQE/2 KQ15701}';
Q15801={'qu' 'Q15801' LQE/2 KQ15801}';
Q15901={'qu' 'Q15901' LQE/2 KQ15901}';
Q16201={'qu' 'Q16201' LQE/2 KQ16201}';
Q16301={'qu' 'Q16301' LQE/2 KQ16301}';
Q16401={'qu' 'Q16401' LQE/2 KQ16401}';
Q16501={'qu' 'Q16501' LQE/2 KQ16501}';
Q16601={'qu' 'Q16601' LQE/2 KQ16601}';
Q16701={'qu' 'Q16701' LQE/2 KQ16701}';
Q16801={'qu' 'Q16801' LQE/2 KQ16801}';
Q16901={'qu' 'Q16901' LQE/2 KQ16901}';
Q17201={'qu' 'Q17201' LQE/2 KQ17201}';
Q17301={'qu' 'Q17301' LQE/2 KQ17301}';
Q17401={'qu' 'Q17401' LQE/2 KQ17401}';
Q17501={'qu' 'Q17501' LQE/2 KQ17501}';
Q17601={'qu' 'Q17601' LQE/2 KQ17601}';
Q17701={'qu' 'Q17701' LQE/2 KQ17701}';
Q17801={'qu' 'Q17801' LQE/2 KQ17801}';
Q17901={'qu' 'Q17901' LQE/2 KQ17901}';
Q18201={'qu' 'Q18201' LQE/2 KQ18201}';
Q18301={'qu' 'Q18301' LQE/2 KQ18301}';
Q18401={'qu' 'Q18401' LQE/2 KQ18401}';
Q18501={'qu' 'Q18501' LQE/2 KQ18501}';
Q18601={'qu' 'Q18601' LQE/2 KQ18601}';
Q18701={'qu' 'Q18701' LQE/2 KQ18701}';
Q18801={'qu' 'Q18801' LQE/2 KQ18801}';
Q18901={'qu' 'Q18901' LQE/2 KQ18901}';
Q19201={'qu' 'Q19201' LQE/2 KQ19201}';
Q19301={'qu' 'Q19301' LQE/2 KQ19301}';
Q19401={'qu' 'Q19401' LQE/2 KQ19401}';
Q19501={'qu' 'Q19501' LQE/2 KQ19501}';
Q19601={'qu' 'Q19601' LQE/2 KQ19601}';
Q19701={'qu' 'Q19701' LQE/2 KQ19701}';
Q19801={'qu' 'Q19801' LQE/2 KQ19801}';
Q19901={'qu' 'Q19901' LQE/2 KQ19901}';
Q20201={'qu' 'Q20201' LQE/2 KQ20201}';
Q20301={'qu' 'Q20301' LQE/2 KQ20301}';
Q20401={'qu' 'Q20401' LQE/2 KQ20401}';
Q20501={'qu' 'Q20501' LQE/2 KQ20501}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
D148Da={'dr' '' 0.3838 []}';
D148Db={'dr' '' 0.2659 []}';
D148Dc={'dr' '' 0.3097 []}';
D151Da={'dr' '' 0.599 []}';
D151Db={'dr' '' 0.5591 []}';
D151Dc={'dr' '' 0.4793 []}';
D151Dd={'dr' '' 0.13545 []}';
D151De={'dr' '' 0.21115 []}';
DAQ4d={'dr' '' 0.9181 []}';
DAQ4e={'dr' '' LDAQ4-DAQ4d{3} []}';
DAQ4f={'dr' '' 0.9856 []}';
DAQ4g={'dr' '' LDAQ4-DAQ4f{3} []}';
DAA7l={'dr' '' LDAA7/2 []}';
DAA7m={'dr' '' LDAA7-DAA7l{3} []}';
DAA7n={'dr' '' 0.4378 []}';
DAA7o={'dr' '' LDAA7-DAA7n{3} []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC14802={'mo' 'XC14802' 0 []}';
XC14900={'mo' 'XC14900' 0 []}';
XC15202={'mo' 'XC15202' 0 []}';
XC15302={'mo' 'XC15302' 0 []}';
XC15402={'mo' 'XC15402' 0 []}';
XC15502={'mo' 'XC15502' 0 []}';
XC15602={'mo' 'XC15602' 0 []}';
XC15702={'mo' 'XC15702' 0 []}';
XC15802={'mo' 'XC15802' 0 []}';
XC15900={'mo' 'XC15900' 0 []}';
XC16202={'mo' 'XC16202' 0 []}';
XC16302={'mo' 'XC16302' 0 []}';
XC16402={'mo' 'XC16402' 0 []}';
XC16502={'mo' 'XC16502' 0 []}';
XC16602={'mo' 'XC16602' 0 []}';
XC16702={'mo' 'XC16702' 0 []}';
XC16802={'mo' 'XC16802' 0 []}';
XC16900={'mo' 'XC16900' 0 []}';
XC17202={'mo' 'XC17202' 0 []}';
XC17302={'mo' 'XC17302' 0 []}';
XC17402={'mo' 'XC17402' 0 []}';
XC17502={'mo' 'XC17502' 0 []}';
XC17602={'mo' 'XC17602' 0 []}';
XC17702={'mo' 'XC17702' 0 []}';
XC17802={'mo' 'XC17802' 0 []}';
XC17900={'mo' 'XC17900' 0 []}';
XC17950={'mo' 'XC17950' 0 []}';
XC18202={'mo' 'XC18202' 0 []}';
XC18302={'mo' 'XC18302' 0 []}';
XC18402={'mo' 'XC18402' 0 []}';
XC18502={'mo' 'XC18502' 0 []}';
XC18602={'mo' 'XC18602' 0 []}';
XC18702={'mo' 'XC18702' 0 []}';
XC18802={'mo' 'XC18802' 0 []}';
XC18900={'mo' 'XC18900' 0 []}';
XC19202={'mo' 'XC19202' 0 []}';
XC19302={'mo' 'XC19302' 0 []}';
XC19402={'mo' 'XC19402' 0 []}';
XC19502={'mo' 'XC19502' 0 []}';
XC19602={'mo' 'XC19602' 0 []}';
XC19700={'mo' 'XC19700' 0 []}';
XC19802={'mo' 'XC19802' 0 []}';
XC19900={'mo' 'XC19900' 0 []}';
XC20202={'mo' 'XC20202' 0 []}';
XC20302={'mo' 'XC20302' 0 []}';
XC20402={'mo' 'XC20402' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC14803={'mo' 'YC14803' 0 []}';
YC14900={'mo' 'YC14900' 0 []}';
YC15203={'mo' 'YC15203' 0 []}';
YC15303={'mo' 'YC15303' 0 []}';
YC15403={'mo' 'YC15403' 0 []}';
YC15503={'mo' 'YC15503' 0 []}';
YC15603={'mo' 'YC15603' 0 []}';
YC15703={'mo' 'YC15703' 0 []}';
YC15803={'mo' 'YC15803' 0 []}';
YC15900={'mo' 'YC15900' 0 []}';
YC16203={'mo' 'YC16203' 0 []}';
YC16303={'mo' 'YC16303' 0 []}';
YC16403={'mo' 'YC16403' 0 []}';
YC16503={'mo' 'YC16503' 0 []}';
YC16603={'mo' 'YC16603' 0 []}';
YC16703={'mo' 'YC16703' 0 []}';
YC16803={'mo' 'YC16803' 0 []}';
YC16900={'mo' 'YC16900' 0 []}';
YC17203={'mo' 'YC17203' 0 []}';
YC17303={'mo' 'YC17303' 0 []}';
YC17403={'mo' 'YC17403' 0 []}';
YC17503={'mo' 'YC17503' 0 []}';
YC17603={'mo' 'YC17603' 0 []}';
YC17703={'mo' 'YC17703' 0 []}';
YC17803={'mo' 'YC17803' 0 []}';
YC17900={'mo' 'YC17900' 0 []}';
YC17950={'mo' 'YC17950' 0 []}';
YC18203={'mo' 'YC18203' 0 []}';
YC18303={'mo' 'YC18303' 0 []}';
YC18403={'mo' 'YC18403' 0 []}';
YC18503={'mo' 'YC18503' 0 []}';
YC18603={'mo' 'YC18603' 0 []}';
YC18703={'mo' 'YC18703' 0 []}';
YC18803={'mo' 'YC18803' 0 []}';
YC18900={'mo' 'YC18900' 0 []}';
YC19203={'mo' 'YC19203' 0 []}';
YC19303={'mo' 'YC19303' 0 []}';
YC19403={'mo' 'YC19403' 0 []}';
YC_145={'mo' 'YC_145' 0 []}';%scavenger e- DC extraction
YC_146={'mo' 'YC_146' 0 []}';%scavenger e- DC extraction
YC19503={'mo' 'YC19503' 0 []}';
YC19603={'mo' 'YC19603' 0 []}';
YC19700={'mo' 'YC19700' 0 []}';
YC19803={'mo' 'YC19803' 0 []}';
YC19900={'mo' 'YC19900' 0 []}';
YC20203={'mo' 'YC20203' 0 []}';
YC20303={'mo' 'YC20303' 0 []}';
YC20403={'mo' 'YC20403' 0 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPM14801={'mo' 'BPM14801' 0 []}';
BPM14901={'mo' 'BPM14901' 0 []}';
BPM15201={'mo' 'BPM15201' 0 []}';
BPM15301={'mo' 'BPM15301' 0 []}';
BPM15401={'mo' 'BPM15401' 0 []}';
BPM15501={'mo' 'BPM15501' 0 []}';
BPM15601={'mo' 'BPM15601' 0 []}';
BPM15701={'mo' 'BPM15701' 0 []}';
BPM15801={'mo' 'BPM15801' 0 []}';
BPM15901={'mo' 'BPM15901' 0 []}';
BPM16201={'mo' 'BPM16201' 0 []}';
BPM16301={'mo' 'BPM16301' 0 []}';
BPM16401={'mo' 'BPM16401' 0 []}';
BPM16501={'mo' 'BPM16501' 0 []}';
BPM16601={'mo' 'BPM16601' 0 []}';
BPM16701={'mo' 'BPM16701' 0 []}';
BPM16801={'mo' 'BPM16801' 0 []}';
BPM16901={'mo' 'BPM16901' 0 []}';
BPM17201={'mo' 'BPM17201' 0 []}';
BPM17301={'mo' 'BPM17301' 0 []}';
BPM17401={'mo' 'BPM17401' 0 []}';
BPM17501={'mo' 'BPM17501' 0 []}';
BPM17601={'mo' 'BPM17601' 0 []}';
BPM17701={'mo' 'BPM17701' 0 []}';
BPM17801={'mo' 'BPM17801' 0 []}';
BPM17901={'mo' 'BPM17901' 0 []}';
BPM18201={'mo' 'BPM18201' 0 []}';
BPM18301={'mo' 'BPM18301' 0 []}';
BPM18401={'mo' 'BPM18401' 0 []}';
BPM18501={'mo' 'BPM18501' 0 []}';
BPM18601={'mo' 'BPM18601' 0 []}';
BPM18701={'mo' 'BPM18701' 0 []}';
BPM18801={'mo' 'BPM18801' 0 []}';
BPM18901={'mo' 'BPM18901' 0 []}';
BPM19201={'mo' 'BPM19201' 0 []}';
BPM19301={'mo' 'BPM19301' 0 []}';
BPM19401={'mo' 'BPM19401' 0 []}';
BPM19501={'mo' 'BPM19501' 0 []}';
BPM19601={'mo' 'BPM19601' 0 []}';
BPM19701={'mo' 'BPM19701' 0 []}';
BPM19801={'mo' 'BPM19801' 0 []}';
BPM19901={'mo' 'BPM19901' 0 []}';
BPM20201={'mo' 'BPM20201' 0 []}';
BPM20301={'mo' 'BPM20301' 0 []}';
BPM20401={'mo' 'BPM20401' 0 []}';
BPM20501={'mo' 'BPM20501' 0 []}';
% ==============================================================================
% miscellaneous diagnostics, collimators, MARKERs, etc.
% ------------------------------------------------------------------------------
C180096T={'dr' 'C180096T' 0 []}';%movable X and Y jaws
L3begB={'mo' '' 0 []}';
ZLIN209={'mo' '' 0 []}';%entrance to 14-7b (Z=1397.9105)
IMBC2oB={'mo' 'IMBC2oB' 0 []}';%BC2 output toroid (comparator with IMBC2i)
LI14end={'mo' '' 0 []}';
ZLIN210={'mo' '' 0 []}';%entrance to 15-1a (Z=1422.4000)
LI15beg={'mo' '' 0 []}';
PH03B={'mo' 'PH03B' 0 []}';%phase measurement RF cavity after BC2
BL22B={'mo' 'BL22B' 0 []}';%BC2+ (ceramic gap-based relative bunch length monitor)
OTR22B={'mo' 'OTR22B' 0 []}';%post-BC2 beam size
OTR_TCAVB={'mo' 'OTR_TCAVB' 0 []}';%post-BC2 longitudinal diagnostics
LI15end={'mo' '' 0 []}';
ZLIN211={'mo' '' 0 []}';%entrance to 16-1a (Z=1524.0000)
LI16beg={'mo' '' 0 []}';
LI16end={'mo' '' 0 []}';
ZLIN212={'mo' '' 0 []}';%entrance to 17-1a (Z=1625.6000)
LI17beg={'mo' '' 0 []}';
LI17end={'mo' '' 0 []}';
ZLIN213={'mo' '' 0 []}';%entrance to 18-1a (Z=1727.2000)
LI18beg={'mo' '' 0 []}';
LI18end={'mo' '' 0 []}';
ZLIN214={'mo' '' 0 []}';%entrance to 19-1a (Z=1828.8000)
LI19beg={'mo' '' 0 []}';
SCAVKICK={'mo' '' 0 []}';%scavenger e- extraction kicker
LI19end={'mo' '' 0 []}';
ZLIN215={'mo' '' 0 []}';%entrance to 20-1a (Z=1930.4000)
LI20beg={'mo' '' 0 []}';
LI20end={'mo' '' 0 []}';
ZLIN216={'mo' '' 0 []}';%entrance to 20-5a (Z=1979.7776)
L3endB={'mo' '' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K14_8a=[K14_8a1,XC14802,K14_8a2,YC14803,K14_8a3];
K14_8c=[K14_8c1,XC14900,K14_8c2,YC14900,K14_8c3];
K15_2a=[K15_2a1,XC15202,K15_2a2,YC15203,K15_2a3];
K15_3a=[K15_3a1,XC15302,K15_3a2,YC15303,K15_3a3];
K15_4a=[K15_4a1,XC15402,K15_4a2,YC15403,K15_4a3];
K15_5a=[K15_5a1,XC15502,K15_5a2,YC15503,K15_5a3];
K15_6a=[K15_6a1,XC15602,K15_6a2,YC15603,K15_6a3];
K15_7a=[K15_7a1,XC15702,K15_7a2,YC15703,K15_7a3];
K15_8a=[K15_8a1,XC15802,K15_8a2,YC15803,K15_8a3];
K15_8d=[K15_8d1,XC15900,K15_8d2,YC15900,K15_8d3];
K16_2a=[K16_2a1,XC16202,K16_2a2,YC16203,K16_2a3];
K16_3a=[K16_3a1,XC16302,K16_3a2,YC16303,K16_3a3];
K16_4a=[K16_4a1,XC16402,K16_4a2,YC16403,K16_4a3];
K16_5a=[K16_5a1,XC16502,K16_5a2,YC16503,K16_5a3];
K16_6a=[K16_6a1,XC16602,K16_6a2,YC16603,K16_6a3];
K16_7a=[K16_7a1,XC16702,K16_7a2,YC16703,K16_7a3];
K16_8a=[K16_8a1,XC16802,K16_8a2,YC16803,K16_8a3];
K16_8d=[K16_8d1,XC16900,K16_8d2,YC16900,K16_8d3];
K17_2a=[K17_2a1,XC17202,K17_2a2,YC17203,K17_2a3];
K17_3a=[K17_3a1,XC17302,K17_3a2,YC17303,K17_3a3];
K17_4a=[K17_4a1,XC17402,K17_4a2,YC17403,K17_4a3];
K17_5a=[K17_5a1,XC17502,K17_5a2,YC17503,K17_5a3];
K17_6a=[K17_6a1,XC17602,K17_6a2,YC17603,K17_6a3];
K17_7a=[K17_7a1,XC17702,K17_7a2,YC17703,K17_7a3];
K17_8a=[K17_8a1,XC17802,K17_8a2,YC17803,K17_8a3];
K17_8d=[K17_8d1,XC17900,K17_8d2,YC17900,K17_8d3];
K18_2a=[K18_2a1,XC18202,K18_2a2,YC18203,K18_2a3];
K18_3a=[K18_3a1,XC18302,K18_3a2,YC18303,K18_3a3];
K18_4a=[K18_4a1,XC18402,K18_4a2,YC18403,K18_4a3];
K18_5a=[K18_5a1,XC18502,K18_5a2,YC18503,K18_5a3];
K18_6a=[K18_6a1,XC18602,K18_6a2,YC18603,K18_6a3];
K18_7a=[K18_7a1,XC18702,K18_7a2,YC18703,K18_7a3];
K18_8a=[K18_8a1,XC18802,K18_8a2,YC18803,K18_8a3];
K18_8d=[K18_8d1,XC18900,K18_8d2,YC18900,K18_8d3];
K19_2a=[K19_2a1,XC19202,K19_2a2,YC19203,K19_2a3];
K19_3a=[K19_3a1,XC19302,K19_3a2,YC19303,K19_3a3];
K19_4a=[K19_4a1,XC19402,K19_4a2,YC19403,K19_4a3];
K19_4d=[K19_4d1,YC_145,K19_4d2,YC_146,K19_4d3];
K19_5a=[K19_5a1,XC19502,K19_5a2,YC19503,K19_5a3];
K19_6a=[K19_6a1,XC19602,K19_6a2,YC19603,K19_6a3];
K19_6d=[K19_6d1,YC19700,K19_6d2,XC19700,K19_6d3];
K19_8a=[K19_8a1,XC19802,K19_8a2,YC19803,K19_8a3];
K19_8d=[K19_8d1,XC19900,K19_8d2,YC19900,K19_8d3];
K20_2a=[K20_2a1,XC20202,K20_2a2,YC20203,K20_2a3];
K20_3a=[K20_3a1,XC20302,K20_3a2,YC20303,K20_3a3];
K20_4a=[K20_4a1,XC20402,K20_4a2,YC20403,K20_4a3];
K14_7=[       K14_7b,K14_7c,K14_7d];
K14_8=[K14_8a,K14_8b,K14_8c       ];
K15_1=[K15_1a,K15_1b,K15_1c       ];
K15_2=[K15_2a,K15_2b,K15_2c,K15_2d];
K15_3=[K15_3a,K15_3b,K15_3c,K15_3d];
K15_4=[K15_4a,K15_4b,K15_4c,K15_4d];
K15_5=[K15_5a,K15_5b,K15_5c,K15_5d];
K15_6=[K15_6a,K15_6b,K15_6c,K15_6d];
K15_7=[K15_7a,K15_7b,K15_7c,K15_7d];
K15_8=[K15_8a,K15_8b,K15_8c,K15_8d];
K16_1=[K16_1a,K16_1b,K16_1c,K16_1d];
K16_2=[K16_2a,K16_2b,K16_2c,K16_2d];
K16_3=[K16_3a,K16_3b,K16_3c,K16_3d];
K16_4=[K16_4a,K16_4b,K16_4c,K16_4d];
K16_5=[K16_5a,K16_5b,K16_5c,K16_5d];
K16_6=[K16_6a,K16_6b,K16_6c,K16_6d];
K16_7=[K16_7a,K16_7b,K16_7c,K16_7d];
K16_8=[K16_8a,K16_8b,K16_8c,K16_8d];
K17_1=[K17_1a,K17_1b,K17_1c,K17_1d];
K17_2=[K17_2a,K17_2b,K17_2c,K17_2d];
K17_3=[K17_3a,K17_3b,K17_3c,K17_3d];
K17_4=[K17_4a,K17_4b,K17_4c,K17_4d];
K17_5=[K17_5a,K17_5b,K17_5c,K17_5d];
K17_6=[K17_6a,K17_6b,K17_6c,K17_6d];
K17_7=[K17_7a,K17_7b,K17_7c,K17_7d];
K17_8=[K17_8a,K17_8b,K17_8c,K17_8d];
K18_1=[K18_1a,K18_1b,K18_1c,K18_1d];
K18_2=[K18_2a,K18_2b,K18_2c,K18_2d];
K18_3=[K18_3a,K18_3b,K18_3c,K18_3d];
K18_4=[K18_4a,K18_4b,K18_4c,K18_4d];
K18_5=[K18_5a,K18_5b,K18_5c,K18_5d];
K18_6=[K18_6a,K18_6b,K18_6c,K18_6d];
K18_7=[K18_7a,K18_7b,K18_7c,K18_7d];
K18_8=[K18_8a,K18_8b,K18_8c,K18_8d];
K19_1=[K19_1a,K19_1b,K19_1c,K19_1d];
K19_2=[K19_2a,K19_2b,K19_2c,K19_2d];
K19_3=[K19_3a,K19_3b,K19_3c,K19_3d];
K19_4=[K19_4a,K19_4b,K19_4c,K19_4d];
K19_5=[K19_5a,K19_5b,K19_5c,K19_5d];
K19_6=[K19_6a,K19_6b,K19_6c,K19_6d];
D19_7=[D10,D10,D10,D10];
K19_8=[K19_8a,K19_8b,K19_8c,K19_8d];
K20_1=[K20_1a,K20_1b,K20_1c,K20_1d];
K20_2=[K20_2a,K20_2b,K20_2c,K20_2d];
K20_3=[K20_3a,K20_3b,K20_3c,K20_3d];
K20_4=[K20_4a,K20_4b,K20_4c,K20_4d];
LI14b=[ZLIN209,K14_7,DAQ1,Q14801,BPM14801,Q14801,DAQ2,K14_8,D148Da,IMBC2oB,D148Db,TCAV3B,TCAV3B,D148Dc,Q14901,BPM14901,Q14901,DAQ4,LI14end];
LI15=[ZLIN210,LI15beg,K15_1,D151Da,PH03B,D151Db,BL22B,D151Dc,OTR22B,D151Dd,BXKIKBa,BXKIKBb,D151De,DAQ1,Q15201,BPM15201,Q15201,DAQ2,K15_2,DAQ1,Q15301,BPM15301,Q15301,DAQ2,K15_3,DAQ1,Q15401,BPM15401,Q15401,DAQ2,K15_4,DAQ1,Q15501,BPM15501,Q15501,DAQ2,K15_5,DAQ1,Q15601,BPM15601,Q15601,DAQ2,K15_6,DAA7l,OTR_TCAVB,DAA7m,DAQ1,Q15701,BPM15701,Q15701,DAQ2,K15_7,DAQ1,Q15801,BPM15801,Q15801,DAQ2,K15_8,DAQ3,Q15901,BPM15901,Q15901,DAQ4,LI15end];
LI16=[ZLIN211,LI16beg,K16_1,DAQ1,Q16201,BPM16201,Q16201,DAQ2,K16_2,DAQ1,Q16301,BPM16301,Q16301,DAQ2,K16_3,DAQ1,Q16401,BPM16401,Q16401,DAQ2,K16_4,DAQ1,Q16501,BPM16501,Q16501,DAQ2,K16_5,DAQ1,Q16601,BPM16601,Q16601,DAQ2,K16_6,DAQ1,Q16701,BPM16701,Q16701,DAQ2,K16_7,DAQ1,Q16801,BPM16801,Q16801,DAQ2,K16_8,DAQ3,Q16901,BPM16901,Q16901,DAQ4,LI16end];
LI17=[ZLIN212,LI17beg,K17_1,DAQ1,Q17201,BPM17201,Q17201,DAQ2,K17_2,DAQ1,Q17301,BPM17301,Q17301,DAQ2,K17_3,DAQ1,Q17401,BPM17401,Q17401,DAQ2,K17_4,DAQ1,Q17501,BPM17501,Q17501,DAQ2,K17_5,DAQ1,Q17601,BPM17601,Q17601,DAQ2,K17_6,DAQ1,Q17701,BPM17701,Q17701,DAQ2,K17_7,DAQ1,Q17801,BPM17801,Q17801,DAQ2,K17_8,DAQ3,Q17901,BPM17901,Q17901,DAQ4d,XC17950,YC17950,DAQ4e,LI17end];
LI18=[ZLIN213,LI18beg,K18_1,DAQ1,Q18201,BPM18201,Q18201,DAQ2,K18_2,DAQ1,Q18301,BPM18301,Q18301,DAQ2,K18_3,DAQ1,Q18401,BPM18401,Q18401,DAQ2,K18_4,DAQ1,Q18501,BPM18501,Q18501,DAQ2,K18_5,DAQ1,Q18601,BPM18601,Q18601,DAQ2,K18_6,DAQ1,Q18701,BPM18701,Q18701,DAQ2,K18_7,DAQ1,Q18801,BPM18801,Q18801,DAQ2,K18_8,DAQ3,Q18901,BPM18901,Q18901,DAQ4f,C180096T,DAQ4g,LI18end];
LI19=[ZLIN214,LI19beg,K19_1,DAQ1,Q19201,BPM19201,Q19201,DAQ2,K19_2,DAQ1,Q19301,BPM19301,Q19301,DAQ2,K19_3,DAQ1,Q19401,BPM19401,Q19401,DAQ2,K19_4,DAA7n,SCAVKICK,DAA7o,DAQ1,Q19501,BPM19501,Q19501,DAQ2,K19_5,DAQ1,Q19601,BPM19601,Q19601,DAQ2,K19_6,DAQ1,Q19701,BPM19701,Q19701,DAQ2,D19_7,DAQ1,Q19801,BPM19801,Q19801,DAQ2,K19_8,DAQ3,Q19901,BPM19901,Q19901,DAQ4,LI19end];
LI20=[ZLIN215,LI20beg,K20_1,DAQ1,Q20201,BPM20201,Q20201,DAQ2,K20_2,DAQ1,Q20301,BPM20301,Q20301,DAQ2,K20_3,DAQ1,Q20401,BPM20401,Q20401,DAQ2,K20_4,DAQ1,Q20501,BPM20501,Q20501,DAQ2,LI20end,ZLIN216];
L3=[L3begB,LI14b,LI15,LI16,LI17,LI18,LI19,LI20,L3endB];
% ==============================================================================

%CALL, FILENAME="LCLSII_L3e.xsif" 
% ==============================================================================
% BEAMLINEs
% ==============================================================================
% ------------------------------------------------------------------------------
% gun
% ------------------------------------------------------------------------------
SC0=[XC00B,YC00B];
SC1=[XC01B,YC01B];
SC2=[XC02B,YC02B];
GUNBXG=[DL00,LOADLOCK,SEQ00,L0begB,SOL1BKB,CATHODEB,ZLIN200,DL01a,SOL1B,CQ01B,CQ01B,SC0,SQ01B,SQ01B,SOL1B,DL01a1,VV01B,DL01a2,AM00B,DL01a3,DAM01B,DL01a4,DYAG01B,DL01a5,DFC01B,DL01b,IM01B,DL01c,SC1,DL01h,BPM2B,DL01d,SEQ01];
BXGL0A=[DXG0,DXGBa,DXGBb,DL01e,BPM3B,DL01f,DCR01B,DL01f2,YAG02B,DL01g,FLNGA1B,L0AB__1,DLFDAB,L0AB__2,DSOL2B,L0AB__3,SC2,L0AB__4,L0AmidB,L0AB__5,DSC3,L0AB__6,OUTCPAB,L0AB__7,FLNGA2B,L0AwakeB,L0A_exit];
GUNL0A=[GUNBXG,BXGL0A];
% ------------------------------------------------------------------------------
% gun spectrometer
% ------------------------------------------------------------------------------
GSPEC=[GSPECBEG,BXGBa,BXGBb,DGS1,DG02B,YCG1B,DG02B, DGS2,DGS3,DG03B,DG03B,DGS4,YAGG1B,DGS5,DGS6,FCG1B,DGS7,GSPECEND];
% ------------------------------------------------------------------------------
% injector
% ------------------------------------------------------------------------------
SC4=[XC04B,YC04B];
SC5=[XC05B,YC05B];
SC6=[XC06B,YC06B];
SC7=[XC07B,YC07B];
SC8=[XC08B,YC08B];
SC9=[XC09B,YC09B];
SC10=[XC10B,YC10B];
L0B=[L0BbegB,DL02a1,YAG03B,DL02a2,DL02a3,QA01B,QA01B,DL02b1,PH01B,DL02b2,QA02B,BPM5B,QA02B,DL02c,FLNGB1B,L0BB__1,DLFDBB,L0BB__2,SC4,L0BB__3,L0BmidB,L0BB__4,SC5,L0BB__5,OUTCPBB,L0BB__6,FLNGB2B,L0endB];
L0=[GUNL0A,L0B];
LSRHTR=[LHbegB,BXh1Ba,BXh1Bb,Dh01,BXh2Ba,BXh2Bb,Dh02a,OTRH1B,Dh03a,LH_UNDB,HTRUNDB,LH_UNDB,Dh03b,OTRH2B,Dh02b,BXh3Ba,BXh3Bb,Dh01,BXh4Ba,BXh4Bb,LHendB];
DL1a=[EMATB,DL1begB,DE00,DE00a,QE01B,BPM6B,QE01B,DE01a,IM02B,DE01b,VV02B,DE01c,QE02B,QE02B,Dh00,LSRHTR,Dh06,TCAV0B,SC6,TCAV0B,DE02,QE03B,BPM8B,QE03B,DE03a,DE03b,SC7,DE03c,QE04B,BPM9B,QE04B,DE04,DWS01B,DE05,OTR1B,DE05c,VV03B,DE06a,RST1B,DE06b,WS02B,DE05a,MRK0B,DE05a,OTR2B,DE06d,BPM10B,DE06e,DWS03B,DE05,OTR3B,DE07,QM01B,BPM11B,QM01B,DE08,SC8,DE08a,VV04B,DE08b,QM02B,BPM12B,QM02B,DE09,SEQ02];
DL1b=[BX01Ba,BX01Bb,DB00a,OTR4B,DB00b,SC9,DB00c,QBB,BPM13B,QBB,DB00d,DWS04B,DB00e,BX02Ba,BX02Bb,CNT0B,SEQ03,ZLIN201,DM00,SC10,DM00a,QM03B,BPM14B,QM03B,DM01,DM01a,QM04B,BPM15B,QM04B,DM02,IM03B,DM02a,DL1endB];
DL1=[DL1a,DL1b];
INJ=[L0,DL1];
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
% ------------------------------------------------------------------------------
SCS1=[XCS1B,YCS1B];
SCS2=[XCS2B,YCS2B];
SPECBL=[SPECBEG,DX01Ba,DX01Bb,DS0,SCS1,DS0a,DS0b,DS1a,VVS1B,DS1b,YAGS1B,DS1c,BPMS1B,DS1d,BXSBa,BXSBb,DS2,QS01B,BPMS2B,QS01B,DS3a,SCS2,DS3b,QS02B,QS02B,DS4,IMS1B,DS6a,BPMS3B,DS6b,YAGS2B,DS7,DS8,DS9,SDMPB,SPECEND];
% ------------------------------------------------------------------------------
% BC1
% ------------------------------------------------------------------------------
SCM11=[XCM11B,YCM11B];
SCM13=[XCM13B,YCM12B];
SCM15=[XCM14B,YCM15B];
BC1i=[DL1Xa,VVX1B,DL1Xb,XbegB,L1XB__1,SCM11,L1XB__2,XendB,DM10a,VVX2B,DM10c,Q11201,BPM11201,Q11201,DM10x,IMBC1iB,DM11,QM11B,QM11B,DM12];
BC1c=[BC1begB,BX11Ba,BX11Bb,DBQ1,CQ11B,CQ11B,D11o,BX12Ba,BX12Bb,DDG11,BPMS11B,DDG12,CE11B,DDG13,OTR11B,DDG14,BX13Ba,BX13Bb,D11oa,SQ13B,SQ13B,D11ob,CQ12B,CQ12B,DBQ1,BX14Ba,BX14Bb,CNT1B,BC1endB];
BC1e=[DM13a,BL11B,DM13b,QM12B,QM12B,DM14a,DM14b,IMBC1oB,DM14c,QM13B,BPMM12B,QM13B,DM15a,BL12B,DM15b,SCM13,DM15c,WS11B,DWW1a,WS12B,DWW1b,OTR12B,DWW1c1,PH02B,DWW1c2,XC11302,DWW1d,YC11303,DWW1e,WS13B,DM16,Q11301,BPM11301,Q11301,DM17a,DM17b,TD11B,DM17c,QM14B,BPMM14B,QM14B,DM18a,SCM15,DM18b,QM15B,QM15B,SEQ04,DM19];
BC1=[ZLIN203,BC1mrkB,BC1i,BC1c,BC1e,BC1finB];
% ------------------------------------------------------------------------------
% BC2
% ------------------------------------------------------------------------------
BC2C1=[BC2begB,BX21Ba,BX21Bb,DBQ2a,CQ21B,CQ21B,D21oa,BX22Ba,BX22Bb,DDG0,DDG21,BPMS21B,DDG22,CE21B,DDG23,OTR21B,DDG24,DDGA,BX23Ba,BX23Bb,D21ob,CQ22B,CQ22B,DBQ2b,BX24Ba,BX24Bb,CNT2B,BC2endB];
BC2=[ZLIN208,BC2mrkB,DM20,Q14501a,Q14501a,D10cma,Q14501b,BPM14501,Q14501b,DM21Z,DM21A,DWS24B,DM21H,IMBC2iB,DM21B,VV21B,DM21C,QM21B,QM21B,DM21D,DM21E,BC2C1,D21w,D21x,BL21B,D21y,DM23B,QM22B,QM22B,DM24A,VV22B,DM24B,DM24D,Q14701a,BPM14701,Q14701a,DM24C,Q14701b,Q14701b,DM25,BC2finB];
% ------------------------------------------------------------------------------
% sector 20 vertical dogleg to bypass line
% ------------------------------------------------------------------------------
BPMBD1={'mo' 'BPMBD1' 0 []}';% 2/22/11
BPMBD2={'mo' 'BPMBD2' 0 []}';% 2/22/11
BPMBD3={'mo' 'BPMBD3' 0 []}';% 2/22/11
BPMBD4={'mo' 'BPMBD4' 0 []}';% 2/22/11
BPMBD5={'mo' 'BPMBD5' 0 []}';% 2/22/11
BPMBD6={'mo' 'BPMBD6' 0 []}';% 2/22/11
BPMBD7={'mo' 'BPMBD7' 0 []}';% 2/22/11
BPMBD8={'mo' 'BPMBD8' 0 []}';% 2/22/11
XCBD2={'mo' 'XCBD2' 0 []}';% 2/22/11
XCBD4={'mo' 'XCBD4' 0 []}';% 2/22/11
XCBD6={'mo' 'XCBD6' 0 []}';% 2/22/11
XCBD8={'mo' 'XCBD8' 0 []}';% 2/22/11
YCBD1={'mo' 'YCBD1' 0 []}';% 2/22/11
YCBD3={'mo' 'YCBD3' 0 []}';% 2/22/11
YCBD5={'mo' 'YCBD5' 0 []}';% 2/22/11
YCBD7={'mo' 'YCBD7' 0 []}';% 2/22/11
YCBD9={'mo' 'YCBD9' 0 []}';% 2/22/11
FODODL=[QFA,DCA,DCA,QDA,QDA,DCA,DCA,QFA];
DLBP=[SEQ05,BRB1a,BRB1b,CNT3A,YCBD1,D02A,QBD1,BPMBD1,QBD1,XCBD2,DCA,DCAc,CEBD,DCAb, QBD2,BPMBD2,QBD2,YCBD3,DCA,DCA, QBD3,BPMBD3,QBD3,XCBD4,DCA,DCA, QBD4,BPMBD4,QBD4,YCBD5,DCAWa,WALL20beg,D20WALL,WALL20end,DCAWb,QBD5,BPMBD5,QBD5,XCBD6,DCA,DCAa,WSBD,DCAb, QBD6,BPMBD6,QBD6,YCBD7,DCA,DCA, QBD7,BPMBD7,QBD7,XCBD8,DCA,DCA, QBD8,BPMBD8,QBD8,YCBD9,D02B,BRB2a,BRB2b,CNT3B];
% ------------------------------------------------------------------------------
% bypass line
% ------------------------------------------------------------------------------
% - FODO   = generic bypass FODO for fitting
% - FODOL  = linac enclosure bypass quads
% - BYPM   = matching into vertical bends
% ------------------------------------------------------------------------------
BPML1P={'mo' 'BPML1P' 0 []}';% 2/22/11
BPML2P={'mo' 'BPML2P' 0 []}';% 2/22/11
BPML3P={'mo' 'BPML3P' 0 []}';% 2/22/11
BPML4P={'mo' 'BPML4P' 0 []}';% 2/22/11
XCL1P={'mo' 'XCL1P' 0 []}';% 2/22/11
XCL2P={'mo' 'XCL2P' 0 []}';% 2/22/11
XCL3P={'mo' 'XCL3P' 0 []}';% 2/22/11
XCL4P={'mo' 'XCL4P' 0 []}';% 2/22/11
YCL1P={'mo' 'YCL1P' 0 []}';% 2/22/11
YCL2P={'mo' 'YCL2P' 0 []}';% 2/22/11
YCL3P={'mo' 'YCL3P' 0 []}';% 2/22/11
YCL4P={'mo' 'YCL4P' 0 []}';% 2/22/11
MTCH1=[DL1P,XCL1P,QL1P,BPML1P,QL1P,YCL1P,DL2P, XCL2P,QL2P,BPML2P,QL2P,YCL2P,DL3P, XCL3P,QL3P,BPML3P,QL3P,YCL3P,DL4P, XCL4P,QL4P,BPML4P,QL4P,YCL4P,DL5P];
FODO=[QFY,DCY,DCY,QDY,QDY,DCY,DCY,QFY];
BPMBP23={'mo' 'BPMBP23' 0 []}';% 2/22/11
BPMBP24={'mo' 'BPMBP24' 0 []}';% 2/22/11
BPMBP25={'mo' 'BPMBP25' 0 []}';% 2/22/11
BPMBP26={'mo' 'BPMBP26' 0 []}';% 2/22/11
BPMBP27={'mo' 'BPMBP27' 0 []}';% 2/22/11
BPMBP28={'mo' 'BPMBP28' 0 []}';% 2/22/11
BPMBP29={'mo' 'BPMBP29' 0 []}';% 2/22/11
BPMBP30={'mo' 'BPMBP30' 0 []}';% 2/22/11
BPMBP31={'mo' 'BPMBP31' 0 []}';% 2/22/11
BPMBP32={'mo' 'BPMBP32' 0 []}';% 2/22/11
BPMBP33={'mo' 'BPMBP33' 0 []}';% 2/22/11
BPMBP34={'mo' 'BPMBP34' 0 []}';% 2/22/11
XCBP23={'mo' 'XCBP23' 0 []}';% 2/22/11
XCBP24={'mo' 'XCBP24' 0 []}';% 2/22/11
XCBP25={'mo' 'XCBP25' 0 []}';% 2/22/11
XCBP26={'mo' 'XCBP26' 0 []}';% 2/22/11
XCBP27={'mo' 'XCBP27' 0 []}';% 2/22/11
XCBP28={'mo' 'XCBP28' 0 []}';% 2/22/11
XCBP29={'mo' 'XCBP29' 0 []}';% 2/22/11
XCBP30={'mo' 'XCBP30' 0 []}';% 2/22/11
XCBP31={'mo' 'XCBP31' 0 []}';% 2/22/11
XCBP32={'mo' 'XCBP32' 0 []}';% 2/22/11
XCBP33={'mo' 'XCBP33' 0 []}';% 2/22/11
XCBP34={'mo' 'XCBP34' 0 []}';% 2/22/11
YCBP23={'mo' 'YCBP23' 0 []}';% 2/22/11
YCBP24={'mo' 'YCBP24' 0 []}';% 2/22/11
YCBP25={'mo' 'YCBP25' 0 []}';% 2/22/11
YCBP26={'mo' 'YCBP26' 0 []}';% 2/22/11
YCBP27={'mo' 'YCBP27' 0 []}';% 2/22/11
YCBP28={'mo' 'YCBP28' 0 []}';% 2/22/11
YCBP29={'mo' 'YCBP29' 0 []}';% 2/22/11
YCBP30={'mo' 'YCBP30' 0 []}';% 2/22/11
YCBP31={'mo' 'YCBP31' 0 []}';% 2/22/11
YCBP32={'mo' 'YCBP32' 0 []}';% 2/22/11
YCBP33={'mo' 'YCBP33' 0 []}';% 2/22/11
YCBP34={'mo' 'YCBP34' 0 []}';% 2/22/11
FODOL=[DCY,QBP23,Q1MRK,BPMBP23,QBP23,XCBP23,YCBP23,DCYa,CX23,DCYb,DCY, QBP24,BPMBP24,QBP24,XCBP24,YCBP24,DCYa,CY24,DCYb,WSBP1,DCY, QBP25,BPMBP25,QBP25,XCBP25,YCBP25,DCY,DCY, QBP26,BPMBP26,QBP26,XCBP26,YCBP26,DCY,WSBP2,DCY, QBP27,BPMBP27,QBP27,XCBP27,YCBP27,DCYa,CX27,DCYb,DCY, QBP28,BPMBP28,QBP28,XCBP28,YCBP28,DCYa,CY28,DCYb,WSBP3,DCY, QBP29,BPMBP29,QBP29,XCBP29,YCBP29,DCY,DCY,QBP30,BPMBP30,QBP30,XCBP30,YCBP30,DCY,WSBP4];
YKIK=[BYKIK1bA,BYKIK1bB,DDL1C,DDL1C,BYKIK2bA,BYKIK2bB];
BYPM=[DCY1,S100B,DCY2,XCBP31,QBP31,BPMBP31,QBP31,YCBP31,DCM1,XCBP32,QBP32 ,BPMBP32,QBP32,YCBP32,DCM2a,YKIK,DCM2b,XCBP33,QBP33 ,BPMBP33,QBP33,YCBP33,DCM3a,SPOILERb,DCM3b,TDKIKb,DCM3c,D2b,DCM3d,ST60b,DCM3e,ST61b,DCM3f,XCBP34,QBP34 ,BPMBP34,QBP34,YCBP34,DCWL];
BYPASS=[FODOL,BYPM];
% ------------------------------------------------------------------------------
% vertical and horizontal bend systems
% ------------------------------------------------------------------------------
VBEND=[BY3a,BY3b,DVB1,QVB4,BPMVB4,QVB4,YCVB4,DVB2,XCVB5,QVB5,BPMVB5,QVB5,DVB2,QVB6,BPMVB6,QVB6,YCVB6,DVB1,BY4a,BY4b,CNTV];
MTCHH=[DH1,YCHM1,QHM1,BPMH1,QHM1,DH2,QHM2,BPMH2,QHM2,XCHM2,DH3, XCHM3,QHM3,BPMH3,QHM3,DH4,QHM4,BPMH4,QHM4,YCHM4,DH5];
DLH1=[MM1,IM41,BX41a,BX41b,DHB1,XCDL41,QDL41,BPMDL41,LOBETA,QDL41,YCDL41,DHB1A,CEDL41,DHB1B,BX42a,BX42b,CNT6];
DLH2=[BX43a,BX43b,DHB1,XCDL42,QDL42,BPMDL42,QDL42,YCDL42,DHB1A,CEDL42,DHB1B,BX44a,BX44b,CNT6];
DLH3=[DX51a,DX51b,DHB1,XCDL43,QDL43,BPMDL43,QDL43,YCDL43,DHB1,DX52a,DX52b];
TRIP1=[DDL5,QT41B,QT41B,DDL1,XCT42,QT42B,BPMT42B,QT42B,YCT42,DDL1,QT43B,QT43B,DDL5];
TRIP2=[DDL5,QT44,QT44,DDL1,XCT45,QT45,BPMT45,QT45,YCT45,DDL1,QT46,QT46,DDL5];
TRIP3=[DDL5,QT47,QT47,DDL1,XCT48,QT48,BPMT48,QT48,YCT48,DDL1,QT49,QT49,DDL5];
DBLDL=[DLH1,TRIP1,T1,DLH2,TRIP2,T2,SEQ07];
DBLDLH=[DLH3,TRIP3,T3];
% ------------------------------------------------------------------------------
% LTU diagnostics and matching
% ------------------------------------------------------------------------------
EDMCH=[D25cmb,IM46,D25cmc,DMM1m90cm,YCEM1H,DEM1A,QEM1H,BPMEM1H,QEM1H,DEM1B,QEM2H,BPMEM2H,QEM2H,DEM2B,XCEM2H,DMM3m80cm,YCEM3H,DEM3A,QEM3H,BPMEM3H,QEM3H,DEM3B,DEM3VH,DEM3VH,DMM4m90cm,XCEM4H,DEM4A,QEM4H,BPMEM4H,QEM4H,DMM5a,DXS1,DMM5b];
ECELL=[QE41,DQEC,DQEC,QE42,QE42,DQEC,DQEC,QE41];
EDSYS=[WS41,D40cm,DE3m80cma,XCE41,DQEA,QE41,BPME41,QE41,DQEBx,CX41,DQEBx2,DE3a,YCE42,DQEAa,QE42,BPME42,QE42,DQEBy,CY42,DQEBy2,WS42,D40cm,DE3m80cmb,XCE43,DQEAb,QE43,BPME43,QE43,DQEC,OTR43,DE3m40cm,YCE44,DQEA,QE44,BPME44,QE44,DQEC,WS43,D40cm,DE3m80cm,XCE45,DQEAc,QE45,BPME45,QE45,DQEBx,CX45,DQEBx2,DE3,YCE46,DQEA,QE46,BPME46,QE46,DQEBy,CY46,DQEBy2,WS44,D40cm];
UNMCH=[DU1m80cm,DCX37,D32cmc,XCUM1H,DUM1A,QUM1H,BPMUM1H,QUM1H,DUM1B,D32cm,DU2m120cm,DCY38,D32cma,YCUM2H,DUM2A,QUM2H,BPMUM2H,QUM2H,DUM2B,DU3m80cm,YCUM3H,DUM3A,QUM3H,BPMUM3H,QUM3H,DUM3B,D40cma,DU4m120cm,XCUM4H,DUM4A,QUM4H,BPMUM4H,QUM4H,DUM4B,RFB01H,DU5m80cm,IMUNDIH,D40cm,RWWAKEAl,DMUON2,DVV35,RFB02H,DTDUND1,TDUNDH,DTDUND2,PCMUONH,DMUON1,VVUNDH,DMUON3,MM3,PFILT1b];
LTUDIAG=[MM2,EDMCH,EDSYS,UNMCH];
LTU=[WALL,BSYEND,DCM5,VBEND,S4,MTCHH,S5,DBLDL];
S20LTU=[S0,M20_5,DLBP,S1,MTCH1,S2,BYPASS,SEQ06,MUWALL,LTU];
LTUH=[DBLDLH,S6,LTUDIAG];
% ------------------------------------------------------------------------------
% place holder for hard X-ray self-seeding
% ------------------------------------------------------------------------------
HSSCEL01=[DB6,DHSS01,DHSS01,DB3,DPMHSS01];
HSSCEL02=[DB6,DHSS02,DHSS02,DB3,DPMHSS02];
HSSCEL03=[DB6,DHSS03,DHSS03,DB3,DPMHSS03];
HSSCEL04=[DB6,DHSS04,DHSS04,DB3,DPMHSS04];
HSSCEL05=[DB6,QHSS05,XCHSS05,YCHSS05,QHSS05,DB3,BPMHSS05];
HSSCEL06=[DB6,QHSS06,XCHSS06,YCHSS06,QHSS06,DB3,BPMHSS06];
HSSCEL07=[DB6,DHSS07,DHSS07,DB3,DPMHSS07];
HSSCEL08=[DB6,DHSS08,DHSS08,DB3,DPMHSS08];
HSSCEL09=[DB6,QHSS09,XCHSS09,YCHSS09,QHSS09,DB3,BPMHSS09];
HSSCEL10=[DB6,DHSS10,DHSS10,DB3,DPMHSS10];
HSSCEL11=[DB6,DHSS11,DHSS11,DB3,DPMHSS11];
HSSCEL12=[DB6,QHSS12,XCHSS12,YCHSS12,QHSS12,DB3,RFBHSS12];
HSSCEL13=[DB6,DHSS13,DHSS13];
HXRSS=[HSSSTART,DB5,DBRK,HSSCEL01,DBRK,HSSCEL02,DBRK,HSSCEL03,DBRK,HSSCEL04,DBRK,HSSCEL05,DBRK,HSSCEL06,DBRK,HSSCEL07,DBRK,HSSCEL08,DBRK,HSSCEL09,DBRK,HSSCEL10,DBRK,HSSCEL11,DBRK,HSSCEL12,DBRK,HSSCEL13];
% ------------------------------------------------------------------------------
% hard X-ray undulator
% ------------------------------------------------------------------------------
% - DBRK10 = long undulator drift from BPM to segment with inline value
% - DBRK25 = long undulator drift from BPM to segment with inline value
% ------------------------------------------------------------------------------
VVU10H={'mo' '' 0 []}';%vacuum valve in HXR undulator
VVU25H={'mo' '' 0 []}';%vacuum valve in HXR undulator
DBRK10=[DBUVV1,VVU10H,DBUVV2];
DBRK25=[DBUVV1,VVU25H,DBUVV2];
HXSTBK01=[DTHXU,HXS01,HXS01,DTHXU];
HXSTBK02=[DTHXU,HXS02,HXS02,DTHXU];
HXSTBK03=[DTHXU,HXS03,HXS03,DTHXU];
HXSTBK04=[DTHXU,HXS04,HXS04,DTHXU];
HXSTBK05=[DTHXU,HXS05,HXS05,DTHXU];
HXSTBK06=[DTHXU,HXS06,HXS06,DTHXU];
HXSTBK07=[DTHXU,HXS07,HXS07,DTHXU];
HXSTBK08=[DTHXU,HXS08,HXS08,DTHXU];
HXSTBK09=[DTHXU,HXS09,HXS09,DTHXU];
HXSTBK10=[DTHXU,HXS10,HXS10,DTHXU];
HXSTBK11=[DTHXU,HXS11,HXS11,DTHXU];
HXSTBK12=[DTHXU,HXS12,HXS12,DTHXU];
HXSTBK13=[DTHXU,HXS13,HXS13,DTHXU];
HXSTBK14=[DTHXU,HXS14,HXS14,DTHXU];
HXSTBK15=[DTHXU,HXS15,HXS15,DTHXU];
HXSTBK16=[DTHXU,HXS16,HXS16,DTHXU];
HXSTBK17=[DTHXU,HXS17,HXS17,DTHXU];
HXSTBK18=[DTHXU,HXS18,HXS18,DTHXU];
HXSTBK19=[DTHXU,HXS19,HXS19,DTHXU];
HXSTBK20=[DTHXU,HXS20,HXS20,DTHXU];
HXSTBK21=[DTHXU,HXS21,HXS21,DTHXU];
HXSTBK22=[DTHXU,HXS22,HXS22,DTHXU];
HXSTBK23=[DTHXU,HXS23,HXS23,DTHXU];
HXSTBK24=[DTHXU,HXS24,HXS24,DTHXU];
HXSTBK25=[DTHXU,HXS25,HXS25,DTHXU];
HXSTBK26=[DTHXU,HXS26,HXS26,DTHXU];
HXSTBK27=[DTHXU,HXS27,HXS27,DTHXU];
HXSTBK28=[DTHXU,HXS28,HXS28,DTHXU];
HXSTBK29=[DTHXU,HXS29,HXS29,DTHXU];
HXSTBK30=[DTHXU,HXS30,HXS30,DTHXU];
HXSTBK31=[DTHXU,HXS31,HXS31,DTHXU];
HXSTBK32=[DTHXU,HXS32,HXS32,DTHXU];
QHXBLK01=[QHX01,XCHX01,MUQH,YCHX01,QHX01];
QHXBLK02=[QHX02,XCHX02,MUQH,YCHX02,QHX02];
QHXBLK03=[QHX03,XCHX03,MUQH,YCHX03,QHX03];
QHXBLK04=[QHX04,XCHX04,MUQH,YCHX04,QHX04];
QHXBLK05=[QHX05,XCHX05,MUQH,YCHX05,QHX05];
QHXBLK06=[QHX06,XCHX06,MUQH,YCHX06,QHX06];
QHXBLK07=[QHX07,XCHX07,MUQH,YCHX07,QHX07];
QHXBLK08=[QHX08,XCHX08,MUQH,YCHX08,QHX08];
QHXBLK09=[QHX09,XCHX09,MUQH,YCHX09,QHX09];
QHXBLK10=[QHX10,XCHX10,MUQH,YCHX10,QHX10];
QHXBLK11=[QHX11,XCHX11,MUQH,YCHX11,QHX11];
QHXBLK12=[QHX12,XCHX12,MUQH,YCHX12,QHX12];
QHXBLK13=[QHX13,XCHX13,MUQH,YCHX13,QHX13];
QHXBLK14=[QHX14,XCHX14,MUQH,YCHX14,QHX14];
QHXBLK15=[QHX15,XCHX15,MUQH,YCHX15,QHX15];
QHXBLK16=[QHX16,XCHX16,MUQH,YCHX16,QHX16];
QHXBLK17=[QHX17,XCHX17,MUQH,YCHX17,QHX17];
QHXBLK18=[QHX18,XCHX18,MUQH,YCHX18,QHX18];
QHXBLK19=[QHX19,XCHX19,MUQH,YCHX19,QHX19];
QHXBLK20=[QHX20,XCHX20,MUQH,YCHX20,QHX20];
QHXBLK21=[QHX21,XCHX21,MUQH,YCHX21,QHX21];
QHXBLK22=[QHX22,XCHX22,MUQH,YCHX22,QHX22];
QHXBLK23=[QHX23,XCHX23,MUQH,YCHX23,QHX23];
QHXBLK24=[QHX24,XCHX24,MUQH,YCHX24,QHX24];
QHXBLK25=[QHX25,XCHX25,MUQH,YCHX25,QHX25];
QHXBLK26=[QHX26,XCHX26,MUQH,YCHX26,QHX26];
QHXBLK27=[QHX27,XCHX27,MUQH,YCHX27,QHX27];
QHXBLK28=[QHX28,XCHX28,MUQH,YCHX28,QHX28];
QHXBLK29=[QHX29,XCHX29,MUQH,YCHX29,QHX29];
QHXBLK30=[QHX30,XCHX30,MUQH,YCHX30,QHX30];
QHXBLK31=[QHX31,XCHX31,MUQH,YCHX31,QHX31];
QHXBLK32=[QHX32,XCHX32,MUQH,YCHX32,QHX32];
HXCEL01=[PHSHX01,DBWM,DB4,HXSTBK01,DB1,QHXBLK01,DB3,RFBHX01];
HXCEL02=[PHSHX02,DBWM,DB4,HXSTBK02,DB1,QHXBLK02,DB3,RFBHX02];
HXCEL03=[PHSHX03,DBWM,DB4,HXSTBK03,DB1,QHXBLK03,DB3,RFBHX03];
HXCEL04=[PHSHX04,DBWM,DB4,HXSTBK04,DB1,QHXBLK04,DB3,RFBHX04];
HXCEL05=[PHSHX05,DBWM,DB4,HXSTBK05,DB1,QHXBLK05,DB3,RFBHX05];
HXCEL06=[PHSHX06,DBWM,DB4,HXSTBK06,DB1,QHXBLK06,DB3,RFBHX06];
HXCEL07=[PHSHX07,DBWM,DB4,HXSTBK07,DB1,QHXBLK07,DB3,RFBHX07];
HXCEL08=[PHSHX08,DBWM,DB4,HXSTBK08,DB1,QHXBLK08,DB3,RFBHX08];
HXCEL09=[PHSHX09,DBWM,DB4,HXSTBK09,DB1,QHXBLK09,DB3,RFBHX09];
HXCEL10=[PHSHX10,DBWM,DB4,HXSTBK10,DB1,QHXBLK10,DB3,RFBHX10];
HXCEL11=[PHSHX11,DBWM,DB4,HXSTBK11,DB1,QHXBLK11,DB3,RFBHX11];
HXCEL12=[PHSHX12,DBWM,DB4,HXSTBK12,DB1,QHXBLK12,DB3,RFBHX12];
HXCEL13=[PHSHX13,DBWM,DB4,HXSTBK13,DB1,QHXBLK13,DB3,RFBHX13];
HXCEL14=[PHSHX14,DBWM,DB4,HXSTBK14,DB1,QHXBLK14,DB3,RFBHX14];
HXCEL15=[PHSHX15,DBWM,DB4,HXSTBK15,DB1,QHXBLK15,DB3,RFBHX15];
HXCEL16=[PHSHX16,DBWM,DB4,HXSTBK16,DB1,QHXBLK16,DB3,RFBHX16];
HXCEL17=[PHSHX17,DBWM,DB4,HXSTBK17,DB1,QHXBLK17,DB3,RFBHX17];
HXCEL18=[PHSHX18,DBWM,DB4,HXSTBK18,DB1,QHXBLK18,DB3,RFBHX18];
HXCEL19=[PHSHX19,DBWM,DB4,HXSTBK19,DB1,QHXBLK19,DB3,RFBHX19];
HXCEL20=[PHSHX20,DBWM,DB4,HXSTBK20,DB1,QHXBLK20,DB3,RFBHX20];
HXCEL21=[PHSHX21,DBWM,DB4,HXSTBK21,DB1,QHXBLK21,DB3,RFBHX21];
HXCEL22=[PHSHX22,DBWM,DB4,HXSTBK22,DB1,QHXBLK22,DB3,RFBHX22];
HXCEL23=[PHSHX23,DBWM,DB4,HXSTBK23,DB1,QHXBLK23,DB3,RFBHX23];
HXCEL24=[PHSHX24,DBWM,DB4,HXSTBK24,DB1,QHXBLK24,DB3,RFBHX24];
HXCEL25=[PHSHX25,DBWM,DB4,HXSTBK25,DB1,QHXBLK25,DB3,RFBHX25];
HXCEL26=[PHSHX26,DBWM,DB4,HXSTBK26,DB1,QHXBLK26,DB3,RFBHX26];
HXCEL27=[PHSHX27,DBWM,DB4,HXSTBK27,DB1,QHXBLK27,DB3,RFBHX27];
HXCEL28=[PHSHX28,DBWM,DB4,HXSTBK28,DB1,QHXBLK28,DB3,RFBHX28];
HXCEL29=[PHSHX29,DBWM,DB4,HXSTBK29,DB1,QHXBLK29,DB3,RFBHX29];
HXCEL30=[PHSHX30,DBWM,DB4,HXSTBK30,DB1,QHXBLK30,DB3,RFBHX30];
HXCEL31=[PHSHX31,DBWM,DB4,HXSTBK31,DB1,QHXBLK31,DB3,RFBHX31];
HXCEL32=[PHSHX32,DBWM,DB4,HXSTBK32,DB1,QHXBLK32,DB3,RFBHX32];
HXRCL=[DBRK,HXCEL01,DBRK,HXCEL02,DBRK,HXCEL03,DBRK,HXCEL04,DBRK,HXCEL05,DBRK,HXCEL06,DBRK,HXCEL07,DBRK,HXCEL08,DBRK,HXCEL09,DBRK,HXCEL10,DBRK,HXCEL11,DBRK,HXCEL12,DBRK,HXCEL13,DBRK,HXCEL14,DBRK,HXCEL15,DBRK,HXCEL16,DBRK,HXCEL17,DBRK,HXCEL18,DBRK,HXCEL19,DBRK,HXCEL20,DBRK,HXCEL21,DBRK,HXCEL22,DBRK,HXCEL23,DBRK,HXCEL24,DBRK,HXCEL25,DBRK,HXCEL26,DBRK,HXCEL27,DBRK,HXCEL28,DBRK,HXCEL29,DBRK,HXCEL30,DBRK,HXCEL31,DBRK,HXCEL32];
%HXR : LINE=(HXRSTART,DF0,DB3,RFBHX00,HXRCL,DB0,HXRTERM)
HXR=[HXRSTART,DB3,RFBHX00,HXRCL,DB0,HXRTERM];
% ------------------------------------------------------------------------------
% HXR dump line
% ------------------------------------------------------------------------------
HUNDEXIT=[UEbegH,DUE1a,VV36H,DUE1d,IMUNDOH,DUE1b,BPMUE1H,DUE1c,QUE1H,QUE1H,DUE2a,XCUE1H,DUE2b,YCUE2H,DUE2c,QUE2H,QUE2H,DUE3a,BPMUE2H,DUE3b,PCPM0H,BTM0H,DUE3c,TRUE1H,DUE3d,DUE4,DUE5A,YCD3H,DUE5C,XCD3H,DUE5D,UEendH,DLSTARTH,DSB0a,VV37H,DSB0b,BPMUE3H,DSB0c,IMBCS3H,DSB0d,SEQ08];
HDUMPLINE=[BYD1Ha,BYD1Hb,DS,BYD2Ha,BYD2Hb,DS, BYD3Ha,BYD3Hb,DSc,PCPM1LH,BTM1LH,DD1a,IMDUMPH,DD1b,YCDDH,DD1f,PCPM2LH,BTM2LH,DD1c,QDMP1H,QDMP1H,DD1d,BPMQDH,DD1e,QDMP2H,QDMP2H,DD2a,XCDDH,DD2b,IMBCS4H,DD3a,BPMDDH,DD3b,OTRDMPH,DWSDUMPa,WSDUMPH,DWSDUMPb,DUMPFACEH,DMPendH,DD3d,DD3e,BTMDUMPH,EOLH];
% ------------------------------------------------------------------------------
% HXR safety dump line
% ------------------------------------------------------------------------------
HPERMDUMP=[SFTBEGH,DYD1,DSS1,DYD2,DSS2,DYD3,DScS1,VV38H,DScS2,PCPM1H,BTM1H,DPM1b,ST0,DST0,BTMST0,DMUSPL,ST1H,DST1,BTMST1H,DPM1c,PCPM2H,BTM2H,DPM1d,BXPM1Ha,BXPM1Hb,DPM1,BXPM2Ha,BXPM2Hb,DPM2,BXPM3Ha,BXPM3Hb,DSFT,SFTDMPH,DPM2e,BTMSFTH,DMPendHS];
% ------------------------------------------------------------------------------
% LTUS horizontal bend system and matching
% ------------------------------------------------------------------------------
CX53={'dr' 'CX53' 0.08 []}';% 3 mm half-gap in X in angled LTUS branch line
CY53={'dr' 'CY53' 0.08 []}';% 3 mm half-gap in Y in angled LTUS branch line 
CX54={'dr' 'CX54' 0.08 []}';% 3 mm half-gap in X in angled LTUS branch line
CY54={'dr' 'CY54' 0.08 []}';% 3 mm half-gap in Y in angled LTUS branch line 
DLH3S=[BX51a,BX51b,DHB1S,XCDL51,QDL51,BPMDL51,QDL51,YCDL51,DHB1S,BX52a,BX52b];
DLH4S=[DDLCa,CY53,DDLCb,CX53,D50D,DHB0S,XCDL52,QDL52,BPMDL52,WSLTUS2,QDL52,YCDL52,DHB0S,D50D,CX54,DDLCb,CY54,DDLCa];
DLH5S=[BX53a,BX53b,DHB1S,XCDL53,QDL53,BPMDL53,QDL53,YCDL53,DHB1S,BX54a,BX54b];
TRIP3S=[DDL5S,QT51,QT51,DDL1S,XCT52,QT52,BPMT52,QT52,YCT52,DDL2S,QT53,QT53,DDL1S,QT53A,QT53A,DDL5Sa,WSLTUS1,DDL5Sb];
TRIP4S=[DDL5Sb,WSLTUS3,DDL5Sa,QT54A,QT54A,DDL1S,QT54,QT54,DDL2S,XCT55,QT55,BPMT55,QT55,YCT55,DDL1S,QT56,QT56,DDL5S];
TRIP5S=[DDL5S,QT57,QT57,DDL1S,XCT58,QT58,BPMT58,QT58,YCT58,DDL1S,QT59,QT59,DDL5S];
UNMCHS=[DU1m80cmS,DCX37S,D32cmcS,XCUM1S,DUM1AS,QUM1S,BPMUM1S,QUM1S,DUM1BS,D32cmS,DU2m120cmS,DCY38S,D32cmaS,YCUM2S,DUM2AS,QUM2S,BPMUM2S,QUM2S,DUM2BS,DU3m80cmS,YCUM3S,DUM3AS,QUM3S,BPMUM3S,QUM3S,DUM3BS,D40cmaS,DU4m120cmS,XCUM4S,DUM4AS,QUM4S,BPMUM4S,QUM4S,DUM4BS,RFB01S,DU5m80cmS,IMUNDIS,D40cmS,DMUON2S,DVV35S,RFB02S,DTDUND1S,TDUNDS,DTDUND2S,PCMUONS,DMUON1S,VVUNDS,DMUON3S,MM3S];
LTUS=[SEQ09,DLH3S,TRIP3S,DLH4S,TRIP4S,DLH5S, TRIP5S,UNMCHS];
% ------------------------------------------------------------------------------
% place holder for soft X-ray self-seeding
% ------------------------------------------------------------------------------
% future self-seeding quads
SSSCEL01=[DB8,DSSS01,DSSS01,DB3,DPMSSS01];
SSSCEL02=[DB8,QSSS02,XCSSS02,YCSSS02,QSSS02,DB3,BPMSSS02];
SSSCEL03=[DB8,DSSS03,DSSS03,DB3,DPMSSS03];
SSSCEL04=[DB8,DSSS04,DSSS04,DB3,DPMSSS04];
SSSCEL05=[DB8,DSSS05,DSSS05,DB3,DPMSSS05];
SSSCEL06=[DB8,DSSS06,DSSS06,DB3,DPMSSS06];
SSSCEL07=[DB8,DSSS07,DSSS07,DB3,DPMSSS07];
SSSCEL08=[DB8,QSSS08,XCSSS08,YCSSS08,QSSS08,DB3,BPMSSS08];
SSSCEL09=[DB8,DSSS09,DSSS09,DB3,DPMSSS09];
SSSCEL10=[DB8,DSSS10,DSSS10,DB3,DPMSSS10];
SSSCEL11=[DB8,DSSS11,DSSS11,DB3,DPMSSS11];
SSSCEL12=[DB8,DSSS12,DSSS12,DB3,DPMSSS12];
SSSCEL13=[DB8,DSSS13,DSSS13,DB3,DPMSSS13];
SSSCEL14=[DB8,QSSS14,XCSSS14,YCSSS14,QSSS14,DB3,BPMSSS14];
SSSCEL15=[DB8,QSSS15,XCSSS15,YCSSS15,QSSS15,DB3,BPMSSS15];
SSSCEL16=[DB8,DSSS16,DSSS16,DB3,DPMSSS16];
SSSCEL17=[DB8,DSSS17,DSSS17,DB3,DPMSSS17];
SSSCEL18=[DB8,DSSS18,DSSS18,DB3,DPMSSS18];
SSSCEL19=[DB8,QSSS19,XCSSS19,YCSSS19,QSSS19,DB3,BPMSSS19];
SSSCEL20=[DB8,DSSS20,DSSS20,DB3,DPMSSS20];
SSSCEL21=[DB8,DSSS21,DSSS21,DB3,DPMSSS21];
SSSCEL22=[DB8,QSSS22,XCSSS22,YCSSS22,QSSS22,DB3,RFBSSS22];
SSSCEL23=[DB8,DSSS23,DSSS23];
SXRSS=[SSSSTART,DB7,DBRK,SSSCEL01,DBRK,SSSCEL02,DBRK,SSSCEL03,DBRK,SSSCEL04,DBRK,SSSCEL05,DBRK,SSSCEL06,DBRK,SSSCEL07,DBRK,SSSCEL08,DBRK,SSSCEL09,DBRK,SSSCEL10,DBRK,SSSCEL11,DBRK,SSSCEL12,DBRK,SSSCEL13,DBRK,SSSCEL14,DBRK,SSSCEL15,DBRK,SSSCEL16,DBRK,SSSCEL17,DBRK,SSSCEL18,DBRK,SSSCEL19,DBRK,SSSCEL20,DBRK,SSSCEL21,DBRK,SSSCEL22,DBRK,SSSCEL23];
% ------------------------------------------------------------------------------
% soft X-ray undulator
% ------------------------------------------------------------------------------
% - DBRK10S = long undulator drift from BPM to segment with inline value
% - DBRK25S = long undulator drift from BPM to segment with inline value
% ------------------------------------------------------------------------------
VVU10S={'mo' '' 0 []}';%vacuum valve in SXR undulator
VVU25S={'mo' '' 0 []}';%vacuum valve in SXR undulator
DBRK10S=[DBUVV1,VVU10S,DBUVV2];
DBRK25S=[DBUVV1,VVU25S,DBUVV2];
SXSTBK01=[DTSXU,SXS01,SXS01,DTSXU];
SXSTBK02=[DTSXU,SXS02,SXS02,DTSXU];
SXSTBK03=[DTSXU,SXS03,SXS03,DTSXU];
SXSTBK04=[DTSXU,SXS04,SXS04,DTSXU];
SXSTBK05=[DTSXU,SXS05,SXS05,DTSXU];
SXSTBK06=[DTSXU,SXS06,SXS06,DTSXU];
SXSTBK07=[DTSXU,SXS07,SXS07,DTSXU];
SXSTBK08=[DTSXU,SXS08,SXS08,DTSXU];
SXSTBK09=[DTSXU,SXS09,SXS09,DTSXU];
SXSTBK10=[DTSXU,SXS10,SXS10,DTSXU];
SXSTBK11=[DTSXU,SXS11,SXS11,DTSXU];
SXSTBK12=[DTSXU,SXS12,SXS12,DTSXU];
SXSTBK13=[DTSXU,SXS13,SXS13,DTSXU];
SXSTBK14=[DTSXU,SXS14,SXS14,DTSXU];
SXSTBK15=[DTSXU,SXS15,SXS15,DTSXU];
SXSTBK16=[DTSXU,SXS16,SXS16,DTSXU];
SXSTBK17=[DTSXU,SXS17,SXS17,DTSXU];
SXSTBK18=[DTSXU,SXS18,SXS18,DTSXU];
QSXBLK01=[QSX01,XCSX01,MUQS,YCSX01,QSX01];
QSXBLK02=[QSX02,XCSX02,MUQS,YCSX02,QSX02];
QSXBLK03=[QSX03,XCSX03,MUQS,YCSX03,QSX03];
QSXBLK04=[QSX04,XCSX04,MUQS,YCSX04,QSX04];
QSXBLK05=[QSX05,XCSX05,MUQS,YCSX05,QSX05];
QSXBLK06=[QSX06,XCSX06,MUQS,YCSX06,QSX06];
QSXBLK07=[QSX07,XCSX07,MUQS,YCSX07,QSX07];
QSXBLK08=[QSX08,XCSX08,MUQS,YCSX08,QSX08];
QSXBLK09=[QSX09,XCSX09,MUQS,YCSX09,QSX09];
QSXBLK10=[QSX10,XCSX10,MUQS,YCSX10,QSX10];
QSXBLK11=[QSX11,XCSX11,MUQS,YCSX11,QSX11];
QSXBLK12=[QSX12,XCSX12,MUQS,YCSX12,QSX12];
QSXBLK13=[QSX13,XCSX13,MUQS,YCSX13,QSX13];
QSXBLK14=[QSX14,XCSX14,MUQS,YCSX14,QSX14];
QSXBLK15=[QSX15,XCSX15,MUQS,YCSX15,QSX15];
QSXBLK16=[QSX16,XCSX16,MUQS,YCSX16,QSX16];
QSXBLK17=[QSX17,XCSX17,MUQS,YCSX17,QSX17];
QSXBLK18=[QSX18,XCSX18,MUQS,YCSX18,QSX18];
SXCEL01=[PHSSX01,DBWM,DB4,SXSTBK01,DB1,QSXBLK01,DB3,RFBSX01];
SXCEL02=[PHSSX02,DBWM,DB4,SXSTBK02,DB1,QSXBLK02,DB3,RFBSX02];
SXCEL03=[PHSSX03,DBWM,DB4,SXSTBK03,DB1,QSXBLK03,DB3,RFBSX03];
SXCEL04=[PHSSX04,DBWM,DB4,SXSTBK04,DB1,QSXBLK04,DB3,RFBSX04];
SXCEL05=[PHSSX05,DBWM,DB4,SXSTBK05,DB1,QSXBLK05,DB3,RFBSX05];
SXCEL06=[PHSSX06,DBWM,DB4,SXSTBK06,DB1,QSXBLK06,DB3,RFBSX06];
SXCEL07=[PHSSX07,DBWM,DB4,SXSTBK07,DB1,QSXBLK07,DB3,RFBSX07];
SXCEL08=[PHSSX08,DBWM,DB4,SXSTBK08,DB1,QSXBLK08,DB3,RFBSX08];
SXCEL09=[PHSSX09,DBWM,DB4,SXSTBK09,DB1,QSXBLK09,DB3,RFBSX09];
SXCEL10=[PHSSX10,DBWM,DB4,SXSTBK10,DB1,QSXBLK10,DB3,RFBSX10];
SXCEL11=[PHSSX11,DBWM,DB4,SXSTBK11,DB1,QSXBLK11,DB3,RFBSX11];
SXCEL12=[PHSSX12,DBWM,DB4,SXSTBK12,DB1,QSXBLK12,DB3,RFBSX12];
SXCEL13=[PHSSX13,DBWM,DB4,SXSTBK13,DB1,QSXBLK13,DB3,RFBSX13];
SXCEL14=[PHSSX14,DBWM,DB4,SXSTBK14,DB1,QSXBLK14,DB3,RFBSX14];
SXCEL15=[PHSSX15,DBWM,DB4,SXSTBK15,DB1,QSXBLK15,DB3,RFBSX15];
SXCEL16=[PHSSX16,DBWM,DB4,SXSTBK16,DB1,QSXBLK16,DB3,RFBSX16];
SXCEL17=[PHSSX17,DBWM,DB4,SXSTBK17,DB1,QSXBLK17,DB3,RFBSX17];
SXCEL18=[PHSSX18,DBWM,DB4,SXSTBK18,DB1,QSXBLK18,DB3,RFBSX18];
SXRCL=[DBRK,SXCEL01,DBRK,SXCEL02,DBRK,SXCEL03,DBRK,SXCEL04,DBRK,SXCEL05,DBRK,SXCEL06,DBRK,SXCEL07,DBRK,SXCEL08,DBRK,SXCEL09,DBRK,SXCEL10,DBRK,SXCEL11,DBRK,SXCEL12,DBRK,SXCEL13,DBRK,SXCEL14,DBRK,SXCEL15,DBRK,SXCEL16,DBRK,SXCEL17,DBRK,SXCEL18];
%SXR : LINE=(SXRSTART,DF0,DB3,RFBSX00,SXRCL,DB0,SXRTERM)
SXR=[SXRSTART,DB3,RFBSX00,SXRCL,DB0,SXRTERM];
% ------------------------------------------------------------------------------
% SXR dump line
% ------------------------------------------------------------------------------
SUNDEXIT=[DPOLS,UEbegS,DUE1a,VV36S,DUE1d,IMUNDOS,DUE1b,BPMUE1S,DUE1c,QUE1S,QUE1S,DUE2a,XCUE1S,DUE2b,YCUE2S,DUE2c,QUE2S,QUE2S,DUE3a,BPMUE2S,DUE3b,PCPM0S,BTM0S,DUE3c,TRUE1S,DUE3d,DUE4,DUE5A,YCD3S,DUE5C,XCD3S,DUE5D,UEendS,DLSTARTS,DSB0a,VV37S,DSB0b,BPMUE3S,DSB0c,IMBCS3S,DSB0d,SEQ10];
SDUMPLINE=[BYD1Sa,BYD1Sb,DS,BYD2Sa,BYD2Sb,DS, BYD3Sa,BYD3Sb,DSc,PCPM1LS,BTM1LS,DD1a,IMDUMPS,DD1b,YCDDS,DD1f,PCPM2LS,BTM2LS,DD1c,QDMP1S,QDMP1S,DD1d,BPMQDS,DD1e,QDMP2S,QDMP2S,DD2a,XCDDS,DD2b,IMBCS4S,DD3a,BPMDDS,DD3b,OTRDMPS,DWSDUMPa,WSDUMPS,DWSDUMPb,DUMPFACES,DMPendS,DD3d,DD3e,BTMDUMPS,EOLS];
% ------------------------------------------------------------------------------
% SXR safety dump line
% ------------------------------------------------------------------------------
SPERMDUMP=[SFTBEGS,DYD1,DSS1,DYD2,DSS2,DYD3,DScS1,VV38S,DScS2,PCPM1S,BTM1S,DPM1b,ST0,DST0,BTMST0,DMUSPL,ST1S,DST1,BTMST1S,DPM1c,PCPM2S,BTM2S,DPM1d,BXPM1Sa,BXPM1Sb,DPM1,BXPM2Sa,BXPM2Sb,DPM2,BXPM3Sa,BXPM3Sb,DSFT,SFTDMPS,DPM2e,BTMSFTS,DMPendSS];
% ------------------------------------------------------------------------------
% aggregate beamlines
% ------------------------------------------------------------------------------
LCLS2=[INJ,L1,BC1,L2,BC2,L3,S20LTU,LTUSPLIT];
LTUDUMPH=[LCLS2,LTUH,HXRSS,S7,HXR,HUNDEXIT,HDUMPLINE];
LCLS2H=[LCLS2,LTUH,HXRSS,S7,HXR,HUNDEXIT,HDUMPLINE];
LCLS2HS=[LCLS2,LTUH,HXRSS,S7,HXR,HUNDEXIT,HPERMDUMP];
LCLS2S=[LCLS2,LTUS,SXRSS,SXR,SUNDEXIT,SDUMPLINE];
LCLS2SS=[LCLS2,LTUS,SXRSS,SXR,SUNDEXIT,SPERMDUMP];
SPECT6=[GUNBXG,GSPEC];
SPECT135=[L0,DL1a,SPECBL];
BSYLTU=[MUWALL,LTU];
BSYLCLS2H=[BSYLTU,LTUH,HXRSS,S7,HXR,HUNDEXIT,HDUMPLINE];
BSYLCLS2S=[BSYLTU,LTUS,SXRSS,SXR,SUNDEXIT,SDUMPLINE];
BSYLCLS2HS=[BSYLTU,LTUH,HXRSS,S7,HXR,HUNDEXIT,HPERMDUMP];
BSYLCLS2SS=[BSYLTU,LTUS,SXRSS,SXR,SUNDEXIT,SPERMDUMP];
UNDLCLS2H=[LTUH,HXRSS,S7,HXR,HUNDEXIT,HDUMPLINE];
UNDLCLS2S=[LTUS,SXRSS,SXR,SUNDEXIT,SDUMPLINE];
% ==============================================================================
% SUBROUTINEs
% ==============================================================================
% match cathode beta's to get L0a-exit beta's (taken from Parmela, etc)
% (NOTE: MAD's matching routines use COUPLEd Twiss parameters, so the matched
%        BXC, AXC, BYC, and AYC values found by this routine will yield the
%        correct BX0, AX0, BY0, and AY0 values at L0A_exit only if propagated
%        using the TWISS, COUPLE command ... )










%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20
%SIMPLEX, TOL=1.E-20



% ------------------------------------------------------------------------------
% match injector into WS02B/OTR2B











%CONSTR, HTRUNDB, BETX>8, BETX<12, BETY>8, BETY<12


%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20
%SIMPLEX, TOL=1.E-20



% ------------------------------------------------------------------------------
% match BC1 chicane R56






%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20





% ------------------------------------------------------------------------------
% match through BC1 chicane into emittance measurement system











%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20






% ------------------------------------------------------------------------------
% match from BC1 into L2













%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



% ------------------------------------------------------------------------------
% match BC2 chicane R56






%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20





% ------------------------------------------------------------------------------
% match from L2 into BC2










%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20





% ------------------------------------------------------------------------------
% match from BC2 into L3

















%LMDIF, TOL=1.E-20, CALLS=10000
%MIGRAD, TOL=1.E-20, CALLS=10000





% ------------------------------------------------------------------------------
% suppress dispersion after sec-20 extraction









%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20


%    TWISS, BETX=1, BETY=1, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=DX,DY, 

% ------------------------------------------------------------------------------
% match from L3 into bypass line

















%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20


%    TWISS, BETA0=TWSSC, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=BC1mrk/S1, 

% ------------------------------------------------------------------------------
% set phase advance of FODO cell in bypass straight line






%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



% ------------------------------------------------------------------------------
% match from sec-20 extraction dogleg into long FODO straight section





%, UPPER= 1.0
%, LOWER=-1.0
%, UPPER= 1.0
%, LOWER=-0.12








%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



%    TWISS, BETA0=TWSSC, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=L3endB/MUWALL, 

% ------------------------------------------------------------------------------
% match dispersion in vertical bend module








%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20


%    TWISS, BETX=1, BETY=1, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=DX,DY, 

% ------------------------------------------------------------------------------
% match into BTHW vertical bends













%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20


%    TWISS, BETA0=TWSSC, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=L3endB/CNTV, 

% ------------------------------------------------------------------------------
% match R56 and find initial beta for two horizontal bend cells

























%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



%    TWISS, BETX=BX4m, ALFX=AX4m, BETY=BY4m, ALFY=AY4m, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, 

% ------------------------------------------------------------------------------
% match into BTH horizontal bends



















%LMDIF, TOL=1.E-20, CALLS=10000
%MIGRAD, TOL=1.E-20



%    TWISS, BETA0=TWSSC, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=MUWALL/#E, 

% ------------------------------------------------------------------------------
% match emit-diag FODO for 45-deg wire-to-wire phase advance






%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



% ------------------------------------------------------------------------------
% find periodic beta's at LTU emit-diag wires













%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20



% ------------------------------------------------------------------------------
% match from horiz. bend cells into emit-diag section












%LMDIF, TOL=1.E-20
%MIGRAD, TOL=1.E-20


%    TWISS, BETX=BX4m, ALFX=AX4m, BETY=BY4m, ALFY=AY4m, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, 

% ------------------------------------------------------------------------------
% match Twiss through HXR self-seeding to entrance of HXR undulator

















% these two points are at beta waist ends








%LMDIF, TOL=1.E-20, CALLS=5000
%MIGRAD, TOL=1.E-20



%PRINT, UNMCH/QHX04[2]
%TWISS, BETA0=TWSSC, SAVE
%PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=UNMCH/QHX04[2], 

% ------------------------------------------------------------------------------
% match through LTUS horizontal bend system
% Note: Set distance between collimators (D_col) for 90 deg separation
% according to D_col = D_ws/sqrt(3), where D_ws is distance between
% outer wires with 120 deg separation.






%, UPPER=0





%LMDIF, TOL=1.E-20, CALLS=5000
%MIGRAD,TOL=1.E-20


%    PRINT, FULL
%    TWISS, BETX=BX4m, ALFX=AX4m, BETY=BY4m, ALFY=AY4m, SAVE
%    PLOT, TABLE=TWISS, HAXIS=S, VAXIS1=BETX,BETY, VAXIS2=DX, 

% ------------------------------------------------------------------------------
% match Twiss through SXR self-seeding to entrance of SXR undulator

























%LMDIF, TOL=1.E-20, CALLS=5000
%MIGRAD, TOL=1.E-20



%PRINT, UNMCHS/QSX04[2]
%TWISS, BETA0=TWSSC, SAVE
%PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, RANGE=UNMCHS/QSX04[2], 

% ------------------------------------------------------------------------------
% match HXR e- dump




% keep COUPLE here











%LMDIF, TOLER=1.E-20, CALLS=2000
%MIGRAD


%PRINT, HUNDEXIT/#E
%TWISS, BETA0=TWSSwh, SAVE
%PLOT, TABLE=TWISS, HAXIS=S, VAXIS1=BETX,BETY, VAXIS2=DX,DY, 

% ------------------------------------------------------------------------------
% match SXR e- dump




% keep COUPLE here











%LMDIF, TOLER=1.E-20, CALLS=2000
%MIGRAD


%PRINT, SUNDEXIT/#E
%TWISS, BETA0=TWSSws, SAVE
%PLOT, TABLE=TWISS, HAXIS=S, VAXIS1=BETX,BETY, VAXIS2=DX,DY, 

% ==============================================================================
% COMMANDs
% ==============================================================================



% ------------------------------------------------------------------------------
% initial SURVEY coordinates
% ------------------------------------------------------------------------------
% set initial linac survey coordinates
% (NOTE: pitch is not included here for simplicity - for linac coordinates,
%        read in pitched plane of linac)
XLL = 10.9474                   ;%X at loadlock start [m] (same as LCLS-I cathode X-location - 02/01/2011, PE)
ZLL = 1001.1996                 ;%Z at loadlock start [m] (LCLS-I cathode Z-location, minus 1016.000000 m - 02/01/2011, PE)
Xi  = XLL+LOADLOCK{3}*sin(ADL1) ;%X at cathode [m]
Zi  = ZLL+LOADLOCK{3}*cos(ADL1) ;%Z at cathode [m]
% set initial BSY survey coordinates
Xf     =  XOFF            ;%hor. position of LTU2 at Mu-Wall is |XOFF| to the south of linac axis [m]
Yf     =  YOFF*cos(2*AVB) - 0.743498 ;%ver. position of LTU2 at Mu-Wall is YOFF above linac axis + LCLS-I Ypos at Mu-Wall entrance) [m]
Zf     =  159.256691 - sin(2*AVB)*YOFF  ;%Z-location (wrt S100?) at entrance of Mu-Wall (taken from LCLS-I and add z-shifted effect of YOFF) [m]
THETAf =  0               ;%no yaw of LTU2 at Mu-Wall
PHIf   =  2*AVB           ;%S100 pitch in undulator coordinates
PSIf   =  0               ;%no roll of LTU2 at Mu-Wall
% set initial UND survey coordinates (z is parallel to undulators, Y = 0, and HXR is at X = 0 & SXR at X = -2.5 m)
Xu     =  0               ;%hor. position of HXR is zero [m]
Yu     =  0               ;%ver. position HXR & SXR is zero [m]
Zu     = -208.951187+1000 ;%Local-undulator coordinates have Z=1000.000000 m at HSSSTART and SSSSTART (near start of und tunnel)
THETAu =  0               ;%yaw angle of LTU2 after 4 hor. bends is defined as zero (prior to LTUS)
PHIu   =  0               ;%pitch angle is defined as zero
PSIu   =  0               ;%roll angle is defined as zero
% ------------------------------------------------------------------------------
% output files for RDB generation
% ------------------------------------------------------------------------------
%CALL, FILENAME="makeSymbols.mad8"
% ------------------------------------------------------------------------------
% matching
% ------------------------------------------------------------------------------
%CALL, FILENAME="MGUN.mad8" 
%COMMENT

%LHund_OFF


%MBC1R56
%MBC1
%ML2
%MBC2R56
%MBC2
%ML3





%MSTRTVB










%ENDCOMMENT
% ------------------------------------------------------------------------------
% Twiss plots
% ------------------------------------------------------------------------------
%COMMENT 




















%ENDCOMMENT
%COMMENT 









%ENDCOMMENT
% ------------------------------------------------------------------------------
% chromatic function plots
% ------------------------------------------------------------------------------








% ------------------------------------------------------------------------------
% standard output files
% ------------------------------------------------------------------------------
% HXR full machine (linac coordinates): cathode to HXR dump
% =========================================================






% SXR full machine (linac coordinates): cathode to SXR dump
% =========================================================






% Gun Spectrometer (linac coordinates): cathode to 6 MeV spectrometer dump
% ========================================================================






% 135 MeV Spectrometer (linac coordinates): cathode to 135 MeV spectrometer dump
% ==============================================================================






% get Twiss at entrance to muon wall









% HXR LTU to Dump (BSY coordinates): muon wall to HXR dump
% ========================================================




%  TWISS, BETA0=TWSSw

% HXR LTU to Safety Dump (BSY coordinates): muon wall to HXR safety dump
% ======================================================================




%  TWISS, BETA0=TWSSw

% SXR LTU to Dump (BSY coordinates): muon wall to SXR dump
% ========================================================




%  TWISS, BETA0=TWSSw

% SXR LTU to Safety Dump (BSY coordinates): muon wall to SXR safety dump
% ======================================================================




%  TWISS, BETA0=TWSSw

% Now dump LTUH, LTUS, HXR, and SXR in LCLS-II local undulator coordinates:
% HXR LTUH to Dump (LCLS-II local undulator coordinates)
% ======================================================





% SXR LTUS to Dump (LCLS-II local undulator coordinates)
% ======================================================





% ------------------------------------------------------------------------------

beamLine.LCLS2=LCLS2';
beamLine.LCLS2H=LCLS2H';
beamLine.LCLS2S=LCLS2S';
beamLine.SPECT6=SPECT6';
beamLine.SPECT135=SPECT135';
