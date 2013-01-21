function [BDES, iMain, iTrim] = model_energyBX3trim(energy)

par=[ 0.000134343891326 -0.005028408091501  0.071497708687392 ...
     -0.451855133746735 17.674019737022437 -1.431271574431690]; % BDES to I polynomial for BYDs

iMain=max(0,polyval(par,energy));

p1 = [-9.299675E-1 1.712876E+1];      % BDES to I polynomial for BX31 (A/(GeV/c)^n)
p2 = [-9.746283E-1 1.706508E+1];      % BDES to I polynomial for BX32 (A/(GeV/c)^n)
p3 = [-9.600769E-1 1.710969E+1];      % BDES to I polynomial for BX35 (A/(GeV/c)^n)
p4 = [-1.051428    1.713753E+1];      % BDES to I polynomial for BX36 (A/(GeV/c)^n)
ptrim = 0.6;                          % BX3 BTRM linear polynomial coeff. (N_main/N_trim)

iBX(1,1)=polyval(p1([2 1]),energy);
iBX(2,1)=polyval(p2([2 1]),energy);
iBX(3,1)=polyval(p3([2 1]),energy);
iBX(4,1)=polyval(p4([2 1]),energy);

BDES=iBX-iMain;

iTrim = BDES*ptrim;   % trim current (trim-coil Amperes) to get field in BX31,2,3,4 exact for this BYD energy (A)
