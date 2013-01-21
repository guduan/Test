clear all;
clc;
LHang=5.72;
LHL12=0.12;
L1pha=-34.5;
L1volt=54.1642;
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

% global LCAV parameters
SbandF = 2856;    %rf frequency (MHz)
XbandF = 11424;
CbandF = 5712;
energy=4;

%Q1,D1,BPM01,B1BC1,AS1o10L1,CRR01,TDS01)
Q1= {'qu' 'Q1' 0.1 2.6}';
D1= {'dr' '' 0.1 []}';
BPM01= {'mo' 'BPM01' 0 []}';
B1BC1= {'be' 'B1BC1' 0.2*BC1ang/sin(BC1ang) [BC1ang  1.5e-02 0  BC1ang  0.5 0.5 0]}';
AS1o10L1= {'lc' 'AS1o10L1' 2.974132/10 [SbandF L1volt/10 (L1pha+90)*pi/180 energy]}';
CRR01= {'mo' ',CRR01' 0 []}';
TDS01= {'tc' 'TDS01' 1.005603 [0 0]}';
LM={'un' 'LM' 0.55 [2.2566e-05 0.055]}';
lineAll=[Q1,D1,BPM01,B1BC1,AS1o10L1,CRR01,TDS01,LM]';
for n=1:8
    R(:,:,n)=model_rMatElement(lineAll{n,[1 3 4]});
end











