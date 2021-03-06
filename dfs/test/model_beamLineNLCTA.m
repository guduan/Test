function [beamLine, MODL76, MODL77, MODL78] = model_beamLineNLCTA()
%MODEL_BEAMLINENLCTA
% BEAMLINE = MODEL_BEAMLINENLCTA() Returns beam line description list for NLCTA.

% Features:

% Input arguments: none

% Output arguments:
%    BEAMLINE: Cell array of beam line information for NLCTA

% Compatibility: Version 7 and higher
% Called functions: none

% Author  : Jeff Rzepiela, SLAC
% Modified: Mark Woodley, SLAC (April 21 2011)

% ------------------------------------------------------------------------------

% ==============================================================================
% global parameters
% ------------------------------------------------------------------------------
  IN2M=0.0254;     %inches to meters
  RADDEG=2*pi/360; %degrees to radians
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
G76= 55/(2*0.918435); %MeV/m ... 5 MeV -> 60 MeV

ACCL380a	=	{	'lc'	'ACCL380a'	0.258075	[11424 0.258075*G76 0]	}';
ACCL380b	=	{	'lc'	'ACCL380b'	0.4318	[11424 0.4318*G76 0]	}';
ACCL380c	=	{	'lc'	'ACCL380c'	0.22856	[11424 0.22856*G76 0]	}';
ACCL430a	=	{	'lc'	'ACCL430a'	0.243571	[11424 0.243571*G76 0]	}';
ACCL430b	=	{	'lc'	'ACCL430b'	0.4318	[11424 0.4318*G76 0]	}';
ACCL430c	=	{	'lc'	'ACCL430c'	0.243064	[11424 0.243064*G76 0]	}';
K821260T	=	{	'lc'	'K821260T'	0.8	[11424 60 0]}';
% ==============================================================================
% TCAVs
% ------------------------------------------------------------------------------
LT11= 6.557*IN2M;
LT27= 12.068*IN2M;

TCAVD11h	=	{	'tc'	'TCAVD11h'	LT11/2	[0 0]	}';
TCAVD27h	=	{	'tc'	'TCAVD27h'	LT27/2	[0 0]	}';
% ==============================================================================
% Bends
% ------------------------------------------------------------------------------
LB77= 0.2;
AB77= 9.559*RADDEG;
GB77= 1.126*IN2M;

ZBS= (38.5+3.5)*IN2M;    %Lpole+gap
ABS= -30.0*RADDEG;       %30 degree bend left
SNC= sin(ABS/2)/(ABS/2); %sinc(theta/2) ... yawed bend
LBS= ZBS/SNC;            %path length
GBS= 3.5*IN2M;           %gap height
VBS= LBS*tan(ABS/2)/ABS; %vertex length

BP78001= (6.34*RADDEG)/0.112;
ZB0= 0.112;        %on-axis effective length
GB0= (0.6*IN2M)/2; %half gap height
ZD0= 0.149922;     %outer bend-to-bend Z distance <*0.15*>

AB0= BP78001*ZB0;
AB0h= AB0/2;
AB0h_2= AB0h*AB0h;
AB0h_4= AB0h_2*AB0h_2;
AB0h_6= AB0h_4*AB0h_2;
SINCAB0h= (1)-AB0h_2/(6)+AB0h_4/(120)-AB0h_6/(5040); %~sin(x)/x
LB0h= (ZB0/2)/SINCAB0h;
AB0_2= AB0*AB0;
AB0_4= AB0_2*AB0_2;
AB0_6= AB0_4*AB0_2;
COSAB0= (1)-AB0_2/(2)+AB0_4/(24)-AB0_6/(720); %~cos(x)
LD0= ZD0/COSAB0;

BP78002= 0.08052/0.112;
ZB1= 0.112;        %on-axis effective length
GB1= (0.6*IN2M)/2; %half gap height
ZD1= 0.300107;     %outer bend-to-bend Z distance <*0.3*>

AB1= BP78002*ZB1;
AB1h= AB1/2;
AB1h_2= AB1h*AB1h;
AB1h_4= AB1h_2*AB1h_2;
AB1h_6= AB1h_4*AB1h_2;
SINCAB1h= (1)-AB1h_2/(6)+AB1h_4/(120)-AB1h_6/(5040); %~sin(x)/x
LB1h= (ZB1/2)/SINCAB1h;
AB1_2= AB1*AB1;
AB1_4= AB1_2*AB1_2;
AB1_6= AB1_4*AB1_2;
COSAB1= (1)-AB1_2/(2)+AB1_4/(24)-AB1_6/(720); %~cos(x)
LD1= ZD1/COSAB1;

BP78003= 0.06081/0.112;
ZB2= 0.112;        %on-axis effective length
GB2= (0.6*IN2M)/2; %half gap height
ZD2= 0.300032;     %outer bend-to-bend Z distance <*0.3*>
AB2= BP78003*ZB2;
AB2h= AB2/2;
AB2h_2= AB2h*AB2h;
AB2h_4= AB2h_2*AB2h_2;
AB2h_6= AB2h_4*AB2h_2;
SINCAB2h= (1)-AB2h_2/(6)+AB2h_4/(120)-AB2h_6/(5040); %~sin(x)/x
LB2h= (ZB2/2)/SINCAB2h;
AB2_2= AB2*AB2;
AB2_4= AB2_2*AB2_2;
AB2_6= AB2_4*AB2_2;
COSAB2= (1)-AB2_2/(2)+AB2_4/(24)-AB2_6/(720); %~cos(x)
LD2= ZD2/COSAB2;

B810610a	=	{	'be'	'B810610'	LB77/2	[AB77/2 GB77/2 AB77/2 0 0.5 0 0]	}';
B810610b	=	{	'be'	'B810610'	LB77/2	[AB77/2 GB77/2 0 AB77/2 0 0.5 0]	}';
B810690a	=	{	'be'	'B810690'	LB77/2	[-AB77/2 GB77/2 -AB77/2 0 0.5 0 0]	}';
B810690b	=	{	'be'	'B810690'	LB77/2	[-AB77/2 GB77/2 0 -AB77/2 0 0.5 0]	}';
B810910a	=	{	'be'	'B810910'	LB77/2	[-AB77/2 GB77/2 -AB77/2 0 0.5 0 0]	}';
B810910b	=	{	'be'	'B810910'	LB77/2	[-AB77/2 GB77/2 0 -AB77/2 0 0.5 0]	}';
B810990a	=	{	'be'	'B810990'	LB77/2	[AB77/2 GB77/2 AB77/2 0 0.5 0 0]	}';
B810990b	=	{	'be'	'B810990'	LB77/2	[AB77/2 GB77/2 0 AB77/2 0 0.5 0]	}';
B812110a	=	{	'be'	'B812110'	LBS/2	[ABS/2 GBS/2 ABS/2 0 0.5 0 0]	}';
B812110b	=	{	'be'	'B812110'	LBS/2	[ABS/2 GBS/2 0 ABS/2 0 0.5 0]	}';
B821590a	=	{	'be'	'B821590'	LB0h	[-AB0h GB0 -AB0h 0 0.5 0 0]	}';
B821590b	=	{	'be'	'B821590'	LB0h	[-AB0h GB0 0 -AB0h 0 0.5 0]	}';
B821600a	=	{	'be'	'B821600'	LB0h	[AB0h GB0 AB0h 0 0.5 0 0]	}';
B821600b	=	{	'be'	'B821600'	LB0h	[AB0h GB0 0 AB0h 0 0.5 0]	}';
B821615a	=	{	'be'	'B821615'	LB0h	[AB0h GB0 AB0h 0 0.5 0 0]	}';
B821615b	=	{	'be'	'B821615'	LB0h	[AB0h GB0 0 AB0h 0 0.5 0]	}';
B821625a	=	{	'be'	'B821625'	LB0h	[-AB0h GB0 -AB0h 0 0.5 0 0]	}';
B821625b	=	{	'be'	'B821625'	LB0h	[-AB0h GB0 0 -AB0h 0 0.5 0]	}';
B821730a	=	{	'be'	'B821730'	LB1h	[-AB1h GB1 -AB1h 0 0.5 0 0]	}';
B821730b	=	{	'be'	'B821730'	LB1h	[-AB1h GB1 0 -AB1h 0 0.5 0]	}';
B821745a	=	{	'be'	'B821745'	LB1h	[AB1h GB1 AB1h 0 0.5 0 0]	}';
B821745b	=	{	'be'	'B821745'	LB1h	[AB1h GB1 0 AB1h 0 0.5 0]	}';
B821760a	=	{	'be'	'B821760'	LB1h	[AB1h GB1 AB1h 0 0.5 0 0]	}';
B821760b	=	{	'be'	'B821760'	LB1h	[AB1h GB1 0 AB1h 0 0.5 0]	}';
B821775a	=	{	'be'	'B821775'	LB1h	[-AB1h GB1 -AB1h 0 0.5 0 0]	}';
B821775b	=	{	'be'	'B821775'	LB1h	[-AB1h GB1 0 -AB1h 0 0.5 0]	}';
B821870a	=	{	'be'	'B821870'	LB2h	[-AB2h GB2 -AB2h 0 0.5 0 0]	}';
B821870b	=	{	'be'	'B821870'	LB2h	[-AB2h GB2 0 -AB2h 0 0.5 0]	}';
B821885a	=	{	'be'	'B821885'	LB2h	[AB2h GB2 AB2h 0 0.5 0 0]	}';
B821885b	=	{	'be'	'B821885'	LB2h	[AB2h GB2 0 AB2h 0 0.5 0]	}';
B821900a	=	{	'be'	'B821900'	LB2h	[AB2h GB2 AB2h 0 0.5 0 0]	}';
B821900b	=	{	'be'	'B821900'	LB2h	[AB2h GB2 0 AB2h 0 0.5 0]	}';
B821915a	=	{	'be'	'B821915'	LB2h	[-AB2h GB2 -AB2h 0 0.5 0 0]	}';
B821915b	=	{	'be'	'B821915'	LB2h	[-AB2h GB2 0 -AB2h 0 0.5 0]	}';
% ==============================================================================
% DRIFs
% ------------------------------------------------------------------------------
LQ78C= 2.75*IN2M;

CH01	=	{	'dr'	''	0.249	[]	}';
CH02	=	{	'dr'	''	0.153	[]	}';
CH03	=	{	'dr'	''	0.153	[]	}';
CH04	=	{	'dr'	''	0.242	[]	}';
CH05	=	{	'dr'	''	0.234	[]	}';
CH06	=	{	'dr'	''	0.264	[]	}';
CH07	=	{	'dr'	''	0.21	[]	}';
CH08a	=	{	'dr'	''	0.068	[]	}';
CH08b	=	{	'dr'	''	0.167	[]	}';
CH08c	=	{	'dr'	''	0.09	[]	}';
CH08d	=	{	'dr'	''	0.101	[]	}';
CH09	=	{	'dr'	''	0.133	[]	}';
CH10a	=	{	'dr'	''	0.241	[]	}';
CH10b	=	{	'dr'	''	0.385	[]	}';
CH11	=	{	'dr'	''	0.212	[]	}';
CH12a	=	{	'dr'	''	0.122	[]	}';
CH12b	=	{	'dr'	''	0.139	[]	}';
CH13	=	{	'dr'	''	0.242	[]	}';
CH14	=	{	'dr'	''	0.249	[]	}';
CH15	=	{	'dr'	''	0.153	[]	}';
CH16	=	{	'dr'	''	0.153	[]	}';
CH17	=	{	'dr'	''	0.242	[]	}';
CM02a	=	{	'dr'	''	0.228	[]	}';
CM02b	=	{	'dr'	''	0.09	[]	}';
CM02c	=	{	'dr'	''	0.246	[]	}';
CM03	=	{	'dr'	''	0.322	[]	}';
CM04a	=	{	'dr'	''	0.171	[]	}';
CM04b	=	{	'dr'	''	0.09	[]	}';
CM04c	=	{	'dr'	''	0.206	[]	}';
CM05	=	{	'dr'	''	0.266	[]	}';
CM06a	=	{	'dr'	''	0.109	[]	}';
CM06b	=	{	'dr'	''	0.139	[]	}';
CM07	=	{	'dr'	''	0.107	[]	}';
CM08a	=	{	'dr'	''	0.207	[]	}';
CM08b	=	{	'dr'	''	0.144	[]	}';
DE00a	=	{	'dr'	''	1.239035	[]	}';
DE00b	=	{	'dr'	''	0.085	[]	}';
DE01	=	{	'dr'	''	0.399962	[]	}';
DE02a	=	{	'dr'	''	0.203425	[]	}';
DE02b	=	{	'dr'	''	0.095631	[]	}';
DE02c	=	{	'dr'	''	0.166218	[]	}';
DE02d	=	{	'dr'	''	0.234769	[]	}';
DE03a	=	{	'dr'	''	0.202917	[]	}';
DE03b	=	{	'dr'	''	0.098806	[]	}';
DE03c	=	{	'dr'	''	0.223577	[]	}';
DE04	=	{	'dr'	''	LD0	[]	}';
DE05a	=	{	'dr'	''	0.100133	[]	}';
DE05b	=	{	'dr'	''	0.100109	[]	}';
DE06	=	{	'dr'	''	LD0	[]	}';
DE07a	=	{	'dr'	''	0.184594	[]	}';
DE07b	=	{	'dr'	''	0.09525	[]	}';
DE07c	=	{	'dr'	''	0.157447	[]	}';
DE08a	=	{	'dr'	''	0.49	[]	}';
DE08b	=	{	'dr'	''	0.141	[]	}';
DE09a	=	{	'dr'	''	0.138009	[]	}';
DE09b	=	{	'dr'	''	0.152	[]	}';
DE09c	=	{	'dr'	''	0.102	[]	}';
DE09d	=	{	'dr'	''	0.094	[]	}';
DE09e	=	{	'dr'	''	0.177	[]	}';
DE10	=	{	'dr'	''	0.178028	[]	}';
DE11a	=	{	'dr'	''	(LD1-LQ78C)/2-0.000026	[]	}';
DE11b	=	{	'dr'	''	(LD1-LQ78C)/2+0.000026	[]	}';
DE12a	=	{	'dr'	''	0.109989	[]	}';
DE12b	=	{	'dr'	''	0.109989	[]	}';
DE13a	=	{	'dr'	''	(LD1-LQ78C)/2+0.000026	[]	}';
DE13b	=	{	'dr'	''	(LD1-LQ78C)/2-0.000026	[]	}';
DE14	=	{	'dr'	''	0.178027	[]	}';
DE15a	=	{	'dr'	''	0.144	[]	}';
DE15b	=	{	'dr'	''	0.133	[]	}';
DE15c	=	{	'dr'	''	0.158	[]	}';
DE16a	=	{	'dr'	''	0.233984	[]	}';
DE16b	=	{	'dr'	''	0.124	[]	}';
DE16c	=	{	'dr'	''	0.102	[]	}';
DE16d	=	{	'dr'	''	0.179	[]	}';
DE17	=	{	'dr'	''	0.177748	[]	}';
DE18a	=	{	'dr'	''	(LD2-LQ78C)/2-0.00244	[]	}';
DE18b	=	{	'dr'	''	(LD2-LQ78C)/2+0.00244	[]	}';
DE19a	=	{	'dr'	''	0.110269	[]	}';
DE19b	=	{	'dr'	''	0.110243	[]	}';
DE20a	=	{	'dr'	''	(LD2-LQ78C)/2+0.002567	[]	}';
DE20b	=	{	'dr'	''	(LD2-LQ78C)/2-0.002567	[]	}';
DE21a	=	{	'dr'	''	0.112452	[]	}';
DE21b	=	{	'dr'	''	0.10033	[]	}';
DE21c	=	{	'dr'	''	0.235988	[]	}';
DE22a	=	{	'dr'	''	0.208	[]	}';
DE22b	=	{	'dr'	''	0.098	[]	}';
DE22c	=	{	'dr'	''	0.305	[]	}';
DE22d	=	{	'dr'	''	0.478293-LT27	[]	}';
DE22e	=	{	'dr'	''	0.404	[]	}';
DE22f	=	{	'dr'	''	0.264	[]	}';
DE23a	=	{	'dr'	''	0.265	[]	}';
DE23b	=	{	'dr'	''	0.138893	[]	}';
DE23c	=	{	'dr'	''	0.148	[]	}';
DE23d	=	{	'dr'	''	0.259	[]	}';
DE24a	=	{	'dr'	''	0.541	[]	}';
DE24b	=	{	'dr'	''	0.120260339659	[]	}';
DE25a	=	{	'dr'	''	0.59435268537	[]	}';
DE25b	=	{	'dr'	''	0.425071	[]	}';
DE25c	=	{	'dr'	''	1.44588	[]	}';
DE25d	=	{	'dr'	''	1.04071	[]	}';
DM01a	=	{	'dr'	''	0.2	[]	}';
DM01b	=	{	'dr'	''	0.11	[]	}';
DM02	=	{	'dr'	''	0.079	[]	}';
DM03	=	{	'dr'	''	0.3422	[]	}';
DM04a	=	{	'dr'	''	0.204	[]	}';
DM04b	=	{	'dr'	''	0.2065	[]	}';
DM05	=	{	'dr'	''	0.1537	[]	}';
DM06	=	{	'dr'	''	0.1283	[]	}';
DM07	=	{	'dr'	''	0.1362	[]	}';
DRI76001	=	{	'dr'	''	0.191048	[]	}';
DRI76002	=	{	'dr'	''	0.080315	[]	}';
DRI76003	=	{	'dr'	''	0.511733	[]	}';
DRI76004	=	{	'dr'	''	0.096749	[]	}';
DRI76005	=	{	'dr'	''	0.067589	[]	}';
DRI76006	=	{	'dr'	''	0.179187	[]	}';
DRI76007	=	{	'dr'	''	0.191269	[]	}';
DN01a	=	{	'dr'	''	2.28161-LT11	[]	}';
DN01b	=	{	'dr'	''	0.053	[]	}';
DN01c	=	{	'dr'	''	0.636	[]	}';
DN02a	=	{	'dr'	''	0.192	[]	}';
DN02b	=	{	'dr'	''	0.19	[]	}';
DN02c	=	{	'dr'	''	1.21122	[]	}';
DN03	=	{	'dr'	''	2.39323	[]	}';
DVTX	=	{	'dr'	''	VBS	[]	}';
DE26a	=	{	'dr'	''	0.864509776428	[]	}';
DE26b	=	{	'dr'	''	1.37795	[]	}';
DE26c	=	{	'dr'	''	0.527304	[]	}';
% ==============================================================================
% Marks
% ------------------------------------------------------------------------------
DBMARK76	=	{	'mo'	'DBMARK76'	0	[]	}';
DBMARK77	=	{	'mo'	'DBMARK77'	0	[]	}';
DBMARK78	=	{	'mo'	'DBMARK78'	0	[]	}';
FARC2195	=	{	'mo'	'FARC2195'	0	[]	}';
ECHO	=	{	'mo'	'ECHO'	0	[]	}';
MECHO	=	{	'mo'	'MECHO'	0	[]	}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
M810408T	=	{	'mo'	'M810408T'	0	[]	}';
M810409T	=	{	'mo'	'M810409T'	0	[]	}';
M810434T	=	{	'mo'	'M810434T'	0	[]	}';
M810435T	=	{	'mo'	'M810435T'	0	[]	}';
M810480T	=	{	'mo'	'M810480T'	0	[]	}';
M810481T	=	{	'mo'	'M810481T'	0	[]	}';
M810530T	=	{	'mo'	'M810530T'	0	[]	}';
M810531T	=	{	'mo'	'M810531T'	0	[]	}';
M810560T	=	{	'mo'	'M810560T'	0	[]	}';
M810561T	=	{	'mo'	'M810561T'	0	[]	}';
M810575T	=	{	'mo'	'M810575T'	0	[]	}';
M810576T	=	{	'mo'	'M810576T'	0	[]	}';
M810590T	=	{	'mo'	'M810590T'	0	[]	}';
M810591T	=	{	'mo'	'M810591T'	0	[]	}';
M810630T	=	{	'mo'	'M810630T'	0	[]	}';
M810631T	=	{	'mo'	'M810631T'	0	[]	}';
M810650T	=	{	'mo'	'M810650T'	0	[]	}';
M810651T	=	{	'mo'	'M810651T'	0	[]	}';
M810670T	=	{	'mo'	'M810670T'	0	[]	}';
M810671T	=	{	'mo'	'M810671T'	0	[]	}';
M810710T	=	{	'mo'	'M810710T'	0	[]	}';
M810711T	=	{	'mo'	'M810711T'	0	[]	}';
M810730T	=	{	'mo'	'M810730T'	0	[]	}';
M810731T	=	{	'mo'	'M810731T'	0	[]	}';
M810750T	=	{	'mo'	'M810750T'	0	[]	}';
M810751T	=	{	'mo'	'M810751T'	0	[]	}';
M810850T	=	{	'mo'	'M810850T'	0	[]	}';
M810851T	=	{	'mo'	'M810851T'	0	[]	}';
M810870T	=	{	'mo'	'M810870T'	0	[]	}';
M810871T	=	{	'mo'	'M810871T'	0	[]	}';
M810890T	=	{	'mo'	'M810890T'	0	[]	}';
M810891T	=	{	'mo'	'M810891T'	0	[]	}';
M810930T	=	{	'mo'	'M810930T'	0	[]	}';
M810931T	=	{	'mo'	'M810931T'	0	[]	}';
M810950T	=	{	'mo'	'M810950T'	0	[]	}';
M810951T	=	{	'mo'	'M810951T'	0	[]	}';
M810970T	=	{	'mo'	'M810970T'	0	[]	}';
M810971T	=	{	'mo'	'M810971T'	0	[]	}';
M811030T	=	{	'mo'	'M811030T'	0	[]	}';
M811031T	=	{	'mo'	'M811031T'	0	[]	}';
M811070T	=	{	'mo'	'M811070T'	0	[]	}';
M811071T	=	{	'mo'	'M811071T'	0	[]	}';
M811110T	=	{	'mo'	'M811110T'	0	[]	}';
M811111T	=	{	'mo'	'M811111T'	0	[]	}';
M821130T	=	{	'mo'	'M821130T'	0	[]	}';
M821131T	=	{	'mo'	'M821131T'	0	[]	}';
M821250T	=	{	'mo'	'M821250T'	0	[]	}';
M821251T	=	{	'mo'	'M821251T'	0	[]	}';
M821350T	=	{	'mo'	'M821350T'	0	[]	}';
M821351T	=	{	'mo'	'M821351T'	0	[]	}';
M821450T	=	{	'mo'	'M821450T'	0	[]	}';
M821451T	=	{	'mo'	'M821451T'	0	[]	}';
M821510T	=	{	'mo'	'M821510T'	0	[]	}';
M821511T	=	{	'mo'	'M821511T'	0	[]	}';
M821530T	=	{	'mo'	'M821530T'	0	[]	}';
M821531T	=	{	'mo'	'M821531T'	0	[]	}';
M821565T	=	{	'mo'	'M821565T'	0	[]	}';
M821566T	=	{	'mo'	'M821566T'	0	[]	}';
M821650T	=	{	'mo'	'M821650T'	0	[]	}';
M821651T	=	{	'mo'	'M821651T'	0	[]	}';
M821720T	=	{	'mo'	'M821720T'	0	[]	}';
M821721T	=	{	'mo'	'M821721T'	0	[]	}';
M821790T	=	{	'mo'	'M821790T'	0	[]	}';
M821860T	=	{	'mo'	'M821860T'	0	[]	}';
M821861T	=	{	'mo'	'M821861T'	0	[]	}';
M821940T	=	{	'mo'	'M821940T'	0	[]	}';
M821941T	=	{	'mo'	'M821941T'	0	[]	}';
M822020T	=	{	'mo'	'M822020T'	0	[]	}';
M822021T	=	{	'mo'	'M822021T'	0	[]	}';
M822070T	=	{	'mo'	'M822070T'	0	[]	}';
M822071T	=	{	'mo'	'M822071T'	0	[]	}';
M822220T	=	{	'mo'	'M822220T'	0	[]	}';
BPMS2120	=	{	'mo'	'BPMS2120'	0	[]	}';
% ==============================================================================
% PROFs
% ------------------------------------------------------------------------------
P810430T	=	{	'mo'	'P810430T'	0	[]	}';
P810505T	=	{	'mo'	'P810505T'	0	[]	}';
P810585T	=	{	'mo'	'P810585T'	0	[]	}';
P810595T	=	{	'mo'	'P810595T'	0	[]	}';
P810770T	=	{	'mo'	'P810770T'	0	[]	}';
P810790T	=	{	'mo'	'P810790T'	0	[]	}';
P810800T	=	{	'mo'	'P810800T'	0	[]	}';
P811015T	=	{	'mo'	'P811015T'	0	[]	}';
P811120T	=	{	'mo'	'P811120T'	0	[]	}';
PA51135T	=	{	'mo'	'PA51135T'	0	[]	}';
P811210T	=	{	'mo'	'P811210T'	0	[]	}';
P811260T	=	{	'mo'	'P811260T'	0	[]	}';
P811550T	=	{	'mo'	'P811550T'	0	[]	}';
P811610T	=	{	'mo'	'P811610T'	0	[]	}';
P811665T	=	{	'mo'	'P811665T'	0	[]	}';
P811700T	=	{	'mo'	'P811700T'	0	[]	}';
P811705T	=	{	'mo'	'P811705T'	0	[]	}';
P811755T	=	{	'mo'	'P811755T'	0	[]	}';
P811805T	=	{	'mo'	'P811805T'	0	[]	}';
P811810T	=	{	'mo'	'P811810T'	0	[]	}';
P811845T	=	{	'mo'	'P811845T'	0	[]	}';
P811895T	=	{	'mo'	'P811895T'	0	[]	}';
P811930T	=	{	'mo'	'P811930T'	0	[]	}';
P811995T	=	{	'mo'	'P811995T'	0	[]	}'; %1975
P812055T	=	{	'mo'	'P812055T'	0	[]	}';
P812250T	=	{	'mo'	'P812250T'	0	[]	}';
P812290T	=	{	'mo'	'P812290T'	0	[]	}';
P812190T	=	{	'mo'	'P812290T'	0	[]	}';
% ==============================================================================
% Quads
% ------------------------------------------------------------------------------
LQ77= 0.126;
LQ78a= 0.126;
LQ78b= 0.171;
LQ78c= 2.75*IN2M;
LQ78d= 0.1306;

KQF0480=7.878543036512;
KQD0530=-3.046589757716;
KQF0560=5.926712899305;
KQD0575=-12.497280793624;
KQF0590=9.469802131827;
KQD0630=0.0;
KQF0650=0.0;
KQD0670=0.0;
KQF0710=0.0;
KQD0730=0.0;
KQF0750=0.0;
KQF0850=0.0;
KQD0870=0.0;
KQF0890=0.0;
KQD0930=0.0;
KQF0950=0.0;
KQD0970=0.0;
KQF1030=8.80890895967;
KQD1070=-12.590746560145;
KQF1110=7.657830169595;
KQD1130=0.0;
KQF1250=4.210428382236;
KQD1350=-3.831726722164;
KQF1450=2.266317563058;
KQD1510=0.0;
KQF1530=0.0;
KQD1565=-0.824781663016;
KQF1650=3.16355677783;
KQD1720=-4.103973958718;
KQT1740=0.0;
KQT1770=0.0;
KQF1790=5.033130799706;
KQD1860=-4.117494214813;
KQT1880=0.0;
KQT1910=0.0;
KQF1940=2.308077889025;
KQD2020=-8.902116457701;
KQF2050=0.0;
KQF2070=4.903358645248;

Q810480T	=	{	'qu'	'Q810480T'	LQ77/2	KQF0480	}';
Q810530T	=	{	'qu'	'Q810530T'	LQ77/2	KQD0530	}';
Q810560T	=	{	'qu'	'Q810560T'	LQ77/2	KQF0560	}';
Q810575T	=	{	'qu'	'Q810575T'	LQ77/2	KQD0575	}';
Q810590T	=	{	'qu'	'Q810590T'	LQ77/2	KQF0590	}';
Q810630T	=	{	'qu'	'Q810630T'	LQ77/2	KQD0630	}';
Q810650T	=	{	'qu'	'Q810650T'	LQ77/2	KQF0650	}';
Q810670T	=	{	'qu'	'Q810670T'	LQ77/2	KQD0670	}';
Q810710T	=	{	'qu'	'Q810710T'	LQ77/2	KQF0710	}';
Q810730T	=	{	'qu'	'Q810730T'	LQ77/2	KQD0730	}';
Q810750T	=	{	'qu'	'Q810750T'	LQ77/2	KQF0750	}';
Q810850T	=	{	'qu'	'Q810850T'	LQ77/2	KQF0850	}';
Q810870T	=	{	'qu'	'Q810870T'	LQ77/2	KQD0870	}';
Q810890T	=	{	'qu'	'Q810890T'	LQ77/2	KQF0890	}';
Q810930T	=	{	'qu'	'Q810930T'	LQ77/2	KQD0930	}';
Q810950T	=	{	'qu'	'Q810950T'	LQ77/2	KQF0950	}';
Q810970T	=	{	'qu'	'Q810970T'	LQ77/2	KQD0970	}';
Q811030T	=	{	'qu'	'Q811030T'	LQ77/2	KQF1030	}';
Q811070T	=	{	'qu'	'Q811070T'	LQ77/2	KQD1070	}';
Q811110T	=	{	'qu'	'Q811110T'	LQ77/2	KQF1110	}';
Q811130T	=	{	'qu'	'Q811130T'	LQ77/2	KQD1130	}';
Q811250T	=	{	'qu'	'Q811250T'	LQ78a/2	KQF1250	}';
Q811350T	=	{	'qu'	'Q811350T'	LQ78a/2	KQD1350	}';
Q811450T	=	{	'qu'	'Q811450T'	LQ78a/2	KQF1450	}';
Q811510T	=	{	'qu'	'Q811510T'	LQ78a/2	KQD1510	}';
Q811530T	=	{	'qu'	'Q811530T'	LQ78b/2	KQF1530	}';
Q811565T	=	{	'qu'	'Q811565T'	LQ78b/2	KQD1565	}';
Q811650T	=	{	'qu'	'Q811650T'	LQ78a/2	KQF1650	}';
Q811720T	=	{	'qu'	'Q811720T'	LQ78a/2	KQD1720	}';
Q811790T	=	{	'qu'	'Q811790T'	LQ78a/2	KQT1740	}';
Q811860T	=	{	'qu'	'Q811860T'	LQ78a/2	KQT1770	}';
Q811940T	=	{	'qu'	'Q811940T'	LQ78b/2	KQF1790	}';
Q812020T	=	{	'qu'	'Q812020T'	LQ78b/2	KQD1860	}';
Q812070T	=	{	'qu'	'Q812070T'	LQ78b/2	KQT1880	}';
Q821740T	=	{	'qu'	'Q821740T'	LQ78c/2	KQT1910	}';
Q821770T	=	{	'qu'	'Q821770T'	LQ78c/2	KQF1940	}';
Q821880T	=	{	'qu'	'Q821880T'	LQ78c/2	KQD2020	}';
Q821910T	=	{	'qu'	'Q821910T'	LQ78c/2	KQF2050	}';
Q822050T	=	{	'qu'	'Q822050T'	LQ78d/2	KQF2070	}';
% ==============================================================================
% Toros
% ------------------------------------------------------------------------------
T810580T	=	{	'mo'	''	0	[]	}';
T810880T	=	{	'mo'	''	0	[]	}';
T811010T	=	{	'mo'	''	0	[]	}';
% ==============================================================================
% Unds
% ------------------------------------------------------------------------------
mc2    = 510.99906E-6;  % e- rest mass [GeV]
EP78001= 0.12;
EGAMMA= EP78001/mc2;

BU20= 0.647751605996;                 %undulator peak field (T)
LU20= 0.2;                            %undulator length (m)
NU20= 10;                             %number of undulator periods
WU20= LU20/NU20;                      %undulator period length (m)
KU20= 93.4*BU20*WU20;                 %undulator strength (1)
KQ20= 2*pi*KU20/WU20/EGAMMA/sqrt(2);  %undulator vertical focusing "K" (1/m)
LU20h= LU20/2;

BU55= 0.40343179;                     %undulator peak field (T)
LU55= 0.55;                           %undulator length (m)
NU55= 10;                             %number of undulator periods
WU55= LU55/NU55;                      %undulator period length (m)
KU55= 93.4*BU55*WU55;                 %undulator strength (1)
KQ55= 2*pi*KU55/WU55/EGAMMA/sqrt(2); %undulator vertical focusing "K" (1/m)
LU55h= LU55/2;

BU33= 0.5845211;                      %undulator peak field (T)
LU33= 0.33;                           %undulator length (m)
NU33= 10;                             %number of undulator periods
WU33= LU33/NU33;                      %undulator period length (m)
KU33= 93.4*BU33*WU33;                 %undulator strength (1)
KQ33= 2*pi*KU33/WU33/EGAMMA/sqrt(2); %undulator vertical focusing "K" (1/m)
LU33h= LU33/2;

U20h	=	{	'un'	'U20h'	LU20h	[KQ20 WU20]	}';
U33h	=	{	'un'	'U33h'	LU33h	[KQ33 WU33]	}';
U55h	=	{	'un'	'U55h'	LU55h	[KQ55 WU55]	}';
% ==============================================================================
% Wires
% ------------------------------------------------------------------------------
W811090T	=	{	'mo'	'W811090T'	0	[]	}';
W812270T	=	{	'mo'	'W812270T'	0	[]	}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
X810372T	=	{	'mo'	'X810372T'	0	[]	}';
X810391T	=	{	'mo'	'X810391T'	0	[]	}';
X810410T	=	{	'mo'	'X810410T'	0	[]	}';
X810430T	=	{	'mo'	'X810430T'	0	[]	}';
X810452T	=	{	'mo'	'X810452T'	0	[]	}';
X810470T	=	{	'mo'	'X810470T'	0	[]	}';

X810480T	=	{	'mo'	'X810480T'	0	[]	}';
X810530T	=	{	'mo'	'X810530T'	0	[]	}';
X810560T	=	{	'mo'	'X810560T'	0	[]	}';
X810575T	=	{	'mo'	'X810575T'	0	[]	}';
X810590T	=	{	'mo'	'X810590T'	0	[]	}';
X810610T	=	{	'mo'	'X810610T'	0	[]	}';
X810630T	=	{	'mo'	'X810630T'	0	[]	}';
X810650T	=	{	'mo'	'X810650T'	0	[]	}';
X810670T	=	{	'mo'	'X810670T'	0	[]	}';
X810690T	=	{	'mo'	'X810690T'	0	[]	}';
X810710T	=	{	'mo'	'X810710T'	0	[]	}';
X810730T	=	{	'mo'	'X810730T'	0	[]	}';
X810750T	=	{	'mo'	'X810750T'	0	[]	}';
X810850T	=	{	'mo'	'X810850T'	0	[]	}';
X810870T	=	{	'mo'	'X810870T'	0	[]	}';
X810890T	=	{	'mo'	'X810890T'	0	[]	}';
X810910T	=	{	'mo'	'X810910T'	0	[]	}';
X810930T	=	{	'mo'	'X810930T'	0	[]	}';
X810950T	=	{	'mo'	'X810950T'	0	[]	}';
X810970T	=	{	'mo'	'X810970T'	0	[]	}';
X810990T	=	{	'mo'	'X810990T'	0	[]	}';
X811030T	=	{	'mo'	'X811030T'	0	[]	}';
X811070T	=	{	'mo'	'X811070T'	0	[]	}';
X811110T	=	{	'mo'	'X811110T'	0	[]	}';
X811130T	=	{	'mo'	'X811130T'	0	[]	}';

X811250T	=	{	'mo'	'X811250T'	0	[]	}';
X811350T	=	{	'mo'	'X811350T'	0	[]	}';
X811450T	=	{	'mo'	'X811450T'	0	[]	}';
X811510T	=	{	'mo'	'X811510T'	0	[]	}';
X811540T	=	{	'mo'	'X811540T'	0	[]	}';
X811575T	=	{	'mo'	'X811575T'	0	[]	}';
X821635T	=	{	'mo'	'X821635T'	0	[]	}';
X811650T	=	{	'mo'	'X811650T'	0	[]	}';
X811690T	=	{	'mo'	'X811690T'	0	[]	}';
X811720T	=	{	'mo'	'X811720T'	0	[]	}';
X811790T	=	{	'mo'	'X811790T'	0	[]	}';
X821835T	=	{	'mo'	'X821835T'	0	[]	}';
X811860T	=	{	'mo'	'X811860T'	0	[]	}';
X821925T	=	{	'mo'	'X821925T'	0	[]	}';
X821950T	=	{	'mo'	'X821950T'	0	[]	}';
% ==============================================================================
% XCOLs
% ------------------------------------------------------------------------------
XCOL0495	=	{	'mo'	'XCOL0495'	0	[]	}';
XCOL0540	=	{	'mo'	'XCOL0540'	0	[]	}';
XCOL0780	=	{	'mo'	'XCOL0780'	0	[]	}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
Y810372T	=	{	'mo'	'Y810372T'	0	[]	}';
Y810391T	=	{	'mo'	'Y810391T'	0	[]	}';
Y810410T	=	{	'mo'	'Y810410T'	0	[]	}';
Y810430T	=	{	'mo'	'Y810430T'	0	[]	}';
Y810452T	=	{	'mo'	'Y810452T'	0	[]	}';
Y810470T	=	{	'mo'	'Y810470T'	0	[]	}';

Y810480T	=	{	'mo'	'Y810480T'	0	[]	}';
Y810530T	=	{	'mo'	'Y810530T'	0	[]	}';
Y810560T	=	{	'mo'	'Y810560T'	0	[]	}';
Y810575T	=	{	'mo'	'Y810575T'	0	[]	}';
Y810590T	=	{	'mo'	'Y810590T'	0	[]	}';
Y810630T	=	{	'mo'	'Y810630T'	0	[]	}';
Y810650T	=	{	'mo'	'Y810650T'	0	[]	}';
Y810670T	=	{	'mo'	'Y810670T'	0	[]	}';
Y810710T	=	{	'mo'	'Y810710T'	0	[]	}';
Y810730T	=	{	'mo'	'Y810730T'	0	[]	}';
Y810750T	=	{	'mo'	'Y810750T'	0	[]	}';
Y810850T	=	{	'mo'	'Y810850T'	0	[]	}';
Y810870T	=	{	'mo'	'Y810870T'	0	[]	}';
Y810890T	=	{	'mo'	'Y810890T'	0	[]	}';
Y810930T	=	{	'mo'	'Y810930T'	0	[]	}';
Y810950T	=	{	'mo'	'Y810950T'	0	[]	}';
Y810970T	=	{	'mo'	'Y810970T'	0	[]	}';
Y811030T	=	{	'mo'	'Y811030T'	0	[]	}';
Y811070T	=	{	'mo'	'Y811070T'	0	[]	}';
Y811110T	=	{	'mo'	'Y811110T'	0	[]	}';
Y811130T	=	{	'mo'	'Y811130T'	0	[]	}';

Y811250T	=	{	'mo'	'Y811250T'	0	[]	}';
Y811350T	=	{	'mo'	'Y811350T'	0	[]	}';
Y811450T	=	{	'mo'	'Y811450T'	0	[]	}';
Y811510T	=	{	'mo'	'Y811510T'	0	[]	}';
Y811545T	=	{	'mo'	'Y811545T'	0	[]	}';
Y811580T	=	{	'mo'	'Y811580T'	0	[]	}';
Y821640T	=	{	'mo'	'Y821640T'	0	[]	}';
Y811650T	=	{	'mo'	'Y811650T'	0	[]	}';
Y811695T	=	{	'mo'	'Y811695T'	0	[]	}';
Y811720T	=	{	'mo'	'Y811720T'	0	[]	}';
Y811790T	=	{	'mo'	'Y811790T'	0	[]	}';
Y821840T	=	{	'mo'	'Y821840T'	0	[]	}';
Y811860T	=	{	'mo'	'Y811860T'	0	[]	}';
Y821955T	=	{	'mo'	'Y821955T'	0	[]	}';
Y822050T	=	{	'mo'	'Y822050T'	0	[]	}';
Y822100T	=	{	'mo'	'Y822050T'	0	[]	}';
% ==============================================================================
% YCOLs
% ------------------------------------------------------------------------------
YCOL0495	=	{	'mo'	'YCOL0495'	0	[]	}';
YCOL0540	=	{	'mo'	'YCOL0540'	0	[]	}';
YCOL0780	=	{	'mo'	'YCOL0780'	0	[]	}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
% MODL76
% ------------------------------------------------------------------------------
ACC380=[ACCL380a,X810372T,Y810372T,ACCL380b,X810391T,Y810391T,ACCL380c];
ACC430=[ACCL430a,X810452T,Y810452T,ACCL430b,X810470T,Y810470T,ACCL430c];

MODL76=[ACC380,DRI76001,M810408T,M810409T,DRI76002,X810410T,Y810410T,DRI76003, ...
    P810430T,DRI76004,X810430T,Y810430T,DRI76005,M810434T,M810435T,DRI76006, ...
    ACC430,DRI76007, ...
    DBMARK76];
% ------------------------------------------------------------------------------
% MODL77
% ------------------------------------------------------------------------------
QF0480=[Q810480T,M810480T,M810481T,X810480T,Y810480T,Q810480T];
QD0530=[Q810530T,M810530T,M810531T,X810530T,Y810530T,Q810530T];
QF0560=[Q810560T,M810560T,M810561T,X810560T,Y810560T,Q810560T];
QD0575=[Q810575T,M810575T,M810576T,X810575T,Y810575T,Q810575T];
QF0590=[Q810590T,M810590T,M810591T,X810590T,Y810590T,Q810590T];
BR0610=[B810610a,X810610T,B810610b];
QD0630=[Q810630T,M810630T,M810631T,X810630T,Y810630T,Q810630T];
QF0650=[Q810650T,M810650T,M810651T,X810650T,Y810650T,Q810650T];
QD0670=[Q810670T,M810670T,M810671T,X810670T,Y810670T,Q810670T];
BL0690=[B810690a,X810690T,B810690b];
QF0710=[Q810710T,M810710T,M810711T,X810710T,Y810710T,Q810710T];
QD0730=[Q810730T,M810730T,M810731T,X810730T,Y810730T,Q810730T];
QF0750=[Q810750T,M810750T,M810751T,X810750T,Y810750T,Q810750T];
QF0850=[Q810850T,M810850T,M810851T,X810850T,Y810850T,Q810850T];
QD0870=[Q810870T,M810870T,M810871T,X810870T,Y810870T,Q810870T];
QF0890=[Q810890T,M810890T,M810891T,X810890T,Y810890T,Q810890T];
BL0910=[B810910a,X810910T,B810910b];
QD0930=[Q810930T,M810930T,M810931T,X810930T,Y810930T,Q810930T];
QF0950=[Q810950T,M810950T,M810951T,X810950T,Y810950T,Q810950T];
QD0970=[Q810970T,M810970T,M810971T,X810970T,Y810970T,Q810970T];
BR0990=[B810990a,X810990T,B810990b];
QF1030=[Q811030T,M811030T,M811031T,X811030T,Y811030T,Q811030T];
QD1070=[Q811070T,M811070T,M811071T,X811070T,Y811070T,Q811070T];
QF1110=[Q811110T,M811110T,M811111T,X811110T,Y811110T,Q811110T];
QD1130=[Q811130T,M821130T,M821131T,X811130T,Y811130T,Q811130T];

MODL77=[ ...
  QF0480,CM02a,YCOL0495,CM02b,XCOL0495,CM02c,P810505T,CM03, ...
  QD0530,CM04a,YCOL0540,CM04b,XCOL0540,CM04c, ...
  QF0560,CM05, ...
  QD0575,CM06a,T810580T,CM06b,P810585T,CM07, ...
  QF0590,CM08a,P810595T,CM08b, ...
  BR0610,CH01, ...
  QD0630,CH02, ...
  QF0650,CH03, ...
  QD0670,CH04, ...
  BL0690,CH05, ...
  QF0710,CH06, ...
  QD0730,CH07, ...
  QF0750,CH08a,P810770T,CH08b,YCOL0780,CH08c,XCOL0780,CH08d, ...
    CH09,P810790T,CH10a,P810800T,CH10b, ...
  QF0850,CH11, ...
  QD0870,CH12a,T810880T,CH12b, ...
  QF0890,CH13, ...
  BL0910,CH14, ...
  QD0930,CH15, ...
  QF0950,CH16, ...
  QD0970,CH17, ...
  BR0990,DM01a,T811010T,DM01b,P811015T,DM02, ...
  QF1030,DM03, ...
  QD1070,DM04a,W811090T,DM04b, ...
  QF1110,DM05,P811120T,DM06, ...
  QD1130,DM07,PA51135T, ...
  DBMARK77];
% ------------------------------------------------------------------------------
% MODL78
% ------------------------------------------------------------------------------
TCAVD11=[TCAVD11h,TCAVD11h];
QF1250=[Q811250T,M821250T,M821251T,X811250T,Y811250T,Q811250T];
QD1350=[Q811350T,M821350T,M821351T,X811350T,Y811350T,Q811350T];
QF1450=[Q811450T,M821450T,M821451T,X811450T,Y811450T,Q811450T];
QD1510=[Q811510T,M821510T,M821511T,X811510T,Y811510T,Q811510T];
QF1530=[Q811530T,M821530T,M821531T,Q811530T];
QD1565=[Q811565T,M821565T,M821566T,Q811565T];
BR1590=[B821590a,B821590b];
BL1600=[B821600a,B821600b];
BL1615=[B821615a,B821615b];
BR1625=[B821625a,B821625b];
QF1650=[Q811650T,M821650T,M821651T,X811650T,Y811650T,Q811650T];
U33=[U33h,U33h];
QD1720=[Q811720T,M821720T,M821721T,X811720T,Y811720T,Q811720T];
BR1730=[B821730a,B821730b];
QT1740=[Q821740T,Q821740T];
BL1745=[B821745a,B821745b];
BL1760=[B821760a,B821760b];
QT1770=[Q821770T,Q821770T];
BR1775=[B821775a,B821775b];
QF1790=[Q811790T,M821790T,X811790T,Y811790T,Q811790T];
U55=[U55h,U55h];
QD1860=[Q811860T,M821860T,M821861T,X811860T,Y811860T,Q811860T];
BR1870=[B821870a,B821870b];
QT1880=[Q821880T,Q821880T];
BL1885=[B821885a,B821885b];
BL1900=[B821900a,B821900b];
QT1910=[Q821910T,Q821910T];
BR1915=[B821915a,B821915b];
QF1940=[Q811940T,M821940T,M821941T,Q811940T];
U20=[U20h,U20h];
TCAVD27=[TCAVD27h,TCAVD27h];
QD2020=[Q812020T,M822020T,M822021T,Q812020T];
QF2050=[Q822050T,Q822050T];
QF2070=[Q812070T,M822070T,M822071T,Q812070T];
BL2110=[B812110a,B812110b];

MODL78a=[ ...
  DN01a,P811210T,DN01b,TCAVD11,DN01c, ...
  QF1250,DN02a,P811260T,DN02b,K821260T,DN02c, ...
  QD1350,DN03, ...
  QF1450,DE00a,ECHO];

MODL78b=[ ...
  DE00b, ...
  QD1510,DE01, ...
  QF1530,DE02a,X811540T,DE02b,Y811545T,DE02c,P811550T,DE02d, ...
  QD1565,DE03a,X811575T,DE03b,Y811580T,DE03c, ...
  BR1590,DE04, ...
  BL1600,DE05a,P811610T,DE05b, ...
  BL1615,DE06, ...
  BR1625,DE07a,X821635T,DE07b,Y821640T,DE07c,MECHO, ...
  QF1650,DE08a,P811665T,DE08b, ...
  U33,DE09a,P811700T,DE09b,P811705T,DE09c,X811690T,DE09d,Y811695T,DE09e, ...
  QD1720,DE10, ...
  BR1730,DE11a,QT1740,DE11b, ...
  BL1745,DE12a,P811755T,DE12b, ...
  BL1760,DE13a,QT1770,DE13b, ...
  BR1775,DE14, ...
  QF1790,DE15a,P811805T,DE15b,P811810T,DE15c, ...
  U55,DE16a,P811845T,DE16b,X821835T,DE16c,Y821840T,DE16d, ...
  QD1860,DE17, ...
  BR1870,DE18a,QT1880,DE18b, ...
  BL1885,DE19a,P811895T,DE19b, ...
  BL1900,DE20a,QT1910,DE20b, ...
  BR1915,DE21a,X821925T,DE21b,P811930T,DE21c, ...
  QF1940,DE22a,X821950T,DE22b,Y821955T,DE22c, ...
  U20,DE22d,P811995T,DE22e,TCAVD27,DE22f, ...
  QD2020,DE23a,Y822050T,DE23b, ...
  QF2050,DE23c,P812055T,DE23d, ...
  QF2070,DE24a,Y822100T,DE24b];

MODL78c=[ ...
  BL2110,DE25a,M822220T,DE25b,P812250T,DE25c,P812290T,DE25d, ...
  DBMARK78];

MODL78d=[ ...
  DVTX,DE26a,BPMS2120,DE26b,P812190T,DE26c,FARC2195];

MODL78=[MODL78a,MODL78b,MODL78c]; %spectrometer bend ON

SPECT0=[MODL78a,MODL78b,MODL78d]; %spectrometer bend OFF
% ==============================================================================

% NLCTA    =[MODL76, MODL77, MODL78];
NLCTA    =[MODL77, MODL78];

LINE=NLCTA;

beamLine=LINE';
MODL76=MODL76';
MODL77=MODL77';
MODL78=MODL78';
