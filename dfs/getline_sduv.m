function beamline = getline_sduv(region,value)
%=======================
%get the lattice of SDUV  Free-Electron Laser
%v0.0  
%2011/11/2
%======================================================================


%======================================================================
% Accelerating Structures(Linac Cavitys)
%  ('lc')
%======================================================================
%Volt=1.6467968535*value;%MV
Grad1=10/cos((-16)*pi/180);%MV/m %actual gradient,highest acclerate voltage
Grad2=15/cos((21)*pi/180);%MV/m
% Grad1=30;%MV/m %actual gradient
% Grad2=45;%MV/m

% A1i= {'lc' 'A1i' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% A1p= {'lc' 'A1p' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% A1e= {'lc' 'A1e' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% 
% A2i= {'lc' 'A2i' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% A2p= {'lc' 'A2p' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% A2e= {'lc' 'A2e' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (-16)*pi/180]}';
% 
% A3i= {'lc' 'A3i' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
% A3p= {'lc' 'A3p' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
% A3e= {'lc' 'A3e' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
% 
% A4i= {'lc' 'A4i' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
% A4p= {'lc' 'A4p' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
% A4e= {'lc' 'A4e' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (21)*pi/180]}';
A1i= {'lc' 'A1i' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';
A1p= {'lc' 'A1p' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';
A1e= {'lc' 'A1e' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';

A2i= {'lc' 'A2i' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';
A2p= {'lc' 'A2p' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';
A2e= {'lc' 'A2e' 1.535055000E-01 [2856 Grad1*1.535055000E-01 (0)*pi/180]}';

A3i= {'lc' 'A3i' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';
A3p= {'lc' 'A3p' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';
A3e= {'lc' 'A3e' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';

A4i= {'lc' 'A4i' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';
A4p= {'lc' 'A4p' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';
A4e= {'lc' 'A4e' 1.535055000E-01 [2856 Grad2*1.535055000E-01 (0)*pi/180]}';
%======================================================================
% Bend
% ('be')
%======================================================================
B11= {'be' 'B11' 0.2*10.7*pi/180/sin(10.7*pi/180) [10.7*pi/180 1.5e-02 0e+00 10.7*pi/180  0.5 0.5 0]}';
B12= {'be' 'B12' 0.2*10.7*pi/180/sin(10.7*pi/180) [10.7*pi/180 1.5e-02 -10.7*pi/180 0e+00 0.5 0.5 0]}';
B13= {'be' 'B13' 0.2*10.7*pi/180/sin(10.7*pi/180) [10.7*pi/180 1.5e-02 0e+00 -10.7*pi/180 0.5 0.5 0]}';
B14= {'be' 'B14' 0.2*10.7*pi/180/sin(10.7*pi/180) [10.7*pi/180 1.5e-02 10.7*pi/180 0e+00  0.5 0.5 0]}';

B0= {'be' 'B0' 0.2*30*pi/180 [30*pi/180 1.5e-02 0e+00 0e+00 0.5 0.5 0]}';

%======================================================================
% Drift
% ('dr')
%======================================================================
DB11= {'dr' '' (6.500000000E-01/cos(10.7*pi/180)) []}';
DB12= {'dr' '' 1.56400000E-01 []}';
DB13= {'dr' '' 1.56400000E-01 []}';
DB14= {'dr' '' (6.500000000E-01/cos(10.7*pi/180)) []}';

DQD1= {'dr' '' 9.000000000E-02 []}';
DQD2= {'dr' '' 1.000000000E-02 []}';
DQD3= {'dr' '' 7.000000000E-02 []}';

DBD= {'dr' '' 9.000000000E-02 []}';
DBdm= {'dr' '' 4.000000000E-01 []}';

D1= {'dr' '' 1.800000000E-01 []}';
D2= {'dr' '' 5.900000000E-01 []}';
D3= {'dr' '' 3.500000000E-01 []}';

DF1= {'dr' '' 3.160000000E-01 []}';
DF2= {'dr' '' 4.000000000E-01 []}';
DF3= {'dr' '' 8.000000000E-01 []}';
DF4= {'dr' '' 8.000000000E-01 []}';
DF5= {'dr' '' 8.000000000E-01 []}';

DBLL1= {'dr' '' 1.839400000E-01 []}';
DBLL2= {'dr' '' 7.000000000E-02 []}';
DBLL3= {'dr' '' 9.000000000E-02 []}';
DBLL4= {'dr' '' 1.300000000E-01 []}';
DBLL5= {'dr' '' 7.500000000E-02 []}';

DBPM1= {'dr' '' 2.400000000E-01 []}';
DBPM2= {'dr' '' 1.700000000E-01 []}';
DBPM3= {'dr' '' 2.400000000E-01 []}';

DICT= {'dr' '' 1.200000000E-01 []}';

DP1FH= {'dr' '' 7.500000000E-02 []}';
DP1SH= {'dr' '' 7.500000000E-02 []}';

DP2FH= {'dr' '' 7.500000000E-02 []}';
DP2SH= {'dr' '' 7.500000000E-02 []}';

DP3FH= {'dr' '' 1.200000000E-01 []}';
DP3SH= {'dr' '' 1.200000000E-01 []}';

DP4FH= {'dr' '' 5.000000000E-02 []}';
DP4SH= {'dr' '' 5.000000000E-02 []}';

DP5FH= {'dr' '' 5.000000000E-02 []}';
DP5SH= {'dr' '' 5.000000000E-02 []}';

DP6FH= {'dr' '' 5.000000000E-02 []}';
DP6SH= {'dr' '' 5.000000000E-02 []}';

DS1FH= {'dr' '' 1.000000000E-01 []}';
DS1SH= {'dr' '' 1.000000000E-01 []}';

DVALV= {'dr' '' 7.000000000E-02 []}';
DAM= {'dr' '' 7.040000000E-01 []}';
%======================================================================
% Corrector
% ('cr')
%======================================================================

CRR01= {'cr' 'CRR01' 0 []}';
CRR02= {'cr' 'CRR02' 0 []}';
CRR03= {'cr' 'CRR03' 0 []}';
CRR04= {'cr' 'CRR04' 0 []}';%four corrector at each acc tube.

%======================================================================
% Quadrupoles
% ('qu')
%======================================================================
Q01= {'qu' 'Q01' 5.000000000E-02 0}';
Q02= {'qu' 'Q02' 5.000000000E-02 -0}';
Q03= {'qu' 'Q03' 5.000000000E-02 0}';
Q04= {'qu' 'Q04' 5.000000000E-02 -0}';
Q05= {'qu' 'Q05' 5.000000000E-02 -16.76692953213907}';
Q06= {'qu' 'Q06' 5.000000000E-02 16.04720112677235}';
Q07= {'qu' 'Q07' 5.000000000E-02 -17.17501848517983}';
Q08= {'qu' 'Q08' 5.000000000E-02 11.34177574073752}';
Q09= {'qu' 'Q09' 5.000000000E-02 18.76128405177444}';
Q10= {'qu' 'Q10' 5.000000000E-02 -18.44206947317775}';



PSTN1= {'mo' 'PSTN1' 0 []}';
PSTN2= {'mo' 'PSTN2' 0 []}';

%======================================================================
% Beam Position Monitor(BPM)
% ('mo')
%======================================================================
BPM01= {'mo' 'BPM01' 0 []}';
BPM02= {'mo' 'BPM02' 0 []}';
BPM03= {'mo' 'BPM03' 0 []}';
PRL1= {'mo' 'PRL1' 0 []}';
PRL2= {'mo' 'PRL2' 0 []}';
PRL3= {'mo' 'PRL3' 0 []}';
PRL4= {'mo' 'PRL4' 0 []}';
PRL5= {'mo' 'PRL5' 0 []}';
PRL6= {'mo' 'PRL6' 0 []}';
PRL7= {'mo' 'PRL7' 0 []}';


%======================================================================

A1=[A1i,repmat(A1p,1,3),CRR01,repmat(A1p,1,15),A1e];
A2=[A2i,repmat(A2p,1,3),CRR02,repmat(A2p,1,15),A2e];
A3=[A3i,repmat(A3p,1,3),CRR03,repmat(A3p,1,15),A3e];
A4=[A4i,repmat(A4p,1,3),CRR04,repmat(A4p,1,15),A4e];

bi2s=[A2i,DBLL2,DQD1,Q01,DQD2,Q02,DBPM2,DBdm,DP2FH,DP2SH,DBLL2];
bi2b=[DBLL2,DQD1,Q01,DQD2,Q02,DBPM2,...
          BPM02,DBD,B0,DBLL3,D2,DBD,...
          DS1FH,DS1SH,DBD,Q03,DQD2,...
          Q04,D3,DBLL4,DP3FH,DP3SH]; 


doub1=[DQD3 ,Q05,DQD2 ,Q06,DQD3];
doub2=[DQD3 ,Q07,DQD2 ,Q08,DQD3];
trip3=[DQD1 ,Q09,DQD2 ,Q10,DQD2 ,Q09,DQD1];

chi=[DBLL2,doub1,DP4FH,PRL3,DP4SH,DBLL5,DBD,...
        B11,DB11 ,B12,DB12,PRL4,DB13,...
        B13,DB14 ,B14,DBD,DBLL5,doub2 ,...
        DP5FH,PRL5,DP5SH,DBLL2,PSTN1];

bl=[A1,bi2s,PRL1,A2,...
        chi,A3,DBLL1,A4,...
        DBLL2,trip3,DBPM3,BPM03,DICT ,DBLL3 ,...
        DVALV,D1,DAM,PRL7,PSTN2];

switch region
	case 'sduvlinac'
        beamline = bl;
    otherwise
        beamline = [];
        disp('Please choose beamline%');
end
