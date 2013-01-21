function beamLine = model_beamLinetest()

CLIGHT = 2.99792458e8;  % speed of light [m/s]
TWOPI  = 2*pi;
RADDEG = pi/180;
EMASS  = 0.510998910e-3;  % electron rest mass [GeV/c]

clight = 2.99792458e8;  % speed of light [m/s]
LQGX   = 0.076;                  % QG quadrupole effective length [m]
IMS1={'mo' 'IMS1' 0 []}';%135-MeV spectrometer
LBRL = 0.52974;
UNDSTART={'mo' 'UNDSTART' 0 []}';
UNDTERM={'mo' 'UNDTERM' 0 []}';
LSTPR  = 0.3046;
LSOL1    = 0.200;
DLD3    = 0.300+0.167527-0.1799554;
DLD4    = 0.200+0.1799554;
XC11={'mo' 'XC11' 0 []}';
YC11={'mo' 'YC11' 0 []}';
XCA11={'mo' 'XCA11' 0 []}';
YCA11={'mo' 'YCA11' 0 []}';
XCA12={'mo' 'XCA12' 0 []}';
YCA12={'mo' 'YCA12' 0 []}';
SC11=[XC11,YC11];
SCA11=[XCA11,YCA11];
SCA12=[XCA12,YCA12];

% *** OPTICS=LCLS28MAY10 ***


% ==============================================================================
% Element naming conventions with the first 1-3 characters meaning:
% ---------------------------------------------------------------------------
% SOL.. = SOLenoid magnet (not fully modeled in this file - zero-length, etc)
% Q.... = Quadrupole magnet (normal quad, and always split into two halves)
% SQ... = Skew-Quadrupole magnet (45-deg rotated quad, always split into two halves)
% CQ... = Correction Quadrupole magnet (nominally set to zero field, always split)
% BX... = Horizontal Bend magnet (always split in two with suffixes "A" and "B")
% BY... = Vertical Bend magnet (always split in two with suffixes "A" and "B")
% WS... = Wire-Scanner transverse beam profile monitor
% PR... = screen-type Profile Monitor (transverse beam profile)
% YAG.. = YAG-screen profile monitor (transverse beam profile)
% BPM.. = Beam Position Monitor (various resolutions, see TYPE=...)
% RFB.. = RF Beam position monitor (<1 micron rms resolution)
% OTR.. = Optical Transition Radiation transverse beam profile monitor
% CTR.. = Coherent Transition Radiation measurement
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
% VV... = Vacuum Valve
% FC... = Faraday Cup (measure charge)
% CR... = Cerenkov radiator
% AM... = Alignment Mirror
% PH... = Phase detector
% RST.. = Radiation STopper
% BFW.. = Beam Finder Wire in FEL undulator for segment alignment
% BTM.. = Burn-Through Monitor BCS device
% ==============================================================================
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 28-MAY-2010, M. Woodley
%    Add CQ31 and CQ32 in DL2 (per P. Emma); add TRUE1 Be foil inserter for
%    THz radiation (per H. Loos and D. Rich)
% 04-JAN-2010, M. Woodley
%    Name change: BPM304001T becomes BPMBSY1; add SQ13 in BC1
% 17-MAR-2009, M. Woodley
%    Switch locations of YCUE1 and XCUE1 ... YCUE1 becomes YCUE2 (per P. Emma);
%    change IM61 from INST to MARK (this toroid is no longer used and will now
%    become "non MAD" in the Oracle "Elements" table); measured locations of
%    some LTU/DMP correctors; add WSDL31 and WSDUMP
% 10-OCT-2008, P. Emma
%    Eliminate old "ST1" safety-dump stopper (but keeping a marker there with its
%    empty can) and rename old "ST2" to "ST1".  Note that the new "ST2" (was "ST3")
%    is not in the safety-dump line, but is in the x-ray line.
% 30-SEP-2008, M. Woodley
%    Change all vacuum valves from INST to MARK (these devices will now become
%    "non MAD" in the Oracle "Elements" table); rename "PVALVE" to "VV999";
%    remove references to XRAYBL
% 25-SEP-2008, M. Woodley
%    Change all DBMARKers from INST back to MARK, since MARKs now show up in
%    the Excel SYMBOLS file; change BPMBSY51 (used to be BPM460051T) from MONI
%    to MARK ... the physical device is still there, but it won't be read out
% 18-SEP-2008, M. Woodley
%    For XAL model generation:
%    - split and change names of the 52-line wiggler sections (from B52WIG1-4
%      to B52WIG1A-B, B52WIG2A-B, B52WIG3A-B)
%    - add TILT to definition of SQ01;
%    for SYMBOLS file generation:
%    - add CALL (normally commented out) to makeSymbols.mad
% 18-SEP-2008, M. Woodley
%    Fix structure counts in computation of "gfac3"; fix Q52Q2 (don't divide
%    length by 2, change polarity to "QD")
% 11-SEP-2008, P. Emma
%    Update TWSS0 beta's based on real measurements and re-fit QA01-QE04 for match
%    at OTR2 with laser-heater chicane and undulator ON (BETX=BETY=12 m at HTRUND).
%    All XCs, YCs, and BPMs with "**4600...", "**9200...", and "**9210..." names
%    now changed to "**BSY...".
% 10-SEP-2008, P. Emma
%    Set TDKIK to 24" long (was 0). Also change "I50I1A" to IMBSY34 (TORO CA11 34).
%    Also move a few dumpline components (BPM & corr's) slightly and swap IMDUMP
%    with IMBCS4 per Rago.
% 08-AUG-2008, P. Emma
%    Change names of 6 old BSY BPMs from BPM920020 to BPMBSY61, etc, and 4 old
%    correctors from XC920020T --> XCCA1160, etc.
% 30-JUL-2008, H.-D. Nuhn
%    Adjust z-locations of BFW01-BFW33, QU01-QU33, and BPM01-BPM03 to include
%    precise length measurements. The adjusted lengths are:
%       DF0:   LQu-0.0417  -> LQu-0.04241                 No quad + correction to maintain symmetry
%       Lbr1:  6.96E-2     -> 6.889E-2                    und-seg to quad [m]
%       Lbr3:  9.117E-2    -> 9.111E-2                    quad to BPM [m]
%       Lbrwm: 3.6881E-2   -> 7.1683E-2                   BFW to radiation monitor [m]
% 13-JUL-2008, P. Emma
%    Set BYD1,2,3 to FINT = 0.57, based on magnetic measurements. Set up L3 MUX
%    to get nearly 45-deg per S28 wire (all new quad settings from QM22 through
%    QVM4).  Update PCMUON ID. Move XCM13/YCM12 center to 14" downstream of QM13
%    center as done in tunnel in July to allow L2 feedback and QM13 quad scans.
%    Change BXH1-4 FINT from 0.5 (guess) to 0.400 (measured) and increase Leff
%    of BXH1-4 from 0.110 m (R. Carr from 2005) to 0.1244 m (measured).
% 25-MAR-2008, H.-D. Nuhn
%    Remove Radiation Monitors (RDM) in the Undulator section. They will be
%    handled as Non-MAD elements.
% 06-MAR-2008, P. Emma
%    Move laser heater components by ~1" adjustments per Joe Steiber and remove
%    YAG04 in prep. for Nov. '08 laser-heater installation.  Matching now done
%    and used here with laser-heater chicane AND undulator ON (FINT=0.5).  Also
%    switch BBh1 fit to use only DL1 at Ei=135 MeV (was L0b,DL1 at 64 MeV).
% 21-FEB-2008, P. Emma
%    Move Q24701B, BPM24701, and BPM24901 based on tunnel tape measurements.
%    (~1" move of Q24701B plus re-fit strength).  Rename sec-28 wires and move
%    RFB08 a bit.  Add and update a few DBMARKers.  Move XCEM4 0.402839 m upstream
%    for Kay Fox.  Change all DBMARKers from MARK to INST so that they show up
%    in the EXCEL symbols file.  Move YCDL1, XCDL3, YCDL3, YCDL4 per K. Fox
%    E-mail of 2/21/08.
% 04-NOV-2007, P. Emma
%    Move CX31, CY32, CX35, CY36, PCTDKIK1, PCTDKIK2, PCTDKIK3, and PCTDKIK4
%    downstream by half their length so that they have the right Z in the EXCEL
%    files.  Also modify LCLS_L3.xsif file (see comments there).
% 21-OCT-2007, P. Emma
%    Locate YC5, XC6, XCA0, and YCA0 properly after installed.  Move components
%    in and around safety dump for J. Langton (new version of XRAYBL file).
% 04-OCT-2007, P. Emma
%    Remove accidental extra YCA0 just after QA0.
% 28-SEP-2007, P. Emma
%    Move many components in the BC2, L3, LTU, and dump areas based on input from
%    R.F. Boyce, P. Cutino, T. Montagne, and J. Langton.  WS21-24 become marker
%    points named DWS21-24 (no longer in baseline design due to money limits).
%    Some components in BC2 are left up to 0.3 mm offset in z (too small for
%    effort). Remove K25_1c, 1d, and K28_5d 10-ft sections (not re-installed
%    anymore - makes 164 10-ft, 25% power sections in L3 rather than 167).
%    Add PH03 and remove MUSPLR.  Added ST1, 2, 3, and severak BTM's plus moved
%    SFTDMP from Z' = 717.514485 m to 719.7361 m.  Also added 52-line optics as
%    another output file.  Also BX21-24 FINT changed from 0.5 to 0.633
%    (measured Sep. 2007).  Also removed (descoped) CX37 and CY38 (now drifts
%    DCX37 & DCY38).  BYKIK becomes two series magnets -> BYKIK1 & BYKIK2.
%    PCTDKIK now in 4 pieces (PCTDKIK1, 2, 3, 4).  CTRWIG, PRXRAY, BYW1, BYW2,
%    and BYW3 all descoped.  Reduced LSPONT from 2.5 m to 1.5 m, removed VV35
%    and replaced with PVALVE (rename to VV35 soon?).  BX21-24 Leff changed from
%    0.540 m to 0.549 m based on magnetic measurements (no z-shifts). Removed
%    PRTDUND (descoped) and set PCMUO to 46" long (was 36" long).
% 07-APR-2007, P. Emma
%    Move a few and add some components in the dump and safety dump for J. Langton.
% 17-MAR-2007, P. Emma
%    Move a few BC2 components for Steve Score (IMBC2I, VV21, BPM24701, QM21, QM22).
%    Set Leff of BYD1-3 to 1.452 m (was 1.399951 m) from J. Tanabe.
% 06-MAR-2007, P. Emma
%    Change 'Q150kG' pole-tip radius to 16 mm (was 11.5 mm).  Changed fit routine
%    "MBChETA" to "USE, (L0b,DL1)".  Was mistakenly (?) set to "USE, DL1", but
%    with TWSS0 (64 MeV).
% 20-FEB-2007, P. Emma
%    BXG bend radius changed from 0.1967 m to 0.1963 m based on magnetic
%    measurements (per D. Dowell - FINAL).  Refit QG02 & QG03 and move DBMARK81
%    from Z = 2018.712185 m to Z = 2018.712486 m.
% 15-FEB-2007, P. Emma
%    BXG bend radius changed from 0.193188 m to 0.1967 m based on magnetic
%    measurements (per D. Dowell).  Refit QG02 & QG03 and move DBMARK81 from
%    Z = 2018.714822 m to Z = 2018.712185 m.
% 11-FEB-2007, P. Emma
%    BXG effective length changed from 0.2660 to 0.2866 m based on magnetic
%    measurements.  Requires moving bend center a bit and re-fitting QG02-03.
%    This also moves DBMARK81 (BXG entrance) upbeam from Z = 2018.725244 m to
%    Z = 2018.714822 m.  Remove "GTL_ON" flag (no longer used).
% 10-FEB-2007, P. Emma
%    BXG edge angle changed from 26.76 to 24.25 degrees, and FINT from 0.45
%    to 0.492, and BXS edge angle from 7.5 to 7.29 degrees, all based on magnetic
%    measurements. Move XC08/YC08 upbeam by 0.03 m, XCS1/YCS1 upbeam by 0.04 m,
%    XC10/YC10 downbeam by 0.03 m, YC21303 downbeam by 0.1 m, all based on tunnel
%    tape measurements. Change Q150kG quad Leff from 0.300 to 0.316 m (per R. Carr).
%    Adjust zpos of QA11, Q21201, Q21301, QM14, and QM15 per Hans Imfeld
%    list of final (constrained) alignment results (search for "dz_").  Move
%    OTRS1 upbeam 2 cm until more precise number available (no adjustment left).
%    Add DBMARK98 (SDMP) to list of reference points in z.
% 15-DEC-2006, P. Emma
%    Move WS21,22,23 upbeam by 4 feet each to reduce possible quad-reflected dark
%    charge.  Set BXS effective length to 0.5435 m (was 0.5 m) after measurement
%    and re-adjust QS01 and QS02 settings to compensate.
% 14-DEC-2006, H.D. Nuhn
%   Add two inline valves in the undulator line:
%   (1) VVU10 between US09 and US10,
%   (2) VVU25 between US24 and US25.
%   The exact locations are expected to require slight adjustment as
%   the design is finalized.
% 10-DEC-2006, P. Emma
%   Move BXKIK to 25-3d where it will fit after removing the 25-3d RF acc.
%   structure.  Also add OTR22 near BXKIK.  Move XC01/YC01 1/8" (3.175 mm) upbeam.
%   Change BXS FINT from 0.45 to 0.391, based on magnetic measurements (no associated
%   quad setting changes necessary).  Adjust post-BC2 component locations per S. Score.
%   Move BPM2 to 0.892574 m from cathode per K. Fox.  Move (~6 in.) XC24202, YC24203,
%   YC24403, YC24503, YC24603, XC24702 per T. Osier (all in L2-linac file).
% 26-NOV-2006, P. Emma
%   Move nomimal beam waist to between WS02 and OTR2, rather than at WS02, then
%   rematch, which slightly changes many nearby quad settings.  Add BL22. Also
%   reduce effective length of the 12 "Q150kG" quads from 0.46092 m to 0.300 m
%   in prep. for better number (with dLQA2 parameter). Finally, add x-ray
%   beamline input file: XRAYBL.xsif.  Move IMBC2O from QM22 area to upbeam of
%   BXKIK (TCAV3 center still not agreeing with Jose?).
% 01-NOV-2006, H.D. Nuhn
%   Name all 33 undulator segments individually: US01-US33. Use new names
%   GIRD01-GIRD33 and USTBK01-USTBK33 to improve clarity of undulator line.
% 24-OCT-2006, P. Emma
%   Remove QG01 quad from GTL beamline permanently.  Change BX11,12,13,14 FINT
%   from 0.5 to 0.387 (measured).
% 15-OCT-2006, P. Emma
%   Set the new BSY correctors (XC6, YC5, XCA0, and YCA0) to more realistic
%   locations based on Jim Turner's tunnel inspection. Move some BC2 stuff for
%   Steve Score.  Also move WS21,22,23 for Jose Chan.
% 21-SEP-2006, P. Emma
%   Set BX01,02 FINT and FINTX to 0.45 based on mag. measurements (was 0.5).
%   Adjust collimator gaps a bit, including PCPM1,2.  Also move YAG03,04,S1,S2
%   0.323" upstream so that YAG crystal center is defined as the MAD location,
%   not the mirror as before (YAG01,02,G1 are a different design).
% 15-AUG-2006, P. Emma
%   Set BYD1,2,3 full pole gap (hor. in this case) to 43 mm (was 23 mm). Remove
%   IMPM toroid from safety dumpline - not needed.  Set BPMUE1,2,3 res. to 10 um
%   (was 5).  Lengthen BC2 bends from 50 cm to 54 cm (CSR emit increase only 1%),
%   but do not change overall length or R56.  Add VV22 vacuum valve after BC2.
% 07-AUG-2006, M. Woodley
%   Change "DVBm25cm" and "DVBm25cmc" to "DVB25cm" and "DVB25cmc" because of 8
%   character element name limit in skeleton decks (names that are longer than
%   8 characters are OK if they are unique in their first 8 characters ... they
%   will be truncated at 8 characters in the skeleton decks); add new Database
%   MARKer points to delineate skeleton deck boundaries; reinstate LI30
%   wraparound quads (QUAD LI30 615 and QUAD LI30 715) as quadrupoles (NOTE:
%   uses negative drifts); change "T850034T" to "I50I1A"; eliminate use of MAD
%   element CLASS definitions ("inheritance"); add VALUE commands for MATRIX
%   elements; add SAVELINE commands for use in skeleton deck generation
% 18-JUL-2006, H.D. Nuhn
%   Corrected placement of all undulator break section components. Added marker
%   for radiation monitor. Modified RF BPM to zero length, located at the center
%   of the dipole cavity.
% 16-JUL-2006, P. Emma
%   Move a few components in the VVX2 to BPMM14 region per J. Langton.
% 22-JUN-2006, P. Emma
%   Move OTR11 36 mm downbeam, per J. Langton.  Fix comments in undulator area and
%   prepare for small adjustments of RFBPMs, etc from H.-D. Nuhn (temporarily change
%   RFBPM length from 5 to 4 inches so that "Lbr2s" drift length is > 0). Set
%   energy in safety-dump file to right value, rather than 6 MeV. Also eliminate
%   TD21 (post BC2 dump) as unnecessary.
% 15-MAY-2006, P. Emma
%   Adjust WS01,2,3 positions to match drawings and fix small errors in MAD file,
%   and move BPM10 upbeam ~1 inch to its electrical center (center of strip length),
%   all per R.F. Boyce.  Remove GSDMP (gun-spec. dump) - not a real device.
% 09-MAY-2006, P. Emma
%   Move SOL2 downstream by 3 mm per R.F. Boyce. Move PH02 upbeam by 0.1017 m,
%   XC21302 upbeam by 14.2 mm, BL12 upbeam by 152.4 mm, and YC21303 upbeam by
%   63 mm, all per Joe Steiber.
% 26-APR-2006, P. Emma
%   Move XC04-YC04 and XC05-YC05, per P. Stephens.
% ------------------------------------------------------------------------------
% 23-MAR-2006, P. Emma
%   Remove FCS1 as should have been done last time.  Slide IMBC1O upbeam
%   about 1 inch per Tom Borden. Move SC7, QA01, QA02, PH01, QE03,
%   QE04, IM02, and VV02 per R.F. Boyce (2-inch is maximum move of these).
% 16-MAR-2006, P. Emma
%   Replace laser-heater undulator SBEN's with MATRIX element.  Changes vert.
%   focusing causing QA01/02 25% stringer with much smaller betaY in L0-b.
%   SUM(L) gets 6 microns shorter at BXH4B-exit. Add 4 BCS toroids (IMBCS1,
%   IMBCS2, IMBCS3, IMBCS4). First two are DL2 comparator and 2nd two are
%   main dump comparator. Remove OTRH1,2 until Nov. '07 installation. Add
%   temporary YAG04 (until Nov. '07) very near future OTRH2 location.
%   Change K of Laser-htr und. to 765-nm resonance (was 800 nm). Move SC2
%   to 2.366320 m in SUM(L) from cathode (was 2.65 then 2.5 m but won't fit).
%   Adjust undulator BPMs, BFWs, and quads to Heinz-Deiter's spacing, add
%   XCUn and YCUn (n=1-33) steering coils to each undulator quad center.
%   Adjust undulator quad length from 7.4 cm to 7.8 cm (ESD 1.4-102) keeping
%   all integrated gradients at 3.000 T. Add BL12, ceramic-gap type bunch
%   length moinitor, just after BC1 (per T. Borden). Add PH02 phase monitor
%   cavity after BC1 (per T. Borden). Move XC21302, YC21303, QM14, and QM15
%   per T. Borden, and put BPMM14 inside QM14. Place SCM15 (as XCM14/YCM15)
%   between QM14 and QM15 (were seperate magnets on either side of doublet).
%   Remove PRTD11 (not easily added to old SLC FF TD-23 stopper). Remove
%   RFB01-06 from LTU (ID too small and RFB07-08 do the job). Swap YAGS2
%   and OTRS1 positions and adjust their locations to fit. Add R(5,6) of
%   laser-heater undulator. Swap VV04 & SC8 and tweak Z per Wing. Tweak
%   BPMS3, YAGS2, and OTRS1 positions per Wing. HTRMID renamed to HTRUND.
%   Also moved SC11, SCA11, SCA12, YC21203, and XC21202 in LCLS_L1.xsif per
%   P. Stephens.  Finally, removed VV0A per Leif, and moved YC21303 upbeam
%   of WS13 to make room for McCormick's fast ion chamber in front of TD11.
% 21-FEB-2006, P. Emma
%   TCAV0 flange to flange is 0.6680236 m (was 0.55 m).  Adjust z-pos of
%   BPMS1, IMS1, BPMS3 and XC08/YCO8 per Wing and Cecile. Adjust SC3, YAG03,
%   TCAV0, SC6, and add VV0a, all per P. Stephens. Add BFW's to undulator.
% 11-FEB-2006, P. Emma
%   Change BXS gap to 34 mm for Rago to fit chamber (no X-focus effect).
%   Add serial numbers for Q21201-601 for post-Aug-2006 magnets.  Change
%   BC1 dipole gap (43->43.28 mm).
% 04-FEB-2006, P. Emma
%   Move DL1 and SAB devices per Cecile and Wing and move SOL2-center to
%   171.4 cm downstream of cathode (per Cecile and M. Palrang). Also change
%   BC1 and BC2 dipole gaps (30->43 mm and 25.4->33.35 mm, respectively).
% 25-JAN-2006, P. Emma
%   Move VV03 ~12 cm.
% 17-JAN-2006, P. Emma
%   Fix a few corrector types to be consistemt with PRD 1.1-007-r1 (especially
%   make SC2 type-1s-L0a (0.003 kG-m max.).  Also add HGAPs and edge angles
%   to BXKIK and BYKIK (does nothing but document, since these are off). Loosen
%   HTRMID fit from exactly 10 m BETAX,Y to 8<BETA<12 (better WS02 fit).
% 05-JAN-2006, P. Emma
%   Save KQS01,2 & KQM01,2 settings in comments for OTRS1 3-keV resolution.
%   Move SOL2 center to 1.654 m after cathode (per Cecile) and move SC2 center
%   to 2.650 m after cathode. Splits L0a into 7 segments rather than 6.
%   Replace QE31-36 quads with "ETA" type (were 'QE' type and FFTB b4 that).
% 20-DEC-2005, P. Emma
%   Reverse BXH1 to negative field (& angle), also reversing BXH2,3,4.  This
%   pushes the laser-heater undulator close to the north-east wall of the
%   injector vault, as preferred by Alan Miahnahri. Place CRG1 after YAGG1 (i.e.,
%   switch their order). [Fix OTR11 to type='OTR' on Jan. 02, '06.]. [Make
%   "MUSPLR" an ECOL, as it always should have been, on Jan. 3, '06.]
% 14-DEC-2005, P. Emma
%   Small 135-MeV spectrometer component z adjustments from Wing Ng's list.
% 12-DEC-2005, P. Emma
%   Remove QS03 from 135-MeV spectrometer and shorten system, per Cecile.
%   Also change XC06 & YC06 to class-1t (was 1s by mistake) - changed Dec. 14.
% 10-DEC-2005, P. Emma
%   Move XC21302 & YC21303 to realistic locations around Q21301.
% 08-DEC-2005, P. Emma
%   Move WS11,12,13 farther apart and rematch (improves QM12 y-chromaticity
%   by reducing betaY there - slight increase in QM11 x-chrom.)
% 02-DEC-2005, P. Emma
%   Adjust laser-heater spacings and set dX=35 mm at its chicane center.
% 01-DEC-2005, P. Emma
%   Adjust QE01-QE03 for laser-heater shuffling, including hor. chicane
%   offset from 2.5 cm to 4.0 cm done while sliding BXH1 ansd BXH4 outboard
%   by 10 cm more. Also move ZLIN02 from 2045.365312 to 2045.436400 m
%   (Q21201 moved a bit). Move XC21202 & YC21203 onto end of 21-1d.
% 29-NOV-2005, P. Emma
%   Fix X-band RF split so EXCEL file shows one cavity only (i.e., rename from
%   L1X_A and L1X_B to L1X___1 and L1X___2 - such that 1st 6 characters are
%   idetical as required by Woodley's xtffs2symbols.m code). Add type-4, -5
%   to existing linac correctors (also in L2 & L3 subfiles). Give all QUADs
%   types ("FFTB" -> "0.91Q17.7") and all LCAV's have type ("10ft", "9.4ft",
%   and "DUALFEED"). Add type to BYD1,2,3. Remove BPM7 and YAG04.
% 23-NOV-2005, P. Emma
%   Change QM11,12,13,14,15 to ETA-type quads, rather than QE-types. Was
%   changed in PRD months ago, but somehow I failed to change it here. Adjust
%   component locations in the X-band area per Jose Chan's drawings and
%   add VVX1 and VVX2 around X-band structure. Remove BL31,32,33 (EO &
%   unknown diagnostics).
% 14-NOV-2005, P. Emma
%   Give all undulator quads thir own name (QU01...QU33).  Move TDUND to
%   dwnstr. side of RFB08 to have beam on RFB07 & 08 with TDUND stopper IN.
%   Modify 135-MeV spectrometer to get more x-separation with linac
%   (per Cecile).
% 09-NOV-2005, P. Emma
%   Add YCM11 and use x/y corrector packages for type-1 correctors.
%   Make various small adjustments to elements to be consistent
%   with drawings.  Add IMS1 toroid, YAGS2, and FCS1.
% 19-OCT-2005, P. Emma
%   Correct the lengths of L0-a and L0-b based on Jose's new data.
% 18-OCT-2005, P. Emma
%   Use 3.25Q20 quads for QUE1 and QUE2. Remove BLE02,3 (EO bunch length).
%   Also add QG02/QG03 gun-spectrometer R-matrix fitting.
% 15-OCT-2005, P. Emma
%   Setup file so that we always get output files for all of the branch lines:
%   1) 6-MeV spectrometer (GSPEC-...)
%   2) 135-MeV spectrometer (SPEC-...)
%   3) safety dump line (SFTDMP-...)
%   4) LTU-only (LTU-...)
%   5) entire LCLS to main dump (LCLS...)
% 13-OCT-2005, P. Emma
%   Replace QUE1 and QUE2 with SLC FF Q18 magnets, and QDMP with 3.25Q20 magnets
%   from the FFTB dumpline.  All 3 were Q80kG types which are now not needed.  Also
%   add BPMQd in QDMP quad.  Move YCD3 upbeam a few meters and add XCD3.
% 08-OCT-2005, P. Emma
%   Small location variations of some components in the L0a L0b area per
%   J. Langton and Paul Stephens. Add ZLIN00 ref. at L0-a entr. flange face.
%   BX01/02 gap set to 30 mm, from 35 mm.
% 07-OCT-2005, P. Emma
%   Add gun spectrometer (see GTL_ON) and adjusted L0a,b lengths and GTL
%   positions. Removed BPM1, BPM4, and BPMG2 (can't fit them in, and not needed).
% 25-SEP-2005, P. Emma
%   Add idealized and as-built L1-linac files, the latter to split L1-linac
%   structures to add correctors at proper locations.  The former is used
%   for Elegant tracking where spitting the structures is undesireable. Also
%   add VV21 valve in front of BC2 (added Sep. 27, 2005).
% 24-SEP-2005, P. Emma
%   Adjust safety dump section to show locations of tripped off bends (i.e,
%   (BYD1->DYD1, BYD2->DYD2, BYD3->DYD3), fix LBdm to include curvature,
%   remove PCPM2 from main dump line (should be only in safety dump line),
%   and name lower (main dump branch) aperture of PCPM1 as PCMP1L (lower
%   hole of two-hole collimator on main and safety dump).
% 29-AUG-2005, P. Emma
%   Change BX11,12,13,14 gap to 30 mm (was 1.05 inches).  Updated corrector
%   class table (under 13-JUL-2005) and adjusted class of all XC's and YC's.
%   Also update QS01,2,3 K-values from Cecile.
% 19-AUG-2005, P. Emma
%   Add 135-MeV spectrometer beamline (when BX01 is switched off).  Based
%   on Cecile's "Final_Aug05.MAD" file. Search for DL1_ON to turn on or off
%   the spectrometer.  Also add solenoid bucking coil, SOL1BK.
% 01-AUG-2005, P. Emma
%   Shorten BXH1,2,3,4 bends from 0.126 m to 0.110 m.  Set Q21301 to remnant
%   integrated-gradient of 0.12 kG. Replace QB with a "QE" magnet (water
%   cooled) rather than an "ET" magnet, which could get too hot and change
%   alignment. Finally, adjust 21-1b,c,d z-positions so that their upstream
%   ends are not moved w.r.t. existing locations (~9 mm upstr. shift due to all
%   eyelets being 0.353" upstream of the "division lines" (per P. Stephens).
% 23-JUL-2005, P. Emma
%   Add 9-foot long, 0.4-inch ID muon collimator after TDKIK beam-abort
%   dump in LTU based on Stan Mao's PRD 1.9-100, pg. 9 (May 6, 2004).
% 22-JUL-2005, P. Emma
%   Add back final undulator quadrupole after last segment to facilitate
%   alignment of this last segment. Refit dump area to slightly larger
%   betaX,Y and etaY, but still 1E-5 dE/E & sigE/E resolution.
% 16-JUL-2005, P. Emma
%   Replace Q24701 & 901 with double QE magnets and QM21 & QM22 with FFTB
%   style 46-cm magnets to allow 30-50 GeV SLC operations. Replace QE31-36
%   quads with "QE" type (were FFTB type).
% 15-JUL-2005, P. Emma
%   Replace RFBUE1 & 2 with strip-line BPMs of ID>36 mm (BPMUE1 & 2) to stay
%   clear of x-ray beam. QUE1 & 2 also must have ID>36 mm, so magnet-type was
%   changed for these also, along with QDMP.  Also introduce new LTU magnet
%   types (Q150kG: ID=23 mm, Q80kG: ID=36 mm).
%   Replace QA11 & QA12 with ET quads (were QE's).
% 13-JUL-2005, P. Emma
%   Replace XC21202 (original XCOR) near Q21201 and put back XC21302 and
%   YC21303 which were removed when the 21-2/3a RF sections were removed.
%   Move TCAV3 to 25-2d for better sigZ resolution and adjust MUY in L3 to
%   get back to 270-deg between TCAV3 and OTR30 (plus small MUX L3 tweak
%   to get BX24A -> BX31A = n*360 deg - was 25 deg off?).  Also add QEM3V
%   "1.259Q3.5" injector-type vernier quad near QEM3 for slice emit-meas
%   in the LTU on OTR33.  Also change LCLS corrector types to:
%    class-G: |BL| < 0.0010 kG-m (RF gun area corrector)
%    class-1: |BL| < 0.0060 kG-m (injector corrector)
%    class-4: |BL| < 0.0600 kG-m (nominal linac corrector)
%    class-5: |BL| < 0.1200 kG-m (strong linac corrector)
% 09-JUL-2005, P. Emma
%   Change XCA11,12, YCA11,12 to type-0 (was type-1 due to wrap-around),
%   change YC5,XC6,XCA0 to type-2 (was no type before - don't know why),
%   change XCE31,YCE32,XCE33,YCE34,XCE35,YCE36 to type-1 (was type-2 because
%   type-2 was cut at 0.02 kG-m - 0.025 kG-m cut is better).
% 06-JUL-2005, P. Emma
%   Rename TCAV1 to TCAV0 (in injector) and TCAVH to TCAV3 (in L3). Replace
%   old 0.4-m BYW1,2,3,4 with SLC 3-bend wiggler with two 0.233681-m long
%   magnets and one 0.467362-m long magnet, each seperated by 0.17373 m.
%   Also convert BXKIK and BYKIK to SBEN (from DRIFT) using ANGLE=1E-12
%   so these show up in the EXCEL symbols files as turned off bends.
%   Also remove PCDMP1, which was actually the same as PCPM1 and separate
%   PCPM1 and PCPM2 as far as possible in safety dump. Then set BXPM1,2,3
%   to reduced field with 5.2-cm gaps (rather than 3.81 cm gaps).
% 29-JUN-2005, P. Emma
%   Replace QA11 and QA12 L1-linac quadrupoles with QE-type magnets rather
%   than QA-types.  There are no more QA-types in the LCLS design.
% 27-JUN-2005, P. Emma
%   Update undulator drifts lengths to 0.470 and 0.898 m (short,short,long).
%   Forces "UNDSTOP" to be redefined as "UNDTERM" at slightly new z-location.
% 18-JUN-2005, P. Emma
%   Move L0-a downstream about 8 cm, lengthen L0-a and L0-b due to dual feed
%   modifications, add Cecile's dual-feed "DLFDa" and "DLFDb" marker points,
%   and move components around between L0-a and L0-b.
% 02-JUN-2005, P. Emma
%   Add comment to each fast-feedback corrector and identify loop number.
%   Add spoiler to beam abort system (SBD).
% 31-MAY-2005, P. Emma
%   Adjust QE04 through QM01 section z-locations by a few mm to back out
%   06-MAY-2005 changes and to accomodate new BPM lengths (per Leif and Wing Ng).
% 25-MAY-2005, P. Emma
%   Move entire FEL undulator upstream by 2 m, remove odd break lengths in
%   first 3 breaks, shorten section between end of undulator and start of
%   dump by 5 m, and shorten section between beginning of dump line and
%   dump's vertical bend magnets by 2 m. Also move saftey-dump disaster
%   monitor ("SFTDMP") upstream by 1.5 m to allow room for X-ray PPS stoppers.
%   (Note the reference points named: "UNDBEG","UNDEND", "DMPBEG", and "DUMP"
%   are all removed now, and replaced by "UNDSTART", "UNDSTOP", "DLSTART", and
%   "EOL", with different Z-locations.) Remove 1st QF quad from start of undulator,
%   which requires rematching, forcing the CX37 and CY38 collimators to move.
%   Also, moved the RFB07 to get 3 BPMs in a row over the 7-m drift from the
%   last undulator matching quad to the first undulator segment. Finally, add
%   BXKIK horizontal kicker magnet just downbeam of sec-25 TCAV for off-axis
%   bunch length meas on 25-9 screen.
% 06-MAY-2005, P. Emma
%   Adjust QE04 through QM01 section z-locations by a few mm due to unfortunate
%   adjustments by designers when they changed the length of RST1.
% 04-MAY-2005, P. Emma
%   Reverse the Nov. 05, beta swap by  (approximately) reversing the signs
%   of the 6 quads: QA01-2, and QE01-4, in order to get betaX back to 30 m
%   from 12 m at the L0-b input coupler.  This so we can measure slice
%   x-emittance at WS02 wth QE03.
% 05-APR-2005, P. Emma
%   Change safety dump layout to Saleski's Nov. 10, 2004 layout, including
%   BYPM1-3 becoming BXPM1-3 for horizontal safety bends. PCDMP1 moved ~1 m
%   to be consistent with new PCPM1 location (same collimator body).
% 23-MAR-2005, P. Emma
%   Make TCAV1 and TCAVH into LCAV types, rather than DRIFTs, so that the
%   xtffs2symbols.m program recognizes them and places them in the EXCEL file.
% 21-MAR-2005, P. Emma
%   Move elements around in the QE04-QM01 area by a few cm based on the CAD
%   layout by Wing Ng and Leif Eriksson. Re-fit WS01-03 beta/alpha.
% 01-MAR-2005, P. Emma
%   Set bore radius of Xgamma injector quads to 16 mm (was 13.75 mm), per
%   Schmerge EXCEL list, and also R. Carr vendor bid document.
% 17-FEB-2005, P. Emma
%   Rematch injector to Cecile's new 1-nC Parmela run (not much different)
%   called 'LCLS_end_L0a_nominal.dat'. Remove L0SHIFT and move move L0WAKE
%   to just after L0a and rename it L0aWAKE, since we start tracking at end
%   of L0a now, rather than L0b.
% 03-FEB-2005, P. Emma
%   Use new SPPS-chicane-like tweaker quads ("2.1Q5.87") in BC1 and BC2
%   and adjust the locations of CQ11,12 quads to dZ=0.40005 m from BX11-center
%   to CQ11-center (and from BX14-center to CQ12-center, backwards), for
%   Joe Stieber's BC1 interference problems.  BC2 not engineered yet, but
%   CQ21 and CQ22 now moved to 2-m from outer bends (was asymmetric -
%   see 13-NOV-2001). Move BPM3 upstr. 2 cm (per Cecile). Move S2 upstr.
%   5 mm (per Cecile). Add VV02 and rename old-VV02 and old-VV03 to VV03
%   and VV04 (per Cecile).
% 18-JAN-2005, P. Emma
%   The steering correctors I would like to have well calibrated
%   (in kG-m of integrated dipole field) prior to installation at
%   the level of <1% accuracy, if possible. (sent to Rago in Fall 2004)
%   DL1-Area:   XC05 & YC05
%   BC1-Area:   XCA12 & YCA11
%   BC2-Area:   XC24702 & YC24703
%   LTU-Area:   XCVM2 & YCVM1
% 01-DEC-2004, P. Emma
%    Move BC1-area devices per Bill Brooks list:
%     1) YCM12  relocated downstream to 21.233 m (was  21.055 m)
%     2) XCM13  relocated downstream to 21.904 m (was  21.726 m)
%     3) IMBC1O relocated upstream   to 22.500 m (was  26.576 m)
%     4) OTR12  relocated upstream   to 23.900 m (was  24.195 m)
%     5) XCM14  relocated upstream   to 26.988 m (was  27.242 m)
%     6) YCM15  relocated downstream to 28.000 m (was  27.599 m)
% 22-NOV-2004, P. Emma
%    Move gun/injector devices in z to be consistent with Cecile's list. This
%    moves most devices from the gun solenoid, S1, to BPM5 in quad QA02. Also
%    update "LQx" quad length from 10.7 cm to 10.8 cm, per J. Schmerge.
% 17-NOV-2004, P. Emma
%    Move entire injector beamline 12.100 mm downstream in a parallel direction
%    to the main linac axis.  This because the Q20901 quad (not in this file
%    but used as a tunnel reference) was found to have a MAD-file z-location
%    12.100 mm too far upstream and the injector was already laid out, so we will
%    preserve the 3.428107-m distance between Q20901-center and the point of
%    intersection of the LCLS injector (with BX01 off) with the SLAC linac, by
%    moving the injector beamline 12.100 mm downstream (see ZOFFINJ).
% 04-NOV-2004, P. Emma
%    Set cathode distances to L0-a and L0-b structure centers and the QA01 and
%    QA02 quadrupole centers so that they agree with Cecile's Parmela files.
%      Cathode to L0-a CENTER = 2.925052 m
%      Cathode to QA01 CENTER = 4.652654 m
%      Cathode to QA02 CENTER = 4.957554 m
%      Cathode to L0-b CENTER = 6.866150 m (Cecile's file changed to this L0-b value)
%    Also (approximately) reverse signs of the 6 quads: QA01-2, and QE01-4, in order
%    to get betaX from 30 m down to 12 m at the L0-b input coupler so the RF kick
%    there produces ~6% x-emiitance growth rather than ~15% (according to Cecile).
%    Add L0a 3-m RF section to injector, rather than the 3-m drift that was used.
%    Set laser-heater chicane bends to 12.6 cm (added 2.6 cm) using "dLbh" parameter.
%    Finally, add mid-points to the L0-a and L0-b RF sections to more easily see
%    their (x,y,z) coordinates.
% 21-OCT-2004, P. Emma
%    Set laser-heater chicane dispersion to 2.5 cm (was 2.0 cm) for Roger Carr
%    and Lynn Bentson (QE01-QE04 quads get somewhat weaker). Also update FEL
%    undulator quad effective lengths to 7.4 cm (was 5 cm) and set gradients
%    to 40.54 T/m (was 60 T/m) to keep the 3.0 T integrated gradients.
% 08-OCT-2004, P. Emma
%    Move CQ11 and CQ12 BC1 quads to exact location as in Joe Stieber's drawings
%    (519E-6 m shifts).  Move OTR11, CE11, and BPMS11 (in BC1) to same as Joe's
%    drawings (~few cm shifts) and use same diagnostics package in BC2, but with
%    a short drift preceeding it, which might be changed later.  Also shortened
%    PCMUON from 5 to 3 feet, according to Lew Keller's new design and added
%    Lew's powered magnetic muon spoiler in the saftey-dump line. Add "TILT" to
%    QSM1 (got lost?), since it is a skew-quad (but nominally off). Fixed
%    'LCLS_L3.xsif file', which had typo using K25_2b,c,d where K25_1b,c,d actually
%    are (no actual effect though, since these are identical sections).
% 24-SEP-2004, P. Emma
%    Set final energy to 13.64 GeV for new undulator parameter of K=3.500 and 6.8-mm
%    gap. This puts BC2 energy at 4.300 GeV (from 4.540 GeV), which adds one spare
%    klystron to the L2-linac. L2-phase now -41.4 deg (rather than -40.8 deg) and
%    L3-linac phase now at crest (0 deg rather than -13.6 deg). Also specify half-gap
%    widths for all LTU collimators (lengths already specified). Finally, remove
%    soft-bend in dumpline (replaced with slightly less drift length such that
%    "DUMP" face coordinates remains unchanged - Y & Z).
% 21-SEP-2004, P. Emma
%    Move CQ11 and CQ12 closer together by ~15 cm each (i.e., each ~15-cm farther
%    from their adjacent dipole.  Now each is exactly 30 cm in Z from adjacent dipole.
%    Also calculate BMIN1 based on drift, rather than the reverse.
% 16-SEP-2004, P. Emma
%    Move Q21201 downstream by 0.035512 m for better fit of X-band structure.
%    Move X-band structure upstream by 0.016491 m for Bill Brooks. Move IMBC1I
%    toroid from BX11 face to just 8 cm downstream of Q21201. Move YC21203 and
%    XCM11 to between Q21201 and QM11 as 4-coil combined x/y corrector. Verified
%    all 22 "ZLIN..." markers, from ZLIN01 to "DUMP" - all OK. Remove PRWIG,
%    since it is now called PRXRAY and placed in the Y-wiggler.
% 17-AUG-2004, P. Emma
%    Comment out Z0=-14.101382 survey line because I don't remember what it's for.
%    Turn on realistic L2 and L3 linac XSIF-files, rather than idealized files.
% 13-AUG-2004, P. Emma
%    Move QM11 downstream by 0.1828 m to make a bit more room for the 60-cm
%    X-band structure.
% 22-JUN-2004, P. Emma
%    Change BC1 length for longer central drift to accomodate diagnostics.
%    Joe Steiber says: move BX12 moved -0.165100 m (-6.5") and BX13 moved
%    +0.165100 m (+6.5").  This gives us 0.508584 m (20.023") to work with.
%    This requires a new BC1 bend angle.
% 05-MAY-2004, P. Emma
%    Change QM11, QM12, and QM13 to QE-type quads, rather than 1Q5.6-types and
%    increase surrounding drifts accordingly (0.0481 m quad length difference).
%    This should have been done a few months ago, but somehow got missed. Now
%    there are no more 1Q5.6 quads anywhere in the LCLS. Re-order BC1 and BC2
%    diagnostics BPM, coll, OTR and spread to get 10-cm space between each.
% 04-MAY-2004, P. Emma
%    Add 7 "fixed points" in the LTU/undulator/dump-line area to document precise
%    locations for future beamline comparisons.  These fixed points (as those termed
%    "ZLIN..." in the linac) are to be maintained in X,Y,Z,THETA,PHI, and PSI,
%    unless an intentional change is made and clearly documented in the comments
%    above (and below - see "ZLIN..." section).  ZLIN08a removed since it was no
%    longer in the beamline anywhere.
% 19-APR-2004, P. Emma
%    Adjust matching upbeam and downbeam of BC2 to get slightly better phase advances
%    across WS21-24 wires. Also reversed K1 signs of QM22 and Q24901 quads to get ~30%
%    weaker strengths (were the tightest alignment tol quads in the area).  Finally,
%    slide OTR30 downstream by 4 cm to center it between XCDL3-exit and QDL33-entrance.
%    (Also put MDL2M fitting above ML3DL2 - was above MDL2T).
% 16-APR-2004, P. Emma
%    Re-model FEL undulator with R-matrix to include natural y-focusing and
%    set <beta>=30 m using 60 T/m QF and QD gradients (H.-D. Nuhn). Also add
%    1st three undulator special break lengths, then re-match and save.
%    Change nominal FEL e- energy to 14.077 GeV with K = 3.630 (H.-D. Nuhn).
% 13-APR-2004, P. Emma
%    Undulator "center" is now at 583 m from S100 rather than 532 m.  This also
%    changes "YF" from 0.009755 m to 0.009738 m to get S100 at Y=0 and changes the
%    BY1/BY2 bend angles slightly.  This change should have been made on 08MAR04
%    but was missed.  Also change LTU coordinates print and survey output file names
%    from FFTBLCLS... to LTU-LCLS..., as preferred by T. Montagne.  Also move MVBEND
%    fitting subroutine to just before ML3DL2, rather than just before MUNDP.  Also
%    add S100_HEIGHT to Earth's radius to refine vertical bend determination (added
%    late: April 16, 2004).
% 24-MAR-2004, P. Emma
%    Add one undulator RFBPM just after last undulator segment (not linac
%    responsibility) and set undulator RFBPMs at proper positions rather than
%    in centers of quads.  Move IMUNDO downstream of undulator-exit by ~15 m
%    (was < 1 m) and move dump-system upstream by ~8 m so that VV36 is 404 m
%    downstream of the RSY-wall. Change PCMUON from 4-ft length to 5-ft length.
%    Change BC1-screen to OTR and rename it from PR11 to OTR11.  Make all 11
%    injector quads (E>60 MeV) into "XGamma" type (10.7 cm long).  Add L0b
%    3-m RF section for 64->135 MeV acc. (still ignore L0a), and move TWSS0
%    beam location to L0a-exit (Parmela TWISS output at L0a-exit now).
% 08-MAR-2004, P. Emma
%    Lengthen LTU emittance diagnostic section by ~34 m to get undulator to start
%    at 517 m from S100.  Also add ~40-m undulator exit section with minimal,
%    low-cost elements, to possibly be used as a future undulator extension.
%    Note, S100 to outer face of research-yard (RSY) wall is 935 ft exactly,
%    or 284.988000 m (updated Sep. 29, 2004 -PE).  Also add slice-Y-emit meas
%    OTR33 (renamed old slice-E-spread OTR33 to OTR30).
% 02-MAR-2004, P. Emma
%    Move dump upbeam about 6 m and move final safety permanent magnets
%    downbeam about 20 m and add 2 PC's upbeam of BYPM dipoles.
% 26-FEB-2004, P. Emma, J. Schmerge
%    Rename some injector elements from gun to 21-1b section.
% 23-FEB-2004, P. Emma
%    Shift injector elements around according to Lynn Bentson's changes. These
%    changes are restricted to the area from gun to entrance of L1-linac.
% 22-JAN-2004, P. Emma
%    Redefine staion-100 (S100) as Y=0 as suggested by Catherine LeCocq.
%    Also dump LTU file starting near 50Q1, rather than at 50B1.  Note
%    S100 is 77.643680 m above its local sea level.
% 13-JAN-2004, P. Emma
%    Adjust alignment coordinates of LTU area to Catherine LeCocq's conventions.
%    This sets the station-100 (S100) height at Y=77.643680 m, the pitch at
%    -4.760 mrad (unchanged) and the Earth's mean radius at R=6372.508025 km.
%    These changes slightly adjust the height of the undulator and the angles
%    of the vertical bends (BY1 and BY2).  Also we changed LTU to allow space to
%    keep the existing VAT valve at the start of FFTB/LTU (see below).
%    Added 30 cm between WALL and YCVM1, subtracted 6 cm from the drift between
%    YCVM1 and QVM1, or:
%    Device    Old Coordinate/m  New Coordinate/m
%    YCVM1     176.11            176.41
%    QVM1      176.74            176.98
%    QVM2      177.70            177.94
%    XCVM2     178.18            178.42
%    BV1       178.63            178.87
%    These moves allow us to keep an existing VAT valve at the start of FFTB/LTU.
% 05-JAN-2004, P. Emma
%    Move single beam dumper (BYKIK and TDKIK) from last bend module (DX37-38)
%    into 2nd bend module (DX33-34) so that dump will be inside BSY enclosure
%    where shielding requirements are much easier.  This limits the spontaneuos
%    undulator to <5 m in length (was limited to <12 m).
% 15-DEC-2003, P. Emma
%    Add laser-heater undulator model to include focusing effects - rematch.
% 06-DEC-2003, P. Emma
%    Move correctors, etc. to realistic location in LTU according to Davies
%    list.
% 01-DEC-2003, P. Emma
%    Use effective path length for BX31,32,35,36 bends rather than effective
%    core length (adds 8.3 microns to bend length).  Change optical fitting
%    in DL2 to ignore vertical E-wiggler-chicane (EWIG).  Lengthen heater
%    undulator by 0.025 m for a 10.5 period length (=0.525 m), and re-match.
% 19-NOV-2003, P. Emma
%    Change e- dump for Stan Mao.  Reduce length of powered Y-bends from
%    1.5 m to 1.4 m, use 5-deg total powered-bends with 3 bends rather than
%    4, use 3 perm-magnet bends rather than 2, and re-fit optics.
% 14-NOV-2003, P. Emma
%    SLide BX01/BX02 bends farther apart by 24" total, move QM01,2,3,4 to
%    accomodate this, and fit BETX<1.7 m, BETY<8 m at OTR4 which is now
%    just upbeam of QB.  All this for Lynn Bentson.
% 13-NOV-2003, P. Emma
%    Add Laser-Heater System (LHS), including chicane, between QE02 and QE03.
%    L0-b slides upbeam by 12 cm, QE03-04 slide downbeam ~1.5 m, TCAV fits
%    after LHS, WS01-WS03 separation goes from 4.33 m to 3.9 m (see LWS01_03),
%    QE01-04 quads become 10-cm new-GTF types, OTR3 gone, WS02 does not move.
% 10-NOV-2003, P. Emma
%    Add 8 RF-BPMs ("RFB...") just upstream of 30-m undulator extension. Add
%    5 new toroids ("IM...") just before BX31, just after BX36 (comparator),
%    at TDUND, just after FEL-undulator, and in dump line. Add X-ray stripe
%    vertical chicane and screens for E-spread meas. in LTU. Add EO, OTR, and CTR
%    bunch length monitors just after BX36. Point to possible future spontaneous
%    undulator location in LTU (no real device in baseline for now). Also
%    set LTU coordinates from station-100 (S100) and set vertical bends to get
%    level system at center of FEL-undulator, including 30-m extension (11-Nov-03).
% 04-NOV-2003, P. Emma
%    Update corrector placements in LTU based on simulated steering.
%    Add YCA0 to BSY (near QA0 upstream of WALL), if easy to add.
% 28-OCT-2003, P. Emma
%    Replace old FFTB-DL2 design with much longer LTU (Linac-To-Undulator)
%    beamline, with multiple undulator branch point options.  Also add
%    129-m undulator model with 30-m pre-extension and e- dump line.
%    Change nominal energy at 1.5 Angtsroms to 14.100 GeV with
%    <beta>=25 m in undulator.
% 16-OCT-2003, P. Emma
%    Add a few BPMs in the DL1 area for better steering and move a few
%    DL1 XCORs and YCORs approximately to where Lynn's drawing show them.
%    Also remove CE01 from near QB in DL1.
% 06-OCT-2003, P. Emma, C. Limborg
%    Replace QA01 and QA02 15-cm long L0-quads with two 6-cm long GTF-type
%    quads. Setup matching using initial beta functions at L0a-exit from Cecile.
%    Add to naming convention above: "CX" as x collimator and "CY" as y
%    collimator.
% 16-JUL-2003, P. Emma
%    Improve location of X and Y correctors and BPMs in the DL1, and BC1
%    areas, based on simulated steering.  Only done from QE01 to undulator,
%    not including L0-linac area, and no moves made in BC2 or DL2 areas,
%    but 2 XCOR's and 2 YCOR's removed from centers of BC1 and BC2
%    chicanes, because Elegant steering shows they were not needed, and
%    BPMWIG was added just dnstr of SC-wiggler which has small aperture.
%    NOTE: Do not use XC460034, XC460036, or XC921010, AND YC460035,
%    YC460037, or YC921010 for steering: Get BAD results in Elegant.
% 15-JUL-2003, P. Emma
%    Add QA01 & QA02 quads to injector at 64 MeV point according to Cecile's
%    new 135-MeV injector design.
% 09-JUL-2003, P. Emma
%    Readjust parameters for 135 MeV injector output.  New RF phases, reduced
%    X-band voltage (22->19 MV), X-band phase now at -160 deg, new BC1 & BC2
%    strengths, loosened jitter tolerances, especially for X-band RF phase
%    (was 0.3 deg, now 0.5 deg).  No elements were moved, except 2 quads added
%    in injector at 64 MeV point.  Only operational were parameters changed.
% 10-JUN-2003, P. Emma
%    Move OTR6 close to WS03 (was 1-m dnstr.), rename B1WA... to BW1A...,
%    remove OTR adjacent to OTR4 (was almost identical), add WS04 back near OTR4,
%    SC-wig gap increased by 2 (to 1-in), add PRTD11, PRTD21, PRTD31 screens on
%    TD11, TD21, and TD31, add dump of expected fit-OFF penalty functions, plus
%    clean up and update of fits results.
% 01-MAY-2003, P. Emma
%    Lengthen BC2 bends from 0.4 m to 0.5 m, increase center BC2 drift from 0.5 m
%    to 1 m, and take up this length by reducing the two drifts after B24B. Bend
%    magnet name changes from 1D15.7 to 1D19.7.  Also add MTWSSC fit call in
%    string of fit routines.
% 17-MAR-2003, M. Woodley
%    Shorten DM23B drift length to compensate for fix of 14-AUG-2002; rematch
%    L3 optics; add "instrumentation section" (~31 m long ) comprised of
%    undulator FODO cells immediately upstream of undulator
% 14-AUG-2002, P. Emma
%    Fixed bug where BC2 drifts were LDo?/cos(0), rather than ../cos(AB21);
%    also update settings around BC2 after new fit
% 10-APR-2002, M. Woodley
%    Correct location of 901 quads in LI25-28 (); change BC2 bends from 1D30.5
%    to 1D15.7; change K21X name to K21_X; remove WS04 (use OTR8); remove WS11
%    (use PR11 OTR); add PR12 OTR in BC1/ED1; remove WS25 (use PR21 OTR);
%    replace WS31 with PR32 OTR; add PR33 OTR in DL2/ED2; add TYPE information
%    for PROFs (PHOSPHOR or OTR) and MONIs (resolution); create seperate
%    (external) input files for L2 and L3 ... one set contains "idealized"
%    layouts with non-split accelerator sections and correctors located at
%    structure entrances, while a second set contains the as-built layouts with
%    split structures, wraparound correctors, etc.
% 14-FEB-2002, M. Woodley
%    Add diagnostics in L0/DL1 area per D. Dowell spreadsheet; run optics such
%    that "sumL" is accumulated distance from cathode
% 15-JAN-2002, M. Woodley
%    For parts list generation: change wire scanners to WIREs; change profile
%    monitors to PROFs; change bunch length monitors to BLMOs; change charge
%    monitors to IMONs; change collimators to RCOLs; change dumps to INSTs;
%    added TYPE="SC_WIGG" to wiggler SBEN definitions; split DW2 in half and
%    added WIGbeg, WIGmid, WIGend MARKers
% 29-NOV-2001, P. Emma
%    New input beam from Cecile with 120 MV/m at gun, 18 MV/m in L0a, and
%    30.5 MV/m in L0b.  Now converging beam at L0-exit.  Beta's in DL1 and
%    BC1 now more like 07-NOV-01, but L1 FODO sign-flipped w.r.t. 07-NOV.
%    Still need better L1-entrance and L2-entrance matching conversion.
% 26-NOV-2001, P. Emma
%    Tweak matching through DL1 and BC1 to reduce CSR?
% 15-NOV-2001, M. Woodley
%    New DL1/injector design: 35 degee off-axis injection, load-lock/gun/L0
%    moved upstream, more space between L0 sections, larger betas at WS02,
%    fewer quads to match through DL1 bend, reverse polarity of L1 quads; add
%    55 cm transverse deflecting structure; rematch to Emma's latest BC1
%    optics
% 13-NOV-2001, P. Emma
%    Move BC2 CQ21 and CQ22 to better locations within BC2 (mostly CQ21 goes
%    4 m past B21 to get bigger etaX/betaX ratio) ... rematch BC2 area
% 07-NOV-2001, P. Emma
%    Move BC2 superconducting wiggler upstream by one quad to get betaX smaller
%    in wiggler (reduces ISR emittance growth, plus allows better BC2 CSR
%    match); make all drifts, which are downstream of and close to bends, of
%    TYPE="CSR"; set MUX from B24 to B31 = 0 for better BC2-DL2 CSR emittance
%    cancellation
% 23-OCT-2001, P. Emma
%    Add a pre-BC2 one-period superconducting wiggler to kill the CSR micro-
%    bunching
% 13-AUG-2001, P. Emma
%    Replace double-chicanes with single, long chicanes to beat high-frequency
%    CSR
% 02-JAN-2001, P. Emma
%    Tweak R56 of BC2-2 from 3.60 mm to 3.55 mm to get 22 um rms final bunch
%    length, rather than 21 um; clean up this file
% 06-DEC-2000, P. Emma
%    Re-match end-of-L0 quads to Patrick's 100000-particle Parmela beta
%    functions ... had to increase drifts between QE01-2,3,4 and reduce BMIN0
%    from 1 m to 0.733855 m (WS02 sig=50 microns now) which moves WS01-2-3
%    closer together accordingly - plus slightly shorter LMED so that length to
%    DL1END is unchanged ... this now allows matching either JR beam or PKR
%    beam
% 25-OCT-2000, P. Emma
%    Tweak basic compression parameters to get more spare klystrons (L1phase
%    from -38.479 deg to -37.824 deg, L2phase from -42.963 to -42.528 deg,
%    R56(BC1) from (24.012+11.500) mm to (24.807+11.900) mm, R56(BC2) from
%    (18.40+3.50) mm to (18.923+3.600) mm ... TRACKED in Elegant: gives 16% CSR
%    emittance growth total
% 22-OCT-2000, M. Woodley
%    Change sign of BC1 and BC2 chicanes (bend away from the aisle); adjust
%    horizontal phase advance of L3 to get 3*360 degrees between last bend
%    of BC2 and center of QL32 in DL2; define CSR drifts for translation to
%    ELEGANT; change "INJ45" back to "DL1"
% 21-OCT-2000, P. Emma
%    Change BC2 beta's to reduce CSR emittance growth (betax=7 m, alphax=-1.1
%    at B28B-exit) and adjust both BC2 chicanes for same total R56, but
%    R56(1)=18.4 mm, R56(2)=3.5 mm (~ 20-OCT values)
% 13-OCT-2000, P. Emma
%    Change BC1 beta's to reduce CSR emittance growth (betax=1.2 m at B18B-exit)
%    and adjust both BC1 chicanes for same total R56, but R56(1)=24.012 mm,
%    R56(2)=11.500 mm; add a few MARKers, like XBEG and XEND
% 10-OCT-2000, M. Woodley
%    Move DL1 line to 3 feet from injector tunnel wall; tweak length and
%    location of X-band section; change BC1 to double chicane system; adjust
%    horizontal phase advance of L2 to get 7*180 degrees between last bend
%    of BC1 and last bend of BC2; add vertical bend system between DL2 dogleg
%    and ED2 emittance diagnostic section to bring beamline level; R56=0
%    optics for DL2 dogleg
% 31-AUG-2000, P. Emma
%    New compression parameters based on optimizer (e.g. sigZ(BC1)=200 um)
% 03-AUG-2000, P. Emma
%    Match injector for Jamie Rosenzweig input beta functions (i.e.
%    "thermal1_jr.sdds"); add X-band to BC1 entrance; re-tune BC1 & BC2 R56 to
%    accomodate different initial beam
% 24-JUL-2000, M. Woodley
%    Verify that all fitting results have been propagated into element
%    definitions; define dummy quads for matching L1/L2/L3 phase advance per
%    cell (coasting)
% 20-JUL-2000, P. Emma
%    Add TCAVPROF screen near H25901; reset R56(BC2-1)=26.0 mm (BB21=10.9.. kG)
% 19-JUL-2000, M. Woodley
%    Remove 25-5a section ... increase gradient on 25-5b; add 8' transverse
%    deflecting cavity at 25-5a for bunch length measurement; adjust phase
%    advance per cell of L3 linac from 30 to 33.4 degrees/cell to get 270
%    degrees of vertical phase advance between the transverse deflecting cavity
%    at 25-5a and PR31 in DL2
% 05-JUL-2000, P. Emma
%    Added 1st-guess zero-length correctors to make ELEGANT steering work;
%    reduce BC2-to-L3 quad strengths to reduce chromatic dilution and rematch;
%    fix effective length of DL1 bends
% 27-APR-2000, M. Woodley
%    From L0 exit to undulator entrance; 45 degree off-axis injection; location
%    of injection line wrt off-axis tunnel per P. Stephens
% ==============================================================================
% initial conditions (exit of L0)
INJDEG = -35.0    ;%injector bend angle w.r.t. linac [degrees]
E00    = 0.006    ;%beam energy after gun (GeV)
E0I    = 0.064    ;%beam energy between L0a and L0b sections (GeV)
EI     = 0.135    ;%initial beam energy (GeV) (150->135 MeV on July 9, 2003)
EBC1   = 0.250    ;%BC1 energy (GeV)
EBC2   = 4.300    ;%BC2 energy (GeV)
EF     = 13.640   ;%final beam energy (GeV)
EMITXN = 1.00E-06 ;%normalized horizontal emittance (m)
EMITYN = 1.00E-06 ;%normalized vertical emittance (m)
BLENG  = 0.83E-03 ;%bunch length (m)
ESPRD  = 2.00E-05 ;%slice rms energy spread at 135 MeV (1)
ZOFFINJ= 0.012100 ;%moves entire injector in main-linac z-direction by this amount (+12.100 mm Nov. 17, 2004)
% twiss parameters at L0a-exit:
% (Update these with output at L0a-exit - NOT L0b-exit anymore - March 29, 2004 - PE)
% TBETX := 17.239  twiss beta x (m)   OLD - from Cecile's 19 MV/m L0a and 24 MV/m L0b (Oct. 6, 2003)
% TALFX := -3.295  twiss alpha x
% TBETY := 17.169  twiss beta y (m)
% TALFY := -3.278  twiss alpha y
TBETX =  1.410  ;%twiss beta x (m)   back-tracked from measured/matched OTR2 through post Aug. 11, 2008 QA01-QE04 real BDES settings
TALFX = -2.613  ;%twiss alpha x
TBETY =  6.706  ;%twiss beta y (m)
TALFY =  0.506  ;%twiss alpha y
% Twiss at start of ED2 diagnostic section
BX1  =  46.225914269746   ;%twiss beta x (m)
AX1  =  -1.084608324864   ;%twiss alpha x
BY1  =  46.225914304669   ;%twiss beta y (m)
AY1  =   1.084608327766   ;%twiss alpha y
% Dummy, fitted twiss parameters at cathode which yield the above twiss parameters at
% L0a-exit (for plotting purposes only - assumes only drift between cathode and L0a-exit)
%  CBETX :=  3.844367602819   consistemt with TWSS0 from Cecile's 19 MV/m L0a and 24 MV/m L0b (Oct. 6, 2003)
%  CALFX :=  3.546536553224
%  CBETY :=  3.824602098386
%  CALFY :=  3.530071369667
CBETX =  15.574222013212  ;% consistent with back-tracked from matched OTR2 through post Aug. 11, 2008 QA01-QE04 real BDES
CALFX =  -3.081460532254;
CBETY =  0.390930039559;
CALFY =  0.551432669489E-2;
% match into LCLS undulator
UBETX  = 34.233825931612  ;% twiss beta x (m)
UALFX  =  1.136104327233  ;% twiss alpha x
UBETY  = 23.966898717584  ;% twiss beta y (m)
UALFY  = -0.797118403589  ;% twiss alpha y
% match in LTU (fitted)
MBETX  = 48.916343743109  ;%at MM1 twiss beta x (m)
MALFX  =  3.142045480135  ;%at MM1 twiss alpha x
MBETY  = 96.854994510320  ;%at MM1 twiss beta y (m)
MALFY  =  3.631316672149  ;%at MM1 twiss alpha y
% Parameters below are used to set LTU Y-bends so that beam is level w.r.t. gravity at center of FEL-undulator, including 30-m extension
S100_PITCH  = -4.760000E-3                           ;% pitch-down angle of linac at station-100 [rad] (0.27272791 deg)
S100_HEIGHT = 77.643680                              ;% station-100 height above local sea level, from Catherine LeCocq, Jan. 22, 2004 [m]
Z_S100_UNDH = 583.000000                             ;% undulator center is defined as 583 m from sta-100 meas. along und. Z-axis (~1/2 und+xtns)
R_EARTH     = 6.372508025E6                          ;% total radius of Earth (gaussain sphere) from Catherine LeCocq, Jan. 2004 [m]

% set up TWSS0, TWSSC, and TWSSU
TWSSC=struct('ENERGY',E00,'BETX',CBETX,'ALFX',CALFX,'BETY',CBETY,'ALFY',CALFY);
TWSS0=struct('ENERGY',E0I,'BETX',TBETX,'ALFX',TALFX,'BETY',TBETY,'ALFY',TALFY);
TWSSM=struct('ENERGY',EF,'BETX',MBETX,'ALFX',MALFX,'BETY',MBETY,'ALFY',MALFY);
TWSSU=struct('ENERGY',EF,'BETX',UBETX,'ALFX',UALFX,'BETY',UBETY,'ALFY',UALFY);
% construct input beam matrix
EMITX = EMITXN/(TWSS0.ENERGY/EMASS);
EMITY = EMITYN/(TWSS0.ENERGY/EMASS);
TGAMX = (1+TWSS0.ALFX*TWSS0.ALFX)/TWSS0.BETX;
TGAMY = (1+TWSS0.ALFY*TWSS0.ALFY)/TWSS0.BETY;
SIG11 = EMITX*TWSS0.BETX;
SIG21 = -EMITX*TWSS0.ALFX;
SIG22 = EMITX*TGAMX;
SIG33 = EMITY*TWSS0.BETY;
SIG43 = -EMITY*TWSS0.ALFY;
SIG44 = EMITY*TGAMY;
C21   = SIG21/sqrt(SIG11*SIG22);
C43   = SIG43/sqrt(SIG33*SIG44);

CGAMX  = (1+TWSSC.ALFX*TWSSC.ALFX)/TWSSC.BETX;
CGAMY  = (1+TWSSC.ALFY*TWSSC.ALFY)/TWSSC.BETY;
SIG11C = EMITX*TWSSC.BETX;
SIG21C = -EMITX*TWSSC.ALFX;
SIG22C = EMITX*CGAMX;
SIG33C = EMITY*TWSSC.BETY;
SIG43C = -EMITY*TWSSC.ALFY;
SIG44C = EMITY*CGAMY;
C21C   = SIG21C/sqrt(SIG11C*SIG22C);
C43C   = SIG43C/sqrt(SIG33C*SIG44C);


% conversion factors
CB=1.0E10/CLIGHT;%energy to magnetic rigidity
GEV2MEV=1000.0;%GeV to MeV
IN2M=0.0254;%inches to meters
MC2=510.99906E-6;%e- rest mass [GeV]
% Database MARKer points
DBMARK80={'mo' 'DBMARK80' 0 []}';%(LCLS GUN) RF gun cathode
DBMARK81={'mo' 'DBMARK81' 0 []}';%(BXG_entr) entrance of BXG
DBMARK97={'mo' 'DBMARK97' 0 []}';%(GUNSPECT) 6 MeV gun spectrometer dump
DBMARK82={'mo' 'DBMARK82' 0 []}';%(BX01entr) entrance of BX01
DBMARK98={'mo' 'DBMARK98' 0 []}';%(135SPECT) 135-MeV spect. dump
DBMARK83={'mo' 'DBMARK83' 0 []}';%(BX02exit) exit of BX02 ... LCLS injection point
DBMARK28={'mo' 'DBMARK28' 0 []}';%(QM15exit) exit of QM15 ... just after TD11
DBMARK29={'mo' 'DBMARK29' 0 []}';%(LI30 FV2) LI30 fast valve 2 ... start of BSY
DBMARK14={'mo' 'DBMARK14' 0 []}';%(50B1BEND) entrance of 50B1
DBMARK99={'mo' 'DBMARK99' 0 []}';%(52-SL2  ) 52 SL2
DBMARK34={'mo' 'DBMARK34' 0 []}';%(BX31entr) entrance of BX31
DBMARK36={'mo' 'DBMARK36' 0 []}';%(WS31    ) center of WS31
DBMARK37={'mo' 'DBMARK37' 0 []}';%(endUNMCH) end of undulator match
DBMARK38={'mo' 'DBMARK38' 0 []}';%(UND_DUMP) final undulator dump
% ==============================================================================
% Longitudinal misalignments observed after installation and difficult to fix:
% Added to MAD file (but not drawings) so that optics comes out right (1/11/07).
% ------------------------------------------------------------------------------
DZ_QA11   = 3.42E-3    ;%quad is too far downstream when dz>0
DZ_Q21201 =-2.39E-3    ;%quad is too far downstream when dz>0
DZ_Q21301 = 5.73E-3    ;%quad is too far downstream when dz>0
DZ_QM14   = 2.17E-3    ;%quad is too far downstream when dz>0
DZ_QM15   = 2.48E-3    ;%quad is too far downstream when dz>0
% ==============================================================================
% QUADs
% ------------------------------------------------------------------------------
% global QUAD parameters
LQC = 0.1080         ;%eff. length of Everson-Tesla big-bore (ETB) quad [ETB: 2.5-kG GDLmax] (m)
RQC = 0.0300         ;%pole-tip radius of Everson-Tesla big-bore (ETB) quad (m)
LQE = 0.1068         ;%QE effective length (m)
RQE = (1.085*IN2M)/2 ;%QE pole-tip radius (m)
LQX = 0.1080         ;%Everson-Tesla (ET) quads "1.259Q3.5" effective length (m)
RQX = 0.01600        ;%Everson-Tesla (ET) quads "1.259Q3.5" pole-tip radius (m)
LQF = 0.46092        ;%FFTB (0.91Q17.72) effective length (m)
RQF = 0.023/2        ;%FFTB (0.91Q17.72) pole-tip radius (m)
LQA = 0.31600        ;%Q150kG effective length [not known yet] (m)
RQA = 0.016          ;%Q150kG pole-tip radius (m)
LQD = 0.550          ;%FFTB dump quad (3.25Q20) effective length (m)
RQD = (3.25*IN2M)/2  ;%FFTB dump quad (3.25Q20) pole-tip radius (m)
LQW = 0.248          ;%QW (wraparound quad) effective length (m)
RQW = (4.625*IN2M)/2 ;%QW (wraparound quad) pole-tip radius (m)
DLQA2 = (0.46092 - LQA)/2        ;%used to adjust LQA adjacent drifts (m)
% global LCAV parameters
SBANDF = 2856.0    ;%rf frequency (MHz)
XBANDF = SBANDF*4  ;%X-band rf frequency (MHz)
DLWLX  = 0.5948    ;%Xband structure length from input-coupler center to output-coupler center, each with tooling balls (m)
DLWL10 = 3.0441    ;%"10  ft" (29 Sband wavelengths; 87 DLWG cavities)
DLWL9  = 2.8692    ;%"9.41 ft" (27 1/3 Sband wavelengths; 82 DLWG cavities)
DLWL7  = 2.1694    ;%"7   ft" (20 2/3 Sband wavelengths; 62 DLWG cavities)
P25    = 1         ;%25% power factor
P50    = sqrt(2)   ;%50% power factor
% L0 energy profile (model the one 3-m L0b section only)
L0PHASE  = -1.1              ;%L0b S-band rf phase (deg)
DEL0A    = GEV2MEV*(E0I-E00) ;%total L0a energy gain (MeV)
DEL0B    = GEV2MEV*(EI-E0I)  ;%total L0b energy gain (MeV)
PHIL0    = L0PHASE/360       ;%radians/2pi
%  gfac0    := 3.130139           flange-to-flange length of dual-feed L0-a and L0-b RF structures [m]
GFAC0    = 3.095244          ;% flange-to-flange length (121.86" Oct. 18, '05) of dual-feed L0-a and L0-b RF structures [m]
GRADL0A  = DEL0A/(GFAC0*cos(PHIL0*TWOPI));
GRADL0B  = DEL0B/(GFAC0*cos(PHIL0*TWOPI));
% L1 energy profile
L1PHASE  = -25.1             ;%L1 S-band rf phase (deg)
L1XPHASE =-160.0             ;%L1 X-band rf phase (deg)
DEL1     = GEV2MEV*(EBC1-EI) ;%total L1 energy gain (MeV)
DEL1X    = 19.0              ;%L1 X-band amplitude (MeV)
PHIL1    = L1PHASE/360       ;%radians/2pi
PHIL1X   = L1XPHASE/360      ;%radians/2pi
GFAC1    = P50*DLWL9+P25*DLWL9+P25*DLWL10;
GRADL1   = (DEL1-DEL1X*cos(PHIL1X*TWOPI))/(GFAC1*cos(PHIL1*TWOPI));

% L2 energy profile
L2PHASE = -41.4               ;%L2 rf phase (deg)
DEL2    = GEV2MEV*(EBC2-EBC1) ;%total L2 energy gain (MeV)
PHIL2   = L2PHASE/360         ;%radians/2pi
GFAC2   = 110*P25*DLWL10+1*P50*DLWL10;
GRADL2  = DEL2/(GFAC2*cos(PHIL2*TWOPI));

% L3 energy profile
L3PHASE = 0.0               ;%L3 rf phase (deg)
DEL3    = GEV2MEV*(EF-EBC2) ;%total L3 energy gain (MeV)
PHIL3   = L3PHASE/360       ;%radians/2pi
GFAC3   = 161*P25*DLWL10 + 12*P50*DLWL10 + 3*P25*DLWL9 + 4*P25*DLWL7;
GRADL3  = DEL3/(GFAC3*cos(PHIL3*TWOPI));

L1X___1={'lc' 'L1X' DLWLX/2 [XBANDF DEL1X/2 PHIL1X*TWOPI]}';
L1X___2={'lc' 'L1X' DLWLX/2 [XBANDF DEL1X/2 PHIL1X*TWOPI]}';
% L0 sections
L0A___1={'lc' 'L0A' 0.0586460 [SBANDF GRADL0A*0.0586460 PHIL0*TWOPI]}';
L0A___2={'lc' 'L0A' 0.1993540 [SBANDF GRADL0A*0.1993540 PHIL0*TWOPI]}';
L0A___3={'lc' 'L0A' 0.6493198 [SBANDF GRADL0A*0.6493198 PHIL0*TWOPI]}';
L0A___4={'lc' 'L0A' 0.6403022 [SBANDF GRADL0A*0.6403022 PHIL0*TWOPI]}';
L0A___5={'lc' 'L0A' 1.1518464 [SBANDF GRADL0A*1.1518464 PHIL0*TWOPI]}';
L0A___6={'lc' 'L0A' 0.3348566 [SBANDF GRADL0A*0.3348566 PHIL0*TWOPI]}';
L0A___7={'lc' 'L0A' 0.0609190 [SBANDF GRADL0A*0.0609190 PHIL0*TWOPI]}';
L0B___1={'lc' 'L0B' 0.0586460 [SBANDF GRADL0B*0.0586460 PHIL0*TWOPI]}';
L0B___2={'lc' 'L0B' 0.3371281 [SBANDF GRADL0B*0.3371281 PHIL0*TWOPI]}';
L0B___3={'lc' 'L0B' 1.1518479 [SBANDF GRADL0B*1.1518479 PHIL0*TWOPI]}';
L0B___4={'lc' 'L0B' 1.1515630 [SBANDF GRADL0B*1.1515630 PHIL0*TWOPI]}';
L0B___5={'lc' 'L0B' 0.3351400 [SBANDF GRADL0B*0.3351400 PHIL0*TWOPI]}';
L0B___6={'lc' 'L0B' 0.0609190 [SBANDF GRADL0B*0.0609190 PHIL0*TWOPI]}';
FLNGA1={'mo' 'FLNGA1' 0 []}';% upstream   face of L0a entrance flange
FLNGA2={'mo' 'FLNGA2' 0 []}';% downstream face of L0a exit flange
FLNGB1={'mo' 'FLNGB1' 0 []}';% upstream   face of L0b entrance flange
FLNGB2={'mo' 'FLNGB2' 0 []}';% downstream face of L0b exit flange
% transverse deflecting cavities
% TCAV0 : DRIF, L=0.6680236/2   flange-to-flange (then split in two)
% TCAV3 : DRIF, L=2.438/2
TCAV0={'lc' 'TCAV0' 0.6680236/2 [0 0 0*TWOPI]}';% flange-to-flange (then split in two)
TCAV3={'lc' 'TCAV3' 2.438/2 [0 0 0*TWOPI]}';
LKIK    = 1.0601              ;% kicker coil length per magnet (m) [41.737 in from SA-380-330-02, rev. 0]
BXKIKA={'be' 'BXKIK' LKIK/2 [1E-12 25.4E-3 0 0 0.5 0 0]}';
BXKIKB={'be' 'BXKIK' LKIK/2 [1E-12 25.4E-3 0 2E-12 0 0.5 0]}';
% ==============================================================================
% BENDs
% ------------------------------------------------------------------------------
% global BEND parameters
DLBH= 0.0144     ;%increase to lengthen BXH1-4 eff. length (m)
LBH = 0.110+DLBH ;%5D3.9 "Z" length (m)   laser-heater chicane bends approx. effective length (R. Carr, 01-AUG-05 -PE)
GBH = 30E-3      ;%5D3.9 gap height (m)
LB0 = 0.2032     ;%5D7.1 "Z" length (m)
GB0 = 30E-3      ;%5D7.1 gap height (m)
LB1 = 0.2032     ;%5D7.1 "Z" length (m)
GB1 = 43.28E-3   ;%5D7.1 gap height (m)
LB2 = 0.5490     ;%1D19.7 "Z" length (m)      changed from 0.540 m to 0.549 on Sep. 28, '07 based on magnetic measurements - PE
GB2 = 33.35E-3   ;%1D19.7 gap height (m)
LB3 = 2.623      ;%4D102.36T effective length (m)
GB3 = 0.023      ;%4D102.36T gap height (m)
LVB = 1.025      ;%3D39 vertical bend effective length (m)
GVB = 0.034925   ;%vertical bend gap width (m)
% GTL
% ===
RBXG   = 0.1963                 ;% BXG bend radius (measured) [m]
ABXG   = 85.0*RADDEG            ;% bend angle of BXG dipole [deg*RADDEG = rad]
EBXG   = 24.25*RADDEG           ;% BXG pole-face rot. edge angle of BXG dipole [deg*RADDEG = rad]
GBXG   = 0.043                  ;% BXG magnet full gap height (m)
LBXG   = RBXG*ABXG              ;% path length of BXG dipole when ON (= R*theta) [m]

BXGA={'be' 'BXG' LBXG/2 [ABXG/2 GBXG/2 EBXG 0 0.492 0 0]}';% 1st-half of gun spectrometer bend (set to ~zero length and strength, with longitudinal position as the actual bend's center)
BXGB={'be' 'BXG' LBXG/2 [ABXG/2 GBXG/2 0 EBXG 0.0 0.492 0]}';% 1st-half of gun spectrometer bend (set to ~zero length and strength, with longitudinal position as the actual bend's center)
DXG0={'dr' '' RBXG*sin(ABXG/2) []}';% drift, w/BXG off, from BXG entrance face to its z-projected center
DXGA={'be' 'DXG' 1E-9/2 [0/2 0 0 0 0 0 0]}';% 1st-half of gun-spec bend (set to ~zero length and strength, with longitudinal position as bend's center)
DXGB={'be' 'DXG' 1E-9/2 [0/2 0 0 0 0 0 0]}';% 2nd-half of gun-spec bend (set to ~zero length and strength, with longitudinal position as bend's center)
DGS1={'dr' '' 0.1900-LQGX/2-20E-6-0.0155757 []}';
DGS2={'dr' '' (0.2300-LQGX)/2+20E-6 []}';
DGS3={'dr' '' (0.2300-LQGX)/2-20E-6 []}';
DGS4={'dr' '' 0.1680-LQGX/2-0.00283 []}';
DGS5={'dr' '' 0.0300-0.02271 []}';
DGS6={'dr' '' 0.0240-0.00402 []}';
DGS7={'dr' '' 0.05 []}';
RQGX   = 0.020                  ;% QG quadrupole pole-tip radius [m]
LQGX   = 0.076                  ;% QG quadrupole effective length [m]
CQ01={'qu' 'CQ01' 1E-9/2 0}';%correction quad in 1st solenoid at gun (nominally set to 0) (set to ~zero length, with longitudinal position as the actual quad's center)
SQ01={'qu' 'SQ01' 1E-9/2 0}';%correction skew-quad in 1st solenoid at gun (nominally set to 0) (set to ~zero length, with longitudinal position as the actual quad's center)
QG02={'qu' 'QG02' LQGX/2 -35.48540}';
QG03={'qu' 'QG03' LQGX/2 80.16051}';
XCG1={'mo' 'XCG1' 0 []}';
XCG2={'mo' 'XCG2' 0 []}';
YCG1={'mo' 'YCG1' 0 []}';
YCG2={'mo' 'YCG2' 0 []}';
SCG1=[XCG1,YCG1];
SCG2=[XCG2,YCG2];
BPMG1={'mo' 'BPMG1' 0 []}';
CRG1={'mo' 'CRG1' 0 []}';% Cerenkov radiator bunch length monitor
YAGG1={'mo' 'YAGG1' 0 []}';% 6-MeV spectrometer screen
FCG1={'mo' 'FCG1' 0 []}';% gun-spec. Faraday cup w/screen
GSPECBEG={'mo' 'GSPECBEG' 0 []}';
GSPEC=[GSPECBEG,BXGA,BXGB,DGS1,QG02,SCG1,QG02, DGS2,BPMG1,DGS3,QG03,SCG2,QG03,DGS4,YAGG1,DGS5,CRG1,DGS6,FCG1,DGS7,DBMARK97];% gun spectrometer from BXG to Farraday cup and dump
% 135-MeV Spectrometer
% ====================
KQS01 =  9.682244191676;
KQS02 = -5.648980372134;
QS01={'qu' 'QS01' LQX/2 KQS01}';
QS02={'qu' 'QS02' LQX/2 KQS02}';
DX01A={'be' 'DX01' LB0/2 [1E-9 0 0 0 0 0 0]}';% 1st half of BX01 magnet switched off here
DX01B={'be' 'DX01' LB0/2 [1E-9 0 0 0 0 0 0]}';% 2nd half of BX01 magnet switched off here
DS0={'dr' '' 0.5583996 []}';
DS0A={'dr' '' 0.1691504 []}';
DS0B={'dr' '' 0.4615/2 []}';
DS1A={'dr' '' 0.0890085 []}';
DS1B={'dr' '' 0.1451215 []}';
DS1C={'dr' '' 0.171796 []}';
DS1D={'dr' '' 0.251824 []}';
DS2={'dr' '' 0.478250 []}';
DS3A={'dr' '' 0.199626 []}';
DS3B={'dr' '' 0.200374 []}';
DS4={'dr' '' 0.287275 []}';
DS6A={'dr' '' 0.2575952 []}';
DS6B={'dr' '' 0.2273298-0.008205 []}';
DS7={'dr' '' 0.3801874+0.008205-0.02 []}';
DS8={'dr' '' 0.1976126+0.02 []}';
DS9={'dr' '' 0.3378194 []}';
SPECBEG={'mo' 'SPECBEG' 0 []}';
BPMS1={'mo' 'BPMS1' 0 []}';
BPMS2={'mo' 'BPMS2' 0 []}';
BPMS3={'mo' 'BPMS3' 0 []}';
VVS1={'mo' 'VVS1' 0 []}';%135-MeV spectrometer vacuum valve
YAGS1={'mo' 'YAGS1' 0 []}';%1st 135-MeV spectrometer YAG-screen - center of device in MAD is defined as center of YAG crystal, not mirror
YAGS2={'mo' 'YAGS2' 0 []}';%2nd 135-MeV spectrometer YAG-screen - center of device in MAD is defined as center of YAG crystal, not mirror
OTRS1={'mo' 'OTRS1' 0 []}';%135-MeV spectrometer OTR-screen
SDMP={'mo' 'SDMP' 0 []}';% gun-spec. dump (exact location? - 11/09/05)
XCS1={'mo' 'XCS1' 0 []}';
YCS1={'mo' 'YCS1' 0 []}';
XCS2={'mo' 'XCS2' 0 []}';
YCS2={'mo' 'YCS2' 0 []}';
SCS1=[XCS1,YCS1];
SCS2=[XCS2,YCS2];
LBS     = 0.5435        ;%measured effective length along curved trajectory (m)
GBS     = 34E-3         ;%gap height (m)
ABS     = INJDEG*RADDEG ;%injection line angle (rad)
BXSEJ   = -7.29*RADDEG;
BXSA={'be' 'BXS' LBS/2 [ABS/2 GBS/2 BXSEJ 0 0.391 0 0]}';
BXSB={'be' 'BXS' LBS/2 [ABS/2 GBS/2 0 BXSEJ 0 0.391 0]}';
SPECBL=[SPECBEG,DX01A,DX01B,DS0,SCS1,DS0A,DS0B,DS1A,VVS1,DS1B,YAGS1,DS1C,BPMS1,DS1D,BXSA,BXSB,DS2,QS01,BPMS2,QS01,DS3A,SCS2,DS3B,QS02,QS02,DS4,IMS1,DS6A,BPMS3,DS6B,YAGS2,DS7,OTRS1,DS8,DS9,SDMP,DBMARK98];
% DL1
% ===
DL1_ON = 1                      ;%=1: nominal LCLS with BX01/02 bend magnet DL1 power-supply is ON, =0: 135-MeV spectrometer-mode with DL1 OFF
ADL1 = INJDEG*RADDEG            ;%injection line angle (rad)
AB0    = ADL1/2                 ;%full bend angle (rad)
LEFFB0 = LB0*AB0/(2*sin(AB0/2)) ;%full bend path length (m)
AEB0   = AB0/2                  ;%edge angles
BX01A={'be' 'BX01' LEFFB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX01B={'be' 'BX01' LEFFB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
BX02A={'be' 'BX02' LEFFB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX02B={'be' 'BX02' LEFFB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
% BC1
% ===
BRHO1 = CB*EBC1            ;%beam rigidity at BC1 (kG-m)
BB11  = -3.555805785115    ;%chicane-1 bend field (kG) - changed June 22, 2004
RB11  = BRHO1/BB11         ;%chicane-1 bend radius (m)
AB11  = asin(LB1/RB11)     ;%full chicane bend angle (rad)
AB11S = asin((LB1/2)/RB11) ;%"short" half chicane bend angle (rad)
LB11S = RB11*AB11S         ;%"short" half chicane bend path length (m)
AB11L = AB11-AB11S         ;%"long" half chicane bend angle (rad)
LB11L = RB11*AB11L         ;%"long" half chicane bend path length (m)
% BX11 gets an offset of 2.2 mm (theta*L/8) towards the wall
% BX12 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% BX13 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% BX14 gets an offset of 2.2 mm (theta*L/8) towards the wall
BX11A={'be' 'BX11' LB11S [+AB11S GB1/2 0 0 0.387 0 0]}';
BX11B={'be' 'BX11' LB11L [+AB11L GB1/2 0 +AB11 0 0.387 0]}';
BX12A={'be' 'BX12' LB11L [-AB11L GB1/2 -AB11 0 0.387 0 0]}';
BX12B={'be' 'BX12' LB11S [-AB11S GB1/2 0 0 0 0.387 0]}';
BX13A={'be' 'BX13' LB11S [-AB11S GB1/2 0 0 0.387 0 0]}';
BX13B={'be' 'BX13' LB11L [-AB11L GB1/2 0 -AB11 0 0.387 0]}';
BX14A={'be' 'BX14' LB11L [+AB11L GB1/2 +AB11 0 0.387 0 0]}';
BX14B={'be' 'BX14' LB11S [+AB11S GB1/2 0 0 0 0.387 0]}';
% magnet-to-magnet path lengths
LD11   = 2.434900                  ;%outer bend-to-bend "Z" distance (m)
LD11O  = LD11/cos(AB11)            ;%outer bend-to-bend path length (m) (minus ~0.15 m 9/21/04)
LD11A  = 0.261301                  ;%"Z" distance upstream of SQ13 (m)
LD11B  = LD11-LD11A-0.16*cos(AB11) ;%"Z" distance downstream of SQ13 (m)
LD11OA = LD11A/cos(AB11)           ;%path length upstream of SQ13
LD11OB = LD11B/cos(AB11)           ;%path length downstream of SQ13
% BC2
% ===
BRHO2 = CB*EBC2            ;%beam rigidity at BC2 (kG-m)
BB21  = -9.071122639275    ;%chicane bend field (kG)
RB21  = BRHO2/BB21         ;%chicane bend radius (m)
AB21  = asin(LB2/RB21)     ;%full chicane bend angle (rad)
AB21S = asin((LB2/2)/RB21) ;%"short" half chicane bend angle (rad)
LB21S = RB21*AB21S         ;%"short" half chicane bend path length (m)
AB21L = AB21-AB21S         ;%"long" half chicane bend angle (rad)
LB21L = RB21*AB21L         ;%"long" half chicane bend path length (m)
% BX21 gets an offset of ~2.3 mm (theta*L/8) towards the wall
% BX22 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% BX23 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% BX24 gets an offset of ~2.3 mm (theta*L/8) towards the wall
BX21A={'be' 'BX21' LB21S [+AB21S GB2/2 0 0 0.633 0 0]}';
BX21B={'be' 'BX21' LB21L [+AB21L GB2/2 0 +AB21 0 0.633 0]}';
BX22A={'be' 'BX22' LB21L [-AB21L GB2/2 -AB21 0 0.633 0 0]}';
BX22B={'be' 'BX22' LB21S [-AB21S GB2/2 0 0 0 0.633 0]}';
BX23A={'be' 'BX23' LB21S [-AB21S GB2/2 0 0 0.633 0 0]}';
BX23B={'be' 'BX23' LB21L [-AB21L GB2/2 0 -AB21 0 0.633 0]}';
BX24A={'be' 'BX24' LB21L [+AB21L GB2/2 +AB21 0 0.633 0 0]}';
BX24B={'be' 'BX24' LB21S [+AB21S GB2/2 0 0 0 0.633 0]}';
% magnet-to-magnet path lengths
LD21I = 1.0 - 2*0.1       ;%inner bend-to-bend "Z" distance (m)
LD1  = 2.00-0.04-0.0045   ;%outer bend-to-bend "Z" distance (m)
LD2  = 8.00-0.04-0.0508-0.0045   ;%outer bend-to-bend "Z" distance (m)
LD3  = 8.00-0.04-0.0508-0.0045   ;%outer bend-to-bend "Z" distance (m)
LD4  = 2.00-0.04-0.0045   ;%outer bend-to-bend "Z" distance (m)
LDO1 = LD1/cos(AB21)      ;%outer bend-to-bend path length (m)
LDO2 = LD2/cos(AB21)-LQC  ;%outer bend-to-bend path length (m)
LDO3 = LD3/cos(AB21)-LQC  ;%outer bend-to-bend path length (m)
LDO4 = LD4/cos(AB21)      ;%outer bend-to-bend path length (m)
% 52-line stuff
B50B1A={'be' 'B50B1' 1.1320272 [-0.86939816E-02 0 0 0 0 0 0]}';
B50B1B={'be' 'B50B1' 1.1320272 [-0.86939816E-02 0 0 0 0 0 0]}';
B52AGFA={'be' 'B52AGF' 0.40010029 [-0.14360109E-02 0 0 0 0 0 0]}';
B52AGFB={'be' 'B52AGF' 0.40010029 [-0.14360109E-02 0 0 0 0 0 0]}';
B52WIG1A={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0 pi/2]}';
B52WIG1B={'be' 'B52WIG1' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0 pi/2]}';
B52WIG2A={'be' 'B52WIG2' 0.23368102 [0.23818974E-02 0 0 0 0 0 pi/2]}';
B52WIG2B={'be' 'B52WIG2' 0.23368102 [0.23818974E-02 0 0 0 0 0 pi/2]}';
B52WIG3A={'be' 'B52WIG3' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0 pi/2]}';
B52WIG3B={'be' 'B52WIG3' 0.23367797/2 [-0.23818663E-02/2 0 0 0 0 0 pi/2]}';
Q52Q2={'qu' 'Q52Q2' 0.37224614 -0.38544745}';
XC69={'mo' 'XC69' 0 []}';
YC54T={'mo' 'YC54T' 0 []}';
YC59={'mo' 'YC59' 0 []}';
BPM52={'mo' 'BPM52' 0 []}';
BPM56={'mo' 'BPM56' 0 []}';
BPM64={'mo' 'BPM64' 0 []}';
BPM68={'mo' 'BPM68' 0 []}';
IM61={'mo' 'IM61' 0 []}';
PR45={'mo' 'PR45' 0 []}';
PR55={'mo' 'PR55' 0 []}';
PR60={'mo' 'PR60' 0 []}';
WS62={'mo' 'WS62' 0 []}';
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
T460061T={'dr' '' 0 []}';
DRI14011={'dr' '' 0.1981200 []}';
DRI14012={'dr' '' 0.3230880 []}';
DRI14013={'dr' '' 0.4252539 []}';
SL1X={'dr' '' 0 []}';
DRI14014={'dr' '' 0.7909590 []}';
SL1Y={'dr' '' 0 []}';
DRI14015={'dr' '' 1.0088270 []}';
DRI14016={'dr' '' 0.3139440 []}';
DRI14017={'dr' '' 2.2764689 []}';
SL2={'dr' '' 0 []}';
% Vertical bend system and DL2
AVB = (S100_PITCH + asin(Z_S100_UNDH/(R_EARTH+S100_HEIGHT)))/2 ;%bend up twice this angle so e- is level in cnt. of und., incl. 30-m ext.

BY1A={'be' 'BY1' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY1B={'be' 'BY1' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
BY2A={'be' 'BY2' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY2B={'be' 'BY2' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
AB3P   = 0.5*RADDEG*(+1);
AB3M   = 0.5*RADDEG*(-1);
LEFFB3 = LB3*AB3P/(2*sin(AB3P/2)) ;%full bend eff. path length (m)
BX31A={'be' 'BX31' LEFFB3/2 [AB3P/2 GB3/2 AB3P/2 0 0.5 0.0 0]}';
BX31B={'be' 'BX31' LEFFB3/2 [AB3P/2 GB3/2 0 AB3P/2 0.0 0.5 0]}';
BX32A={'be' 'BX32' LEFFB3/2 [AB3P/2 GB3/2 AB3P/2 0 0.5 0.0 0]}';
BX32B={'be' 'BX32' LEFFB3/2 [AB3P/2 GB3/2 0 AB3P/2 0.0 0.5 0]}';
DX33A={'dr' '' LB3/2 []}';%optional bend for branch point
DX33B={'dr' '' LB3/2 []}';
DX34A={'dr' '' LB3/2 []}';
DX34B={'dr' '' LB3/2 []}';
BX35A={'be' 'BX35' LEFFB3/2 [AB3M/2 GB3/2 AB3M/2 0 0.5 0.0 0]}';
BX35B={'be' 'BX35' LEFFB3/2 [AB3M/2 GB3/2 0 AB3M/2 0.0 0.5 0]}';
BX36A={'be' 'BX36' LEFFB3/2 [AB3M/2 GB3/2 AB3M/2 0 0.5 0.0 0]}';
BX36B={'be' 'BX36' LEFFB3/2 [AB3M/2 GB3/2 0 AB3M/2 0.0 0.5 0]}';
DX37A={'dr' '' LB3/2 []}';%optional bend for branch point
DX37B={'dr' '' LB3/2 []}';
DX38A={'dr' '' LB3/2 []}';
DX38B={'dr' '' LB3/2 []}';
% Single beam dumper vertical kicker:
% ----------------------------------
BYKIK1A={'be' 'BYKIK1' LKIK/2 [1E-12/2 25.4E-3 0 0 0.5 0 pi/2]}';
BYKIK1B={'be' 'BYKIK1' LKIK/2 [1E-12/2 25.4E-3 0 0 0 0.5 pi/2]}';
BYKIK2A={'be' 'BYKIK2' LKIK/2 [1E-12/2 25.4E-3 0 0 0.5 0 pi/2]}';
BYKIK2B={'be' 'BYKIK2' LKIK/2 [1E-12/2 25.4E-3 0 0 0 0.5 pi/2]}';
TDKIK={'mo' 'TDKIK' 0.6096 []}';%SBD vertical off-axis kicker dump (24 in long - 9/8/08)
SPOILER={'mo' 'SPOILER' 0 []}';%SBD dump spoiler
% X-ray stripe 'wiggler' vertical 3-dipole chicane (from SLC BSY)
LBXW  = 0.233681            ;%"Z" length (m)
%  GBxw  := 1.05*in2m           gap height - SLC wiggler gap not known yet - used 1.05 inches for now - 7/6/05 -PE (m)
BRHOX = CB*EF               ;%beam rigidity in LTU (kG-m)
BBXW  = -6.0                ;%X-ray chicane bend field (kG) - (eta matching in DL2 not fixed yet: small error - PE)
RBXW  = BRHOX/BBXW          ;%X-ray chicane bend radius (m)
ABXW  = asin(LBXW/RBXW)     ;%full X-ray chicane bend angle (rad)
%  ABxwS := ASIN((LBxw/2)/RBxw) "short" half X-ray chicane bend angle (rad)
%  LBxwS := RBxw*ABxwS          "short" half X-ray chicane bend path length (m)
%  ABxwL := ABxw-ABxwS          "long" half X-ray chicane bend angle (rad)
%  LBxwL := RBxw*ABxwL          "long" half X-ray chicane bend path length (m)

%  BYw1A : SBEN, TYPE="5D7.1", L=LBxwS, ANGLE=+ABxwS, HGAP=GBxw/2, &
%                E1=0, FINT=0.5, FINTX=0, TILT
%  BYw1B : SBEN, TYPE="5D7.1", L=LBxwL, ANGLE=+ABxwL, HGAP=GBxw/2, &
%                FINT=0, E2=+ABxw, FINTX=0.5, TILT
%  BYw2A : SBEN, TYPE="5D7.1", L=LBxwL+LBxwS, ANGLE=-ABxw, HGAP=GBxw/2, &
%                E1=-ABxw, FINT=0.5, FINTX=0, TILT
%  BYw2B : SBEN, TYPE="5D7.1", L=LBxwS+LBxwL, ANGLE=-ABxw, HGAP=GBxw/2, &
%                FINT=0, E2=-ABxw, FINTX=0.5, TILT
%  BYw3A : SBEN, TYPE="5D7.1", L=LBxwL, ANGLE=+ABxwL, HGAP=GBxw/2, &
%                E1=+ABxw, FINT=0.5, FINTX=0, TILT
%  BYw3B : SBEN, TYPE="5D7.1", L=LBxwS, ANGLE=+ABxwS, HGAP=GBxw/2, &
%                FINT=0, E2=0, FINTX=0.5, TILT
DBYW1A={'dr' '' LBXW/2 []}';
DBYW1B={'dr' '' LBXW/2 []}';
DBYW2A={'dr' '' LBXW []}';
DBYW2B={'dr' '' LBXW []}';
DBYW3A={'dr' '' LBXW/2 []}';
DBYW3B={'dr' '' LBXW/2 []}';
LDW1O = 0.173736;
SDW1O = LDW1O/cos(ABXW);
DW1O={'dr' '' SDW1O []}';
% Dump:
% ----
LBDM   = 1.452          ;%effective vertical bend length of main dump bends - from J. Tanabe (m)
GBDM   = 0.043          ;%full gap (m) - this is a full gap 'width' for these vert. dipoles
ABDM0  = (5.0*RADDEG)/3;
LBPM   = 0.944             ;%effective length of permanent magnet FFTB dump bends (m)
BPM0   = 4.3               ;%permanent magnetic field at full gap = 3.81 cm
GBPM  = 0.0381            ;%gap height as exists in FFTB in 2005 (m)
BPM    = BPM0*GBPM/0.0520 ;%permanent magnetic field after opening gaps
ABPM   = LBPM*BPM/BRHOX;
LEFFBDM = LBDM*ABDM0/(2*sin(ABDM0/2)) ;%full bend path length (m)
BYD1A={'be' 'BYD1' LEFFBDM/2 [ABDM0/2 GBDM/2 ABDM0/2 0 0.57 0.00 pi/2]}';
BYD1B={'be' 'BYD1' LEFFBDM/2 [ABDM0/2 GBDM/2 0 ABDM0/2 0.00 0.57 pi/2]}';
BYD2A={'be' 'BYD2' LEFFBDM/2 [ABDM0/2 GBDM/2 ABDM0/2 0 0.57 0.00 pi/2]}';
BYD2B={'be' 'BYD2' LEFFBDM/2 [ABDM0/2 GBDM/2 0 ABDM0/2 0.00 0.57 pi/2]}';
BYD3A={'be' 'BYD3' LEFFBDM/2 [ABDM0/2 GBDM/2 ABDM0/2 0 0.57 0.00 pi/2]}';
BYD3B={'be' 'BYD3' LEFFBDM/2 [ABDM0/2 GBDM/2 0 ABDM0/2 0.00 0.57 pi/2]}';
BXPM1A={'be' 'BXPM1' LBPM/2 [ABPM/2 GBPM/2 0 0 0.5 0.0 0]}';
BXPM1B={'be' 'BXPM1' LBPM/2 [ABPM/2 GBPM/2 0 1*ABPM 0.0 0.5 0]}';
BXPM2A={'be' 'BXPM2' LBPM/2 [ABPM/2 GBPM/2 1*ABPM 0 0.5 0.0 0]}';
BXPM2B={'be' 'BXPM2' LBPM/2 [ABPM/2 GBPM/2 0 2*ABPM 0.0 0.5 0]}';
BXPM3A={'be' 'BXPM3' LBPM/2 [ABPM/2 GBPM/2 2*ABPM 0 0.5 0.0 0]}';
BXPM3B={'be' 'BXPM3' LBPM/2 [ABPM/2 GBPM/2 0 3*ABPM 0.0 0.5 0]}';
% DL1
%  KQA01 :=  -7.474220813631             OLD - no lsr-htr (for commissioning in Dec. '06 through July '07) & on-measured TWSS0
%  KQA02 :=   8.137641193725
%  KQE01 :=  -2.215639104385
%  KQE02 :=  -0.241173314721
%  KQE03 :=   7.613440306134
%  KQE04 :=  -6.985386854286
%  KQA01 := -12.492179751016             OLD - with 5.4-cm lamu lsr-htr and "MATRIX" focusing, but non-measured TWSS0
%  KQA02 :=  11.022504569397
%  KQE01 :=  -3.089332618348
%  KQE02 :=   0.090132722014
%  KQE03 :=   6.822078966488
%  KQE04 :=  -5.731166555613
%  KQA01 := -6.1200                      post Aug. 11, 2008 matching based on real measurements with heater/chicane not yet installed (64 & 135 MeV)
%  KQA02 := 12.6808
%  KQE01 := -1.4046
%  KQE02 := -2.4546
%  KQE03 :=  9.6624
%  KQE04 := -7.4610
KQA01 = -12.317411498864            ;% new design with laser-heater ON (chicane and und, w/Betx=Bety=12 m), based on measured (back-tracked) TWSS0
KQA02 =  13.706906173749;
KQE01 =  -6.538179321052;
KQE02 =   5.354060093454;
KQE03 =   6.054674881291;
KQE04 =  -5.235476556481;
KQM01 =  15.072053882204;
KQM02 = -11.974604636345;
KQM03 =  -8.255421303054;
KQM04 =  13.306105246908;
KQB   =  22.169701529353;
QA01={'qu' 'QA01' LQX/2 KQA01}';
QA02={'qu' 'QA02' LQX/2 KQA02}';
QE01={'qu' 'QE01' LQX/2 KQE01}';
QE02={'qu' 'QE02' LQX/2 KQE02}';
QE03={'qu' 'QE03' LQX/2 KQE03}';
QE04={'qu' 'QE04' LQX/2 KQE04}';
QM01={'qu' 'QM01' LQX/2 KQM01}';
QM02={'qu' 'QM02' LQX/2 KQM02}';
QB={'qu' 'QB' LQE/2 KQB}';
QM03={'qu' 'QM03' LQX/2 KQM03}';
QM04={'qu' 'QM04' LQX/2 KQM04}';
% L1
KQL1 = 3.789198342593;
QFL1={'qu' 'QFL1' LQE/2 +KQL1}';
QDL1={'qu' 'QDL1' LQE/2 -KQL1}';
KQA11 = -KQL1;
KQA12 =  1.863910872552;
QA11={'qu' 'QA11' LQX/2 KQA11}';
QA12={'qu' 'QA12' LQX/2 KQA12}';
% BC1
KQ21201 =  -9.357677119503;
KQM11   =   7.960339117021;
KQM12   =  -8.366726970987;
KQM13   =   9.860390676906;
KCQ11   =   1E-12;
KSQ13   =   1E-12;
KCQ12   =   1E-12;
KQ21301 =  -0.1347              ;% turn this quad OFF for LCLS operations (this is meas'd remnant field of Gdl = 0.12 kG)
KQM14   =   7.079239169293;
KQM15   =  -6.765038435385;
Q21201={'qu' 'Q21201' LQE/2 KQ21201}';% (QE-072 after Aug 2006) gets moved downstream of pre-LCLS location by 1.101312 m (measured parallel to main linac axis)
QM11={'qu' 'QM11' LQX/2 KQM11}';
CQ11={'qu' 'CQ11' LQC/2 KCQ11}';% now ETB tweaker quad
SQ13={'qu' 'SQ13' 0.16/2 KSQ13}';% per Kirk Bertsche
CQ12={'qu' 'CQ12' LQC/2 KCQ12}';% now ETB tweaker quad
QM12={'qu' 'QM12' LQX/2 KQM12}';
QM13={'qu' 'QM13' LQX/2 KQM13}';
Q21301={'qu' 'Q21301' LQE/2 KQ21301}';% (QE-004 after Aug 2006) gets moved downstream of pre-LCLS location by 1.247066 m (measured parallel to main linac axis), and turned off for LCLS
QM14={'qu' 'QM14' LQX/2 KQM14}';
QM15={'qu' 'QM15' LQX/2 KQM15}';
% L2
KQL2 = 0.708388522907;
QFL2={'qu' 'QFL2' LQE/2 +KQL2}';
QDL2={'qu' 'QDL2' LQE/2 -KQL2}';
KQ21401 =  1.044881943081  ;% (QE-002 after Aug 2006)
KQ21501 = -0.833170329125 ;% (use pre-Aug-2006 Q21201 magnet)
KQ21601 =  KQL2           ;% (use pre-Aug-2006 Q21301 magnet)
KQ21701 = -KQL2;
KQ21801 =  0.721703961622;
KQ21901 = -0.721930035688;
KQ22201 =  0.711368406706;
KQ22301 = -0.764179973154;
KQ22401 =  KQL2;
KQ22501 = -KQL2;
KQ22601 =  KQL2;
KQ22701 = -KQL2;
KQ22801 =  0.748596129657;
KQ22901 = -0.709657173604;
KQ23201 =  0.721241098608;
KQ23301 = -0.741011348313;
KQ23401 =  KQL2;
KQ23501 = -KQL2;
KQ23601 =  KQL2;
KQ23701 = -KQL2;
KQ23801 =  0.770675623153;
KQ23901 = -0.726878264576;
KQ24201 =  0.779404953697;
KQ24301 = -0.856812505218;
KQ24401 =  1.025618689057;
KQ24501 = -0.931675081162;
KQ24601 =  0.603160584173;
Q21401={'qu' 'Q21401' LQE/2 KQ21401}';
Q21501={'qu' 'Q21501' LQE/2 KQ21501}';
Q21601={'qu' 'Q21601' LQE/2 KQ21601}';
Q21701={'qu' 'Q21701' LQE/2 KQ21701}';
Q21801={'qu' 'Q21801' LQE/2 KQ21801}';
Q21901={'qu' 'Q21901' LQE/2 KQ21901}';
Q22201={'qu' 'Q22201' LQE/2 KQ22201}';
Q22301={'qu' 'Q22301' LQE/2 KQ22301}';
Q22401={'qu' 'Q22401' LQE/2 KQ22401}';
Q22501={'qu' 'Q22501' LQE/2 KQ22501}';
Q22601={'qu' 'Q22601' LQE/2 KQ22601}';
Q22701={'qu' 'Q22701' LQE/2 KQ22701}';
Q22801={'qu' 'Q22801' LQE/2 KQ22801}';
Q22901={'qu' 'Q22901' LQE/2 KQ22901}';
Q23201={'qu' 'Q23201' LQE/2 KQ23201}';
Q23301={'qu' 'Q23301' LQE/2 KQ23301}';
Q23401={'qu' 'Q23401' LQE/2 KQ23401}';
Q23501={'qu' 'Q23501' LQE/2 KQ23501}';
Q23601={'qu' 'Q23601' LQE/2 KQ23601}';
Q23701={'qu' 'Q23701' LQE/2 KQ23701}';
Q23801={'qu' 'Q23801' LQE/2 KQ23801}';
Q23901={'qu' 'Q23901' LQE/2 KQ23901}';
Q24201={'qu' 'Q24201' LQE/2 KQ24201}';
Q24301={'qu' 'Q24301' LQE/2 KQ24301}';
Q24401={'qu' 'Q24401' LQE/2 KQ24401}';
Q24501={'qu' 'Q24501' LQE/2 KQ24501}';
Q24601={'qu' 'Q24601' LQE/2 KQ24601}';
% BC2
KQ24701 = -1.286030138047;
KQM21   =  0.508115309359;
KCQ21   =  1E-12;
KCQ22   =  1E-12;
KQM22   = -0.590418980634;
KQ24901 =  1.082042245094;
Q24701A={'qu' 'Q24701A' LQE/2 KQ24701}';% in same location as pre-LCLS (with its BPM)
Q24701B={'qu' 'Q24701B' LQE/2 KQ24701}';% 10 cm between Q24701A & B
QM21={'qu' 'QM21' LQF/2 KQM21}';
CQ21={'qu' 'CQ21' LQC/2 KCQ21}';
CQ22={'qu' 'CQ22' LQC/2 KCQ22}';
QM22={'qu' 'QM22' LQF/2 KQM22}';
Q24901A={'qu' 'Q24901A' LQE/2 KQ24901}';% moved 2.397400 m downstream of original Q24901 position
Q24901B={'qu' 'Q24901B' LQE/2 KQ24901}';% 10 cm between Q24901A & B (BPM in this 2nd quad)
% L3
%  KQFL3 :=  0.446670469684  was used for 12*2*pi MUX from BX24 to BX31
%  KQDL3 := -0.424793498653  was used for 12*2*pi MUX from BX24 to BX31
KQFL3 =  0.395798933782  ;% gives psix = 50.76 deg, 44.64 deg, 45.00 deg between four LI28 wires
KQDL3 = -0.395649286346  ;% gives TCAV3 -> OTR30 right + WS28 psiy: 48.96 deg, 45.72 deg, 43.92 deg
QFL3={'qu' 'QFL3' LQE/2 KQFL3}';
QDL3={'qu' 'QDL3' LQE/2 KQDL3}';
KQ25201 =  0.697993592575;
KQ25301 = -0.478388226374;
KQ25401 =  0.42896785871;
KQ25501 = -0.399864956514;
KQ25601 =  KQFL3;
KQ25701 =  KQDL3;
KQ25801 =  0.407168436855;
KQ25901 = -0.388171234952;
KQ26201 =  0.388578933647;
KQ26301 = -0.405404843557;
KQ26401 =  KQFL3;
KQ26501 =  KQDL3;
KQ26601 =  KQFL3;
KQ26701 =  KQDL3;
KQ26801 =  0.406308742855;
KQ26901 = -0.388549789828;
KQ27201 =  0.390161854669;
KQ27301 = -0.406474370795;
KQ27401 =  KQFL3;
KQ27501 =  KQDL3;
KQ27601 =  KQFL3;
KQ27701 =  KQDL3;
KQ27801 =  0.406495928662;
KQ27901 = -0.388870517181;
KQ28201 =  0.390352348197;
KQ28301 = -0.406461529502;
KQ28401 =  KQFL3;
KQ28501 =  KQDL3;
KQ28601 =  KQFL3;
KQ28701 =  KQDL3;
KQ28801 =  0.406649614831;
KQ28901 = -0.389077444001;
KQ29201 =  0.390429567548;
KQ29301 = -0.406416613477;
KQ29401 =  KQFL3;
KQ29501 =  KQDL3;
KQ29601 =  KQFL3;
KQ29701 =  KQDL3;
KQ29801 =  0.406588653506;
KQ29901 = -0.389037213556;
KQ30201 =  0.39027307525;
KQ30301 = -0.406178588622;
KQ30401 =  KQFL3;
KQ30501 =  KQDL3;
KQ30601 =  KQFL3;
KQ30615 =  0;
KQ30701 =  KQDL3;
KQ30715 =  0;
KQ30801 =  0.418743774352;
Q25201={'qu' 'Q25201' LQE/2 KQ25201}';
Q25301={'qu' 'Q25301' LQE/2 KQ25301}';
Q25401={'qu' 'Q25401' LQE/2 KQ25401}';
Q25501={'qu' 'Q25501' LQE/2 KQ25501}';
Q25601={'qu' 'Q25601' LQE/2 KQ25601}';
Q25701={'qu' 'Q25701' LQE/2 KQ25701}';
Q25801={'qu' 'Q25801' LQE/2 KQ25801}';
Q25901={'qu' 'Q25901' LQE/2 KQ25901}';
Q26201={'qu' 'Q26201' LQE/2 KQ26201}';
Q26301={'qu' 'Q26301' LQE/2 KQ26301}';
Q26401={'qu' 'Q26401' LQE/2 KQ26401}';
Q26501={'qu' 'Q26501' LQE/2 KQ26501}';
Q26601={'qu' 'Q26601' LQE/2 KQ26601}';
Q26701={'qu' 'Q26701' LQE/2 KQ26701}';
Q26801={'qu' 'Q26801' LQE/2 KQ26801}';
Q26901={'qu' 'Q26901' LQE/2 KQ26901}';
Q27201={'qu' 'Q27201' LQE/2 KQ27201}';
Q27301={'qu' 'Q27301' LQE/2 KQ27301}';
Q27401={'qu' 'Q27401' LQE/2 KQ27401}';
Q27501={'qu' 'Q27501' LQE/2 KQ27501}';
Q27601={'qu' 'Q27601' LQE/2 KQ27601}';
Q27701={'qu' 'Q27701' LQE/2 KQ27701}';
Q27801={'qu' 'Q27801' LQE/2 KQ27801}';
Q27901={'qu' 'Q27901' LQE/2 KQ27901}';
Q28201={'qu' 'Q28201' LQE/2 KQ28201}';
Q28301={'qu' 'Q28301' LQE/2 KQ28301}';
Q28401={'qu' 'Q28401' LQE/2 KQ28401}';
Q28501={'qu' 'Q28501' LQE/2 KQ28501}';
Q28601={'qu' 'Q28601' LQE/2 KQ28601}';
Q28701={'qu' 'Q28701' LQE/2 KQ28701}';
Q28801={'qu' 'Q28801' LQE/2 KQ28801}';
Q28901={'qu' 'Q28901' LQE/2 KQ28901}';
Q29201={'qu' 'Q29201' LQE/2 KQ29201}';
Q29301={'qu' 'Q29301' LQE/2 KQ29301}';
Q29401={'qu' 'Q29401' LQE/2 KQ29401}';
Q29501={'qu' 'Q29501' LQE/2 KQ29501}';
Q29601={'qu' 'Q29601' LQE/2 KQ29601}';
Q29701={'qu' 'Q29701' LQE/2 KQ29701}';
Q29801={'qu' 'Q29801' LQE/2 KQ29801}';
Q29901={'qu' 'Q29901' LQE/2 KQ29901}';
Q30201={'qu' 'Q30201' LQE/2 KQ30201}';
Q30301={'qu' 'Q30301' LQE/2 KQ30301}';
Q30401={'qu' 'Q30401' LQE/2 KQ30401}';
Q30501={'qu' 'Q30501' LQE/2 KQ30501}';
Q30601={'qu' 'Q30601' LQE/2 KQ30601}';
Q30615A={'qu' 'Q30615A' LQW/2 KQ30615}';
Q30615B={'qu' 'Q30615B' LQW/2 KQ30615}';
Q30615C={'qu' 'Q30615C' LQW/2 KQ30615}';
Q30701={'qu' 'Q30701' LQE/2 KQ30701}';
Q30715A={'qu' 'Q30715A' LQW/2 KQ30715}';
Q30715B={'qu' 'Q30715B' LQW/2 KQ30715}';
Q30715C={'qu' 'Q30715C' LQW/2 KQ30715}';
Q30801={'qu' 'Q30801' LQE/2 KQ30801}';
% BSY
K50Q   =  0.252164058501;
KQ50Q1 = -K50Q;
KQ50Q2 =  K50Q;
KQ50Q3 = -K50Q;
KQSM1  =  0;
KQ5    = -0.159291446684;
KQ6    =  0.234194141524;
KQA0   = -0.201473658651;
Q50Q1={'qu' 'Q50Q1' 0.093671 KQ50Q1}';
Q50Q2={'qu' 'Q50Q2' 0.162151 KQ50Q2}';
Q50Q3={'qu' 'Q50Q3' 0.143254 KQ50Q3}';
QSM1={'qu' 'QSM1' 0.101 KQSM1}';
Q5={'qu' 'Q5' LQF/2 KQ5}';
Q6={'qu' 'Q6' LQF/2 KQ6}';
QA0={'qu' 'QA0' LQF/2 KQA0}';
% LTU vertical bend system quads:
% ------------------------------
KQVM1 = -0.978990884832;
KQVM2 =  0.666842383965;
KQVM3 =  0.757009388096;
KQVM4 = -0.735502720623;
KQVB  = -0.42223036711;
QVM1={'qu' 'QVM1' LQF/2 KQVM1}';
QVM2={'qu' 'QVM2' LQF/2 KQVM2}';
QVB1={'qu' 'QVB1' LQF/2 KQVB}';
QVB2={'qu' 'QVB2' LQF/2 -KQVB}';
QVB3={'qu' 'QVB3' LQF/2 KQVB}';
QVM3={'qu' 'QVM3' LQF/2 KQVM3}';
QVM4={'qu' 'QVM4' LQF/2 KQVM4}';
% LTU dog-leg bend system quads:
% ------------------------------
KQDL   = 0.44267670105;
KCQ31  = 0;
KCQ32  = 0;
KQT1   =-0.420937827343;
KQT2   = 0.839614778043;
KQEM1  =-0.3948193191;
KQEM2  = 0.437029374266;
KQEM3  =-0.601204901993;
KQEM4  = 0.425609607536;
%KQEM1  := 0.523067013378          set KQED2=0 and match QEM1-4 for slice-x-emit on OTR33: BETX,Y=20.6 m, ALFX,Y=0 (20.6=12*DE3[L]/5) - 9/9/08
%KQEM2  :=-0.353726700311
%KQEM3  := 0.476261669139          use nearby QEM3V quad to scan slice-x-emit on OTR33
%KQEM4  :=-0.277924519027
KQUM1  = 0.438152708498         ;% for <beta>=30 m undulator
KQUM2  =-0.387122017170         ;% for <beta>=30 m undulator
KQUM3  = 0.092751923581         ;% for <beta>=30 m undulator
KQUM4  = 0.340037095214         ;% for <beta>=30 m undulator
KQED2  = 0.402753198232*1       ;% ED2 FODO quad strength (set =0 for slice-emit on OTR33)
QDL31={'qu' 'QDL31' LQA/2 KQDL}';
QDL32={'qu' 'QDL32' LQA/2 KQDL}';
QDL33={'qu' 'QDL33' LQA/2 KQDL}';
QDL34={'qu' 'QDL34' LQA/2 KQDL}';
CQ31={'qu' 'CQ31' LQX/2 KCQ31}';
CQ32={'qu' 'CQ32' LQX/2 KCQ32}';
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
QE31={'qu' 'QE31' LQX/2 +KQED2}';
QE32={'qu' 'QE32' LQX/2 -KQED2}';
QE33={'qu' 'QE33' LQX/2 +KQED2}';
QE34={'qu' 'QE34' LQX/2 -KQED2}';
QE35={'qu' 'QE35' LQX/2 +KQED2}';
QE36={'qu' 'QE36' LQX/2 -KQED2}';
QEM1={'qu' 'QEM1' LQA/2 KQEM1}';
QEM2={'qu' 'QEM2' LQA/2 KQEM2}';
QEM3={'qu' 'QEM3' LQA/2 KQEM3}';
QEM3V={'qu' 'QEM3V' LQX/2 0}';
QEM4={'qu' 'QEM4' LQA/2 KQEM4}';
QUM1={'qu' 'QUM1' LQA/2 KQUM1}';
QUM2={'qu' 'QUM2' LQA/2 KQUM2}';
QUM3={'qu' 'QUM3' LQA/2 KQUM3}';
QUM4={'qu' 'QUM4' LQA/2 KQUM4}';
% LTU stuff:
% ---------
LPCTDKIK= 0.8128                                            ;% length of each if 4 muon protection collimator after TDKIK (0.875" ID w/pipe)
PCTDKIK1={'dr' 'PCTDKIK1' LPCTDKIK []}';% muon collimator after SBD TDKIK in-line dump
PCTDKIK2={'dr' 'PCTDKIK2' LPCTDKIK []}';% muon collimator after SBD TDKIK in-line dump
PCTDKIK3={'dr' 'PCTDKIK3' LPCTDKIK []}';% muon collimator after SBD TDKIK in-line dump
PCTDKIK4={'dr' 'PCTDKIK4' LPCTDKIK []}';% muon collimator after SBD TDKIK in-line dump
DTDUND1={'dr' '' 0.5+0.127+1.087896-0.003189 []}';% drift before pre-undulator tune-up dump
DTDUND2={'dr' '' 0.37935 []}';% drift after pre-undulator tune-up dump
PCMUON={'dr' 'PCMUON' 1.1684 []}';% muon scattering collimator after pre-undulator tune-up dump (ID from Rago: 7/18/08)
DVV35={'dr' '' 1.780-0.254-1.087896+0.003189 []}';% drift after pre-undulator vacuum valve
VV999={'mo' 'VV999' 0 []}';% new vacuum valve just upbeam of undulator
VV36={'mo' 'VV36' 0 []}';% treaty-point vacuum valve just downbeam of undulator
VV37={'mo' 'VV37' 0 []}';% vac. valve in dumpline
VV38={'mo' 'VV38' 0 []}';% vac. valve in safety-dump line
% Undulator:
% ---------
GAMF   =  EF/MC2                                   ;% Lorentz energy factor in undulator [ ]
KUND   =   3.500;                                  ;% Undulator parameter (rms) [ ]
LAMU   =   0.030;                                  ;% Undulator period [m]
GQF    =  38.461538;                               ;% Undulator F-quad gradient [T/m] (3 T integrated gradient)
GQD    = -38.461538;                               ;% Undulator D-quad gradient [T/m] (3 T integrated gradient)
LQU    =   0.078;                                  ;% Undulator quadrupole effective length [m]
LSEG   =   3.400;                                  ;% Undulator segment length [m]
LUE    =   0.035                                   ;% Undulator termination length (approx) [m]
LUND   =   LSEG - 2*LUE;                           ;% Undulator segment length without terminations [m]
LUNDH  =   LUND/2;
SHRT   =   0.470;                                  ;% Standard short break length [m]
LONG   =   0.898;                                  ;% Standard long break length [m]
LRFBU  =   0                                       ;% undulator RF-BPM only implemented as zero length monitor
LBR1   =   6.889E-2                                ;% und-seg to quad [m]
LBR3   =   9.111E-2                                ;% quad to BPM [m]
LBR4   =   5.8577E-2                               ;% Radiation monitor to segment [m]
LBRWM  =   7.1683E-2                               ;% BFW to radiation monitor [m]
LBRS   =   SHRT-LRFBU-LQU-LBR1-LBR3-LBR4-LBRWM;    ;% Standard short break length (BPM-to-quad distance) [m]
LBUVV2 =   0.2                                     ;% drift length after inline vaccum valve
LBUVV1 =   LBRL - LBUVV2                           ;% drift length before inline vaccum valve
LBRL   =   LONG-LRFBU-LQU-LBR1-LBR3-LBR4-LBRWM;    ;% Standard long break length (BPM-to-quad distance) [m]
KQUND  = (KUND*2*pi/LAMU/sqrt(2)/GAMF)^2           ;% natural undulator focusing "k" in y-plane [m^-2]
KQF    = 1E-9*GQF*CLIGHT/EF;                       ;% QF undulator quadrupole focusing "k" [m^-2]
KQD    = 1E-9*GQD*CLIGHT/EF;                       ;% QD undulator quadrupole focusing "k" [m^-2]

QU01={'qu' 'QU01' LQU/2 KQD}';% undulator quad (even numbers are QF's, odd are QD's)
QU02={'qu' 'QU02' LQU/2 KQF}';% undulator quad
QU03={'qu' 'QU03' LQU/2 KQD}';% undulator quad
QU04={'qu' 'QU04' LQU/2 KQF}';% undulator quad
QU05={'qu' 'QU05' LQU/2 KQD}';% undulator quad
QU06={'qu' 'QU06' LQU/2 KQF}';% undulator quad
QU07={'qu' 'QU07' LQU/2 KQD}';% undulator quad
QU08={'qu' 'QU08' LQU/2 KQF}';% undulator quad
QU09={'qu' 'QU09' LQU/2 KQD}';% undulator quad
QU10={'qu' 'QU10' LQU/2 KQF}';% undulator quad
QU11={'qu' 'QU11' LQU/2 KQD}';% undulator quad
QU12={'qu' 'QU12' LQU/2 KQF}';% undulator quad
QU13={'qu' 'QU13' LQU/2 KQD}';% undulator quad
QU14={'qu' 'QU14' LQU/2 KQF}';% undulator quad
QU15={'qu' 'QU15' LQU/2 KQD}';% undulator quad
QU16={'qu' 'QU16' LQU/2 KQF}';% undulator quad
QU17={'qu' 'QU17' LQU/2 KQD}';% undulator quad
QU18={'qu' 'QU18' LQU/2 KQF}';% undulator quad
QU19={'qu' 'QU19' LQU/2 KQD}';% undulator quad
QU20={'qu' 'QU20' LQU/2 KQF}';% undulator quad
QU21={'qu' 'QU21' LQU/2 KQD}';% undulator quad
QU22={'qu' 'QU22' LQU/2 KQF}';% undulator quad
QU23={'qu' 'QU23' LQU/2 KQD}';% undulator quad
QU24={'qu' 'QU24' LQU/2 KQF}';% undulator quad
QU25={'qu' 'QU25' LQU/2 KQD}';% undulator quad
QU26={'qu' 'QU26' LQU/2 KQF}';% undulator quad
QU27={'qu' 'QU27' LQU/2 KQD}';% undulator quad
QU28={'qu' 'QU28' LQU/2 KQF}';% undulator quad
QU29={'qu' 'QU29' LQU/2 KQD}';% undulator quad
QU30={'qu' 'QU30' LQU/2 KQF}';% undulator quad
QU31={'qu' 'QU31' LQU/2 KQD}';% undulator quad
QU32={'qu' 'QU32' LQU/2 KQF}';% undulator quad
QU33={'qu' 'QU33' LQU/2 KQD}';% undulator quad
RFBU00={'mo' 'RFBU00' LRFBU []}';% undulator BPMs
RFBU01={'mo' 'RFBU01' LRFBU []}';% undulator BPMs
RFBU02={'mo' 'RFBU02' LRFBU []}';% undulator BPMs
RFBU03={'mo' 'RFBU03' LRFBU []}';% undulator BPMs
RFBU04={'mo' 'RFBU04' LRFBU []}';% undulator BPMs
RFBU05={'mo' 'RFBU05' LRFBU []}';% undulator BPMs
RFBU06={'mo' 'RFBU06' LRFBU []}';% undulator BPMs
RFBU07={'mo' 'RFBU07' LRFBU []}';% undulator BPMs
RFBU08={'mo' 'RFBU08' LRFBU []}';% undulator BPMs
RFBU09={'mo' 'RFBU09' LRFBU []}';% undulator BPMs
RFBU10={'mo' 'RFBU10' LRFBU []}';% undulator BPMs
RFBU11={'mo' 'RFBU11' LRFBU []}';% undulator BPMs
RFBU12={'mo' 'RFBU12' LRFBU []}';% undulator BPMs
RFBU13={'mo' 'RFBU13' LRFBU []}';% undulator BPMs
RFBU14={'mo' 'RFBU14' LRFBU []}';% undulator BPMs
RFBU15={'mo' 'RFBU15' LRFBU []}';% undulator BPMs
RFBU16={'mo' 'RFBU16' LRFBU []}';% undulator BPMs
RFBU17={'mo' 'RFBU17' LRFBU []}';% undulator BPMs
RFBU18={'mo' 'RFBU18' LRFBU []}';% undulator BPMs
RFBU19={'mo' 'RFBU19' LRFBU []}';% undulator BPMs
RFBU20={'mo' 'RFBU20' LRFBU []}';% undulator BPMs
RFBU21={'mo' 'RFBU21' LRFBU []}';% undulator BPMs
RFBU22={'mo' 'RFBU22' LRFBU []}';% undulator BPMs
RFBU23={'mo' 'RFBU23' LRFBU []}';% undulator BPMs
RFBU24={'mo' 'RFBU24' LRFBU []}';% undulator BPMs
RFBU25={'mo' 'RFBU25' LRFBU []}';% undulator BPMs
RFBU26={'mo' 'RFBU26' LRFBU []}';% undulator BPMs
RFBU27={'mo' 'RFBU27' LRFBU []}';% undulator BPMs
RFBU28={'mo' 'RFBU28' LRFBU []}';% undulator BPMs
RFBU29={'mo' 'RFBU29' LRFBU []}';% undulator BPMs
RFBU30={'mo' 'RFBU30' LRFBU []}';% undulator BPMs
RFBU31={'mo' 'RFBU31' LRFBU []}';% undulator BPMs
RFBU32={'mo' 'RFBU32' LRFBU []}';% undulator BPMs
RFBU33={'mo' 'RFBU33' LRFBU []}';% undulator BPMs
BFW00={'mo' 'BFW00' 0 []}';% Beam Finder Wire
BFW01={'mo' 'BFW01' 0 []}';% Beam Finder Wire
BFW02={'mo' 'BFW02' 0 []}';% Beam Finder Wire
BFW03={'mo' 'BFW03' 0 []}';% Beam Finder Wire
BFW04={'mo' 'BFW04' 0 []}';% Beam Finder Wire
BFW05={'mo' 'BFW05' 0 []}';% Beam Finder Wire
BFW06={'mo' 'BFW06' 0 []}';% Beam Finder Wire
BFW07={'mo' 'BFW07' 0 []}';% Beam Finder Wire
BFW08={'mo' 'BFW08' 0 []}';% Beam Finder Wire
BFW09={'mo' 'BFW09' 0 []}';% Beam Finder Wire
BFW10={'mo' 'BFW10' 0 []}';% Beam Finder Wire
BFW11={'mo' 'BFW11' 0 []}';% Beam Finder Wire
BFW12={'mo' 'BFW12' 0 []}';% Beam Finder Wire
BFW13={'mo' 'BFW13' 0 []}';% Beam Finder Wire
BFW14={'mo' 'BFW14' 0 []}';% Beam Finder Wire
BFW15={'mo' 'BFW15' 0 []}';% Beam Finder Wire
BFW16={'mo' 'BFW16' 0 []}';% Beam Finder Wire
BFW17={'mo' 'BFW17' 0 []}';% Beam Finder Wire
BFW18={'mo' 'BFW18' 0 []}';% Beam Finder Wire
BFW19={'mo' 'BFW19' 0 []}';% Beam Finder Wire
BFW20={'mo' 'BFW20' 0 []}';% Beam Finder Wire
BFW21={'mo' 'BFW21' 0 []}';% Beam Finder Wire
BFW22={'mo' 'BFW22' 0 []}';% Beam Finder Wire
BFW23={'mo' 'BFW23' 0 []}';% Beam Finder Wire
BFW24={'mo' 'BFW24' 0 []}';% Beam Finder Wire
BFW25={'mo' 'BFW25' 0 []}';% Beam Finder Wire
BFW26={'mo' 'BFW26' 0 []}';% Beam Finder Wire
BFW27={'mo' 'BFW27' 0 []}';% Beam Finder Wire
BFW28={'mo' 'BFW28' 0 []}';% Beam Finder Wire
BFW29={'mo' 'BFW29' 0 []}';% Beam Finder Wire
BFW30={'mo' 'BFW30' 0 []}';% Beam Finder Wire
BFW31={'mo' 'BFW31' 0 []}';% Beam Finder Wire
BFW32={'mo' 'BFW32' 0 []}';% Beam Finder Wire
BFW33={'mo' 'BFW33' 0 []}';% Beam Finder Wire
XCU01={'mo' 'XCU01' 0 []}';% undulator X-steering coil in quad
XCU02={'mo' 'XCU02' 0 []}';% undulator X-steering coil in quad
XCU03={'mo' 'XCU03' 0 []}';% undulator X-steering coil in quad
XCU04={'mo' 'XCU04' 0 []}';% undulator X-steering coil in quad
XCU05={'mo' 'XCU05' 0 []}';% undulator X-steering coil in quad
XCU06={'mo' 'XCU06' 0 []}';% undulator X-steering coil in quad
XCU07={'mo' 'XCU07' 0 []}';% undulator X-steering coil in quad
XCU08={'mo' 'XCU08' 0 []}';% undulator X-steering coil in quad
XCU09={'mo' 'XCU09' 0 []}';% undulator X-steering coil in quad
XCU10={'mo' 'XCU10' 0 []}';% undulator X-steering coil in quad
XCU11={'mo' 'XCU11' 0 []}';% undulator X-steering coil in quad
XCU12={'mo' 'XCU12' 0 []}';% undulator X-steering coil in quad
XCU13={'mo' 'XCU13' 0 []}';% undulator X-steering coil in quad
XCU14={'mo' 'XCU14' 0 []}';% undulator X-steering coil in quad
XCU15={'mo' 'XCU15' 0 []}';% undulator X-steering coil in quad
XCU16={'mo' 'XCU16' 0 []}';% undulator X-steering coil in quad
XCU17={'mo' 'XCU17' 0 []}';% undulator X-steering coil in quad
XCU18={'mo' 'XCU18' 0 []}';% undulator X-steering coil in quad
XCU19={'mo' 'XCU19' 0 []}';% undulator X-steering coil in quad
XCU20={'mo' 'XCU20' 0 []}';% undulator X-steering coil in quad
XCU21={'mo' 'XCU21' 0 []}';% undulator X-steering coil in quad
XCU22={'mo' 'XCU22' 0 []}';% undulator X-steering coil in quad
XCU23={'mo' 'XCU23' 0 []}';% undulator X-steering coil in quad
XCU24={'mo' 'XCU24' 0 []}';% undulator X-steering coil in quad
XCU25={'mo' 'XCU25' 0 []}';% undulator X-steering coil in quad
XCU26={'mo' 'XCU26' 0 []}';% undulator X-steering coil in quad
XCU27={'mo' 'XCU27' 0 []}';% undulator X-steering coil in quad
XCU28={'mo' 'XCU28' 0 []}';% undulator X-steering coil in quad
XCU29={'mo' 'XCU29' 0 []}';% undulator X-steering coil in quad
XCU30={'mo' 'XCU30' 0 []}';% undulator X-steering coil in quad
XCU31={'mo' 'XCU31' 0 []}';% undulator X-steering coil in quad
XCU32={'mo' 'XCU32' 0 []}';% undulator X-steering coil in quad
XCU33={'mo' 'XCU33' 0 []}';% undulator X-steering coil in quad
YCU01={'mo' 'YCU01' 0 []}';% undulator Y-steering coil in quad
YCU02={'mo' 'YCU02' 0 []}';% undulator Y-steering coil in quad
YCU03={'mo' 'YCU03' 0 []}';% undulator Y-steering coil in quad
YCU04={'mo' 'YCU04' 0 []}';% undulator Y-steering coil in quad
YCU05={'mo' 'YCU05' 0 []}';% undulator Y-steering coil in quad
YCU06={'mo' 'YCU06' 0 []}';% undulator Y-steering coil in quad
YCU07={'mo' 'YCU07' 0 []}';% undulator Y-steering coil in quad
YCU08={'mo' 'YCU08' 0 []}';% undulator Y-steering coil in quad
YCU09={'mo' 'YCU09' 0 []}';% undulator Y-steering coil in quad
YCU10={'mo' 'YCU10' 0 []}';% undulator Y-steering coil in quad
YCU11={'mo' 'YCU11' 0 []}';% undulator Y-steering coil in quad
YCU12={'mo' 'YCU12' 0 []}';% undulator Y-steering coil in quad
YCU13={'mo' 'YCU13' 0 []}';% undulator Y-steering coil in quad
YCU14={'mo' 'YCU14' 0 []}';% undulator Y-steering coil in quad
YCU15={'mo' 'YCU15' 0 []}';% undulator Y-steering coil in quad
YCU16={'mo' 'YCU16' 0 []}';% undulator Y-steering coil in quad
YCU17={'mo' 'YCU17' 0 []}';% undulator Y-steering coil in quad
YCU18={'mo' 'YCU18' 0 []}';% undulator Y-steering coil in quad
YCU19={'mo' 'YCU19' 0 []}';% undulator Y-steering coil in quad
YCU20={'mo' 'YCU20' 0 []}';% undulator Y-steering coil in quad
YCU21={'mo' 'YCU21' 0 []}';% undulator Y-steering coil in quad
YCU22={'mo' 'YCU22' 0 []}';% undulator Y-steering coil in quad
YCU23={'mo' 'YCU23' 0 []}';% undulator Y-steering coil in quad
YCU24={'mo' 'YCU24' 0 []}';% undulator Y-steering coil in quad
YCU25={'mo' 'YCU25' 0 []}';% undulator Y-steering coil in quad
YCU26={'mo' 'YCU26' 0 []}';% undulator Y-steering coil in quad
YCU27={'mo' 'YCU27' 0 []}';% undulator Y-steering coil in quad
YCU28={'mo' 'YCU28' 0 []}';% undulator Y-steering coil in quad
YCU29={'mo' 'YCU29' 0 []}';% undulator Y-steering coil in quad
YCU30={'mo' 'YCU30' 0 []}';% undulator Y-steering coil in quad
YCU31={'mo' 'YCU31' 0 []}';% undulator Y-steering coil in quad
YCU32={'mo' 'YCU32' 0 []}';% undulator Y-steering coil in quad
YCU33={'mo' 'YCU33' 0 []}';% undulator Y-steering coil in quad
DF0={'dr' '' LQU-0.04241 []}';% No quad + correction to maintain symmetry
DB0={'dr' '' 0.5653-LBR1-LQU-LBR3-LRFBU []}';% sets UNDSTOP to Jim Welch's Z' value
DB1={'dr' '' LBR1 []}';% drift from segment to quad
DB3={'dr' '' LBR3 []}';% drift from quad to BPM
DB4={'dr' '' LBR4 []}';% Radiation monitor to segment drift
DBWM={'dr' '' LBRWM []}';% BFW to radiation monitor drift
DBRS={'dr' '' LBRS []}';% standard short undulator drift from BPM to segment
DBRL={'dr' '' LBRL []}';% standard long undulator drift from BPM to segment
DT={'dr' '' LUE []}';% undulator segment small terminations modeled as drift
MUQ={'mo' 'MUQ' 0 []}';% undulator quad center marker for beta matching in all quads
DBUVV1={'dr' '' LBUVV1 []}';% drift before inline vaccum valve
DBUVV2={'dr' '' LBUVV2 []}';% drift after inline vaccum valve
VVU10={'mo' 'VVU10' 0 []}';% inline vacuum valve in undulator chamber before girder 10
VVU25={'mo' 'VVU25' 0 []}';% inline vacuum valve in undulator chamber before girder 25
DBRL10=[DBUVV1,VVU10,DBUVV2];% long undulator drift from BPM to segment with inline value
DBRL25=[DBUVV1,VVU25,DBUVV2];% long undulator drift from BPM to segment with inline value
% undulator segment modeled as R-matrix to include vertical natural focusing over all but its edge terminations:
USEGH={'un' 'USEGH' LUNDH [KQUND LAMU]}';
US01=USEGH;US01{2}='US01';
US02=USEGH;US02{2}='US02';
US03=USEGH;US03{2}='US03';
US04=USEGH;US04{2}='US04';
US05=USEGH;US05{2}='US05';
US06=USEGH;US06{2}='US06';
US07=USEGH;US07{2}='US07';
US08=USEGH;US08{2}='US08';
US09=USEGH;US09{2}='US09';
US10=USEGH;US10{2}='US10';
US11=USEGH;US11{2}='US11';
US12=USEGH;US12{2}='US12';
US13=USEGH;US13{2}='US13';
US14=USEGH;US14{2}='US14';
US15=USEGH;US15{2}='US15';
US16=USEGH;US16{2}='US16';
US17=USEGH;US17{2}='US17';
US18=USEGH;US18{2}='US18';
US19=USEGH;US19{2}='US19';
US20=USEGH;US20{2}='US20';
US21=USEGH;US21{2}='US21';
US22=USEGH;US22{2}='US22';
US23=USEGH;US23{2}='US23';
US24=USEGH;US24{2}='US24';
US25=USEGH;US25{2}='US25';
US26=USEGH;US26{2}='US26';
US27=USEGH;US27{2}='US27';
US28=USEGH;US28{2}='US28';
US29=USEGH;US29{2}='US29';
US30=USEGH;US30{2}='US30';
US31=USEGH;US31{2}='US31';
US32=USEGH;US32{2}='US32';
US33=USEGH;US33{2}='US33';





USTBK01=[DT,US01,US01,DT];
USTBK02=[DT,US02,US02,DT];
USTBK03=[DT,US03,US03,DT];
USTBK04=[DT,US04,US04,DT];
USTBK05=[DT,US05,US05,DT];
USTBK06=[DT,US06,US06,DT];
USTBK07=[DT,US07,US07,DT];
USTBK08=[DT,US08,US08,DT];
USTBK09=[DT,US09,US09,DT];
USTBK10=[DT,US10,US10,DT];
USTBK11=[DT,US11,US11,DT];
USTBK12=[DT,US12,US12,DT];
USTBK13=[DT,US13,US13,DT];
USTBK14=[DT,US14,US14,DT];
USTBK15=[DT,US15,US15,DT];
USTBK16=[DT,US16,US16,DT];
USTBK17=[DT,US17,US17,DT];
USTBK18=[DT,US18,US18,DT];
USTBK19=[DT,US19,US19,DT];
USTBK20=[DT,US20,US20,DT];
USTBK21=[DT,US21,US21,DT];
USTBK22=[DT,US22,US22,DT];
USTBK23=[DT,US23,US23,DT];
USTBK24=[DT,US24,US24,DT];
USTBK25=[DT,US25,US25,DT];
USTBK26=[DT,US26,US26,DT];
USTBK27=[DT,US27,US27,DT];
USTBK28=[DT,US28,US28,DT];
USTBK29=[DT,US29,US29,DT];
USTBK30=[DT,US30,US30,DT];
USTBK31=[DT,US31,US31,DT];
USTBK32=[DT,US32,US32,DT];
USTBK33=[DT,US33,US33,DT];
QBLK01=[QU01,XCU01,MUQ,YCU01,QU01];
QBLK02=[QU02,XCU02,MUQ,YCU02,QU02];
QBLK03=[QU03,XCU03,MUQ,YCU03,QU03];
QBLK04=[QU04,XCU04,MUQ,YCU04,QU04];
QBLK05=[QU05,XCU05,MUQ,YCU05,QU05];
QBLK06=[QU06,XCU06,MUQ,YCU06,QU06];
QBLK07=[QU07,XCU07,MUQ,YCU07,QU07];
QBLK08=[QU08,XCU08,MUQ,YCU08,QU08];
QBLK09=[QU09,XCU09,MUQ,YCU09,QU09];
QBLK10=[QU10,XCU10,MUQ,YCU10,QU10];
QBLK11=[QU11,XCU11,MUQ,YCU11,QU11];
QBLK12=[QU12,XCU12,MUQ,YCU12,QU12];
QBLK13=[QU13,XCU13,MUQ,YCU13,QU13];
QBLK14=[QU14,XCU14,MUQ,YCU14,QU14];
QBLK15=[QU15,XCU15,MUQ,YCU15,QU15];
QBLK16=[QU16,XCU16,MUQ,YCU16,QU16];
QBLK17=[QU17,XCU17,MUQ,YCU17,QU17];
QBLK18=[QU18,XCU18,MUQ,YCU18,QU18];
QBLK19=[QU19,XCU19,MUQ,YCU19,QU19];
QBLK20=[QU20,XCU20,MUQ,YCU20,QU20];
QBLK21=[QU21,XCU21,MUQ,YCU21,QU21];
QBLK22=[QU22,XCU22,MUQ,YCU22,QU22];
QBLK23=[QU23,XCU23,MUQ,YCU23,QU23];
QBLK24=[QU24,XCU24,MUQ,YCU24,QU24];
QBLK25=[QU25,XCU25,MUQ,YCU25,QU25];
QBLK26=[QU26,XCU26,MUQ,YCU26,QU26];
QBLK27=[QU27,XCU27,MUQ,YCU27,QU27];
QBLK28=[QU28,XCU28,MUQ,YCU28,QU28];
QBLK29=[QU29,XCU29,MUQ,YCU29,QU29];
QBLK30=[QU30,XCU30,MUQ,YCU30,QU30];
QBLK31=[QU31,XCU31,MUQ,YCU31,QU31];
QBLK32=[QU32,XCU32,MUQ,YCU32,QU32];
QBLK33=[QU33,XCU33,MUQ,YCU33,QU33];
GIRD01=[BFW01,DBWM,DB4,USTBK01,DB1,QBLK01,DB3,RFBU01];
GIRD02=[BFW02,DBWM,DB4,USTBK02,DB1,QBLK02,DB3,RFBU02];
GIRD03=[BFW03,DBWM,DB4,USTBK03,DB1,QBLK03,DB3,RFBU03];
GIRD04=[BFW04,DBWM,DB4,USTBK04,DB1,QBLK04,DB3,RFBU04];
GIRD05=[BFW05,DBWM,DB4,USTBK05,DB1,QBLK05,DB3,RFBU05];
GIRD06=[BFW06,DBWM,DB4,USTBK06,DB1,QBLK06,DB3,RFBU06];
GIRD07=[BFW07,DBWM,DB4,USTBK07,DB1,QBLK07,DB3,RFBU07];
GIRD08=[BFW08,DBWM,DB4,USTBK08,DB1,QBLK08,DB3,RFBU08];
GIRD09=[BFW09,DBWM,DB4,USTBK09,DB1,QBLK09,DB3,RFBU09];
GIRD10=[BFW10,DBWM,DB4,USTBK10,DB1,QBLK10,DB3,RFBU10];
GIRD11=[BFW11,DBWM,DB4,USTBK11,DB1,QBLK11,DB3,RFBU11];
GIRD12=[BFW12,DBWM,DB4,USTBK12,DB1,QBLK12,DB3,RFBU12];
GIRD13=[BFW13,DBWM,DB4,USTBK13,DB1,QBLK13,DB3,RFBU13];
GIRD14=[BFW14,DBWM,DB4,USTBK14,DB1,QBLK14,DB3,RFBU14];
GIRD15=[BFW15,DBWM,DB4,USTBK15,DB1,QBLK15,DB3,RFBU15];
GIRD16=[BFW16,DBWM,DB4,USTBK16,DB1,QBLK16,DB3,RFBU16];
GIRD17=[BFW17,DBWM,DB4,USTBK17,DB1,QBLK17,DB3,RFBU17];
GIRD18=[BFW18,DBWM,DB4,USTBK18,DB1,QBLK18,DB3,RFBU18];
GIRD19=[BFW19,DBWM,DB4,USTBK19,DB1,QBLK19,DB3,RFBU19];
GIRD20=[BFW20,DBWM,DB4,USTBK20,DB1,QBLK20,DB3,RFBU20];
GIRD21=[BFW21,DBWM,DB4,USTBK21,DB1,QBLK21,DB3,RFBU21];
GIRD22=[BFW22,DBWM,DB4,USTBK22,DB1,QBLK22,DB3,RFBU22];
GIRD23=[BFW23,DBWM,DB4,USTBK23,DB1,QBLK23,DB3,RFBU23];
GIRD24=[BFW24,DBWM,DB4,USTBK24,DB1,QBLK24,DB3,RFBU24];
GIRD25=[BFW25,DBWM,DB4,USTBK25,DB1,QBLK25,DB3,RFBU25];
GIRD26=[BFW26,DBWM,DB4,USTBK26,DB1,QBLK26,DB3,RFBU26];
GIRD27=[BFW27,DBWM,DB4,USTBK27,DB1,QBLK27,DB3,RFBU27];
GIRD28=[BFW28,DBWM,DB4,USTBK28,DB1,QBLK28,DB3,RFBU28];
GIRD29=[BFW29,DBWM,DB4,USTBK29,DB1,QBLK29,DB3,RFBU29];
GIRD30=[BFW30,DBWM,DB4,USTBK30,DB1,QBLK30,DB3,RFBU30];
GIRD31=[BFW31,DBWM,DB4,USTBK31,DB1,QBLK31,DB3,RFBU31];
GIRD32=[BFW32,DBWM,DB4,USTBK32,DB1,QBLK32,DB3,RFBU32];
GIRD33=[BFW33,DBWM,DB4,USTBK33,DB1,QBLK33,DB3,RFBU33];
UNDCL=[DBRS,  GIRD01,DBRS,GIRD02,DBRS,GIRD03, DBRL,  GIRD04,DBRS,GIRD05,DBRS,GIRD06, DBRL,  GIRD07,DBRS,GIRD08,DBRS,GIRD09, DBRL10,GIRD10,DBRS,GIRD11,DBRS,GIRD12, DBRL,  GIRD13,DBRS,GIRD14,DBRS,GIRD15, DBRL,  GIRD16,DBRS,GIRD17,DBRS,GIRD18, DBRL,  GIRD19,DBRS,GIRD20,DBRS,GIRD21, DBRL,  GIRD22,DBRS,GIRD23,DBRS,GIRD24, DBRL25,GIRD25,DBRS,GIRD26,DBRS,GIRD27, DBRL,  GIRD28,DBRS,GIRD29,DBRS,GIRD30, DBRL,  GIRD31,DBRS,GIRD32,DBRS,GIRD33];
UND=[UNDSTART,DF0,DB3,RFBU00,UNDCL,DB0,UNDTERM];
% Undulator exit section:
% ----------------------
DUE1A={'dr' '' 10.720575-8.930036 []}';
DUE1D={'dr' '' 8.930036+0.411634 []}';
DUE1B={'dr' '' 0.5-0.411634+0.038094 []}';
DUE1C={'dr' '' 0.455460-0.038094 []}';
DUE2A={'dr' '' 0.455460+0.139704+0.129836 []}';
DUE2B={'dr' '' 10.609500-0.17858 []}';
DUE2C={'dr' '' 0.455460+0.050796+0.048744 []}';
DUE3A={'dr' '' 0.455460-0.139956 []}';
DUE3B={'dr' '' 0.144120 []}';
DUE3C={'dr' '' 5.0429295 []}';%11.919836
DUE3D={'dr' '' 6.8769065 []}';
DUE4={'dr' '' 0.5 []}';
DUE5A={'dr' '' 1.020814-0.0762-0.009011 []}';
DUE5C={'dr' '' 0.33362-0.00362 []}';
DUE5D={'dr' '' 0.145566+0.0762+0.012631 []}';
KQUE1  =  0.104402672527    ;% [<beta>=30 m]
KQUE2  = -0.034721612961    ;% [<beta>=30 m]
QUE1={'qu' 'QUE1' LQD/2 KQUE1}';
QUE2={'qu' 'QUE2' LQD/2 KQUE2}';
UEBEG={'mo' 'UEBEG' 0 []}';
TRUE1={'mo' 'TRUE1' 0 []}';%Be foil inserter (THz)
UEEND={'mo' 'UEEND' 0 []}';
% Dump:
% ----
KQDMP  = -0.112488747732   ;% [<beta>=30 m]
QDMP1={'qu' 'QDMP1' LQD/2 KQDMP}';
QDMP2={'qu' 'QDMP2' LQD/2 KQDMP}';
DDMPV  = -0.73352263654;
LDS    = 0.300-0.026027*2;
LDSC   = 0.499225-0.026027+0.1124278-0.008032;
DDMP1={'dr' '' 0.30 []}';
D2D={'dr' '' 0.75 []}';
DDMP3={'dr' '' 0.75 []}';
DSB0A={'dr' '' 0.111120 []}';
DSB0B={'dr' '' 0.21491 []}';
DSB0C={'dr' '' 0.235534+0.031167 []}';
DSB0D={'dr' '' 0.278039-0.031167 []}';
DS={'dr' '' LDS []}';
DSC={'dr' '' LDSC []}';
DD1A={'dr' '' 2.6512616 []}';
DD1B={'dr' '' 6.8896877-LQD/2-DDMPV+0.017094407653 []}';
DD1F={'dr' '' 0.266645-0.017094407653 []}';
DD1C={'dr' '' 0.4+0.2920945-0.266645-2*0.0381452 []}';
DD1D={'dr' '' 0.25-0.0079372 []}';
DD1E={'dr' '' 0.25+0.0079372 []}';
DD2A={'dr' '' 0.4+0.0634916+0.0115084 []}';
DD2B={'dr' '' 8.425460-LQD/2+DDMPV-0.15-0.0634916-0.049684-0.0115084 []}';
DD3A={'dr' '' 0.3+0.049684+0.001583 []}';
DD3B={'dr' '' 0.3-0.001583-0.1447026 []}';
DD3C={'dr' '' 2.580+0.1447026-0.2441932 []}';
DD3D={'dr' '' 0.2441932 []}';
DD3E={'dr' '' 0.2857474-0.2441932 []}';
DPM1A={'dr' '' 6.851618-0.694995 []}';
DPM1B={'dr' '' 1.820699-LSTPR/2+0.163401-0.1174 []}';
DST0={'dr' '' 0.1112 []}';
DMUSPL={'dr' '' 3*0.3048+2.893089-LSTPR-3.288089+0.1174-0.1112-0.1174 []}';
DST1={'dr' '' 0.1112 []}';
DPM1C={'dr' '' 4.7074-LSTPR/2+3.4214+0.1174-0.1112 []}';
DPM1D={'dr' '' 0.50+0.112-0.296712+0.008013 []}';
DPM1={'dr' '' 0.30/cos(ABPM) []}';
DPM2={'dr' '' 0.30/cos(2*ABPM) []}';
DSFT={'dr' '' 11.934976 []}';
DPM2E={'dr' '' 0.076213 []}';
DMPEND={'mo' 'DMPEND' 0 []}';
OTRDMP={'mo' 'OTRDMP' 0 []}';%Dump screen
LPCPM  = 0.076;
PCPM1L={'dr' 'PCPM1L' LPCPM/cos(3*ABDM0) []}';
BTM1L={'mo' 'BTM1L' 0 []}';% Burn-Through-Monitor behind PCPM1L
PCPM2L={'dr' 'PCPM2L' LPCPM/cos(3*ABDM0) []}';
BTM2L={'mo' 'BTM2L' 0 []}';% Burn-Through-Monitor behind PCPM2L
% Safety Dump:
% -----------
SFTBEG={'mo' 'SFTBEG' 0 []}';% start of safety dump (entrance of turned-off BYD1)
PCPM0={'dr' 'PCPM0' LPCPM []}';% added Sep. 13, 2007 per J. Langton
PCPM1={'dr' 'PCPM1' LPCPM []}';
PCPM2={'dr' 'PCPM2' LPCPM []}';
BTM0={'mo' 'BTM0' 0 []}';% Burn-Through-Monitor behind PCPM1L
BTM1={'mo' 'BTM1' 0 []}';% Burn-Through-Monitor behind PCPM1L
BTM2={'mo' 'BTM2' 0 []}';% Burn-Through-Monitor behind PCPM1L
DYD1={'dr' '' LBDM*cos(1*ABDM0/2) []}';
DYD2={'dr' '' LBDM*cos(3*ABDM0/2) []}';
DYD3={'dr' '' LBDM*cos(5*ABDM0/2) []}';
DSS1={'dr' '' LDS*cos(1*ABDM0) []}';
DSS2={'dr' '' LDS*cos(2*ABDM0) []}';
DSCS1={'dr' '' LDSC*cos(3*ABDM0)/2+0.188398+0.004 []}';
DSCS2={'dr' '' LDSC*cos(3*ABDM0)/2-0.188398-0.004 []}';
BTMSFT={'mo' 'BTMSFT' 0 []}';% Burn-Through-Monitor behind saftey-dump
% ==============================================================================
% DRIFTs
% ------------------------------------------------------------------------------
% L1/2/3 FODO cells
D9={'dr' '' DLWL9 []}';
D10={'dr' '' DLWL10 []}';
DAQ1={'dr' '' 0.0342 []}';
DAQ2={'dr' '' 0.027 []}';
% injector geometry
LGGUN   = 7.51*0.3048;
LGL0    = 2*3.0441+1.0;
LGBEND  = 0.95 + 2*0.3048     ;% add 12" to either side of QB for more room (22JAN04 - PE)
LGEMIT  = 9.000328707307;
LGMATCH = 1.5134597681;
DGGUN={'dr' '' LGGUN []}';
DGL0={'dr' '' LGL0 []}';
% L0
LOADLOCK={'dr' '' LGGUN-1.42 []}';
DL00={'dr' '' -LOADLOCK{3} []}';%from cathode back to u/s end of loadlock
DL01A={'dr' '' 0.19601-LSOL1/2 []}';
DL01A1={'dr' '' 0.07851 []}';
DL01A2={'dr' '' 0.11609 []}';
DL01A3={'dr' '' 0.10461 []}';
DL01A4={'dr' '' 0.0170+0.0014 []}';
DL01A5={'dr' '' 0.0132-0.00223 []}';
DL01B={'dr' '' 0.0825 []}';
DL01C={'dr' '' 0.1340-0.00353-0.003175 []}';
DL01D={'dr' '' 0.1008464-0.0155757 []}';
DL01H={'dr' '' 0.0581886 []}';
DL01E={'dr' '' 0.2286-DXG0{3}-0.00536+0.0155757 []}';
DL01F={'dr' '' 0.1353+0.00708 []}';
DL01F2={'dr' '' 0.0277+0.00167 []}';
DL01G={'dr' '' 0.0740-0.00341 []}';
DL02A1={'dr' '' 0.066356+0.0021436-0.008205 []}';
DL02A2={'dr' '' 0.104580+0.008205 []}';
DL02A3={'dr' '' 0.098776-LQX/2+0.028834 []}';
DL02B1={'dr' '' 0.169672-LQX/2-0.028834+0.007646 []}';
DL02B2={'dr' '' 0.185928-LQX/2-0.007646+0.001610 []}';
DL02C={'dr' '' 0.121498-LQX/2-0.001610 []}';
% Heater-Chicane:
% LSRHTR_ON := 1E-12          set to 1E-12 for laser heater bends & undulator OFF and 1.0 for ON (nominal)
LSRHTR_ON = 1              ;%set to 1E-12 for laser heater bends & undulator OFF and 1.0 for ON (nominal)
BRHOH = CB*EI              ;%beam rigidity at heater (kG-m)
BBH1  = -4.751481741801*LSRHTR_ON    ;%heater-chicane bend field for 35-mm etaX_pk (kG)
RBH1  = BRHOH/BBH1         ;%heater-chicane bend radius (m)
ABH1  = asin(LBH/RBH1)     ;%heater-chicane bend angle (rad)
ABH1S = asin((LBH/2)/RBH1) ;%"short" half heater-chicane bend angle (rad)
LBH1S = RBH1*ABH1S         ;%"short" half heater-chicane bend path length (m)
ABH1L = ABH1-ABH1S         ;%"long" half heater-chicane bend angle (rad)
LBH1L = RBH1*ABH1L         ;%"long" half heater-chicane bend path length (m)
DH00={'dr' '' 0.13453045-DLBH/2 []}';
DH01={'dr' '' (0.155-DLBH)/cos(ABH1) []}';
DH02A={'dr' '' 0.06717020-DLBH/2 []}';
DH03A={'dr' '' 0.09290825 []}';
DH03B={'dr' '' 0.08401830 []}';
DH02B={'dr' '' 0.09503020-DLBH/2 []}';
DH06={'dr' '' 0.13010070-DLBH/2 []}';
HTRUND={'mo' 'HTRUND' 0 []}';
BXH1A={'be' 'BXH1' LBH1S [+ABH1S GBH/2 0 0 0.400 0 0]}';
BXH1B={'be' 'BXH1' LBH1L [+ABH1L GBH/2 0 +ABH1 0 0.400 0]}';
BXH2A={'be' 'BXH2' LBH1L [-ABH1L GBH/2 -ABH1 0 0.400 0 0]}';
BXH2B={'be' 'BXH2' LBH1S [-ABH1S GBH/2 0 0 0 0.400 0]}';
BXH3A={'be' 'BXH3' LBH1S [-ABH1S GBH/2 0 0 0.400 0 0]}';
BXH3B={'be' 'BXH3' LBH1L [-ABH1L GBH/2 0 -ABH1 0 0.400 0]}';
BXH4A={'be' 'BXH4' LBH1L [+ABH1L GBH/2 +ABH1 0 0.400 0 0]}';
BXH4B={'be' 'BXH4' LBH1S [+ABH1S GBH/2 0 0 0 0.400 0]}';
% Laser-Heater Undulator Model:
LAM   = 0.054                            ;% laser-heater undulator period [m]
LAMR  = 758E-9                           ;% heater laser wavelength [m]
GAMI  = EI/MC2                           ;% Lorentz energy factor in laser-heater undulator [ ]
K_UND = LSRHTR_ON*sqrt(2*(LAMR*2*GAMI^2/LAM - 1))  ;% undulator K for laser heater und.
LHUN  = 0.506263                         ;% length of laser-heater undulator
KQLH  = (K_UND*2*pi/LAM/sqrt(2)/GAMI)^2  ;% natural undulator focusing "k" in y-plane [m^-2]

LHBEG={'mo' 'LHBEG' 0 []}';
LHEND={'mo' 'LHEND' 0 []}';
% laser-heater undulator modeled as R-matrix to include vertical natural focusing:
LH_UND={'un' 'LH_UND' LHUN/2 [KQLH LAM]}';
% RM(5,6) =  Lhun/2/(gami^2)*(1+(K_und^2)/2)





% VALUE, LH_UND[RM(5,6)],Lhun/2/(gami^2)*(1+(K_und^2)/2)
% DL1
LWS01_03 =  3.827458            ;% distance from WS01 to WS03 wire centers [m] (changed 06MAY05 -PE)
BMIN0 = LWS01_03/sqrt(3)/2      ;% betaX=betaY at WS02 where waist is located (12NOV03 -PE)

MRK0={'mo' 'MRK0' 0 []}';
DE00={'dr' '' 0.024994 []}';
DE00A={'dr' '' 0.070613-LQX/2 []}';
DE01A={'dr' '' 0.130373-LQX/2 []}';
DE01B={'dr' '' 0.176359-LQX/2 []}';
DE01C={'dr' '' 0.094781 []}';
DE02={'dr' '' 0.0897395-LQX/2 []}';
DE03A={'dr' '' 0.16832-LQX/2 []}';
DE03B={'dr' '' 0.047581 []}';
DE03C={'dr' '' 0.190499-LQX/2 []}';
DE04={'dr' '' 0.197688-LQX/2 []}';
DE05={'dr' '' 0.151968 []}';
DE05A={'dr' '' DE05{3}/2 []}';
DE05C={'dr' '' 0.104470 []}';
DE06B={'dr' '' 0.2478024 []}';
DE06A={'dr' '' LWS01_03/2-DE05{3}-DE05C{3}-DE06B{3} []}';
DE06D={'dr' '' 0.1638307 []}';
DE06E={'dr' '' LWS01_03/2-DE05{3}-DE06D{3} []}';
DE07={'dr' '' 0.2045007-LQX/2+0.305E-3 []}';
DE08={'dr' '' 0.2318721-LQX/2-0.03 []}';
DE08A={'dr' '' 0.153330+0.03 []}';
DE08B={'dr' '' 0.170620-LQX/2 []}';
DE09={'dr' '' 0.27745-LQX/2 []}';
DB00A={'dr' '' 0.399700 []}';
DB00B={'dr' '' 0.161 []}';
DB00C={'dr' '' 0.219100-LQE/2 []}';
DB00D={'dr' '' 0.342-LQE/2 []}';
DB00E={'dr' '' 0.4378 []}';
DM00={'dr' '' 0.203400-ZOFFINJ+0.03 []}';% move entire injector ~12 mm dntr. (Nov. 17, 2004 - PE)
DM00A={'dr' '' 0.224683-LQX/2-0.03 []}';
DM01={'dr' '' 0.142367-LQX/2 []}';
DM01A={'dr' '' 0.262800-LQX/2 []}';
DM02={'dr' '' 0.194200-LQX/2 []}';
DM02A={'dr' '' 0.157448 []}';
% L1
DAQA1={'dr' '' 0.033450+DZ_QA11 []}';
DAQA2={'dr' '' 0.033450-DZ_QA11 []}';
DAQA3={'dr' '' 0.033450 []}';
DAQA4={'dr' '' 0.033450 []}';
% BC1
LWW1  = 1.656196                                     ;% WS11-12 drift length and therefore ~ beam size
BMIN1 = LWW1/sqrt(3)                                 ;% betaX,Y at WS12
DL1XA={'dr' '' 0.093369 []}';
DL1XB={'dr' '' 0.2 []}';
DM10A={'dr' '' 0.227400-0.022322 []}';
DM10C={'dr' '' 0.122322+DZ_Q21201 []}';
DM10X={'dr' '' 0.083617-DZ_Q21201 []}';
DM11={'dr' '' 0.272500+0.006383 []}';
DM12={'dr' '' 0.127801 []}';
DBQ1={'dr' '' (0.400381-LB1/2-LQC/2)/cos(AB11) []}';
D11O={'dr' '' LD11O-(DBQ1{3}+LQC)-2E-7 []}';
D11OA={'dr' '' LD11OA []}';
D11OB={'dr' '' LD11OB-(DBQ1{3}+LQC)-2E-7 []}';
DDG0={'dr' '' 0.1698-0.084915+0.0508-0.0045 []}';% additional drift in BC2 center prior to diag. package
DDGA={'dr' '' 0.084915+0.0508-0.0045 []}';% additional drift in BC2 center prior to diag. package
DDG1={'dr' '' 0.2891-0.04046 []}';% BC1 and BC2 diag. package drifts (BX*2B to BPM)
DDG2={'dr' '' 0.1240+0.04046 []}';% BC1 and BC2 diag. package drifts (BPM to CE)
DDG3={'dr' '' 0.1460+0.036606 []}';% BC1 and BC2 diag. package drifts (CE to OTR)
DDG4={'dr' '' 0.2711-0.036606 []}';% BC1 and BC2 diag. package drifts (OTR to BX*3A)
DM13A={'dr' '' 0.323450/2 []}';
DM13B={'dr' '' 0.323450/2 []}';
DM14A={'dr' '' 0.25-0.07615 []}';
DM14B={'dr' '' 0.15638875-0.0254+0.07615 []}';
DM14C={'dr' '' 0.15638875+0.0254 []}';
DM15A={'dr' '' 0.252872-0.1524 []}';
DM15B={'dr' '' 0.2836740-0.0826 []}';
DM15C={'dr' '' 0.1524+0.0826 []}';
DWW1A={'dr' '' LWW1 []}';
DWW1B={'dr' '' 0.295 []}';
DWW1C1={'dr' '' 0.812030-0.295-0.1017 []}';
DWW1C2={'dr' '' LWW1-1.427096+0.1017-0.0142-0.014199 []}';
DWW1D={'dr' '' 0.346099 []}';
DWW1E={'dr' '' 0.297366 []}';
DM16={'dr' '' 0.25+DZ_Q21301 []}';
DM17A={'dr' '' 0.2658341-DZ_Q21301 []}';
DM16A={'dr' '' 0.0 []}';
DM16B={'dr' '' 0.0 []}';
DM17B={'dr' '' 0.4008829 []}';
DM17C={'dr' '' 0.385417+DZ_QM14 []}';
DM18A={'dr' '' 0.228300-DZ_QM14 []}';
DM18B={'dr' '' 0.228200+DZ_QM15 []}';
DM19={'dr' '' 0.099400-DZ_QM15 []}';
% L2 and L3
DAQ3={'dr' '' 0.3533 []}';
DAQ4={'dr' '' 2.5527 []}';
DAQ5={'dr' '' 2.841-0.3048-1.2192 []}';
DAQ6={'dr' '' 0.2373 []}';
DAQ6A={'dr' '' 0.2373+0.3048+1.2192 []}';
DAQ7={'dr' '' 0.2748 []}';
DAQ8={'dr' '' 2.6312 []}';
DAQ8A={'dr' '' 0.5+0.003200 []}';
DAQ8B={'dr' '' 2.1312-0.003200 []}';
DAQ12={'dr' '' 0.2286 []}';
DAQ13={'dr' '' 0.0231 []}';
DAQ14={'dr' '' 0.2130 []}';
DAQ15={'dr' '' 0.0087 []}';
DAQ16={'dr' '' 0.2274 []}';
DAQ17={'dr' '' 3.9709 []}';
D255A={'dr' '' 0.06621-0.001510 []}';
D255B={'dr' '' 0.11184+0.001510 []}';
D255C={'dr' '' 0.17805-0.275500+0.25 []}';
D255D={'dr' '' 0.03420+0.275500 []}';
D256A={'dr' '' 2.350-1.1919-0.559100 []}';
D256B={'dr' '' 0.559100 []}';
D256E={'dr' '' 1.019800-0.540500 []}';
D256C={'dr' '' 0.540500-0.40505 []}';
D256D={'dr' '' 0.21115 []}';
% BC2
DM21Z={'dr' '' 0.0828006-0.027 []}';
DM21A={'dr' '' 0.3199994 []}';
DM21H={'dr' '' 0.193 []}';
DM21B={'dr' '' 0.6340002 []}';
DM21C={'dr' '' 0.3202404 []}';
DM21D={'dr' '' 0.139536 []}';
DM21E={'dr' '' 0.1996034-0.0045 []}';
DM20={'dr' '' 0.034200 []}';
DBQ2A={'dr' '' LDO1 []}';
D21OA={'dr' '' LDO2 []}';
D21I={'dr' '' LD21I/2 []}';
D21OB={'dr' '' LDO3 []}';
DBQ2B={'dr' '' LDO4 []}';
D21W={'dr' '' 0.311000-0.0045 []}';
D21X={'dr' '' 0.208700 []}';
D21Y={'dr' '' 0.114235 []}';
DM23B={'dr' '' 0.050405 []}';
DM24A={'dr' '' 0.129440 []}';
DM24B={'dr' '' 0.178000 []}';
DM24D={'dr' '' 0.070700 []}';
DM24C={'dr' '' 0.106300 []}';
DM25={'dr' '' 0.160400 []}';
% BSY
DRIF0105={'dr' '' 0.134786 []}';
DRIF0106={'dr' '' 0.140208 []}';
DRIF0107={'dr' '' 1.605264 []}';
DRIF0108={'dr' '' 0.0184 []}';
DRIF0109={'dr' '' 2.688336 []}';
DRIF0110={'dr' '' 0.35052 []}';
DRIF0111={'dr' '' 2.93 []}';
DRIF0112={'dr' '' 0.5411 []}';
DRIF0113={'dr' '' 2.0764 []}';
DRIF0114={'dr' '' 4.843132 []}';
DRIF0115={'dr' '' 0.382923 []}';
DRIF0116={'dr' '' 0.128016 []}';
DRIF0117={'dr' '' 0.950976 []}';
DRIF0118={'dr' '' 0.192024 []}';
DRIF0119={'dr' '' 0.466344 []}';
DRIF0120={'dr' '' 0.331248 []}';
DRIF0121={'dr' '' 0.566 []}';
DRIF0122={'dr' '' 0.247 []}';
DRIF0123={'dr' '' 0.459 []}';
DRIF0124={'dr' '' 0.487899 []}';
DRIF0125={'dr' '' 0.204216 []}';
DRIF0126={'dr' '' 0.377343 []}';
D50B1={'dr' '' 1.132027 []}';
DR19={'dr' '' 0.76197 []}';
DR20={'dr' '' 17.808583 []}';
DR21={'dr' '' 9.09461 []}';
DR22={'dr' '' 0.578 []}';
DR23={'dr' '' 0.1524 []}';
A4DXL={'dr' '' 0.08335 []}';
DR23A={'dr' '' 0.0233 []}';
DR23B={'dr' '' 0.134 []}';
A4DYL={'dr' '' 0.08335 []}';
DR24={'dr' '' 0.0684 []}';
PMV={'dr' '' 0.3429 []}';
DR25={'dr' '' 0.2032 []}';
DR25A={'dr' '' 0.255 []}';
FPM1={'dr' '' 0.83085 []}';
PM1={'dr' '' 0.600075 []}';
DR26={'dr' '' 2.708228 []}';
DR27={'dr' '' 4.901982 []}';
DR28={'dr' '' 65.897951 []}';
D10D={'dr' '' 4.29893 []}';
DMB01={'dr' '' 3.687288 []}';
DMB02={'dr' '' 0.27604 []}';
H1DL={'dr' '' 0.08335 []}';
DM03={'dr' '' 0.110211 []}';
V1DL={'dr' '' 0.08335 []}';
DM04={'dr' '' 0.49955 []}';
DM05={'dr' '' 0.660502 []}';
DM08={'dr' '' 0.686013 []}';
DM09={'dr' '' 0.550794 []}';
DM10B={'dr' '' 0.423278 []}';
DQSM1={'dr' '' 0.23738 []}';
DYC5={'dr' '' 0.307342 []}';
I4A={'dr' '' 0.32385-0.205742 []}';
I4B={'dr' '' 0.32385 []}';
I5={'dr' '' 0.32385 []}';
DM12A={'dr' '' 0.044958 []}';
I6={'dr' '' 0.32385 []}';
DM12B={'dr' '' 0.459314 []}';
DM12C={'dr' '' 0.31 []}';
DXC6={'dr' '' 0.68 []}';
DM2={'dr' '' 0.561408 []}';
D2L={'dr' '' 0.6096 []}';
DM3={'dr' '' 0.1524 []}';
ST60L={'dr' '' 0.6096 []}';
DM4={'dr' '' 8.622041 []}';
DXCA0={'dr' '' 0.31 []}';
DYCA0={'dr' '' 0.356220-0.076799 []}';
ST61L={'dr' '' 0.6096 []}';
DM5={'dr' '' 0.561379 []}';
DM6={'dr' '' 0.567588 []}';
DMONI={'dr' '' 0.009525 []}';
WALL={'dr' '' 16.764 []}';
% LTU
DZ_ADJUST = 47.825;
D10CM={'dr' '' 0.10 []}';
D10CMA={'dr' '' 0.127 []}';
DC10CM={'dr' '' 0.10 []}';
D21CM={'dr' '' 0.21 []}';
D25CM={'dr' '' 0.25 []}';
D29CMA={'dr' '' 0.29+0.023878+0.1000244+0.1704396 []}';
D30CM={'dr' '' 0.30 []}';
D32CM={'dr' '' 0.32 []}';
D32CMA={'dr' '' 0.32+0.0253999+0.0750601 []}';
D32CMB={'dr' '' 0.32-0.056221+0.4000244 []}';
D32CMC={'dr' '' 0.32-0.0254+0.00586 []}';
D32CMD={'dr' '' 0.32-0.056221+0.4000244+0.2404381 []}';
D34CM={'dr' '' 0.34 []}';
D40CM={'dr' '' 0.40 []}';
D40CMA={'dr' '' 0.40+1.407939 []}';
D40CMB={'dr' '' 0.40+0.090013 []}';
D40CMC={'dr' '' 0.40 []}';
D40CMD={'dr' '' 0.40+0.090013-0.000473 []}';
D40CME={'dr' '' 0.40+0.090013+0.010447 []}';
D40CMF={'dr' '' 0.40+0.090013-0.065013 []}';
D50CM={'dr' '' 0.50 []}';
D31A={'dr' '' 0.40+DLQA2+0.090005 []}';
D31B={'dr' '' 0.40+DLQA2+0.4900025-0.4000244 []}';
D32A={'dr' '' 0.40+DLQA2 []}';
D32B={'dr' '' 0.40+DLQA2 []}';
D33A={'dr' '' 0.21+DLQA2+0.380004-0.1000244-0.1704396 []}';
D33B={'dr' '' 0.40+DLQA2+0.4900025-0.4000244-0.2404381 []}';
D34A={'dr' '' 0.40+DLQA2+0.09-0.00046 []}';
D34B={'dr' '' 0.25+DLQA2+0.2399776-0.2404376 []}';
DEM1A={'dr' '' 0.40+DLQA2-0.10046 []}';
DEM1B={'dr' '' 4.00+DLQA2*2 []}';
DEM2B={'dr' '' 0.40+DLQA2+0.02954 []}';
DEM3A={'dr' '' 0.40+DLQA2-0.10046 []}';
DEM3B={'dr' '' 0.30+DLQA2+0.402839 []}';
DEM4A={'dr' '' 0.40+DLQA2-0.402839+(0.402839)+0.02954 []}';
DUM1A={'dr' '' 0.40+DLQA2+0.0254-0.00586 []}';
DUM1B={'dr' '' 0.40+DLQA2 []}';
DUM2A={'dr' '' 0.40+DLQA2-0.0253999-0.0750601 []}';
DUM2B={'dr' '' 0.40+DLQA2 []}';
DUM3A={'dr' '' 0.40+DLQA2+0.125-0.21546 []}';
DUM3B={'dr' '' 0.40+DLQA2 []}';
DUM4A={'dr' '' 0.40+DLQA2+0.0254+0.00414 []}';
DUM4B={'dr' '' 0.40+DLQA2+0.127 []}';
DYCVM1={'dr' '' 0.40 []}';
DQVM1={'dr' '' 0.34 []}';
DVB25CM={'dr' '' 0.5-0.25 []}';
DVB25CMC={'dr' '' 0.5-0.25 []}';
DQVM2={'dr' '' 0.5 []}';
DXCVM2={'dr' '' 0.25 []}';
DVB1={'dr' '' 8.0-2*0.3125 []}';
DVB1M40CM={'dr' '' 8.0-0.4-2*0.3125 []}';
DVB2={'dr' '' 4.0 []}';
DVB2M80CM={'dr' '' 4.0-0.4-0.4 []}';
DVBE={'dr' '' 0.5 []}';
DVBEM25CM={'dr' '' 0.5-0.25 []}';
DVBEM15CM={'dr' '' 0.150+0.00381+0.018803 []}';
D10CMB={'dr' '' 0.1064869 []}';
D25CMA={'dr' '' 0.25-0.00381-0.018803-0.0064869 []}';
DQEA={'dr' '' 0.40+(LQF-LQX)/2-0.15046 []}';
DQEAA={'dr' '' 0.40+(LQF-LQX)/2-0.14046 []}';
DQEAB={'dr' '' 0.40+(LQF-LQX)/2-0.12046 []}';
DQEAC={'dr' '' 0.40+(LQF-LQX)/2+0.02954 []}';
DQEBX={'dr' '' 0.32+(LQF-LQX)/2+0.33655-0.0768665+0.04 []}';
DQEBY={'dr' '' 0.32+(LQF-LQX)/2+0.33655-0.0768665+0.04 []}';
DQEC={'dr' '' 4.6+DZ_ADJUST/12+(LQF-LQX)/2 []}';
DE3={'dr' '' 4.6+DZ_ADJUST/12+0.15046 []}';
DE3A={'dr' '' 4.6+DZ_ADJUST/12+0.14046 []}';
DE3M40CM={'dr' '' 4.6-0.4+DZ_ADJUST/12+0.15046 []}';
DE3M80CM={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12-0.02954 []}';
DE3M80CMA={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12+0.15046 []}';
DE3M80CMB={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12+0.12046 []}';
DQEBX2={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12-0.33655+0.0768665-0.04 []}';
DQEBY2={'dr' '' 4.6-0.4+DZ_ADJUST/12-0.33655+0.0768665-0.04 []}';
DDL10={'dr' '' 12.86072 []}';
DDL10M70CM={'dr' '' 12.86072-0.4-0.3-0.09+0.00046 []}';
DDL10U={'dr' '' 0.5 []}';
DDL10UM25CM={'dr' '' 0.5-0.25-0.2399776+0.2404376 []}';
DDL10V={'dr' '' 12.86072-0.5 []}';
DDL1A={'dr' '' 5.820626-LKIK/2 []}';
DDL1C={'dr' '' 0.609226-LKIK/2 []}';
DDL1B={'dr' '' 5.421642-LKIK/2 []}';
DSPLR={'dr' '' 0.43036 []}';
D30CMA={'dr' '' 0.257426 []}';
DPC1={'dr' '' 0.266697 []}';
DPC2={'dr' '' 0.266697 []}';
DPC3={'dr' '' 0.266697 []}';
DPC4={'dr' '' 0.266697+0.339613-0.8128/2 []}';
DDL1DM30CM={'dr' '' 0.379160-0.262228 []}';% allow possible new spontaneous undulator here
DDL1CM40CM={'dr' '' 6.03036-0.43036-0.6096/2 []}';
LSPONT = 1.5                           ;% length of possible spontaneous undulator (<=5 m now that TDKIK is also there)
SPONTUA={'dr' '' LSPONT/2 []}';
SPONTUB={'dr' '' LSPONT/2 []}';
DDL20={'dr' '' 0.5 []}';
DDL30={'dr' '' 1.0 []}';
DDL30M40CM={'dr' '' 1.0-0.4 []}';
DDL10W={'dr' '' 12.86072-2*LDW1O-3*(LBXW)-1.1 []}';
DDL10X={'dr' '' 0.250000-0.033681-0.090005 []}';
DDL10E={'dr' '' 12.86072 []}';
DDL10EM50CM={'dr' '' 12.86072-0.25-0.25-0.090002-0.313878 []}';
DDL10EM80CM={'dr' '' 12.86072-0.4-0.4-0.433783 []}';
DCQ31A={'dr' '' 6.037182 []}';
DCQ31B={'dr' '' 5.811658 []}';
DCQ32A={'dr' '' 5.4817585 []}';
DCQ32B={'dr' '' 6.0371785 []}';
DDL20E={'dr' '' 0.5 []}';
DDL30E={'dr' '' 1.0 []}';
DDL30EM40CM={'dr' '' 1.0-0.4-0.090013 []}';
DDL30EM40CMA={'dr' '' 1.0-0.4-0.090013+0.000473 []}';
DDL30EM40CMB={'dr' '' 1.0-0.4-0.090013-0.010447 []}';
DDL30EM40CMC={'dr' '' 1.0-0.4-0.090013+0.065013 []}';
D25CMB={'dr' '' 0.25+0.0127 []}';
D25CMC={'dr' '' 0.25-0.0127 []}';
DMM1M90CM={'dr' '' 2.0-0.25-0.25-0.4+0.10046 []}';
DMM3M80CM={'dr' '' 10.0-0.4-0.4+2.0+0.07092 []}';
DMM4M90CM={'dr' '' 3.6-0.30-LQX-(0.402839)-0.02954 []}';
DMM5={'dr' '' 2.0+DLQA2 []}';
DU1M80CM={'dr' '' 4.550 []}';
DU2M120CM={'dr' '' 4.730 []}';
DU3M80CM={'dr' '' 8.0-0.4-0.4-0.125+0.21546 []}';
DU4M120CM={'dr' '' 2.800-1.407939-0.0254-0.00414 []}';
DU5M80CM={'dr' '' 0.5 []}';
DMUON2={'dr' '' 1.406800 []}';
DMUON1={'dr' '' 0.154859 []}';
DMUON3={'dr' '' 0.310592 []}';
DWSDL31A={'dr' '' 0.096237 []}';%0.096779-0.000542
DWSDL31B={'dr' '' 0.153763 []}';%0.153221+0.000542
DWSDUMPA={'dr' '' 0.44156 []}';%0.5-0.058217-0.000222-0.000001
DWSDUMPB={'dr' '' 2.038949 []}';%1.980509+0.058217+0.000222+0.000001
% ==============================================================================
% MARKERs
% ------------------------------------------------------------------------------
% wire scanners
WS01={'mo' 'WS01' 0 []}';%DL1- emittance
WS02={'mo' 'WS02' 0 []}';%DL1- emittance
WS03={'mo' 'WS03' 0 []}';%DL1- emittance
WS04={'mo' 'WS04' 0 []}';%DL1- energy spread
WS11={'mo' 'WS11' 0 []}';%BC1+ emittance
WS12={'mo' 'WS12' 0 []}';%BC1+ emittance
WS13={'mo' 'WS13' 0 []}';%BC1+ emittance
%  WS21 : WIRE LI24 emittance
%  WS22 : WIRE LI24 emittance
%  WS23 : WIRE LI24 emittance
%  WS24 : WIRE BC2- emittance
DWS21={'mo' 'DWS21' 0 []}';%someday will be a wire-scanner again?
DWS22={'mo' 'DWS22' 0 []}';%someday will be a wire-scanner again?
DWS23={'mo' 'DWS23' 0 []}';%someday will be a wire-scanner again?
DWS24={'mo' 'DWS24' 0 []}';%someday will be a wire-scanner again?
WS27644={'mo' 'WS27644' 0 []}';%LI27 emittance (existing; moved)
WS28144={'mo' 'WS28144' 0 []}';%LI28 emittance
WS28444={'mo' 'WS28444' 0 []}';%LI28 emittance
WS28744={'mo' 'WS28744' 0 []}';%LI28 emittance (existing; moved)
WS31={'mo' 'WS31' 0 []}';%LTU  emittance
WS32={'mo' 'WS32' 0 []}';%LTU  emittance
WS33={'mo' 'WS33' 0 []}';%LTU  emittance
WS34={'mo' 'WS34' 0 []}';%LTU  emittance
WSDL31={'mo' 'WSDL31' 0 []}';
WSDUMP={'mo' 'WSDUMP' 0 []}';
% profile monitors
YAG01={'mo' 'YAG01' 0 []}';%gun (15.5 in from cathode, per J. Schmerge, June 17, 2003; -PE)
YAG02={'mo' 'YAG02' 0 []}';%gun (need proper positions still - June 10, 2003)
YAG03={'mo' 'YAG03' 0 []}';%after L0-a (~ 60 MeV) - center of device in MAD is defined as center of YAG crystal, not mirror
YAG04={'mo' 'YAG04' 0 []}';%temporarily (Dec. '06 - July '07) placed in laser-heater region (135 MeV) - center of device in MAD is defined as center of YAG crystal, not mirror
PH01={'mo' 'PH01' 0 []}';%phase measurement RF cavity between L0-a and L0-b
PH02={'mo' 'PH02' 0 []}';%phase measurement RF cavity after BC1
PH03={'mo' 'PH03' 0 []}';%phase measurement RF cavity after BC2
VV01={'mo' 'VV01' 0 []}';%vacuum valve near gun
VV02={'mo' 'VV02' 0 []}';%vacuum valve in injector
VV03={'mo' 'VV03' 0 []}';%vacuum valve in injector
VV04={'mo' 'VV04' 0 []}';%vacuum valve in injector
VVX1={'mo' 'VVX1' 0 []}';%vacuum valve before X-band structure
VVX2={'mo' 'VVX2' 0 []}';%vacuum valve after X-band structure
VV21={'mo' 'VV21' 0 []}';%vacuum valve in front of BC2
VV22={'mo' 'VV22' 0 []}';%vacuum valve after BC2
RST1={'mo' 'RST1' 0 []}';%radiation stopper near WS02 in injector
OTRH1={'mo' 'OTRH1' 0 []}';%Laser-heater OTR screen just upbeam of heater-undulator (12NOV03 - PE)
OTRH2={'mo' 'OTRH2' 0 []}';%Laser-heater OTR screen just dnbeam of heater-undulator (12NOV03 - PE)
%  DOTRH1   : MARK                  Laser-heater OTR screen PLACE-HOLDER just upbeam of heater-undulator (not installed until summer 2008)
%  DOTRH2   : MARK                  Laser-heater OTR screen PLACE-HOLDER just dnbeam of heater-undulator (not installed until summer 2008)
OTR1={'mo' 'OTR1' 0 []}';%DL1-emit
OTR2={'mo' 'OTR2' 0 []}';%DL1-emit
OTR3={'mo' 'OTR3' 0 []}';%DL1-emit
OTR4={'mo' 'OTR4' 0 []}';%DL1 slice and proj. energy spread
OTR11={'mo' 'OTR11' 0 []}';%BC1 energy spread
OTR12={'mo' 'OTR12' 0 []}';%BC1 emittance
OTR21={'mo' 'OTR21' 0 []}';%BC2 energy spread
OTR22={'mo' 'OTR22' 0 []}';%post-BC2 beam size
OTR_TCAV={'mo' 'OTR_TCAV' 0 []}';%LI25 longitudinal diagnostics
OTR30={'mo' 'OTR30' 0 []}';%LTU slice energy spread (90 deg from TCAV3)
OTR33={'mo' 'OTR33' 0 []}';%LTU slice emittance (~90 deg from TCAV3)
% bunch length monitors
BL11={'mo' 'BL11' 0 []}';%BC1+ (CSR-based relative bunch length monitor)
BL12={'mo' 'BL12' 0 []}';%BC1+ (ceramic gap-based relative bunch length monitor)
BL21={'mo' 'BL21' 0 []}';%BC2+ (CSR-based relative bunch length monitor)
BL22={'mo' 'BL22' 0 []}';%BC2+ (ceramic gap-based relative bunch length monitor)
% bunch charge monitors (toroids)
IM01={'mo' 'IM01' 0 []}';%L0
IM02={'mo' 'IM02' 0 []}';%L0
IMS1={'mo' 'IMS1' 0 []}';%135-MeV spectrometer
IM03={'mo' 'IM03' 0 []}';%DL1-
IMBC1I={'mo' 'IMBC1I' 0 []}';%BC1 input toriod (comparator with IMBC1O)
IMBC1O={'mo' 'IMBC1O' 0 []}';%BC1 output toroid (comparator with IMBC1I)
IMBC2I={'mo' 'IMBC2I' 0 []}';%BC2 input toroid (comparator with IMBC2O)
IMBC2O={'mo' 'IMBC2O' 0 []}';%BC2 output toroid (comparator with IMBC2I)
IM31={'mo' 'IM31' 0 []}';%LTU: upstr. of BX31 (comparator with IM36)
IM36={'mo' 'IM36' 0 []}';%LTU: dnstr. of BX36 (comparator with IM31)
IMUNDI={'mo' 'IMUNDI' 0 []}';%FEL-undulator input toroid (comparator with IMUNDO)
IMUNDO={'mo' 'IMUNDO' 0 []}';%FEL-undulator output toroid (comparator with IMUNDI)
IMDUMP={'mo' 'IMDUMP' 0 []}';%in dump line after Y-bends and quad (comparator with IMUNDO)
% BCS toroids (from Saleski request)
IMBCS1={'mo' 'IMBCS1' 0 []}';%LTU: upstr. of BX31 (comparator with IMBCS2)
IMBCS2={'mo' 'IMBCS2' 0 []}';%LTU: dnstr. of BX36 (comparator with IMBCS1)
IMBCS3={'mo' 'IMBCS3' 0 []}';%pre-dump magnet toroid with >42-mm ID stay-clear (comparator with IMBCS4)
IMBCS4={'mo' 'IMBCS4' 0 []}';%in dump line, after Y-bends, with >48-mm ID stay-clear (comparator with IMBCS3)
% other diagnostics
FC01={'mo' 'FC01' 0 []}';%L0 Faraday cup w/screen
AM00={'mo' 'AM00' 0 []}';%gun laser normal incidence mirror
AM01={'mo' 'AM01' 0 []}';%alignment mirror
CR01={'mo' 'CR01' 0 []}';%Cerenkov radiator bunch length monitor
% collimators
CE11={'dr' 'CE11' 0 []}';%adjustable energy (x) collimator in middle of BC1 chicane
CE21={'dr' 'CE21' 0 []}';%adjustable energy (x) collimator in middle of BC2 chicane
% dumps
TD11={'mo' 'TD11' 0 []}';%BC1+ insertable block
% miscellany
LSOL1    = 0.200;
L0BEG={'mo' 'L0BEG' 0 []}';
SOL1BK={'dr' 'SOL1BK' 1E-9 []}';%gun-bucking-solenoid (set to ~zero length and strength, with longitudinal unknown for now)
CATHODE={'mo' 'CATHODE' 0 []}';
SOL1={'dr' 'SOL1' LSOL1/2 []}';%gun-solenoid (set to zero strength)
SOL2={'dr' 'SOL2' 1E-9 []}';%2nd-solenoid (set to ~zero length and strength, with longitudinal position as the actual solenoid's center)
L0END={'mo' 'L0END' 0 []}';
L0AWAKE={'mo' 'L0AWAKE' 0 []}';
EMAT={'mo' 'EMAT' 0 []}';% for Elegant only to remove energy error in DL1 bends
DL1BEG={'mo' 'DL1BEG' 0 []}';
DLFDA={'mo' 'DLFDA' 0 []}';% dual-feed input coupler location at start of L0-a RF structure
L0AMID={'mo' 'L0AMID' 0 []}';
OUTCPA={'mo' 'OUTCPA' 0 []}';% output coupler location at end of L0-a RF structure
L0BBEG={'mo' 'L0BBEG' 0 []}';
DLFDB={'mo' 'DLFDB' 0 []}';% dual-feed input coupler location at start of L0-b RF structure
L0BMID={'mo' 'L0BMID' 0 []}';
OUTCPB={'mo' 'OUTCPB' 0 []}';% output coupler location at end of L0-b RF structure
CNT0={'mo' 'CNT0' 0 []}';
DL1END={'mo' 'DL1END' 0 []}';
L1BEG={'mo' 'L1BEG' 0 []}';
L1END={'mo' 'L1END' 0 []}';
BC1MRK={'mo' 'BC1MRK' 0 []}';
XBEG={'mo' 'XBEG' 0 []}';%before X-band RF, but after L1
XEND={'mo' 'XEND' 0 []}';%after X-band RF, but before BC1
BC1BEG={'mo' 'BC1BEG' 0 []}';
CNT1={'mo' 'CNT1' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC1END={'mo' 'BC1END' 0 []}';
BC1FIN={'mo' 'BC1FIN' 0 []}';
L2BEG={'mo' 'L2BEG' 0 []}';
LI21BEG={'mo' 'LI21BEG' 0 []}';
LI21END={'mo' 'LI21END' 0 []}';
LI22BEG={'mo' 'LI22BEG' 0 []}';
LI22END={'mo' 'LI22END' 0 []}';
LI23BEG={'mo' 'LI23BEG' 0 []}';
LI23END={'mo' 'LI23END' 0 []}';
LI24BEG={'mo' 'LI24BEG' 0 []}';
LI24END={'mo' 'LI24END' 0 []}';
L2END={'mo' 'L2END' 0 []}';
BC2MRK={'mo' 'BC2MRK' 0 []}';
BC2BEG={'mo' 'BC2BEG' 0 []}';
CNT2={'mo' 'CNT2' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC2END={'mo' 'BC2END' 0 []}';
BC2FIN={'mo' 'BC2FIN' 0 []}';
L3BEG={'mo' 'L3BEG' 0 []}';
LI25BEG={'mo' 'LI25BEG' 0 []}';
LI25END={'mo' 'LI25END' 0 []}';
LI26BEG={'mo' 'LI26BEG' 0 []}';
LI26END={'mo' 'LI26END' 0 []}';
LI27BEG={'mo' 'LI27BEG' 0 []}';
LI27END={'mo' 'LI27END' 0 []}';
LI28BEG={'mo' 'LI28BEG' 0 []}';
LI28END={'mo' 'LI28END' 0 []}';
LI29BEG={'mo' 'LI29BEG' 0 []}';
LI29END={'mo' 'LI29END' 0 []}';
LI30BEG={'mo' 'LI30BEG' 0 []}';
RWWAKESS={'mo' 'RWWAKESS' 0 []}';%will be resistive wall wake of stainless steel in ELEGANT
LI30END={'mo' 'LI30END' 0 []}';
L3END={'mo' 'L3END' 0 []}';
BSYBEG={'mo' 'BSYBEG' 0 []}';
CNTV={'mo' 'CNTV' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
CNTW={'mo' 'CNTW' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
CNT3A={'mo' 'CNT3A' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
CNT3B={'mo' 'CNT3B' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
EOBLM={'mo' 'EOBLM' 0 []}';%future electro-optic bunch length monitor?
RWWAKEAL={'mo' 'RWWAKEAL' 0 []}';%will be resistive wall wake of aluminum in ELEGANT
PFILT1={'mo' 'PFILT1' 0 []}';
% BSY stuff (exists)
FFTBORGN={'mo' 'FFTBORGN' 0 []}';
S100={'mo' 'S100' 0 []}';
C50PC20={'mo' 'C50PC20' 0 []}';
I40IW1={'mo' 'I40IW1' 0 []}';
M40B1={'mo' 'M40B1' 0 []}';
P460031T={'mo' 'P460031T' 0 []}';
P460032T={'mo' 'P460032T' 0 []}';
C50PC30={'mo' 'C50PC30' 0 []}';
%  I50I1A   : MARK
IMBSY34={'mo' 'IMBSY34' 0 []}';
W460042T={'mo' 'W460042T' 0 []}';
P460045T={'mo' 'P460045T' 0 []}';
PM3={'mo' 'PM3' 0 []}';
B2={'mo' 'B2' 0 []}';
D10B={'mo' 'D10B' 0 []}';
PC90={'mo' 'PC90' 0 []}';
I3={'mo' 'I3' 0 []}';
P950020T={'mo' 'P950020T' 0 []}';
IV4={'mo' 'IV4' 0 []}';
D2={'mo' 'D2' 0 []}';
ST60={'mo' 'ST60' 0 []}';
ST61={'mo' 'ST61' 0 []}';
SS1={'mo' 'SS1' 0 []}';
SS3={'mo' 'SS3' 0 []}';
MM1={'mo' 'MM1' 0 []}';
MM2={'mo' 'MM2' 0 []}';
MM3={'mo' 'MM3' 0 []}';
% Permanent reference points in the linac (and LTU: Z') Z-coordinate system (in meters)
% (NOTE: Z' is measured parallel to the undulator axis which is at an angle of
% 2*AVB [=4.668514 mrad on May 4, 2004] w.r.t. the linac axis):
% (Note Q20-901 is at 2029.4060 m in drawing ID-380-802-00 pg. 2 - this does not agree
%  with Woodley/Seeman database at 2029.3939 m.  We assume drawing is right -PE, June 11, 2004)
% ============================================================================================
ZLIN00={'mo' 'ZLIN00' 0 []}';% face of L0-a entrance flange : Z=2019.106625 (= 1.459000 m from cathode parallel to injector line, X = 9.612087)
% DBMARK98 : MARK   (135SPECT)135-MeV spect. dump: Z=2036.774471
ZLIN01={'mo' 'ZLIN01' 0 []}';% entrance to 21-1b            : Z=2035.035130 (= 20*101.600 m + 3.0441 m - 0.00897 m: 8/1/05)
ZLIN02={'mo' 'ZLIN02' 0 []}';% center of QUAD LI21 201      : (not used anymore since Q21201 is a few mm off) [was Z=2045.436400 pre 1/11/07]
ZLIN03={'mo' 'ZLIN03' 0 []}';% center of QUAD LI21 301      : (not used anymore since Q21301 is a few mm off) [was Z=2057.855466 pre 1/11/07]
ZLIN04={'mo' 'ZLIN04' 0 []}';% entrance to 21-3b            : Z=2059.732900
ZLIN05={'mo' 'ZLIN05' 0 []}';% start of LI22                : Z=2133.600000
ZLIN06={'mo' 'ZLIN06' 0 []}';% start of LI23                : Z=2235.200000
ZLIN07={'mo' 'ZLIN07' 0 []}';% start of LI24                : Z=2336.800000
ZLIN08={'mo' 'ZLIN08' 0 []}';% center of QUAD LI24 701 (A)  : Z=2410.786000 (not moved)
ZLIN09={'mo' 'ZLIN09' 0 []}';% start of LI25                : Z=2438.400000
ZLIN10={'mo' 'ZLIN10' 0 []}';% start of LI26                : Z=2540.000000
ZLIN11={'mo' 'ZLIN11' 0 []}';% start of LI27                : Z=2641.600000
ZLIN12={'mo' 'ZLIN12' 0 []}';% start of LI28                : Z=2743.200000
ZLIN13={'mo' 'ZLIN13' 0 []}';% start of LI29                : Z=2844.800000
ZLIN14={'mo' 'ZLIN14' 0 []}';% start of LI30                : Z=2946.400000
ZLIN15={'mo' 'ZLIN15' 0 []}';% station-100 (or "S100")      : Z=3048.000000  (Z' =   0.000000 m, X'= 0.000000 m, Y'= 0.000000 m)
BSYEND={'mo' 'BSYEND' 0 []}';% FFTB side of muon plug wall  : Z=3224.022426  (Z' = 176.020508 m, X'= 0.000000 m, Y'=-0.821761 m)
VBIN={'mo' 'VBIN' 0 []}';% start of vert. bend system   : Z=3226.684266  (Z' = 178.682319 m, X'= 0.000000 m, Y'=-0.834188 m)
VBOUT={'mo' 'VBOUT' 0 []}';% end of vert. bend system     : Z=3252.866954  (Z' = 204.865007 m, X'= 0.000000 m, Y'=-0.895305 m)
UNDSTART={'mo' 'UNDSTART' 0 []}';% start of undulator system    : Z=3562.999159  (Z' = 515.000592 m, X'=-1.250000 m, Y'=-0.895305 m)
UNDTERM={'mo' 'UNDTERM' 0 []}';% ~end of undulator system     : Z=3695.441716  (Z' = 647.444592 m, X'=-1.250000 m, Y'=-0.895305 m)
DLSTART={'mo' 'DLSTART' 0 []}';% start of dumpline            : Z=3734.383707  (Z' = 686.387007 m, X'=-1.250000 m, Y'=-0.895305 m)
EOL={'mo' 'EOL' 0 []}';% near entrance face of dump   : Z=3763.781501  (Z' = 715.774454 m, X'=-1.250000 m, Y'=-3.180529 m)
SFTDMP={'mo' 'SFTDMP' 0 []}';% safety dump when BYD's trip  : Z=NA           (Z' = 719.120100 m, X'=-1.517688 m, Y'=-0.895305 m)
DUMPFACE={'mo' 'DUMPFACE' 0 []}';% entrance face of main e- dump (same as EOL)
BTMDUMP={'mo' 'BTMDUMP' 0 []}';% Burn-Through-Monitor of main e- dump
% ==============================================================================
% existing XCORs
% ------------------------------------------------------------------------------
%  XC460009T : HKIC
%  XC460026T : HKIC
%  XC460034T : HKIC do not use to steer ... bad results in Elegant
%  XC460036T : HKIC do not use to steer ... bad results in Elegant
%  XC920020T : HKIC
%  XC921010T : HKIC do not use to steer ... bad results in Elegant
XCBSY09={'mo' 'XCBSY09' 0 []}';% names changed from above to these (Sep. 2008)
XCBSY26={'mo' 'XCBSY26' 0 []}';
XCBSY34={'mo' 'XCBSY34' 0 []}';%do not use to steer ... bad results in Elegant
XCBSY36={'mo' 'XCBSY36' 0 []}';%do not use to steer ... bad results in Elegant
XCBSY60={'mo' 'XCBSY60' 0 []}';
XCBSY81={'mo' 'XCBSY81' 0 []}';%do not use to steer ... bad results in Elegant
% ==============================================================================
% new XCORs
% ------------------------------------------------------------------------------
XC00={'mo' 'XC00' 0 []}';
XC01={'mo' 'XC01' 0 []}';
XC02={'mo' 'XC02' 0 []}';
XC03={'mo' 'XC03' 0 []}';
XC04={'mo' 'XC04' 0 []}';% fast-feedback (loop-1)
XC05={'mo' 'XC05' 0 []}';% calibrated to <1%
XC06={'mo' 'XC06' 0 []}';
XC07={'mo' 'XC07' 0 []}';% fast-feedback (loop-1)
XC08={'mo' 'XC08' 0 []}';
XC09={'mo' 'XC09' 0 []}';
XC10={'mo' 'XC10' 0 []}';
XC11={'mo' 'XC11' 0 []}';
XCA11={'mo' 'XCA11' 0 []}';
XCA12={'mo' 'XCA12' 0 []}';% calibrated to <1%
XC21202={'mo' 'XC21202' 0 []}';% pulled off structure and replaced on beamline?
XC21302={'mo' 'XC21302' 0 []}';% pulled off structure and replaced on beamline?
XCM11={'mo' 'XCM11' 0 []}';
XCM13={'mo' 'XCM13' 0 []}';
XCM14={'mo' 'XCM14' 0 []}';
XC6={'mo' 'XC6' 0 []}';
XCA0={'mo' 'XCA0' 0 []}';
XCVB2={'mo' 'XCVB2' 0 []}';
XCVM2={'mo' 'XCVM2' 0 []}';% calibrated to <1%
XCVM3={'mo' 'XCVM3' 0 []}';
XCDL1={'mo' 'XCDL1' 0 []}';
XCDL2={'mo' 'XCDL2' 0 []}';
XCDL3={'mo' 'XCDL3' 0 []}';
XCDL4={'mo' 'XCDL4' 0 []}';% fast-feedback (loop-4)
XCQT12={'mo' 'XCQT12' 0 []}';
XCQT22={'mo' 'XCQT22' 0 []}';
XCQT32={'mo' 'XCQT32' 0 []}';% fast-feedback (loop-4)
XCQT42={'mo' 'XCQT42' 0 []}';
XCEM2={'mo' 'XCEM2' 0 []}';
XCEM4={'mo' 'XCEM4' 0 []}';
XCE31={'mo' 'XCE31' 0 []}';
XCE33={'mo' 'XCE33' 0 []}';
XCE35={'mo' 'XCE35' 0 []}';
XCUM1={'mo' 'XCUM1' 0 []}';% fast-feedback (loop-5)
XCUM4={'mo' 'XCUM4' 0 []}';% fast-feedback (loop-5)
XCUE1={'mo' 'XCUE1' 0 []}';
XCD3={'mo' 'XCD3' 0 []}';
XCDD={'mo' 'XCDD' 0 []}';
% ==============================================================================
% existing YCORs
% ------------------------------------------------------------------------------
%  YC460010T : VKIC
%  YC460027T : VKIC do not use to steer ... bad results in Elegant
%  YC460035T : VKIC do not use to steer ... bad results in Elegant
%  YC460037T : VKIC
%  YC920020T : VKIC
%  YC921010T : VKIC do not use to steer ... bad results in Elegant
YCBSY10={'mo' 'YCBSY10' 0 []}';% names changed from above to these (Sep. 2008)
YCBSY27={'mo' 'YCBSY27' 0 []}';%do not use to steer ... bad results in Elegant
YCBSY35={'mo' 'YCBSY35' 0 []}';%do not use to steer ... bad results in Elegant
YCBSY37={'mo' 'YCBSY37' 0 []}';
YCBSY62={'mo' 'YCBSY62' 0 []}';
YCBSY82={'mo' 'YCBSY82' 0 []}';%do not use to steer ... bad results in Elegant
% ==============================================================================
% new YCORs
% ------------------------------------------------------------------------------
YC00={'mo' 'YC00' 0 []}';
YC01={'mo' 'YC01' 0 []}';
YC02={'mo' 'YC02' 0 []}';
YC03={'mo' 'YC03' 0 []}';
YC04={'mo' 'YC04' 0 []}';% fast-feedback (loop-1)
YC05={'mo' 'YC05' 0 []}';% calibrated to <1%
YC06={'mo' 'YC06' 0 []}';
YC07={'mo' 'YC07' 0 []}';% fast-feedback (loop-1)
YC08={'mo' 'YC08' 0 []}';
YC09={'mo' 'YC09' 0 []}';
YC10={'mo' 'YC10' 0 []}';
YC11={'mo' 'YC11' 0 []}';
YCA11={'mo' 'YCA11' 0 []}';% calibrated to <1%
YCA12={'mo' 'YCA12' 0 []}';
YC21203={'mo' 'YC21203' 0 []}';
YC21303={'mo' 'YC21303' 0 []}';% pulled off structure and replaced on beamline?
YCM11={'mo' 'YCM11' 0 []}';
YCM12={'mo' 'YCM12' 0 []}';
YCM15={'mo' 'YCM15' 0 []}';
YC5={'mo' 'YC5' 0 []}';
YCA0={'mo' 'YCA0' 0 []}';% add new YCOR here, if easy (PE, Nov. 4, 2003)
YCVB1={'mo' 'YCVB1' 0 []}';
YCVB3={'mo' 'YCVB3' 0 []}';
YCVM1={'mo' 'YCVM1' 0 []}';% calibrated to <1%
YCVM4={'mo' 'YCVM4' 0 []}';
YCDL1={'mo' 'YCDL1' 0 []}';
YCDL2={'mo' 'YCDL2' 0 []}';
YCDL3={'mo' 'YCDL3' 0 []}';
YCDL4={'mo' 'YCDL4' 0 []}';
YCQT12={'mo' 'YCQT12' 0 []}';
YCQT22={'mo' 'YCQT22' 0 []}';
YCQT32={'mo' 'YCQT32' 0 []}';% fast-feedback (loop-4)
YCQT42={'mo' 'YCQT42' 0 []}';% fast-feedback (loop-4)
YCEM1={'mo' 'YCEM1' 0 []}';
YCEM3={'mo' 'YCEM3' 0 []}';
YCE32={'mo' 'YCE32' 0 []}';
YCE34={'mo' 'YCE34' 0 []}';
YCE36={'mo' 'YCE36' 0 []}';
YCUM2={'mo' 'YCUM2' 0 []}';% fast-feedback (loop-5)
YCUM3={'mo' 'YCUM3' 0 []}';% fast-feedback (loop-5)
YCUE2={'mo' 'YCUE2' 0 []}';
YCD3={'mo' 'YCD3' 0 []}';
YCDD={'mo' 'YCDD' 0 []}';
% ==============================================================================
% existing BPMs
% ------------------------------------------------------------------------------
BPM21201={'mo' 'BPM21201' 0 []}';
BPM21301={'mo' 'BPM21301' 0 []}';
BPM21401={'mo' 'BPM21401' 0 []}';
BPM21501={'mo' 'BPM21501' 0 []}';
BPM21601={'mo' 'BPM21601' 0 []}';
BPM21701={'mo' 'BPM21701' 0 []}';
BPM21801={'mo' 'BPM21801' 0 []}';
BPM21901={'mo' 'BPM21901' 0 []}';
BPM22201={'mo' 'BPM22201' 0 []}';
BPM22301={'mo' 'BPM22301' 0 []}';
BPM22401={'mo' 'BPM22401' 0 []}';
BPM22501={'mo' 'BPM22501' 0 []}';
BPM22601={'mo' 'BPM22601' 0 []}';
BPM22701={'mo' 'BPM22701' 0 []}';
BPM22801={'mo' 'BPM22801' 0 []}';
BPM22901={'mo' 'BPM22901' 0 []}';
BPM23201={'mo' 'BPM23201' 0 []}';
BPM23301={'mo' 'BPM23301' 0 []}';
BPM23401={'mo' 'BPM23401' 0 []}';
BPM23501={'mo' 'BPM23501' 0 []}';
BPM23601={'mo' 'BPM23601' 0 []}';
BPM23701={'mo' 'BPM23701' 0 []}';
BPM23801={'mo' 'BPM23801' 0 []}';
BPM23901={'mo' 'BPM23901' 0 []}';
BPM24201={'mo' 'BPM24201' 0 []}';
BPM24301={'mo' 'BPM24301' 0 []}';
BPM24401={'mo' 'BPM24401' 0 []}';
BPM24501={'mo' 'BPM24501' 0 []}';
BPM24601={'mo' 'BPM24601' 0 []}';
BPM24701={'mo' 'BPM24701' 0 []}';
BPM24901={'mo' 'BPM24901' 0 []}';
BPM25201={'mo' 'BPM25201' 0 []}';
BPM25301={'mo' 'BPM25301' 0 []}';
BPM25401={'mo' 'BPM25401' 0 []}';
BPM25501={'mo' 'BPM25501' 0 []}';
BPM25601={'mo' 'BPM25601' 0 []}';
BPM25701={'mo' 'BPM25701' 0 []}';
BPM25801={'mo' 'BPM25801' 0 []}';
BPM25901={'mo' 'BPM25901' 0 []}';
BPM26201={'mo' 'BPM26201' 0 []}';
BPM26301={'mo' 'BPM26301' 0 []}';
BPM26401={'mo' 'BPM26401' 0 []}';
BPM26501={'mo' 'BPM26501' 0 []}';
BPM26601={'mo' 'BPM26601' 0 []}';
BPM26701={'mo' 'BPM26701' 0 []}';
BPM26801={'mo' 'BPM26801' 0 []}';
BPM26901={'mo' 'BPM26901' 0 []}';
BPM27201={'mo' 'BPM27201' 0 []}';
BPM27301={'mo' 'BPM27301' 0 []}';
BPM27401={'mo' 'BPM27401' 0 []}';
BPM27501={'mo' 'BPM27501' 0 []}';
BPM27601={'mo' 'BPM27601' 0 []}';
BPM27701={'mo' 'BPM27701' 0 []}';
BPM27801={'mo' 'BPM27801' 0 []}';
BPM27901={'mo' 'BPM27901' 0 []}';
BPM28201={'mo' 'BPM28201' 0 []}';
BPM28301={'mo' 'BPM28301' 0 []}';
BPM28401={'mo' 'BPM28401' 0 []}';
BPM28501={'mo' 'BPM28501' 0 []}';
BPM28601={'mo' 'BPM28601' 0 []}';
BPM28701={'mo' 'BPM28701' 0 []}';
BPM28801={'mo' 'BPM28801' 0 []}';
BPM28901={'mo' 'BPM28901' 0 []}';
BPM29201={'mo' 'BPM29201' 0 []}';
BPM29301={'mo' 'BPM29301' 0 []}';
BPM29401={'mo' 'BPM29401' 0 []}';
BPM29501={'mo' 'BPM29501' 0 []}';
BPM29601={'mo' 'BPM29601' 0 []}';
BPM29701={'mo' 'BPM29701' 0 []}';
BPM29801={'mo' 'BPM29801' 0 []}';
BPM29901={'mo' 'BPM29901' 0 []}';
BPM30201={'mo' 'BPM30201' 0 []}';
BPM30301={'mo' 'BPM30301' 0 []}';
BPM30401={'mo' 'BPM30401' 0 []}';
BPM30501={'mo' 'BPM30501' 0 []}';
BPM30601={'mo' 'BPM30601' 0 []}';
BPM30701={'mo' 'BPM30701' 0 []}';
BPM30801={'mo' 'BPM30801' 0 []}';
%  BPM304001T : MONI, TYPE="10_um_res"
%  BPM460029T : MONI, TYPE="10_um_res"
%  BPM460039T : MONI, TYPE="10_um_res"
%  BPM460051T : MONI, TYPE="10_um_res"
%  BPM920020T : MONI, TYPE="10_um_res"
%  BPM920030T : MONI, TYPE="10_um_res"
%  BPM920050T : MONI, TYPE="10_um_res"
%  BPM921010T : MONI, TYPE="10_um_res"
%  BPM921020T : MONI, TYPE="10_um_res"
%  BPM921030T : MONI, TYPE="10_um_res"
BPMBSY1={'mo' 'BPMBSY1' 0 []}';
BPMBSY29={'mo' 'BPMBSY29' 0 []}';
BPMBSY39={'mo' 'BPMBSY39' 0 []}';
BPMBSY51={'mo' 'BPMBSY51' 0 []}';
BPMBSY61={'mo' 'BPMBSY61' 0 []}';% rename these 6 BSY BPMs on Aug. 8, 2008
BPMBSY63={'mo' 'BPMBSY63' 0 []}';
BPMBSY83={'mo' 'BPMBSY83' 0 []}';
BPMBSY85={'mo' 'BPMBSY85' 0 []}';
BPMBSY88={'mo' 'BPMBSY88' 0 []}';
BPMBSY92={'mo' 'BPMBSY92' 0 []}';
% ==============================================================================
% new BPMs
% ------------------------------------------------------------------------------
BPM2={'mo' 'BPM2' 0 []}';
BPM3={'mo' 'BPM3' 0 []}';
BPM5={'mo' 'BPM5' 0 []}';
BPM6={'mo' 'BPM6' 0 []}';
BPM8={'mo' 'BPM8' 0 []}';
BPM9={'mo' 'BPM9' 0 []}';
BPM10={'mo' 'BPM10' 0 []}';
BPM11={'mo' 'BPM11' 0 []}';
BPM12={'mo' 'BPM12' 0 []}';
BPM13={'mo' 'BPM13' 0 []}';
BPM14={'mo' 'BPM14' 0 []}';
BPM15={'mo' 'BPM15' 0 []}';
BPMA11={'mo' 'BPMA11' 0 []}';
BPMA12={'mo' 'BPMA12' 0 []}';
BPMS11={'mo' 'BPMS11' 0 []}';
BPMM12={'mo' 'BPMM12' 0 []}';
BPMM14={'mo' 'BPMM14' 0 []}';
BPMS21={'mo' 'BPMS21' 0 []}';
BPMVM1={'mo' 'BPMVM1' 0 []}';
BPMVM2={'mo' 'BPMVM2' 0 []}';
BPMVB1={'mo' 'BPMVB1' 0 []}';
BPMVB2={'mo' 'BPMVB2' 0 []}';
BPMVB3={'mo' 'BPMVB3' 0 []}';
BPMVB4={'mo' 'BPMVB4' 0 []}';
BPMVM3={'mo' 'BPMVM3' 0 []}';
BPMVM4={'mo' 'BPMVM4' 0 []}';
BPMDL1={'mo' 'BPMDL1' 0 []}';
BPMDL2={'mo' 'BPMDL2' 0 []}';
BPMDL3={'mo' 'BPMDL3' 0 []}';
BPMDL4={'mo' 'BPMDL4' 0 []}';
BPMT12={'mo' 'BPMT12' 0 []}';
BPMT22={'mo' 'BPMT22' 0 []}';
BPMT32={'mo' 'BPMT32' 0 []}';
BPMT42={'mo' 'BPMT42' 0 []}';
BPME31={'mo' 'BPME31' 0 []}';
BPME32={'mo' 'BPME32' 0 []}';
BPME33={'mo' 'BPME33' 0 []}';
BPME34={'mo' 'BPME34' 0 []}';
BPME35={'mo' 'BPME35' 0 []}';
BPME36={'mo' 'BPME36' 0 []}';
BPMEM1={'mo' 'BPMEM1' 0 []}';
BPMEM2={'mo' 'BPMEM2' 0 []}';
BPMEM3={'mo' 'BPMEM3' 0 []}';
BPMEM4={'mo' 'BPMEM4' 0 []}';
BPMUM1={'mo' 'BPMUM1' 0 []}';
BPMUM2={'mo' 'BPMUM2' 0 []}';
BPMUM3={'mo' 'BPMUM3' 0 []}';
BPMUM4={'mo' 'BPMUM4' 0 []}';
RFB07={'mo' 'RFB07' 0 []}';
RFB08={'mo' 'RFB08' 0 []}';
BPMUE1={'mo' 'BPMUE1' 0 []}';
BPMUE2={'mo' 'BPMUE2' 0 []}';
BPMUE3={'mo' 'BPMUE3' 0 []}';
BPMQD={'mo' 'BPMQD' 0 []}';
BPMDD={'mo' 'BPMDD' 0 []}';
% Collimators
% ===========
CEDL1={'dr' 'CEDL1' 0.08 []}';% XSIZE (or YSIZE) is the collimator half-gap (Tungsten body with Nitanium-Nitrite surface?)
CEDL3={'dr' 'CEDL3' 0.08 []}';
CX31={'dr' 'CX31' 0.08 []}';% 2.2 mm half-gap in X and Y here (beta_max=67 m) keeps worst case radius: r = sqrt(x^2+y^2) < 2 mm in undulator (beta_max=35 m)
CY32={'dr' 'CY32' 0.08 []}';
CX35={'dr' 'CX35' 0.08 []}';
CY36={'dr' 'CY36' 0.08 []}';
%  CX37   : RCOL,L=0.08,XSIZE=2.3E-3,YSIZE=20E-3
%  CY38   : RCOL,L=0.08,YSIZE=3.2E-3,XSIZE=20E-3
DCX37={'dr' '' 0.08 []}';% de-scoped in 2007 until ?
DCY38={'dr' '' 0.08 []}';% de-scoped in 2007 until ?
TDUND={'mo' 'TDUND' 0 []}';%LTU insertable block at und. extension entrance (w/ screen)
LSTPR  = 0.3046;
ST0={'dr' '' LSTPR []}';%Empty can of uninstalled X-ray insertable stopper (was "ST1" in ~2007)
BTMST0={'dr' '' 0 []}';% Non-existent Burn-Through-Monitor behind empty ST0 can
ST1={'mo' 'ST1' LSTPR []}';%X-ray insertable stopper (was "ST2" in ~2007)
BTMST1={'mo' 'BTMST1' 0 []}';% Burn-Through-Monitor behind ST1
% ==============================================================================
% external files
% ------------------------------------------------------------------------------
% load idealized (design) L1, L2, and L3 lattices ...
%  CALL, FILENAME="LCLS_L1e.xsif"
%  CALL, FILENAME="LCLS_L2e.xsif"
%  CALL, FILENAME="LCLS_L3e.xsif"
% ... or actual (as built) L1, L2, and L3 lattices
% ==============================================================================
% 11-JAN-2007, P. Emma
%    Move QA11 a few mm as observed by alignment.
% 09-MAR-2006, P. Emma
%    Move SC11, SCA11, SCA12, and XC21202 and YC21203 per P. Stephens.
% 01-DEC-2005, P. Emma
%    Move XC21202 and YC21203 onto end of 21-1d.
% 29-NOV-2005, P. Emma
%    Add types for LCAV's.
% 09-NOV-2005, P. Emma
%    Use type-1 x/y corrector packages in L1-linac and relocate.
% 25-SEP-2005, P. Emma
%    Break L1 structure up to insert correctors at proper locations.
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L1 linac consists of:   1 9.4  ft S-band sections @ 50% power
%                             1 9.4  ft S-band sections @ 25% power
%                             1 10   ft S-band sections @ 25% power
% ------------------------------------------------------------------------------
DLB1    = 0.200+0.253432;
DLB2    = DLWL9-DLB1;
K21_1B1={'lc' 'K21_1B' DLB1 [SBANDF P50*GRADL1*DLB1 PHIL1*TWOPI]}';
K21_1B2={'lc' 'K21_1B' DLB2 [SBANDF P50*GRADL1*DLB2 PHIL1*TWOPI]}';
DLC1    = 0.200+0.2534458;
DLC2    = DLWL9-DLC1;
K21_1C1={'lc' 'K21_1C' DLC1 [SBANDF P25*GRADL1*DLC1 PHIL1*TWOPI]}';
K21_1C2={'lc' 'K21_1C' DLC2 [SBANDF P25*GRADL1*DLC2 PHIL1*TWOPI]}';
DLD1    = 0.200+0.1693348;
DLD2    = DLWL10-DLD1-DLD3-DLD4;
DLD3    = 0.300+0.167527-0.1799554;
DLD4    = 0.200+0.1799554;
K21_1D1={'lc' 'K21_1D' DLD1 [SBANDF P25*GRADL1*DLD1 PHIL1*TWOPI]}';
K21_1D2={'lc' 'K21_1D' DLD2 [SBANDF P25*GRADL1*DLD2 PHIL1*TWOPI]}';
K21_1D3={'lc' 'K21_1D' DLD3 [SBANDF P25*GRADL1*DLD3 PHIL1*TWOPI]}';
K21_1D4={'lc' 'K21_1D' DLD4 [SBANDF P25*GRADL1*DLD4 PHIL1*TWOPI]}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
L1=[L1BEG,ZLIN01,K21_1B1,SC11 ,K21_1B2,DAQA1,QA11,BPMA11,QA11,DAQA2,K21_1C1,SCA11,K21_1C2,DAQA3,QA12,BPMA12,QA12,DAQA4,K21_1D1,SCA12,K21_1D2,YC21203,K21_1D3,XC21202,K21_1D4,L1END];
% ==============================================================================

% ==============================================================================
% 11-SEP-2007, P. Emma
%    Replace WS21,22,23 with MARKer points DWS21-23 (no longer in baseline), and
%    add back 25-3d, 4d, and 5d sections (now 110 10-ft P25% sections & 1 P50%).
% 15-DEC-2006, P. Emma
%    Move WS21,22,23 upbeam by 4 feet each to reduce possible quad-reflected dark charge.
% 13-DEC-2006, P. Emma
%    Move (~6 in.) XC24202, YC24203, YC24403, YC24503, YC24603, XC24702 per T. Osier.
% 15-OCT-2006, P. Emma
%    Move WS21,22,23 for Jose Chan (DAQ6 becomes DAQ6A).
% 20-MAR-2006, P. Emma
%    Remove YCM15 from this file as should have been done back in Nov. 9, 2005.
% 29-NOV-2005, P. Emma
%    Add types for LCAV's, HKIC's, and VKIC's.
% 09-NOV-2005, P. Emma
%    Move YCM15 back into main LCLS file.
% 02-JUN-2005, P. Emma
%    Add comments adjacent to fast-feedback correctors
% 18-JAN-2005, P. Emma
%    Added the two 1%-calibrated correctors.
% 01-DEC-2004, P. Emma
%    Move YCM15 into this file from the main LCLS file (moved dnstr. by 0.401 m
%    and jumped over QM15 onto the L2 linac as a wrap-around corrector)
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L2 linac consists of: 110 10   ft S-band sections @ 25% power
%                             1 10   ft S-band sections @ 50% power
% ------------------------------------------------------------------------------
K21_3B1={'lc' 'K21_3B' 0.2672 [SBANDF P50*GRADL2*0.2672 PHIL2*TWOPI]}';
K21_3B2={'lc' 'K21_3B' 2.7769 [SBANDF P50*GRADL2*2.7769 PHIL2*TWOPI]}';
K21_3C={'lc' 'K21_3C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_3D={'lc' 'K21_3D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_4A1={'lc' 'K21_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K21_4A2={'lc' 'K21_4A' 0.3707 [SBANDF P25*GRADL2*0.3707 PHIL2*TWOPI]}';
K21_4A3={'lc' 'K21_4A' 2.3466 [SBANDF P25*GRADL2*2.3466 PHIL2*TWOPI]}';
K21_4B={'lc' 'K21_4B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_4C={'lc' 'K21_4C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_4D={'lc' 'K21_4D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_5A1={'lc' 'K21_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K21_5A2={'lc' 'K21_5A' 0.3778 [SBANDF P25*GRADL2*0.3778 PHIL2*TWOPI]}';
K21_5A3={'lc' 'K21_5A' 2.3339 [SBANDF P25*GRADL2*2.3339 PHIL2*TWOPI]}';
K21_5B={'lc' 'K21_5B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_5C={'lc' 'K21_5C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_5D={'lc' 'K21_5D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_6A1={'lc' 'K21_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K21_6A2={'lc' 'K21_6A' 0.3885 [SBANDF P25*GRADL2*0.3885 PHIL2*TWOPI]}';
K21_6A3={'lc' 'K21_6A' 2.3276 [SBANDF P25*GRADL2*2.3276 PHIL2*TWOPI]}';
K21_6B={'lc' 'K21_6B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_6C={'lc' 'K21_6C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_6D={'lc' 'K21_6D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_7A1={'lc' 'K21_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K21_7A2={'lc' 'K21_7A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_7A3={'lc' 'K21_7A' 2.4605 [SBANDF P25*GRADL2*2.4605 PHIL2*TWOPI]}';
K21_7B={'lc' 'K21_7B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_7C={'lc' 'K21_7C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_7D={'lc' 'K21_7D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_8A1={'lc' 'K21_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K21_8A2={'lc' 'K21_8A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_8A3={'lc' 'K21_8A' 2.4649 [SBANDF P25*GRADL2*2.4649 PHIL2*TWOPI]}';
K21_8B={'lc' 'K21_8B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_8C={'lc' 'K21_8C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K21_8D1={'lc' 'K21_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K21_8D2={'lc' 'K21_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_8D3={'lc' 'K21_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K22_1A={'lc' 'K22_1A' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_1B={'lc' 'K22_1B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_1C={'lc' 'K22_1C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_1D={'lc' 'K22_1D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_2A1={'lc' 'K22_2A' 0.3256 [SBANDF P25*GRADL2*0.3256 PHIL2*TWOPI]}';
K22_2A2={'lc' 'K22_2A' 0.3782 [SBANDF P25*GRADL2*0.3782 PHIL2*TWOPI]}';
K22_2A3={'lc' 'K22_2A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K22_2B={'lc' 'K22_2B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_2C={'lc' 'K22_2C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_2D={'lc' 'K22_2D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_3A1={'lc' 'K22_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K22_3A2={'lc' 'K22_3A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_3A3={'lc' 'K22_3A' 2.4629 [SBANDF P25*GRADL2*2.4629 PHIL2*TWOPI]}';
K22_3B={'lc' 'K22_3B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_3C={'lc' 'K22_3C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_3D={'lc' 'K22_3D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_4A1={'lc' 'K22_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K22_4A2={'lc' 'K22_4A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_4A3={'lc' 'K22_4A' 2.4673 [SBANDF P25*GRADL2*2.4673 PHIL2*TWOPI]}';
K22_4B={'lc' 'K22_4B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_4C={'lc' 'K22_4C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_4D={'lc' 'K22_4D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_5A1={'lc' 'K22_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K22_5A2={'lc' 'K22_5A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_5A3={'lc' 'K22_5A' 2.4617 [SBANDF P25*GRADL2*2.4617 PHIL2*TWOPI]}';
K22_5B={'lc' 'K22_5B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_5C={'lc' 'K22_5C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_5D={'lc' 'K22_5D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_6A1={'lc' 'K22_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K22_6A2={'lc' 'K22_6A' 0.3790 [SBANDF P25*GRADL2*0.3790 PHIL2*TWOPI]}';
K22_6A3={'lc' 'K22_6A' 2.3371 [SBANDF P25*GRADL2*2.3371 PHIL2*TWOPI]}';
K22_6B={'lc' 'K22_6B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_6C={'lc' 'K22_6C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_6D={'lc' 'K22_6D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_7A1={'lc' 'K22_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K22_7A2={'lc' 'K22_7A' 0.3829 [SBANDF P25*GRADL2*0.3829 PHIL2*TWOPI]}';
K22_7A3={'lc' 'K22_7A' 2.3276 [SBANDF P25*GRADL2*2.3276 PHIL2*TWOPI]}';
K22_7B={'lc' 'K22_7B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_7C={'lc' 'K22_7C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_7D={'lc' 'K22_7D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_8A1={'lc' 'K22_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K22_8A2={'lc' 'K22_8A' 0.3969 [SBANDF P25*GRADL2*0.3969 PHIL2*TWOPI]}';
K22_8A3={'lc' 'K22_8A' 2.3180 [SBANDF P25*GRADL2*2.3180 PHIL2*TWOPI]}';
K22_8B={'lc' 'K22_8B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_8C={'lc' 'K22_8C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K22_8D1={'lc' 'K22_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K22_8D2={'lc' 'K22_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_8D3={'lc' 'K22_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K23_1A={'lc' 'K23_1A' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_1B={'lc' 'K23_1B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_1C={'lc' 'K23_1C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_1D={'lc' 'K23_1D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_2A1={'lc' 'K23_2A' 0.3256 [SBANDF P25*GRADL2*0.3256 PHIL2*TWOPI]}';
K23_2A2={'lc' 'K23_2A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_2A3={'lc' 'K23_2A' 2.4685 [SBANDF P25*GRADL2*2.4685 PHIL2*TWOPI]}';
K23_2B={'lc' 'K23_2B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_2C={'lc' 'K23_2C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_2D={'lc' 'K23_2D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_3A1={'lc' 'K23_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K23_3A2={'lc' 'K23_3A' 0.3726 [SBANDF P25*GRADL2*0.3726 PHIL2*TWOPI]}';
K23_3A3={'lc' 'K23_3A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K23_3B={'lc' 'K23_3B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_3C={'lc' 'K23_3C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_3D={'lc' 'K23_3D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_4A1={'lc' 'K23_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K23_4A2={'lc' 'K23_4A' 0.3770 [SBANDF P25*GRADL2*0.3770 PHIL2*TWOPI]}';
K23_4A3={'lc' 'K23_4A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K23_4B={'lc' 'K23_4B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_4C={'lc' 'K23_4C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_4D={'lc' 'K23_4D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_5A1={'lc' 'K23_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K23_5A2={'lc' 'K23_5A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_5A3={'lc' 'K23_5A' 2.4617 [SBANDF P25*GRADL2*2.4617 PHIL2*TWOPI]}';
K23_5B={'lc' 'K23_5B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_5C={'lc' 'K23_5C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_5D={'lc' 'K23_5D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_6A1={'lc' 'K23_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K23_6A2={'lc' 'K23_6A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_6A3={'lc' 'K23_6A' 2.4661 [SBANDF P25*GRADL2*2.4661 PHIL2*TWOPI]}';
K23_6B={'lc' 'K23_6B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_6C={'lc' 'K23_6C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_6D={'lc' 'K23_6D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_7A1={'lc' 'K23_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K23_7A2={'lc' 'K23_7A' 0.3671 [SBANDF P25*GRADL2*0.3671 PHIL2*TWOPI]}';
K23_7A3={'lc' 'K23_7A' 2.3434 [SBANDF P25*GRADL2*2.3434 PHIL2*TWOPI]}';
K23_7B={'lc' 'K23_7B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_7C={'lc' 'K23_7C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_7D={'lc' 'K23_7D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_8A1={'lc' 'K23_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K23_8A2={'lc' 'K23_8A' 0.4064 [SBANDF P25*GRADL2*0.4064 PHIL2*TWOPI]}';
K23_8A3={'lc' 'K23_8A' 2.3085 [SBANDF P25*GRADL2*2.3085 PHIL2*TWOPI]}';
K23_8B={'lc' 'K23_8B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_8C={'lc' 'K23_8C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K23_8D1={'lc' 'K23_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K23_8D2={'lc' 'K23_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_8D3={'lc' 'K23_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K24_1A={'lc' 'K24_1A' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_1B={'lc' 'K24_1B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_1C={'lc' 'K24_1C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_1D={'lc' 'K24_1D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_2A1={'lc' 'K24_2A' 0.3716 [SBANDF P25*GRADL2*0.3256 PHIL2*TWOPI]}';
K24_2A2={'lc' 'K24_2A' 0.2810 [SBANDF P25*GRADL2*0.3497 PHIL2*TWOPI]}';
K24_2A3={'lc' 'K24_2A' 2.3915 [SBANDF P25*GRADL2*2.3688 PHIL2*TWOPI]}';
K24_2B={'lc' 'K24_2B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_2C={'lc' 'K24_2C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_2D={'lc' 'K24_2D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_3A1={'lc' 'K24_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K24_3A2={'lc' 'K24_3A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K24_3A3={'lc' 'K24_3A' 2.4629 [SBANDF P25*GRADL2*2.4629 PHIL2*TWOPI]}';
K24_3B={'lc' 'K24_3B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_3C={'lc' 'K24_3C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_3D={'lc' 'K24_3D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_4A1={'lc' 'K24_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K24_4A2={'lc' 'K24_4A' 0.3048 [SBANDF P25*GRADL2*0.3707 PHIL2*TWOPI]}';
K24_4A3={'lc' 'K24_4A' 2.4125 [SBANDF P25*GRADL2*2.3466 PHIL2*TWOPI]}';
K24_4B={'lc' 'K24_4B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_4C={'lc' 'K24_4C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_4D={'lc' 'K24_4D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_5A1={'lc' 'K24_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K24_5A2={'lc' 'K24_5A' 0.3048 [SBANDF P25*GRADL2*0.3619 PHIL2*TWOPI]}';
K24_5A3={'lc' 'K24_5A' 2.4069 [SBANDF P25*GRADL2*2.3498 PHIL2*TWOPI]}';
K24_5B={'lc' 'K24_5B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_5C={'lc' 'K24_5C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_5D={'lc' 'K24_5D' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_6A1={'lc' 'K24_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K24_6A2={'lc' 'K24_6A' 0.3048 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K24_6A3={'lc' 'K24_6A' 2.4113 [SBANDF P25*GRADL2*2.4661 PHIL2*TWOPI]}';
K24_6B={'lc' 'K24_6B' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_6C={'lc' 'K24_6C' 3.0441 [SBANDF P25*GRADL2*3.0441 PHIL2*TWOPI]}';
K24_6D1={'lc' 'K24_6D' 2.3321 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K24_6D2={'lc' 'K24_6D' 0.3048 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K24_6D3={'lc' 'K24_6D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC21402={'mo' 'XC21402' 0 []}';% fast-feedback (loop-2)
XC21502={'mo' 'XC21502' 0 []}';
XC21602={'mo' 'XC21602' 0 []}';
XC21702={'mo' 'XC21702' 0 []}';
XC21802={'mo' 'XC21802' 0 []}';% fast-feedback (loop-2)
XC21900={'mo' 'XC21900' 0 []}';
XC22202={'mo' 'XC22202' 0 []}';
XC22302={'mo' 'XC22302' 0 []}';
XC22402={'mo' 'XC22402' 0 []}';
XC22502={'mo' 'XC22502' 0 []}';
XC22602={'mo' 'XC22602' 0 []}';
XC22702={'mo' 'XC22702' 0 []}';
XC22802={'mo' 'XC22802' 0 []}';
XC22900={'mo' 'XC22900' 0 []}';
XC23202={'mo' 'XC23202' 0 []}';
XC23302={'mo' 'XC23302' 0 []}';
XC23402={'mo' 'XC23402' 0 []}';
XC23502={'mo' 'XC23502' 0 []}';
XC23602={'mo' 'XC23602' 0 []}';
XC23702={'mo' 'XC23702' 0 []}';
XC23802={'mo' 'XC23802' 0 []}';
XC23900={'mo' 'XC23900' 0 []}';
XC24202={'mo' 'XC24202' 0 []}';
XC24302={'mo' 'XC24302' 0 []}';
XC24402={'mo' 'XC24402' 0 []}';
XC24502={'mo' 'XC24502' 0 []}';
XC24602={'mo' 'XC24602' 0 []}';
XC24702={'mo' 'XC24702' 0 []}';% calibrated to <1%
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC21403={'mo' 'YC21403' 0 []}';
YC21503={'mo' 'YC21503' 0 []}';% fast-feedback (loop-2)
YC21603={'mo' 'YC21603' 0 []}';
YC21703={'mo' 'YC21703' 0 []}';
YC21803={'mo' 'YC21803' 0 []}';
YC21900={'mo' 'YC21900' 0 []}';% fast-feedback (loop-2)
YC22203={'mo' 'YC22203' 0 []}';
YC22303={'mo' 'YC22303' 0 []}';
YC22403={'mo' 'YC22403' 0 []}';
YC22503={'mo' 'YC22503' 0 []}';
YC22603={'mo' 'YC22603' 0 []}';
YC22703={'mo' 'YC22703' 0 []}';
YC22803={'mo' 'YC22803' 0 []}';
YC22900={'mo' 'YC22900' 0 []}';
YC23203={'mo' 'YC23203' 0 []}';
YC23303={'mo' 'YC23303' 0 []}';
YC23403={'mo' 'YC23403' 0 []}';
YC23503={'mo' 'YC23503' 0 []}';
YC23603={'mo' 'YC23603' 0 []}';
YC23703={'mo' 'YC23703' 0 []}';
YC23803={'mo' 'YC23803' 0 []}';
YC23900={'mo' 'YC23900' 0 []}';
YC24203={'mo' 'YC24203' 0 []}';
YC24303={'mo' 'YC24303' 0 []}';
YC24403={'mo' 'YC24403' 0 []}';
YC24503={'mo' 'YC24503' 0 []}';
YC24603={'mo' 'YC24603' 0 []}';
YC24703={'mo' 'YC24703' 0 []}';% calibrated to <1%
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K21_3=[K21_3B1,K21_3B2,K21_3C ,K21_3D];
K21_4=[K21_4A1,XC21402,K21_4A2,YC21403,K21_4A3,K21_4B,K21_4C,K21_4D];
K21_5=[K21_5A1,XC21502,K21_5A2,YC21503,K21_5A3,K21_5B,K21_5C,K21_5D];
K21_6=[K21_6A1,XC21602,K21_6A2,YC21603,K21_6A3,K21_6B,K21_6C,K21_6D];
K21_7=[K21_7A1,XC21702,K21_7A2,YC21703,K21_7A3,K21_7B,K21_7C,K21_7D];
K21_8=[K21_8A1,XC21802,K21_8A2,YC21803,K21_8A3,K21_8B,K21_8C,K21_8D1,XC21900,K21_8D2,YC21900,K21_8D3];
LI21=[LI21BEG,ZLIN04,K21_3,DAQ1,Q21401,BPM21401,Q21401,DAQ2,K21_4,DAQ1,Q21501,BPM21501,Q21501,DAQ2,K21_5,DAQ1,Q21601,BPM21601,Q21601,DAQ2,K21_6,DAQ1,Q21701,BPM21701,Q21701,DAQ2,K21_7,DAQ1,Q21801,BPM21801,Q21801,DAQ2,K21_8,DAQ3,Q21901,BPM21901,Q21901,DAQ4,LI21END];
% ------------------------------------------------------------------------------
K22_1=[K22_1A,K22_1B,K22_1C,K22_1D];
K22_2=[K22_2A1,XC22202,K22_2A2,YC22203,K22_2A3,K22_2B,K22_2C,K22_2D];
K22_3=[K22_3A1,XC22302,K22_3A2,YC22303,K22_3A3,K22_3B,K22_3C,K22_3D];
K22_4=[K22_4A1,XC22402,K22_4A2,YC22403,K22_4A3,K22_4B,K22_4C,K22_4D];
K22_5=[K22_5A1,XC22502,K22_5A2,YC22503,K22_5A3,K22_5B,K22_5C,K22_5D];
K22_6=[K22_6A1,XC22602,K22_6A2,YC22603,K22_6A3,K22_6B,K22_6C,K22_6D];
K22_7=[K22_7A1,XC22702,K22_7A2,YC22703,K22_7A3,K22_7B,K22_7C,K22_7D];
K22_8=[K22_8A1,XC22802,K22_8A2,YC22803,K22_8A3,K22_8B,K22_8C,K22_8D1,XC22900,K22_8D2,YC22900,K22_8D3];
LI22=[LI22BEG,ZLIN05,K22_1,DAQ1,Q22201,BPM22201,Q22201,DAQ2,K22_2,DAQ1,Q22301,BPM22301,Q22301,DAQ2,K22_3,DAQ1,Q22401,BPM22401,Q22401,DAQ2,K22_4,DAQ1,Q22501,BPM22501,Q22501,DAQ2,K22_5,DAQ1,Q22601,BPM22601,Q22601,DAQ2,K22_6,DAQ1,Q22701,BPM22701,Q22701,DAQ2,K22_7,DAQ1,Q22801,BPM22801,Q22801,DAQ2,K22_8,DAQ3,Q22901,BPM22901,Q22901,DAQ4,LI22END];
% ------------------------------------------------------------------------------
K23_1=[K23_1A,K23_1B,K23_1C,K23_1D];
K23_2=[K23_2A1,XC23202,K23_2A2,YC23203,K23_2A3,K23_2B,K23_2C,K23_2D];
K23_3=[K23_3A1,XC23302,K23_3A2,YC23303,K23_3A3,K23_3B,K23_3C,K23_3D];
K23_4=[K23_4A1,XC23402,K23_4A2,YC23403,K23_4A3,K23_4B,K23_4C,K23_4D];
K23_5=[K23_5A1,XC23502,K23_5A2,YC23503,K23_5A3,K23_5B,K23_5C,K23_5D];
K23_6=[K23_6A1,XC23602,K23_6A2,YC23603,K23_6A3,K23_6B,K23_6C,K23_6D];
K23_7=[K23_7A1,XC23702,K23_7A2,YC23703,K23_7A3,K23_7B,K23_7C,K23_7D];
K23_8=[K23_8A1,XC23802,K23_8A2,YC23803,K23_8A3,K23_8B,K23_8C,K23_8D1,XC23900,K23_8D2,YC23900,K23_8D3];
LI23=[LI23BEG,ZLIN06,K23_1,DAQ1,Q23201,BPM23201,Q23201,DAQ2,K23_2,DAQ1,Q23301,BPM23301,Q23301,DAQ2,K23_3,DAQ1,Q23401,BPM23401,Q23401,DAQ2,K23_4,DAQ1,Q23501,BPM23501,Q23501,DAQ2,K23_5,DAQ1,Q23601,BPM23601,Q23601,DAQ2,K23_6,DAQ1,Q23701,BPM23701,Q23701,DAQ2,K23_7,DAQ1,Q23801,BPM23801,Q23801,DAQ2,K23_8,DAQ3,Q23901,BPM23901,Q23901,DAQ4,LI23END];
% ------------------------------------------------------------------------------
K24_1=[K24_1A,K24_1B,K24_1C,K24_1D];
K24_2=[K24_2A1,XC24202,K24_2A2,YC24203,K24_2A3,K24_2B,K24_2C,K24_2D];
%  K24_3 : LINE=(K24_3a1,XC24302,K24_3a2,YC24303,K24_3a3,K24_3b,K24_3c)    WS21 descoped in 2007
%  K24_4 : LINE=(K24_4a1,XC24402,K24_4a2,YC24403,K24_4a3,K24_4b,K24_4c)    WS22 descoped in 2007
%  K24_5 : LINE=(K24_5a1,XC24502,K24_5a2,YC24503,K24_5a3,K24_5b,K24_5c)    WS23 descoped in 2007
K24_3=[K24_3A1,XC24302,K24_3A2,YC24303,K24_3A3,K24_3B,K24_3C,K24_3D];% WS21 descoped in 2007
K24_4=[K24_4A1,XC24402,K24_4A2,YC24403,K24_4A3,K24_4B,K24_4C,K24_4D];% WS22 descoped in 2007
K24_5=[K24_5A1,XC24502,K24_5A2,YC24503,K24_5A3,K24_5B,K24_5C,K24_5D];% WS23 descoped in 2007
K24_6=[K24_6A1,XC24602,K24_6A2,YC24603,K24_6A3,K24_6B,K24_6C,K24_6D1,XC24702,K24_6D2,YC24703,K24_6D3];
LI24=[LI24BEG,ZLIN07,K24_1,DAQ1,Q24201,BPM24201,Q24201,DAQ2,K24_2,DAQ1,Q24301,BPM24301,Q24301,DAQ2,K24_3,DAQ1,Q24401,BPM24401,Q24401,DAQ2,K24_4,DAQ1,Q24501,BPM24501,Q24501,DAQ2,K24_5,DAQ1,Q24601,BPM24601,Q24601,DAQ2,K24_6,LI24END];% WS21 descoped in 2007
%                K24_3,DAQ5,DWS21,DAQ6A,Q24401,BPM24401,Q24401,DAQ2,&    WS21 descoped in 2007
%                K24_4,DAQ5,DWS22,DAQ6A,Q24501,BPM24501,Q24501,DAQ2,&    WS22 descoped in 2007
%                K24_5,DAQ5,DWS23,DAQ6A,Q24601,BPM24601,Q24601,DAQ2,&    WS23 descoped in 2007
% ==============================================================================

% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L3 linac consists of: 161 10   ft S-band sections @ 25% power
%                            12 10   ft S-band sections @ 50% power
%                             3  9.4 ft S-band sections @ 25% power
%                             4  7   ft S-band sections @ 25% power
% ------------------------------------------------------------------------------
% 24-OCT-2008, M. Woodley
%    Change XC29092, YC29092, XC29095, and YC29095 to MARK ... the physical
%    devices are still there, but they won't be used
% 18-SEP-2008, M. Woodley
%    Fixed structure counts in header comments
% 17-AUG-2008, P. Emma
%    K25_1d was changed back to LCAVITY (from D25_1d) and uses P50 (should since Jan. 2008)
%    K25_3c LCAVITY was changed to use P50 (should since Jan. 2008)
%    K28_5c LCAVITY was changed to use P50 (should since Jan. 2008)
% 02-JAN-2008, P. Emma
%    Rename sec-28 wires (WS044 -> WS27644, WS144 -> WS28144,
%    WS444 -> WS28444, WS544 -> WS28744).
% 04-NOV-2007, P. Emma
%    Move XC25502 & YC25503 to downstream of Q25501, as they should be (were upstream).
%    Remove XC29090, YC29090, XC29096, and YC29096 correctors (not installed).
% 04-OCT-2007, P. Emma
%    Remove D25cm from upbeam of TCAV3 and replace with 25-cm longer D255c, which
%    was negative
% 11-SEP-2007, P. Emma
%    Move BL22 from near BX24 to just upbeam of OTR22 & remove 25_1c, 1d, and
%    28-5d (these no longer re-installed into linac due to money limits).
% 10-DEC-2006, P. Emma
%    Move BXKIK to 25-3d where it will fit after removing the 25-3d RF acc.
%    structure.  Also add OTR22 near BXKIK.
% 03-DEC-2006, P. Emma
%    Move IMBC2O toroid to upbeam of BXKIK (from QM22 area).
% 02-AUG-2006, M. Woodley
%    Reinstate LI30 wraparound quads (QUAD LI30 615 and QUAD LI30 715) as
%    quadrupoles (NOTE: uses negative drifts)
% 29-NOV-2005, P. Emma
%    Add types for LCAV's, HKIC's, and VKIC's.
% 13-JUL-2005, P. Emma
%    Move TCAV3 to 25-2d for better sigZ resolution (was 25-5a).  Restored 25-5a
%    and removed 25-2d.
% 06-JUL-2005, P. Emma
%    Rename TCAVH to TCAV3.
% 02-JUN-2005, P. Emma
%    Add comments adjacent to fast-feedback correctors.
% ------------------------------------------------------------------------------
K25_1A1={'lc' 'K25_1A' 0.3250 [SBANDF P25*GRADL3*0.3250 PHIL3*TWOPI]}';
K25_1A2={'lc' 'K25_1A' 0.3250 [SBANDF P25*GRADL3*0.3250 PHIL3*TWOPI]}';
K25_1A3={'lc' 'K25_1A' 2.3941 [SBANDF P25*GRADL3*2.3941 PHIL3*TWOPI]}';
K25_1B={'lc' 'K25_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
%  K25_1c  : LCAV, FREQ=SbandF, L=3.0441, DELTAE=P25*gradL3*3.0441, PHI0=PhiL3, &
%                  TYPE="10ft"
D25_1C={'dr' '' 3.0441 []}';
K25_1D={'lc' 'K25_1D' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
%  D25_1d  : DRIFT,L=3.0441
K25_2A1={'lc' 'K25_2A' 0.4530 [SBANDF P25*GRADL3*0.4530 PHIL3*TWOPI]}';
K25_2A2={'lc' 'K25_2A' 0.3175 [SBANDF P25*GRADL3*0.3175 PHIL3*TWOPI]}';
K25_2A3={'lc' 'K25_2A' 2.2736 [SBANDF P25*GRADL3*2.2736 PHIL3*TWOPI]}';
K25_2B={'lc' 'K25_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_2C={'lc' 'K25_2C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_3A1={'lc' 'K25_3A' 0.3312 [SBANDF P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K25_3A2={'lc' 'K25_3A' 0.3504 [SBANDF P25*GRADL3*0.3504 PHIL3*TWOPI]}';
K25_3A3={'lc' 'K25_3A' 2.3625 [SBANDF P25*GRADL3*2.3625 PHIL3*TWOPI]}';
K25_3B={'lc' 'K25_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_3C={'lc' 'K25_3C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_4A1={'lc' 'K25_4A' 0.3268 [SBANDF P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K25_4A2={'lc' 'K25_4A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_4A3={'lc' 'K25_4A' 2.4673 [SBANDF P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K25_4B={'lc' 'K25_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_4C={'lc' 'K25_4C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_4D={'lc' 'K25_4D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_5A1={'lc' 'K25_5A' 0.3268 [SBANDF P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K25_5A2={'lc' 'K25_5A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_5A3={'lc' 'K25_5A' 2.4673 [SBANDF P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K25_5B={'lc' 'K25_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_5C={'lc' 'K25_5C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_5D={'lc' 'K25_5D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_6A1={'lc' 'K25_6A' 0.3280 [SBANDF P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K25_6A2={'lc' 'K25_6A' 0.3822 [SBANDF P25*GRADL3*0.3822 PHIL3*TWOPI]}';
K25_6A3={'lc' 'K25_6A' 2.3339 [SBANDF P25*GRADL3*2.3339 PHIL3*TWOPI]}';
K25_6B={'lc' 'K25_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_6C={'lc' 'K25_6C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_6D={'lc' 'K25_6D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_7A1={'lc' 'K25_7A' 0.3336 [SBANDF P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K25_7A2={'lc' 'K25_7A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_7A3={'lc' 'K25_7A' 2.4605 [SBANDF P25*GRADL3*2.4605 PHIL3*TWOPI]}';
K25_7B={'lc' 'K25_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_7C={'lc' 'K25_7C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_7D={'lc' 'K25_7D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_8A1={'lc' 'K25_8A' 0.3292 [SBANDF P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K25_8A2={'lc' 'K25_8A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_8A3={'lc' 'K25_8A' 2.4649 [SBANDF P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K25_8B={'lc' 'K25_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_8C={'lc' 'K25_8C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K25_8D1={'lc' 'K25_8D' 2.3869 [SBANDF P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K25_8D2={'lc' 'K25_8D' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_8D3={'lc' 'K25_8D' 0.4072 [SBANDF P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K26_1A={'lc' 'K26_1A' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_1B={'lc' 'K26_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_1C={'lc' 'K26_1C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_1D={'lc' 'K26_1D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_2A1={'lc' 'K26_2A' 0.3256 [SBANDF P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K26_2A2={'lc' 'K26_2A' 0.3719 [SBANDF P25*GRADL3*0.3719 PHIL3*TWOPI]}';
K26_2A3={'lc' 'K26_2A' 2.3466 [SBANDF P25*GRADL3*2.3466 PHIL3*TWOPI]}';
K26_2B={'lc' 'K26_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_2C={'lc' 'K26_2C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_2D={'lc' 'K26_2D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_3A1={'lc' 'K26_3A' 0.3312 [SBANDF P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K26_3A2={'lc' 'K26_3A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_3A3={'lc' 'K26_3A' 2.4629 [SBANDF P25*GRADL3*2.4629 PHIL3*TWOPI]}';
K26_3B={'lc' 'K26_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_3C={'lc' 'K26_3C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_3D={'lc' 'K26_3D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_4A1={'lc' 'K26_4A' 0.3268 [SBANDF P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K26_4A2={'lc' 'K26_4A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_4A3={'lc' 'K26_4A' 2.4673 [SBANDF P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K26_4B={'lc' 'K26_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_4C={'lc' 'K26_4C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_4D={'lc' 'K26_4D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_5A1={'lc' 'K26_5A' 0.3324 [SBANDF P25*GRADL3*0.3324 PHIL3*TWOPI]}';
K26_5A2={'lc' 'K26_5A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_5A3={'lc' 'K26_5A' 2.4617 [SBANDF P25*GRADL3*2.4617 PHIL3*TWOPI]}';
K26_5B={'lc' 'K26_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_5C={'lc' 'K26_5C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_5D={'lc' 'K26_5D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_6A1={'lc' 'K26_6A' 0.3280 [SBANDF P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K26_6A2={'lc' 'K26_6A' 0.4108 [SBANDF P25*GRADL3*0.4108 PHIL3*TWOPI]}';
K26_6A3={'lc' 'K26_6A' 2.3053 [SBANDF P25*GRADL3*2.3053 PHIL3*TWOPI]}';
K26_6B={'lc' 'K26_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_6C={'lc' 'K26_6C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_6D={'lc' 'K26_6D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_7A1={'lc' 'K26_7A' 0.3336 [SBANDF P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K26_7A2={'lc' 'K26_7A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_7A3={'lc' 'K26_7A' 2.4605 [SBANDF P25*GRADL3*2.4605 PHIL3*TWOPI]}';
K26_7B={'lc' 'K26_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_7C={'lc' 'K26_7C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_7D={'lc' 'K26_7D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_8A1={'lc' 'K26_8A' 0.3292 [SBANDF P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K26_8A2={'lc' 'K26_8A' 0.3810 [SBANDF P25*GRADL3*0.3810 PHIL3*TWOPI]}';
K26_8A3={'lc' 'K26_8A' 2.3339 [SBANDF P25*GRADL3*2.3339 PHIL3*TWOPI]}';
K26_8B={'lc' 'K26_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_8C={'lc' 'K26_8C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K26_8D1={'lc' 'K26_8D' 2.3869 [SBANDF P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K26_8D2={'lc' 'K26_8D' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_8D3={'lc' 'K26_8D' 0.4072 [SBANDF P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K27_1A={'lc' 'K27_1A' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_1B={'lc' 'K27_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_1C={'lc' 'K27_1C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_1D={'lc' 'K27_1D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_2A1={'lc' 'K27_2A' 0.3256 [SBANDF P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K27_2A2={'lc' 'K27_2A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_2A3={'lc' 'K27_2A' 2.4685 [SBANDF P25*GRADL3*2.4685 PHIL3*TWOPI]}';
K27_2B={'lc' 'K27_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_2C={'lc' 'K27_2C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_2D={'lc' 'K27_2D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_3A1={'lc' 'K27_3A' 0.3312 [SBANDF P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K27_3A2={'lc' 'K27_3A' 0.3695 [SBANDF P25*GRADL3*0.3695 PHIL3*TWOPI]}';
K27_3A3={'lc' 'K27_3A' 2.3434 [SBANDF P25*GRADL3*2.3434 PHIL3*TWOPI]}';
K27_3B={'lc' 'K27_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_3C={'lc' 'K27_3C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_3D={'lc' 'K27_3D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_4A1={'lc' 'K27_4A' 0.3268 [SBANDF P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K27_4A2={'lc' 'K27_4A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_4A3={'lc' 'K27_4A' 2.4673 [SBANDF P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K27_4B={'lc' 'K27_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_4C={'lc' 'K27_4C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_4D={'lc' 'K27_4D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_5A1={'lc' 'K27_5A' 0.3324 [SBANDF P25*GRADL3*0.3324 PHIL3*TWOPI]}';
K27_5A2={'lc' 'K27_5A' 0.3683 [SBANDF P25*GRADL3*0.3683 PHIL3*TWOPI]}';
K27_5A3={'lc' 'K27_5A' 2.3434 [SBANDF P25*GRADL3*2.3434 PHIL3*TWOPI]}';
K27_5B={'lc' 'K27_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_5C={'lc' 'K27_5C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_5D={'lc' 'K27_5D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_6A1={'lc' 'K27_6A' 0.3280 [SBANDF P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K27_6A2={'lc' 'K27_6A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_6A3={'lc' 'K27_6A' 2.4661 [SBANDF P25*GRADL3*2.4661 PHIL3*TWOPI]}';
K27_6B={'lc' 'K27_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_6C={'lc' 'K27_6C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_7A1={'lc' 'K27_7A' 0.3336 [SBANDF P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K27_7A2={'lc' 'K27_7A' 0.3512 [SBANDF P25*GRADL3*0.3512 PHIL3*TWOPI]}';
K27_7A3={'lc' 'K27_7A' 2.3593 [SBANDF P25*GRADL3*2.3593 PHIL3*TWOPI]}';
K27_7B={'lc' 'K27_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_7C={'lc' 'K27_7C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_7D={'lc' 'K27_7D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_8A1={'lc' 'K27_8A' 0.3292 [SBANDF P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K27_8A2={'lc' 'K27_8A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_8A3={'lc' 'K27_8A' 2.4649 [SBANDF P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K27_8B={'lc' 'K27_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_8C={'lc' 'K27_8C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K27_8D1={'lc' 'K27_8D' 2.2411 [SBANDF P25*GRADL3*2.2411 PHIL3*TWOPI]}';
K27_8D2={'lc' 'K27_8D' 0.3958 [SBANDF P25*GRADL3*0.3958 PHIL3*TWOPI]}';
K27_8D3={'lc' 'K27_8D' 0.4072 [SBANDF P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K28_1A={'lc' 'K28_1A' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_1B={'lc' 'K28_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_1C={'lc' 'K28_1C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_2A1={'lc' 'K28_2A' 0.3256 [SBANDF P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K28_2A2={'lc' 'K28_2A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_2A3={'lc' 'K28_2A' 2.4685 [SBANDF P25*GRADL3*2.4685 PHIL3*TWOPI]}';
K28_2B={'lc' 'K28_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_2C={'lc' 'K28_2C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_2D={'lc' 'K28_2D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_3A1={'lc' 'K28_3A' 0.3312 [SBANDF P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K28_3A2={'lc' 'K28_3A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_3A3={'lc' 'K28_3A' 2.4629 [SBANDF P25*GRADL3*2.4629 PHIL3*TWOPI]}';
K28_3B={'lc' 'K28_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_3C={'lc' 'K28_3C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_3D={'lc' 'K28_3D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_4A1={'lc' 'K28_4A' 0.3800 [SBANDF P25*GRADL3*0.3800 PHIL3*TWOPI]}';
K28_4A2={'lc' 'K28_4A' 0.2921 [SBANDF P25*GRADL3*0.2921 PHIL3*TWOPI]}';
K28_4A3={'lc' 'K28_4A' 2.3720 [SBANDF P25*GRADL3*2.3720 PHIL3*TWOPI]}';
K28_4B={'lc' 'K28_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_4C={'lc' 'K28_4C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_5A1={'lc' 'K28_5A' 0.3959 [SBANDF P25*GRADL3*0.3959 PHIL3*TWOPI]}';
K28_5A2={'lc' 'K28_5A' 0.3111 [SBANDF P25*GRADL3*0.3111 PHIL3*TWOPI]}';
K28_5A3={'lc' 'K28_5A' 2.3371 [SBANDF P25*GRADL3*2.3371 PHIL3*TWOPI]}';
K28_5B={'lc' 'K28_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_5C={'lc' 'K28_5C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
%  K28_5d  : LCAV, FREQ=SbandF, L=3.0441, DELTAE=P25*gradL3*3.0441, PHI0=PhiL3, &
%                  TYPE="10ft"
D28_5D={'dr' '' 3.0441 []}';
K28_6A1={'lc' 'K28_6A' 0.3280 [SBANDF P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K28_6A2={'lc' 'K28_6A' 0.3600 [SBANDF P25*GRADL3*0.3600 PHIL3*TWOPI]}';
K28_6A3={'lc' 'K28_6A' 2.3561 [SBANDF P25*GRADL3*2.3561 PHIL3*TWOPI]}';
K28_6B={'lc' 'K28_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_6C={'lc' 'K28_6C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_6D={'lc' 'K28_6D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_7A1={'lc' 'K28_7A' 0.3336 [SBANDF P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K28_7A2={'lc' 'K28_7A' 0.4052 [SBANDF P25*GRADL3*0.4052 PHIL3*TWOPI]}';
K28_7A3={'lc' 'K28_7A' 2.3053 [SBANDF P25*GRADL3*2.3053 PHIL3*TWOPI]}';
K28_7B={'lc' 'K28_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_7C={'lc' 'K28_7C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_8A1={'lc' 'K28_8A' 0.3292 [SBANDF P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K28_8A2={'lc' 'K28_8A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_8A3={'lc' 'K28_8A' 2.4649 [SBANDF P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K28_8B={'lc' 'K28_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_8C={'lc' 'K28_8C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K28_8D1={'lc' 'K28_8D' 2.3869 [SBANDF P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K28_8D2={'lc' 'K28_8D' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_8D3={'lc' 'K28_8D' 0.4072 [SBANDF P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K29_1A={'lc' 'K29_1A' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_1B={'lc' 'K29_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_1C={'lc' 'K29_1C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_2A1={'lc' 'K29_2A' 0.3256 [SBANDF P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K29_2A2={'lc' 'K29_2A' 0.3528 [SBANDF P25*GRADL3*0.3528 PHIL3*TWOPI]}';
K29_2A3={'lc' 'K29_2A' 2.3657 [SBANDF P25*GRADL3*2.3657 PHIL3*TWOPI]}';
K29_2B={'lc' 'K29_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_2C={'lc' 'K29_2C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_2D={'lc' 'K29_2D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_3A1={'lc' 'K29_3A' 0.3312 [SBANDF P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K29_3A2={'lc' 'K29_3A' 0.3599 [SBANDF P25*GRADL3*0.3599 PHIL3*TWOPI]}';
K29_3A3={'lc' 'K29_3A' 2.3530 [SBANDF P25*GRADL3*2.3530 PHIL3*TWOPI]}';
K29_3B={'lc' 'K29_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_3C={'lc' 'K29_3C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_3D={'lc' 'K29_3D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_4A1={'lc' 'K29_4A' 0.3268 [SBANDF P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K29_4A2={'lc' 'K29_4A' 0.2500 [SBANDF P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K29_4A3={'lc' 'K29_4A' 2.4673 [SBANDF P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K29_4B={'lc' 'K29_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_4C={'lc' 'K29_4C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_5A1={'lc' 'K29_5A' 0.3800 [SBANDF P25*GRADL3*0.3800 PHIL3*TWOPI]}';
K29_5A2={'lc' 'K29_5A' 0.2762 [SBANDF P25*GRADL3*0.2762 PHIL3*TWOPI]}';
K29_5A3={'lc' 'K29_5A' 2.3879 [SBANDF P25*GRADL3*2.3879 PHIL3*TWOPI]}';
K29_5B={'lc' 'K29_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_5C={'lc' 'K29_5C' 3.0441 [SBANDF P50*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_6A1={'lc' 'K29_6A' 0.4498 [SBANDF P25*GRADL3*0.4498 PHIL3*TWOPI]}';
K29_6A2={'lc' 'K29_6A' 0.3715 [SBANDF P25*GRADL3*0.3715 PHIL3*TWOPI]}';
K29_6A3={'lc' 'K29_6A' 2.2228 [SBANDF P25*GRADL3*2.2228 PHIL3*TWOPI]}';
K29_6B={'lc' 'K29_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_6C={'lc' 'K29_6C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_6D={'lc' 'K29_6D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_7A1={'lc' 'K29_7A' 0.3336 [SBANDF P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K29_7A2={'lc' 'K29_7A' 0.3988 [SBANDF P25*GRADL3*0.3988 PHIL3*TWOPI]}';
K29_7A3={'lc' 'K29_7A' 2.3117 [SBANDF P25*GRADL3*2.3117 PHIL3*TWOPI]}';
K29_7B={'lc' 'K29_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_7C={'lc' 'K29_7C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_7D={'lc' 'K29_7D' 2.8692 [SBANDF P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K29_8A1={'lc' 'K29_8A' 0.3896 [SBANDF P25*GRADL3*0.3896 PHIL3*TWOPI]}';
K29_8A2={'lc' 'K29_8A' 0.2790 [SBANDF P25*GRADL3*0.2790 PHIL3*TWOPI]}';
K29_8A3={'lc' 'K29_8A' 2.3755 [SBANDF P25*GRADL3*2.3755 PHIL3*TWOPI]}';
K29_8B={'lc' 'K29_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_8C={'lc' 'K29_8C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K29_8D1={'lc' 'K29_8D' 2.4558 [SBANDF P25*GRADL3*2.4558 PHIL3*TWOPI]}';
K29_8D2={'lc' 'K29_8D' 0.2800 [SBANDF P25*GRADL3*0.2800 PHIL3*TWOPI]}';
K29_8D3={'lc' 'K29_8D' 0.3083 [SBANDF P25*GRADL3*0.3083 PHIL3*TWOPI]}';
K30_1A={'lc' 'K30_1A' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_1B={'lc' 'K30_1B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_1C={'lc' 'K30_1C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_1D={'lc' 'K30_1D' 2.1694 [SBANDF P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_2A1={'lc' 'K30_2A' 0.5006 [SBANDF P25*GRADL3*0.5006 PHIL3*TWOPI]}';
K30_2A2={'lc' 'K30_2A' 0.3302 [SBANDF P25*GRADL3*0.3302 PHIL3*TWOPI]}';
K30_2A3={'lc' 'K30_2A' 2.2133 [SBANDF P25*GRADL3*2.2133 PHIL3*TWOPI]}';
K30_2B={'lc' 'K30_2B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_2C={'lc' 'K30_2C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_2D={'lc' 'K30_2D' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_3A1={'lc' 'K30_3A' 0.3986 [SBANDF P25*GRADL3*0.3986 PHIL3*TWOPI]}';
K30_3A2={'lc' 'K30_3A' 0.3300 [SBANDF P25*GRADL3*0.3300 PHIL3*TWOPI]}';
K30_3A3={'lc' 'K30_3A' 2.3155 [SBANDF P25*GRADL3*2.3155 PHIL3*TWOPI]}';
K30_3B={'lc' 'K30_3B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_3C={'lc' 'K30_3C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_3D={'lc' 'K30_3D' 2.1694 [SBANDF P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_4A1={'lc' 'K30_4A' 0.3856 [SBANDF P25*GRADL3*0.3856 PHIL3*TWOPI]}';
K30_4A2={'lc' 'K30_4A' 0.2790 [SBANDF P25*GRADL3*0.2790 PHIL3*TWOPI]}';
K30_4A3={'lc' 'K30_4A' 2.3795 [SBANDF P25*GRADL3*2.3795 PHIL3*TWOPI]}';
K30_4B={'lc' 'K30_4B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_4C={'lc' 'K30_4C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_4D={'lc' 'K30_4D' 2.1694 [SBANDF P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_5A1={'lc' 'K30_5A' 0.3726 [SBANDF P25*GRADL3*0.3726 PHIL3*TWOPI]}';
K30_5A2={'lc' 'K30_5A' 0.2920 [SBANDF P25*GRADL3*0.2920 PHIL3*TWOPI]}';
K30_5A3={'lc' 'K30_5A' 2.3795 [SBANDF P25*GRADL3*2.3795 PHIL3*TWOPI]}';
K30_5B={'lc' 'K30_5B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_5C={'lc' 'K30_5C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_5D={'lc' 'K30_5D' 2.1694 [SBANDF P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_6A1={'lc' 'K30_6A' 0.3940 [SBANDF P25*GRADL3*0.3940 PHIL3*TWOPI]}';
K30_6A2={'lc' 'K30_6A' 0.3930 [SBANDF P25*GRADL3*0.3930 PHIL3*TWOPI]}';
K30_6A3={'lc' 'K30_6A' 0.4070 [SBANDF P25*GRADL3*0.4070 PHIL3*TWOPI]}';
K30_6A4={'lc' 'K30_6A' 0.9810 [SBANDF P25*GRADL3*0.9810 PHIL3*TWOPI]}';
K30_6A5={'lc' 'K30_6A' 0.3550 [SBANDF P25*GRADL3*0.3550 PHIL3*TWOPI]}';
K30_6A6={'lc' 'K30_6A' 0.5141 [SBANDF P25*GRADL3*0.5141 PHIL3*TWOPI]}';
K30_6B={'lc' 'K30_6B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_6C={'lc' 'K30_6C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_6D={'lc' 'K30_6D' 2.8692 [SBANDF P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K30_7A1={'lc' 'K30_7A' 0.3813 [SBANDF P25*GRADL3*0.3813 PHIL3*TWOPI]}';
K30_7A2={'lc' 'K30_7A' 0.4317 [SBANDF P25*GRADL3*0.4317 PHIL3*TWOPI]}';
K30_7A3={'lc' 'K30_7A' 0.3740 [SBANDF P25*GRADL3*0.3740 PHIL3*TWOPI]}';
K30_7A4={'lc' 'K30_7A' 0.9910 [SBANDF P25*GRADL3*0.9910 PHIL3*TWOPI]}';
K30_7A5={'lc' 'K30_7A' 0.3590 [SBANDF P25*GRADL3*0.3590 PHIL3*TWOPI]}';
K30_7A6={'lc' 'K30_7A' 0.5071 [SBANDF P25*GRADL3*0.5071 PHIL3*TWOPI]}';
K30_7B={'lc' 'K30_7B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_7C={'lc' 'K30_7C' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_7D={'lc' 'K30_7D' 2.8692 [SBANDF P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K30_8A1={'lc' 'K30_8A' 0.3859 [SBANDF P25*GRADL3*0.3859 PHIL3*TWOPI]}';
K30_8A2={'lc' 'K30_8A' 0.3810 [SBANDF P25*GRADL3*0.3810 PHIL3*TWOPI]}';
K30_8A3={'lc' 'K30_8A' 2.2772 [SBANDF P25*GRADL3*2.2772 PHIL3*TWOPI]}';
K30_8B={'lc' 'K30_8B' 3.0441 [SBANDF P25*GRADL3*3.0441 PHIL3*TWOPI]}';
K30_8C1={'lc' 'K30_8C' 0.7620 [SBANDF P50*GRADL3*0.7620 PHIL3*TWOPI]}';
K30_8C2={'lc' 'K30_8C' 1.4669 [SBANDF P50*GRADL3*1.4669 PHIL3*TWOPI]}';
K30_8C3={'lc' 'K30_8C' 0.8152 [SBANDF P50*GRADL3*0.8152 PHIL3*TWOPI]}';
% ==============================================================================
% DRIFs
% ------------------------------------------------------------------------------
DAQ4A={'dr' '' 0.2527 []}';
DAQ4B={'dr' '' 0.203 []}';
DAQ4C={'dr' '' 0.915 []}';
DAQ4D={'dr' '' 0.272 []}';
DAQ4E={'dr' '' 0.91 []}';
DAQ5A={'dr' '' 2.1979-0.588200 []}';
DAQ5B={'dr' '' 0.28+0.588200-0.588800 []}';
DAQ5C={'dr' '' 0.3631+0.588800-0.497500 []}';
DAQ5X={'dr' '' 0.2373+0.497500 []}';
DAQ5D={'dr' '' 2.0907 []}';
DAQ5E={'dr' '' 0.296 []}';
DAQ5F={'dr' '' 0.4543 []}';
DAQ5G={'dr' '' 2.0807 []}';
DAQ5H={'dr' '' 0.286 []}';
DAQ5I={'dr' '' 0.4743 []}';
DAQ5J={'dr' '' 2.1017-0.491500 []}';
DAQ5K={'dr' '' 0.288+0.491500-0.500100 []}';
DAQ5L={'dr' '' 0.4513+0.500100-0.497000 []}';
DAQ5Y={'dr' '' 0.2373+0.497000 []}';
DAQ8C={'dr' '' 0.3352 []}';
DAQ8D={'dr' '' 2.296 []}';
DAQ9A={'dr' '' 0.0811 []}';
DAQ9B={'dr' '' 0.128 []}';
DAQ10A={'dr' '' 0.1333 []}';
DAQ10B={'dr' '' 0.203 []}';
DAQ10C={'dr' '' 0.215 []}';
DAQ10D={'dr' '' 0.3576 []}';
DAQ10E={'dr' '' 0.7765 []}';
DAQ10F={'dr' '' 0.1324 []}';
DAQ10G={'dr' '' 0.1301 []}';
DAQ10H={'dr' '' 0.203 []}';
DAQ10I={'dr' '' 0.206 []}';
DAQ10J={'dr' '' 0.237 []}';
DAQ10K={'dr' '' 0.1328 []}';
DAQ11A={'dr' '' 0.1317 []}';
DAQ11B={'dr' '' 0.211 []}';
DAQ11C={'dr' '' 0.211 []}';
DAQ11D={'dr' '' 0.1536 []}';
D10CA={'dr' '' 2.8157 []}';
D10CB={'dr' '' 0.2284 []}';
D10CC={'dr' '' 2.815900 []}';
D10CD={'dr' '' 0.228200 []}';
D10CE={'dr' '' 2.8161 []}';
D10CF={'dr' '' 0.2280 []}';
DAQW={'dr' '' -LQW/2 []}';% *** NEGATIVE DRIFT ***
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC24900={'mo' 'XC24900' 0 []}';
XC25202={'mo' 'XC25202' 0 []}';% fast-feedback (loop-3)
XC25302={'mo' 'XC25302' 0 []}';
XC25402={'mo' 'XC25402' 0 []}';
XC25502={'mo' 'XC25502' 0 []}';
XC25602={'mo' 'XC25602' 0 []}';% fast-feedback (loop-3)
XC25702={'mo' 'XC25702' 0 []}';
XC25802={'mo' 'XC25802' 0 []}';
XC25900={'mo' 'XC25900' 0 []}';
XC26202={'mo' 'XC26202' 0 []}';
XC26302={'mo' 'XC26302' 0 []}';
XC26402={'mo' 'XC26402' 0 []}';
XC26502={'mo' 'XC26502' 0 []}';
XC26602={'mo' 'XC26602' 0 []}';
XC26702={'mo' 'XC26702' 0 []}';
XC26802={'mo' 'XC26802' 0 []}';
XC26900={'mo' 'XC26900' 0 []}';
XC27202={'mo' 'XC27202' 0 []}';
XC27302={'mo' 'XC27302' 0 []}';
XC27402={'mo' 'XC27402' 0 []}';
XC27502={'mo' 'XC27502' 0 []}';
XC27602={'mo' 'XC27602' 0 []}';
XC27702={'mo' 'XC27702' 0 []}';
XC27802={'mo' 'XC27802' 0 []}';
XC27900={'mo' 'XC27900' 0 []}';
XC29092={'mo' 'XC29092' 0 []}';
XC28202={'mo' 'XC28202' 0 []}';
XC28302={'mo' 'XC28302' 0 []}';
XC28402={'mo' 'XC28402' 0 []}';
XC29095={'mo' 'XC29095' 0 []}';
XC28502={'mo' 'XC28502' 0 []}';
XC28602={'mo' 'XC28602' 0 []}';
XC28702={'mo' 'XC28702' 0 []}';
XC28802={'mo' 'XC28802' 0 []}';
XC28900={'mo' 'XC28900' 0 []}';
XC29202={'mo' 'XC29202' 0 []}';
XC29302={'mo' 'XC29302' 0 []}';
XC29402={'mo' 'XC29402' 0 []}';
XC29502={'mo' 'XC29502' 0 []}';
XC29602={'mo' 'XC29602' 0 []}';
XC29702={'mo' 'XC29702' 0 []}';
XC29802={'mo' 'XC29802' 0 []}';
XC29900={'mo' 'XC29900' 0 []}';
XC30202={'mo' 'XC30202' 0 []}';
XC30302={'mo' 'XC30302' 0 []}';
XC30402={'mo' 'XC30402' 0 []}';
XC30502={'mo' 'XC30502' 0 []}';
XC30602={'mo' 'XC30602' 0 []}';
XC30702={'mo' 'XC30702' 0 []}';
XC30802={'mo' 'XC30802' 0 []}';
XC30900={'mo' 'XC30900' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC24900={'mo' 'YC24900' 0 []}';% fast-feedback (loop-3)
YC25203={'mo' 'YC25203' 0 []}';
YC25303={'mo' 'YC25303' 0 []}';
YC25403={'mo' 'YC25403' 0 []}';
YC25503={'mo' 'YC25503' 0 []}';% fast-feedback (loop-3)
YC25603={'mo' 'YC25603' 0 []}';
YC25703={'mo' 'YC25703' 0 []}';
YC25803={'mo' 'YC25803' 0 []}';
YC25900={'mo' 'YC25900' 0 []}';
YC26203={'mo' 'YC26203' 0 []}';
YC26303={'mo' 'YC26303' 0 []}';
YC26403={'mo' 'YC26403' 0 []}';
YC26503={'mo' 'YC26503' 0 []}';
YC26603={'mo' 'YC26603' 0 []}';
YC26703={'mo' 'YC26703' 0 []}';
YC26803={'mo' 'YC26803' 0 []}';
YC26900={'mo' 'YC26900' 0 []}';
YC27203={'mo' 'YC27203' 0 []}';
YC27303={'mo' 'YC27303' 0 []}';
YC27403={'mo' 'YC27403' 0 []}';
YC27503={'mo' 'YC27503' 0 []}';
YC27603={'mo' 'YC27603' 0 []}';
YC27703={'mo' 'YC27703' 0 []}';
YC27803={'mo' 'YC27803' 0 []}';
YC27900={'mo' 'YC27900' 0 []}';
YC29092={'mo' 'YC29092' 0 []}';
YC28203={'mo' 'YC28203' 0 []}';
YC28303={'mo' 'YC28303' 0 []}';
YC28403={'mo' 'YC28403' 0 []}';
YC29095={'mo' 'YC29095' 0 []}';
YC28503={'mo' 'YC28503' 0 []}';
YC28603={'mo' 'YC28603' 0 []}';
YC28703={'mo' 'YC28703' 0 []}';
YC28803={'mo' 'YC28803' 0 []}';
YC28900={'mo' 'YC28900' 0 []}';
YC29203={'mo' 'YC29203' 0 []}';
YC29303={'mo' 'YC29303' 0 []}';
YC29403={'mo' 'YC29403' 0 []}';
YC29503={'mo' 'YC29503' 0 []}';
YC29603={'mo' 'YC29603' 0 []}';
YC29703={'mo' 'YC29703' 0 []}';
YC29803={'mo' 'YC29803' 0 []}';
YC29900={'mo' 'YC29900' 0 []}';
YC30203={'mo' 'YC30203' 0 []}';
YC30303={'mo' 'YC30303' 0 []}';
YC30403={'mo' 'YC30403' 0 []}';
YC30503={'mo' 'YC30503' 0 []}';
YC30603={'mo' 'YC30603' 0 []}';
YC30703={'mo' 'YC30703' 0 []}';
YC30803={'mo' 'YC30803' 0 []}';
YC30900={'mo' 'YC30900' 0 []}';
% ==============================================================================
% MARKERs
% ------------------------------------------------------------------------------
% profile monitors ("Decker screens")
P30013={'mo' 'P30013' 0 []}';
P30014={'mo' 'P30014' 0 []}';
P30143={'mo' 'P30143' 0 []}';
P30144={'mo' 'P30144' 0 []}';
P30443={'mo' 'P30443' 0 []}';
P30444={'mo' 'P30444' 0 []}';
P30543={'mo' 'P30543' 0 []}';
P30544={'mo' 'P30544' 0 []}';
% collimators
C29096={'dr' 'C29096' 0 []}';
C29146={'dr' 'C29146' 0 []}';
C29446={'dr' 'C29446' 0 []}';
C29546={'dr' 'C29546' 0 []}';
C30096={'dr' 'C30096' 0 []}';
C30146={'dr' 'C30146' 0 []}';
C30446={'dr' 'C30446' 0 []}';
C30546={'dr' 'C30546' 0 []}';
% miscellany
PK297={'mo' 'PK297' 0 []}';
PK299={'mo' 'PK299' 0 []}';
PK303={'mo' 'PK303' 0 []}';
PK304={'mo' 'PK304' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K25_1=[K25_1A1,XC24900,K25_1A2,YC24900,K25_1A3,K25_1B,D25_1C,K25_1D];
K25_2=[K25_2A1,XC25202,K25_2A2,YC25203,K25_2A3,K25_2B,K25_2C];
K25_3=[K25_3A1,XC25302,K25_3A2,YC25303,K25_3A3,K25_3B,K25_3C];
K25_4=[K25_4A1,XC25402,K25_4A2,YC25403,K25_4A3,K25_4B,K25_4C,K25_4D];
K25_5=[K25_5A1,XC25502,K25_5A2,YC25503,K25_5A3,K25_5B,K25_5C,K25_5D];
K25_6=[K25_6A1,XC25602,K25_6A2,YC25603,K25_6A3,K25_6B,K25_6C,K25_6D];
K25_7=[K25_7A1,XC25702,K25_7A2,YC25703,K25_7A3,K25_7B,K25_7C,K25_7D];
K25_8=[K25_8A1,XC25802,K25_8A2,YC25803,K25_8A3,K25_8B,K25_8C,K25_8D1,XC25900,K25_8D2,YC25900,K25_8D3];
LI25=[LI25BEG,ZLIN09,K25_1,DAQ1,Q25201,BPM25201,Q25201,DAQ2,K25_2,D255A,IMBC2O,D255B,D255C,TCAV3,TCAV3,D255D,Q25301,BPM25301,Q25301,DAQ2,K25_3,D256A,PH03,D256B,BL22,D256E,OTR22,D256C,BXKIKA,BXKIKB,D256D,DAQ1,Q25401,BPM25401,Q25401,DAQ2,K25_4,DAQ1,Q25501,BPM25501,Q25501,DAQ2,K25_5,DAQ1,Q25601,BPM25601,Q25601,DAQ2,K25_6,DAQ1,Q25701,BPM25701,Q25701,DAQ2,K25_7,DAQ1,Q25801,BPM25801,Q25801,DAQ2,K25_8,DAQ7,Q25901,BPM25901,Q25901,DAQ8A,OTR_TCAV,DAQ8B,LI25END];
% ------------------------------------------------------------------------------
K26_1=[K26_1A,K26_1B,K26_1C,K26_1D];
K26_2=[K26_2A1,XC26202,K26_2A2,YC26203,K26_2A3,K26_2B,K26_2C,K26_2D];
K26_3=[K26_3A1,XC26302,K26_3A2,YC26303,K26_3A3,K26_3B,K26_3C,K26_3D];
K26_4=[K26_4A1,XC26402,K26_4A2,YC26403,K26_4A3,K26_4B,K26_4C,K26_4D];
K26_5=[K26_5A1,XC26502,K26_5A2,YC26503,K26_5A3,K26_5B,K26_5C,K26_5D];
K26_6=[K26_6A1,XC26602,K26_6A2,YC26603,K26_6A3,K26_6B,K26_6C,K26_6D];
K26_7=[K26_7A1,XC26702,K26_7A2,YC26703,K26_7A3,K26_7B,K26_7C,K26_7D];
K26_8=[K26_8A1,XC26802,K26_8A2,YC26803,K26_8A3,K26_8B,K26_8C,K26_8D1,XC26900,K26_8D2,YC26900,K26_8D3];
LI26=[LI26BEG,ZLIN10,K26_1,DAQ1,Q26201,BPM26201,Q26201,DAQ2,K26_2,DAQ1,Q26301,BPM26301,Q26301,DAQ2,K26_3,DAQ1,Q26401,BPM26401,Q26401,DAQ2,K26_4,DAQ1,Q26501,BPM26501,Q26501,DAQ2,K26_5,DAQ1,Q26601,BPM26601,Q26601,DAQ2,K26_6,DAQ1,Q26701,BPM26701,Q26701,DAQ2,K26_7,DAQ1,Q26801,BPM26801,Q26801,DAQ2,K26_8,DAQ7,Q26901,BPM26901,Q26901,DAQ8,LI26END];
% ------------------------------------------------------------------------------
K27_1=[K27_1A,K27_1B,K27_1C,K27_1D];
K27_2=[K27_2A1,XC27202,K27_2A2,YC27203,K27_2A3,K27_2B,K27_2C,K27_2D];
K27_3=[K27_3A1,XC27302,K27_3A2,YC27303,K27_3A3,K27_3B,K27_3C,K27_3D];
K27_4=[K27_4A1,XC27402,K27_4A2,YC27403,K27_4A3,K27_4B,K27_4C,K27_4D];
K27_5=[K27_5A1,XC27502,K27_5A2,YC27503,K27_5A3,K27_5B,K27_5C,K27_5D];
K27_6=[K27_6A1,XC27602,K27_6A2,YC27603,K27_6A3,K27_6B,K27_6C];
K27_7=[K27_7A1,XC27702,K27_7A2,YC27703,K27_7A3,K27_7B,K27_7C,K27_7D];
K27_8=[K27_8A1,XC27802,K27_8A2,YC27803,K27_8A3,K27_8B,K27_8C,K27_8D1,XC27900,K27_8D2,YC27900,K27_8D3];
LI27=[LI27BEG,ZLIN11,K27_1,DAQ1,Q27201,BPM27201,Q27201,DAQ2,K27_2,DAQ1,Q27301,BPM27301,Q27301,DAQ2,K27_3,DAQ1,Q27401,BPM27401,Q27401,DAQ2,K27_4,DAQ1,Q27501,BPM27501,Q27501,DAQ2,K27_5,DAQ1,Q27601,BPM27601,Q27601,DAQ2,K27_6,DAQ5A,DAQ5B,DAQ5C,WS27644,DAQ5X,Q27701,BPM27701,Q27701,DAQ2,K27_7,DAQ1,Q27801,BPM27801,Q27801,DAQ2,K27_8,DAQ7,Q27901,BPM27901,Q27901,DAQ8,LI27END];
% ------------------------------------------------------------------------------
K28_1=[K28_1A,K28_1B,K28_1C];
K28_2=[K28_2A1,XC28202,K28_2A2,YC28203,K28_2A3,K28_2B,K28_2C,K28_2D];
K28_3=[K28_3A1,XC28302,K28_3A2,YC28303,K28_3A3,K28_3B,K28_3C,K28_3D];
K28_4=[K28_4A1,XC28402,K28_4A2,YC28403,K28_4A3,K28_4B,K28_4C];
K28_5=[K28_5A1,XC28502,K28_5A2,YC28503,K28_5A3,K28_5B,K28_5C,D28_5D];
K28_6=[K28_6A1,XC28602,K28_6A2,YC28603,K28_6A3,K28_6B,K28_6C,K28_6D];
K28_7=[K28_7A1,XC28702,K28_7A2,YC28703,K28_7A3,K28_7B,K28_7C];
K28_8=[K28_8A1,XC28802,K28_8A2,YC28803,K28_8A3,K28_8B,K28_8C,K28_8D1,XC28900,K28_8D2,YC28900,K28_8D3];
LI28=[LI28BEG,ZLIN12,K28_1,DAQ5D,XC29092,DAQ5E,YC29092,DAQ5F,WS28144,DAQ6,Q28201,BPM28201,Q28201,DAQ2,K28_2,DAQ1,Q28301,BPM28301,Q28301,DAQ2,K28_3,DAQ1,Q28401,BPM28401,Q28401,DAQ2,K28_4,DAQ5G,XC29095,DAQ5H,YC29095,DAQ5I,WS28444,DAQ6,Q28501,BPM28501,Q28501,DAQ2,K28_5,DAQ1,Q28601,BPM28601,Q28601,DAQ2,K28_6,DAQ1,Q28701,BPM28701,Q28701,DAQ2,K28_7,DAQ5J,DAQ5K,DAQ5L,WS28744,DAQ5Y,Q28801,BPM28801,Q28801,DAQ2,K28_8,DAQ7,Q28901,BPM28901,Q28901,DAQ8C,C29096,DAQ8D,LI28END];
% ------------------------------------------------------------------------------
K29_1=[K29_1A,K29_1B,K29_1C];
K29_2=[K29_2A1,XC29202,K29_2A2,YC29203,K29_2A3,K29_2B,K29_2C,K29_2D];
K29_3=[K29_3A1,XC29302,K29_3A2,YC29303,K29_3A3,K29_3B,K29_3C,K29_3D];
K29_4=[K29_4A1,XC29402,K29_4A2,YC29403,K29_4A3,K29_4B,K29_4C];
K29_5=[K29_5A1,XC29502,K29_5A2,YC29503,K29_5A3,K29_5B,K29_5C];
K29_6=[K29_6A1,XC29602,K29_6A2,YC29603,K29_6A3,K29_6B,K29_6C,K29_6D];
K29_7=[K29_7A1,XC29702,K29_7A2,YC29703,K29_7A3,K29_7B,K29_7C,K29_7D];
K29_8=[K29_8A1,XC29802,K29_8A2,YC29803,K29_8A3,K29_8B,K29_8C,K29_8D1,XC29900,K29_8D2,YC29900,K29_8D3];
LI29=[LI29BEG,ZLIN13,K29_1,D10CA,C29146,D10CB,DAQ1,Q29201,BPM29201,Q29201,DAQ2,K29_2,DAQ1,Q29301,BPM29301,Q29301,DAQ2,K29_3,DAQ1,Q29401,BPM29401,Q29401,DAQ2,K29_4,D10CC,C29446,D10CD,DAQ1,Q29501,BPM29501,Q29501,DAQ2,K29_5,D10CE,C29546,D10CF,DAQ1,Q29601,BPM29601,Q29601,DAQ2,K29_6,DAQ1,Q29701,BPM29701,Q29701,DAQ2,K29_7,DAQ9A,PK297,DAQ9B,Q29801,BPM29801,Q29801,DAQ2,K29_8,DAQ3,Q29901,BPM29901,Q29901,DAQ4A,P30013,DAQ4B,P30014,DAQ4C,C30096,DAQ4D,PK299,DAQ4E,LI29END];
% ------------------------------------------------------------------------------
K30_1=[K30_1A,K30_1B,K30_1C,K30_1D];
K30_2=[K30_2A1,XC30202,K30_2A2,YC30203,K30_2A3,K30_2B,K30_2C,K30_2D];
K30_3=[K30_3A1,XC30302,K30_3A2,YC30303,K30_3A3,K30_3B,K30_3C,K30_3D];
K30_4=[K30_4A1,XC30402,K30_4A2,YC30403,K30_4A3,K30_4B,K30_4C,K30_4D];
K30_5=[K30_5A1,XC30502,K30_5A2,YC30503,K30_5A3,K30_5B,K30_5C,K30_5D];
K30_6=[K30_6A1,XC30602,K30_6A2,DAQW,Q30615A,Q30615A,DAQW,K30_6A3,YC30603,K30_6A4,DAQW,Q30615B,Q30615B,DAQW,K30_6A5,DAQW,Q30615C,Q30615C,DAQW,K30_6A6,K30_6B,K30_6C,K30_6D];
K30_7=[K30_7A1,XC30702,K30_7A2,DAQW,Q30715A,Q30715A,DAQW,K30_7A3,YC30703,K30_7A4,DAQW,Q30715B,Q30715B,DAQW,K30_7A5,DAQW,Q30715C,Q30715C,DAQW,K30_7A6,K30_7B,K30_7C,K30_7D];
K30_8=[K30_8A1,XC30802,K30_8A2,YC30803,K30_8A3,K30_8B,K30_8C1,XC30900,K30_8C2,YC30900,K30_8C3];
LI30=[LI30BEG,ZLIN14,K30_1,DAQ10A,P30143,DAQ10B,P30144,DAQ10C,C30146,DAQ10D,Q30201,BPM30201,Q30201,DAQ2,K30_2,DAQ1,Q30301,BPM30301,Q30301,DAQ2,K30_3,DAQ10E,PK303,DAQ10F,Q30401,BPM30401,Q30401,DAQ2,K30_4,DAQ10G,P30443,DAQ10H,P30444,DAQ10I,C30446,DAQ10J,PK304,DAQ10K,Q30501,BPM30501,Q30501,DAQ2,K30_5,DAQ11A,P30543,DAQ11B,P30544,DAQ11C,C30546,DAQ11D,Q30601,BPM30601,Q30601,DAQ12,K30_6,DAQ13,Q30701,BPM30701,Q30701,DAQ14,K30_7,DAQ15,Q30801,BPM30801,Q30801,DAQ16,K30_8,DAQ17,LI30END];
% ==============================================================================

% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
L1C=[D9,DAQ1,QFL1,QFL1,DAQ1,D9,DAQ1,QDL1,QDL1,DAQ1];
L2C=[D10,D10,D10,D10,DAQ1,QFL2,QFL2,DAQ2,D10,D10,D10,D10,DAQ1,QDL2,QDL2,DAQ2];
L3C=[D10,D10,D10,D10,DAQ1,QFL3,QFL3,DAQ2,D10,D10,D10,D10,DAQ1,QDL3,QDL3,DAQ2];
SC0=[XC00,YC00];
SC1=[XC01,YC01];
SC2=[XC02,YC02];
SC3=[XC03,YC03];
SC4=[XC04,YC04];
SC5=[XC05,YC05];
SC6=[XC06,YC06];
SC7=[XC07,YC07];
SC8=[XC08,YC08];
SC9=[XC09,YC09];
SC10=[XC10,YC10];
SC11=[XC11,YC11];
SCA11=[XCA11,YCA11];
SCA12=[XCA12,YCA12];
SCM11=[XCM11,YCM11];
SCM13=[XCM13,YCM12];
SCM15=[XCM14,YCM15];
GUNBXG=[DL00,LOADLOCK,L0BEG,SOL1BK,DBMARK80,CATHODE,DL01A,SOL1,CQ01,CQ01,SC0,SQ01,SQ01,SOL1,DL01A1,VV01,DL01A2,AM00,DL01A3,AM01,DL01A4,YAG01,DL01A5,FC01,DL01B,IM01,DL01C,SC1,DL01H,BPM2,DL01D,DBMARK81];
BXGL0A=[DXG0,DXGA,DXGB,DL01E,BPM3,DL01F,CR01,DL01F2,YAG02,DL01G,ZLIN00,FLNGA1,L0A___1,DLFDA,L0A___2,SOL2,L0A___3,SC2,L0A___4,L0AMID,L0A___5,SC3,L0A___6,OUTCPA,L0A___7,FLNGA2,L0AWAKE];
GUNL0A=[GUNBXG,BXGL0A];
L0B=[L0BBEG,DL02A1,YAG03,DL02A2,DL02A3,QA01,QA01,DL02B1,PH01,DL02B2,QA02,BPM5,QA02,DL02C,FLNGB1,L0B___1,DLFDB,L0B___2,SC4,L0B___3,L0BMID,L0B___4,SC5,L0B___5,OUTCPB,L0B___6,FLNGB2,L0END];
LSRHTR=[LHBEG,BXH1A,BXH1B,DH01,BXH2A,BXH2B,DH02A,OTRH1,DH03A,LH_UND,HTRUND,LH_UND,DH03B,OTRH2,DH02B,BXH3A,BXH3B,DH01,BXH4A,BXH4B,LHEND];
DL1A=[EMAT,DL1BEG,DE00,DE00A,QE01,BPM6,QE01,DE01A,IM02,DE01B,VV02,DE01C,QE02,QE02,DH00,LSRHTR,DH06,TCAV0,SC6,TCAV0,DE02,QE03,BPM8,QE03,DE03A,DE03B,SC7,DE03C,QE04,BPM9,QE04,DE04,WS01,DE05,OTR1,DE05C,VV03,DE06A,RST1,DE06B,WS02,DE05A,MRK0,DE05A,OTR2,DE06D,BPM10,DE06E,WS03,DE05,OTR3,DE07,QM01,BPM11,QM01,DE08,SC8,DE08A,VV04,DE08B,QM02,BPM12,QM02,DE09,DBMARK82];
DL1B=[BX01A,BX01B,DB00A,OTR4,DB00B,SC9,DB00C,QB,BPM13,QB,DB00D,WS04,DB00E,BX02A,BX02B,CNT0,DBMARK83,DM00,SC10,DM00A,QM03,BPM14,QM03,DM01,DM01A,QM04,BPM15,QM04,DM02,IM03,DM02A,DL1END];
DL1=[DL1A,DL1B];% This is nominal LCLS DL1 layout with BX01/BX02 bends on
DIAG1=[DDG1,BPMS11,DDG2,CE11,DDG3,OTR11,DDG4];
BC1C=[BC1BEG,BX11A,BX11B,DBQ1,CQ11,CQ11,D11O,BX12A,BX12B,DIAG1,BX13A,BX13B,D11OA,SQ13,SQ13,D11OB,CQ12,CQ12,DBQ1,BX14A,BX14B,CNT1,BC1END];
BC1I=[DL1XA,VVX1,DL1XB,XBEG,L1X___1,SCM11,L1X___2,XEND,DM10A,VVX2,DM10C,Q21201,BPM21201,ZLIN02,Q21201,DM10X,IMBC1I,DM11,QM11,QM11,DM12];
BC1E=[DM13A,BL11,DM13B,QM12,QM12,DM14A,DM14B,IMBC1O,DM14C,QM13,BPMM12,QM13,DM15A,BL12,DM15B,SCM13,DM15C,WS11,DWW1A,WS12,DWW1B,OTR12,DWW1C1,PH02,DWW1C2,XC21302,DWW1D,YC21303,DWW1E,WS13,DM16,Q21301,BPM21301,ZLIN03,Q21301,DM17A,DM17B,TD11,DM17C,QM14,BPMM14,QM14,DM18A,SCM15,DM18B,QM15,QM15,DBMARK28,DM19];
BC1=[BC1MRK,BC1I,BC1C,BC1E,BC1FIN];
L2=[L2BEG,LI21,LI22,LI23,LI24,L2END];
DIAG2=[DDG1,BPMS21,DDG2,CE21,DDG3,OTR21,DDG4];
BC2C1=[BC2BEG,BX21A,BX21B,DBQ2A,CQ21,CQ21,D21OA,BX22A,BX22B,DDG0,DIAG2,DDGA,BX23A,BX23B,D21OB,CQ22,CQ22,DBQ2B,BX24A,BX24B,CNT2,BC2END];
BC2=[BC2MRK,DM20,Q24701A,ZLIN08,Q24701A,D10CMA,Q24701B,BPM24701,Q24701B,DM21Z,DM21A,DWS24,DM21H,IMBC2I,DM21B,VV21,DM21C,QM21,QM21,DM21D,DM21E,BC2C1,D21W,D21X,BL21,D21Y,DM23B,QM22,QM22,DM24A,VV22,DM24B,DM24D,Q24901A,BPM24901,Q24901A,DM24C,Q24901B,Q24901B,DM25,BC2FIN];
L3=[L3BEG,LI25,LI26,LI27,LI28,LI29,LI30,L3END,DBMARK29];
B12WAL=[D50B1     ,D50B1     ,DR19      ,P460045T  ,DR20      ,BPMBSY51  ,DR21      ,DR22      ,DR23      ,A4DXL     ,XCBSY60   ,A4DXL     ,DR23A     ,BPMBSY61  ,DR23B     ,A4DYL     ,YCBSY62   ,A4DYL     ,DR24      ,PMV       ,PMV       ,DR25      ,DR25A     ,BPMBSY63  ,FPM1      ,PM1       ,PM1       ,DR26      ,PM3       ,DR27      ,B2        ,DR28      ,D10D      ,D10B      ,DMB01     ,PC90      ,DMB02     ,H1DL      ,XCBSY81   ,H1DL      ,DM03      ,V1DL      ,YCBSY82   ,V1DL      ,DM04      ,I3        ,DM05      ,P950020T  ,DM08      ,IV4       ,DM09      ,BPMBSY83  ,DM10B     ,QSM1      ,QSM1      ,DQSM1     ,Q5        ,BPMBSY85  ,Q5        ,DYC5      ,I4A       ,I4B       ,I5        ,I5        ,DM12A     ,I6        ,I6        ,DM12B     ,YC5       ,DM12C     ,XC6       ,DXC6      ,Q6        ,BPMBSY88  ,Q6        ,DM2       ,D2L       ,D2        ,D2L       ,DM3       ,ST60L     ,ST60      ,ST60L     ,DM4       ,XCA0      ,DXCA0     ,YCA0      ,DYCA0     ,ST61L     ,ST61      ,ST61L     ,DM5       ,QA0       ,BPMBSY92  ,QA0       ,DM6       ,DMONI     ,DMONI     ,WALL      ,BSYEND  ];
B52LIN=[B50B1A    ,B50B1B    ,DRI14001  ,PR45      ,DRI14002  ,BPM52     ,DRI14003  ,B52AGFA   ,B52AGFB   ,DRI14004  ,B52WIG1A  ,B52WIG1B  ,DRI14005  ,B52WIG2A  ,YC54T     ,B52WIG2B  ,DRI14005  ,B52WIG3A  ,B52WIG3B  ,DRI14006  ,PR55      ,DRI14007  ,BPM56     ,DRI14008  ,Q52Q2     ,Q52Q2     ,DRI14009  ,PR60      ,DRI14010  ,IM61      ,DRI14011  ,WS62      ,DRI14012  ,YC59      ,DRI14013  ,SL1X      ,BPM64     ,DRI14014  ,SL1Y      ,DRI14015  ,BPM68     ,DRI14016  ,XC69      ,DRI14017  ,SL2       ,DBMARK99];
BSY=[BSYBEG  ,DRIF0105,Q50Q1   ,Q50Q1   ,DRIF0106,BPMBSY1 ,DRIF0107,FFTBORGN,DRIF0108,S100    ,ZLIN15  ,DRIF0109,XCBSY09,DRIF0110,YCBSY10,DRIF0111,C50PC20 ,DRIF0112,I40IW1  ,DRIF0113,M40B1   ,DRIF0114,XCBSY26,DRIF0110,YCBSY27,DRIF0115,Q50Q2   ,Q50Q2   ,DRIF0116,BPMBSY29,DRIF0117,P460031T,DRIF0118,P460032T,DRIF0119,C50PC30 ,DRIF0120,IMBSY34,DRIF0121,XCBSY34,DRIF0122,YCBSY35,DRIF0123,XCBSY36,DRIF0110,YCBSY37,DRIF0124,Q50Q3   ,Q50Q3   ,DRIF0125,BPMBSY39,DRIF0125,W460042T,DRIF0126,DBMARK14];
ECELL=[QE31,DQEC,DQEC,QE32,QE32,DQEC,DQEC,QE31];
VBEND=[VBIN,BY1A,BY1B,DVB1,QVB1,BPMVB1,QVB1,D40CMC,YCVB1, DVB2M80CM,XCVB2,D40CMC,QVB2,BPMVB2,QVB2,DVB2, QVB3,BPMVB3,QVB3,D40CMC,YCVB3,DVB1M40CM,BY2A,BY2B,CNTV, VBOUT];
VBSYS=[DYCVM1,YCVM1,DQVM1,QVM1,BPMVM1,QVM1,DQVM2,QVM2,BPMVM2,QVM2,DXCVM2,XCVM2,DVB25CM,VBEND,DVB25CMC,XCVM3,D25CM,QVM3,BPMVM3,QVM3,DVBEM25CM,YCVM4,D25CM,QVM4,BPMVM4,QVM4,DVBEM15CM,IM31,D10CMB,IMBCS1,D25CMA];
EWIG=[DBYW1A,DBYW1B,DW1O,DBYW2A,DBYW2B,DW1O,DBYW3A,DBYW3B,CNTW];
DL21=[DBMARK34,BX31A,BX31B,DDL10W,EWIG, DWSDL31A,WSDL31,DWSDL31B,DDL10X, XCDL1,D31A,QDL31,BPMDL1,QDL31,D31B,YCDL1,D32CMB,CEDL1, DDL10EM80CM,BX32A,BX32B,CNT3A];
DL22=[DX33A,DX33B,DDL1A,BYKIK1A,BYKIK1B,DDL1C,DDL1C,BYKIK2A,BYKIK2B,DDL1B,XCDL2,D32A,QDL32,BPMDL2,QDL32,D32B,YCDL2,DSPLR,SPOILER,DDL1CM40CM,TDKIK,D30CMA,PCTDKIK1,DPC1,PCTDKIK2,DPC2,PCTDKIK3,DPC3,PCTDKIK4,DPC4,SPONTUA,SPONTUB,DDL1DM30CM,DX34A,DX34B];
DL23=[BX35A,BX35B,DCQ31A,CQ31,CQ31,DCQ31B,OTR30,D29CMA,XCDL3, D33A,QDL33,BPMDL3,QDL33,D33B,YCDL3,D32CMD,CEDL3, DCQ32A,CQ32,CQ32,DCQ32B,BX36A,BX36B,CNT3B];
DL24=[DX37A,DX37B,D30CM,IMBCS2,DDL10M70CM,XCDL4,D34A,QDL34,BPMDL4,QDL34,D34B,YCDL4,DDL10UM25CM,DDL10V,DX38A,DX38B];
TRIP1=[DDL20E,QT11,QT11,DDL30EM40CM,XCQT12,D40CMB,QT12, BPMT12,QT12,D40CMB,YCQT12,DDL30EM40CM,QT13,QT13,DDL20E];
TRIP2=[DDL20,QT21,QT21,DDL30EM40CM,XCQT22,D40CMB,QT22, BPMT22,QT22,D40CMB,YCQT22,DDL30EM40CM,QT23,QT23,DDL20];
TRIP3=[DDL20E,QT31,QT31,DDL30EM40CMA,XCQT32,D40CMD,QT32, BPMT32,QT32,D40CME,YCQT32,DDL30EM40CMB,QT33,QT33,DDL20E];
TRIP4=[DDL20,QT41,QT41,DDL30EM40CMC,XCQT42,D40CMF,QT42, BPMT42,QT42,D40CMB,YCQT42,DDL30EM40CM,QT43,QT43,DDL20];
DOGLG2A=[DL21,TRIP1,SS1,DL22,TRIP2];
DOGLG2B=[DL23,TRIP3,SS3,DL24,TRIP4];
EDMCH=[D25CMB,IM36,D25CMC,DMM1M90CM,YCEM1, DEM1A,QEM1,BPMEM1,QEM1,DEM1B,QEM2,BPMEM2,QEM2,DEM2B, XCEM2,DMM3M80CM,YCEM3,DEM3A,QEM3,BPMEM3,QEM3, DEM3B,QEM3V,QEM3V,DMM4M90CM,XCEM4,DEM4A,QEM4,BPMEM4,QEM4,DMM5];
EDSYS=[DBMARK36,WS31,D40CM,DE3M80CMA, XCE31,DQEA,QE31,BPME31,QE31,DQEBX,CX31,DQEBX2, DE3A,YCE32,DQEAA,QE32,BPME32,QE32,DQEBY,CY32, DQEBY2,WS32,D40CM,DE3M80CMB,XCE33,DQEAB, QE33,BPME33,QE33,DQEC,OTR33,DE3M40CM,YCE34,DQEA,QE34, BPME34,QE34,DQEC,WS33,D40CM,DE3M80CM,XCE35, DQEAC,QE35,BPME35,QE35,DQEBX,CX35,DQEBX2,DE3, YCE36,DQEA,QE36,BPME36,QE36,DQEBY,CY36,DQEBY2, WS34,D40CM];
UNMCH=[DU1M80CM,DCX37,D32CMC,XCUM1,DUM1A,QUM1,BPMUM1,QUM1,DUM1B, D32CM,DU2M120CM,DCY38,D32CMA,YCUM2,DUM2A,QUM2, BPMUM2,QUM2,DUM2B,DU3M80CM,YCUM3,DUM3A, QUM3,BPMUM3,QUM3,DUM3B,D40CMA,EOBLM,DU4M120CM, XCUM4,DUM4A,QUM4,BPMUM4,QUM4,DUM4B,RFB07,DU5M80CM, IMUNDI,D40CM,RWWAKEAL,DMUON2,DVV35,RFB08,DTDUND1,TDUND,DTDUND2,PCMUON,DMUON1,VV999,DMUON3,MM3,PFILT1,DBMARK37];
% Undulator exit and Dumps:
% ========================
UNDEXIT=[UEBEG,DUE1A,VV36,DUE1D,IMUNDO,DUE1B,BPMUE1,DUE1C,QUE1,QUE1,DUE2A,XCUE1,DUE2B,YCUE2,DUE2C,QUE2,QUE2,DUE3A,BPMUE2,DUE3B,PCPM0,BTM0,DUE3C,TRUE1,DUE3D,DUE4,DUE5A,YCD3,DUE5C,XCD3,DUE5D,UEEND,DLSTART,DSB0A,VV37,DSB0B,BPMUE3,DSB0C,IMBCS3,DSB0D];
DUMPLINE=[BYD1A,BYD1B,DS,BYD2A,BYD2B,DS, BYD3A,BYD3B,DSC,PCPM1L,BTM1L,DD1A,IMDUMP,DD1B,YCDD,DD1F,PCPM2L,BTM2L,DD1C,QDMP1,QDMP1,DD1D,BPMQD,DD1E,QDMP2,QDMP2,DD2A,XCDD,DD2B,IMBCS4,DD3A,BPMDD,DD3B,OTRDMP,DWSDUMPA,WSDUMP,DWSDUMPB,DUMPFACE,DMPEND,DD3D,EOL,DD3E,BTMDUMP,DBMARK38];
PERMDUMP=[SFTBEG,DYD1,DSS1,DYD2,DSS2,DYD3,DSCS1,VV38,DSCS2,PCPM1,BTM1,DPM1B,ST0,DST0,BTMST0,DMUSPL,ST1,DST1,BTMST1,DPM1C,PCPM2,BTM2,DPM1D,BXPM1A,BXPM1B,DPM1,BXPM2A,BXPM2B,DPM2,BXPM3A,BXPM3B,DSFT,SFTDMP,DPM2E,BTMSFT,DMPEND];
LTU=[MM1,DOGLG2A,DOGLG2B,MM2,EDMCH,EDSYS,UNMCH];
BSYLTU=[RWWAKESS,BSY,B12WAL,VBSYS,LTU,UND,UNDEXIT,DUMPLINE];
LCLS=[DL1,L1,BC1,L2,BC2,L3,BSYLTU];
% ==============================================================================
% SUBROUTINEs
% ------------------------------------------------------------------------------

% match L1 phase advance per cell (coasting)





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match L2 phase advance per cell (coasting)





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match L3 phase advance per cell (coasting)






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% find Twiss at cathode
% (NOTE: optics between cathode and DL1beg is meaningless ... used only to
%        initialize sumL and show beamline layout)








%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match gun spectrometer






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% set Heater-chicane peak dispersion




% want 35 mm X-offset - need 35.486 mm of etaX to get it
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match DL1 bend system dispersion





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match from exit of L0 into ED0











%LMDIF
%MIGRAD
%SIMPLEX

% =expected penalty function with fitting OFF (htr fully ON)


% ------------------------------------------------------------------------------

% match from ED0 through injection bend system to L1











%MIGRAD
%SIMPLEX

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match 135-MeV spectrometer



% nominal fit at YAGS2
% nominal fit at YAGS2
%    VARY, KQM01, STEP=1.E-5, LOWER=-40,UPPER=+40      only use when 3-keV resolution on OTR required
%    VARY, KQM02, STEP=1.E-5, LOWER=-40,UPPER=+40      only use when 3-keV resolution on OTR required
% all fits
% nominal fit at YAGS2
%    CONSTR, OTRS1, BETX<0.07,BETY>5,BETY<12           only use when 3-keV resolution on OTR required
% nominal fit at YAGS2
%    CONSTR, OTRS1, DX=-1.0*E0i/Ei                     only use when 3-keV resolution on OTR required
%    CONSTR, DS2, BETX<35                              only use when 3-keV resolution on OTR required
%    CONSTR, BPM12, BETY<35                            only use when 3-keV resolution on OTR required
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match BC1 R56





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match through BC1 chicane into emittance measurement system










%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match BC1 to L2



%    VARY, KQ21301, STEP=1.E-5, LOWER=-10,UPPER=0   leave this quad OFF - unhook cables?





%, BETY=BET22
%, BETX=BET22



%, BETX=BET22
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI22 betas












%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI23 betas












%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI24 betas








%      VARY, KQ24501, STEP=1.E-5, LOWER=-100, UPPER=0

% , BETY=BET22
% , BETX=BET22
% , BETY=BET22
% , BETX=BET22
% , BETY=BET22
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF and when KQ24501 set to post MBC2i-fit value


% ------------------------------------------------------------------------------

% match BC2 R56





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match into BC2



%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100







%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match BC2 to L3




%, LOWER=-10 , UPPER=0
%, LOWER=0   , UPPER=10
%, LOWER=-10 , UPPER=0
%, LOWER=0   , UPPER=10
%, LOWER=-10 , UPPER=0







%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI26 betas



%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI27 betas



%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI28 betas



%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI29 betas



%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match LI30 betas



%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0
%, LOWER=0   , UPPER=100
%, LOWER=-100, UPPER=0






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% Match dispersion in vertical bend module






%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% find periodic beta's through bend cells









%LMDIF
%MIGRAD

% =expected penalty function with DL23 fitting OFF


% ------------------------------------------------------------------------------

% match L3 to LTU


















%MIGRAD
%SIMPLEX

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match DL2 dogleg dispersion






%LMDIF
%MIGRAD

% =expected penalty function with DL23 fitting OFF


% ------------------------------------------------------------------------------

% Match with triplet between bend-cells






%LMDIF
%MIGRAD
%SIMPLEX

% =expected penalty function with DOGLG2B fitting OFF


% ------------------------------------------------------------------------------

% Match FODO quad strength for 45-deg wire-to-wire phase adv.





%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% Find periodic beta's through LTU emit-diag section











%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% Match between bend cells and emit-diag section








%CONSTR,OTR33,BETX=12*DE3[L]/5,BETY=12*DE3[L]/5,ALFX=0,ALFY=0    for slice-emit on OTR33 with KQED2=0
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% find proper periodic betas in undulator







% <beta>=30 m
%    CONSTR,#S/#E,PATTERN="MUQ",BETX<15.5,BETY<15.0   <beta>=10 m
%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match betas at entrance to undulator








%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% match e- dump






%    VARY, Ddmpv, STEP=1.E-4, UPPER=5, LOWER=-5



%LMDIF
%MIGRAD

% =expected penalty function with fitting OFF


% ------------------------------------------------------------------------------

% initialize L2 quad K1s to FODO cell values




























% ------------------------------------------------------------------------------

% output L2 quad K1s




























% ------------------------------------------------------------------------------

% initialize L3 quad K1s to FODO cell values
















































% ------------------------------------------------------------------------------

% output L3 quad K1s
















































% ------------------------------------------------------------------------------

% load DL2 optics with DX=DPX=0 between bending units













% ==============================================================================
% COMMANDs
% ------------------------------------------------------------------------------


BET11 = 10.090395936353;
BET12 = 2.470673595371;
BET21 = 43.876719659503;
BET22 = 16.019619746515;
%  BET31 := 53.481287866029
%  BET32 := 35.468087644847
%  BET33 := 29.55797372867
%  BET34 := 63.601589300188
BET31 = 61.868125327071;
BET32 = 36.40742728964;
BET33 = 36.353377790534;
BET34 = 61.956709274457;
%  BET31 := 69.818359882868   for WS28 45 deg/wire
%  BET32 := 37.0062095289
%  BET33 := 42.5680425597
%  BET34 := 60.952049693321
% do fitting






















%      SET, MUX_L3, 36.175/360  July 13, 2005 - set for n*360 deg BX24A to BX31A (TCAV3 -> 25-2d)
%July 13, 2008 - set for best WS28 45-deg mux phase advances
%July 13, 2005 - set for 3*90 deg TCAV3[1] to OTR30 (TCAV3 -> 25-2d)




















%**L2K1in  use ONLY when you're changing L2 phase advance per cell




%L2K1out


%**L3K1in  use ONLY when you're changing L3 phase advance per cell






%L3K1out











% generate output files and plots (optics) and survey coordinates
% (NOTE: Y-PITCH is not included here for simplicity - for linac coordinates, read in pitched plane of linac)
XLL = 10.9474                                  ;% X at loadlock start [m]
ZLL = 2032.0-14.8125+ZOFFINJ                   ;% Z at loadlock start (move injector ~12 mm dnstr. - Nov. 17, 2004, -PE) [m]
XI  = XLL+LOADLOCK{3}*sin(ADL1)                ;% subtract from upbeam side of loadlock to get to cathode [m]
ZI  = ZLL+LOADLOCK{3}*cos(ADL1)                ;% subtract from upbeam side of loadlock to get to cathode [m]
XF     =  0                                    ;% hor. position is on linac axis, which is zero here [m]
THETAF =  0                                    ;% no yaw at S100
PSIF   =  0                                    ;% no roll at S100
YF     =  0.009738                             ;% Y near 50Q1 (~2 m upbeam S100) in undulator coordinates (for LTU engineers)
ZF     = -2.085977                             ;% Z near 50Q1 (~2 m upbeam S100) in undulator coordinates (for LTU engineers)
PHIF   = 2*AVB                                 ;% S100 pitch in undulator coordinates (for LTU engineers)

% Generate output files for SYMBOLS file creation:
% ===============================================
%CALL, FILENAME="makeSymbols.mad"
% Generate output files for entire machine:
% ========================================





%SELECT, OPTICS, FULL
%ENVELOPE, SIGMA0=SIGC, SAVE, TAPE="LCLS-28MAY10_envelope.tape"
%SAVELINE, NAME="LSFEL", FILENAME="LCLS-28MAY10.saveline"
% Make plots for various sections of the machine:
% ==============================================
















% Generate output files for 6-MeV Gun Spectrometer:
% ================================================






%PLOT, TABLE=TWISS, HAXIS=S, VAXIS1=BETX,BETY, VAXIS2=DX, &
%  STYLE=100, SPLINE=.T., &
%  RANGE=GSPECBEG/#E, TITLE="Gun spectrometer", &
%  FILE="LCLS-28MAY10"
%SAVELINE, NAME="LSGUN", FILENAME="GSPEC-28MAY10.saveline"
% Generate output files for 135-MeV Spectrometer:
% ==============================================







%SAVELINE, NAME="LSINJ", FILENAME="SPEC-28MAY10.saveline"
% Generate special 'BSY' survey coordinates including Y-pitch-down angle at Station-100 (S100)
% (NOTE: map onto alignment reference at QSM1 center)
% Generate output files for LTU:
% =============================





% Generate output files for 52-LINE:
% =================================







% Generate output files for safety dump:
% =====================================







% ------------------------------------------------------------------------------

% check horizontal phase advance between last bends of BC1 and BC2




% horizontal phase advance between BC1/BC2 CSR kicks (180 deg desired)


% ------------------------------------------------------------------------------

% check phase advance between wire-scanners WS21 through WS24













% ------------------------------------------------------------------------------

% check horizontal phase advance between last BC2 bend and center of first
% DL2 bend system and vertical phase advance between transverse deflecting
% cavity and OTR30






% horizontal phase advance between last BC2 bend and first bend of DL2
% system (want 2N*pi, N=0,1,2,...)

% vertical phase advance from transverse deflecting cavity to OTR30 (want
% (2N+1)*(pi/2), N=0,1,2,...)

% twiss at OTR30, including horizontal eta/beta ratio


% ------------------------------------------------------------------------------

beamLine.LCLS=[GUNL0A,L0B,LCLS]';
beamLine.SPECBL=[GUNL0A,L0B,DL1A,SPECBL]';
beamLine.B52=[GUNL0A,L0B,DL1,L1,BC1,L2,BC2,L3,RWWAKESS,BSY,B52LIN]';
beamLine.GSPEC=[GUNBXG,GSPEC]';
